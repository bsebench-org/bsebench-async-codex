---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-9-a-runner-estimator-io-contract
base_branch: main
hard_wallclock_min: 60
---

# Phase 9.a - runner estimator I/O contract

You are a rigorous benchmark-interface engineer. You are not alone in this
codebase; do not revert or overwrite unrelated edits.

## Objective

Add a minimal estimator I/O contract that lets SOC/SOH estimators, filters, ECM
observers, and AI observers plug into the runner without owning dataset loading,
split logic, metric calculation, or report generation.

## Inputs Inspected

This queue-pack author inspected:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`
- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`
- `cto/AUTONOMY_BACKLOG/README.md`

Before editing, inspect the target repository and record the actual files read.

## Decisions

- Active lane: evidence generation. Produce mechanical API and validation
  evidence only.
- Owned write scope in the target repo: estimator contract module, toy
  estimator fixtures, and estimator contract tests only.
- Do not edit profile protocols, split guards, dataset adapters, stats, async
  docs, thesis files, manuscript files, roadmap files, claim registry files,
  `claims/registry.yaml`, or `claim_55`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim
  statements without a completed source ledger, stable URL or DOI, retrieval
  date, metric, dataset, split, BSEBench frozen value, and comparability caveat.

## Required Behavior

- Define the smallest runner-side estimator contract needed for a step-based
  estimator to consume voltage, current, temperature, and dt and return SOC,
  optional SOH, and validity metadata.
- Include reset or initialization behavior sufficient for repeated benchmark
  profiles without hidden state leakage.
- Add toy estimator fixtures that pass and fail the contract in observable ways.
- Add tests that prove dataset loading and metric aggregation are not required
  inside estimator implementations.
- Add a short neutral note or docstring describing the contract as benchmark
  plumbing, not a performance claim.

## Falsification Gate

The task must fail if an estimator can pass the contract while omitting required
input handling, returning out-of-range SOC without invalid metadata, leaking
state across resets, or importing dataset loaders or stats aggregators inside
the toy estimator.

## Validation Checklist

- Run the focused estimator contract tests, including at least one negative
  fixture.
- Run any target-repo lightweight formatting or lint command that is already
  documented or obvious from the inspected files.
- Run `git diff --check`.
- Record changed files and exact validation command results in the worker
  summary.

## Residual Risks

- The final module name depends on target-repo layout and must be chosen after
  inspection.
- A minimal contract may need later extension for batch estimators or methods
  that expose uncertainty; do not widen this task unless required by existing
  runner patterns.

## Next Concrete Task

After this merges, queue `phase-9-b-runner-profile-stress-protocol` so profile
stress protocols can consume the estimator contract without defining a second
adapter shape.
