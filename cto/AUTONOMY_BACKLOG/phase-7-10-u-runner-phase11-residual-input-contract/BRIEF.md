---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-u-runner-phase11-residual-input-contract
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.u - runner Phase 11 residual input contract

You are a rigorous BSEBench runner preflight engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a dry-run input contract check for Phase 11 residual-decomposition runs before expensive residual traces are scheduled.

## Active lane

Evidence generation: preflight validation, not scientific interpretation. The handoff artifact is a deterministic readiness JSON describing residual input fields, units, source provenance, stats dependency identity, and blocking gaps.

## Required behavior

- Add or extend a dry-run command that inspects intended Phase 11 residual trace inputs without running filters.
- The preflight must verify dataset/config identifiers, voltage/current/time units, sample count availability, residual component fields needed for sensor-noise versus model-mismatch decomposition, PCRLB/MAD floor input availability when applicable, stats dependency identity, and sanitized provenance/cache readiness.
- Output JSON must distinguish `ready`, `not_ready`, and `insufficient_metadata` per config with concrete blocking reasons.
- Do not generate new empirical residual traces, do not commit local-machine paths as evidence, and do not assert any Phase 11 scientific result.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 11 residual input contract.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a Phase 11 candidate config lacks required units, timebase, residual component fields, sample counts, provenance/cache readiness, or stats dependency identity, the preflight must mark it not ready and block downstream scheduling.

## Validation

Run and record:

- `uv run --locked --all-extras pytest tests/test_phase11_residual_input_contract.py -q`;
- a real dry-run preflight over the current Phase 11 candidate config set without running filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
