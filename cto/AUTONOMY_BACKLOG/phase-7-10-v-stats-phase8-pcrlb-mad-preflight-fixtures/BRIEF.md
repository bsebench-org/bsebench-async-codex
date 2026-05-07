---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-v-stats-phase8-pcrlb-mad-preflight-fixtures
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.v - stats Phase 8 PCRLB MAD preflight fixtures

You are a rigorous BSEBench statistics validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Roadmap mapping

- Phase 8 preparation: PCRLB/MAD ratio validation before cross-chemistry claim work.
- Phase 11 preparation: sensor-floor inputs and residual decomposition sanity checks.
- Active lane: Evidence generation only.

## Goal

Add preflight fixtures for PCRLB/MAD ratio inputs so future Phase 8 and Phase 11 statistics commands fail before producing misleading finite-looking numbers.

## Required behavior

- Review existing PCRLB, MAD, sensor-floor, or replay-summary utilities in `bsebench-stats`.
- Add validation helpers or fixture tests for required input fields: dataset/config, chemistry/profile metadata, MAD units, PCRLB units, sample count, split/run condition, provenance identity, and finite numeric arrays.
- The preflight must distinguish missing metadata, unit mismatch, zero or negative variance, non-finite values, sample-count imbalance, and provenance unknown.
- Output must be mechanical-only JSON or test assertions; do not create a claim verdict or SOTA comparison.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this PCRLB/MAD preflight task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If PCRLB/MAD preflight accepts missing provenance, mismatched units, non-finite values, zero or negative variance, or an unstated split/run condition as ready, the task must fail and mark the candidate input invalid.

## Validation

Run and record:

- focused tests for valid, missing-metadata, unit-mismatch, non-finite, non-positive-variance, sample-imbalance, and provenance-unknown fixtures;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
