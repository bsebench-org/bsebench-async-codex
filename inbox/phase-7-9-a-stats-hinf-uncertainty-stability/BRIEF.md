---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-9-a-stats-hinf-uncertainty-stability
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.9.a — Hinf uncertainty and stability audit

You are a rigorous BSEBench statistics engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Extend the stats-owned Hinf sensitivity work with uncertainty/stability diagnostics that quantify how fragile the strict 5x5 interpretation is.

## Required behavior

- Read `../bsebench-runner/outputs/hinf_residual_evidence_5x5.json`.
- Add a deterministic command or runner helper for:
  - bootstrap or jackknife intervals for Hinf correlations where mathematically valid;
  - leave-one-config-out summaries for decomposition shares;
  - explicit treatment of the NASA short-sample config.
- Emit JSON-safe output with finite values only.
- Keep output mechanical-only: no `verified`, no novelty, no SOTA, no thesis claim.

## Falsification gate

If uncertainty intervals or leave-one-config-out runs make the Hinf interpretation unstable, the output must say so explicitly and must not smooth it away.

## Validation

Run and record:

- synthetic tests for stable and unstable cases;
- real command against the committed strict Hinf evidence;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
