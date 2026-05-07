---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-ac-datasets-phase8-source-ledger-readiness
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ac - datasets Phase 8 source-ledger readiness

You are a rigorous BSEBench datasets provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 8 cross-chemistry comparisons by auditing whether dataset metadata can populate a source-ledger comparability row before any SOTA or novelty comparison is attempted.

## Roadmap mapping

- Phase 8 preparation: cross-chemistry extension needs explicit dataset, split, metric, and preprocessing identity.
- Research-gate lane: SOTA or novelty comparisons require stable source metadata and comparability caveats.
- Active lane: dataset provenance and comparison-readiness validation only.

## Required behavior

- Reuse existing dataset registry, adapter metadata, cache manifest, or loader descriptors where available.
- Add or extend a read-only command that reports, for candidate Phase 8 datasets, whether local metadata can provide dataset identifier, chemistry, profile, temperature, split/run condition, metric compatibility hints, preprocessing caveats, and stable source URL or DOI when already known.
- The command must not download data, mutate caches, invent external literature rows, or infer missing source metadata from memory.
- Output JSON must distinguish `ready`, `partial`, `not_comparable`, `unknown_metadata`, and `not_applicable`, and must not print secrets or token values.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to Phase 8 source-ledger readiness.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a dataset lacks stable source identity, split/run-condition metadata, metric compatibility, or preprocessing caveats, the readiness report must mark the row `partial`, `not_comparable`, or `unknown_metadata` and must fail any strict-ready summary.

## Validation

Run and record:

- focused tests for ready, partial, not-comparable, unknown-metadata, and missing-source-identity cases;
- one read-only local readiness command against available dataset metadata or local roots;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
