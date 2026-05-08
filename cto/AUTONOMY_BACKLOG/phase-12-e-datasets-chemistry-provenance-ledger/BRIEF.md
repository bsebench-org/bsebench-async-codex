---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-12-e-datasets-chemistry-provenance-ledger
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 12.e - datasets chemistry provenance ledger

You are a rigorous BSEBench provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a local chemistry provenance ledger schema for Phase 12 transfer readiness.

## Active lane

Provenance validation only. Do not infer missing chemistry and do not generate empirical evidence.

## Required behavior

- Define and validate a ledger format that binds chemistry labels to existing local metadata fields, dataset/config identifiers, source-file identity, loader identity, retrieval notes already present in repo artifacts, and redaction status.
- Provide deterministic validation output for complete, incomplete, ambiguous, and conflicting chemistry provenance.
- Do not use remote sources to fill gaps; unresolved gaps must be reported as not ready.
- Do not upload, download, publish, or sync any dataset artifact.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 12 provenance ledger.
- Do not make SOTA, novelty, leaderboard, breakthrough, or result claims without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The ledger validator must fail any chemistry label that is inferred, undocumented, conflicting, or missing source identity.

## Validation

Run and record:

- focused tests for complete ledger, missing source, ambiguous chemistry, conflicting chemistry, missing retrieval note, redaction failure, and remote-operation blocked cases;
- a local validation dry-run over existing metadata fixtures;
- the repo standard non-slow tests if available;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. Do not add prohibited co-author trailers.
