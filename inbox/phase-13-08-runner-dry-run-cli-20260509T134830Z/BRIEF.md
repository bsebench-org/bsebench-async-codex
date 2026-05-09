---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: glassbox-phase13-08-runner-dry-run-cli-20260509T134830Z
base_branch: main
hard_wallclock_min: 120
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-specs
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-filters
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
---

# phase-13-08-runner-dry-run-cli-20260509T134830Z

You are a BSEBench Phase 13 product worker. This is real product work toward
the universal SOC/SOH benchmark, not activity padding.

## Mission

Add a small Phase 13 dry-run CLI helper or module-level entrypoint that validates an ensemble plan fixture without executing expensive filters or making claims.

## Owned Scope

Repository: `bsebench-runner`

You own only these paths unless an import/export file must be minimally touched
to expose the new module:

- `src/bsebench_runner/phase13_dry_run_cli.py`
- `tests/test_phase13_dry_run_cli.py`

Do not edit unrelated files. Do not revert user or other-worker changes.

## Scientific Integrity Rules

- Preserve Phase 12 blockers: no SOC derivation, estimator execution, transfer
  execution, or parameter use unless the existing gates authorize it.
- Do not claim frontier-performance, method victory, leaderboard status, SOC/SOH performance, or
  universal empirical validity.
- No Hugging Face upload or dataset download.
- No thesis repo edits, no claim registry edits, no roadmap edits.
- Commit subject must start exactly with: `GLASSBOX [role: phase13-runner-dryrun-cli]`
- Do not add `Co-Authored-By Claude`.

## Expected Deliverable

- Production code or machine-readable schema in the owned paths.
- Focused tests in the owned test path.
- Fail-closed behavior when evidence, hashes, splits, provenance, or finite
  metrics are missing.
- A final commit pushed to `glassbox-phase13-08-runner-dry-run-cli-20260509T134830Z`.

## Validation

Run targeted pytest for the CLI helper and a no-execution smoke path.

Also run `git diff --check`. If a broader project check is cheap, run it too.
Report any skipped validation explicitly.
