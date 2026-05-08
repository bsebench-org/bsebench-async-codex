---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-13-c-stats-ensemble-aggregation-contract
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 13.c - stats ensemble aggregation contract

You are a rigorous BSEBench statistical methods engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Define deterministic aggregation rules for Phase 13 ensembles before empirical evaluation.

## Active lane

Contract implementation only. Do not claim that any ensemble improves results.

## Required behavior

- Validate allowed aggregation families, member alignment, weight sources, tie handling, uncertainty propagation inputs, calibration fold identity, and test-fold isolation.
- Reject learned weights derived from test folds or from unknown provenance.
- Output deterministic validation artifacts for mean, median, fixed-weight, and calibration-weighted candidates where applicable.
- Do not upload, download, publish, or sync any dataset artifact.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 13 aggregation contract.
- Do not make SOTA, novelty, leaderboard, breakthrough, or result claims without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The contract must fail any aggregation whose weights, folds, member alignment, uncertainty inputs, or metric units cannot be validated before test evaluation.

## Validation

Run and record:

- focused tests for allowed mean/median/fixed-weight/calibration-weighted contracts, test-derived weight rejection, member misalignment, missing uncertainty, missing metric units, and unknown provenance;
- local fixture validation without claiming empirical performance;
- the repo standard non-slow tests if available;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. Do not add prohibited co-author trailers.
