#!/usr/bin/env python3
"""Append a mobile-friendly BSEBench CTO status report and push it.

This is a lightweight GLASSBOX reporter. It checks process health, keeps phase
progress deltas across reports, and writes an append-only `CODEX STATUS` block
to docs/MOBILE_CTO_CHAT.md every 15 minutes.
"""

from __future__ import annotations

import fcntl
import json
import os
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(os.environ.get("BSEBENCH_ASYNC_REPO", "/mnt/c/doctorat/bsebench-org/bsebench-async-codex"))
STATE_DIR = Path(os.environ.get("STATE_DIR", str(Path.home() / ".local/state/bsebench-async-watchdog")))
CHAT_PATH = ROOT / "docs" / "MOBILE_CTO_CHAT.md"
STATE_PATH = STATE_DIR / "mobile-status-state.json"
LOG_PATH = STATE_DIR / "mobile-status-report.log"
LOCK_PATH = STATE_DIR / "mobile-status-report.lock"
WATCHDOG_DIR = STATE_DIR

BASE_PROGRESS = {"phase9": 63, "phase10": 59, "phase11": 52}
CAPS = {"phase9": 70, "phase10": 66, "phase11": 60}
PHASE_LABELS = {"phase9": "Phase 9", "phase10": "Phase 10", "phase11": "Phase 11"}
USER_RE = re.compile(r"^## USER\b", re.MULTILINE)
CODEX_REPLY_RE = re.compile(r"^## CODEX(?! STATUS)\b", re.MULTILINE)
FENCED_BLOCK_RE = re.compile(r"```.*?```", re.DOTALL)


def now_local() -> datetime:
    return datetime.now(timezone.utc).astimezone()


def log(message: str) -> None:
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    line = f"[{now_local().isoformat(timespec='seconds')}] {message}\n"
    with LOG_PATH.open("a", encoding="utf-8") as fh:
        fh.write(line)
    print(line, end="")


def run(args: list[str], cwd: Path | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        args,
        cwd=str(cwd) if cwd else None,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )


def git(*args: str) -> subprocess.CompletedProcess[str]:
    return run(["git", "-C", str(ROOT), *args])


