#!/usr/bin/env bash
# cto-daemon.sh — autonomous CTO daemon. Runs on the same PC as the worker
# and chef daemons (France PC under WSL2). Mirrors chef-daemon shell-while-
# loop pattern : per-tick cheap shell checks, codex exec spawned ONLY when
# there is real work (CEO_DIRECTIVE_*.md pending OR a daemon down).
#
# Why this primitive (vs codex interactive auto-poll) :
# Codex interactive runs ONE turn per user input then waits. It does NOT
# autonomously sleep + tick. Advisor 2026-05-06 caught this. Pattern A
# (shell-while-loop) is the only working primitive on this stack.
#
# Responsibilities :
#   1. Loop every CTO_INTERVAL_SEC (default 90 s).
#   2. Pull bsebench-async-codex.
#   3. Health-check daemons :
#      - pgrep -af 'worker-daemon'   (expect ≥ 1 worker, possibly 2)
#      - pgrep -af 'chef-daemon'     (expect 1 chef)
#      - if any missing → write CTO_INCIDENT_<iso>.md proactively + relaunch
#        per docs/CTO-BOOTSTRAP-PROMPT.md launch sequence
#   4. CEO_DIRECTIVE polling :
#      - ls cto/INBOX/CEO_DIRECTIVE_*.md
#      - For each <iso> without matching cto/OUTBOX/CTO_REPORT_<iso>.md or
#        CTO_QUERY_<iso>.md, dispatch codex exec with the directive content
#        + a CTO-tick prompt
#      - Codex exec writes the report file, commits, pushes
#      - cto-daemon waits for codex exec to finish then continues loop
#   5. Sleep INTERVAL_SEC.
#
# Concurrency : flock on /tmp/codex-async-cto.lock — different from worker
# (/tmp/codex-async-worker.lock) and chef (/tmp/codex-async-chef.lock).
#
# Auth : uses the same GCM wrapper the worker / chef use ; ensure
# git config --global credential.helper points at it before launching.
#
# Usage (start) :
#   nohup stdbuf -oL -eL bash scripts/cto-daemon.sh > ~/.async-cto.log 2>&1 &
#   disown
#
# Usage (stop) :
#   pkill -f cto-daemon.sh

set -uo pipefail

# Force line-buffered stdout/stderr (same self-protective wrapper as
# chef-daemon, post 2026-05-06 silent-log incident).
if command -v stdbuf >/dev/null 2>&1 ; then
  if [[ "${CTO_STDBUF_WRAPPED:-0}" != "1" ]] ; then
    export CTO_STDBUF_WRAPPED=1
    exec stdbuf -oL -eL bash "$0" "$@"
  fi
fi

echo "[$(date -Iseconds)] cto-daemon: BOOT entered script body (PID=$$, stdbuf_wrapped=${CTO_STDBUF_WRAPPED:-0})"

ASYNC_REPO="${ASYNC_REPO:-/mnt/c/doctorat/bsebench-org/bsebench-async-codex}"
LOCK_FILE="/tmp/codex-async-cto.lock"
INTERVAL_SEC="${CTO_INTERVAL_SEC:-90}"
TICK_WALLCLOCK_SEC="${CTO_TICK_WALLCLOCK_SEC:-300}"
WORKER1_LOG="${WORKER1_LOG:-$HOME/.async-worker.log}"
WORKER2_LOG="${WORKER2_LOG:-$HOME/.async-worker-2.log}"
CHEF_LOG="${CHEF_LOG:-$HOME/.async-chef.log}"
CTO_LOG="${CTO_LOG:-$HOME/.async-cto.log}"

# Self-respawn : capture our own script's SHA at start. If it changes after
# a git pull inside the loop, exec ourselves with the new version so patches
# take effect without manual restart.
SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_SHA_AT_START=$(sha256sum "$SCRIPT_PATH" 2>/dev/null | cut -d' ' -f1)
echo "[$(date -Iseconds)] cto-daemon: BOOT script_sha=$SCRIPT_SHA_AT_START"

