---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-r-stats-hinf-leave-source-fragility
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.r - stats Hinf leave-source fragility

You are a rigorous BSEBench stats validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Stress the Hinf candidate evidence against leave-one-source and leave-one-config perturbations so fragility is visible before any claim language is drafted.

## Active lane

Evidence generation: mechanical sensitivity analysis over frozen runner Hinf evidence. The handoff artifact is a JSON/Markdown fragility report with input artifact hashes, perturbation definitions, mismatch counts, and neutral pass/fragile fields.

## Required behavior

- Consume committed runner Hinf evidence and stats replay outputs without regenerating runner filters.
- Add or extend a deterministic stats command that computes leave-one-dataset, leave-one-profile, and leave-one-config perturbation summaries for Hinf residual covariance/decomposition evidence.
- Report sample counts, omitted source identifiers, compared values, tolerance thresholds, category changes, and a machine-readable `fragility_status` such as `stable`, `fragile`, or `insufficient_evidence`.
- Treat missing source identity, divergent ok-filter sets, non-finite values, or insufficient sample counts as evidence gaps, not as permission to smooth or infer results.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf fragility validation task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a leave-one-source/config perturbation changes the reported Hinf evidence category, flips the sign of a key comparison, exceeds the configured tolerance, or cannot be computed from frozen artifacts with known source identity, the report must mark the candidate evidence fragile and block downstream claim registration.

## Validation

Run and record:

- `uv run --locked --all-extras pytest tests/test_hinf_leave_source_fragility.py -q`;
- a read-only real fragility run against `../bsebench-runner/outputs/hinf_residual_evidence_5x5.json`;
- `uv run --locked --all-extras pytest tests/ -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
