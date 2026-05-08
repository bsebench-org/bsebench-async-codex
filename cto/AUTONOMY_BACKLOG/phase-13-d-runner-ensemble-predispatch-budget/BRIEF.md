---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-13-d-runner-ensemble-predispatch-budget
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 13.d - runner ensemble predispatch budget

You are a rigorous BSEBench runner scheduling engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a local-only predispatch budget for Phase 13 ensemble candidates.

## Active lane

Scheduling review only. The output is a dry-run budget, not an execution queue.

## Required behavior

- Enumerate ensemble candidates, member counts, aggregation contract ID, expected local artifacts, estimated artifact footprint, skip reasons, and stats dependency identity.
- Mark candidates not ready when any member is missing, split-incompatible, duplicate, unhashable, calibration/test ambiguous, upload/download-dependent, or stats-contract-unknown.
- Do not enqueue empirical ensemble runs and do not create `QUEUED.json`.
- Do not upload, download, publish, or sync any dataset artifact.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 13 budget.
- Do not make SOTA, novelty, leaderboard, breakthrough, or result claims without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The budget must fail if it cannot explain member readiness, aggregation contract identity, local-only status, and deterministic skip reasons.

## Validation

Run and record:

- focused tests for ready budget, missing member, duplicate member, split mismatch, calibration/test ambiguity, upload blocked, download blocked, stats contract unknown, and empty candidate set cases;
- a real local dry-run budget over current ensemble candidates without running filters;
- the repo standard non-slow tests if available;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. Do not add prohibited co-author trailers.
