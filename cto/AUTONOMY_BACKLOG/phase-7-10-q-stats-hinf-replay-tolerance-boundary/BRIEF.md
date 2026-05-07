---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-q-stats-hinf-replay-tolerance-boundary
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 75
---

# Phase 7.10.q - stats Hinf replay tolerance boundary

You are a rigorous BSEBench stats replay engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make the strict Hinf stats replay boundary falsifiable by reporting exactly how close replayed covariance and decomposition values are to their configured tolerances.

## Active lane

Evidence generation. Produce mechanical replay diagnostics only; do not interpret whether the Hinf candidate supports a scientific claim.

## Required behavior

- Review `scripts/replay_hinf_residual_stats.py`, `tests/test_hinf_residual_stats_replay.py`, and the committed runner Hinf evidence/manifest artifacts.
- Add or extend a deterministic replay diagnostic that reports value counts, maximum absolute difference, maximum relative difference where meaningful, tolerance values, and mismatch locations in JSON.
- The diagnostic must distinguish exact match, within-tolerance drift, over-tolerance drift, missing artifact, malformed artifact, and non-finite value cases.
- Use committed or synthetic fixtures; do not regenerate expensive filters.
- Keep language mechanical: replay result, mismatch count, tolerance, and artifact identity only.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf replay tolerance audit.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any replayed covariance or decomposition value exceeds the configured tolerance, if any non-finite value is accepted, or if mismatch locations are not reported for a failing replay, the task must fail and mark the replay boundary insufficient for downstream claim work.

## Validation

Run and record:

- focused tests for exact match, within-tolerance drift, over-tolerance drift, malformed artifact, missing artifact, and non-finite replay values;
- a real replay diagnostic against `/mnt/c/doctorat/bsebench-org/bsebench-runner/outputs/hinf_residual_evidence_5x5.json`;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