def acquire_lock():
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    lock_file = LOCK_PATH.open("w", encoding="utf-8")
    try:
        fcntl.flock(lock_file.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        log("SKIP_LOCKED another_mobile_status_report_running=true")
        return None
    return lock_file


def tracked_dirty() -> bool:
    proc = git("status", "--porcelain")
    return any(line and not line.startswith("?? ") for line in proc.stdout.splitlines())


def sync_main() -> bool:
    if (ROOT / ".git" / "index.lock").exists():
        log("SKIP git_index_lock=true")
        return False
    git("fetch", "origin", "main")
    if tracked_dirty():
        log("SKIP tracked_dirty_before_rebase=true")
        return False
    proc = git("rebase", "origin/main")
    if proc.returncode != 0:
        log("SKIP rebase_failed=" + proc.stdout.strip().replace("\n", " | ")[:600])
        return False
    return True


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


def count_codex_pids(ps: str) -> int:
    return sum(1 for line in ps.splitlines() if "codex exec" in line and "awk" not in line)


def refill_running(ps: str) -> bool:
    return any("cto_phase9_11_refill_loop.py" in line and "python3" in line for line in ps.splitlines())


def upload_count(ps: str) -> int:
    count = 0
    for line in ps.splitlines():
        lower = line.lower()
        if "awk" in lower or "mobile_status_report.py" in lower:
            continue
        if ".hf-upload-stage" in lower or "hf-upload-stage" in lower:
            count += 1
        elif "huggingface-cli" in lower and " upload" in lower:
            count += 1
    return count


def load_state() -> dict:
    if not STATE_PATH.exists():
        return {
            "progress": dict(BASE_PROGRESS),
            "last_report_progress": dict(BASE_PROGRESS),
            "seen_success_logs": [str(path) for path in WATCHDOG_DIR.glob("bsebench-*-phase9-11-refill-*.log")],
        }
    try:
        state = json.loads(STATE_PATH.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return {
            "progress": dict(BASE_PROGRESS),
            "last_report_progress": dict(BASE_PROGRESS),
            "seen_success_logs": [],
        }
    state.setdefault("progress", dict(BASE_PROGRESS))
    state.setdefault("last_report_progress", dict(state["progress"]))
    state.setdefault("seen_success_logs", [])
    return state


def save_state(state: dict) -> None:
    STATE_PATH.write_text(json.dumps(state, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def phase_keys_for_log(path: Path) -> list[str]:
    name = path.name
    keys: list[str] = []
    if "-p9-" in name or "profile" in name:
        keys.append("phase9")
    if "-p10-" in name or "aging" in name:
        keys.append("phase10")
    if "-p11-" in name or "residual" in name:
        keys.append("phase11")
    if "p9-11" in name and not keys:
        keys.extend(["phase9", "phase10", "phase11"])
    return sorted(set(keys))


def success_signal(text: str) -> bool:
    lowered = text.lower()
    if "blockers: none" in lowered:
        return True
    if "git push" in lowered and "succeeded" in lowered:
        return True
    if "\nto https://github.com/" in lowered and "glassbox" in lowered:
        return True
    if " passed" in lowered and "failed" not in lowered and "error" not in lowered:
        return True
    return False


def latest_signals(limit: int = 5) -> list[str]:
    logs = sorted(
        WATCHDOG_DIR.glob("bsebench-*-phase9-11-refill-*.log"),
        key=lambda path: path.stat().st_mtime,
        reverse=True,
    )
    signals: list[str] = []
    for path in logs[:limit]:
        tail = "\n".join(path.read_text(encoding="utf-8", errors="replace").splitlines()[-8:])
        clean = " ".join(line.strip() for line in tail.splitlines() if line.strip())
        signals.append(f"{path.name}: {clean[:180]}")
    return signals


def update_progress_from_success_logs(state: dict) -> dict[str, int]:
    progress = {key: int(value) for key, value in state["progress"].items()}
    seen = set(state.get("seen_success_logs", []))
    for path in sorted(WATCHDOG_DIR.glob("bsebench-*-phase9-11-refill-*.log")):
        key = str(path)
        if key in seen:
            continue
        try:
            text = path.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        if not success_signal(text):
            continue
        phases = phase_keys_for_log(path)
        if not phases:
            continue
        for phase in phases:
            progress[phase] = min(CAPS[phase], progress.get(phase, BASE_PROGRESS[phase]) + 1)
        seen.add(key)
    state["seen_success_logs"] = sorted(seen)
    state["progress"] = progress
    return progress


def latest_user_pending(text: str) -> bool:
    text = FENCED_BLOCK_RE.sub("", text)
    last_user = None
    for match in USER_RE.finditer(text):
        last_user = match.start()
    if last_user is None:
        return False
    last_reply = None
    for match in CODEX_REPLY_RE.finditer(text):
        last_reply = match.start()
    return last_reply is None or last_user > last_reply


def format_delta(delta: int) -> str:
    if delta > 0:
        return f"+{delta}%"
    if delta < 0:
        return f"{delta}%"
    return "+0%"


def append_status_block(state: dict, workdirs: list[str], codex_pids: int, uploads: int, refill: bool) -> None:
    text = CHAT_PATH.read_text(encoding="utf-8", errors="replace")
    pending_user = latest_user_pending(text)
    progress = state["progress"]
    previous = state["last_report_progress"]
    timestamp = now_local().strftime("%Y-%m-%d %H:%M %Z")
    lines = [
        "",
        f"## CODEX STATUS {timestamp}",
        "",
        f"- Codex exec actifs: `{len(workdirs)}` workdirs uniques, `{codex_pids}` PIDs.",
        f"- Refill: `{'OK' if refill else 'MISSING'}`; target `17`; cron minute active.",
        f"- Upload HF: `{uploads}`.",
        "- Scope: Phase 9/10/11 only; Phase 12/13+ locked.",
        f"- Message USER en attente: `{'yes' if pending_user else 'no'}`.",
        f"- {PHASE_LABELS['phase9']}: `{progress['phase9']}%` ({format_delta(progress['phase9'] - previous.get('phase9', progress['phase9']))} depuis dernier status).",
        f"- {PHASE_LABELS['phase10']}: `{progress['phase10']}%` ({format_delta(progress['phase10'] - previous.get('phase10', progress['phase10']))} depuis dernier status).",
        f"- {PHASE_LABELS['phase11']}: `{progress['phase11']}%` ({format_delta(progress['phase11'] - previous.get('phase11', progress['phase11']))} depuis dernier status).",
        "- Scientific closure: `NO-GO` until cache/provenance/Tier2 empirical evidence passes.",
    ]
    signals = latest_signals()
    if signals:
        lines.append("- Recent signals:")
        lines.extend(f"  - {signal}" for signal in signals[:3])
    lines.append("")
    CHAT_PATH.write_text(text.rstrip() + "\n" + "\n".join(lines), encoding="utf-8")
    state["last_report_progress"] = dict(progress)


def commit_and_push() -> bool:
    git("add", "docs/MOBILE_CTO_CHAT.md")
    if git("diff", "--cached", "--quiet").returncode == 0:
        log("NO_COMMIT no_chat_diff=true")
        return True
    stamp = now_local().strftime("%Y-%m-%d %H:%M")
    commit = git(
        "-c",
        "user.name=Oussama Akir",
        "-c",
        "user.email=claude@cosmocomply.com",
        "commit",
        "-m",
        f"GLASSBOX: mobile CTO status {stamp}",
    )
    if commit.returncode != 0:
        log("COMMIT_FAILED " + commit.stdout.strip().replace("\n", " | ")[:600])
        return False
    push = git("push", "origin", "main")
    if push.returncode == 0:
        log("PUSH_OK")
        return True
    log("PUSH_RETRY " + push.stdout.strip().replace("\n", " | ")[:600])
    rebase = git("pull", "--rebase", "origin", "main")
    if rebase.returncode != 0:
        log("PUSH_RETRY_REBASE_FAILED " + rebase.stdout.strip().replace("\n", " | ")[:600])
        return False
    push = git("push", "origin", "main")
    ok = push.returncode == 0
    log("PUSH_OK_AFTER_REBASE" if ok else "PUSH_FAILED " + push.stdout.strip().replace("\n", " | ")[:600])
    return ok


def main() -> int:
    lock_file = acquire_lock()
    if lock_file is None:
        return 0
    if not ROOT.exists() or not CHAT_PATH.exists():
        log("ERROR repo_or_chat_missing=true")
        return 2
    if not sync_main():
        return 0
    state = load_state()
    update_progress_from_success_logs(state)
    ps = ps_output()
    append_status_block(
        state,
        active_workdirs(ps),
        count_codex_pids(ps),
        upload_count(ps),
        refill_running(ps),
    )
    save_state(state)
    commit_and_push()
    return 0


if __name__ == "__main__":
    sys.exit(main())
