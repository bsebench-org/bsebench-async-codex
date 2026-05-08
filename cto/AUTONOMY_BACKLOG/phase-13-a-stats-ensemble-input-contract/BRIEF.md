---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-13-a-stats-ensemble-input-contract
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 13.a - stats ensemble input contract

You are a rigorous BSEBench statistical validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add an input contract for Phase 13 ensemble methods before any ensemble aggregation is computed.

## Active lane

Input validation only. Do not compute ensemble results or claim performance changes.

## Required behavior

- Validate member prediction identity, config ID, seed ID, split ID, chemistry/source labels, calibration/test boundaries, metric units, uncertainty fields, and provenance identity.
- Output deterministic `ready`, `not_ready`, and `insufficient_metadata` statuses with concrete blocking reasons.
- Reject member inputs that lack split identity, metric denominator, provenance, or calibration/test isolation.
- Do not upload, download, publish, or sync any dataset artifact.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 13 ensemble input contract.
- Do not make SOTA, novelty, leaderboard, breakthrough, or result claims without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The contract must fail if any member prediction lacks deterministic identity, split provenance, metric units, or calibration/test isolation.

## Validation

Run and record:

- focused tests for ready input, missing member ID, missing split ID, calibration/test leakage, missing metric units, missing uncertainty field, missing provenance, and remote-operation blocked cases;
- a local fixture validation dry-run without computing final ensemble metrics;
- the repo standard non-slow tests if available;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. Do not add prohibited co-author trailers.
