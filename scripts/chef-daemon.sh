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

# Force line-buffered stdout/stderr so log lines appear immediately when
# the parent (worker-daemon's nohup launch, or manual nohup) doesn't pass
# through stdbuf. Self-protective : works regardless of how we were
# launched. Insurance for the 2026-05-06 bug where chef-daemon was alive
# but silent for 1h27 due to glibc block-buffering.
if command -v stdbuf >/dev/null 2>&1 ; then
  # Already in a stdbuf wrapper if our parent passed it. Otherwise this
  # exec re-launches us through stdbuf for line buffering.
  if [[ "${CHEF_STDBUF_WRAPPED:-0}" != "1" ]] ; then
    export CHEF_STDBUF_WRAPPED=1
    exec stdbuf -oL -eL bash "$0" "$@"
  fi
fi

# Earliest possible log line — confirms script execution reached this
# point. If `.async-chef.log` is empty post-launch, the issue is upstream
# of this line (file-system, disk full, fork failure).
echo "[$(date -Iseconds)] chef-daemon: BOOT entered script body (PID=$$, stdbuf_wrapped=${CHEF_STDBUF_WRAPPED:-0})"

ASYNC_REPO="${ASYNC_REPO:-$HOME/bsebench-async-codex}"
LOCK_FILE="/tmp/codex-async-chef.lock"
INTERVAL_SEC="${CHEF_INTERVAL_SEC:-60}"
DEFAULT_TARGET_REPO_ROOT="${TARGET_REPO_ROOT:-/mnt/c/doctorat/bsebench-org}"
KAIZEN_ENABLED="${KAIZEN_ENABLED:-1}"
KAIZEN_WALLCLOCK_SEC="${KAIZEN_WALLCLOCK_SEC:-180}"
STALE_GIT_LOCK_MIN="${STALE_GIT_LOCK_MIN:-15}"

# Self-respawn : capture our own script's SHA at start. If it changes after
# a git pull inside the loop, exec ourselves with the new version so patches
# take effect without manual restart.
SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_SHA_AT_START=$(sha256sum "$SCRIPT_PATH" 2>/dev/null | cut -d' ' -f1)
echo "[$(date -Iseconds)] chef-daemon: BOOT script_sha=$SCRIPT_SHA_AT_START"

# Write running-state file so the worker daemon (meta-supervisor) can detect
# a stale chef-daemon version and trigger a restart. Format : single line
# "PID SHA". Worker-daemon reads this and compares SHA to disk-SHA each tick.
RUNNING_STATE_FILE="$HOME/.async-chef-daemon.running"
echo "$$ $SCRIPT_SHA_AT_START" > "$RUNNING_STATE_FILE" 2>/dev/null || true
echo "[$(date -Iseconds)] chef-daemon: BOOT running-state file written"

# ------------------------------------------------------------------ flock
echo "[$(date -Iseconds)] chef-daemon: BOOT attempting flock $LOCK_FILE"
exec 9>"$LOCK_FILE"
if ! flock -n 9 ; then
  echo "[$(date -Iseconds)] chef-daemon: BOOT flock failed (another chef alive) — exiting"
  exit 0
fi
echo "[$(date -Iseconds)] chef-daemon: BOOT flock acquired"

# ------------------------------------------------------------------ helpers

log() {
  echo "[$(date -Iseconds)] chef: $*"
}

clear_stale_git_index_lock() {
  local repo="$1"
  local lock="$repo/.git/index.lock"
  local age_min

  [[ -e "$lock" ]] || return 0

  age_min=$((($(date +%s) - $(stat -c %Y "$lock" 2>/dev/null || echo 0)) / 60))
  if [[ "$age_min" -lt "$STALE_GIT_LOCK_MIN" ]] ; then
    log "git index.lock present but fresh repo=$repo age_min=$age_min"
    return 0
  fi

  if ps -eo args | grep -F "$repo" | grep -E '[ /]git( |$)' | grep -v grep >/dev/null 2>&1 ; then
    log "git index.lock present but git process still references repo=$repo age_min=$age_min"
    return 0
  fi

  rm -f "$lock"
  log "removed stale git index.lock repo=$repo age_min=$age_min"
}

