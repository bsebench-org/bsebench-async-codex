---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: glassbox-phase14-07-runner-bound-dryrun-cli-20260509T145752Z
base_branch: main
hard_wallclock_min: 120
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-specs
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-filters
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
---

# phase-14-07-runner-bound-dryrun-cli-20260509T145752Z

You are a BSEBench Phase 14 product worker. This is real product work toward
information-theoretic SOC/SOH benchmark bounds, not activity padding.

## Mission

Add a small dry-run CLI/helper for Phase 14 bound-plan JSON validation. It must not run filters, derive SOC, download data, or claim tightness.

## Owned Scope

Repository: `bsebench-runner`

You own only these paths unless an import/export file must be minimally touched
to expose the new module:

- `src/bsebench_runner/phase14_bound_dry_run_cli.py`
- `tests/test_phase14_bound_dry_run_cli.py`

Dependencies: runner-bound-plan

Do not edit unrelated files. Do not revert user or other-worker changes.

## Scientific Integrity Rules

- Treat Phase 14 as theory/tooling preflight only.
- Do not claim a new theorem, tight bound, SOTA, filter superiority, SOC/SOH
  performance, transfer success, leaderboard status, or universal validity.
- Use synthetic fixtures unless real evidence gates already exist and are
  explicitly in scope. This task has no permission to execute estimators.
- No Hugging Face upload or dataset download.
- No thesis repo edits, no claim registry edits, no roadmap edits.
- Commit subject must start exactly with: `GLASSBOX [role: phase14-runner-bound-dryrun-cli]`
- Do not add `Co-Authored-By Claude`.

## Expected Deliverable

- Production code, schema, fixture, or documentation in the owned paths.
- Focused tests in the owned test path when applicable.
- Fail-closed behavior for missing evidence, non-finite values, dimension
  mismatches, invalid covariance/information matrices, or unsupported claims.
- A final commit pushed to `glassbox-phase14-07-runner-bound-dryrun-cli-20260509T145752Z`.

## Validation

Run focused pytest for CLI success/failure and git diff --check.

Also run `git diff --check`. If a broader project check is cheap, run it too.
Report any skipped validation explicitly.
