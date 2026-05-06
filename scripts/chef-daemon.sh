#!/usr/bin/env bash
# chef-daemon.sh — autonomous chef polling daemon. Runs on the same PC as the
# worker daemon (e.g., France PC under WSL2). Uses local GCM auth (proven by
# the worker daemon). Eliminates dependence on Claude Code conversation OR
# Anthropic cloud routine for chef-side decisions.
#
# Responsibilities :
#   1. Loop every CHEF_INTERVAL_SEC (default 60 s).
#   2. Pull bsebench-async-codex.
#   3. For each phase with status=done where no CHEF_VERDICT.md exists :
#      a. Fetch the branch on target_repo.
#      b. Run fast tests + ruff check + ruff format check.
#      c. Verify commit author + no Co-Authored-By: Claude trailer + scope.
#      d. If all green : ff-merge to main, push, delete branch, write
#         CHEF_VERDICT.md = approved.
#      e. If fail : write CHEF_VERDICT.md = needs_fix with details (no
#         auto-fix-BRIEF in V1 — escalation visible in repo).
#      f. Push the verdict commit.
#   4. For each phase with status=error where no CHEF_VERDICT.md exists :
#      a. V1 behavior : write CHEF_VERDICT.md = escalated, with the SUMMARY
#         tail. User reviews via web UI on next visit.
#
# Concurrency : flock on /tmp/codex-async-chef.lock — different from the
# worker's /tmp/codex-async-worker.lock so both can run in parallel.
#
# Auth : uses the same GCM wrapper the worker uses ; ensure
# git config --global credential.helper points at it before launching.
#
# Usage (start) :
#   nohup bash scripts/chef-daemon.sh > ~/.async-chef.log 2>&1 &
#   disown
#
# Usage (stop) :
#   pkill -f chef-daemon.sh

set -uo pipefail

ASYNC_REPO="${ASYNC_REPO:-$HOME/bsebench-async-codex}"
LOCK_FILE="/tmp/codex-async-chef.lock"
INTERVAL_SEC="${CHEF_INTERVAL_SEC:-60}"
DEFAULT_TARGET_REPO_ROOT="${TARGET_REPO_ROOT:-/mnt/c/doctorat/bsebench-org}"

# ------------------------------------------------------------------ flock
exec 9>"$LOCK_FILE"
if ! flock -n 9 ; then
  exit 0
fi

# ------------------------------------------------------------------ helpers

log() {
  echo "[$(date -Iseconds)] chef: $*"
}

# Verify a phase's branch + write CHEF_VERDICT
verify_and_merge() {
  local phase_id="$1"
  local status_file="$2"
  local summary_file="$ASYNC_REPO/outbox/$phase_id/SUMMARY.md"

  local target_repo
  local target_branch
  local base_branch
  target_repo=$(jq -r '.target_repo' "$status_file")
  target_branch=$(jq -r '.target_branch' "$status_file")
  base_branch=$(jq -r '.base_branch' "$status_file")

  log "verify-and-merge $phase_id (branch $target_branch)"

  # Resolve target_repo on this PC
  local repo_dir
  repo_dir=$(eval echo "$target_repo")
  if [[ ! -d "$repo_dir/.git" ]] ; then
    write_verdict "$phase_id" "escalated" "target_repo not on this PC : $repo_dir" ""
    return
  fi

  cd "$repo_dir" || {
    write_verdict "$phase_id" "escalated" "cannot cd to $repo_dir" ""
    return
  }

  # Fetch + checkout
  if ! git fetch origin --prune --quiet ; then
    write_verdict "$phase_id" "escalated" "git fetch failed on $repo_dir" ""
    return
  fi

  # Make sure we are not already on the target branch (avoid checkout from itself).
  git checkout main --quiet 2>/dev/null || true

  if ! git checkout "$target_branch" --quiet ; then
    write_verdict "$phase_id" "escalated" "git checkout $target_branch failed (branch missing or conflicting state)" ""
    return
  fi

  # Verify commit metadata
  local author email body
  author=$(git log -1 --format=%an)
  email=$(git log -1 --format=%ae)
  body=$(git log -1 --format=%B)

  if [[ "$author" != "Oussama Akir" ]] ; then
    write_verdict "$phase_id" "needs_fix" "commit author '$author' != 'Oussama Akir'" ""
    git checkout main --quiet
    return
  fi
  if [[ "$email" != "claude@cosmocomply.com" ]] ; then
    write_verdict "$phase_id" "needs_fix" "commit email '$email' != 'claude@cosmocomply.com'" ""
    git checkout main --quiet
    return
  fi
  if echo "$body" | grep -qi 'Co-Authored-By:.*Claude' ; then
    write_verdict "$phase_id" "needs_fix" "Co-Authored-By: Claude trailer present in commit body" ""
    git checkout main --quiet
    return
  fi

  # Run gates if pyproject.toml present
  local gate_log
  gate_log=$(mktemp)
  local gates_ok=1

  if [[ -f "pyproject.toml" ]] ; then
    if ! uv run pytest -m "not slow" -v > "$gate_log" 2>&1 ; then
      gates_ok=0
      log "$phase_id pytest failed"
    fi
    if [[ "$gates_ok" -eq 1 ]] ; then
      if ! uv run ruff format --check . >> "$gate_log" 2>&1 ; then
        gates_ok=0
        log "$phase_id ruff format failed"
      fi
    fi
    if [[ "$gates_ok" -eq 1 ]] ; then
      if ! uv run ruff check . >> "$gate_log" 2>&1 ; then
        gates_ok=0
        log "$phase_id ruff check failed"
      fi
    fi
  else
    log "$phase_id no pyproject.toml — skipping gates (assume worker-side gates are authoritative)"
  fi

  local gate_tail
  gate_tail=$(tail -50 "$gate_log")
  rm -f "$gate_log"

  if [[ "$gates_ok" -eq 0 ]] ; then
    write_verdict "$phase_id" "needs_fix" "chef-side gate failure" "$gate_tail"
    git checkout main --quiet
    return
  fi

  # Gates green : merge ff to main, push, delete branch
  if ! git checkout main --quiet ; then
    write_verdict "$phase_id" "escalated" "could not checkout main for merge" ""
    return
  fi

  if ! git merge --ff-only "$target_branch" --quiet ; then
    write_verdict "$phase_id" "escalated" "ff-merge $target_branch -> main failed (non-linear ?)" ""
    return
  fi

  if ! git push origin main --quiet ; then
    write_verdict "$phase_id" "escalated" "git push origin main failed (auth ?)" ""
    return
  fi

  git branch -d "$target_branch" --quiet 2>/dev/null || true
  git push origin --delete "$target_branch" --quiet 2>/dev/null || true

  local merged_sha
  merged_sha=$(git rev-parse HEAD)
  write_verdict "$phase_id" "approved" "merged $target_branch -> main at $merged_sha" "$gate_tail"

  log "$phase_id approved + merged at $merged_sha"
}