RUNNING_STATE_FILE="$HOME/.async-cto-daemon.running"
echo "$$ $SCRIPT_SHA_AT_START" > "$RUNNING_STATE_FILE" 2>/dev/null || true

# ------------------------------------------------------------------ flock
echo "[$(date -Iseconds)] cto-daemon: BOOT attempting flock $LOCK_FILE"
exec 9>"$LOCK_FILE"
if ! flock -n 9 ; then
  echo "[$(date -Iseconds)] cto-daemon: BOOT flock failed (another cto alive) — exiting"
  exit 0
fi
echo "[$(date -Iseconds)] cto-daemon: BOOT flock acquired"

# ------------------------------------------------------------------ helpers

log() {
  echo "[$(date -Iseconds)] cto: $*"
}

# Generate ISO without colons (file-system-safe) for filenames
iso_for_filename() {
  date -u +%Y%m%dT%H%M%SZ
}

# Check daemon health. Returns space-separated list of MISSING daemons.
# Empty string = all healthy.
daemons_missing() {
  local missing=""
  if ! pgrep -f 'worker-daemon\.sh' > /dev/null 2>&1 ; then
    missing="$missing worker"
  fi
  if ! pgrep -f 'chef-daemon\.sh' > /dev/null 2>&1 ; then
    missing="$missing chef"
  fi
  echo "$missing" | xargs
}

# Re-launch a missing daemon
relaunch_daemon() {
  local kind="$1"
  case "$kind" in
    worker)
      log "relaunching worker-1"
      nohup bash "$ASYNC_REPO/scripts/worker-daemon.sh" \
        > "$WORKER1_LOG" 2>&1 &
      disown
      ;;
    chef)
      log "relaunching chef-daemon"
      nohup stdbuf -oL -eL bash "$ASYNC_REPO/scripts/chef-daemon.sh" \
        > "$CHEF_LOG" 2>&1 &
      disown
      ;;
    *)
      log "relaunch_daemon unknown kind: $kind"
      ;;
  esac
}

# Find pending CEO directives (no matching CTO_REPORT or CTO_QUERY)
find_pending_directives() {
  local directives_dir="$ASYNC_REPO/cto/INBOX"
  local reports_dir="$ASYNC_REPO/cto/OUTBOX"
  shopt -s nullglob
  for d in "$directives_dir"/CEO_DIRECTIVE_*.md ; do
    local base
    base=$(basename "$d" .md)
    local iso="${base#CEO_DIRECTIVE_}"
    if [[ ! -f "$reports_dir/CTO_REPORT_$iso.md" && ! -f "$reports_dir/CTO_QUERY_$iso.md" ]] ; then
      echo "$d"
    fi
  done
  shopt -u nullglob
}

