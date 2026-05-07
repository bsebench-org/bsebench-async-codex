---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-c-datasets-auditj-cache-gap-report
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.c - datasets Audit J cache gap report

You are a rigorous BSEBench datasets engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Turn Audit J local-cache root resolution into a read-only gap report for strict and near-future evidence configs.

## Required behavior

- Add or extend a read-only command that reports cache-root coverage, required-file presence, and loader-readiness metadata.
- Output JSON must be finite and must not print secrets or token values.
- Include strict Hinf configs and adjacent Phase 8/11 prep datasets when those are already represented in dataset metadata.
- Do not download data, mutate local caches, or commit machine-local absolute paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not make SOTA, novelty, or verified-claim statements without a source ledger and comparability table.

## Falsification gate

If a dataset appears covered by filenames but fails loader-readiness checks, the report must mark it not ready and explain the local reason without hiding it.

## Validation

Run and record:

- focused tests for present, missing, and unreadable local-cache roots;
- the read-only real command against available local roots;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
