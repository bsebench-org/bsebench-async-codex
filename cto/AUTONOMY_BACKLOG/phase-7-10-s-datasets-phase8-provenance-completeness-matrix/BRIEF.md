---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-s-datasets-phase8-provenance-completeness-matrix
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.s - datasets Phase 8 provenance completeness matrix

You are a rigorous BSEBench dataset provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 8 cross-chemistry work by making dataset provenance gaps visible before runner jobs can treat a config as evidence-ready.

## Active lane

Evidence generation. Produce provenance-readiness metadata only; do not run filters or interpret cross-chemistry performance.

## Required behavior

- Review `src/bsebench_datasets/hinf_loader_provenance.py`, `src/bsebench_datasets/auditj_local_cache_manifest.py`, dataset manifests, and current adapter tests.
- Add or extend a deterministic provenance completeness matrix for Phase 8 candidate datasets/configs with dataset id, adapter id, loader id, split/profile, chemistry when known, local-cache readiness, source URL/DOI or accession identifier when available, citation/license metadata status, and explicit gap fields.
- Treat unknown source, split, chemistry, cache, license, or citation metadata as a gap; do not infer it from memory.
- The matrix may use dry-run local cache probing, but must not upload/download datasets or create empirical filter outputs.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8 provenance matrix.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any Phase 8 candidate row is marked evidence-ready while source identity, split/profile identity, local-cache readiness, adapter identity, or citation/license status is missing, the task must fail and report the row as blocked by provenance gaps.

## Validation

Run and record:

- focused tests for complete provenance, missing source identifier, missing split/profile, missing cache, missing citation/license metadata, and unknown chemistry;
- a real dry-run matrix command over the current Phase 8 candidate set without downloads or filter execution;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
