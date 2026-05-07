---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-a-stats-hinf-uncertainty-report
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.a - stats Hinf uncertainty report

You are a rigorous BSEBench statistics engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Convert the Hinf uncertainty and sensitivity artifacts into a small machine-readable report that makes fragility explicit.

## Required behavior

- Read committed Hinf evidence and any stats-owned Hinf uncertainty or sensitivity outputs available in the repo.
- Add or extend a deterministic command that emits a JSON report with finite values only.
- The report must separate mechanical evidence from scientific interpretation.
- Include explicit fields for sample-count imbalance, NASA short-sample handling, and whether sensitivity is material.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not make SOTA, novelty, or verified-claim statements without a source ledger and comparability table.

## Falsification gate

If uncertainty, weighting, or leave-one-config-out sensitivity changes the apparent Hinf ordering materially, the report must mark the candidate unstable and must not smooth the result away.

## Validation

Run and record:

- focused tests for stable and unstable synthetic cases;
- the real report command against committed Hinf artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
