#!/usr/bin/env python3
"""Phase 9-only Codex refill loop.

Keeps useful Phase 9 closure work running without starting Phase 10+ tasks or
HF uploads.
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
TARGET = int(os.environ.get("TARGET_CODEX", "17"))
INTERVAL = int(os.environ.get("INTERVAL_SECONDS", "60"))
REPORT_SECONDS = int(os.environ.get("REPORT_SECONDS", "900"))
MODEL = os.environ.get("MODEL", "gpt-5.5")
REASONING = os.environ.get("REASONING", "xhigh")

LOG = STATE_DIR / "phase9-11-refill-python.log"
REPORT = STATE_DIR / "phase9-11-checkpoint-status.md"
LOCK = STATE_DIR / "phase9-11-refill-python.lock"
INDEX = STATE_DIR / "phase9-11-refill-python.index"
PAUSE_FILE = STATE_DIR / "AUTONOMY_PAUSED"
ALLOW_AUTONOMY = os.environ.get("BSEBENCH_ALLOW_CODEX_AUTONOMY", "").lower() in {"1", "true", "yes"}

TASKS: list[tuple[str, str, str]] = [
    ("bsebench-datasets", "p9-tier2-profile-cache", "Phase 9 profile-axis Tier2 cache/provenance audit; local evidence only; fail closed."),
    ("bsebench-datasets", "p9-profile-source-ledger", "Phase 9 profile source-ledger completeness and machine-readable evidence audit; no downloads/uploads."),
    ("bsebench-datasets", "p9-profile-split-integrity", "Phase 9 profile train/calibration/eval split integrity checks; reject leakage."),
    ("bsebench-datasets", "p9-local-path-discovery", "Phase 9 local Tier2 path discovery and manifest reconciliation; no downloads/uploads."),
    ("bsebench-runner", "p9-profile-empirical-scheduler", "Phase 9 empirical profile dry-run scheduler; refuse all-blocked matrices."),
    ("bsebench-runner", "p9-profile-cache-smoke", "Phase 9 cache hydration smoke fixtures and fail-closed no-cache behavior."),
    ("bsebench-runner", "p9-profile-cli-acceptance", "Phase 9 CLI acceptance path for profile axis; focused tests only."),
    ("bsebench-runner", "p9-profile-failclosed-fixtures", "Phase 9 fail-closed fixtures for missing provenance/source-ledger evidence."),
    ("bsebench-stats", "p9-profile-verdict-inputs", "Phase 9 verdict-input validator; reject synthetic-only or missing source-ledger evidence."),
    ("bsebench-stats", "p9-profile-metric-contract", "Phase 9 profile metric contract checks; no SOTA/winner claims."),
    ("bsebench-stats", "p9-profile-evidence-table", "Phase 9 evidence table generator/validator for audit report inputs."),
    ("bsebench-stats", "p9-no-claims-linter", "Phase 9 no-claims linter for SOTA/winner/leaderboard wording."),
    ("bsebench-specs", "p9-schema-export-audit", "Phase 9 schema/export audit with focused fail-closed tests."),
    ("bsebench-specs", "p9-api-contract-audit", "Phase 9 plugin/API contract audit for profile-axis submission payloads."),
    ("bsebench-filters", "p9-filter-contract-audit", "Phase 9 filter contract/export audit with focused tests."),
    ("bsebench-filters", "p9-baseline-export-audit", "Phase 9 baseline filter export/import smoke tests; no leaderboard claims."),
    ("bsebench-runner", "p9-final-closure-dryrun", "Phase 9 final closure dry-run checklist: cache, provenance, split, CLI, verdict inputs."),
]


def log(message: str) -> None:
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    line = f"[{time.strftime('%Y-%m-%dT%H:%M:%S%z')}] {message}\n"
    with LOG.open("a", encoding="utf-8") as fh:
        fh.write(line)
    print(line, end="", flush=True)


def autonomy_block_reason() -> str:
    if not ALLOW_AUTONOMY:
        if PAUSE_FILE.exists():
            return f"pause_file={PAUSE_FILE}"
        return "allow_env_missing=BSEBENCH_ALLOW_CODEX_AUTONOMY"
    return ""


def autonomy_paused() -> bool:
    return bool(autonomy_block_reason())


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
    if autonomy_paused():
        log(f"LAUNCH_BLOCKED {autonomy_block_reason()}")
        return
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
            "You are a BSEBench Phase 9 closure worker. Do not work on Phase 10/11/12/13 or later.",
            f"Objective: {objective}",
            "Rules: no Co-Authored-By Claude. Commit subject must start with GLASSBOX.",
            "No Hugging Face uploads, no dataset downloads, no thesis edits, no roadmap edits, no claim-registry edits, no claim_55 edits.",
            "Scientific integrity: do not declare Phase 9 complete unless evidence supports it.",
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
        f"## Phase 9 Checkpoint Status - {time.strftime('%Y-%m-%dT%H:%M:%S%z')}",
        "",
        f"- Active unique Codex workdirs: `{len(workdirs)}` / target `{TARGET}`",
        f"- Real HF upload processes: `{upload_count()}`",
        "- Scope lock: Phase 9 only until validation checkpoint closes.",
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
    if autonomy_paused():
        log(f"PAUSED {autonomy_block_reason()} action=status_only")
        write_report(workdirs)
        return
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
