---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-8-h-datasets-auditj-local-cache-manifest
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.8.h — Audit J local cache manifest

You are a rigorous BSEBench datasets reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits. Keep the write scope narrow.

## Goal

Create a read-only local cache manifest/probe for the datasets that can support future expanded Hinf evidence beyond the strict 5x5 bundle.

## Required behavior

- Probe only local filesystem/cache state; do not download large data or require network access.
- Emit a machine-readable manifest with dataset/profile/temperature or equivalent identity, local path availability, file sizes, and hashes where practical.
- Distinguish "missing", "present but unreadable", and "present and loader-readable".
- Keep this as infrastructure for future expanded evidence, not a scientific result.
- Do not edit thesis files, claim registry, or research roadmap.

## Falsification gate

The manifest must fail or mark gaps explicitly when local data cannot support an expanded evidence target. It must not infer availability from intended configs alone.

## Validation

Run and record:

- the new dry-run/probe command
- focused tests with synthetic local cache fixtures
- `uv run pytest tests/ -m "not slow" -q`
- `uv run ruff check .`

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
