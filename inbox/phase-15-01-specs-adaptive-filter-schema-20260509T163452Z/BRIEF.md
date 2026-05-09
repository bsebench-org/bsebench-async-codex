---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-specs
target_branch: glassbox-phase15-01-specs-adaptive-filter-schema-20260509T163452Z
base_branch: main
hard_wallclock_min: 120
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-filters
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
---

# phase-15-01-specs-adaptive-filter-schema-20260509T163452Z

You are a BSEBench Phase 15 product worker. This is real product work toward
adaptive filter-learning readiness, not activity padding.

## Mission

Define a fail-closed Phase 15 adaptive-filter contract for online update rules, calibration/evaluation split separation, residual access, learning-rate bounds, and NO_GO_CLAIM status.

## Owned Scope

Repository: `bsebench-specs`

You own only these paths unless an import/export file must be minimally touched
to expose the new module:

- `schemas/phase15_adaptive_filter.schema.json`
- `src/bsebench_specs/phase15_adaptive_filter.py`
- `tests/test_phase15_adaptive_filter.py`

Dependencies: none

Do not edit unrelated files. Do not revert user or other-worker changes.

## Scientific Integrity Rules

- Treat Phase 15 as adaptive tooling/preflight only.
- Do not claim RMSE gain, >20% improvement, SOTA, filter superiority, SOC/SOH
  performance, transfer success, leaderboard status, or universal validity.
- Use synthetic fixtures unless explicit split/provenance evidence is already
  supplied by the task. This task has no permission to execute estimators.
- No neural training, no Hugging Face upload, no dataset download.
- No thesis repo edits, no claim registry edits, no roadmap edits.
- Commit subject must start exactly with: `GLASSBOX [role: phase15-specs-adaptive-filter-schema]`
- Do not add `Co-Authored-By Claude`.

## Expected Deliverable

- Production code, schema, fixture, or documentation in the owned paths.
- Focused tests in the owned test path when applicable.
- Fail-closed behavior for missing evidence, non-finite values, split leakage,
  invalid hashes, unsupported claims, or forbidden adaptive-gain wording.
- A final commit pushed to `glassbox-phase15-01-specs-adaptive-filter-schema-20260509T163452Z`.

## Validation

Run focused pytest for the new schema/model tests plus schema export checks if local patterns exist.

Also run `git diff --check`. If a broader project check is cheap, run it too.
Report any skipped validation explicitly.
