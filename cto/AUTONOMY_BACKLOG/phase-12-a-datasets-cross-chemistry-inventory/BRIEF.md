---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-12-a-datasets-cross-chemistry-inventory
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 12.a - datasets cross-chemistry inventory

You are a rigorous BSEBench datasets preflight engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a local dry-run inventory for Phase 12 cross-chemistry transfer candidates.

## Active lane

Evidence preparation only. Produce deterministic readiness metadata; do not generate empirical transfer results.

## Required behavior

- Add or extend a command/module that enumerates candidate dataset/config identifiers, chemistry labels, cell format, units, cadence, temperature, aging/SOH metadata, source provenance, and local cache status without remote access.
- Output finite JSON with `ready`, `not_ready`, and `insufficient_metadata` statuses per candidate.
- Distinguish missing chemistry, ambiguous chemistry, missing units, missing cadence, missing provenance, cache unavailable, loader unavailable, and unsupported remote operation.
- Do not upload, download, publish, or sync any dataset artifact.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 12 preflight.
- Do not make SOTA, novelty, leaderboard, breakthrough, or result claims without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The inventory must fail a candidate if chemistry identity, units, cadence, provenance, or local readiness cannot be verified from existing local metadata.

## Validation

Run and record:

- focused tests for ready, missing chemistry, ambiguous chemistry, missing units, missing provenance, cache unavailable, and remote-operation blocked cases;
- a real local dry-run over the current candidate registry without uploads or downloads;
- the repo standard non-slow tests if available;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. Do not add prohibited co-author trailers.
