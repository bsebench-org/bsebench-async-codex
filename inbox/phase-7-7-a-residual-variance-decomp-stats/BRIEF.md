---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-7-a-residual-variance-decomp-stats
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 50
---

# Phase 7.7.a - residual variance decomposition stats primitive

## Mission

Add the stats-side variance decomposition primitive for Phase 7.7 evidence.
It consumes the Phase 7.6 residual trace payload shape and produces JSON-safe
per-config/per-filter residual diagnostics plus a two-factor decomposition.

This is tooling only. Do not run real datasets and do not verify, retract, or
update any claim.

## Source references

Read first:

- `src/bsebench_stats/runners/residual_cov.py`
- `tests/test_residual_cov_panel_runner.py`
- `src/bsebench_stats/residual_cov.py`
- `/mnt/c/doctorat/bsebench-org/bsebench-runner/scripts/residual_trace_5x5.py`
- `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch/phase60_residual_cov.py`
- async docs `docs/RESEARCH-ROADMAP-2026-05-06.md`, Phase 7 only

## Deliverable

Add a small public API, preferably:

- `src/bsebench_stats/runners/residual_decomp.py`
- exports from `src/bsebench_stats/runners/__init__.py`
- optional top-level exports from `src/bsebench_stats/__init__.py`

Suggested functions:

- `build_residual_variance_decomposition(trace_payload, *, min_ok_filters=2, require_ok_configs=1, metric="log_residual_var") -> dict`
- `run_residual_variance_decomposition(input_path, output_path, *, ...) -> dict`

Names may differ if clearer, but keep the public surface narrow and documented.

## Input

Consume the same trace payload shape as Phase 7.6:

- top-level `schema_version == "1.0"`;
- `config_labels`, `filter_labels`, `configs`;
- config entries with `status`, `retained_samples`, `filters`;
- ok filters with finite one-dimensional `residual_mV` arrays.

Only ok filters with finite residual arrays enter the analysis. Failed filters
must be excluded without fabricated residual evidence. Configs with fewer than
`min_ok_filters` ok filters are skipped with a structured reason.

## Output

Return JSON-safe lists/scalars only:

- `schema_version`;
- `metric`;
- `policy` documenting `min_ok_filters`, `require_ok_configs`, epsilon if used,
  and no-fake-evidence behavior;
- `summary` with counts for total configs, ok configs, skipped/error configs,
  ok filter traces;
- `per_config_filter_metrics` keyed by config then filter, with:
  - `bias_mV`;
  - `std_mV`;
  - `rmse_mV`;
  - `residual_var_mV2`;
  - selected decomposition metric value, preferably `log(residual_var_mV2 + eps)`;
- `decomposition` with two-factor sums of squares or equivalent deterministic
  shares:
  - `config_share`;
  - `filter_share`;
  - `residual_or_interaction_share`;
  - raw `ss_config`, `ss_filter`, `ss_residual`, `ss_total`;
- `filter_effects` and `config_effects` as mechanical, non-claim summaries;
- optional deterministic bootstrap CI if straightforward and fast.

## Decomposition policy

Use a balanced table over retained config/filter cells. If retained configs do
not share an identical ok-filter set and order, fail clearly rather than
imputing or averaging mismatched cells. This matches the Phase 7.6 covariance
panel policy.

Default metric should be deterministic and robust for positive variance,
e.g. `log_residual_var = log(residual_var_mV2 + eps)` with a documented
positive epsilon. Support `rmse_mV` only if it is easy to test cleanly.

## Fail-loud requirements

- If fewer than `require_ok_configs` configs remain, raise a clear custom or
  standard exception before writing output.
- If retained configs have different ok-filter sets, raise a clear `ValueError`.
- If any residual array is non-finite, not one-dimensional, too short, or length
  mismatched with `retained_samples`, raise clear `ValueError`.
- Do not write an output file before all requirements are satisfied.
- `json.dumps(..., allow_nan=False)` must pass for outputs.

## Tests

Add focused synthetic tests:

- balanced 5 configs x 5 filters produces per-cell metrics and decomposition
  shares summing to approximately 1.0;
- config-dominant synthetic payload yields `config_share > filter_share`;
- filter-dominant synthetic payload yields `filter_share > config_share`;
- a synthetic Hinf-like filter with distinct variance appears in mechanical
  `filter_effects`, but do not make any claim or conclusion;
- failed filters are excluded without fake residual arrays;
- divergent ok-filter sets across retained configs fail loud;
- non-finite residuals, invalid lengths, duplicate labels, and insufficient ok
  configs raise clear errors;
- file runner writes JSON only after requirements pass;
- top-level exports work if added.

## Acceptance gates

- G1: focused tests pass.
- G2: `uv run --locked --all-extras pytest -m "not slow" --tb=short` passes.
- G3: `uv run --locked --all-extras ruff format --check .` passes.
- G4: `uv run --locked --all-extras ruff check .` passes.
- G5: no `uv.lock` committed.
- G6: no README, roadmap, claim registry, thesis prose, or scientific verdict
  edits.
- G7: commit uses GLASSBOX with `[role: worker-codex-FR]`.
- G8: no `Co-Authored-By: Claude` trailer.

## Out of scope

- No real-data run.
- No plot.
- No claim_55 verdict.
- No registry/prose edits.

## If blocked

Write `outbox/phase-7-7-a-residual-variance-decomp-stats/BLOCKED.md` with the
smallest ambiguity and a proposed narrower next step.
