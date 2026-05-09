#!/usr/bin/env python3
"""Phase 9/10/11-only Codex refill loop.

Keeps useful work running without starting Phase 12/13+ tasks or HF uploads.
"""

from __future__ import annotations

import argparse
import fcntl
import os
import shlex
import subprocess
import sys
import time
from pathlib import Path


ROOT = Path(os.environ.get("BSEBENCH_ROOT", "/mnt/c/doctorat/bsebench-org"))
STATE_DIR = Path(os.environ.get("STATE_DIR", "/home/oakir/.local/state/bsebench-async-watchdog"))
TARGET = int(os.environ.get("TARGET_CODEX", "18"))
INTERVAL = int(os.environ.get("INTERVAL_SECONDS", "60"))
REPORT_SECONDS = int(os.environ.get("REPORT_SECONDS", "900"))
MODEL = os.environ.get("MODEL", "gpt-5.5")
REASONING = os.environ.get("REASONING", "xhigh")

LOG = STATE_DIR / "phase9-11-refill-python.log"
REPORT = STATE_DIR / "phase9-11-checkpoint-status.md"
LOCK = STATE_DIR / "phase9-11-refill-python.lock"
INDEX = STATE_DIR / "phase9-11-refill-python.index"

TASKS: list[tuple[str, str, str]] = [
    ("bsebench-datasets", "p9-tier2-profile-cache", "Phase 9 profile-axis Tier2 cache/provenance audit; local evidence only; fail closed."),
    ("bsebench-datasets", "p10-tier2-aging-cache", "Phase 10 aging/SOH Tier2 cache/provenance audit; local evidence only; fail closed."),
    ("bsebench-datasets", "p11-tier2-residual-cache", "Phase 11 residual Tier2 unit/cadence/cache audit; local evidence only; fail closed."),
    ("bsebench-runner", "p9-profile-empirical-scheduler", "Phase 9 empirical profile dry-run scheduler; refuse all-blocked matrices."),
    ("bsebench-runner", "p10-aging-empirical-scheduler", "Phase 10 aging/SOH dry-run scheduler; require split/cache/provenance evidence."),
    ("bsebench-runner", "p11-residual-trace-scheduler", "Phase 11 residual trace dry-run scheduler; require units/cadence/components."),
    ("bsebench-stats", "p9-profile-verdict-inputs", "Phase 9 verdict-input validator; reject synthetic-only or missing source-ledger evidence."),
    ("bsebench-stats", "p10-aging-verdict-inputs", "Phase 10 verdict-input validator; require aging/SOH empirical evidence."),
    ("bsebench-stats", "p11-residual-verdict-inputs", "Phase 11 verdict-input validator; require residual trace evidence."),
    ("bsebench-specs", "p9-11-schema-export-audit", "Phase 9/10/11 schema/export audit with focused fail-closed tests."),
    ("bsebench-filters", "p9-11-contract-export-audit", "Phase 9/10/11 filter contract/export audit with focused tests."),
    ("bsebench-datasets", "p9-11-local-path-discovery", "Phase 9/10/11 local Tier2 path discovery; no downloads/uploads."),
    ("bsebench-runner", "p9-11-dryrun-cli-smoke", "Phase 9/10/11 dry-run CLI smoke fixtures; no expensive filters."),
    ("bsebench-stats", "p9-11-no-claims-linter", "Phase 9/10/11 no-claims linter for SOTA/winner/leaderboard wording."),
]


def log(message: str) -> None:
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    line = f"[{time.strftime('%Y-%m-%dT%H:%M:%S%z')}] {message}\n"
    with LOG.open("a", encoding="utf-8") as fh:
        fh.write(line)
    print(line, end="", flush=True)


def active_workdirs() -> list[str]:
    proc = subprocess.run(
        ["pgrep", "-af", r"codex exec|/usr/bin/codex|@openai/codex"],
        text=True,
        capture_output=True,
        check=False,
    )
    seen: list[str] = []
    for line in proc.stdout.splitlines():
        if "pgrep" in line or "cto_phase9_11_refill_loop.py" in line:
            continue
        try:
            parts = shlex.split(line)
        except ValueError:
            parts = line.split()
        workdir = None
        for idx, token in enumerate(parts):
            if token in {"-C", "--cd"} and idx + 1 < len(parts):
                workdir = parts[idx + 1]
                break
        if workdir and str(ROOT) in workdir and workdir not in seen:
            seen.append(workdir)
    return seen


def upload_count() -> int:
    proc = subprocess.run(["ps", "-eo", "comm=,args="], text=True, capture_output=True, check=False)
    count = 0
    for line in proc.stdout.splitlines():
        if line.startswith(("bash ", "awk ")):
            continue
        if ".hf-upload-stage" in line or "hf-upload-stage" in line:
            count += 1
        elif "huggingface-cli" in line and " upload" in line:
            count += 1
    return count


def next_task() -> tuple[str, str, str]:
    try:
        idx = int(INDEX.read_text(encoding="utf-8").strip())
    except Exception:
        idx = 0
    task = TASKS[idx % len(TASKS)]
    INDEX.write_text(f"{idx + 1}\n", encoding="utf-8")
    return task