# Snapshot system state into a temp file (for codex prompt)
snapshot_state() {
  local out="$1"
  {
    echo "## pgrep snapshot"
    pgrep -af 'worker-daemon|chef-daemon|cto-daemon' 2>/dev/null || echo "(no matches)"
    echo ""
    echo "## Recent worker-1 log (last 8 lines)"
    tail -8 "$WORKER1_LOG" 2>/dev/null || echo "(log missing)"
    echo ""
    echo "## Recent worker-2 log (last 8 lines)"
    tail -8 "$WORKER2_LOG" 2>/dev/null || echo "(log missing)"
    echo ""
    echo "## Recent chef log (last 8 lines)"
    tail -8 "$CHEF_LOG" 2>/dev/null || echo "(log missing)"
    echo ""
    echo "## Inbox running phases"
    cd "$ASYNC_REPO" || return 1
    for s in inbox/*/STATUS.json ; do
      local st
      st=$(jq -r '.status' "$s" 2>/dev/null)
      if [[ "$st" == "running" ]] ; then
        local p t w
        p=$(jq -r '.phase_id' "$s" 2>/dev/null)
        t=$(jq -r '.ts_started' "$s" 2>/dev/null)
        w=$(jq -r '.worker_id' "$s" 2>/dev/null)
        echo "- $p (worker=$w, started=$t)"
      fi
    done
    echo ""
    echo "## Disk usage"
    df -h "$ASYNC_REPO" 2>/dev/null | tail -1
  } > "$out"
}

# Dispatch codex exec for a directive. Codex writes the report file +
# commits + pushes. cto-daemon just orchestrates.
act_on_directive() {
  local directive_path="$1"
  local base
  base=$(basename "$directive_path" .md)
  local iso="${base#CEO_DIRECTIVE_}"

  log "acting on directive iso=$iso"

  cd "$ASYNC_REPO" || {
    log "cannot cd to ASYNC_REPO"
    return 1
  }
  git pull --rebase origin main --quiet 2>/dev/null || true

  # Build snapshot file for context
  local snap
  snap=$(mktemp)
  snapshot_state "$snap"

  # Build codex prompt
  local prompt
  prompt=$(mktemp)
  cat > "$prompt" <<PROMPT_EOF
You are the CTO daemon (codex exec, role: cto-FR) acting on a CEO
directive. Your scope is the bsebench-async-codex repo on the France PC.

## Your authority
$(cat "$ASYNC_REPO/docs/CTO-CHARTER.md" 2>/dev/null || echo "(charter unavailable)")

## CEO directive content
$(cat "$directive_path")

## Current system state snapshot (just captured)
$(cat "$snap")

## Your task
1. Read the directive carefully.
2. Take the requested actions IN PERSON via Bash tool. The cto-daemon
   shell-loop wrapping you handles only orchestration ; YOU run pkill,
   nohup, queue BRIEFs, etc. via your Bash tool.
3. CRITICAL : Do NOT pkill -9 -f a process that has active in-flight
   work. Check STATUS.json running phases first ; if a worker is
   currently processing a phase (recent ts_started, no ts_done), do a
   GRACEFUL drain (let it finish) instead of pkill. Only force-kill if a
   process is genuinely stuck (no log update for > 30 min).
4. Write \`cto/OUTBOX/CTO_REPORT_$iso.md\` with the full report per
   docs/CEO-CTO-PROTOCOL.md format (Actions taken, State observed,
   Issues / blockers, Steady-state confirmed, Persistence note).
5. \`git add cto/OUTBOX/CTO_REPORT_$iso.md\` and any new files you
   created. Commit with GLASSBOX format :
   \`\`\`
   report(cto): $iso <short summary> [role: cto-FR]
   \`\`\`
   Body : Context / Objective / Problem / Result. NO Co-Authored-By Claude.
6. \`git push origin main\`. If push race, \`git pull --rebase\` retry.
7. Echo "[CTO_TICK_DONE iso=$iso]" so the wrapper knows you're done.

If the directive is ambiguous or would cause damage, write
\`cto/OUTBOX/CTO_QUERY_$iso.md\` instead with specific questions.
Commit + push the query. Echo "[CTO_QUERY iso=$iso]".

If you encounter a true emergency that the directive doesn't cover,
write \`cto/OUTBOX/CTO_INCIDENT_$iso.md\` proactively. Commit + push.
Echo "[CTO_INCIDENT iso=$iso]".
PROMPT_EOF

  # Dispatch codex exec with hard wallclock guard
  local codex_log
  codex_log=$(mktemp)
  log "dispatching codex exec (wallclock=${TICK_WALLCLOCK_SEC}s)"

  # Pattern mirrors remote-worker.sh:223 (proven on this codex 0.129.0-alpha.7)
  # -C explicit cwd, --add-dir for repo visibility, stdin redirect for prompt
  if timeout --kill-after=30s "${TICK_WALLCLOCK_SEC}" \
       codex exec --dangerously-bypass-approvals-and-sandbox \
         -c 'model="gpt-5.5"' \
         -c 'model_reasoning_effort="xhigh"' \
         -C "$ASYNC_REPO" \
         --add-dir "$ASYNC_REPO" \
         --add-dir /mnt/c/doctorat/bsebench-org \
         < "$prompt" \
         > "$codex_log" 2>&1 ; then
    log "codex exec completed for iso=$iso"
  else
    local ec=$?
    log "codex exec failed for iso=$iso (exit=$ec, log=$codex_log)"
    # Write a minimal CTO_INCIDENT to communicate the failure
    local report_path="$ASYNC_REPO/cto/OUTBOX/CTO_INCIDENT_$iso.md"
    {
      echo "# CTO incident — codex exec failure for directive $iso"
      echo ""
      echo "[role: cto-FR]"
      echo "Generated at : $(date -Iseconds)"
      echo ""
      echo "## What happened"
      echo "codex exec failed with exit=$ec while acting on directive $iso."
      echo "wallclock budget : ${TICK_WALLCLOCK_SEC}s."
      echo ""
      echo "## Last 30 lines of codex output"
      echo '```'
      tail -30 "$codex_log"
      echo '```'
      echo ""
      echo "## Recovery"
      echo "claude-TN should re-issue the directive with a different iso, or"
      echo "investigate the codex log. cto-daemon continues steady-state polling."
    } > "$report_path"
    cd "$ASYNC_REPO" || true
    git pull --rebase origin main --quiet 2>/dev/null || true
    git add "cto/OUTBOX/CTO_INCIDENT_$iso.md" 2>/dev/null || true
    git commit -m "report(cto): $iso codex exec failure [role: cto-FR]" --quiet 2>/dev/null || true
    git push origin main --quiet 2>/dev/null || true
  fi

  rm -f "$prompt" "$snap" "$codex_log"
}

# ------------------------------------------------------------------ main loop

log "main loop start (interval=${INTERVAL_SEC}s)"

while true ; do
  log "tick start"

  # Pull repo
  cd "$ASYNC_REPO" || { log "cannot cd $ASYNC_REPO"; sleep "$INTERVAL_SEC"; continue; }
  git pull --rebase origin main --quiet 2>/dev/null || log "git pull failed (continuing)"

  # Self-respawn check
  current_sha=$(sha256sum "$SCRIPT_PATH" 2>/dev/null | cut -d' ' -f1)
  if [[ "$current_sha" != "$SCRIPT_SHA_AT_START" ]] ; then
    log "self-respawn : disk SHA $current_sha != boot SHA $SCRIPT_SHA_AT_START"
    rm -f "$RUNNING_STATE_FILE" 2>/dev/null || true
    flock -u 9 2>/dev/null || true
    exec bash "$SCRIPT_PATH"
  fi

  # Daemon health-check
  missing=$(daemons_missing)
  if [[ -n "$missing" ]] ; then
    log "daemons missing : $missing"
    for kind in $missing ; do
      relaunch_daemon "$kind"
    done
    # Write proactive incident
    iso=$(iso_for_filename)
    incident_path="$ASYNC_REPO/cto/OUTBOX/CTO_INCIDENT_${iso}.md"
    {
      echo "# CTO incident — daemons missing detected"
      echo ""
      echo "[role: cto-FR]"
      echo "Generated at : $(date -Iseconds)"
      echo ""
      echo "## Missing daemons"
      for kind in $missing ; do echo "- $kind" ; done
      echo ""
      echo "## Auto-recovery"
      echo "cto-daemon issued nohup relaunch for each missing daemon."
      echo "Verify with pgrep on next tick."
      echo ""
      echo "## Probable cause"
      echo "WSL2 reaped processes after terminal closure, OR codex exec hung"
      echo "and triggered timeout SIGKILL leaving orphan, OR script crash."
    } > "$incident_path"
    git add "cto/OUTBOX/CTO_INCIDENT_${iso}.md" 2>/dev/null || true
    git commit -m "report(cto): $iso daemons-missing auto-recovered [role: cto-FR]" --quiet 2>/dev/null || true
    git push origin main --quiet 2>/dev/null || true
  fi

  # CEO directive polling
  pending=$(find_pending_directives)
  if [[ -n "$pending" ]] ; then
    log "pending directives detected"
    while IFS= read -r d ; do
      [[ -z "$d" ]] && continue
      act_on_directive "$d"
    done <<< "$pending"
  fi

  log "tick done — sleeping ${INTERVAL_SEC}s"
  sleep "$INTERVAL_SEC"
done
