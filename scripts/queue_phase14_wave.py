#!/usr/bin/env python3
"""Queue the Phase 14 opening wave with disjoint worker scopes."""

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
    add_dirs: tuple[str, ...] = ()
    hard_wallclock_min: int = 120


TASKS: tuple[Task, ...] = (
    Task(
        slug="specs-information-bound-schema",
        repo="bsebench-specs",
        role="phase14-specs-bound-schema",
        owned_paths=(
            "schemas/phase14_information_bound.schema.json",
            "src/bsebench_specs/phase14_information_bound.py",
            "tests/test_phase14_information_bound.py",
        ),
        objective=(
            "Define a fail-closed Phase 14 information-bound contract for "
            "PCRLB inputs/outputs, model-uncertainty metadata, finite matrices, "
            "noise evidence, and NO_GO_CLAIM status."
        ),
        validation_hint="Run focused pytest for the new schema/model tests plus JSON schema generation checks if local patterns exist.",
    ),
    Task(
        slug="stats-matrix-checks",
        repo="bsebench-stats",
        role="phase14-stats-matrix-checks",
        owned_paths=(
            "src/bsebench_stats/phase14_matrix_checks.py",
            "tests/test_phase14_matrix_checks.py",
        ),
        objective=(
            "Implement finite matrix validators for square shape, symmetry, PSD/SPD, "
            "dimension compatibility, inversion-safe regularization refusal, and "
            "JSON-safe diagnostics."
        ),
        validation_hint="Run focused pytest for matrix checks and ruff on touched files.",
    ),
    Task(
        slug="stats-linear-pcrlb",
        repo="bsebench-stats",
        role="phase14-stats-linear-pcrlb",
        owned_paths=(
            "src/bsebench_stats/phase14_linear_pcrlb.py",
            "tests/test_phase14_linear_pcrlb.py",
        ),
        objective=(
            "Implement a deterministic linear-Gaussian PCRLB recursion for supplied "
            "F, H, Q, R, and prior information matrices. Use the Tichavsky-style "
            "D11/D12/D22 recursion for synthetic fixtures only; no battery claim."
        ),
        validation_hint="Run focused pytest, including scalar and matrix synthetic fixtures, plus ruff.",
        depends_on=("stats-matrix-checks",),
    ),
    Task(
        slug="stats-model-uncertainty",
        repo="bsebench-stats",
        role="phase14-stats-model-uncertainty",
        owned_paths=(
            "src/bsebench_stats/phase14_model_uncertainty.py",
            "tests/test_phase14_model_uncertainty.py",
        ),
        objective=(
            "Implement a model-uncertainty/oracle-mixture preflight that validates "
            "model weights, per-model bound artifacts, matching state dimensions, "
            "and finite information/covariance matrices. Do not call a weighted "
            "conditional summary a true Bayesian model-uncertainty PCRLB unless "
            "validated mixture information blocks are supplied; emit NO_GO_CLAIM."
        ),
        validation_hint="Run focused pytest for valid mixtures and fail-closed missing/invalid model evidence.",
        depends_on=("stats-matrix-checks",),
    ),
    Task(
        slug="stats-bound-report-gate",
        repo="bsebench-stats",
        role="phase14-stats-bound-report-gate",
        owned_paths=(
            "src/bsebench_stats/phase14_bound_report_gate.py",
            "tests/test_phase14_bound_report_gate.py",
        ),
        objective=(
            "Implement a Phase 14 report gate that blocks theorem, tightness, SOTA, "
            "leaderboard, and empirical-bound wording unless a later audited verdict "
            "artifact authorizes it."
        ),
        validation_hint="Run focused pytest for forbidden wording and authorized/no-claim payloads.",
        depends_on=("stats-linear-pcrlb", "stats-model-uncertainty"),
    ),
    Task(
        slug="runner-bound-plan",
        repo="bsebench-runner",
        role="phase14-runner-bound-plan",
        owned_paths=(
            "src/bsebench_runner/phase14_bound_plan.py",
            "tests/test_phase14_bound_plan.py",
        ),
        objective=(
            "Implement a dry-run information-bound plan that records required truth, "
            "split, parameter, linearization, and noise-evidence inputs and refuses "
            "estimator execution."
        ),
        validation_hint="Run focused pytest for ready synthetic metadata and blocked missing evidence.",
    ),
    Task(
        slug="runner-bound-dryrun-cli",
        repo="bsebench-runner",
        role="phase14-runner-bound-dryrun-cli",
        owned_paths=(
            "src/bsebench_runner/phase14_bound_dry_run_cli.py",
            "tests/test_phase14_bound_dry_run_cli.py",
        ),
        objective=(
            "Add a small dry-run CLI/helper for Phase 14 bound-plan JSON validation. "
            "It must not run filters, derive SOC, download data, or claim tightness."
        ),
        validation_hint="Run focused pytest for CLI success/failure and git diff --check.",
        depends_on=("runner-bound-plan",),
    ),
    Task(
        slug="datasets-noise-evidence",
        repo="bsebench-datasets",
        role="phase14-datasets-noise-evidence",
        owned_paths=(
            "src/bsebench_datasets/phase14_noise_evidence.py",
            "tests/test_phase14_noise_evidence.py",
        ),
        objective=(
            "Implement a fail-closed noise-evidence gate for Phase 14 requiring "
            "measurement/process noise provenance, units, finite variances/covariances, "
            "source hashes, and no empirical claim."
        ),
        validation_hint="Run focused pytest for ready synthetic evidence and blocked missing provenance.",
    ),
    Task(
        slug="filters-ecm-linearization",
        repo="bsebench-filters",
        role="phase14-filters-ecm-linearization",
        owned_paths=(
            "src/bsebench_filters/phase14_ecm_linearization.py",
            "tests/test_phase14_ecm_linearization.py",
        ),
        objective=(
            "Implement an ECM/filter linearization descriptor contract for supplied "
            "state transition and observation Jacobians. Validate dimensions and "
            "finite values only; do not alter filter math."
        ),
        validation_hint="Run focused pytest for finite descriptors and fail-closed invalid dimensions/non-finite values.",
    ),
    Task(
        slug="stats-synthetic-sanity-fixtures",
        repo="bsebench-stats",
        role="phase14-stats-synthetic-sanity",
        owned_paths=(
            "tests/fixtures/phase14_linear_gaussian_bound/README.md",
            "tests/fixtures/phase14_linear_gaussian_bound/scalar_fixture.json",
            "tests/test_phase14_synthetic_sanity.py",
        ),
        objective=(
            "Add synthetic linear-Gaussian sanity fixtures for Phase 14 PCRLB checks. "
            "Fixtures must be explicitly synthetic and claim-ineligible."
        ),
        validation_hint="Run focused pytest for fixture schema/finite checks.",
        depends_on=("stats-linear-pcrlb",),
    ),
    Task(
        slug="website-phase14-page",
        repo="bsebench-website",
        role="phase14-website-status",
        owned_paths=(
            "src/content/docs/phase14-information-bounds.md",
            "astro.config.mjs",
        ),
        objective=(
            "Add a public Phase 14 status page explaining that information-bound work "
            "is theory/tooling preflight only and remains NO_GO_CLAIM."
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
    add_dirs = task.add_dirs or tuple(str(path) for path in COMMON_ADD_DIRS if path.name != task.repo)
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

You are a BSEBench Phase 14 product worker. This is real product work toward
information-theoretic SOC/SOH benchmark bounds, not activity padding.

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

- Treat Phase 14 as theory/tooling preflight only.
- Do not claim a new theorem, tight bound, SOTA, filter superiority, SOC/SOH
  performance, transfer success, leaderboard status, or universal validity.
- Use synthetic fixtures unless real evidence gates already exist and are
  explicitly in scope. This task has no permission to execute estimators.
- No Hugging Face upload or dataset download.
- No thesis repo edits, no claim registry edits, no roadmap edits.
- Commit subject must start exactly with: `GLASSBOX [role: {task.role}]`
- Do not add `Co-Authored-By Claude`.

## Expected Deliverable

- Production code, schema, fixture, or documentation in the owned paths.
- Focused tests in the owned test path when applicable.
- Fail-closed behavior for missing evidence, non-finite values, dimension
  mismatches, invalid covariance/information matrices, or unsupported claims.
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
        phase_id = f"phase-14-{index:02d}-{task.slug}-{timestamp}"
        target_branch = f"glassbox-phase14-{index:02d}-{task.slug}-{timestamp}"
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
            "depends_on": list(task.depends_on),
        }
        (phase_dir / "STATUS.json").write_text(
            json.dumps(status, indent=2, sort_keys=True) + "\n",
            encoding="utf-8",
        )
        queued.append(
            {
                "phase_id": phase_id,
                "repo": task.repo,
                "branch": target_branch,
                "depends_on": list(task.depends_on),
            }
        )

    print(json.dumps({"queued": queued}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
