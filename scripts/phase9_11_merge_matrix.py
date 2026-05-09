#!/usr/bin/env python3
"""Build a Phase 9/10/11 merge matrix without checking out or merging refs."""

from __future__ import annotations

import argparse
import datetime as dt
import re
import subprocess
import sys
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path


REPOS = (
    "bsebench-datasets",
    "bsebench-runner",
    "bsebench-stats",
    "bsebench-specs",
    "bsebench-filters",
    "bsebench-async-codex",
    "bsebench-website",
)

REFILL_BRANCH_RE = re.compile(
    r"^(?:origin/)?phase9-11-refill-(?P<slug>.+)-"
    r"(?P<timestamp>\d{8}T\d{6}(?:[+-]\d{4}|Z)?)$"
)

PROTECTED_PATH_MARKERS = (
    "thesis",
    "these_lfp",
    "roadmap",
    "claim-registry",
    "claim_registry",
    "claim_55",
)


@dataclass(frozen=True)
class TaskSpec:
    phase: str
    label: str
    stage: str
    order: int
    evidence_blocker: str


TASKS: dict[str, TaskSpec] = {
    "p9-11-anti-claim-audit": TaskSpec(
        "9/10/11",
        "unsupported-claim audit",
        "guardrails",
        10,
        "blocks unsupported closure/performance wording",
    ),
    "p9-11-acceptance-gate": TaskSpec(
        "9/10/11",
        "acceptance gate",
        "guardrails",
        11,
        "separates tooling readiness from scientific closure",
    ),
    "p9-11-schema-export-audit": TaskSpec(
        "9/10/11",
        "schema/export audit",
        "shared contracts",
        20,
        "schema compatibility must validate before downstream branches",
    ),
    "p9-11-contract-export-audit": TaskSpec(
        "9/10/11",
        "filter contract/export audit",
        "shared contracts",
        21,
        "filter contract compatibility must validate before runner branches",
    ),
    "p9-tier2-profile-cache": TaskSpec(
        "9",
        "profile-axis Tier2/cache audit",
        "dataset readiness",
        30,
        "Phase 9 remains blocked by missing local Tier2/cache/provenance evidence",
    ),
    "p10-tier2-aging-cache": TaskSpec(
        "10",
        "aging/SOH Tier2/cache audit",
        "dataset readiness",
        31,
        "Phase 10 remains blocked by missing aging/SOH Tier2/cache/provenance evidence",
    ),
    "p11-tier2-residual-cache": TaskSpec(
        "11",
        "residual Tier2/cache/unit audit",
        "dataset readiness",
        32,
        "Phase 11 remains blocked by missing residual unit/cadence/cache evidence",
    ),
    "p9-11-local-path-discovery": TaskSpec(
        "9/10/11",
        "local Tier2 path discovery",
        "dataset readiness",
        33,
        "read-only path discovery is not empirical evidence",
    ),
    "p9-profile-empirical-scheduler": TaskSpec(
        "9",
        "profile empirical scheduler",
        "runner dry-run",
        40,
        "scheduler output must not be treated as empirical-run evidence",
    ),
    "p10-aging-empirical-scheduler": TaskSpec(
        "10",
        "aging/SOH empirical scheduler",
        "runner dry-run",
        41,
        "scheduler output must not be treated as empirical-run evidence",
    ),
    "p11-residual-trace-scheduler": TaskSpec(
        "11",
        "residual trace scheduler",
        "runner dry-run",
        42,
        "scheduler output must not be treated as residual trace evidence",
    ),
    "p9-11-dryrun-cli-smoke": TaskSpec(
        "9/10/11",
        "dry-run CLI smoke",
        "runner dry-run",
        43,
        "smoke fixtures do not establish scientific readiness",
    ),
    "p9-profile-verdict-inputs": TaskSpec(
        "9",
        "profile verdict-input validator",
        "stats validators",
        50,
        "requires real profile empirical artifacts plus source-ledger evidence",
    ),
    "p10-aging-verdict-inputs": TaskSpec(
        "10",
        "aging/SOH verdict-input validator",
        "stats validators",
        51,
        "requires real aging/SOH empirical artifacts plus source-ledger evidence",
    ),
    "p11-residual-verdict-inputs": TaskSpec(
        "11",
        "residual verdict-input validator",
        "stats validators",
        52,
        "requires residual trace artifacts plus source-ledger evidence",
    ),
    "p9-11-no-claims-linter": TaskSpec(
        "9/10/11",
        "no-claims linter",
        "stats validators",
        53,
        "claim language remains blocked without empirical/source-ledger evidence",
    ),
    "p9-11-checkpoint-report": TaskSpec(
        "9/10/11",
        "checkpoint report",
        "async rollup",
        60,
        "rollup must stay NO-GO until evidence gates pass",
    ),
    "p9-11-merge-matrix": TaskSpec(
        "9/10/11",
        "merge matrix",
        "async rollup",
        61,
        "coordination artifact only; it must not merge branches",
    ),
}


