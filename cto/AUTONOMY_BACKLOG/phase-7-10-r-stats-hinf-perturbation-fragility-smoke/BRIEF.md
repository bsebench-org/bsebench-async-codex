---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-r-stats-hinf-perturbation-fragility-smoke
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.r - stats Hinf perturbation fragility smoke

You are a rigorous BSEBench statistics validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a small, mechanical fragility smoke test that checks whether Hinf residual-covariance observations are stable under bounded numeric perturbations of already-committed evidence.

## Roadmap map

- Phase 7 evidence validation: stress the Hinf candidate against perturbation-sensitive conclusions.
- Phase 11 preparation: reuse residual-decomposition comparison machinery without creating a scientific verdict.

## Required behavior

- Add or extend a stats-side command that consumes committed runner Hinf evidence or synthetic fixtures and applies deterministic bounded perturbations to residual-derived summary inputs.
- Report baseline values, perturbed values, tolerance, direction changes, materiality flags, and mismatch count in finite JSON.
- Keep the output mechanical-only: it may say a diagnostic is stable, fragile, or blocked, but must not verify or reject a claim.
- Include tests where perturbations stay within tolerance and where they flip a materiality decision.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this fragility smoke test.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a bounded perturbation changes a material Hinf diagnostic direction, produces non-finite output, or cannot report the compared values and tolerance, the smoke test must fail or mark the candidate observation fragile and not ready for claim promotion.

## Validation

Run and record:

- focused tests for stable perturbation, material flip, non-finite input, and missing baseline cases;
- a real read-only smoke run against committed Hinf evidence when available, otherwise a clearly synthetic fixture run;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
