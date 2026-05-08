---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-9-d-stats-soc-soh-metric-envelope
base_branch: main
hard_wallclock_min: 60
---

# Phase 9.d - stats SOC/SOH metric envelope

You are a rigorous benchmark-metrics engineer. You are not alone in this
codebase; do not revert or overwrite unrelated edits.

## Objective

Add a neutral metric-envelope schema for SOC/SOH benchmark outputs so accuracy,
maximum error, recovery, invalid-output, and optional compute metadata can be
reported without turning the report into a SOTA or leaderboard claim.

## Inputs Inspected

This queue-pack author inspected:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`
- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`
- `cto/AUTONOMY_BACKLOG/README.md`

Before editing, inspect the target repository and record the actual files read.

## Decisions

- Active lane: evidence generation. Produce schema and validation evidence
  only.
- Owned write scope in the target repo: SOC/SOH metric-envelope schema,
  synthetic report fixtures, and focused metric-envelope tests only.
- Do not edit runner protocols, dataset manifests, async docs, thesis files,
  manuscript files, roadmap files, claim registry files, `claims/registry.yaml`,
  or `claim_55`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim
  statements without a completed source ledger, stable URL or DOI, retrieval
  date, metric, dataset, split, BSEBench frozen value, and comparability caveat.

## Required Behavior

- Define required fields for method id, dataset id, split id, profile label,
  target state, RMSE, MAE, MAXE, sample count, invalid-output count, and
  caveat.
- Allow optional recovery and compute-cost fields without making them mandatory
  for every estimator.
- Add tests for valid SOC rows, valid SOH rows, missing-required-field rows,
  non-finite metric rows, and invalid-output count mismatch rows.
- Keep ranking or public leaderboard ordering out of scope.

## Falsification Gate

The task must fail if a metric envelope can pass with missing method, dataset,
split, target state, RMSE, MAE, MAXE, sample count, invalid-output count, or
caveat fields, or if non-finite numeric values pass as valid metrics.

## Validation Checklist

- Run focused metric-envelope validation tests for positive and negative
  fixtures.
- Run any target-repo lightweight formatting or lint command that is already
  documented or obvious from the inspected files.
- Run `git diff --check`.
- Record changed files and exact validation command results in the worker
  summary.

## Residual Risks

- Existing stats outputs may use different field names. Preserve compatibility
  when practical, but do not modify unrelated aggregators in this task.
- Compute-cost metadata may need runner support before real values are
  available; missing values should remain explicit.

## Next Concrete Task

After this merges, queue a read-only report adapter task that consumes this
metric envelope and emits a caveated benchmark table without ranking claims.