@dataclass(frozen=True)
class BranchRef:
    repo: str
    branch: str
    slug: str
    timestamp: dt.datetime
    sha: str
    short_sha: str
    subject: str
    author: str
    author_email: str
    committed_at: str
    changed_files: tuple[str, ...]
    body: str
    main_sha: str
    repo_dirty: bool
    already_in_main: bool

    @property
    def spec(self) -> TaskSpec:
        return TASKS.get(
            self.slug,
            TaskSpec("9/10/11", self.slug, "unclassified", 90, "unclassified branch"),
        )

    @property
    def is_empty_retry(self) -> bool:
        return self.sha == self.main_sha

    @property
    def protected_paths(self) -> tuple[str, ...]:
        protected = []
        for path in self.changed_files:
            lowered = path.lower()
            if any(marker in lowered for marker in PROTECTED_PATH_MARKERS):
                protected.append(path)
        return tuple(protected)

    @property
    def has_glassbox_subject(self) -> bool:
        return self.subject.startswith("GLASSBOX")

    @property
    def has_claude_trailer(self) -> bool:
        return bool(re.search(r"(?im)^co-authored-by:.*claude", self.body))


@dataclass(frozen=True)
class RepoProblem:
    repo: str
    problem: str


@dataclass(frozen=True)
class Matrix:
    candidates: tuple[BranchRef, ...]
    superseded_count: int
    empty_retry_count: int
    repo_problems: tuple[RepoProblem, ...]
    generated_at: str


def parse_refill_branch(refname: str) -> tuple[str, dt.datetime] | None:
    match = REFILL_BRANCH_RE.match(refname)
    if not match:
        return None
    raw_ts = match.group("timestamp")
    if raw_ts.endswith("Z"):
        raw_ts = raw_ts[:-1] + "+0000"
    return match.group("slug"), dt.datetime.strptime(raw_ts, "%Y%m%dT%H%M%S%z")


def run_git(repo_path: Path, args: list[str], *, check: bool = True) -> str:
    proc = subprocess.run(
        ["git", "-C", str(repo_path), *args],
        check=False,
        capture_output=True,
        text=True,
    )
    if check and proc.returncode != 0:
        raise RuntimeError(
            f"git -C {repo_path} {' '.join(args)} failed: {proc.stderr.strip()}"
        )
    return proc.stdout


def git_ok(repo_path: Path, args: list[str]) -> bool:
    proc = subprocess.run(
        ["git", "-C", str(repo_path), *args],
        check=False,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        text=True,
    )
    return proc.returncode == 0


def collect_repo(root: Path, repo: str) -> tuple[list[BranchRef], list[RepoProblem]]:
    repo_path = root / repo
    problems: list[RepoProblem] = []
    if not repo_path.exists() or not git_ok(repo_path, ["rev-parse", "--git-dir"]):
        return [], [RepoProblem(repo, "missing local git repository")]

    try:
        main_sha = run_git(repo_path, ["rev-parse", "origin/main"]).strip()
    except RuntimeError as exc:
        return [], [RepoProblem(repo, str(exc))]

    dirty = bool(run_git(repo_path, ["status", "--porcelain"], check=False).strip())
    if dirty:
        problems.append(RepoProblem(repo, "local base worktree has uncommitted changes"))

    refs = run_git(
        repo_path,
        [
            "for-each-ref",
            "--format=%(refname:short)%00%(objectname)%00%(committerdate:iso8601)",
            "refs/remotes/origin/phase9-11-refill-*",
        ],
    )

    branches: list[BranchRef] = []
    for line in refs.splitlines():
        if not line:
            continue
        refname, sha, committed_at = line.split("\0", 2)
        parsed = parse_refill_branch(refname)
        if parsed is None:
            continue
        slug, timestamp = parsed
        log_fields = run_git(
            repo_path,
            ["log", "-1", "--format=%H%x00%s%x00%an%x00%ae%x00%B", sha],
        ).split("\0", 4)
        _, subject, author, email, body = (log_fields + [""])[:5]
        diff = run_git(
            repo_path,
            ["diff", "--name-only", f"origin/main...{sha}"],
            check=False,
        )
        already_in_main = git_ok(repo_path, ["merge-base", "--is-ancestor", sha, "origin/main"])
        branches.append(
            BranchRef(
                repo=repo,
                branch=refname,
                slug=slug,
                timestamp=timestamp,
                sha=sha,
                short_sha=sha[:12],
                subject=subject,
                author=author,
                author_email=email,
                committed_at=committed_at,
                changed_files=tuple(path for path in diff.splitlines() if path),
                body=body,
                main_sha=main_sha,
                repo_dirty=dirty,
                already_in_main=already_in_main,
            )
        )
    return branches, problems


