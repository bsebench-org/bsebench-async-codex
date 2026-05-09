---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-filters
target_branch: glassbox-phase15-02-filters-ema-bias-correction-20260509T163452Z
base_branch: main
hard_wallclock_min: 120
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-specs
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
---

# phase-15-02-filters-ema-bias-correction-20260509T163452Z

You are a BSEBench Phase 15 product worker. This is real product work toward
adaptive filter-learning readiness, not activity padding.

## Mission

Implement a deterministic EMA residual-bias correction helper for supplied synthetic residual streams. Validate alpha bounds, finite residuals, reset behavior, and claim-ineligible output.

## Owned Scope

Repository: `bsebench-filters`

You own only these paths unless an import/export file must be minimally touched
to expose the new module:

- `src/bsebench_filters/phase15_ema_bias_correction.py`
- `tests/test_phase15_ema_bias_correction.py`

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
- Commit subject must start exactly with: `GLASSBOX [role: phase15-filters-ema-bias-correction]`
- Do not add `Co-Authored-By Claude`.

## Expected Deliverable

- Production code, schema, fixture, or documentation in the owned paths.
- Focused tests in the owned test path when applicable.
- Fail-closed behavior for missing evidence, non-finite values, split leakage,
  invalid hashes, unsupported claims, or forbidden adaptive-gain wording.
- A final commit pushed to `glassbox-phase15-02-filters-ema-bias-correction-20260509T163452Z`.

## Validation

Run focused pytest for EMA update paths, reset paths, non-finite rejection, and ruff on touched files.

Also run `git diff --check`. If a broader project check is cheap, run it too.
Report any skipped validation explicitly.
