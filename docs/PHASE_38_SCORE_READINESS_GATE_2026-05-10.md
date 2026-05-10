# Phase 38 Score-Readiness Gate

Date: 2026-05-10
Status: CLOSED WITH SCORE BLOCKED
Runner commit: `36ea973`
Claim status: `NO_CLAIM`

## Objective

Assess whether the Phase 37 resolved six-config run is ready for a pre-registered aggregate BSE-Score.

This phase intentionally did not compute a global score. It checked whether the required KPI families are actually measured and claim-safe.

## Definition Of Done

- Consume the Phase 37 resolved run.
- Verify the three-method panel and six-config reduced panel are complete.
- Verify zero sentinels and zero failure traces.
- Preserve the formal `calce_legacy:DST:T25` exclusion with no substitution.
- Classify KPI availability by category.
- Block BSE-Score and ranking if any required KPI family is missing.
- Produce a machine-readable gate artifact.
- Validate with tests, Ruff, whitespace checks, and secret scan.

## Implementation

Added to `bsebench-runner`:

```text
src/bsebench_runner/phase38_score_readiness_gate.py
scripts/phase38_score_readiness_gate.py
tests/test_phase38_score_readiness_gate.py
outputs/phase38_score_readiness_gate_20260510.json
```

The gate validates:

```text
resolved run status=amended_micro_run_completed
sentinel_cell_count=0
failure_trace_count=0
filter_names=[EKF_projected, GRU_light, SO_SMO]
Phase 37 status=dataset_panel_resolved_with_formal_exclusion
substitution_allowed=false
excluded_config_replaced=false
ranking_authorized=false
bse_score_authorized=false
```

## Gate Result

```text
status=score_readiness_blocked
execution_integrity.status=complete
dataset_panel_integrity.status=formally_reduced
bse_score_authorized=false
ranking_authorized=false
```

Execution integrity:

```text
n_filters=3
n_configs=6
sentinel_cell_count=0
failure_trace_count=0
```

Resolved configs:

```text
calce_a123_dyn-DST-T20
panasonic-US06-T10
nasa-CC-discharge-T24
lg_hg2-WLTC_P066-T25
yao-BCDC-T35
calce_inr_dyn-DST-T25
```

## KPI Taxonomy Status

Available as diagnostic only:

```text
voltage_rmse_mV
```

Mean voltage RMSE on the resolved six-config panel:

```text
EKF_projected: 99.23201446224964 mV
GRU_light:     376.0523744339692 mV
SO_SMO:        451.49406724569116 mV
```

Important limit:

```text
Voltage RMSE is not a SOC/SOH state-estimation accuracy claim.
```

Blocked KPI families:

```text
soc_accuracy: truth_missing on 18/18 cells
soh_accuracy: truth_missing on 18/18 cells
max_error: not emitted for voltage and state truth missing
time_to_first_estimation: not measured
inference_time_per_cycle: not measured
ram_mb: not measured under fixed cloud profile
cpu_percent: not measured under fixed cloud profile
noise_sensitivity: perturbation protocol not executed
temperature_sensitivity: controlled robustness protocol not executed
```

## BSE-Score Decision

BSE-Score remains blocked:

```text
bse_score_authorized=false
reduced_panel_score_authorized=false
diagnostic_voltage_rmse_summary_authorized=true
```

Blocking reasons:

```text
kpi_not_available:soc_accuracy
kpi_not_available:soh_accuracy
kpi_not_available:max_error
kpi_not_available:time_to_first_estimation
kpi_not_available:inference_time_per_cycle
kpi_not_available:ram_mb
kpi_not_available:cpu_percent
kpi_not_available:noise_sensitivity
kpi_not_available:temperature_sensitivity
bse_score_formula_not_frozen_for_reduced_panel
```

## Artifact Hash

| Artifact | SHA-256 |
|---|---|
| `bsebench-runner/outputs/phase38_score_readiness_gate_20260510.json` | `580052e5939f113def36a3f54033f9b1bbdd3e88f1adbb042e98fb61861a8fdf` |

## Validation

Executed in `bsebench-runner`:

```bash
uv run pytest tests/test_phase38_score_readiness_gate.py
uv run pytest tests/test_phase25_three_family_panel.py tests/test_phase29_real_micro_run.py tests/test_phase33_diagnostic_projection_run.py tests/test_phase36_amended_micro_run.py tests/test_phase37_dataset_panel_resolution.py tests/test_phase38_score_readiness_gate.py
uv run ruff check src/bsebench_runner/phase37_dataset_panel_resolution.py src/bsebench_runner/phase38_score_readiness_gate.py scripts/phase37_dataset_panel_resolution.py scripts/phase38_score_readiness_gate.py tests/test_phase37_dataset_panel_resolution.py tests/test_phase38_score_readiness_gate.py
git diff --check
```

Result:

```text
4 passed
23 passed
Ruff: All checks passed
git diff --check: clean
strict token scan: no raw Hugging Face token found
```

## Scientific Interpretation

The current benchmark core has made a real step forward:

- three method families execute end-to-end;
- the dataset blocker is formally resolved without scientific substitution;
- the reduced panel has zero sentinels and zero failure traces.

But this is still not a complete benchmark claim. The only available numeric comparison is voltage residual RMSE, and it is diagnostic. The user-facing benchmark objective requires precision, latency, compute cost, robustness, and a pre-registered global score. Those categories are not all measured yet.

The correct trajectory is therefore to move from execution readiness to KPI instrumentation, not to publish a ranking.

## Next Phase

Recommended Phase 39: latency and compute profiling on the resolved six-config panel.

Definition of Done:

- run the same three methods and six configs under an explicit profiling runner;
- capture time-to-first-estimation and per-cycle inference time;
- capture RAM evidence with current Python allocation profiler and document its scope;
- capture CPU/GPU policy or explicitly block unavailable hardware counters;
- emit per-method/per-config profiles and summaries;
- keep BSE-Score blocked until robustness and score formula freeze are done.
