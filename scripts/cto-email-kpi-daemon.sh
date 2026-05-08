#!/usr/bin/env bash
# Run a concise CTO KPI email every 30 minutes.

set -uo pipefail

ASYNC_REPO="${ASYNC_REPO:-/mnt/c/doctorat/bsebench-org/bsebench-async-codex}"
KPI_EMAIL_TO="${KPI_EMAIL_TO:-akir.oussama@gmail.com}"
KPI_INTERVAL_SEC="${KPI_INTERVAL_SEC:-1800}"
STATE_DIR="${STATE_DIR:-$HOME/.local/state/bsebench-kpi-email}"
LOG_FILE="${KPI_LOG_FILE:-$HOME/.bsebench-kpi-email.log}"
LOCK_FILE="$STATE_DIR/daemon.lock"

mkdir -p "$STATE_DIR"

exec 9>"$LOCK_FILE"
if ! flock -n 9 ; then
  echo "[$(date -Iseconds)] cto-email-kpi-daemon already running" >> "$LOG_FILE"
  exit 0
fi

echo "[$(date -Iseconds)] cto-email-kpi-daemon start interval=${KPI_INTERVAL_SEC}s to=$KPI_EMAIL_TO" >> "$LOG_FILE"

while true ; do
  {
    echo "[$(date -Iseconds)] tick"
    python3 "$ASYNC_REPO/scripts/cto-email-kpi-report.py" \
      --async-repo "$ASYNC_REPO" \
      --to "$KPI_EMAIL_TO" \
      --send-if-configured \
      --git-push
  } >> "$LOG_FILE" 2>&1 || {
    echo "[$(date -Iseconds)] KPI email tick failed exit=$?" >> "$LOG_FILE"
  }
  sleep "$KPI_INTERVAL_SEC"
done
