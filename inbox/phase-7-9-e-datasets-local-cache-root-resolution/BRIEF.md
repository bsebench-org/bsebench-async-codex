---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-9-e-datasets-local-cache-root-resolution
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 75
---

# Phase 7.9.e — local cache root resolution for Audit J manifest

You are a rigorous BSEBench datasets reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Improve the Audit J local cache manifest so it can discover or clearly report cache root configuration instead of showing all 26 configs missing when local data exists elsewhere.

## Required behavior

- Inspect the existing manifest CLI and local cache conventions.
- Add deterministic root-resolution helpers or documentation that map env vars and `_datasets` layout to supported wrappers.
- Do not download data.
- Do not commit machine-specific absolute paths as required defaults.
- Preserve explicit gaps when data is unavailable.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, or roadmap files.
- Do not make SOTA claims without a source ledger, stable URL/DOI, and comparability table.

## Falsification gate

If local cache roots cannot be resolved portably, the tool must explain the missing configuration and exact env vars/CLI overrides needed. It must not pretend evidence is ready.

## Validation

Run and record:

- synthetic tests for env var, CLI override, and missing-root cases;
- local dry-run/probe with `--allow-gaps`;
- `uv run --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --all-extras ruff check .`;
- `uv run --all-extras ruff format --check .`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
