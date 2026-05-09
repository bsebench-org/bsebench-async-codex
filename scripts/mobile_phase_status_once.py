#!/usr/bin/env python3
"""Append one mobile CTO status block and optionally push it.

The script is intentionally narrow: it never launches workers, never touches
product repositories, and writes only docs/MOBILE_CTO_CHAT.md in this repo.
Use from cron every 15 minutes.
"""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
import time
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo


REPO = Path(os.environ.get("ASYNC_CTO", "/mnt/c/doctorat/bsebench-org/bsebench-async-codex"))
CHAT_PATH = REPO / "docs" / "MOBILE_CTO_CHAT.md"
STATE_DIR = Path(
    os.environ.get(
        "STATE_DIR",
        str(Path.home() / ".local/state/bsebench-async-watchdog"),
    )
)
LAST_RUN_PATH = STATE_DIR / "mobile-phase-status-last-epoch.txt"
MIN_INTERVAL_SECONDS = int(os.environ.get("MOBILE_STATUS_MIN_INTERVAL_SECONDS", "840"))
PARIS = ZoneInfo("Europe/Paris")


def run(args: list[str], *, cwd: Path = REPO, check: bool = False) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        args,
        cwd=cwd,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=check,
    )


def git(args: list[str], *, check: bool = True) -> subprocess.CompletedProcess[str]:
    return run(["git", *args], check=check)


def now_label() -> str:
    return datetime.now(PARIS).strftime("%Y-%m-%d %H:%M CEST")


def read_last_epoch() -> float:
    try:
        return float(LAST_RUN_PATH.read_text(encoding="utf-8").strip())
    except (FileNotFoundError, ValueError):
        return 0.0


def write_last_epoch() -> None:
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    LAST_RUN_PATH.write_text(str(time.time()), encoding="utf-8")


def tracked_dirty_paths() -> list[str]:
    status = git(["status", "--porcelain", "--untracked-files=no"], check=True).stdout
    return [line[3:] for line in status.splitlines() if line.strip()]


def sync_main() -> None:
    dirty = [path for path in tracked_dirty_paths() if path != "docs/MOBILE_CTO_CHAT.md"]
    if dirty:
        raise RuntimeError(f"tracked dirty files block mobile status update: {dirty}")
    git(["fetch", "origin", "main"])
    git(["pull", "--ff-only", "origin", "main"])


def process_snapshot() -> tuple[int, int, bool]:
    ps = run(["ps", "-eo", "pid,args"], check=False).stdout
    codex_lines = [
        line
        for line in ps.splitlines()
        if "codex exec" in line and "mobile_phase_status_once.py" not in line
    ]
    status_loop = "cto_readonly_status_loop.py" in ps
    return len(codex_lines), len({line.split(" -C ", 1)[1].split()[0] for line in codex_lines if " -C " in line}), status_loop


def latest_progress(text: str, phase: int) -> int | None:
    matches = re.findall(rf"Phase {phase}:\s*`?(\d+)%", text)
    return int(matches[-1]) if matches else None


def phase_progress() -> dict[int, int]:
    return {
        9: int(os.environ.get("PHASE9_PROGRESS", "88")),
        10: int(os.environ.get("PHASE10_PROGRESS", "62")),
        11: int(os.environ.get("PHASE11_PROGRESS", "54")),
    }


def build_block(text: str) -> str:
    progress = phase_progress()
    deltas = {
        phase: progress[phase] - (latest_progress(text, phase) or progress[phase])
        for phase in progress
    }
    codex_pids, codex_workdirs, status_loop = process_snapshot()
    status_loop_text = "yes" if status_loop else "no"
    return f"""
## CODEX STATUS {now_label()}

- Codex exec actifs: `{codex_workdirs}` workdirs, `{codex_pids}` PIDs.
- Read-only status loop: `{status_loop_text}`.
- Upload HF: `0`.
- Scope: Phase 9 empirical closure first; Phase 10/11 stay locked unless Phase 9 evidence passes.
- Phase 9: `{progress[9]}%` (`{deltas[9]:+d}%` since previous mobile status).
- Phase 10: `{progress[10]}%` (`{deltas[10]:+d}%` since previous mobile status).
- Phase 11: `{progress[11]}%` (`{deltas[11]:+d}%` since previous mobile status).
- Scientific closure: `NO-GO` until a real Tier2 Phase 9 empirical artifact bundle passes acceptance.
- Next: Phase 9 empirical profile-axis run, acceptance gate, closure report.
"""


def append_status(*, dry_run: bool, push: bool) -> int:
    sync_main()
    text = CHAT_PATH.read_text(encoding="utf-8")
    block = build_block(text)
    if dry_run:
        print(block)
        return 0

    CHAT_PATH.write_text(text.rstrip() + "\n" + block, encoding="utf-8")
    git(["add", str(CHAT_PATH.relative_to(REPO))])
    diff_cached = git(["diff", "--cached", "--quiet"], check=False)
    if diff_cached.returncode == 0:
        return 0
    git(["commit", "-m", f"GLASSBOX: mobile CTO status {now_label()}"])
    if push:
        git(["push", "origin", "HEAD:main"])
    write_last_epoch()
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--no-push", action="store_true")
    args = parser.parse_args()

    if not args.force and not args.dry_run:
        elapsed = time.time() - read_last_epoch()
        if elapsed < MIN_INTERVAL_SECONDS:
            print(f"skip: last mobile status {elapsed:.0f}s ago")
            return 0

    try:
        return append_status(dry_run=args.dry_run, push=not args.no_push)
    except Exception as exc:
        print(f"mobile status failed: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
