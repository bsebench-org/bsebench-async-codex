#!/usr/bin/env python3
"""Queue the Phase 13 opening wave with disjoint worker scopes."""

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
    add_dirs: tuple[str, ...] = ()
    hard_wallclock_min: int = 120


TASKS: tuple[Task, ...] = (
    Task(
        slug="specs-method-card-schema",
        repo="bsebench-specs",
        role="phase13-specs-method-card",
        owned_paths=(
            "schemas/phase13_ensemble_method_card.schema.json",
            "src/bsebench_specs/phase13_ensemble_method_card.py",
            "tests/test_phase13_ensemble_method_card.py",
        ),
        objective="Define a fail-closed ensemble method-card contract with method identity, member families, aggregation strategy, provenance requirements, and no-claim status.",
        validation_hint="Run the focused pytest for the new method-card tests plus any local schema validation checks.",
    ),
    Task(
        slug="specs-ensemble-run-schema",
        repo="bsebench-specs",
        role="phase13-specs-run-schema",
        owned_paths=(
            "schemas/phase13_ensemble_run.schema.json",
            "src/bsebench_specs/phase13_ensemble_run.py",
            "tests/test_phase13_ensemble_run_schema.py",
        ),
        objective="Define a fail-closed ensemble run/evidence schema that requires split identity, member artifact hashes, uncertainty method, metric keys, compute profile, and verdict status.",
        validation_hint="Run the focused pytest for the new run-schema tests plus JSON-schema validation if available.",
    ),
    Task(
        slug="stats-comparison-gate",
        repo="bsebench-stats",
        role="phase13-stats-comparison-gate",
        owned_paths=(
            "src/bsebench_stats/phase13_comparison_gate.py",
            "tests/test_phase13_comparison_gate.py",
        ),
        objective="Implement a comparison-readiness gate that refuses ensemble comparisons unless all candidates have provenance, finite metrics, uncertainty, split IDs, and matching metric keys.",
        validation_hint="Run targeted pytest for the new gate and existing ensemble contract tests.",
    ),
    Task(
        slug="stats-bootstrap-uncertainty",
        repo="bsebench-stats",
        role="phase13-stats-bootstrap",
        owned_paths=(
            "src/bsebench_stats/phase13_bootstrap_uncertainty.py",
            "tests/test_phase13_bootstrap_uncertainty.py",
        ),
        objective="Implement deterministic bootstrap uncertainty helpers for metric summaries with finite-value guards and reproducible seeds.",
        validation_hint="Run targeted pytest for the new bootstrap utilities.",
    ),
    Task(
        slug="stats-no-claim-linter",
        repo="bsebench-stats",
        role="phase13-stats-no-claims",
        owned_paths=(
            "src/bsebench_stats/phase13_no_claims.py",
            "tests/test_phase13_no_claims.py",
        ),
        objective="Implement a Phase 13 report-wording linter that rejects method-leader, leaderboard, frontier-performance, winner, and performance-conclusion wording unless an explicit empirical verdict artifact authorizes it.",
        validation_hint="Run targeted pytest for the new linter.",
    ),
    Task(
        slug="runner-ensemble-plan",
        repo="bsebench-runner",
        role="phase13-runner-plan",
        owned_paths=(
            "src/bsebench_runner/phase13_ensemble_plan.py",
            "tests/test_phase13_ensemble_plan.py",
        ),
        objective="Implement a dry-run ensemble evaluation plan object that consumes candidate member descriptors and blocks scheduling when truth, split, or parameter-freeze evidence is missing.",
        validation_hint="Run targeted pytest for the new plan model.",
    ),
    Task(
        slug="runner-member-artifacts",
        repo="bsebench-runner",
        role="phase13-runner-artifacts",
        owned_paths=(
            "src/bsebench_runner/phase13_member_artifacts.py",
            "tests/test_phase13_member_artifacts.py",
        ),
        objective="Implement member artifact collection/validation for ensemble candidates, including SHA-256 presence, dataset fingerprint matching, and member ID uniqueness.",
        validation_hint="Run targeted pytest for the new artifact collector.",
    ),
    Task(
        slug="runner-dry-run-cli",
        repo="bsebench-runner",
        role="phase13-runner-dryrun-cli",
        owned_paths=(
            "src/bsebench_runner/phase13_dry_run_cli.py",
            "tests/test_phase13_dry_run_cli.py",
        ),
        objective="Add a small Phase 13 dry-run CLI helper or module-level entrypoint that validates an ensemble plan fixture without executing expensive filters or making claims.",
        validation_hint="Run targeted pytest for the CLI helper and a no-execution smoke path.",
    ),
    Task(
        slug="runner-compute-profile",
        repo="bsebench-runner",
        role="phase13-runner-compute",
        owned_paths=(
            "src/bsebench_runner/phase13_compute_profile.py",
            "tests/test_phase13_compute_profile.py",
        ),
        objective="Implement a lightweight compute-profile manifest for ensemble runs, recording runtime, memory fields, iteration counts, and fail-closed missing-data behavior.",
        validation_hint="Run targeted pytest for the compute-profile manifest.",
    ),
    Task(
        slug="filters-static-weighted-ensemble",
        repo="bsebench-filters",
        role="phase13-filters-static-weighted",
        owned_paths=(
            "src/bsebench_filters/phase13_static_weighted_ensemble.py",
            "tests/test_phase13_static_weighted_ensemble.py",
        ),
        objective="Implement a contract-compliant static weighted ensemble adapter over member estimates with strict weight validation and no changes to existing filter math.",
        validation_hint="Run targeted pytest for the static weighted adapter.",
    ),
    Task(
        slug="filters-time-varying-weights",
        repo="bsebench-filters",
        role="phase13-filters-time-varying",
        owned_paths=(
            "src/bsebench_filters/phase13_time_varying_weights.py",
            "tests/test_phase13_time_varying_weights.py",
        ),
        objective="Implement a time-varying weight adapter skeleton with bounded weights, deterministic update inputs, and fail-closed missing-member behavior.",
        validation_hint="Run targeted pytest for time-varying weight validation.",
    ),
    Task(
        slug="filters-hierarchical-priors",
        repo="bsebench-filters",
        role="phase13-filters-hierarchical",
        owned_paths=(
            "src/bsebench_filters/phase13_hierarchical_priors.py",
            "tests/test_phase13_hierarchical_priors.py",
        ),
        objective="Implement hierarchical-prior metadata and validation primitives for ensemble methods, without claiming empirical advantage.",
        validation_hint="Run targeted pytest for hierarchical-prior metadata validation.",
    ),
    Task(
        slug="filters-weight-freeze",
        repo="bsebench-filters",
        role="phase13-filters-weight-freeze",
        owned_paths=(
            "src/bsebench_filters/phase13_weight_freeze.py",
            "tests/test_phase13_weight_freeze.py",
        ),
        objective="Implement a fail-closed ensemble weight-freeze gate requiring calibration split hash, calibration run hash, member config hashes, and weight vector hash.",
        validation_hint="Run targeted pytest for the weight-freeze gate.",
    ),
    Task(
        slug="datasets-ensemble-evidence",
        repo="bsebench-datasets",
        role="phase13-datasets-evidence",
        owned_paths=(
            "src/bsebench_datasets/phase13_ensemble_evidence.py",
            "tests/test_phase13_ensemble_evidence.py",
        ),
        objective="Implement an ensemble evidence manifest helper that records dataset IDs, truth-evidence status, split IDs, and member artifact references for Phase 13 inputs.",
        validation_hint="Run targeted pytest for the ensemble evidence manifest.",
    ),
    Task(
        slug="datasets-split-compatibility",
        repo="bsebench-datasets",
        role="phase13-datasets-splits",
        owned_paths=(
            "src/bsebench_datasets/phase13_split_compatibility.py",
            "tests/test_phase13_split_compatibility.py",
        ),
        objective="Implement split compatibility checks for ensemble candidates, blocking any comparison where members use mismatched calibration/evaluation splits.",
        validation_hint="Run targeted pytest for split compatibility.",
    ),
    Task(
        slug="datasets-opening-queue",
        repo="bsebench-datasets",
        role="phase13-datasets-opening-queue",
        owned_paths=(
            "src/bsebench_datasets/phase13_opening_queue.py",
            "tests/test_phase13_opening_queue.py",
            "outputs/phase13_dataset_evidence_open_queue_20260509.json",
        ),
        objective="Produce a machine-readable Phase 13 dataset evidence opening queue from existing local manifests, with every row classified as ready or blocked and no downloads/uploads.",
        validation_hint="Run targeted pytest plus the queue generation script if implemented.",
    ),
    Task(
        slug="website-phase13-page",
        repo="bsebench-website",
        role="phase13-website-status",
        owned_paths=(
            "src/content/docs/phase13-ensemble-methods.md",
            "astro.config.mjs",
        ),
        objective="Add a public Phase 13 status page that explains ensemble-method readiness as mechanical work only and links it from the reference sidebar.",
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
    add_dirs = task.add_dirs or tuple(str(path) for path in COMMON_ADD_DIRS if path.name != task.repo)
    owned = "\n".join(f"- `{path}`" for path in task.owned_paths)
    add_dir_block = "\n".join(f"  - {path}" for path in add_dirs)
    return f"""---
target_repo: {ROOT / task.repo}
target_branch: {target_branch}
base_branch: main
hard_wallclock_min: {task.hard_wallclock_min}
add_dir:
{add_dir_block}
---

# {phase_id}

You are a BSEBench Phase 13 product worker. This is real product work toward
the universal SOC/SOH benchmark, not activity padding.

## Mission

{task.objective}

## Owned Scope

Repository: `{task.repo}`

You own only these paths unless an import/export file must be minimally touched
to expose the new module:

{owned}

Do not edit unrelated files. Do not revert user or other-worker changes.

## Scientific Integrity Rules

- Preserve Phase 12 blockers: no SOC derivation, estimator execution, transfer
  execution, or parameter use unless the existing gates authorize it.
- Do not claim frontier-performance, method victory, leaderboard status, SOC/SOH performance, or
  universal empirical validity.
- No Hugging Face upload or dataset download.
- No thesis repo edits, no claim registry edits, no roadmap edits.
- Commit subject must start exactly with: `GLASSBOX [role: {task.role}]`
- Do not add `Co-Authored-By Claude`.

## Expected Deliverable

- Production code or machine-readable schema in the owned paths.
- Focused tests in the owned test path.
- Fail-closed behavior when evidence, hashes, splits, provenance, or finite
  metrics are missing.
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
        phase_id = f"phase-13-{index:02d}-{task.slug}-{timestamp}"
        target_branch = f"glassbox-phase13-{index:02d}-{task.slug}-{timestamp}"
        phase_dir = ASYNC / "inbox" / phase_id
        if phase_dir.exists():
            raise SystemExit(f"Refusing to overwrite existing inbox entry: {phase_dir}")

        phase_dir.mkdir(parents=True)
        (phase_dir / "BRIEF.md").write_text(
            brief_for(task, phase_id, target_branch),
            encoding="utf-8",
        )
        status = {
            "phase_id": phase_id,
            "status": "queued",
            "ts_queued": now.isoformat().replace("+00:00", "Z"),
            "ts_started": None,
            "ts_done": None,
            "exit_code": None,
            "worker_id": None,
            "target_repo": str(ROOT / task.repo),
            "target_branch": target_branch,
            "base_branch": "main",
        }
        (phase_dir / "STATUS.json").write_text(
            json.dumps(status, indent=2, sort_keys=True) + "\n",
            encoding="utf-8",
        )
        queued.append({"phase_id": phase_id, "repo": task.repo, "branch": target_branch})

    print(json.dumps({"queued": queued}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
