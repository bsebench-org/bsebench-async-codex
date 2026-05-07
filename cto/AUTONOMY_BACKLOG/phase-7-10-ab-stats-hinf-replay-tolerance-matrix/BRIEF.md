---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-ab-stats-hinf-replay-tolerance-matrix
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ab - stats Hinf replay tolerance matrix

You are a rigorous BSEBench statistics reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Create a neutral tolerance matrix for stats-side Hinf replay so reviewers can see which covariance and decomposition comparisons are exact, tolerance-sensitive, missing, or mismatched.

## Roadmap mapping

- Active lane: evidence generation validation.
- Roadmap scope: Phase 7 Hinf evidence fragility and independent stats replay, with no scientific verdict.
- Handoff artifact: JSON or Markdown-plus-JSON matrix listing replay sections, tolerance used, values compared, mismatch counts, and pass/fail status.

## Required behavior

- Read the existing stats replay command and committed runner Hinf evidence before changing code.
- Add or extend a synthetic-testable report that compares replay behavior under at least strict, default, and intentionally loose tolerances.
- The report must make missing required sections fail loud and may mark optional sections as unavailable with explicit reason fields.
- Keep wording mechanical: replay/tolerance status only, no claim promotion.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this replay tolerance task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a non-zero mismatch count appears at the required tolerance, if a required Hinf replay section is missing, or if tolerance changes alter the pass/fail status without being reported, the task must fail and mark the evidence fragile.

## Validation

Run and record:

- focused tests for exact match, tolerated roundoff, required mismatch, missing required section, and optional unavailable section;
- the real tolerance-matrix command against committed Hinf artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
