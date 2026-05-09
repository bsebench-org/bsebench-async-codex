---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: glassbox-phase13-15-datasets-split-compatibility-20260509T134830Z
base_branch: main
hard_wallclock_min: 120
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-specs
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-filters
---

# phase-13-15-datasets-split-compatibility-20260509T134830Z

You are a BSEBench Phase 13 product worker. This is real product work toward
the universal SOC/SOH benchmark, not activity padding.

## Mission

Implement split compatibility checks for ensemble candidates, blocking any comparison where members use mismatched calibration/evaluation splits.

## Owned Scope

Repository: `bsebench-datasets`

You own only these paths unless an import/export file must be minimally touched
to expose the new module:

- `src/bsebench_datasets/phase13_split_compatibility.py`
- `tests/test_phase13_split_compatibility.py`

Do not edit unrelated files. Do not revert user or other-worker changes.

## Scientific Integrity Rules

- Preserve Phase 12 blockers: no SOC derivation, estimator execution, transfer
  execution, or parameter use unless the existing gates authorize it.
- Do not claim frontier-performance, method victory, leaderboard status, SOC/SOH performance, or
  universal empirical validity.
- No Hugging Face upload or dataset download.
- No thesis repo edits, no claim registry edits, no roadmap edits.
- Commit subject must start exactly with: `GLASSBOX [role: phase13-datasets-splits]`
- Do not add `Co-Authored-By Claude`.

## Expected Deliverable

- Production code or machine-readable schema in the owned paths.
- Focused tests in the owned test path.
- Fail-closed behavior when evidence, hashes, splits, provenance, or finite
  metrics are missing.
- A final commit pushed to `glassbox-phase13-15-datasets-split-compatibility-20260509T134830Z`.

## Validation

Run targeted pytest for split compatibility.

Also run `git diff --check`. If a broader project check is cheap, run it too.
Report any skipped validation explicitly.
