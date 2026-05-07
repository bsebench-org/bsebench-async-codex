---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-i-datasets-phase8-cache-probe
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.i - datasets Phase 8 cache probe

You are a rigorous BSEBench datasets engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a read-only cache probe for Phase 8/11 candidate datasets so future cross-dataset work starts from known local availability instead of assumptions.

## Required behavior

- Reuse existing dataset registry or adapter metadata where available.
- Probe only metadata and local file presence/readiness; do not download or mutate caches.
- Output JSON must clearly separate `ready`, `missing`, `unreadable`, and `unknown_metadata`.
- Do not commit machine-local evidence as a scientific result.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not make SOTA, novelty, or verified-claim statements without a source ledger and comparability table.

## Falsification gate

If a dataset lacks enough metadata to define required local files, the report must mark `unknown_metadata` rather than pretending the cache is missing or ready.

## Validation

Run and record:

- focused tests for ready, missing, unreadable, and unknown-metadata cases;
- one read-only local probe command;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
