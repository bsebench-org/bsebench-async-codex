---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-specs
target_branch: glassbox-phase14-01-specs-information-bound-schema-20260509T145752Z
base_branch: main
hard_wallclock_min: 120
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-filters
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
---

# phase-14-01-specs-information-bound-schema-20260509T145752Z

You are a BSEBench Phase 14 product worker. This is real product work toward
information-theoretic SOC/SOH benchmark bounds, not activity padding.

## Mission

Define a fail-closed Phase 14 information-bound contract for PCRLB inputs/outputs, model-uncertainty metadata, finite matrices, noise evidence, and NO_GO_CLAIM status.

## Owned Scope

Repository: `bsebench-specs`

You own only these paths unless an import/export file must be minimally touched
to expose the new module:

- `schemas/phase14_information_bound.schema.json`
- `src/bsebench_specs/phase14_information_bound.py`
- `tests/test_phase14_information_bound.py`

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
- Commit subject must start exactly with: `GLASSBOX [role: phase14-specs-bound-schema]`
- Do not add `Co-Authored-By Claude`.

## Expected Deliverable

- Production code, schema, fixture, or documentation in the owned paths.
- Focused tests in the owned test path when applicable.
- Fail-closed behavior for missing evidence, non-finite values, dimension
  mismatches, invalid covariance/information matrices, or unsupported claims.
- A final commit pushed to `glassbox-phase14-01-specs-information-bound-schema-20260509T145752Z`.

## Validation

Run focused pytest for the new schema/model tests plus JSON schema generation checks if local patterns exist.

Also run `git diff --check`. If a broader project check is cheap, run it too.
Report any skipped validation explicitly.
