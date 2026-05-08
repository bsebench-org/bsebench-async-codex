---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-13-e-runner-ensemble-provenance-manifest
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 13.e - runner ensemble provenance manifest

You are a rigorous BSEBench provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a deterministic provenance manifest for Phase 13 ensemble member identity.

## Active lane

Provenance and sanitizer validation only. Do not compute ensemble results.

## Required behavior

- Produce a manifest linking each ensemble candidate to member artifact hashes, config IDs, seed IDs, split IDs, dataset/source labels, chemistry labels, aggregation contract ID, and sanitizer status.
- Mark entries not ready when hashes cannot be computed locally, member identity is incomplete, source labels are missing, or sanitizer checks fail.
- Avoid recording local-machine paths as scientific evidence; use sanitized paths or repository-relative identifiers where possible.
- Do not upload, download, publish, or sync any dataset artifact.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 13 provenance manifest.
- Do not make SOTA, novelty, leaderboard, breakthrough, or result claims without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The manifest must fail if member artifact identity, hash, split ID, config provenance, or sanitizer status cannot be verified locally.

## Validation

Run and record:

- focused tests for ready manifest, missing hash, missing config ID, missing split ID, missing source label, sanitizer failure, and remote-operation blocked cases;
- a local dry-run manifest over current ensemble candidates without empirical aggregation;
- the repo standard non-slow tests if available;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. Do not add prohibited co-author trailers.