def select_latest_candidates(branches: list[BranchRef]) -> tuple[list[BranchRef], int, int]:
    grouped: dict[tuple[str, str], list[BranchRef]] = defaultdict(list)
    empty_retry_count = 0
    for branch in branches:
        if branch.is_empty_retry:
            empty_retry_count += 1
            continue
        if branch.already_in_main:
            continue
        grouped[(branch.repo, branch.slug)].append(branch)

    candidates: list[BranchRef] = []
    superseded_count = 0
    for group in grouped.values():
        group.sort(key=lambda item: (item.committed_at, item.timestamp, item.sha), reverse=True)
        candidates.append(group[0])
        superseded_count += len(group) - 1

    candidates.sort(key=lambda item: (item.spec.order, item.repo, item.slug))
    return candidates, superseded_count, empty_retry_count


def build_matrix(root: Path) -> Matrix:
    all_branches: list[BranchRef] = []
    repo_problems: list[RepoProblem] = []
    for repo in REPOS:
        branches, problems = collect_repo(root, repo)
        all_branches.extend(branches)
        repo_problems.extend(problems)

    candidates, superseded_count, empty_retry_count = select_latest_candidates(all_branches)
    generated_at = dt.datetime.now(dt.UTC).replace(microsecond=0).isoformat()
    return Matrix(
        candidates=tuple(candidates),
        superseded_count=superseded_count,
        empty_retry_count=empty_retry_count,
        repo_problems=tuple(repo_problems),
        generated_at=generated_at,
    )


def overlap_notes(candidates: tuple[BranchRef, ...]) -> dict[tuple[str, str], tuple[str, ...]]:
    notes: dict[tuple[str, str], list[str]] = defaultdict(list)
    by_repo: dict[str, list[BranchRef]] = defaultdict(list)
    for candidate in candidates:
        by_repo[candidate.repo].append(candidate)

    for repo_candidates in by_repo.values():
        for idx, left in enumerate(repo_candidates):
            left_files = set(left.changed_files)
            if not left_files:
                continue
            for right in repo_candidates[idx + 1 :]:
                shared = left_files.intersection(right.changed_files)
                if shared:
                    notes[(left.repo, left.slug)].append(
                        f"{right.slug}: {len(shared)} shared files"
                    )
                    notes[(right.repo, right.slug)].append(
                        f"{left.slug}: {len(shared)} shared files"
                    )
    return {key: tuple(value) for key, value in notes.items()}


def validation_state(candidate: BranchRef, overlaps: tuple[str, ...]) -> str:
    failures = []
    if not candidate.has_glassbox_subject:
        failures.append("commit subject missing GLASSBOX")
    if candidate.has_claude_trailer:
        failures.append("Claude co-author trailer")
    if candidate.protected_paths:
        failures.append("protected-path diff")
    if failures:
        return "metadata-fail: " + "; ".join(failures)
    blockers = []
    if candidate.repo_dirty:
        blockers.append("dirty local validation worktree")
    if overlaps:
        blockers.append("same-repo file overlap")
    if blockers:
        return "metadata-ok; blocked: " + "; ".join(blockers)
    return "metadata-ok; clean validation pending"


def md_escape(value: str) -> str:
    return value.replace("|", "\\|").replace("\n", " ")


