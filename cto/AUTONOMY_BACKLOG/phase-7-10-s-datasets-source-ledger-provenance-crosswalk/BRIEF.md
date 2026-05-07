---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-s-datasets-source-ledger-provenance-crosswalk
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 75
---

# Phase 7.10.s - datasets source-ledger provenance crosswalk

You are a rigorous BSEBench dataset provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare a dataset-provenance crosswalk that helps future source-ledger and comparability tasks distinguish dataset identity, split identity, cache identity, and literature-source identity.

## Roadmap mapping

- Active lane: evidence generation.
- Phase 8/11 preparation: cross-dataset comparison and residual-decomposition provenance.
- Validation infrastructure: source-ledger comparability can only start after dataset identity and retrieval facts are explicit.

## Required behavior

- Review dataset manifests, loader metadata, local-cache provenance helpers, and the async research gate protocol.
- Add a template, fixture, or lightweight validator that maps dataset/config identifiers to required provenance fields: stable dataset URL or DOI when available, retrieval date, local cache root policy, split/profile label, chemistry label, loader name, and provenance caveat.
- Use synthetic rows or empty templates for fields that are not already known from committed metadata; do not invent provenance facts from memory.
- Mark unknown DOI, split, retrieval date, cache identity, or preprocessing details as gaps, not as inferred values.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to dataset provenance crosswalk work.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a dataset/config row can be marked comparison-ready while its stable URL or DOI, retrieval date, split/profile identity, loader identity, or provenance caveat is missing or unknown, the validator must fail.

## Validation

Run and record:

- focused positive and negative checks for complete, partial, and missing-provenance rows;
- a dry-run over the current candidate Phase 8/11 dataset/config list if such a list exists, otherwise a clearly labeled synthetic fixture run;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