def launch_one() -> None:
    repo, slug, objective = next_task()
    base = ROOT / repo
    if not (base / ".git").exists():
        log(f"SKIP missing_repo repo={repo}")
        return
    ts = time.strftime("%Y%m%dT%H%M%S%z")
    branch = f"phase9-11-refill-{slug}-{ts}"
    worktree = ROOT / f"{repo}-{branch}"
    run_log = STATE_DIR / f"{repo}-{branch}.log"

    if worktree.exists():
        log(f"SKIP existing_worktree worktree={worktree}")
        return

    cmd = ["git", "-C", str(base), "worktree", "add", "-q", "-b", branch, str(worktree), "HEAD"]
    result = subprocess.run(cmd, text=True, capture_output=True, check=False)
    if result.returncode != 0:
        log(f"LAUNCH_FAIL repo={repo} branch={branch} step=worktree_add stderr={result.stderr.strip()!r}")
        return

    prompt = "\n".join(
        [
            "You are a BSEBench Phase 9/10/11 closure worker. Do not work on Phase 12/13 or later.",
            f"Objective: {objective}",
            "Rules: no Co-Authored-By Claude. Commit subject must start with GLASSBOX.",
            "No Hugging Face uploads, no dataset downloads, no thesis edits, no roadmap edits, no claim-registry edits, no claim_55 edits.",
            "Scientific integrity: do not declare Phase 9/10/11 complete unless evidence supports it.",
            "Fail closed on missing cache/provenance/Tier2/source-ledger/empirical-run evidence.",
            "No SOTA, novelty, winner, leaderboard, or public benchmark claims.",
            "Inspect existing code/tests first, keep scope narrow, add focused tests, run ruff/format/diff checks available in this repo.",
            f"Commit and push origin/{branch} if possible. Final response must include commit SHA, files changed, validation results, and blockers.",
        ]
    )
    with run_log.open("wb") as out:
        proc = subprocess.Popen(
            [
                "timeout",
                "--kill-after=30s",
                "7200s",
                "codex",
                "exec",
                "--dangerously-bypass-approvals-and-sandbox",
                "-c",
                f'model="{MODEL}"',
                "-c",
                f'model_reasoning_effort="{REASONING}"',
                "-C",
                str(worktree),
                "--add-dir",
                str(ROOT / "bsebench-runner"),
                "--add-dir",
                str(ROOT / "bsebench-stats"),
                "--add-dir",
                str(ROOT / "bsebench-datasets"),
                "--add-dir",
                str(ROOT / "bsebench-specs"),
                "--add-dir",
                str(ROOT / "bsebench-filters"),
                "--add-dir",
                str(ROOT / "bsebench-async-codex"),
            ],
            stdin=subprocess.PIPE,
            stdout=out,
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )
        assert proc.stdin is not None
        proc.stdin.write(prompt.encode("utf-8"))
        proc.stdin.close()
    log(f"LAUNCHED repo={repo} branch={branch} pid={proc.pid} log={run_log}")


def write_report(workdirs: list[str]) -> None:
    lines = [
        f"## Phase 9/10/11 Checkpoint Status - {time.strftime('%Y-%m-%dT%H:%M:%S%z')}",
        "",
        f"- Active unique Codex workdirs: `{len(workdirs)}` / target `{TARGET}`",
        f"- Real HF upload processes: `{upload_count()}`",
        "- Scope lock: Phase 9/10/11 only until validation checkpoint closes.",
        "- Scientific status: NO-GO until cache/provenance/Tier2 empirical evidence passes.",
        "",
        "### Active Workdirs",
        "",
    ]
    lines.extend(f"- `{wd}`" for wd in workdirs)
    REPORT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    with LOG.open("a", encoding="utf-8") as fh:
        fh.write(REPORT.read_text(encoding="utf-8"))


def tick() -> None:
    workdirs = active_workdirs()
    uploads = upload_count()
    log(f"TICK active={len(workdirs)} target={TARGET} uploads={uploads}")
    if uploads:
        log(f"UPLOAD_GUARD uploads={uploads} action=no_upload_refill_only")
    while len(workdirs) < TARGET:
        try:
            launch_one()
        except Exception as exc:  # noqa: BLE001
            log(f"LAUNCH_EXCEPTION type={type(exc).__name__} message={exc}")
        time.sleep(1)
        workdirs = active_workdirs()
    write_report(workdirs)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--once", action="store_true")
    args = parser.parse_args()

    STATE_DIR.mkdir(parents=True, exist_ok=True)
    with LOCK.open("w", encoding="utf-8") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            return 0
        log(f"START phase9-11-python target={TARGET} interval={INTERVAL} report={REPORT_SECONDS}")
        if args.once:
            tick()
            return 0
        last_report = 0.0
        while True:
            tick()
            now = time.time()
            if now - last_report >= REPORT_SECONDS:
                write_report(active_workdirs())
                last_report = now
            time.sleep(INTERVAL)


if __name__ == "__main__":
    sys.exit(main())
