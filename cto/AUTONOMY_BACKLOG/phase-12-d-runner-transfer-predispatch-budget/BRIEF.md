---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-12-d-runner-transfer-predispatch-budget
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 12.d - runner transfer predispatch budget

You are a rigorous BSEBench runner scheduling engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a local-only dry-run budget for Phase 12 transfer candidates before any expensive run is scheduled.

## Active lane

Predispatch review only. The output is a budget and skip-reason manifest, not a run queue.

## Required behavior

- Enumerate candidate source/target chemistry pairs, filter IDs, config IDs, expected local artifact paths, estimated artifact footprint, stats dependency identity, and skip reasons.
- Mark candidates not ready when they require upload/download, remote dataset access, missing local cache, missing filter, incomplete chemistry metadata, split uncertainty, or unknown stats dependency.
- Do not enqueue empirical runs and do not create `QUEUED.json`.
- Do not upload, download, publish, or sync any dataset artifact.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 12 budget.
- Do not make SOTA, novelty, leaderboard, breakthrough, or result claims without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The budget must fail if any candidate cannot explain local readiness, dependency identity, skip reason, and no-upload/no-download status deterministically.

## Validation

Run and record:

- focused tests for ready budget, cache missing, upload blocked, download blocked, filter missing, split incomplete, stats unknown, and empty candidate set cases;
- a real dry-run budget over current candidate configs without running filters;
- the repo standard non-slow tests if available;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. Do not add prohibited co-author trailers.
