#!/usr/bin/env python3
"""Queue the Phase 15 opening wave with disjoint worker scopes."""

from __future__ import annotations

import json
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path("/mnt/c/doctorat/bsebench-org")
ASYNC = ROOT / "bsebench-async-codex"


@dataclass(frozen=True)
class Task:
    slug: str
    repo: str
    role: str
    owned_paths: tuple[str, ...]
    objective: str
    validation_hint: str
    depends_on: tuple[str, ...] = ()
    hard_wallclock_min: int = 120


TASKS: tuple[Task, ...] = (
    Task(
        slug="specs-adaptive-filter-schema",
        repo="bsebench-specs",
        role="phase15-specs-adaptive-filter-schema",
        owned_paths=(
            "schemas/phase15_adaptive_filter.schema.json",
            "src/bsebench_specs/phase15_adaptive_filter.py",
            "tests/test_phase15_adaptive_filter.py",
        ),
        objective=(
            "Define a fail-closed Phase 15 adaptive-filter contract for online "
            "update rules, calibration/evaluation split separation, residual access, "
            "learning-rate bounds, and NO_GO_CLAIM status."
        ),
        validation_hint="Run focused pytest for the new schema/model tests plus schema export checks if local patterns exist.",
    ),
    Task(
        slug="filters-ema-bias-correction",
        repo="bsebench-filters",
        role="phase15-filters-ema-bias-correction",
        owned_paths=(
            "src/bsebench_filters/phase15_ema_bias_correction.py",
            "tests/test_phase15_ema_bias_correction.py",
        ),
        objective=(
            "Implement a deterministic EMA residual-bias correction helper for supplied "
            "synthetic residual streams. Validate alpha bounds, finite residuals, reset "
            "behavior, and claim-ineligible output."
        ),
        validation_hint="Run focused pytest for EMA update paths, reset paths, non-finite rejection, and ruff on touched files.",
    ),
    Task(
        slug="filters-residual-predictor-contract",
        repo="bsebench-filters",
        role="phase15-filters-residual-predictor-contract",
        owned_paths=(
            "src/bsebench_filters/phase15_residual_predictor_contract.py",
            "tests/test_phase15_residual_predictor_contract.py",
        ),
        objective=(
            "Implement a residual-predictor manifest contract. It may describe neural "
            "or non-neural predictor metadata, but must not train, import ML frameworks, "
            "or execute predictors on real traces."
        ),
        validation_hint="Run focused pytest for allowed metadata, forbidden training/execution fields, and JSON-safe diagnostics.",
    ),
    Task(
        slug="filters-adaptation-safety",
        repo="bsebench-filters",
        role="phase15-filters-adaptation-safety",
        owned_paths=(
            "src/bsebench_filters/phase15_adaptation_safety.py",
            "tests/test_phase15_adaptation_safety.py",
        ),
        objective=(
            "Implement an adaptation safety/leakage gate requiring calibration/test "
            "separation, no future label access, bounded online updates, reset policy, "
            "and explicit NO_GO_CLAIM."
        ),
        validation_hint="Run focused pytest for ready synthetic traces and fail-closed leakage, split overlap, missing reset, and non-finite inputs.",
        depends_on=("filters-ema-bias-correction", "filters-residual-predictor-contract"),
    ),
    Task(
        slug="stats-adaptive-delta-gate",
        repo="bsebench-stats",
        role="phase15-stats-adaptive-delta-gate",
        owned_paths=(
            "src/bsebench_stats/phase15_adaptive_delta_gate.py",
            "tests/test_phase15_adaptive_delta_gate.py",
        ),
        objective=(
            "Implement a paired adaptive-delta gate over supplied baseline/adaptive "
            "metric artifacts. It validates finite paired rows and uncertainty inputs "
            "but refuses improvement claims by default."
        ),
        validation_hint="Run focused pytest for paired finite deltas, missing baseline/adaptive rows, and unsupported claim flags.",
    ),
    Task(
        slug="stats-adaptive-report-gate",
        repo="bsebench-stats",
        role="phase15-stats-adaptive-report-gate",
        owned_paths=(
            "src/bsebench_stats/phase15_adaptive_report_gate.py",
            "tests/test_phase15_adaptive_report_gate.py",
        ),
        objective=(
            "Implement a Phase 15 report gate that blocks RMSE-gain, >20% improvement, "
            "adaptive superiority, SOTA, and leaderboard wording unless a later audited "
            "verdict artifact authorizes it."
        ),
        validation_hint="Run focused pytest for forbidden wording, neutral reports, authorized/no-claim payloads, and git diff --check.",
        depends_on=("stats-adaptive-delta-gate",),
    ),
    Task(
        slug="runner-adaptive-plan",
        repo="bsebench-runner",
        role="phase15-runner-adaptive-plan",
        owned_paths=(
            "src/bsebench_runner/phase15_adaptive_plan.py",
            "tests/test_phase15_adaptive_plan.py",
        ),
        objective=(
            "Implement an adaptive-learning dry-run plan that records required baseline, "
            "calibration split, evaluation split, update rule, residual source, and "
            "safety gate inputs while refusing estimator execution."
        ),
        validation_hint="Run focused pytest for ready synthetic metadata and blocked missing calibration/evaluation evidence.",
    ),
    Task(
        slug="runner-adaptive-dryrun-cli",
        repo="bsebench-runner",
        role="phase15-runner-adaptive-dryrun-cli",
        owned_paths=(
            "src/bsebench_runner/phase15_adaptive_dry_run_cli.py",
            "tests/test_phase15_adaptive_dry_run_cli.py",
        ),
        objective=(
            "Add a dry-run CLI/helper for Phase 15 adaptive-plan JSON validation. "
            "It must not run filters, train predictors, derive SOC, download data, "
            "or claim gains."
        ),
        validation_hint="Run focused pytest for CLI success/failure, no execution side effects, and git diff --check.",
        depends_on=("runner-adaptive-plan",),
    ),
    Task(
        slug="datasets-calibration-evidence",
        repo="bsebench-datasets",
        role="phase15-datasets-calibration-evidence",
        owned_paths=(
            "src/bsebench_datasets/phase15_calibration_evidence.py",
            "tests/test_phase15_calibration_evidence.py",
        ),
        objective=(
            "Implement a calibration split evidence gate requiring source hashes, "
            "split IDs, non-overlap with evaluation windows, residual availability "
            "scope, and no adaptive-performance claim."
        ),
        validation_hint="Run focused pytest for ready synthetic split evidence and blocked overlap/missing provenance.",
    ),
    Task(
        slug="stats-synthetic-ema-fixtures",
        repo="bsebench-stats",
        role="phase15-stats-synthetic-ema-fixtures",
        owned_paths=(
            "tests/fixtures/phase15_ema_adaptation/README.md",
            "tests/fixtures/phase15_ema_adaptation/scalar_bias_fixture.json",
            "tests/test_phase15_synthetic_ema.py",
        ),
        objective=(
            "Add claim-ineligible synthetic EMA adaptation fixtures that connect the "
            "filter helper and paired-delta gate without using real battery data."
        ),
        validation_hint="Run focused pytest for fixture schema, finite values, paired deltas, and fail-closed mutations.",
        depends_on=("filters-ema-bias-correction", "stats-adaptive-delta-gate"),
    ),
    Task(
        slug="website-phase15-page",
        repo="bsebench-website",
        role="phase15-website-status",
        owned_paths=(
            "src/content/docs/phase15-adaptive-learning.md",
            "astro.config.mjs",
        ),
        objective=(
            "Add a public Phase 15 status page explaining that adaptive-learning work "
            "is tooling/preflight only and remains NO_GO_CLAIM."
        ),
        validation_hint="Run npm build or the smallest available website build check.",
    ),
)


