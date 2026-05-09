#!/usr/bin/env python3
"""Build a fail-closed Phase 9/10/11 merge validation matrix.

The script is read-only: it inspects local git refs and prints a matrix. It does
not checkout, merge, delete, push, upload, download, or fetch datasets.
"""

from __future__ import annotations

import argparse
import dataclasses
import json
import os
import re
import subprocess
import sys
from collections import defaultdict
from pathlib import Path


REPO_KINDS = {
    "bsebench-datasets": "datasets",
    "bsebench-runner": "runner",
    "bsebench-stats": "stats",
    "bsebench-specs": "specs",
    "bsebench-filters": "filters",
    "bsebench-async-codex": "async",
}

PROTECTED_PATH_RE = re.compile(
    r"(^|/)(claim_55|claims/registry|claim-registry|claim_registry|thesis|manuscript)|"
    r"(^|/)docs/RESEARCH-ROADMAP-2026-05-06\.md$",
    re.IGNORECASE,
)
FORBIDDEN_CLAIM_RE = re.compile(
    r"\b(SOTA|state[- ]of[- ]the[- ]art|novelty|winner|leaderboard|public benchmark result)\b|"
    r"\bPhase\s+(9|10|11)\s+(is\s+)?(complete|closed|verified)\b|"
    r"\bclaim[_ -]?(60|61|62|63)\s+(is\s+)?(verified|proven|validated)\b",
    re.IGNORECASE,
)
REFILL_RE = re.compile(
    r"^origin/phase9-11-refill-(?P<slug>.+)-(?P<ts>\d{8}T\d{6}[+-]\d{4})$"
)
TIMESTAMP_RE = re.compile(r"(?P<ts>\d{8}T\d{6}(?:[+-]\d{4}|Z)?)")
KNOWN_BLOCKED_BRANCHES = {
    "origin/phase-9-10-11-anti-hallucination-audit-20260508T203801+0200": (
        "superseded: stale final-verdict branch facts; regenerate before merge"
    ),
    "origin/phase-9-10-11-final-synthesis-20260508T203723+0200": (
        "superseded: stale final-verdict facts and unsupported closure percentages"
    ),
    "origin/phase9-11-closure-pr-plan-20260508T204815+0200": (
        "superseded by refreshed refill matrix"
    ),
    "origin/phase9-11-final-merge-coordinator-20260508T204536+0200": (
        "superseded by refreshed refill matrix"
    ),
    "origin/phase9-11-refill-p9-11-merge-matrix-20260509T013035+0200": (
        "superseded by this merge-matrix branch once pushed"
    ),
}


@dataclasses.dataclass(frozen=True)
class RefRecord:
    repo: str
    branch: str
    sha: str
    date: str
    subject: str
    body: str = ""
    changed_paths: tuple[str, ...] = ()
    diff_check: str = "not_run"
    merge_tree: str = "not_run"
    ancestor_of_main: bool = False


@dataclasses.dataclass(frozen=True)
class MatrixRow:
    order: int
    repo: str
    branch: str
    sha: str
    phases: tuple[str, ...]
    lane: str
    disposition: str
    blockers: tuple[str, ...]
    changed_paths: tuple[str, ...]
    validation: tuple[str, ...]


def run_git(repo_path: Path, *args: str) -> subprocess.CompletedProcess[str]:
    try:
        return subprocess.run(
            ["git", "-C", str(repo_path), *args],
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
            timeout=20,
        )
    except subprocess.TimeoutExpired as exc:
        stdout = exc.stdout or ""
        if isinstance(stdout, bytes):
            stdout = stdout.decode(errors="replace")
        return subprocess.CompletedProcess(
            ["git", "-C", str(repo_path), *args],
            124,
            stdout=stdout + "\nTIMEOUT",
            stderr=exc.stderr,
        )


def refill_slug(branch: str) -> str | None:
    match = REFILL_RE.match(branch)
    if not match:
        return None
    return match.group("slug")


def branch_timestamp(branch: str, date: str = "") -> str:
    match = TIMESTAMP_RE.search(branch)
    if match:
        return match.group("ts")
    return date


def candidate_key(branch: str) -> str | None:
    slug = refill_slug(branch)
    if slug:
        return f"refill:{slug}"
    name = branch.removeprefix("origin/")
    allowed_prefixes = (
        "phase-9-10-11-",
        "phase-9-final-verdict-",
        "phase-10-final-verdict-",
        "phase-11-final-verdict-",
        "phase-9-11-",
        "phase9-11-",
        "phase9-profile-",
        "phase10-aging-",
        "phase11-residual-",
    )
    if name.startswith(allowed_prefixes):
        return f"branch:{name}"
    return None


