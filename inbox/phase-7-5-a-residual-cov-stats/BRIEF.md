---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-5-a-residual-cov-stats
base_branch: main
add_dir:
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 35
---

# Phase 7.5.a - residual covariance stats primitives

## Mission

Start scientific Phase 7 / claim_55 verification by porting the reusable
statistics part of the legacy residual covariance workflow into
`bsebench-stats`.

This is tooling only. Do not verify, retract, or update claim_55 here.

## Source references

Read first:

- `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch/phase60_residual_cov.py`
- `src/bsebench_stats/runners/friedman.py`
- `tests/test_friedman_panel_runner.py`
- `docs/RESEARCH-ROADMAP-2026-05-06.md` in async-codex, Phase 7 summary

Legacy behavior to preserve in package form:

- input residual traces are time-series residuals, one column per filter;
- per-config covariance uses `np.cov(..., rowvar=False)` after any caller-side
  burn-in;
- correlation divides covariance by per-filter sigma and uses diagonal `1.0`;
- average covariance/correlation can be formed across multiple configs;
- output must be JSON-safe, with non-finite correlation entries represented as
  `None`, not NaN.

## Deliverable

Add a small public API, preferably in `src/bsebench_stats/residual_cov.py` or
`src/bsebench_stats/runners/residual_cov.py` depending on local style.

Expected public functions:

- `compute_residual_covariance(residual_matrix, filter_names) -> dict`
- `aggregate_residual_covariances(per_config_reports) -> dict`

Names may differ if clearer, but keep the surface small and documented.

Expected report fields:

- `filter_names`;
- `n_samples`, `n_filters`;
- covariance matrix;
- correlation matrix;
- residual standard deviations;
- off-diagonal summary with median absolute correlation, max absolute
  correlation, fraction below a threshold such as `0.5`;
- JSON-safe lists/scalars only.

## Tests

Add focused fast tests with synthetic residual matrices:

- known 3-filter residual matrix yields expected covariance shape, symmetric
  correlation, diagonal `1.0`;
- constant residual column is JSON-safe and uses `None` where correlation is
  undefined;
- invalid shape, duplicate/empty filter names, non-finite residuals raise clear
  `ValueError`;
- aggregation across two configs preserves shape and reports the config count;
- top-level package export works if you add one.

## Acceptance gates

- G1: focused tests pass.
- G2: `uv run --all-extras pytest -m "not slow" --tb=short` passes.
- G3: `uv run --all-extras ruff format --check .` passes.
- G4: `uv run --all-extras ruff check .` passes.
- G5: no `uv.lock` committed.
- G6: no claim registry, roadmap, README, or thesis prose edits.
- G7: commit uses GLASSBOX with `[role: worker-codex-FR]`.
- G8: no `Co-Authored-By: Claude` trailer.

## Out of scope

- No plotting.
- No real-data run.
- No statement such as "Hinf is uncorrelated" or "claim_55 verified".
- No edits outside `bsebench-stats` package/tests unless required for exports.

## If blocked

Write `outbox/phase-7-5-a-residual-cov-stats/BLOCKED.md` with the smallest API
ambiguity and proposed narrower next step.
