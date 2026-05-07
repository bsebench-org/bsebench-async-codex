---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-u-runner-phase11-residual-artifact-contract
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.u - runner Phase 11 residual artifact contract

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Roadmap mapping

- Phase 11 preparation: sensor-noise versus model-mismatch residual decomposition tooling.
- Research-gate lane: manifest and artifact contract validation before expensive evidence generation.
- Active lane: Evidence generation only.

## Goal

Define and validate a dry-run residual artifact contract for Phase 11 so future residual-decomposition runs have replayable paths, provenance fields, and fail-loud readiness status before filters run.

## Required behavior

- Review current residual trace export, Hinf evidence bundle, and Phase 11 preflight hooks in `bsebench-runner`.
- Add or extend a dry-run command, schema fixture, or tests that define required fields for residual trace artifacts: dataset/config, filter, command, stats dependency, dataset provenance identity, output path, hash placeholder or final hash, finite numeric policy, and replay command.
- The dry run must not execute filters or commit empirical residual outputs.
- Readiness must distinguish missing dataset provenance, missing stats identity, missing replay command, and unsupported filter/config combinations.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 11 artifact-contract task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a Phase 11 residual artifact can be marked ready without dataset provenance identity, stats dependency identity, finite numeric policy, and a replay command, the contract must fail and mark downstream scheduling blocked.

## Validation

Run and record:

- focused tests for ready, provenance-missing, stats-unknown, replay-missing, unsupported-filter, and non-finite-policy cases;
- a real dry-run over the current Phase 11 candidate config set without running filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
