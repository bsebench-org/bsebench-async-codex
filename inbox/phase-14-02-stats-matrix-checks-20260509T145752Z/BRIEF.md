---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: glassbox-phase14-02-stats-matrix-checks-20260509T145752Z
base_branch: main
hard_wallclock_min: 120
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-specs
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-filters
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
---

# phase-14-02-stats-matrix-checks-20260509T145752Z

You are a BSEBench Phase 14 product worker. This is real product work toward
information-theoretic SOC/SOH benchmark bounds, not activity padding.

## Mission

Implement finite matrix validators for square shape, symmetry, PSD/SPD, dimension compatibility, inversion-safe regularization refusal, and JSON-safe diagnostics.

## Owned Scope

Repository: `bsebench-stats`

You own only these paths unless an import/export file must be minimally touched
to expose the new module:

- `src/bsebench_stats/phase14_matrix_checks.py`
- `tests/test_phase14_matrix_checks.py`

Dependencies: none

Do not edit unrelated files. Do not revert user or other-worker changes.

## Scientific Integrity Rules

- Treat Phase 14 as theory/tooling preflight only.
- Do not claim a new theorem, tight bound, SOTA, filter superiority, SOC/SOH
  performance, transfer success, leaderboard status, or universal validity.
- Use synthetic fixtures unless real evidence gates already exist and are
  explicitly in scope. This task has no permission to execute estimators.
- No Hugging Face upload or dataset download.
- No thesis repo edits, no claim registry edits, no roadmap edits.
- Commit subject must start exactly with: `GLASSBOX [role: phase14-stats-matrix-checks]`
- Do not add `Co-Authored-By Claude`.

## Expected Deliverable

- Production code, schema, fixture, or documentation in the owned paths.
- Focused tests in the owned test path when applicable.
- Fail-closed behavior for missing evidence, non-finite values, dimension
  mismatches, invalid covariance/information matrices, or unsupported claims.
- A final commit pushed to `glassbox-phase14-02-stats-matrix-checks-20260509T145752Z`.

## Validation

Run focused pytest for matrix checks and ruff on touched files.

Also run `git diff --check`. If a broader project check is cheap, run it too.
Report any skipped validation explicitly.