changed_files_unavailable() {
  local reason="$1"
  printf 'unavailable: %s\n' "$reason"
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
    write_verdict "$phase_id" "escalated" "target_repo not on this PC : $repo_dir" "" "$(changed_files_unavailable "target repo missing before chef could inspect branch diff")"
    return
  fi

  cd "$repo_dir" || {
    write_verdict "$phase_id" "escalated" "cannot cd to $repo_dir" "" "$(changed_files_unavailable "cannot cd to target repo before chef could inspect branch diff")"
    return
  }
  clear_stale_git_index_lock "$repo_dir"

  # Fetch + clean working tree before checkout. The chef-daemon shares the
  # canonical clone with the worker daemon — worker creates worktrees there
  # and codex runs leave .coverage / .pytest_cache / .venv / .ruff_cache
  # untracked artifacts in the working tree. Without `git clean -fdx`, those
  # block `git checkout` with "would overwrite untracked files" errors.
  if ! git fetch origin --prune --quiet ; then
    write_verdict "$phase_id" "escalated" "git fetch failed on $repo_dir" "" "$(changed_files_unavailable "git fetch failed before chef could inspect origin branch diff")"
    return
  fi

  # Early exit : if the worker SUMMARY.md branch SHA is already an ancestor
  # of origin/main, the phase has been merged (manually by claude-TN, or by
  # an earlier chef tick). No checkout / re-test needed — write approved.
  local summary_path="$ASYNC_REPO/outbox/$phase_id/SUMMARY.md"
  local worker_sha=""
  if [[ -f "$summary_path" ]] ; then
    worker_sha=$(grep -E '^- Branch SHA :' "$summary_path" | awk '{print $5}' | head -1)
    if [[ -n "$worker_sha" && "$worker_sha" != "none" ]] ; then
      if git merge-base --is-ancestor "$worker_sha" origin/main 2>/dev/null ; then
        local fast_path_changed_files
        fast_path_changed_files=$(git diff-tree --no-commit-id --name-status -r "$worker_sha" 2>/dev/null || true)
        write_verdict "$phase_id" "approved" "branch SHA $worker_sha already in origin/main — manual chef merge or prior chef tick handled this" "" "$fast_path_changed_files"
        log "$phase_id approved (already-in-main fast path, sha=$worker_sha)"
        return
      fi
    fi
  fi

  # Hard-reset to origin/main and remove all untracked files. This is safe :
  # the worker uses a SEPARATE worktree at $repo_dir-$target_branch for codex
  # runs, so we cannot lose codex work by cleaning $repo_dir itself.
  git checkout main --quiet 2>/dev/null || true
  git reset --hard "origin/main" --quiet 2>/dev/null || true
  git clean -fdx --quiet 2>/dev/null || true

  # Now check out the target branch from origin (force-create local tracking)
  if ! git checkout -B "$target_branch" "origin/$target_branch" --quiet 2>/dev/null ; then
    local checkout_changed_files
    checkout_changed_files=$(git diff-tree --no-commit-id --name-status -r "$worker_sha" 2>/dev/null || true)
    if [[ -z "$checkout_changed_files" ]] ; then
      checkout_changed_files=$(changed_files_unavailable "target branch could not be checked out and worker SHA diff was unavailable")
    fi
    # Fallback : maybe origin already deleted the branch (chef merged earlier)
    if git show-ref --verify --quiet "refs/remotes/origin/$target_branch" ; then
      write_verdict "$phase_id" "escalated" "git checkout origin/$target_branch failed despite ref existing — investigate working tree state" "" "$checkout_changed_files"
    else
      write_verdict "$phase_id" "escalated" "branch $target_branch missing on origin (already merged + cleaned by another chef tick ?)" "" "$checkout_changed_files"
    fi
    return
  fi

  local changed_files
  changed_files=$(git diff --name-status "origin/$base_branch"...HEAD 2>/dev/null || git diff-tree --no-commit-id --name-status -r HEAD 2>/dev/null || true)

  # Verify commit metadata
  local author email body
  author=$(git log -1 --format=%an)
  email=$(git log -1 --format=%ae)
  body=$(git log -1 --format=%B)

  if [[ "$author" != "Oussama Akir" ]] ; then
    write_verdict "$phase_id" "needs_fix" "commit author '$author' != 'Oussama Akir'" "" "$changed_files"
    git checkout main --quiet
    return
  fi
  if [[ "$email" != "claude@cosmocomply.com" ]] ; then
    write_verdict "$phase_id" "needs_fix" "commit email '$email' != 'claude@cosmocomply.com'" "" "$changed_files"
    git checkout main --quiet
    return
  fi
  if echo "$body" | grep -qi 'Co-Authored-By:.*Claude' ; then
    write_verdict "$phase_id" "needs_fix" "Co-Authored-By: Claude trailer present in commit body" "" "$changed_files"
    git checkout main --quiet
    return
  fi

  # Run gates if pyproject.toml present
  local gate_log
  gate_log=$(mktemp)
  local gates_ok=1

  if [[ -f "pyproject.toml" ]] ; then
    # Chef gates must be reproducible from a fresh project environment. The
    # BSEBench repos keep pytest/ruff in optional extras rather than runtime
    # dependencies, and some dataset tests need non-dev extras at collection
    # time. Use all extras so validation does not depend on a worker's warm
    # local venv.
    if ! uv run --all-extras pytest -m "not slow" -v > "$gate_log" 2>&1 ; then
      gates_ok=0
      log "$phase_id pytest failed"
    fi
    if [[ "$gates_ok" -eq 1 ]] ; then
      if ! uv run --all-extras ruff format --check . >> "$gate_log" 2>&1 ; then
        gates_ok=0
        log "$phase_id ruff format failed"
      fi
    fi
    if [[ "$gates_ok" -eq 1 ]] ; then
      if ! uv run --all-extras ruff check . >> "$gate_log" 2>&1 ; then
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
    write_verdict "$phase_id" "needs_fix" "chef-side gate failure" "$gate_tail" "$changed_files"
    git checkout main --quiet
    return
  fi

  # Gates green : merge ff to main, push, delete branch
  if ! git checkout main --quiet ; then
    write_verdict "$phase_id" "escalated" "could not checkout main for merge" "" "$changed_files"
    return
  fi

  if ! git merge --ff-only "$target_branch" --quiet ; then
    write_verdict "$phase_id" "escalated" "ff-merge $target_branch -> main failed (non-linear ?)" "" "$changed_files"
    return
  fi

  if ! git push origin main --quiet ; then
    write_verdict "$phase_id" "escalated" "git push origin main failed (auth ?)" "" "$changed_files"
    return
  fi

  git branch -d "$target_branch" --quiet 2>/dev/null || true
  git push origin --delete "$target_branch" --quiet 2>/dev/null || true

  local merged_sha
  merged_sha=$(git rev-parse HEAD)
  write_verdict "$phase_id" "approved" "merged $target_branch -> main at $merged_sha" "$gate_tail" "$changed_files"

  log "$phase_id approved + merged at $merged_sha"
}

