#!/usr/bin/env bash
# worker-daemon.sh — userspace worker loop. No system cron required.
#
# This is the SIMPLE alternative to setting up cron / Task Scheduler /
# /etc/wsl.conf. One bash process, one sleep, runs as long as WSL2 (or
# native shell) is alive.
#
# Usage (start) :
#   cd /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts
#   nohup bash worker-daemon.sh > ~/.async-worker.log 2>&1 &
#   echo "worker daemon started, PID $!"
#
# Usage (stop) :
#   pkill -f worker-daemon.sh
#
# Usage (monitor) :
#   tail -f ~/.async-worker.log
#
# Usage (auto-start on next shell — optional, append to ~/.bashrc) :
#   if ! pgrep -f worker-daemon.sh > /dev/null ; then
#     nohup bash /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/worker-daemon.sh \
#       > ~/.async-worker.log 2>&1 &
#   fi
#
# Configuration via env vars :
#   WORKER_ID            : worker name in workers/<id>.json (default: france-personal)
#   ASYNC_REPO           : local path to bsebench-async-codex clone (default: detected)
#   WORKER_INTERVAL_SEC  : seconds between ticks (default: 60 ; user mandate suggests 60-900 OK)
#   QUIET                : if set to 1, suppress per-tick "no queued" messages

set -uo pipefail

INTERVAL_SEC="${WORKER_INTERVAL_SEC:-60}"
QUIET="${QUIET:-0}"
WORKER_ID="${WORKER_ID:-france-personal}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ASYNC_REPO="${ASYNC_REPO:-$(cd "$SCRIPT_DIR/.." && pwd)}"

# Sanity : worker script must exist
if [[ ! -f "$SCRIPT_DIR/remote-worker.sh" ]] ; then
  echo "[$(date -Iseconds)] FATAL : $SCRIPT_DIR/remote-worker.sh not found" >&2
  exit 1
fi

echo "[$(date -Iseconds)] worker daemon start"
echo "  WORKER_ID         = $WORKER_ID"
echo "  ASYNC_REPO        = $ASYNC_REPO"
echo "  WORKER_INTERVAL_SEC = $INTERVAL_SEC"
echo "  pid               = $$"
echo

# Trap SIGTERM/SIGINT to exit cleanly on pkill
trap 'echo "[$(date -Iseconds)] worker daemon stopped (signal received)" ; exit 0' TERM INT

while true ; do
  if [[ "$QUIET" != "1" ]] ; then
    echo "[$(date -Iseconds)] tick"
  fi
  WORKER_ID="$WORKER_ID" ASYNC_REPO="$ASYNC_REPO" \
    bash "$SCRIPT_DIR/remote-worker.sh" 2>&1 || \
    echo "[$(date -Iseconds)] worker-tick exit non-zero (continuing)"
  sleep "$INTERVAL_SEC"
done
