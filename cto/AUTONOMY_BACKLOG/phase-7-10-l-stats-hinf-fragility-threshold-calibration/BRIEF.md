---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-l-stats-hinf-fragility-threshold-calibration
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.l - stats Hinf fragility threshold calibration

You are a rigorous BSEBench statistics engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make the Hinf fragility thresholds auditable so future readers can see whether uncertainty, leave-one-config-out, or sample-count imbalance conclusions depend on arbitrary cutoffs.

## Required behavior

- Read the committed strict Hinf evidence and existing stats-owned sensitivity or uncertainty report commands.
- Add a synthetic-testable threshold sweep or calibration summary that records which thresholds change the mechanical fragility status.
- Output JSON must be finite and must separate evidence fragility from scientific interpretation.
- Include explicit fields for the threshold grid, materiality rule, NASA short-sample handling, and whether the strict 5x5 result is threshold-dependent.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf candidate evidence lane.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a reasonable threshold grid changes the Hinf fragility status or hides material sensitivity, the report must mark the candidate threshold-dependent and must not collapse the result into a single stable-looking verdict.

## Validation

Run and record:

- focused tests for stable, threshold-dependent, and invalid-threshold synthetic cases;
- the real calibration command against committed Hinf artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
