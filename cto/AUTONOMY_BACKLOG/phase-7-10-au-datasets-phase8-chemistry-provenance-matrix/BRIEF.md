---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-au-datasets-phase8-chemistry-provenance-matrix
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.au - datasets Phase 8 chemistry provenance matrix

You are a rigorous BSEBench datasets provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 8 cross-chemistry validation with a source/provenance matrix that exposes which dataset/config candidates are comparable enough to schedule.

## Active lane

Evidence generation: provenance preflight only. The handoff artifact is a deterministic matrix of chemistry, dataset identity, split/profile metadata, source identity, cache readiness, and blocking gaps.

## Required behavior

- Review dataset metadata, Audit J cache/provenance tooling, and runner Phase 8 candidate config expectations.
- Add or extend a read-only command or fixture-backed report that maps Phase 8 candidate datasets to chemistry, cell/source family, profile/split, units, local cache status, loader readiness, and source identity.
- The report must distinguish known source, partial source, unknown source, cache missing, loader missing, and metadata incomplete.
- Do not download data, mutate local caches, or commit machine-local absolute paths as scientific evidence.
- Do not assert cross-chemistry validity, ceiling behavior, SOTA, novelty, or a scientific verdict.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8 provenance matrix.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any Phase 8 candidate lacks deterministic source identity, split/profile metadata, unit metadata, or loader/cache readiness, the matrix must mark it not schedulable and block downstream cross-dataset comparison work.

## Validation

Run and record:

- focused tests for known-source, partial-source, unknown-source, cache-missing, loader-missing, and metadata-incomplete rows;
- a read-only real provenance matrix command against available local metadata/cache roots;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
