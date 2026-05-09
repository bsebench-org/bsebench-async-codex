#!/usr/bin/env python3
"""Periodic Phase 15 monitor/refill loop for direct Codex workers."""

from __future__ import annotations

import json
import subprocess
import time
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path("/mnt/c/doctorat/bsebench-org")
ASYNC = ROOT / "bsebench-async-codex"
INBOX = ASYNC / "inbox"
STATE = Path("/home/oakir/.local/state/bsebench-phase15-direct")
LOG = STATE / "supervisor.log"
INTERVAL_SECONDS = 300
MAX_ITERATIONS = 144


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")


def log(message: str) -> None:
    STATE.mkdir(parents=True, exist_ok=True)
    with LOG.open("a", encoding="utf-8") as handle:
        handle.write(f"{utc_now()} {message}\n")


def run_script(name: str) -> subprocess.CompletedProcess[str]:
    proc = subprocess.run(
        ["python3", f"scripts/{name}"],
        cwd=ASYNC,
        text=True,
        capture_output=True,
        check=False,
    )
    log(f"{name} rc={proc.returncode} stdout={proc.stdout.strip()} stderr={proc.stderr.strip()}")
    return proc


def counts() -> dict[str, int]:
    result = {"queued": 0, "running_direct": 0, "done": 0, "error": 0}
    for path in INBOX.glob("phase-15-*/STATUS.json"):
        status = json.loads(path.read_text(encoding="utf-8"))
        value = str(status.get("status", "unknown"))
        if value in result:
            result[value] += 1
    return result


def main() -> int:
    log("phase15 supervisor start")
    for iteration in range(1, MAX_ITERATIONS + 1):
        log(f"iteration={iteration} begin")
        monitor = run_script("phase15_direct_monitor.py")
        current = counts()
        log(f"counts_after_monitor={json.dumps(current, sort_keys=True)}")

        if current["error"] > 0:
            log("error_present=true action=hold_new_launches")
        elif current["queued"] > 0:
            launch = run_script("phase15_direct_launch_ready.py")
            log(f"launch_attempted=true rc={launch.returncode}")
            current = counts()
            log(f"counts_after_launch={json.dumps(current, sort_keys=True)}")

        if current["queued"] == 0 and current["running_direct"] == 0:
            log("phase15 supervisor stop reason=no_queued_or_running")
            return 0 if current["error"] == 0 else 1

        time.sleep(INTERVAL_SECONDS)

    log("phase15 supervisor stop reason=max_iterations")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
