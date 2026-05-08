---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-12-b-runner-transfer-split-contract
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 12.b - runner transfer split contract

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a dry-run contract that proves source/target chemistry split isolation before Phase 12 transfer runs can be scheduled.

## Active lane

Scheduling preflight only. The handoff artifact is a deterministic split-readiness JSON, not a scientific result.

## Required behavior

- Verify source chemistry, target chemistry, dataset/config identity, cell identifiers, train/calibration/test split IDs, filter identity, and output path sanitizer status without running filters.
- Detect and block source/target leakage, duplicate cell IDs across incompatible splits, missing split keys, missing chemistry labels, unknown filters, and unknown stats dependency identity.
- Output `ready`, `not_ready`, and `insufficient_metadata` statuses with concrete blocking reasons.
- Do not upload, download, publish, or sync any dataset artifact.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 12 transfer split contract.
- Do not make SOTA, novelty, leaderboard, breakthrough, or result claims without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The contract must fail if any source/target split identity overlaps, cannot be traced to deterministic IDs, or depends on inferred chemistry metadata.

## Validation

Run and record:

- focused tests for ready, missing split key, source/target leakage, duplicate cell ID, missing chemistry, filter missing, stats dependency unknown, and remote-operation blocked cases;
- a real dry-run over the current Phase 12 candidate configs without running filters;
- the repo standard non-slow tests if available;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. Do not add prohibited co-author trailers.
