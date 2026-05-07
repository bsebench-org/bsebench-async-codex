#!/usr/bin/env bash
# cto-supervisor-10h.sh - bounded 10h guard for active Codex execution.
#
# This supervisor is deliberately operational: it logs real codex exec workdirs,
# watches for silent logs, runs the audit watchdog and autonomy pacer, and exits
# after the configured deadline. It does not edit thesis, claim registry,
# roadmap, or target-repo evidence files.

set -euo pipefail

export PATH="/home/oakir/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

ROOT="${BSEBENCH_ROOT:-/mnt/c/doctorat/bsebench-org}"
ASYNC_CTO="${ASYNC_CTO:-$ROOT/bsebench-async-codex-cto-report}"
STATE_DIR="${STATE_DIR:-/home/oakir/.local/state/bsebench-async-watchdog}"
LOG_FILE="${SUPERVISOR_LOG:-$STATE_DIR/supervisor-10h.log}"
LOCK_FILE="$STATE_DIR/supervisor-10h.lock"
PID_FILE="$STATE_DIR/supervisor-10h.pid"
END_FILE="$STATE_DIR/supervisor-10h.ends"
INTERVAL_SECONDS="${INTERVAL_SECONDS:-600}"
DURATION_SECONDS="${DURATION_SECONDS:-36000}"
MIN_UNIQUE_CODEX_EXEC="${MIN_UNIQUE_CODEX_EXEC:-2}"
SILENT_LOG_WARN_SECONDS="${SILENT_LOG_WARN_SECONDS:-1200}"

mkdir -p "$STATE_DIR"

usage() {
  cat <<'USAGE'
Usage:
  scripts/cto-supervisor-10h.sh [--once]

Environment:
  DURATION_SECONDS=36000        total runtime when not --once
  INTERVAL_SECONDS=600          tick period
  MIN_UNIQUE_CODEX_EXEC=2       warn below this unique -C workdir count
  SILENT_LOG_WARN_SECONDS=1200  warn when watched logs are silent this long
USAGE
}

log() {
  printf '[%s] %s\n' "$(date -Is)" "$*" | tee -a "$LOG_FILE"
}

unique_codex_workdirs() {
  python3 - "$ROOT" <<'PY'
import shlex
import subprocess
import sys

root = sys.argv[1]
proc = subprocess.run(
    ["pgrep", "-af", r"codex exec|/usr/bin/codex|@openai/codex"],
    text=True,
    capture_output=True,
    check=False,
)
seen = []
for line in proc.stdout.splitlines():
    if "cto-supervisor-10h" in line or "cto-autonomy-pacer" in line or "cto-watchdog-10min" in line:
        continue
    try:
        parts = shlex.split(line)
    except ValueError:
        parts = line.split()
    workdir = None
    for idx, token in enumerate(parts):
        if token in ("-C", "--cd") and idx + 1 < len(parts):
            workdir = parts[idx + 1]
            break
    if workdir and root in workdir and workdir not in seen:
        seen.append(workdir)
for workdir in seen:
    print(workdir)
PY
}

status_counts() {
  local repo="$1"
  [[ -d "$repo/inbox" ]] || return 0
  find "$repo/inbox" -mindepth 2 -maxdepth 2 -name STATUS.json -print0 2>/dev/null |
    xargs -0 -r jq -r '.status // "unknown"' 2>/dev/null |
    sort |
    uniq -c |
    sort -k2
}

log_inbox_state() {
  local repo
  for repo in "$ROOT/bsebench-async-codex" "$ROOT/bsebench-async-codex-worker-2" "$ASYNC_CTO"; do
    [[ -d "$repo" ]] || continue
    log "INBOX_STATUS repo=$(basename "$repo")"
    status_counts "$repo" | sed 's/^/[status] /' | tee -a "$LOG_FILE"
  done
}

log_watched_log_mtimes() {
  local now file mtime age size lines
  now="$(date +%s)"
  for file in \
    "$STATE_DIR"/manual-phase-7-10-q2.log \
    "$STATE_DIR"/manual-phase-7-10-r.log \
    "$STATE_DIR"/manual-phase-7-10-s.log \
    "$STATE_DIR"/manual-phase-7-10-t.log \
    "$STATE_DIR"/manual-phase-7-10-u.log \
    "$STATE_DIR"/manual-phase-7-10-v.log \
    "$STATE_DIR"/manual-phase-7-10-n.log \
    "$STATE_DIR"/manual-phase-7-10-p.log \
    "$STATE_DIR"/pacer.log \
    "$STATE_DIR"/watchdog.log
  do
    [[ -f "$file" ]] || continue
    mtime="$(stat -c %Y "$file")"
    age=$((now - mtime))
    size="$(stat -c %s "$file")"
    lines="$(wc -l < "$file" | tr -d ' ')"
    log "LOG_MTIME file=$(basename "$file") age_s=$age size=$size lines=$lines"
    if [[ "$age" -ge "$SILENT_LOG_WARN_SECONDS" ]] ; then
      log "WARN_SILENT_LOG file=$(basename "$file") age_s=$age threshold_s=$SILENT_LOG_WARN_SECONDS"
    fi
  done
}

