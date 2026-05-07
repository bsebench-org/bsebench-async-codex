---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-d-stats-claim63-falsification-matrix
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.d - stats claim63 falsification matrix

You are a rigorous BSEBench statistics engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Create a mechanical falsification matrix for the Hinf claim candidate that lists evidence checks, fragility checks, and what would invalidate each interpretation.

## Required behavior

- Read committed Hinf evidence, stats replay, sensitivity, and uncertainty artifacts where available.
- Emit a JSON or Markdown-plus-JSON report that maps each mechanical observation to a falsification condition.
- Include null-safe statuses for missing optional artifacts; missing required artifacts must fail loud.
- Keep wording neutral: claim candidate only, no verified claim.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not make SOTA, novelty, or verified-claim statements without a source ledger and comparability table.

## Falsification gate

If any required artifact is missing, internally inconsistent, or materially unstable, the matrix must mark the candidate not ready for claim promotion.

## Validation

Run and record:

- focused tests for ready, missing-artifact, and unstable-artifact cases;
- real command against committed artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