COMMON_ADD_DIRS = (
    ROOT / "bsebench-specs",
    ROOT / "bsebench-stats",
    ROOT / "bsebench-runner",
    ROOT / "bsebench-filters",
    ROOT / "bsebench-datasets",
)


def brief_for(task: Task, phase_id: str, target_branch: str) -> str:
    add_dirs = tuple(str(path) for path in COMMON_ADD_DIRS if path.name != task.repo)
    owned = "\n".join(f"- `{path}`" for path in task.owned_paths)
    add_dir_block = "\n".join(f"  - {path}" for path in add_dirs)
    depends = ", ".join(task.depends_on) if task.depends_on else "none"
    return f"""---
target_repo: {ROOT / task.repo}
target_branch: {target_branch}
base_branch: main
hard_wallclock_min: {task.hard_wallclock_min}
add_dir:
{add_dir_block}
---

# {phase_id}

You are a BSEBench Phase 15 product worker. This is real product work toward
adaptive filter-learning readiness, not activity padding.

## Mission

{task.objective}

## Owned Scope

Repository: `{task.repo}`

You own only these paths unless an import/export file must be minimally touched
to expose the new module:

{owned}

Dependencies: {depends}

Do not edit unrelated files. Do not revert user or other-worker changes.

## Scientific Integrity Rules

- Treat Phase 15 as adaptive tooling/preflight only.
- Do not claim RMSE gain, >20% improvement, SOTA, filter superiority, SOC/SOH
  performance, transfer success, leaderboard status, or universal validity.
- Use synthetic fixtures unless explicit split/provenance evidence is already
  supplied by the task. This task has no permission to execute estimators.
- No neural training, no Hugging Face upload, no dataset download.
- No thesis repo edits, no claim registry edits, no roadmap edits.
- Commit subject must start exactly with: `GLASSBOX [role: {task.role}]`
- Do not add `Co-Authored-By Claude`.

## Expected Deliverable

- Production code, schema, fixture, or documentation in the owned paths.
- Focused tests in the owned test path when applicable.
- Fail-closed behavior for missing evidence, non-finite values, split leakage,
  invalid hashes, unsupported claims, or forbidden adaptive-gain wording.
- A final commit pushed to `{target_branch}`.

## Validation

{task.validation_hint}

Also run `git diff --check`. If a broader project check is cheap, run it too.
Report any skipped validation explicitly.
"""