run_watchdog_and_pacer() {
  if [[ -x "$ASYNC_CTO/scripts/cto-watchdog-10min.sh" ]] ; then
    log "RUN watchdog"
    bash "$ASYNC_CTO/scripts/cto-watchdog-10min.sh" >> "$LOG_FILE" 2>&1 || log "WARN watchdog_failed status=$?"
  else
    log "WARN watchdog_missing path=$ASYNC_CTO/scripts/cto-watchdog-10min.sh"
  fi

  if [[ -x "$ASYNC_CTO/scripts/cto-autonomy-pacer.sh" ]] ; then
    log "RUN pacer"
    MIN_RUNNING=2 MIN_QUEUED=1 MIN_RESERVE=6 MAX_QUEUE_PER_TICK=3 \
      bash "$ASYNC_CTO/scripts/cto-autonomy-pacer.sh" >> "$LOG_FILE" 2>&1 || log "WARN pacer_failed status=$?"
  else
    log "WARN pacer_missing path=$ASYNC_CTO/scripts/cto-autonomy-pacer.sh"
  fi
}

tick() {
  local workdirs count
  log "TICK_BEGIN"
  mapfile -t workdirs < <(unique_codex_workdirs)
  count="${#workdirs[@]}"
  log "UNIQUE_CODEX_EXEC count=$count min=$MIN_UNIQUE_CODEX_EXEC"
  printf '%s\n' "${workdirs[@]}" | sed 's/^/[codex-workdir] /' | tee -a "$LOG_FILE"

  if [[ "$count" -lt "$MIN_UNIQUE_CODEX_EXEC" ]] ; then
    log "WARN_LOW_CODEX_EXEC unique=$count min=$MIN_UNIQUE_CODEX_EXEC action=run_pacer_and_recheck"
  fi

  log "DAEMONS"
  { pgrep -af 'worker-daemon|chef-daemon|cto-daemon' || true; } | sed 's/^/[daemon] /' | tee -a "$LOG_FILE"

  log_inbox_state
  log_watched_log_mtimes
  run_watchdog_and_pacer

  if [[ "$count" -lt "$MIN_UNIQUE_CODEX_EXEC" ]] ; then
    sleep 45
    mapfile -t workdirs < <(unique_codex_workdirs)
    count="${#workdirs[@]}"
    log "RECHECK_UNIQUE_CODEX_EXEC count=$count min=$MIN_UNIQUE_CODEX_EXEC"
    printf '%s\n' "${workdirs[@]}" | sed 's/^/[codex-workdir] /' | tee -a "$LOG_FILE"
  fi

  log "PACER_TAIL"
  tail -25 "$STATE_DIR/pacer.log" 2>/dev/null | sed 's/^/[pacer-tail] /' | tee -a "$LOG_FILE" || true
  log "TICK_END"
}

main_loop() {
  local end_epoch now sleep_for
  end_epoch="${END_EPOCH:-$(( $(date +%s) + DURATION_SECONDS ))}"
  printf '%s\n' "$$" > "$PID_FILE"
  date -d "@$end_epoch" -Is > "$END_FILE"
  log "SUPERVISOR_START pid=$$ interval_s=$INTERVAL_SECONDS end=$(cat "$END_FILE")"

  trap 'log "SUPERVISOR_STOP signal_or_exit"; rm -f "$PID_FILE"' EXIT

  while true ; do
    now="$(date +%s)"
    [[ "$now" -lt "$end_epoch" ]] || break
    tick
    now="$(date +%s)"
    sleep_for="$INTERVAL_SECONDS"
    if [[ $((end_epoch - now)) -lt "$sleep_for" ]] ; then
      sleep_for=$((end_epoch - now))
    fi
    [[ "$sleep_for" -gt 0 ]] || break
    log "SLEEP seconds=$sleep_for"
    sleep "$sleep_for"
  done

  log "SUPERVISOR_COMPLETE end=$(date -Is)"
}

mode="loop"
while [[ $# -gt 0 ]] ; do
  case "$1" in
    --once) mode="once" ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

(
  flock -n 9 || {
    echo "supervisor already running: $LOCK_FILE" >&2
    exit 0
  }
  if [[ "$mode" == "once" ]] ; then
    tick
  else
    main_loop
  fi
) 9>"$LOCK_FILE"
