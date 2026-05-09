#!/usr/bin/env python3
"""Launch ready Phase 15 inbox entries in isolated product worktrees."""

from __future__ import annotations

import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path("/mnt/c/doctorat/bsebench-org")
ASYNC = ROOT / "bsebench-async-codex"
INBOX = ASYNC / "inbox"
STATE = Path("/home/oakir/.local/state/bsebench-phase15-direct")
LAUNCH = STATE / "launch.tsv"
MAX_LAUNCH = 7


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")


def run(args: list[str], cwd: Path | None = None, check: bool = True) -> subprocess.CompletedProcess[str]:
    proc = subprocess.run(args, cwd=cwd, text=True, capture_output=True, check=False)
    if check and proc.returncode != 0:
        raise RuntimeError(
            f"command failed rc={proc.returncode}: {' '.join(args)}\n"
            f"stdout={proc.stdout}\nstderr={proc.stderr}"
        )
    return proc


def status_files() -> list[Path]:
    return sorted(INBOX.glob("phase-15-*/STATUS.json"))


def load_status(path: Path) -> dict[str, object]:
    return json.loads(path.read_text(encoding="utf-8"))


def phase_slug(phase_id: str) -> str:
    parts = phase_id.split("-")
    if len(parts) < 5:
        return phase_id
    return "-".join(parts[3:-1])


def done_slugs() -> set[str]:
    slugs: set[str] = set()
    for path in status_files():
        status = load_status(path)
        if status.get("status") == "done":
            slugs.add(phase_slug(str(status.get("phase_id", path.parent.name))))
    return slugs


def already_launched() -> set[str]:
    if not LAUNCH.exists():
        return set()
    return {
        line.split("\t", 1)[0]
        for line in LAUNCH.read_text(encoding="utf-8").splitlines()
        if line.strip()
    }


def ready_entries() -> list[tuple[Path, dict[str, object]]]:
    done = done_slugs()
    launched = already_launched()
    ready: list[tuple[Path, dict[str, object]]] = []
    for path in status_files():
        status = load_status(path)
        phase_id = str(status["phase_id"])
        if phase_id in launched or status.get("status") != "queued":
            continue
        depends_on = [str(dep) for dep in status.get("depends_on", [])]
        if all(dep in done for dep in depends_on):
            ready.append((path, status))
    return ready


def add_dirs_for(repo: Path) -> list[str]:
    repos = [
        ROOT / "bsebench-specs",
        ROOT / "bsebench-stats",
        ROOT / "bsebench-runner",
        ROOT / "bsebench-filters",
        ROOT / "bsebench-datasets",
    ]
    args: list[str] = []
    for other in repos:
        if other != repo:
            args.extend(["--add-dir", str(other)])
    return args


def launch(status_path: Path, status: dict[str, object]) -> tuple[str, int, Path, Path]:
    phase_id = str(status["phase_id"])
    repo = Path(str(status["target_repo"]))
    branch = str(status["target_branch"])
    base_branch = str(status.get("base_branch", "main"))
    hard_wallclock_min = int(status.get("hard_wallclock_min", 120) or 120)
    brief = status_path.parent / "BRIEF.md"
    worktree = repo.parent / f"{repo.name}-{branch}"
    log = STATE / f"{phase_id}.log"

    run(["git", "-C", str(repo), "fetch", "origin", "--quiet"])
    run(["git", "-C", str(repo), "worktree", "remove", "--force", str(worktree)], check=False)
    run(["git", "-C", str(repo), "branch", "-D", branch], check=False)
    run(["git", "-C", str(repo), "worktree", "add", "-b", branch, str(worktree), f"origin/{base_branch}"])

    cmd = [
        "timeout",
        "--kill-after=30s",
        f"{hard_wallclock_min * 60}s",
        "codex",
        "exec",
        "--dangerously-bypass-approvals-and-sandbox",
        "-c",
        'model="gpt-5.5"',
        "-c",
        'model_reasoning_effort="xhigh"',
        "-C",
        str(worktree),
        *add_dirs_for(repo),
    ]
    log_handle = log.open("wb")
    prompt = brief.read_bytes()
    proc = subprocess.Popen(
        cmd,
        stdin=subprocess.PIPE,
        stdout=log_handle,
        stderr=subprocess.STDOUT,
        start_new_session=True,
    )
    assert proc.stdin is not None
    proc.stdin.write(prompt)
    proc.stdin.close()

    status["status"] = "running_direct"
    status["worker_id"] = f"direct:{proc.pid}"
    status["ts_started"] = utc_now()
    status["direct_worktree"] = str(worktree)
    status["direct_log"] = str(log)
    status_path.write_text(json.dumps(status, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    return branch, proc.pid, worktree, log


def main() -> int:
    STATE.mkdir(parents=True, exist_ok=True)
    LAUNCH.touch(exist_ok=True)
    launched: list[dict[str, object]] = []
    for status_path, status in ready_entries()[:MAX_LAUNCH]:
        branch, pid, worktree, log = launch(status_path, status)
        phase_id = str(status["phase_id"])
        repo = Path(str(status["target_repo"]))
        with LAUNCH.open("a", encoding="utf-8") as handle:
            handle.write(f"{phase_id}\t{repo}\t{branch}\t{worktree}\t{pid}\t{log}\n")
        launched.append(
            {
                "phase_id": phase_id,
                "repo": repo.name,
                "branch": branch,
                "pid": pid,
                "log": str(log),
            }
        )

    if launched:
        run(["git", "-C", str(ASYNC), "add", "inbox"])
        run(["git", "-C", str(ASYNC), "commit", "-m", "GLASSBOX launch Phase 15 direct ready workers"])
        run(["git", "-C", str(ASYNC), "pull", "--rebase", "origin", "main"])
        run(["git", "-C", str(ASYNC), "push", "origin", "main"])

    print(json.dumps({"launched": launched}, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