# Write CHEF_VERDICT.md and push to async repo
write_verdict() {
  local phase_id="$1"
  local decision="$2"     # approved | needs_fix | escalated
  local summary="$3"
  local gate_evidence="${4:-}"
  local changed_files="${5:-}"

  cd "$ASYNC_REPO" || return
  mkdir -p "outbox/$phase_id"
  local out="outbox/$phase_id/CHEF_VERDICT.md"
  cat > "$out" <<VERDICT
# Chef verdict for $phase_id

- Decision : $decision
- Decided at : $(date -Iseconds)
- Decided by : chef-daemon (automated, France PC) [role: chef-FR]

## Re-verification on chef PC

$summary

$( [[ -n "$gate_evidence" ]] && echo -e "## Gate evidence\n\n\`\`\`\n$gate_evidence\n\`\`\`" )

$( [[ -n "$changed_files" ]] && echo -e "## Changed files\n\n\`\`\`\n$changed_files\n\`\`\`" )

## Cross-references

- inbox/$phase_id/STATUS.json (worker artifact)
- outbox/$phase_id/SUMMARY.md (worker SUMMARY)
- outbox/$phase_id/run.log.tail (worker stdout tail, if non-empty)
VERDICT

  git add "$out"
  git commit -m "chore(async): chef verdict $decision on $phase_id

[role: chef-FR]

Chef-daemon decision : $decision. Summary : $summary. Action taken per CHEF.md §6 auto-merge matrix." --quiet 2>/dev/null
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
$log_tail" "$(changed_files_unavailable "worker status=error; chef did not check out target branch")"
}