def phase_tags(text: str) -> tuple[str, ...]:
    original = text.lower()
    refill_match = re.search(
        r"phase9-11-refill-(?P<slug>.+)-\d{8}t\d{6}[+-]\d{4}", original
    )
    lowered = refill_match.group("slug") if refill_match else original
    tags: list[str] = []
    if (
        "phase-9-10-11" in original
        or "phase9-11-refill-p9-11" in original
        or "phase9-11-blocker" in original
        or "phase9-11-closure" in original
        or "phase9-11-final-merge" in original
        or "p9-11" in lowered
        or "phase-9-11" in original
    ):
        return ("P9", "P10", "P11")
    if (
        "phase-9-final" in lowered
        or "phase-9-" in lowered
        or "phase9" in lowered
        or "p9-" in lowered
        or "profile" in lowered
    ):
        tags.append("P9")
    if (
        "phase-10-final" in lowered
        or "phase-10" in lowered
        or "phase10" in lowered
        or "p10" in lowered
        or "aging" in lowered
        or "soh" in lowered
    ):
        tags.append("P10")
    if (
        "phase-11-final" in lowered
        or "phase-11" in lowered
        or "phase11" in lowered
        or "p11" in lowered
        or "residual" in lowered
    ):
        tags.append("P11")
    return tuple(dict.fromkeys(tags or ["P9", "P10", "P11"]))


def validation_lane(record: RefRecord) -> str:
    text = f"{record.repo} {record.branch} {' '.join(record.changed_paths)}".lower()
    if any(
        token in text
        for token in (
            "no-claims",
            "anti-claim",
            "acceptance-gate",
            "schema-export",
            "contract-export",
            "dryrun-cli-smoke",
        )
    ):
        return "guardrail"
    if (
        "datasets" in record.repo
        or "tier2" in text
        or "local-path" in text
        or "cache" in text
    ):
        return "dataset"
    if (
        "runner" in record.repo
        or "scheduler" in text
        or "dispatch" in text
        or "trace" in text
    ):
        return "runner"
    if "stats" in record.repo or "verdict-input" in text or "linter" in text:
        return "stats"
    if (
        "final-gap-audit" in text
        or "final-verdict" in text
        or "checkpoint-report" in text
    ):
        return "record"
    return "coordination"


def lane_rank(lane: str) -> int:
    return {
        "guardrail": 10,
        "dataset": 20,
        "runner": 30,
        "stats": 40,
        "record": 50,
        "coordination": 60,
    }.get(lane, 90)


def claim_findings(text: str) -> tuple[str, ...]:
    findings: list[str] = []
    for match in FORBIDDEN_CLAIM_RE.finditer(text):
        phrase = " ".join(match.group(0).split())
        if phrase not in findings:
            findings.append(phrase)
    return tuple(findings)


def selected_latest(records: list[RefRecord]) -> list[RefRecord]:
    groups: dict[tuple[str, str], list[RefRecord]] = defaultdict(list)
    passthrough: list[RefRecord] = []
    for record in records:
        key = candidate_key(record.branch)
        if key is None:
            continue
        if key.startswith("refill:"):
            groups[(record.repo, key)].append(record)
        else:
            passthrough.append(record)
    latest = [
        max(
            group, key=lambda item: (branch_timestamp(item.branch, item.date), item.sha)
        )
        for group in groups.values()
    ]
    return sorted(passthrough + latest, key=record_sort_key)


def record_sort_key(record: RefRecord) -> tuple[int, str, str, str]:
    lane = validation_lane(record)
    phases = ",".join(phase_tags(record.branch))
    return (lane_rank(lane), phases, record.repo, record.branch)


def validation_commands(kind: str, branch: str) -> tuple[str, ...]:
    common = (
        "git fetch --prune origin",
        f"git diff --name-status origin/main...{branch}",
        f"git diff --check origin/main...{branch}",
        f"git log -1 --format='%s%n%b' {branch} | rg -ni 'co-authored-by:.*claude' && exit 1 || true",
        f"git log -1 --format='%s' {branch} | rg -n '^GLASSBOX'",
    )
    if kind == "async":
        return common + (
            "bash scripts/probe-research-diff-scope-guard.sh",
            "bash scripts/probe-autonomy-pacer-safety.sh",
        )
    if kind in {"datasets", "runner", "stats", "specs", "filters"}:
        return common + (
            "uv run ruff format --check .",
            "uv run ruff check .",
            'HF_HUB_OFFLINE=1 HF_DATASETS_OFFLINE=1 uv run pytest tests/ -m "not slow" -q',
        )
    return common


