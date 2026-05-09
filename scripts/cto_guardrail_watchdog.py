#!/usr/bin/env python3
"""Layered watchdog for Phase 9/10/11 Codex execution.

This script intentionally overlaps with the refill loop and cron. Its job is
not to create new task logic, but to make sure independent guardrails recover
the system if one layer stops.
"""

from __future__ import annotations

import argparse
import fcntl
import os
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(os.environ.get("BSEBENCH_ROOT", "/mnt/c/doctorat/bsebench-org"))
ASYNC_REPO = ROOT / "bsebench-async-codex"
STATE_DIR = Path(os.environ.get("STATE_DIR", str(Path.home() / ".local/state/bsebench-async-watchdog")))
TARGET = int(os.environ.get("TARGET_CODEX", "17"))
MIN_ACTIVE = int(os.environ.get("MIN_CODEX", "6"))
LOG_PATH = STATE_DIR / "cto-layered-watchdog.log"
STATUS_PATH = STATE_DIR / "cto-layered-watchdog-status.md"
LOCK_PATH = STATE_DIR / "cto-layered-watchdog.lock"
REFILL_LOG = STATE_DIR / "phase9-11-refill-python.nohup.log"
PAUSE_FILE = STATE_DIR / "AUTONOMY_PAUSED"
ALLOW_AUTONOMY = os.environ.get("BSEBENCH_ALLOW_CODEX_AUTONOMY", "").lower() in {"1", "true", "yes"}


def now() -> str:
    return datetime.now(timezone.utc).astimezone().isoformat(timespec="seconds")


def log(message: str) -> None:
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    line = f"[{now()}] {message}\n"
    with LOG_PATH.open("a", encoding="utf-8") as fh:
        fh.write(line)
    print(line, end="")


def autonomy_paused() -> bool:
    return bool(autonomy_block_reason())


def autonomy_block_reason() -> str:
    if not ALLOW_AUTONOMY:
        if PAUSE_FILE.exists():
            return f"pause_file={PAUSE_FILE}"
        return "allow_env_missing=BSEBENCH_ALLOW_CODEX_AUTONOMY"
    return ""


def run(args: list[str], cwd: Path | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        args,
        cwd=str(cwd) if cwd else None,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )


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


def refill_daemon_pids(ps: str) -> list[str]:
    pids: list[str] = []
    for line in ps.splitlines():
        if "python3 scripts/cto_phase9_11_refill_loop.py" in line and "awk" not in line:
            pids.append(line.strip().split()[0])
    return pids


def upload_count(ps: str) -> int:
    count = 0
    for line in ps.splitlines():
        lower = line.lower()
        if "awk" in lower or "cto_guardrail_watchdog.py" in lower:
            continue
        if ".hf-upload-stage" in lower or "hf-upload-stage" in lower:
            count += 1
        elif "huggingface-cli" in lower and " upload" in lower:
            count += 1
    return count


def acquire_lock():
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    lock_file = LOCK_PATH.open("w", encoding="utf-8")
    try:
        fcntl.flock(lock_file.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        log("SKIP_LOCKED another_watchdog_running=true")
        return None
    return lock_file


def run_refill_once() -> bool:
    if autonomy_paused():
        log(f"REFILL_ONCE_BLOCKED {autonomy_block_reason()}")
        return False
    proc = run(
        [
            "/usr/bin/env",
            f"BSEBENCH_ROOT={ROOT}",
            f"STATE_DIR={STATE_DIR}",
            f"TARGET_CODEX={TARGET}",
            "/usr/bin/python3",
            str(ASYNC_REPO / "scripts" / "cto_phase9_11_refill_loop.py"),
            "--once",
        ],
        cwd=ASYNC_REPO,
    )
    ok = proc.returncode == 0
    log(("REFILL_ONCE_OK" if ok else "REFILL_ONCE_FAILED") + " output=" + proc.stdout.strip().replace("\n", " | ")[:500])
    return ok


def ensure_daemon(ps: str) -> bool:
    if autonomy_paused():
        log(f"DAEMON_BLOCKED {autonomy_block_reason()}")
        return False
    if refill_daemon_pids(ps):
        return True
    with REFILL_LOG.open("ab") as out:
        subprocess.Popen(
            [
                "setsid",
                "/usr/bin/env",
                f"BSEBENCH_ROOT={ROOT}",
                f"STATE_DIR={STATE_DIR}",
                f"TARGET_CODEX={TARGET}",
                "INTERVAL_SECONDS=60",
                "REPORT_SECONDS=900",
                "/usr/bin/python3",
                "scripts/cto_phase9_11_refill_loop.py",
            ],
            cwd=str(ASYNC_REPO),
            stdin=subprocess.DEVNULL,
            stdout=out,
            stderr=subprocess.STDOUT,
            start_new_session=False,
        )
    log("DAEMON_RESTARTED")
    return True


def write_status(mode: str, active: list[str], pids: int, uploads: int, daemon_ok: bool) -> None:
    lines = [
        f"## CTO Layered Watchdog - {now()}",
        "",
        f"- Mode: `{mode}`",
        f"- Active unique Codex workdirs: `{len(active)}` / target `{TARGET}`",
        f"- Minimum acceptable: `{MIN_ACTIVE}`",
        f"- Codex-related PIDs: `{pids}`",
        f"- Refill daemon: `{'OK' if daemon_ok else 'MISSING'}`",
        f"- HF uploads: `{uploads}`",
        "- Scope lock: Phase 9/10/11 only.",
        f"- Autonomy paused: `{'yes' if autonomy_paused() else 'no'}`",
        "",
        "### Active Workdirs",
        "",
    ]
    lines.extend(f"- `{workdir}`" for workdir in active)
    STATUS_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--mode", default="guard", choices=["guard", "daemon", "audit"])
    args = parser.parse_args()

    lock_file = acquire_lock()
    if lock_file is None:
        return 0

    ps = ps_output()
    active = active_workdirs(ps)
    pids = codex_pid_count(ps)
    uploads = upload_count(ps)
    daemon_ok = bool(refill_daemon_pids(ps))
    paused = autonomy_paused()

    if paused:
        log(f"PAUSED mode={args.mode} active={len(active)} target={TARGET} action=status_only {autonomy_block_reason()}")
    elif args.mode in {"daemon", "audit"} or not daemon_ok:
        ensure_daemon(ps)
        ps = ps_output()
        daemon_ok = bool(refill_daemon_pids(ps))

    if len(active) < TARGET and not paused:
        run_refill_once()
        ps = ps_output()
        active = active_workdirs(ps)
        pids = codex_pid_count(ps)
        uploads = upload_count(ps)
        daemon_ok = bool(refill_daemon_pids(ps))

    severity = "OK"
    if len(active) < MIN_ACTIVE:
        severity = "CRITICAL"
    elif len(active) < TARGET:
        severity = "DEGRADED"
    log(
        f"{severity} mode={args.mode} active={len(active)} target={TARGET} "
        f"pids={pids} uploads={uploads} daemon={str(daemon_ok).lower()}"
    )
    write_status(args.mode, active, pids, uploads, daemon_ok)
    return 0 if severity != "CRITICAL" else 1


if __name__ == "__main__":
    sys.exit(main())
