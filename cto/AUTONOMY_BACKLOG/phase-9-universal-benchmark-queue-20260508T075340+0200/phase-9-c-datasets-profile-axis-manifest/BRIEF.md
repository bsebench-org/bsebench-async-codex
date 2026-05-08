---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-9-c-datasets-profile-axis-manifest
base_branch: main
hard_wallclock_min: 60
---

# Phase 9.c - datasets profile-axis manifest

You are a rigorous dataset-provenance engineer. You are not alone in this
codebase; do not revert or overwrite unrelated edits.

## Objective

Add a dataset-side profile-axis manifest or schema so BSEBench can evaluate
SOC/SOH estimators by profile family while preserving provenance and avoiding
hard-coded runner assumptions.

## Inputs Inspected

This queue-pack author inspected:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`
- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`
- `cto/AUTONOMY_BACKLOG/README.md`

Before editing, inspect the target repository and record the actual files read.

## Decisions

- Active lane: evidence generation. Produce metadata contract and validation
  evidence only.
- Owned write scope in the target repo: profile-axis manifest/schema,
  synthetic or example manifest fixtures, and manifest validation tests only.
- Do not edit runner protocol files, estimator contract files, stats files,
  async submission templates, thesis files, manuscript files, roadmap files,
  claim registry files, `claims/registry.yaml`, or `claim_55`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim
  statements without a completed source ledger, stable URL or DOI, retrieval
  date, metric, dataset, split, BSEBench frozen value, and comparability caveat.

## Required Behavior

- Define required manifest fields for dataset id, cell or pack id when
  available, chemistry when available, profile label, temperature label or
  value when available, aging/SOH metadata when available, source artifact id,
  and provenance caveat.
- Support unknown metadata explicitly with a caveat rather than inferred values.
- Add positive and negative fixtures for valid, missing-required-field, and
  unknown-with-caveat rows.
- Keep the manifest independent from any specific estimator family or metric
  aggregator.

## Falsification Gate

The task must fail if a manifest row can pass with a missing dataset id, missing
profile label, missing source artifact identity, or unknown metadata that lacks
an explicit caveat.

## Validation Checklist

- Run focused manifest validation tests for valid, invalid, and
  unknown-with-caveat rows.
- Run any target-repo lightweight formatting or lint command that is already
  documented or obvious from the inspected files.
- Run `git diff --check`.
- Record changed files and exact validation command results in the worker
  summary.

## Residual Risks

- Existing adapters may not have enough metadata to populate every optional
  field. Record those gaps; do not fill them from memory.
- Cross-repo integration with runner profile protocols should remain a later
  task after this metadata contract is stable.

## Next Concrete Task

After this merges, queue a runner integration task that reads the profile-axis
manifest only if both this task and `phase-9-b-runner-profile-stress-protocol`
have landed.
