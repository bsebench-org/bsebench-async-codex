---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-13-b-runner-ensemble-member-registry-preflight
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 13.b - runner ensemble member registry preflight

You are a rigorous BSEBench runner preflight engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a local member registry preflight for Phase 13 ensemble candidates.

## Active lane

Registry validation only. Do not schedule ensemble runs and do not compute ensemble outputs.

## Required behavior

- Enumerate locally available member artifacts, config IDs, seed IDs, split IDs, dataset/source labels, chemistry labels, artifact hashes when cheap, and sanitizer status.
- Mark members not ready when missing, duplicate, split-incompatible, config-unknown, hash-unavailable, or stats-dependency-unknown.
- Output deterministic JSON suitable for a later predispatch budget.
- Do not upload, download, publish, or sync any dataset artifact.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 13 member registry.
- Do not make SOTA, novelty, leaderboard, breakthrough, or result claims without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The preflight must fail any ensemble member that cannot be tied to deterministic local artifact identity, split identity, and config provenance.

## Validation

Run and record:

- focused tests for ready member, missing artifact, duplicate member, split mismatch, config unknown, hash unavailable, stats unknown, and remote-operation blocked cases;
- a real local preflight over current member candidates without uploads or downloads;
- the repo standard non-slow tests if available;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. Do not add prohibited co-author trailers.