def render_markdown(matrix: Matrix) -> str:
    overlaps = overlap_notes(matrix.candidates)
    lines = [
        "# Phase 9/10/11 Merge Matrix - 2026-05-09",
        "",
        f"Generated at: `{matrix.generated_at}`",
        "",
        (
            "Scope: Phase 9/10/11 closure branches only. This is a read-only "
            "matrix; no merge is performed here."
        ),
        "",
        (
            "Scientific status: NO-GO for Phase 9/10/11 closure until "
            "cache/provenance/Tier2/source-ledger/empirical-run evidence "
            "exists and replays cleanly."
        ),
        "",
        "## Summary",
        "",
        f"- Latest non-empty candidate rows: `{len(matrix.candidates)}`",
        (
            "- Superseded non-empty retry refs collapsed out of the table: "
            f"`{matrix.superseded_count}`"
        ),
        (
            "- Empty retry refs equal to `origin/main` collapsed out of the "
            f"table: `{matrix.empty_retry_count}`"
        ),
        (
            "- The current in-progress matrix branch is not counted until it "
            "is committed and pushed; rerun this script after push for an "
            "updated coordination row."
        ),
        (
            "- Final verdict or public-claim language is blocked unless the "
            "relevant empirical and source-ledger evidence is present."
        ),
    ]
    if matrix.repo_problems:
        lines.append("- Local repo blockers:")
        for problem in matrix.repo_problems:
            lines.append(f"  - `{problem.repo}`: {problem.problem}")
    lines.extend(
        [
            "",
            "## Merge Matrix",
            "",
            (
                "| Order | Repo | Stage | Phase | Task | Branch | SHA | State | "
                "Required evidence gate |"
            ),
            "| ---: | --- | --- | --- | --- | --- | --- | --- | --- |",
        ]
    )
    for candidate in matrix.candidates:
        spec = candidate.spec
        notes = overlaps.get((candidate.repo, candidate.slug), ())
        state = validation_state(candidate, notes)
        if notes:
            state = f"{state}; overlap: {', '.join(notes)}"
        lines.append(
            "| "
            + " | ".join(
                [
                    str(spec.order),
                    md_escape(candidate.repo),
                    md_escape(spec.stage),
                    md_escape(spec.phase),
                    md_escape(spec.label),
                    f"`{md_escape(candidate.branch)}`",
                    f"`{candidate.short_sha}`",
                    md_escape(state),
                    md_escape(spec.evidence_blocker),
                ]
            )
            + " |"
        )

    lines.extend(
        [
            "",
            "## Validation Order",
            "",
            "1. Fetch/prune each target repo and verify the candidate branch exists on origin.",
            (
                "2. Reject immediately if the head commit subject does not "
                "start with `GLASSBOX`, contains a `Co-Authored-By` Claude "
                "trailer, edits protected thesis/roadmap/claim paths, or "
                "contains unsupported closure/performance claim language."
            ),
            (
                "3. Validate shared contracts first: async guardrails, specs "
                "schema/export audit, then filters contract/export audit."
            ),
            (
                "4. Validate dataset readiness branches next, because runner "
                "and stats branches must fail closed on missing "
                "Tier2/cache/provenance evidence."
            ),
            (
                "5. Validate runner dry-run schedulers only after dataset "
                "evidence gates are available; dry-run output is not "
                "empirical evidence."
            ),
            (
                "6. Validate stats verdict-input branches only after empirical "
                "artifacts, source-ledger rows, and replay commands exist."
            ),
            (
                "7. Merge only one same-repo branch at a time on a clean "
                "worktree, rerunning focused tests, full non-slow tests when "
                "available, ruff check, ruff format check, and "
                "`git diff --check` after each rebase or merge rehearsal."
            ),
            "",
            "## Blockers",
            "",
            "- Do not merge from this branch.",
            (
                "- Do not mark Phase 9, Phase 10, or Phase 11 complete from "
                "these tooling branches alone."
            ),
            (
                "- Dirty local base worktrees must be resolved or replaced "
                "with clean validation worktrees before any branch-level "
                "gates are trusted."
            ),
            (
                "- Same-repo file overlaps must be handled by selecting one "
                "branch or rebasing in order; do not blindly merge retry "
                "branches."
            ),
        ]
    )
    return "\n".join(lines) + "\n"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--root",
        type=Path,
        default=Path.cwd().parent,
        help="BSEBench org root containing sibling repositories.",
    )
    parser.add_argument("--output", type=Path, help="Write markdown report to this path.")
    args = parser.parse_args(argv)

    matrix = build_matrix(args.root)
    report = render_markdown(matrix)
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(report, encoding="utf-8")
    else:
        sys.stdout.write(report)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
