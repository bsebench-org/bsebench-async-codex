#!/usr/bin/env python3
"""Poll the GitHub-backed mobile CTO chat for new USER messages.

The script is intentionally conservative: it only pulls the async repo and logs
whether the latest USER block still needs a CODEX reply. It does not edit the
chat itself and does not launch extra workers, so it cannot create merge loops or
consume Codex slots unexpectedly.
"""

from __future__ import annotations

import hashlib
import os
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(os.environ.get("BSEBENCH_ASYNC_REPO", "/mnt/c/doctorat/bsebench-org/bsebench-async-codex"))
CHAT_PATH = ROOT / "docs" / "MOBILE_CTO_CHAT.md"
STATE_DIR = Path(os.environ.get("STATE_DIR", str(Path.home() / ".local/state/bsebench-async-watchdog")))
STATE_PATH = STATE_DIR / "mobile-chat-last-user-sha256.txt"
LOG_PATH = STATE_DIR / "mobile-chat-watch.log"


USER_RE = re.compile(r"^## USER\b", re.MULTILINE)
CODEX_RE = re.compile(r"^## CODEX\b", re.MULTILINE)
FENCED_BLOCK_RE = re.compile(r"```.*?```", re.DOTALL)


def log(message: str) -> None:
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    now = datetime.now(timezone.utc).astimezone().isoformat(timespec="seconds")
    line = f"[{now}] {message}\n"
    with LOG_PATH.open("a", encoding="utf-8") as fh:
        fh.write(line)
    print(line, end="")


def run_git(*args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["git", "-C", str(ROOT), *args],
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )


def tracked_dirty() -> bool:
    proc = run_git("status", "--porcelain")
    for line in proc.stdout.splitlines():
        if line and not line.startswith("?? "):
            return True
    return False


def pull_main_if_safe() -> None:
    run_git("fetch", "origin", "main")
    if tracked_dirty():
        log("SKIP_PULL tracked_dirty=true")
        return
    proc = run_git("rebase", "origin/main")
    if proc.returncode != 0:
        log("PULL_REBASE_FAILED " + proc.stdout.strip().replace("\n", " | ")[:600])
        return
    log("PULL_REBASE_OK")


def latest_user_block(text: str) -> tuple[str, bool] | None:
    text = FENCED_BLOCK_RE.sub("", text)
    matches = list(USER_RE.finditer(text))
    if not matches:
        return None
    start = matches[-1].start()
    block = text[start:]
    code_replied = CODEX_RE.search(block) is not None
    return block.strip(), code_replied


def main() -> int:
    if not ROOT.exists():
        log(f"ERROR repo_missing={ROOT}")
        return 2
    pull_main_if_safe()
    if not CHAT_PATH.exists():
        log(f"ERROR chat_missing={CHAT_PATH}")
        return 2

    block_info = latest_user_block(CHAT_PATH.read_text(encoding="utf-8", errors="replace"))
    if block_info is None:
        log("NO_USER_MESSAGES")
        return 0

    block, code_replied = block_info
    digest = hashlib.sha256(block.encode("utf-8")).hexdigest()
    previous = STATE_PATH.read_text(encoding="utf-8").strip() if STATE_PATH.exists() else ""
    status = "REPLIED" if code_replied else "NEEDS_CODEX_REPLY"
    changed = digest != previous
    if changed:
        STATE_PATH.write_text(digest + "\n", encoding="utf-8")
    log(f"{status} latest_user_sha256={digest[:16]} changed={str(changed).lower()}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
