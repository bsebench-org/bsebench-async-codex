---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-8-c-datasets-hinf-loader-provenance-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 75
---

# Phase 7.8.c — strict Hinf loader/cache provenance audit

You are a rigorous BSEBench datasets engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits. Keep the write scope narrow.

## Goal

Add a lightweight provenance audit for dataset loaders used by the strict Hinf 5x5 evidence path.

## Required behavior

- Identify the strict Hinf evidence configs from `bsebench-runner` and the corresponding dataset loader modules in `bsebench-datasets`.
- Add a read-only audit script or focused tests that verify loader/cache provenance contracts without downloading large data.
- Prefer synthetic or monkeypatched filesystem fixtures over network access.
- The audit should check that the loader path/source identity cannot silently disappear from strict-evidence runs.
- If a loader currently lacks explicit provenance fields, document that as a machine-readable gap rather than inventing provenance.

## Falsification gate

The audit must fail if a strict-evidence loader can no longer be mapped to a deterministic local-cache/source identity. It must not fabricate source metadata.

## Validation

Run and record:

- focused provenance tests or the new audit script
- `uv run pytest tests/ -m "not slow" -q`
- `uv run ruff check .`

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
