---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-aw-runner-phase11-pcrlb-mad-preflight-ci
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.aw - runner Phase 11 PCRLB/MAD preflight CI

You are a rigorous BSEBench runner preflight engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a CI-suitable dry-run preflight for Phase 11 PCRLB/MAD residual-decomposition inputs before expensive evidence generation is scheduled.

## Active lane

Evidence generation: preflight validation, not scientific interpretation. The handoff artifact is a deterministic readiness report for Phase 11 input contracts and CI failure conditions.

## Required behavior

- Review runner residual-input contracts, stats PCRLB/MAD preflight expectations, and datasets provenance metadata.
- Add or extend a dry-run command that validates Phase 11 candidate configs for voltage/current/time units, sample cadence, sample count availability, residual field availability, PCRLB/MAD input availability, stats dependency identity, and sanitized provenance/cache readiness.
- The command must not run filters or regenerate empirical evidence.
- CI output must be finite JSON or stable text with machine-readable ready/not-ready counts and blocking reasons.
- Do not assert sensor-floor, model-mismatch, residual decomposition, SOTA, novelty, or verified-claim results.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 11 PCRLB/MAD preflight.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a Phase 11 config with missing units, missing cadence, missing residual fields, missing PCRLB/MAD inputs, missing sample counts, or unknown stats dependency can be marked ready, this task must fail and block CI adoption.

## Validation

Run and record:

- focused tests for ready, missing-units, missing-cadence, missing-residual-field, missing-PCRLB-MAD-input, missing-sample-count, and unknown-stats-dependency cases;
- a real dry-run over the current Phase 11 candidate config set without running filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
