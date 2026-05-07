---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-ab-stats-hinf-bootstrap-fragility-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ab - stats Hinf bootstrap fragility audit

You are a rigorous BSEBench statistics engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make Hinf candidate fragility visible under bootstrap or resampling perturbations without turning the result into a scientific verdict.

## Roadmap mapping

- Phase 7 evidence lane: distinguish structural Hinf behavior from instability or sample-count imbalance.
- Phase 11 preparation: reusable residual-decomposition uncertainty reporting for future sensor-noise versus model-mismatch work.
- Active lane: evidence replay and fragility diagnostics only.

## Required behavior

- Read committed Hinf residual evidence and existing stats replay, sensitivity, threshold, or uncertainty commands where available.
- Add a synthetic-testable bootstrap, jackknife, or resampling audit that reports whether the mechanical Hinf fragility status changes under explicit perturbation settings.
- The audit must expose seed, resampling rule, sample/config weighting rule, NASA short-sample handling, compared fields, and finite JSON-safe output.
- Mark missing optional artifacts as explicit gaps; missing required evidence must fail loud.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf candidate evidence lane.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If resampling, weighting, or leave-one-config perturbations change the mechanical Hinf fragility status or make the result threshold-dependent, the report must mark the candidate unstable and must not collapse the result into a stable-looking verdict.

## Validation

Run and record:

- focused tests for stable, unstable, non-finite, missing-required-artifact, and seed-determinism cases;
- the real bootstrap or resampling audit command against committed Hinf artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
