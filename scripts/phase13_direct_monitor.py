#!/usr/bin/env python3
"""Monitor direct Phase 13 Codex launches and write async outbox summaries."""

from __future__ import annotations

import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path("/mnt/c/doctorat/bsebench-org")
ASYNC = ROOT / "bsebench-async-codex"
STATE = Path("/home/oakir/.local/state/bsebench-phase13-direct")
LAUNCH = STATE / "launch.tsv"
MOBILE = ASYNC / "docs" / "MOBILE_CTO_CHAT.md"


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")


def pid_alive(pid: int) -> bool:
    return subprocess.run(["kill", "-0", str(pid)], check=False).returncode == 0


def git(path: Path, *args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["git", "-C", str(path), *args],
        text=True,
        capture_output=True,
        check=False,
    )


def log_tail(path: Path, lines: int = 160) -> str:
    if not path.exists():
        return "(log missing)"
    data = path.read_text(errors="replace").splitlines()
    return "\n".join(data[-lines:])


def read_launch_rows() -> list[dict[str, object]]:
    rows: list[dict[str, object]] = []
    if not LAUNCH.exists():
        return rows
    for raw in LAUNCH.read_text().splitlines():
        if not raw.strip():
            continue
        phase, repo, branch, worktree, pid, log_path = raw.split("\t")
        rows.append(
            {
                "phase": phase,
                "repo": Path(repo),
                "branch": branch,
                "worktree": Path(worktree),
                "pid": int(pid),
                "log": Path(log_path),
            }
        )
    return rows


def summarize_finished(row: dict[str, object]) -> tuple[str, dict[str, object]]:
    phase = str(row["phase"])
    worktree = Path(row["worktree"])
    repo = Path(row["repo"])
    branch = str(row["branch"])
    log = Path(row["log"])

    diff = git(worktree, "diff", "--quiet", "origin/main", "HEAD")
    has_diff = diff.returncode != 0
    sha_proc = git(worktree, "rev-parse", "HEAD")
    sha = sha_proc.stdout.strip() if sha_proc.returncode == 0 else ""
    push_result = "not_attempted"
    push_stderr = ""
    if has_diff:
        push = git(worktree, "push", "-u", "origin", branch)
        push_result = "ok" if push.returncode == 0 else "push_failed"
        push_stderr = push.stderr.strip()

    final_status = "done" if has_diff and push_result == "ok" else "error"
    if not has_diff:
        final_status = "error"

    outbox = ASYNC / "outbox" / phase
    outbox.mkdir(parents=True, exist_ok=True)
    (outbox / "run.log.tail").write_text(log_tail(log), encoding="utf-8")
    summary = f"""# Phase {phase} direct-worker summary

- Direct pid: `{row["pid"]}`
- Target repo: `{repo}`
- Worktree: `{worktree}`
- Target branch: `{branch}`
- Branch SHA: `{sha or "unknown"}`
- Has diff vs `origin/main`: `{str(has_diff).lower()}`
- Push result: `{push_result}`
- Final status: `{final_status}`
- Finished: `{utc_now()}`

## Push stderr

```text
{push_stderr or "(none)"}
```

## Log tail

```text
{log_tail(log, 80)}
```
"""
    (outbox / "SUMMARY.md").write_text(summary, encoding="utf-8")
    return final_status, {
        "branch_sha": sha or None,
        "push_result": push_result,
        "direct_worktree": str(worktree),
        "direct_log": str(log),
    }


def main() -> int:
    rows = read_launch_rows()
    counts = {"running_direct": 0, "done": 0, "error": 0}
    changed = False

    for row in rows:
        phase = str(row["phase"])
        status_path = ASYNC / "inbox" / phase / "STATUS.json"
        if not status_path.exists():
            continue
        status = json.loads(status_path.read_text())
        current = status.get("status")
        if current in {"done", "error"}:
            counts[current] += 1
            continue
        if pid_alive(int(row["pid"])):
            counts["running_direct"] += 1
            continue
        final_status, extra = summarize_finished(row)
        status["status"] = final_status
        status["ts_done"] = utc_now()
        status["exit_code"] = 0 if final_status == "done" else 1
        status.update(extra)
        status_path.write_text(json.dumps(status, indent=2, sort_keys=True) + "\n")
        counts[final_status] += 1
        changed = True

    if changed:
        report = (
            f"\n## CODEX STATUS {datetime.now().strftime('%Y-%m-%d %H:%M CEST')}\n"
            f"- Phase 13 direct monitor: running `{counts['running_direct']}`, "
            f"done `{counts['done']}`, error `{counts['error']}`.\n"
            "- Workers remain claim-guarded: no empirical SOC/SOH or method-ranking claim.\n"
        )
        MOBILE.write_text(MOBILE.read_text(encoding="utf-8") + report, encoding="utf-8")
        git(ASYNC, "add", "inbox", "outbox", "docs/MOBILE_CTO_CHAT.md")
        git(ASYNC, "commit", "-m", "GLASSBOX record Phase 13 direct worker updates")
        git(ASYNC, "pull", "--rebase", "origin", "main")
        git(ASYNC, "push", "origin", "main")

    print(json.dumps(counts, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
