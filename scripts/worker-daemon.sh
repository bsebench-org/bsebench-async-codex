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

# Self-respawn : capture our own script's SHA at start. If it changes after
# a `git pull` in the inner loop, exec ourselves with the new version. This
# preserves the nohup detachment + PID semantics while picking up patches
# without manual restart. Same pattern in chef-daemon.sh.
SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_SHA_AT_START=$(sha256sum "$SCRIPT_PATH" 2>/dev/null | cut -d' ' -f1)

echo "[$(date -Iseconds)] worker daemon start"
echo "  WORKER_ID         = $WORKER_ID"
echo "  ASYNC_REPO        = $ASYNC_REPO"
echo "  WORKER_INTERVAL_SEC = $INTERVAL_SEC"
echo "  pid               = $$"
echo "  script_sha        = $SCRIPT_SHA_AT_START"
echo

# Trap SIGTERM/SIGINT to exit cleanly on pkill
trap 'echo "[$(date -Iseconds)] worker daemon stopped (signal received)" ; exit 0' TERM INT

# Helper : ensure chef-daemon is alive AND running latest disk SHA. If
# chef-daemon process is missing OR its running SHA differs from the disk
# SHA, pkill + nohup-launch a fresh chef-daemon. This breaks the
# bootstrap chicken-and-egg : chef-daemon never has to update itself,
# the worker meta-supervisor handles it.
ensure_chef_daemon_fresh() {
  local chef_script="$SCRIPT_DIR/chef-daemon.sh"
  [[ -f "$chef_script" ]] || return 0  # nothing to supervise

  local disk_sha
  disk_sha=$(sha256sum "$chef_script" 2>/dev/null | cut -d' ' -f1)
  [[ -z "$disk_sha" ]] && return 0

  local running_state="$HOME/.async-chef-daemon.running"
  local running_pid=""
  local running_sha=""
  if [[ -f "$running_state" ]] ; then
    read -r running_pid running_sha < "$running_state" 2>/dev/null || true
  fi

  # Is the recorded PID actually a live chef-daemon process ?
  local alive=0
  if [[ -n "$running_pid" ]] && kill -0 "$running_pid" 2>/dev/null ; then
    if ps -p "$running_pid" -o cmd= 2>/dev/null | grep -q 'chef-daemon.sh' ; then
      alive=1
    fi
  fi

  # Decide whether to restart
  local need_restart=0
  if [[ "$alive" -ne 1 ]] ; then
    echo "[$(date -Iseconds)] worker: chef-daemon not running, will launch"
    need_restart=1
  elif [[ -n "$running_sha" && "$running_sha" != "$disk_sha" ]] ; then
    echo "[$(date -Iseconds)] worker: chef-daemon SHA stale (running=$running_sha, disk=$disk_sha), will restart"
    need_restart=1
  fi

  if [[ "$need_restart" -eq 1 ]] ; then
    pkill -f chef-daemon.sh 2>/dev/null || true
    sleep 1
    chmod +x "$chef_script" 2>/dev/null || true
    nohup bash "$chef_script" > "$HOME/.async-chef.log" 2>&1 &
    disown 2>/dev/null || true
    echo "[$(date -Iseconds)] worker: chef-daemon launched (disk_sha=$disk_sha)"
  fi
}

while true ; do
  if [[ "$QUIET" != "1" ]] ; then
    echo "[$(date -Iseconds)] tick"
  fi

  # Self-respawn check : if our own script file changed on disk (e.g., a
  # `git pull` inside remote-worker.sh updated the working tree),
  # exec ourselves with the new version so the next tick uses it.
  current_sha=$(sha256sum "$SCRIPT_PATH" 2>/dev/null | cut -d' ' -f1)
  if [[ -n "$current_sha" && "$current_sha" != "$SCRIPT_SHA_AT_START" ]] ; then
    echo "[$(date -Iseconds)] worker daemon source changed ($SCRIPT_SHA_AT_START -> $current_sha), exec'ing new version"
    exec bash "$SCRIPT_PATH"
  fi

  WORKER_ID="$WORKER_ID" ASYNC_REPO="$ASYNC_REPO" \
    bash "$SCRIPT_DIR/remote-worker.sh" 2>&1 || \
    echo "[$(date -Iseconds)] worker-tick exit non-zero (continuing)"

  # Meta-supervision : ensure chef-daemon is alive + fresh after each tick.
  # Breaks the bootstrap chicken-and-egg (chef-daemon V1.0 never picked up
  # V1.1 / V2 / V3 because no self-respawn was in V1.0). Now the worker
  # restarts chef-daemon whenever the disk SHA changes — patches apply in
  # ≤ 60 s after push, with zero manual intervention.
  ensure_chef_daemon_fresh

  sleep "$INTERVAL_SEC"
done
