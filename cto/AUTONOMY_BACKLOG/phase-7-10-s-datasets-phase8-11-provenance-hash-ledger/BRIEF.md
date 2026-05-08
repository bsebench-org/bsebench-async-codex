---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-s-datasets-phase8-11-provenance-hash-ledger
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.s - datasets Phase 8/11 provenance hash ledger

You are a rigorous BSEBench datasets provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 8 cross-chemistry and Phase 11 residual-decomposition work with a provenance/hash ledger that separates loader readiness from source identity and local cache availability.

## Active lane

Evidence generation: read-only provenance validation over dataset manifests, adapters, and local-cache metadata. The handoff artifact is a sanitized JSON/Markdown ledger with source identity, hash status, loader readiness, and explicit gaps.

## Required behavior

- Extend the existing Audit J / Hinf provenance audit machinery or add a small read-only command for Phase 8/11 candidate datasets already represented in dataset metadata.
- For each candidate dataset/config, report manifest identifier, adapter name, source URL or DOI when known, retrieval/source date field when known, license/provenance field when known, required raw/cache file hash status, loader readiness, and sanitized local-cache status.
- Never print secrets or token values, never download data, and never commit machine-local absolute paths as scientific evidence.
- Unknown source identity, missing hashes, missing license/provenance, or loader failures must be explicit gaps and must not be inferred from filenames.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8/11 provenance ledger.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any dataset is marked loader-ready while source identity, required hash status, or provenance/license fields are unknown, the ledger must fail or mark that dataset `not_ready_for_claim_support` with the missing fields listed.

## Validation

Run and record:

- `uv run --locked --all-extras pytest tests/test_phase8_11_provenance_hash_ledger.py -q`;
- a real read-only provenance ledger command against available local roots with sanitized paths;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