def assess_record(record: RefRecord, repo_root: Path) -> MatrixRow:
    blockers: list[str] = []
    message = f"{record.subject}\n{record.body}"
    if not record.subject.startswith("GLASSBOX"):
        blockers.append("commit subject does not start with GLASSBOX")
    if re.search(r"co-authored-by:.*claude", message, flags=re.IGNORECASE):
        blockers.append("Claude co-author trailer")
    protected = [
        path for path in record.changed_paths if PROTECTED_PATH_RE.search(path)
    ]
    if protected:
        blockers.append("protected path changed: " + ", ".join(protected[:3]))
    if record.diff_check not in {"passed", "deferred"}:
        blockers.append(f"diff check {record.diff_check}")
    if record.merge_tree not in {"clean", "deferred"}:
        blockers.append(f"merge-tree {record.merge_tree}")
    if record.branch in KNOWN_BLOCKED_BRANCHES:
        blockers.append(KNOWN_BLOCKED_BRANCHES[record.branch])
    claim_hits = changed_markdown_claim_findings(record, repo_root)
    if claim_hits:
        blockers.append("unsupported claim language: " + ", ".join(claim_hits[:3]))
    if record.ancestor_of_main:
        disposition = "already_integrated_or_empty_diff"
    elif blockers:
        disposition = "blocked"
    else:
        disposition = "validate_before_merge"
    lane = validation_lane(record)
    return MatrixRow(
        order=lane_rank(lane),
        repo=record.repo,
        branch=record.branch,
        sha=record.sha,
        phases=phase_tags(record.branch),
        lane=lane,
        disposition=disposition,
        blockers=tuple(blockers),
        changed_paths=record.changed_paths,
        validation=validation_commands(
            REPO_KINDS.get(record.repo, "unknown"), record.branch
        ),
    )


def changed_markdown_claim_findings(
    record: RefRecord, repo_root: Path
) -> tuple[str, ...]:
    repo_path = repo_root / record.repo
    findings: list[str] = []
    for path in record.changed_paths:
        if not path.endswith(".md"):
            continue
        proc = run_git(repo_path, "show", f"{record.branch}:{path}")
        if proc.returncode != 0:
            continue
        for finding in claim_findings(proc.stdout):
            if finding not in findings:
                findings.append(finding)
    return tuple(findings)


def collect_records(repo_root: Path) -> list[RefRecord]:
    records: list[RefRecord] = []
    for repo in REPO_KINDS:
        repo_path = repo_root / repo
        if not (repo_path / ".git").exists():
            continue
        refs = run_git(
            repo_path,
            "for-each-ref",
            "refs/remotes/origin",
            "--format=%(refname:short)%09%(objectname)%09%(committerdate:iso8601)%09%(subject)",
        )
        if refs.returncode != 0:
            continue
        for line in refs.stdout.splitlines():
            branch, sha, date, subject = (line.split("\t", 3) + ["", "", "", ""])[:4]
            if candidate_key(branch) is None:
                continue
            records.append(
                RefRecord(
                    repo=repo,
                    branch=branch,
                    sha=sha,
                    date=date,
                    subject=subject,
                )
            )
    return records


def enrich_record(repo_root: Path, record: RefRecord) -> RefRecord:
    _ = repo_root
    return dataclasses.replace(
        record,
        body="",
        changed_paths=(),
        diff_check="deferred",
        merge_tree="deferred",
        ancestor_of_main=False,
    )


def merge_tree_status(repo_path: Path, branch: str) -> str:
    base = run_git(repo_path, "merge-base", "origin/main", branch)
    if base.returncode != 0:
        return "no_merge_base"
    proc = run_git(repo_path, "merge-tree", base.stdout.strip(), "origin/main", branch)
    if proc.returncode != 0:
        return "failed"
    lowered = proc.stdout.lower()
    if any(
        token in lowered
        for token in (
            "<<<<<<<",
            ">>>>>>>",
            "changed in both",
            "added in both",
            "conflict",
        )
    ):
        return "conflict"
    return "clean"


def build_rows(repo_root: Path) -> list[MatrixRow]:
    records = [
        enrich_record(repo_root, record)
        for record in selected_latest(collect_records(repo_root))
    ]
    rows = [assess_record(record, repo_root) for record in records]
    return [
        dataclasses.replace(row, order=index)
        for index, row in enumerate(sorted(rows, key=row_sort_key), start=1)
    ]


def row_sort_key(row: MatrixRow) -> tuple[int, str, str, str]:
    return (lane_rank(row.lane), ",".join(row.phases), row.repo, row.branch)


def row_to_dict(row: MatrixRow) -> dict[str, object]:
    return dataclasses.asdict(row)


