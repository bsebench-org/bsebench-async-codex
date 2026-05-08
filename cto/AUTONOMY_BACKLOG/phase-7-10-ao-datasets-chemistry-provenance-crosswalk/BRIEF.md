---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-ao-datasets-chemistry-provenance-crosswalk
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ao - datasets chemistry provenance crosswalk

You are a rigorous BSEBench datasets provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 8 cross-chemistry work by making chemistry, cell family, source identity, and provenance gaps explicit before any cross-dataset comparison is scheduled.

## Roadmap mapping

- Roadmap scope: Phase 8 cross-chemistry extension plus validation infrastructure that blocks false comparisons.
- Active lane: Evidence generation, limited to read-only dataset metadata and provenance checks.
- Handoff artifact: sanitized crosswalk report mapping dataset/config identifiers to chemistry labels, source identity, manifest fields, loader readiness, and missing provenance fields.

## Required behavior

- Reuse existing dataset manifests, adapter metadata, local-cache manifests, or provenance audit helpers where practical.
- Add or extend a read-only command that reports dataset identifier, adapter, chemistry, cell family, source URL or DOI when known, retrieval/source date field when known, license/provenance field when known, local-cache hash status, and loader readiness.
- The command must distinguish explicit metadata, loader-derived metadata, unknown metadata, not-applicable fields, and unsafe filename-derived guesses.
- Unknown chemistry, source identity, license/provenance, hash status, or loader failure must be explicit gaps and must not be inferred from filenames.
- Do not download data, mutate caches, or commit machine-local absolute paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this chemistry provenance crosswalk.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a dataset/config can be marked Phase 8 comparison-ready while chemistry, source identity, provenance/license, required hash status, or loader readiness is unknown or filename-inferred, the task must fail or mark that dataset `not_ready_for_cross_chemistry`.

## Validation

Run and record:

- focused tests for explicit chemistry provenance, missing chemistry, missing source identity, missing hash status, loader failure, and filename-derived guess rejection;
- one real read-only chemistry-provenance crosswalk command against available manifests or local cache roots;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
