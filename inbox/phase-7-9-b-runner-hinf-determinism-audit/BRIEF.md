---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-9-b-runner-hinf-determinism-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 120
---

# Phase 7.9.b — strict Hinf determinism audit

You are a rigorous BSEBench reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a deterministic audit path that can compare a fresh strict Hinf run or dry-run-compatible recomputation against the committed strict 5x5 artifacts.

## Required behavior

- Add an audit script and tests in `bsebench-runner`.
- The audit must compare committed artifacts against deterministic expectations and, where feasible with local cache, recompute the strict evidence to a temporary path and compare:
  - ok config/filter counts;
  - guardrails;
  - key Hinf correlations;
  - decomposition shares;
  - artifact hashes or manifest entries.
- Do not overwrite committed evidence during the audit.
- Do not make a scientific verdict.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, or roadmap files.
- Do not make SOTA claims without a source ledger, stable URL/DOI, and comparability table.

## Falsification gate

If a fresh strict run drifts from committed evidence beyond explicit tolerances, the audit must exit non-zero and preserve diagnostic output outside committed artifacts.

## Validation

Run and record:

- the new audit on committed artifacts;
- if local cache allows, the fresh-run comparison to a temp directory;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
