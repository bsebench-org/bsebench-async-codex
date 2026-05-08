---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-an-stats-hinf-bootstrap-fragility-intervals
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.an - stats Hinf bootstrap fragility intervals

You are a rigorous BSEBench stats validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Stress the frozen Hinf residual evidence with deterministic bootstrap or jackknife intervals so unstable covariance/decomposition summaries are visible before claim-language work.

## Roadmap mapping

- Roadmap scope: Phase 7 Hinf evidence fragility and validation infrastructure.
- Active lane: Evidence generation, limited to mechanical sensitivity analysis over frozen runner artifacts.
- Handoff artifact: JSON/Markdown fragility interval report with input hashes, resampling seeds, interval widths, status fields, and explicit uncertainty gaps.

## Required behavior

- Consume committed runner Hinf evidence and stats replay outputs without regenerating runner filters.
- Add or extend a deterministic stats command that computes bootstrap or jackknife intervals for selected Hinf residual covariance and variance-decomposition summaries.
- Report source identifiers, sample counts, seed list, interval method, compared values, width thresholds, and a machine-readable status such as `stable`, `fragile`, or `insufficient_evidence`.
- Treat missing source identity, insufficient samples, divergent ok-filter sets, non-finite values, or seed-sensitive status changes as evidence gaps.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf bootstrap-fragility task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If interval width exceeds the configured fragility threshold, the status changes across deterministic seed sets, source identity is missing, or ok-filter sets diverge, the report must mark the evidence fragile or insufficient and block downstream claim registration.

## Validation

Run and record:

- focused tests for stable intervals, threshold-exceeding intervals, seed-sensitive intervals, missing source identity, insufficient samples, and non-finite values;
- a read-only real fragility-interval run against `../bsebench-runner/outputs/hinf_residual_evidence_5x5.json`;
- `uv run --locked --all-extras pytest tests/ -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
