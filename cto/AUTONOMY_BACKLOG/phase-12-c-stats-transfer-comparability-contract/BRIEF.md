---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-12-c-stats-transfer-comparability-contract
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 12.c - stats transfer comparability contract

You are a rigorous BSEBench statistical validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a Phase 12 comparability contract that blocks invalid cross-chemistry pooled comparisons before reports or result tables are generated.

## Active lane

Statistical contract and validation only. Do not compute or claim transfer performance.

## Required behavior

- Validate chemistry, dataset source, drive profile, temperature, aging/SOH, cadence, metric units, denominator, split identity, filter identity, and uncertainty fields for transfer comparisons.
- Produce a deterministic comparability matrix with allowed, blocked, and stratify-only decisions plus concrete reasons.
- Reject pooled comparisons when chemistry or protocol fields are missing, incomparable, or only inferable.
- Do not upload, download, publish, or sync any dataset artifact.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 12 comparability contract.
- Do not make SOTA, novelty, leaderboard, breakthrough, or result claims without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The contract must fail any comparison whose metric units, denominator, split identity, chemistry metadata, or protocol stratification cannot be validated.

## Validation

Run and record:

- focused tests for allowed, blocked, stratify-only, missing chemistry, missing denominator, mismatched cadence, mismatched temperature, missing uncertainty, and unsupported pooling cases;
- a local fixture matrix showing no empirical result claims;
- the repo standard non-slow tests if available;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. Do not add prohibited co-author trailers.
