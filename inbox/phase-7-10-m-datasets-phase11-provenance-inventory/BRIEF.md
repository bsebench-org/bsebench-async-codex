---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-m-datasets-phase11-provenance-inventory
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.m - datasets Phase 11 provenance inventory

You are a rigorous BSEBench datasets provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 11 sensor-noise versus model-mismatch work with a read-only provenance inventory for residual-decomposition candidate datasets.

## Required behavior

- Reuse existing dataset registry, adapter metadata, Audit J cache manifest logic, or loader descriptors where available.
- Add or extend a read-only command that reports dataset identifier, chemistry/profile/temperature fields when known, local-cache readiness, voltage/current units, sampling cadence availability, and provenance gaps.
- Output JSON must distinguish `ready`, `missing`, `unreadable`, `unknown_metadata`, and `not_applicable` without printing secrets or token values.
- Do not download data, mutate local caches, or commit machine-local absolute paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 11 preflight.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a dataset lacks enough metadata to support residual decomposition or sensor-floor analysis, the inventory must mark `unknown_metadata` or `not_ready` and must not infer units, cadence, chemistry, profile, or split from filenames alone.

## Validation

Run and record:

- focused tests for ready, missing, unreadable, unknown-metadata, and unit/cadence-gap cases;
- one read-only local inventory command against available local roots;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
