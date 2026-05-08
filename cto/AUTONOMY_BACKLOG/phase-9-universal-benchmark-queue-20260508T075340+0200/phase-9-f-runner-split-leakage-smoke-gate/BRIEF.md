---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-9-f-runner-split-leakage-smoke-gate
base_branch: main
hard_wallclock_min: 60
---

# Phase 9.f - runner split-leakage smoke gate

You are a rigorous anti-leakage engineer. You are not alone in this codebase;
do not revert or overwrite unrelated edits.

## Objective

Add a runner smoke gate that separates calibration, tuning, and evaluation
splits for universal SOC/SOH benchmarking before profile-stress or public
submission workflows can be treated as ready.

## Inputs Inspected

This queue-pack author inspected:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`
- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`
- `cto/AUTONOMY_BACKLOG/README.md`

Before editing, inspect the target repository and record the actual files read.

## Decisions

- Active lane: evidence generation. Produce split/leakage validation evidence
  only.
- Owned write scope in the target repo: split-leakage smoke gate, split
  fixtures, and focused split-leakage tests only.
- Keep this independent from estimator-contract files, profile-stress protocol
  files, dataset profile manifests, stats metric envelopes, async submission
  templates, thesis files, manuscript files, roadmap files, claim registry
  files, `claims/registry.yaml`, and `claim_55`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim
  statements without a completed source ledger, stable URL or DOI, retrieval
  date, metric, dataset, split, BSEBench frozen value, and comparability caveat.

## Required Behavior

- Add a smoke gate or equivalent local pattern that validates calibration,
  tuning, and evaluation identifiers are declared and non-overlapping.
- Include fixture cases for valid splits, overlapping calibration/evaluation,
  missing tuning declaration, and unknown split identity.
- Ensure failures report the split ids involved rather than only exiting
  non-zero.
- Keep the gate mechanical; it must not interpret estimator performance.

## Falsification Gate

The task must fail if overlapping calibration, tuning, or evaluation split ids
can pass as valid, or if a missing split declaration is silently accepted.

## Validation Checklist

- Run focused split-leakage tests for valid and invalid fixtures.
- Run any target-repo lightweight formatting or lint command that is already
  documented or obvious from the inspected files.
- Run `git diff --check`.
- Record changed files and exact validation command results in the worker
  summary.

## Residual Risks

- Existing runner split metadata may be incomplete. Report missing identity as
  a blocker rather than relaxing the smoke gate.
- Cross-dataset leakage checks may require dataset-side provenance fields from
  later tasks.

## Next Concrete Task

After this merges, queue an integration task that runs the split-leakage smoke
gate before profile-stress protocol execution.
