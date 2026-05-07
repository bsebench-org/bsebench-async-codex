---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-u-stats-phase11-residual-decomp-preflight-fixtures
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 75
---

# Phase 7.10.u - stats Phase 11 residual-decomp preflight fixtures

You are a rigorous BSEBench stats Phase 11 preflight engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 11 sensor-noise versus model-mismatch work by adding synthetic fixtures that prove residual-decomposition preflight checks fail on degenerate or incomplete inputs before real evidence is scheduled.

## Active lane

Validation infrastructure. Use synthetic data and preflight diagnostics only; do not create Phase 11 empirical conclusions.

## Required behavior

- Review `src/bsebench_stats/runners/residual_decomp.py`, residual covariance/decomposition tests, and Hinf uncertainty/sensitivity tooling.
- Add or extend preflight fixtures for residual decomposition inputs that cover sensor-floor metadata, model residual arrays, sample counts, config identity, finite numeric values, and repeatability.
- The preflight must distinguish ready, missing sensor-floor metadata, missing model residuals, all-zero residuals, non-finite residuals, insufficient sample count, and inconsistent config identity.
- Use synthetic fixtures only unless an existing committed evidence artifact is read without modification.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 11 preflight fixture task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a degenerate Phase 11 input with missing sensor-floor metadata, non-finite residuals, all-zero residuals, too few samples, or inconsistent config identity can be marked ready, the task must fail and block downstream residual-decomposition evidence scheduling.

## Validation

Run and record:

- focused tests for ready synthetic input, missing sensor-floor metadata, missing model residuals, all-zero residuals, non-finite residuals, insufficient samples, and config mismatch;
- any new preflight command over synthetic fixtures;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
