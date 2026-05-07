---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-r-runner-manifest-replay-mismatch-fixtures
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 75
---

# Phase 7.10.r - runner manifest replay mismatch fixtures

You are a rigorous BSEBench runner reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Strengthen manifest replay validation so future Hinf, Phase 8, and Phase 11 evidence cannot pass with stale hashes, dependency drift, or silent artifact substitution.

## Roadmap mapping

- Active lane: evidence generation.
- Phase 7: strict Hinf evidence replay guardrails, with no `claim_55` targeting.
- Phase 8/11 preparation: reusable manifest integrity checks before cross-dataset and residual-decomposition runs.

## Required behavior

- Review the runner artifact manifest audit and any CI evidence-audit scripts.
- Add synthetic fixtures or tests that cover at least: artifact hash mismatch, missing artifact, changed stats dependency SHA, changed command line, duplicate output path, and unknown provenance field.
- The audit must report exact failure reasons in machine-readable output and must not collapse all failures into a generic non-zero exit.
- Do not rerun expensive filters or commit newly generated scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to manifest mismatch validation.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any synthetic mismatch fixture exits successfully, or if the audit output omits which artifact, dependency, command, or provenance field failed, the task must fail and block downstream manifest-replay reliance.

## Validation

Run and record:

- focused tests for every mismatch fixture listed above plus one clean fixture;
- the current real manifest audit command against committed runner outputs;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
