---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-q-stats-hinf-fragility-null-controls
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.q - stats Hinf fragility null controls

You are a rigorous BSEBench stats validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make the strict Hinf residual-covariance evidence harder to overread by adding null-control or perturbation checks that quantify whether the observed Hinf separation is fragile.

## Roadmap mapping

- Phase 7: Hinf evidence fragility and mechanism validation, without a scientific verdict.
- Phase 11 preparation: residual-decomposition robustness checks over frozen trace payloads.
- Validation infrastructure: independent replay over committed artifacts, not new claim work.

## Active lane

Evidence generation, validation infrastructure only. The handoff artifact is a machine-readable fragility/null-control report over frozen Hinf evidence with explicit pass, fail, mismatch, and inconclusive fields.

## Required behavior

- Consume frozen runner Hinf residual evidence and stats replay inputs; do not regenerate filters or edit runner outputs.
- Add a deterministic null-control, label-perturbation, or threshold-sensitivity report that makes the Hinf separation mechanically checkable.
- The report must distinguish supported, fragile, inconclusive, and replay-mismatch states.
- Missing strict configs, non-finite values, changed replay values, or absent provenance must be recorded as validation failures or explicit gaps.
- No thesis or claim registry edits are permitted.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this validation task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if replay over the frozen Hinf evidence has any mismatch, if a null-control can reproduce the apparent Hinf separation within the configured tolerance, if any strict config is silently dropped, or if the report cannot state whether the evidence is supported, fragile, inconclusive, or invalid.

## Validation

Run and record:

- focused tests for replay mismatch, non-finite payloads, silently dropped configs, and a null-control that should mark the result fragile;
- a real replay/null-control command over the committed strict Hinf evidence bundle;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
