#!/usr/bin/env bash
# Maintain a minimum BSEBench Codex capacity and write 15-minute KPI reports.

set -euo pipefail

ROOT="${BSEBENCH_ROOT:-/mnt/c/doctorat/bsebench-org}"
ASYNC="$ROOT/bsebench-async-codex"
STATE_DIR="${STATE_DIR:-/home/oakir/.local/state/bsebench-async-watchdog}"
MIN_CODEX="${MIN_CODEX:-6}"
TARGET_CODEX="${TARGET_CODEX:-9}"
INTERVAL_SECONDS="${INTERVAL_SECONDS:-60}"
REPORT_SECONDS="${REPORT_SECONDS:-900}"
LOG_FILE="$STATE_DIR/min6-target9-loop.log"
REPORT_FILE="$STATE_DIR/cto-15min-status.md"
LOCK_FILE="$STATE_DIR/min6-target9-loop.lock"

mkdir -p "$STATE_DIR"

log() {
  printf '[%s] %s\n' "$(date -Is)" "$*" | tee -a "$LOG_FILE"
}

unique_workdirs() {
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
    if any(x in line for x in ("pgrep", "cto-min6-target9-loop")):
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

real_upload_count() {
  ps -eo comm=,args= |
    awk '$1 != "bash" && $1 != "awk" && ($0 ~ /\.hf-upload-stage|hf-upload-stage/ || ($0 ~ /huggingface-cli/ && $0 ~ / upload/)) {n++} END {print n + 0}'
}

launch_capacity() {
  local active="$1"
  local needed
  needed=$((TARGET_CODEX - active))
  [[ "$needed" -gt 0 ]] || return 0

  log "CAPACITY_LOW active=$active min=$MIN_CODEX target=$TARGET_CODEX action=emergency_capacity"
  MIN_PRODUCT_CODEX_EXEC="$TARGET_CODEX" \
    MAX_PRODUCT_LAUNCH="$needed" \
    BSEBENCH_ROOT="$ROOT" \
    STATE_DIR="$STATE_DIR" \
    bash "$ASYNC/scripts/cto-emergency-capacity.sh" >> "$LOG_FILE" 2>&1 || true
}

write_report() {
  local now active uploads heads
  now="$(date -Is)"
  mapfile -t workdirs < <(unique_workdirs)
  active="${#workdirs[@]}"
  uploads="$(real_upload_count)"
  heads="$(
    for repo in bsebench-runner bsebench-stats bsebench-datasets bsebench-specs bsebench-filters bsebench-async-codex; do
      if [[ -d "$ROOT/$repo/.git" ]]; then
        printf -- '- `%s`: `%s`\n' "$repo" "$(git -C "$ROOT/$repo" log -1 --oneline --decorate | head -1)"
      fi
    done
  )"
  {
    printf '## CTO 15-Minute Status - %s\n\n' "$now"
    printf -- '- Active unique Codex workdirs: `%s` (min `%s`, target `%s`)\n' "$active" "$MIN_CODEX" "$TARGET_CODEX"
    printf -- '- Real HF upload processes: `%s`\n' "$uploads"
    printf -- '- Policy: uploads remain paused until consolidated dataset registry is complete.\n\n'
    printf '### Active Workdirs\n\n'
    if [[ "$active" -eq 0 ]]; then
      printf -- '- none\n'
    else
      printf -- '- `%s`\n' "${workdirs[@]}"
    fi
    printf '\n### Repo Heads\n\n%s\n' "$heads"
  } > "$REPORT_FILE"
  cat "$REPORT_FILE" >> "$LOG_FILE"
}

tick() {
  local active uploads
  mapfile -t workdirs < <(unique_workdirs)
  active="${#workdirs[@]}"
  uploads="$(real_upload_count)"
  log "TICK active=$active uploads=$uploads min=$MIN_CODEX target=$TARGET_CODEX"
  if [[ "$uploads" -gt 0 ]]; then
    log "UPLOAD_GUARD uploads=$uploads action=manual_stop_required"
  fi
  if [[ "$active" -lt "$MIN_CODEX" ]]; then
    launch_capacity "$active"
  fi
}

main() {
  local last_report=0 now
  log "START min=$MIN_CODEX target=$TARGET_CODEX interval=$INTERVAL_SECONDS report=$REPORT_SECONDS"
  while true; do
    now="$(date +%s)"
    tick
    if [[ $((now - last_report)) -ge "$REPORT_SECONDS" ]]; then
      write_report
      last_report="$now"
    fi
    sleep "$INTERVAL_SECONDS"
  done
}

(
  flock -n 9 || exit 0
  main
) 9>"$LOCK_FILE"
