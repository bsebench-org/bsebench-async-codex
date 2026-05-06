---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-6-11-d-friedman-nemenyi-stats-fix-1
base_branch: main
add_dir:
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 30
---

# Phase 6.11.d fix-1 - Friedman + Nemenyi statistical test

## Why this is fix-1

The original `phase-6-11-d-friedman-nemenyi-stats` was killed with exit code
137 before producing a deliverable. The chef/advisor trail says to requeue the
same statistical implementation once daemon stability is acceptable.

This phase is independent from `phase-6-11-b-chi2-multi-cfg-sweep-fix-1`: it
adds reusable nonparametric statistics code to `bsebench-stats`; it does not
consume the runner sweep output.

Execution base requirement: create the worker worktree from `origin/main` after
`git fetch origin`. The reusable `/mnt/c/doctorat/bsebench-org/bsebench-stats`
checkout may contain unrelated local modifications; do not reset or reuse that
dirty checkout.

## Mission

Implement Friedman omnibus test plus Nemenyi post-hoc comparisons in
`bsebench-stats`.

Input: RMSE-like score matrix with shape `[n_configs, n_filters]`, where lower
is better. Output: Friedman statistic/p-value, average ranks, critical
difference, and pairwise significance.

## Pre-flight

1. Read existing `bsebench-stats/src/` and tests end-to-end.
2. Read Demsar 2006 "Statistical Comparisons of Classifiers over Multiple Data
   Sets" for formulas and terminology.
3. Read the thesis reference implementation:
   `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch/phase_J_audit_friedman_retune.py`.
4. Confirm `git rev-parse --short HEAD` in the worker worktree resolves to
   `f5285f5` or a direct descendant before editing.

## Deliverables

### `src/bsebench_stats/friedman_nemenyi.py`

Implement:

- `friedman_test(rmse_matrix: np.ndarray) -> dict`
  - returns at least `chi2`, `p_value`, `ranks`, `average_ranks`,
    `n_configs`, `n_filters`;
  - uses `scipy.stats.friedmanchisquare`;
  - ranks each row with lower RMSE receiving better rank.
- `nemenyi_test(ranks: np.ndarray, n_configs: int, alpha: float = 0.05) -> dict`
  - returns at least `critical_difference` and a boolean pairwise significance
    matrix;
  - uses `scipy.stats.studentized_range` for the critical value.

If the existing package structure already has a better module name, use the
existing style, but keep the public functions above.

### `tests/test_friedman_nemenyi.py`

Add at least 5 fast tests:

- 3x3 and 5x4 synthetic sanity checks;
- all-equal data produces a non-significant result or explicit documented
  handling;
- clearly separated filters produce a small p-value;
- Nemenyi pairwise matrix shape/symmetry/diagonal behavior;
- invalid shape or insufficient filters/configs raises a clear error.

## Acceptance gates

- G1: at least 5 focused fast tests pass.
- G2: `uv run pytest -m "not slow" --tb=short` passes.
- G3: `uv run ruff format --check .` passes.
- G4: `uv run ruff check .` passes.
- G5: scope <= 3 files unless a small package export is required.
- G6: commit uses GLASSBOX with `[role: worker-codex-FR]`.
- G7: no `Co-Authored-By: Claude` trailer.

## Out of scope

- No claim registry changes.
- No thesis prose edits.
- No changes to the scientific roadmap.
- No dependency expansion beyond what is already in `pyproject.toml` unless
  `scipy` is missing from the package metadata and tests cannot import it.

## If blocked

Write `outbox/phase-6-11-d-friedman-nemenyi-stats-fix-1/BLOCKED.md` with the
exact traceback, missing dependency/API, and the smallest proposed recovery.