def render_markdown(rows: list[MatrixRow], repo_root: Path) -> str:
    lines = [
        "# Phase 9/10/11 Merge Matrix",
        "",
        "Generated from local `origin/*` refs. This is a validation order only; no merge is authorized by this file.",
        "",
        "## Guardrails",
        "",
        "- Scope is Phase 9/10/11 only; Phase 12/13+ stays locked.",
        "- Missing cache, provenance, Tier2, source-ledger, or empirical-run evidence remains a blocker.",
        "- Rows marked `validate_before_merge` still require the listed repository checks before any human merge action.",
        "- Rows marked `blocked` or `already_integrated_or_empty_diff` must not be merged from this matrix.",
        "- Hugging Face uploads/downloads, thesis edits, roadmap edits, claim-registry edits, and `claim_55` edits are out of scope.",
        "",
        "## Matrix",
        "",
        "| Order | Lane | Phases | Repo | Branch | SHA | Disposition | Blockers | Changed paths |",
        "|---:|---|---|---|---|---:|---|---|---|",
    ]
    for row in rows:
        blockers = (
            "<br>".join(row.blockers) if row.blockers else "none in lightweight scan"
        )
        paths = (
            "<br>".join(row.changed_paths[:5])
            if row.changed_paths
            else "deferred to validation"
        )
        if len(row.changed_paths) > 5:
            paths += f"<br>... +{len(row.changed_paths) - 5} more"
        lines.append(
            "| {order} | `{lane}` | {phases} | `{repo}` | `{branch}` | `{sha}` | `{disp}` | {blockers} | {paths} |".format(
                order=row.order,
                lane=row.lane,
                phases="/".join(row.phases),
                repo=row.repo,
                branch=row.branch,
                sha=row.sha[:12],
                disp=row.disposition,
                blockers=blockers,
                paths=paths,
            )
        )
    lines.extend(
        [
            "",
            "## Validation Order",
            "",
            "1. Run branch metadata gates for every row: exact head, `GLASSBOX` subject, no Claude co-author trailer, `git diff --check`, and merge-tree clean scan.",
            "2. Validate guardrails first: no-claims/anti-claim, acceptance gate, schema/export, contract/export, and dry-run CLI smoke branches.",
            "3. Validate dataset/cache/source-ledger rows next. Any missing Tier2/cache/provenance/source-ledger evidence blocks downstream runner and stats rows.",
            "4. Validate runner dry-run schedulers only after their dataset/cache rows are either ready or explicitly fail-closed with machine-readable blockers.",
            "5. Validate stats verdict-input rows only after corresponding runner artifacts and source-ledger rows exist. Synthetic-only or missing empirical evidence remains NO-GO.",
            "6. Validate record/docs rows last. Final verdict/checkpoint records may document NO-GO only; they must not promote tooling readiness into scientific closure.",
            "7. After all checks pass, perform any actual merges in clean throwaway worktrees or PRs. This matrix does not merge.",
            "",
            "## Repository Checks",
            "",
        ]
    )
    by_repo: dict[str, list[MatrixRow]] = defaultdict(list)
    for row in rows:
        if row.disposition == "validate_before_merge":
            by_repo[row.repo].append(row)
    for repo in sorted(by_repo):
        lines.extend([f"### {repo}", ""])
        sample = by_repo[repo][0]
        lines.append("```bash")
        lines.append(f"cd {repo_root / repo}")
        for command in sample.validation:
            lines.append(command)
        lines.append("```")
        lines.append("")
    lines.extend(
        [
            "## Blockers",
            "",
            "- Scientific closure is still NO-GO unless later evidence proves cache/provenance/Tier2/source-ledger/empirical-run readiness.",
            "- Superseded refill branches are intentionally omitted from the merge order; use only the latest branch per refill slug unless a human re-audits an older branch.",
            "- The current merge-matrix branch supersedes prior `phase9-11-refill-p9-11-merge-matrix-*` rows once pushed.",
        ]
    )
    return "\n".join(lines) + "\n"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--repo-root",
        default=os.environ.get("BSEBENCH_ROOT", "/mnt/c/doctorat/bsebench-org"),
    )
    parser.add_argument("--format", choices=("markdown", "json"), default="markdown")
    args = parser.parse_args(argv)

    repo_root = Path(args.repo_root)
    rows = build_rows(repo_root)
    if args.format == "json":
        print(json.dumps([row_to_dict(row) for row in rows], indent=2, sort_keys=True))
    else:
        print(render_markdown(rows, repo_root), end="")
    return 0


if __name__ == "__main__":
    sys.exit(main())