# Kaizen retro : after a verdict is written, dispatch codex with a tight
# kaizen-BRIEF that produces KEEP/FIX/SHIP-ONE markdown. The codex run reads
# inbox/<phase>/BRIEF.md + outbox/<phase>/SUMMARY.md + outbox/<phase>/CHEF_VERDICT.md
# and outputs ≤ 200 tokens of retrospective. We save that as
# outbox/<phase>/KAIZEN.md and commit with [role: kaizen-FR].
#
# The SHIP-ONE recommendation is TEXT only — not auto-executed. claude-TN
# (or a future auto-fix-BRIEF queueing daemon V2) is responsible for
# converting the SHIP-ONE bullet into a concrete fix-BRIEF if the value /
# scope justifies it.
#
# Wallclock cap : KAIZEN_WALLCLOCK_SEC (default 180 s). The retro is meant
# to be FAST — no code changes, no test runs, just reading 3 files and
# producing a short markdown.
run_kaizen() {
  local phase_id="$1"
  local decision="$2"

  if [[ "$KAIZEN_ENABLED" != "1" ]] ; then
    return
  fi

  # Skip if we already have a KAIZEN.md (idempotency)
  if [[ -f "$ASYNC_REPO/outbox/$phase_id/KAIZEN.md" ]] ; then
    return
  fi

  log "kaizen retro on $phase_id (decision=$decision)"

  cd "$ASYNC_REPO" || return

  # Inline kaizen-BRIEF for codex. Hard-coded prompt — no separate file
  # to keep the daemon self-contained.
  local kaizen_prompt
  read -r -d '' kaizen_prompt <<KAIZEN_EOF || true
You are the **kaizen reviewer** for the bsebench-async-codex protocol. Your job here is short and tight : look at the three files for phase **$phase_id** and produce a retrospective. Decision recorded by chef : **$decision**.

Files to read in this cwd ($ASYNC_REPO) :

- inbox/$phase_id/BRIEF.md   — what was asked
- outbox/$phase_id/SUMMARY.md — what worker reported (codex stdout tail + branch SHA + push result)
- outbox/$phase_id/CHEF_VERDICT.md — what chef decided (gates evidence + action taken)

If HISTORY.md is present, skim its last 50 lines for context.

**Output a single Markdown document, ≤ 250 tokens, with EXACTLY these three sections**, written DIRECTLY to outbox/$phase_id/KAIZEN.md via apply_patch (replace its content if it already exists, else create) :

\`\`\`
# Kaizen retro for $phase_id

[role: kaizen-FR]
Decision audited : $decision
Generated at : <ISO-8601 UTC timestamp>

## KEEP
<1 short bullet : what worked that we should explicitly preserve. e.g., "ERR trap caught the worktree-add failure cleanly and produced a forensic SUMMARY", "GLASSBOX [role:] tags made the verdict's authorship obvious".>

## FIX
<1 short bullet : what surprised, rubbed, or partially failed. If NOTHING — write "none — clean run." Don't fabricate friction.>

## SHIP-ONE
<1 specific improvement to ship NEXT. Constraints : ≤ 30 LOC of code OR ≤ 1 paragraph in a doc OR ≤ 1 bullet in a checklist. Be concrete : file path + what to change + why. claude-TN or V2 auto-fix-BRIEF queueing will pick this up and queue a fix-BRIEF if it's worth it.>
\`\`\`

Then commit + DO NOT PUSH (the chef-daemon will commit + push the file). Just write KAIZEN.md and exit.

**Rules** :
- Keep it short. ≤ 250 tokens of markdown total.
- Be concrete on SHIP-ONE — vague "improve robustness" is forbidden.
- Don't propose architectural changes. Kaizen is for incremental, ≤30-LOC moves.
- Don't fabricate FIX. "none — clean run" is acceptable and accurate when true.
KAIZEN_EOF

  # Dispatch codex (inline brief via stdin). Wallclock cap.
  local kaizen_log
  kaizen_log=$(mktemp)
  if echo "$kaizen_prompt" | timeout --kill-after=15s "${KAIZEN_WALLCLOCK_SEC}s" \
       codex exec --dangerously-bypass-approvals-and-sandbox \
       -c 'model="gpt-5.5"' -c 'model_reasoning_effort="xhigh"' \
       -C "$ASYNC_REPO" - > "$kaizen_log" 2>&1 ; then
    log "$phase_id kaizen codex ok"
  else
    log "$phase_id kaizen codex exit non-zero (continuing with whatever was written)"
  fi
  rm -f "$kaizen_log"

  # Commit + push if codex actually wrote KAIZEN.md
  if [[ -f "$ASYNC_REPO/outbox/$phase_id/KAIZEN.md" ]] ; then
    git add "outbox/$phase_id/KAIZEN.md"
    git commit -m "docs(kaizen): retro for $phase_id

[role: kaizen-FR]

Auto-generated kaizen retro (KEEP / FIX / SHIP-ONE). Triggered by chef-daemon after writing CHEF_VERDICT (decision=$decision). The SHIP-ONE bullet is text-only — claude-TN at next session, or V2 auto-fix-BRIEF queueing, decides whether to convert it into a fix-BRIEF based on scope/value/timing." --quiet 2>/dev/null || true
    git push origin main --quiet 2>/dev/null || log "$phase_id kaizen push failed (will retry on next phase)"
  else
    log "$phase_id KAIZEN.md not written by codex — skipping commit"
  fi
}

# ------------------------------------------------------------------ panel check + advisor + email block (V1)
# Per user mandate 2026-05-06 ~17:00 UTC : after each iteration close, run a
# 3-agent panel (Mme Rim Barrak + 2 task-relevant experts), get confidence
# scores. If avg < 89, escalate to advisor (single fresh-context reviewer).
# If advisor returns BLOCK, write outbox/_blocks/<phase>.block + email
# pending in outbox/_emails_pending/. The chef-daemon then refuses to
# process new phases until block file is removed.

PANEL_CHECK_ENABLED="${PANEL_CHECK_ENABLED:-1}"
PANEL_THRESHOLD="${PANEL_THRESHOLD:-89}"
PANEL_WALLCLOCK_SEC="${PANEL_WALLCLOCK_SEC:-180}"
ESCALATION_EMAIL="${ESCALATION_EMAIL:-akir.oussama@gmail.com}"

run_panel_check() {
  local phase_id="$1"
  local decision="$2"

  if [[ "$PANEL_CHECK_ENABLED" != "1" ]] ; then return ; fi
  if [[ -f "$ASYNC_REPO/outbox/$phase_id/PANEL_CHECK.md" ]] ; then return ; fi

  log "panel check on $phase_id"
  cd "$ASYNC_REPO" || return

  local panel_prompt
  read -r -d '' panel_prompt <<PANEL_EOF || true
You are a 3-agent review panel for the bsebench-async-codex protocol. Read these files in cwd ($ASYNC_REPO) :

- inbox/$phase_id/BRIEF.md
- outbox/$phase_id/SUMMARY.md
- outbox/$phase_id/CHEF_VERDICT.md
- outbox/$phase_id/KAIZEN.md (if present)

Decision recorded by chef : **$decision**.

Play these 3 personas, each scoring 0-100 :

1. **Mme Rim Barrak** (thesis director, Sup'Com Tunisia, GRESCOM Lab) — applies REPORT_RULES_MME_RIM discipline : pagination, acronyms, biblio, sign convention, source-of-truth pinning. Score the work's academic / forensic rigor.
2. **Expert 2** : pick based on phase type. If BRIEF involves CODE / TESTS / ADAPTERS / LOADERS → "ML/Stats expert" (frequentist + nonparametric, scrutinizes test coverage + edge cases). If DOCS / PROTOCOL / META → "Q1 reviewer" (Q1 venue peer-review experience). If DATA / DATASET / CHEMISTRY → "Battery-electrochem expert".
3. **Expert 3** : pick complementary. Default = "Adversarial reviewer" (red-team, attacks assumptions). For dataset work, "Embedded/MCU expert" (deployability constraints). State your reasoning briefly.

Write your output DIRECTLY to outbox/$phase_id/PANEL_CHECK.md via apply_patch :

# Panel check for $phase_id

[role: panel-FR]
Decision audited : $decision
Generated at : <ISO-8601 UTC>

## Panel composition
- Mme Rim Barrak (thesis director, mandatory)
- <expert 2 name> (reasoning : <one line>)
- <expert 3 name> (reasoning : <one line>)

## Confidence scores (0-100, where 100 = "ship it now, no concerns")
- mme_rim : NN — <one-line rationale>
- expert2 : NN — <one-line rationale>
- expert3 : NN — <one-line rationale>
- **AVERAGE : NN**

## Key concerns (if any)
- <bullet 1>
- <bullet 2>

## Verdict
PASS (avg ≥ $PANEL_THRESHOLD) | NEEDS_REVIEW (avg < $PANEL_THRESHOLD, escalate to advisor)

Output ONLY the markdown above. No extra commentary. The threshold for escalation is $PANEL_THRESHOLD.
PANEL_EOF

  local panel_log
  panel_log=$(mktemp)
  echo "$panel_prompt" | timeout --kill-after=15s "${PANEL_WALLCLOCK_SEC}s" \
       codex exec --dangerously-bypass-approvals-and-sandbox \
       -c 'model="gpt-5.5"' -c 'model_reasoning_effort="xhigh"' \
       -C "$ASYNC_REPO" - > "$panel_log" 2>&1 || \
       log "$phase_id panel codex exit non-zero"
  rm -f "$panel_log"

  if [[ ! -f "$ASYNC_REPO/outbox/$phase_id/PANEL_CHECK.md" ]] ; then
    log "$phase_id PANEL_CHECK.md not written — skipping panel logic"
    return
  fi

  # Parse average from PANEL_CHECK.md
  local avg
  avg=$(grep -oE 'AVERAGE\s*:?\s*\*?\*?\s*[0-9]+' "$ASYNC_REPO/outbox/$phase_id/PANEL_CHECK.md" | grep -oE '[0-9]+' | head -1)
  log "$phase_id panel avg = ${avg:-unknown}"

  git add "outbox/$phase_id/PANEL_CHECK.md"
  git commit -m "docs(panel): $phase_id avg=${avg:-?} (threshold=$PANEL_THRESHOLD)

[role: panel-FR]

3-agent panel (Mme Rim + 2 experts) reviewed phase $phase_id (decision=$decision). Average confidence : ${avg:-unparseable}. Threshold : $PANEL_THRESHOLD. $([[ -n "$avg" && "$avg" -ge "$PANEL_THRESHOLD" ]] && echo "PASS — continuing." || echo "NEEDS_REVIEW — escalating to advisor.")" --quiet 2>/dev/null || true
  git push origin main --quiet 2>/dev/null || true

  if [[ -n "$avg" && "$avg" -ge "$PANEL_THRESHOLD" ]] ; then
    return  # PASS
  fi

  # Escalate to advisor
  log "$phase_id panel below threshold ($avg < $PANEL_THRESHOLD), escalating to advisor"
  call_advisor_block_check "$phase_id" "$decision" "${avg:-unparseable}"
}

call_advisor_block_check() {
  local phase_id="$1"
  local decision="$2"
  local panel_avg="$3"

  cd "$ASYNC_REPO" || return

  local advisor_prompt
  read -r -d '' advisor_prompt <<ADV_EOF || true
You are the FRESH-CONTEXT ADVISOR. A 3-agent panel reviewed phase $phase_id and gave avg confidence $panel_avg < $PANEL_THRESHOLD.

Read in cwd : inbox/$phase_id/BRIEF.md, outbox/$phase_id/SUMMARY.md, outbox/$phase_id/CHEF_VERDICT.md, outbox/$phase_id/KAIZEN.md (if present), outbox/$phase_id/PANEL_CHECK.md.

Decide : GO (override the panel and continue) or BLOCK (stop chef-daemon and escalate to user via email).

Output to outbox/$phase_id/ADVISOR_CHECK.md :

# Advisor check for $phase_id

[role: advisor-FR]
Generated at : <ISO-8601 UTC>
Panel average that triggered escalation : $panel_avg
Threshold : $PANEL_THRESHOLD

## Verdict
<exactly GO or BLOCK on its own line>

## Reasoning
<2-4 sentences explaining your decision>

Note : the chef-daemon will write a unified progress email after this advisor decision (PASS or BLOCK both produce a notification). Don't write your own email file.
ADV_EOF

  local adv_log
  adv_log=$(mktemp)
  echo "$advisor_prompt" | timeout --kill-after=15s "${PANEL_WALLCLOCK_SEC}s" \
       codex exec --dangerously-bypass-approvals-and-sandbox \
       -c 'model="gpt-5.5"' -c 'model_reasoning_effort="xhigh"' \
       -C "$ASYNC_REPO" - > "$adv_log" 2>&1 || \
       log "$phase_id advisor codex exit non-zero"
  rm -f "$adv_log"

  local verdict="BLOCK"  # Conservative default : if advisor failed to write, BLOCK
  if [[ -f "$ASYNC_REPO/outbox/$phase_id/ADVISOR_CHECK.md" ]] ; then
    verdict=$(grep -oE '^GO$|^BLOCK$' "$ASYNC_REPO/outbox/$phase_id/ADVISOR_CHECK.md" | head -1)
    [[ -z "$verdict" ]] && verdict="BLOCK"
  fi

  if [[ "$verdict" == "BLOCK" ]] ; then
    mkdir -p "$ASYNC_REPO/outbox/_blocks" "$ASYNC_REPO/outbox/_emails_pending"
    echo "Phase $phase_id BLOCKED at $(date -Iseconds). Panel avg=$panel_avg, advisor=BLOCK. Email queued at outbox/_emails_pending/. Delete this file to unblock the chef-daemon." > "$ASYNC_REPO/outbox/_blocks/$phase_id.block"

    git add -A "outbox/$phase_id/" "outbox/_blocks/" "outbox/_emails_pending/"
    git commit -m "block(async): $phase_id BLOCKED (panel=$panel_avg, advisor=BLOCK)

[role: chef-FR]

Panel of 3 returned avg=$panel_avg < $PANEL_THRESHOLD. Advisor confirmed BLOCK. Chef-daemon paused : no new phases picked up until outbox/_blocks/$phase_id.block is removed by the user. Email pending at outbox/_emails_pending/ for $ESCALATION_EMAIL." --quiet 2>/dev/null || true
    git push origin main --quiet 2>/dev/null || true
    log "$phase_id BLOCKED — chef-daemon paused"
  else
    git add "outbox/$phase_id/ADVISOR_CHECK.md"
    git commit -m "docs(advisor): $phase_id GO (override panel=$panel_avg)

[role: advisor-FR]

Panel sub-threshold but advisor approved GO with reasoning. Continuing to next iteration." --quiet 2>/dev/null || true
    git push origin main --quiet 2>/dev/null || true
    log "$phase_id advisor said GO — continuing"
  fi
}

# Write a unified progress email after every iteration close.
# User mandate 2026-05-06 ~17:30 UTC : "dans tout les cas, envoi un email
# après chaque itération, concis, bref, mot simple, qui me permet de
# suivre l'avancement et interagir si necessaire.. il faut dire tache
# suivante aussi". One email per phase verdict, regardless of decision.
write_progress_email() {
  local phase_id="$1"
  local decision="$2"          # approved | needs_fix | escalated
  local panel_avg="$3"         # number or "?" or "N/A"
  local final_state="$4"       # approved | needs_fix | escalated | blocked

  cd "$ASYNC_REPO" || return

  # Find next queued phase (worker picks lex-smallest first)
  local next_phase="(aucune phase en attente)"
  if [[ -d inbox ]] ; then
    local found
    found=$(for s in inbox/*/STATUS.json ; do
      [[ -f "$s" ]] || continue
      local st
      st=$(jq -r '.status' "$s" 2>/dev/null)
      if [[ "$st" == "queued" ]] ; then
        basename "$(dirname "$s")"
        break
      fi
    done | head -1)
    [[ -n "$found" ]] && next_phase="$found"
  fi

  # Subject tag (short, scannable)
  local subject_tag
  case "$final_state" in
    approved)  subject_tag="OK" ;;
    needs_fix) subject_tag="FIX" ;;
    escalated) subject_tag="ESCALATED" ;;
    blocked)   subject_tag="BLOCKED" ;;
    *)         subject_tag="?" ;;
  esac

  # Quoi : extract first H1 line from BRIEF.md as a one-line summary
  local brief_title="(no title)"
  if [[ -f "inbox/$phase_id/BRIEF.md" ]] ; then
    brief_title=$(grep -E '^# ' "inbox/$phase_id/BRIEF.md" | head -1 | sed 's/^# //')
    [[ -z "$brief_title" ]] && brief_title="(no title)"
  fi

  # Repo URLs
  local repo_url="https://github.com/bsebench-org/bsebench-async-codex"
  local verdict_url="$repo_url/blob/main/outbox/$phase_id/CHEF_VERDICT.md"
  local kaizen_url="$repo_url/blob/main/outbox/$phase_id/KAIZEN.md"
  local panel_url="$repo_url/blob/main/outbox/$phase_id/PANEL_CHECK.md"

  local ts
  ts=$(date -u +%Y%m%dT%H%M%SZ)
  local email_path="outbox/_emails_pending/${ts}-progress-${phase_id}.eml"
  mkdir -p "outbox/_emails_pending"

  cat > "$email_path" <<PEMAIL
To: $ESCALATION_EMAIL
Subject: [$subject_tag] $phase_id (panel ${panel_avg}/100)
From: chef-daemon <noreply@bsebench-async-codex>
Date: $(date -Iseconds)

Phase    : $phase_id
Etat     : $final_state ($decision)
Panel    : ${panel_avg}/100 (seuil 89)
Quoi     : $brief_title
Prochaine: $next_phase

Liens :
- Verdict : $verdict_url
- Kaizen  : $kaizen_url
- Panel   : $panel_url
- Repo    : $repo_url
PEMAIL

  # BLOCK addendum
  if [[ "$final_state" == "blocked" ]] ; then
    cat >> "$email_path" <<PEMAIL_BLOCK

ATTENTION : chef-daemon est PAUSE.
Action :
  (a) supprime outbox/_blocks/$phase_id.block pour reprendre, OU
  (b) queue une fix-BRIEF dans inbox/ qui repond aux preoccupations.

ADVISOR_CHECK : $repo_url/blob/main/outbox/$phase_id/ADVISOR_CHECK.md
PEMAIL_BLOCK
  fi

  git add "$email_path"
  git commit -m "notify(email): progress for $phase_id ($final_state)

[role: chef-FR]

Email concise pour $ESCALATION_EMAIL : $phase_id => $final_state ($decision), panel=$panel_avg, prochaine=$next_phase. Notification est ecrite a chaque iteration (PASS, FIX, ESCALATED, ou BLOCKED) per user mandate 2026-05-06 ~17:30 UTC. V1 = file pending in outbox/_emails_pending/ ; V2 = GitHub Actions on-push SMTP send (pas encore configure)." --quiet 2>/dev/null || true
  git push origin main --quiet 2>/dev/null || log "$phase_id progress email push failed"
  log "$phase_id progress email queued ($final_state, next=$next_phase)"
}

# Determine final state of an iteration based on decision + presence of block file
determine_final_state() {
  local phase_id="$1"
  local decision="$2"

  if [[ -f "$ASYNC_REPO/outbox/_blocks/$phase_id.block" ]] ; then
    echo "blocked"
    return
  fi
  echo "$decision"
}

# Check if chef-daemon is paused due to a block file
chef_is_blocked() {
  if [[ -d "$ASYNC_REPO/outbox/_blocks" ]] ; then
    local blocks
    blocks=$(find "$ASYNC_REPO/outbox/_blocks" -maxdepth 1 -type f -name '*.block' 2>/dev/null | wc -l)
    [[ "$blocks" -gt 0 ]] && return 0
  fi
  return 1
}

# ------------------------------------------------------------------ main loop
log "chef-daemon start (interval ${INTERVAL_SEC}s, async_repo=$ASYNC_REPO)"

trap 'log "chef-daemon stopped (signal received)" ; exit 0' TERM INT

while true ; do
  cd "$ASYNC_REPO" || { sleep "$INTERVAL_SEC" ; continue ; }
  clear_stale_git_index_lock "$ASYNC_REPO"
  git fetch origin main --quiet || true
  git reset --hard origin/main --quiet || true

  # Self-respawn : if our own script changed (just pulled a patched
  # version), exec ourselves so the next iteration runs the new code.
  current_sha=$(sha256sum "$SCRIPT_PATH" 2>/dev/null | cut -d' ' -f1)
  if [[ -n "$current_sha" && "$current_sha" != "$SCRIPT_SHA_AT_START" ]] ; then
    log "chef-daemon source changed ($SCRIPT_SHA_AT_START -> $current_sha), exec'ing new version"
    exec bash "$SCRIPT_PATH"
  fi

  # Refuse to process new phases while a block file is present.
  if chef_is_blocked ; then
    log "chef-daemon paused : outbox/_blocks/ contains $(ls "$ASYNC_REPO/outbox/_blocks" 2>/dev/null | wc -l) block file(s). Waiting for user to unblock."
    sleep "$INTERVAL_SEC"
    continue
  fi

  for status_path in inbox/*/STATUS.json ; do
    [[ -f "$status_path" ]] || continue
    phase_id=$(basename "$(dirname "$status_path")")
    [[ -f "outbox/$phase_id/CHEF_VERDICT.md" ]] && continue

    status=$(jq -r '.status' "$status_path" 2>/dev/null || echo "unknown")
    case "$status" in
      done)
        verify_and_merge "$phase_id" "$status_path"
        if [[ -f "outbox/$phase_id/CHEF_VERDICT.md" ]] ; then
          decision=$(grep -E '^- Decision :' "outbox/$phase_id/CHEF_VERDICT.md" | awk -F': ' '{print $2}' | head -1)
          decision="${decision:-unknown}"
          run_kaizen "$phase_id" "$decision"
          run_panel_check "$phase_id" "$decision"
          # Unified progress email — fires regardless of state
          panel_avg=$(grep -oE 'AVERAGE\s*:?\s*\*?\*?\s*[0-9]+' "outbox/$phase_id/PANEL_CHECK.md" 2>/dev/null | grep -oE '[0-9]+' | head -1)
          panel_avg="${panel_avg:-?}"
          final_state=$(determine_final_state "$phase_id" "$decision")
          write_progress_email "$phase_id" "$decision" "$panel_avg" "$final_state"
        fi
        ;;
      error)
        classify_error "$phase_id" "$status_path"
        if [[ -f "outbox/$phase_id/CHEF_VERDICT.md" ]] ; then
          run_kaizen "$phase_id" "escalated"
          run_panel_check "$phase_id" "escalated"
          panel_avg=$(grep -oE 'AVERAGE\s*:?\s*\*?\*?\s*[0-9]+' "outbox/$phase_id/PANEL_CHECK.md" 2>/dev/null | grep -oE '[0-9]+' | head -1)
          panel_avg="${panel_avg:-?}"
          final_state=$(determine_final_state "$phase_id" "escalated")
          write_progress_email "$phase_id" "escalated" "$panel_avg" "$final_state"
        fi
        ;;
      *)
        : # queued, running — leave alone
        ;;
    esac
  done

  sleep "$INTERVAL_SEC"
done
