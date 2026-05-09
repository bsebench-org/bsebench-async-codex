#!/usr/bin/env python3
"""Read-only BSEBench CTO status loop.

This process never launches Codex, never changes git state, and never pushes.
It exists as an independent heartbeat so status visibility survives even when
cron, mobile reporting, or the refill watchdog fails.
"""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(os.environ.get("BSEBENCH_ROOT", "/mnt/c/doctorat/bsebench-org"))
STATE_DIR = Path(os.environ.get("STATE_DIR", str(Path.home() / ".local/state/bsebench-async-watchdog")))
INTERVAL_SECONDS = int(os.environ.get("READONLY_STATUS_INTERVAL_SECONDS", "300"))
LOG_PATH = STATE_DIR / "cto-readonly-status-loop.log"
STATUS_PATH = STATE_DIR / "cto-readonly-status-loop-status.md"
PAUSE_FILE = STATE_DIR / "AUTONOMY_PAUSED"


def now() -> str:
    return datetime.now(timezone.utc).astimezone().isoformat(timespec="seconds")


def run(args: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(args, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=False)


def ps_output() -> str:
    return run(["ps", "-eo", "pid,stat,etime,args"]).stdout


def active_workdirs(ps: str) -> list[str]:
    workdirs: set[str] = set()
    for line in ps.splitlines():
        if "codex exec" not in line or "awk" in line:
            continue
        match = re.search(r" -C (\S+)", line)
        if match:
            workdirs.add(match.group(1))
    return sorted(workdirs)


def codex_pid_count(ps: str) -> int:
    return sum(1 for line in ps.splitlines() if "codex exec" in line and "awk" not in line)


def matching_processes(ps: str) -> list[str]:
    needles = (
        "codex exec",
        "cto_phase9_11_refill_loop.py",
        "cto_guardrail_watchdog.py",
        "mobile_status_report.py",
        "mobile_chat_watch.py",
        "cto_readonly_status_loop.py",
    )
    return [line for line in ps.splitlines() if any(needle in line for needle in needles) and "awk" not in line]


def upload_count(ps: str) -> int:
    count = 0
    for line in ps.splitlines():
        lower = line.lower()
        if ".hf-upload-stage" in lower or "hf-upload-stage" in lower:
            count += 1
        elif "huggingface-cli" in lower and " upload" in lower:
            count += 1
    return count


def write_status() -> None:
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    ps = ps_output()
    workdirs = active_workdirs(ps)
    processes = matching_processes(ps)
    lines = [
        f"## CTO Read-Only Status Loop - {now()}",
        "",
        f"- Active Codex workdirs: `{len(workdirs)}`",
        f"- Codex-related PIDs: `{codex_pid_count(ps)}`",
        f"- HF upload processes: `{upload_count(ps)}`",
        f"- Autonomy paused: `{'yes' if PAUSE_FILE.exists() else 'no'}`",
        f"- Repo root: `{ROOT}`",
        "",
        "### Active Workdirs",
        "",
    ]
    lines.extend(f"- `{workdir}`" for workdir in workdirs)
    lines.extend(["", "### Matching Processes", "", "```"])
    lines.extend(processes[:120])
    lines.append("```")
    STATUS_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")
    with LOG_PATH.open("a", encoding="utf-8") as fh:
        fh.write(f"[{now()}] STATUS active={len(workdirs)} pids={codex_pid_count(ps)} paused={PAUSE_FILE.exists()}\n")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--once", action="store_true")
    args = parser.parse_args()

    write_status()
    if args.once:
        return 0
    while True:
        time.sleep(INTERVAL_SECONDS)
        write_status()


if __name__ == "__main__":
    sys.exit(main())