def main() -> int:
    now = datetime.now(timezone.utc)
    timestamp = now.strftime("%Y%m%dT%H%M%SZ")
    queued = []

    for index, task in enumerate(TASKS, start=1):
        phase_id = f"phase-15-{index:02d}-{task.slug}-{timestamp}"
        target_branch = f"glassbox-phase15-{index:02d}-{task.slug}-{timestamp}"
        phase_dir = ASYNC / "inbox" / phase_id
        if phase_dir.exists():
            raise SystemExit(f"Refusing to overwrite existing inbox entry: {phase_dir}")

        phase_dir.mkdir(parents=True)
        (phase_dir / "BRIEF.md").write_text(
            brief_for(task, phase_id, target_branch),
            encoding="utf-8",
        )
        status = {
            "base_branch": "main",
            "depends_on": list(task.depends_on),
            "exit_code": None,
            "phase_id": phase_id,
            "status": "queued",
            "target_branch": target_branch,
            "target_repo": str(ROOT / task.repo),
            "ts_done": None,
            "ts_queued": now.isoformat().replace("+00:00", "Z"),
            "ts_started": None,
            "worker_id": None,
        }
        (phase_dir / "STATUS.json").write_text(
            json.dumps(status, indent=2, sort_keys=True) + "\n",
            encoding="utf-8",
        )
        queued.append(
            {
                "branch": target_branch,
                "depends_on": list(task.depends_on),
                "phase_id": phase_id,
                "repo": task.repo,
            }
        )

    print(json.dumps({"queued": queued}, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
