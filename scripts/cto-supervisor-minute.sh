#!/usr/bin/env bash
# One-minute CTO supervisor tick.
#
# Kept intentionally short so crontab does not need long inline env commands.

set -euo pipefail

export BSEBENCH_ROOT="${BSEBENCH_ROOT:-/mnt/c/doctorat/bsebench-org}"
export ASYNC_CTO="${ASYNC_CTO:-$BSEBENCH_ROOT/bsebench-async-codex}"
export STATE_DIR="${STATE_DIR:-/home/oakir/.local/state/bsebench-async-watchdog}"
export INTERVAL_SECONDS="${INTERVAL_SECONDS:-60}"
export DURATION_SECONDS="${DURATION_SECONDS:-120}"
export MIN_UNIQUE_CODEX_EXEC="${MIN_UNIQUE_CODEX_EXEC:-6}"
export MIN_PRODUCT_CODEX_EXEC="${MIN_PRODUCT_CODEX_EXEC:-9}"
export MIN_RESERVE="${MIN_RESERVE:-6}"
export MAX_QUEUE_PER_TICK="${MAX_QUEUE_PER_TICK:-3}"

mkdir -p "$STATE_DIR"

exec bash "$BSEBENCH_ROOT/bsebench-async-codex/scripts/cto-supervisor-10h.sh" --once \
  >> "$STATE_DIR/supervisor-1min.cron.log" 2>&1
