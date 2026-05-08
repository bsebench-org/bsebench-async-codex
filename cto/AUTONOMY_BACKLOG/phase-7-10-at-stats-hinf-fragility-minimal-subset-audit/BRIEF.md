---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-at-stats-hinf-fragility-minimal-subset-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.at - stats Hinf fragility minimal-subset audit

You are a rigorous BSEBench statistics engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Measure whether strict Hinf mechanical observations are fragile to minimal dataset/source subsets before any claim-registration work is allowed.

## Active lane

Evidence generation: mechanical fragility audit over frozen artifacts. The handoff artifact is a JSON-safe report that classifies each subset as stable, fragile, or not evaluable with concrete blocking reasons.

## Required behavior

- Read frozen Hinf residual evidence and replay summaries from runner/stats artifacts when available.
- Add or extend a stats-side command that evaluates leave-one-source, leave-one-dataset, and minimal two-source subset checks without regenerating filters.
- Report the exact included configs, excluded configs, observation fields compared, threshold used, and whether the candidate observation changes materially.
- Missing required artifacts must fail loud; missing optional subsets must be reported as not evaluable, not inferred.
- Keep wording neutral: Hinf candidate only, no verified claim, no novelty or SOTA conclusion.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf fragility audit.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any leave-one-source or minimal-subset audit flips a material Hinf mechanical observation, exceeds the configured fragility threshold, or cannot reproduce the baseline comparison, the report must mark the candidate fragile and block downstream claim promotion.

## Validation

Run and record:

- focused tests for stable, threshold-exceeded, missing-baseline, missing-subset, and non-finite input cases;
- a real audit command against committed frozen Hinf artifacts without recomputing filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
