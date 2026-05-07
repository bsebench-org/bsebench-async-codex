---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-r-stats-hinf-perturbation-fragility-index
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.r - stats Hinf perturbation fragility index

You are a rigorous BSEBench statistics engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a neutral stats-side fragility index that consumes frozen Hinf replay, uncertainty, sensitivity, or leave-one-out artifacts and reports whether the mechanical Hinf observation is stable under documented perturbations.

## Roadmap mapping

- Active lane: evidence generation validation.
- Supports Phase 7 Hinf evidence fragility and prepares Phase 8/11 stability conventions.
- Produces mechanical diagnostics only; it does not change the scientific roadmap.

## Required behavior

- Read only committed or explicitly supplied frozen artifacts; do not regenerate evidence inside this task.
- Emit finite JSON with input artifact paths, artifact hashes when practical, perturbation labels, observed deltas, threshold source, missing-artifact status, and `mechanical_evidence_only=true`.
- Distinguish at least stable, materially sensitive, missing required artifact, missing optional artifact, and non-finite input states.
- Treat missing threshold provenance as a gap; do not infer a threshold from memory.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf fragility validation.
- Do not make SOTA, novelty, leaderboard, breakthrough, verified-claim, or claim-promotion statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if a non-finite input, missing required artifact, unproven threshold, or material perturbation can be reported as stable or claim-ready. Material sensitivity must block downstream claim promotion.

## Validation

Run and record:

- focused tests for stable, materially sensitive, missing-required, missing-optional, non-finite, and missing-threshold-provenance cases;
- a real read-only command over the currently committed Hinf artifacts when present;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
