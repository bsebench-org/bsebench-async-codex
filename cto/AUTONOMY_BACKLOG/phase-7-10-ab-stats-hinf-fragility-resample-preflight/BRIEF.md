---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-ab-stats-hinf-fragility-resample-preflight
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ab - stats Hinf fragility resample preflight

You are a rigorous BSEBench statistics engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a mechanical preflight that shows whether the Hinf residual covariance/decomposition summary is fragile under deterministic resampling or leave-one-config perturbations before any candidate interpretation is trusted.

## Active lane

Evidence generation and validation infrastructure only. The handoff artifact is a replayable fragility preflight JSON summary, not a claim decision.

## Required behavior

- Read the existing Hinf stats replay, uncertainty report, sensitivity report, and leave-one-config tooling.
- Add a deterministic synthetic-testable resample or perturbation preflight that records seed/config identity, perturbation rule, compared fields, mismatch count, and materiality flags.
- The report must distinguish numerical instability, sample-count imbalance, missing config coverage, and threshold-dependent fragility.
- Output JSON must be finite and must keep mechanical evidence language only.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf candidate fragility validation.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If deterministic perturbations change the mechanical Hinf fragility status, produce non-finite output, or hide a non-zero mismatch count, the preflight must mark the evidence fragile or threshold-dependent and must not collapse it into a stable-looking verdict.

## Validation

Run and record:

- focused tests for stable, fragile, threshold-dependent, missing-config, and non-finite synthetic cases;
- the real preflight command against committed runner Hinf artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
