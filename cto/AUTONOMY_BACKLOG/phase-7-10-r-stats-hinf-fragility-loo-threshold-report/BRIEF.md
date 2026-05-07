---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-r-stats-hinf-fragility-loo-threshold-report
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.r - stats Hinf fragility LOO threshold report

You are a rigorous BSEBench statistics validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Roadmap mapping

- Phase 7: Hinf candidate fragility and stability diagnostics, without scientific verdicts.
- Research-gate lane: independent replay output that can weaken or block candidate interpretation.
- Active lane: Evidence generation only.

## Goal

Produce a mechanical leave-one-config-out fragility report over the committed strict Hinf residual evidence, with explicit thresholds and failure fields.

## Required behavior

- Review the existing Hinf stats replay and variance-decomposition stability tooling in `bsebench-stats`.
- Add or extend a command that reads the committed runner Hinf evidence bundle and reports per-left-out-config changes in covariance, decomposition, filter ranking, and threshold status.
- The report must be JSON, finite, deterministic, and clear that it is mechanical evidence only.
- Include threshold parameters in the output so independent validators can see what would count as fragile.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this fragility validation task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If leaving out any strict evidence config changes the candidate Hinf diagnostic status beyond the configured threshold, or if the command cannot state the threshold and changed fields, the task must fail or mark `fragility_status=material`.

## Validation

Run and record:

- focused tests for stable, materially changed, non-finite, and missing-config inputs;
- a real replay over the committed strict Hinf evidence bundle;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
