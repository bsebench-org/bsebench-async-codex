---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-6-b-runner-residual-trace-5x5
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-filters
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 50
---

# Phase 7.6.b - runner residual trace 5x5 producer

## Mission

Create the runner-side script for Phase 7.6 claim_55 evidence: export
post-warmup residual traces on the same five configs x five filters used by
`scripts/chi2_sweep_5x5.py`.

This is evidence infrastructure only. Do not verify, retract, or update
claim_55 here.

## Source references

Read first:

- `src/bsebench_runner/residuals.py`
- `tests/test_residuals.py`
- `scripts/chi2_sweep_5x5.py`
- `scripts/chi2_smoke_yao_bcdc_t25.py`
- `/mnt/c/doctorat/bsebench-org/bsebench-stats/src/bsebench_stats/residual_cov.py`
- `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch/phase60_residual_cov.py`

## Deliverable

Add a small script, preferably `scripts/residual_trace_5x5.py`, that reuses
the target definitions and factory builders from `scripts/chi2_sweep_5x5.py`.

Expected behavior:

- load the five `CONFIG_TARGETS` through the default adapter registry;
- run the five `FILTER_TARGETS` through `run_residual_traces`;
- output JSON only after fail-loud requirements pass;
- include measured voltage only once per config, and residual arrays under each
  ok filter;
- record loader/filter errors without creating fake residual arrays;
- use residual convention already established by `bsebench_runner.residuals`:
  `V_pred - V_meas`, in mV;
- never write all-skipped/all-error evidence by default.

## Output schema

Use this shape so `bsebench-stats` can consume it:

```json
{
  "schema_version": "1.0",
  "script": "scripts/residual_trace_5x5.py",
  "config_targets": [{"label": "Yao BCDC T25"}],
  "filter_targets": [{"label": "EKF", "registry_name": "EKF"}],
  "config_labels": ["Yao BCDC T25"],
  "filter_labels": ["EKF", "UKFDef", "Hinf"],
  "configs": {
    "Yao BCDC T25": {
      "status": "ok",
      "config": {"label": "Yao BCDC T25", "wrapper": "yao", "profile": "BCDC", "T_C": 25.0},
      "retained_samples": 2900,
      "warmup_samples": 100,
      "validation_window": {"start_index": 100, "end_index": 3000},
      "time_s": [100.0, 101.0],
      "measured_voltage_mV": [3700.0, 3699.0],
      "filters": {
        "EKF": {"status": "ok", "retained_samples": 2900, "residual_mV": [0.1, -0.2]},
        "Hinf": {"status": "error", "error": {"type": "RuntimeError", "message": "..."}}
      }
    }
  },
  "summary": {"ok_configs": 1, "error_configs": 0, "ok_filter_runs": 1, "error_filter_runs": 1}
}
```

Predicted voltage arrays may be omitted from the script output if this keeps the
evidence file smaller; residuals and measured voltage are sufficient for Phase
7.6 stats.

## CLI

Provide a small CLI:

- `--output`, default `outputs/residual_trace_5x5.json`;
- `--n-max`, default aligned with `chi2_sweep_5x5.py`;
- `--warmup-samples`;
- `--checkpoints-dir`;
- `--require-ok-configs`, default `1`;
- `--require-ok-filter-runs`, default `1`.

If requirements fail, return exit code `2`, print a compact summary, and do not
write the output file.

## Tests

Add fast synthetic tests, no real dataset dependency:

- synthetic two-config/two-filter run writes expected schema and residuals;
- failing loader marks a config skipped/error without residual arrays;
- failing filter is reported but does not block other filters;
- `--require-ok-configs` and `--require-ok-filter-runs` prevent output writing
  when requirements are not met;
- JSON serializes with `allow_nan=False`;
- script can be imported without executing real data.

## Acceptance gates

- G1: focused tests pass.
- G2: `uv run --locked --all-extras pytest -m "not slow" --tb=short` passes.
- G3: `uv run --locked --all-extras ruff format --check .` passes.
- G4: `uv run --locked --all-extras ruff check .` passes.
- G5: no real-data output committed.
- G6: no claim registry, roadmap, README, thesis prose, or empirical verdict
  edits.
- G7: commit uses GLASSBOX with `[role: worker-codex-FR]`.
- G8: no `Co-Authored-By: Claude` trailer.

## Out of scope

- Do not compute covariance here; stats owns that.
- Do not plot.
- Do not claim that `Hinf` is decorrelated or that claim_55 is verified.

## If blocked

Write `outbox/phase-7-6-b-runner-residual-trace-5x5/BLOCKED.md` with the
smallest ambiguity and the proposed next step.