# Write CHEF_VERDICT.md and push to async repo
write_verdict() {
  local phase_id="$1"
  local decision="$2"     # approved | needs_fix | escalated
  local summary="$3"
  local gate_evidence="${4:-}"

  cd "$ASYNC_REPO" || return
  mkdir -p "outbox/$phase_id"
  local out="outbox/$phase_id/CHEF_VERDICT.md"
  cat > "$out" <<VERDICT
# Chef verdict for $phase_id

- Decision : $decision
- Decided at : $(date -Iseconds)
- Decided by : chef-daemon (automated, France PC)

## Re-verification on chef PC

$summary

$( [[ -n "$gate_evidence" ]] && echo -e "## Gate evidence\n\n\`\`\`\n$gate_evidence\n\`\`\`" )

## Cross-references

- inbox/$phase_id/STATUS.json (worker artifact)
- outbox/$phase_id/SUMMARY.md (worker SUMMARY)
- outbox/$phase_id/run.log.tail (worker stdout tail, if non-empty)
VERDICT

  git add "$out"
  git commit -m "chore(async): chef verdict $decision on $phase_id" --quiet 2>/dev/null
  git push origin main --quiet 2>/dev/null || log "verdict push failed (will retry next tick)"
}

# Classify status=error and write escalation verdict
classify_error() {
  local phase_id="$1"
  local status_file="$2"

  cd "$ASYNC_REPO" || return
  local sum=""
  if [[ -f "outbox/$phase_id/SUMMARY.md" ]] ; then
    sum=$(tail -30 "outbox/$phase_id/SUMMARY.md")
  fi
  local log_tail=""
  if [[ -f "outbox/$phase_id/run.log.tail" ]] ; then
    log_tail=$(tail -30 "outbox/$phase_id/run.log.tail")
  fi
  write_verdict "$phase_id" "escalated" "Worker reported status=error. Manual investigation needed (see SUMMARY + run.log.tail above for context). V1 chef-daemon does not auto-fix errors." "$sum

--- run.log.tail ---
$log_tail"
}

# ------------------------------------------------------------------ main loop
log "chef-daemon start (interval ${INTERVAL_SEC}s, async_repo=$ASYNC_REPO)"

trap 'log "chef-daemon stopped (signal received)" ; exit 0' TERM INT

while true ; do
  cd "$ASYNC_REPO" || { sleep "$INTERVAL_SEC" ; continue ; }
  git fetch origin main --quiet || true
  git reset --hard origin/main --quiet || true

  for status_path in inbox/*/STATUS.json ; do
    [[ -f "$status_path" ]] || continue
    phase_id=$(basename "$(dirname "$status_path")")
    [[ -f "outbox/$phase_id/CHEF_VERDICT.md" ]] && continue

    status=$(jq -r '.status' "$status_path" 2>/dev/null || echo "unknown")
    case "$status" in
      done)
        verify_and_merge "$phase_id" "$status_path"
        ;;
      error)
        classify_error "$phase_id" "$status_path"
        ;;
      *)
        : # queued, running — leave alone
        ;;
    esac
  done

  sleep "$INTERVAL_SEC"
done
