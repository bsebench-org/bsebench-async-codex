---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-6-a-residual-cov-trace-panel
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 45
---

# Phase 7.6.a - residual covariance trace-panel consumer

## Mission

Create the stats-side consumer for Phase 7.6 claim_55 evidence: given a JSON
payload of per-config/per-filter residual traces, compute per-config residual
covariance reports and one aggregate panel report.

This is evidence infrastructure only. Do not verify, retract, or update
claim_55 here.

## Source references

Read first:

- `src/bsebench_stats/residual_cov.py`
- `tests/test_residual_cov.py`
- `src/bsebench_stats/runners/friedman.py`
- `/mnt/c/doctorat/bsebench-org/bsebench-runner/src/bsebench_runner/residuals.py`
- `/mnt/c/doctorat/bsebench-org/bsebench-runner/scripts/chi2_sweep_5x5.py`
- `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch/phase60_residual_cov.py`

## Input schema to support

Support this runner trace payload shape exactly; tests can build it
synthetically:

```json
{
  "schema_version": "1.0",
  "script": "scripts/residual_trace_5x5.py",
  "config_labels": ["cfg_a", "cfg_b"],
  "filter_labels": ["EKF", "UKF", "Hinf"],
  "configs": {
    "cfg_a": {
      "status": "ok",
      "config": {"label": "cfg_a"},
      "retained_samples": 4,
      "filters": {
        "EKF": {"status": "ok", "residual_mV": [1.0, 2.0, 3.0, 4.0]},
        "UKF": {"status": "ok", "residual_mV": [1.1, 2.1, 3.1, 4.1]},
        "Hinf": {"status": "error", "error": {"type": "RuntimeError"}}
      }
    }
  }
}
```

Only filters with `status == "ok"` and finite equal-length residual arrays may
enter a covariance matrix. A config with fewer than two ok filters must be
skipped with a clear reason, not coerced into fake evidence.

## Deliverable

Add a small runner module, preferably `src/bsebench_stats/runners/residual_cov.py`,
with public functions such as:

- `build_residual_covariance_panel(trace_payload, *, require_ok_configs=1, min_ok_filters=2) -> dict`
- `run_residual_covariance_panel(input_path, output_path, *, require_ok_configs=1, min_ok_filters=2) -> dict`

Exact names may differ if clearer, but keep the API narrow and documented.

Expected output fields:

- `schema_version`, `source_schema_version`;
- `config_labels`, `filter_labels`;
- `per_config_reports` keyed by config label;
- `aggregate_report` from `aggregate_residual_covariances`;
- `summary` with counts for ok/skipped/error configs and ok filter traces;
- `skipped_configs` with reasons;
- `policy` documenting `min_ok_filters`, `require_ok_configs`, and how
  undefined correlations are represented (`None`, JSON-safe).

Fail loud:

- If fewer than `require_ok_configs` configs produce covariance reports, raise a
  custom or clear `RuntimeError`/`ValueError`.
- Do not write the output file before this requirement is satisfied.
- Never emit NaN or Infinity; `json.dumps(..., allow_nan=False)` must pass.

## Tests

Add focused tests with synthetic payloads:

- two configs x three filters produce per-config reports and an aggregate with
  `n_configs == 2`;
- a failed filter is excluded without fabricating residual evidence;
- configs with fewer than two ok filters are skipped and can trigger the
  fail-loud requirement;
- unequal residual lengths, non-finite residuals, duplicate filter labels, and
  missing required keys raise clear errors;
- file-level runner writes JSON only after the ok-config requirement passes.

## Acceptance gates

- G1: focused tests pass.
- G2: `uv run --all-extras pytest -m "not slow" --tb=short` passes.
- G3: `uv run --all-extras ruff format --check .` passes.
- G4: `uv run --all-extras ruff check .` passes.
- G5: no `uv.lock` committed.
- G6: no claim registry, roadmap, README, thesis prose, or empirical verdict
  edits.
- G7: commit uses GLASSBOX with `[role: worker-codex-FR]`.
- G8: no `Co-Authored-By: Claude` trailer.

## Out of scope

- Do not run real datasets.
- Do not plot.
- Do not claim that `Hinf` is decorrelated or that claim_55 is verified.

## If blocked

Write `outbox/phase-7-6-a-residual-cov-trace-panel/BLOCKED.md` with the
smallest ambiguity and the proposed next step.
