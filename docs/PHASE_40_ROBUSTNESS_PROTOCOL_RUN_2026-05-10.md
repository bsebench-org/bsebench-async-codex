# Phase 40 Robustness Protocol Run

Date: 2026-05-10
Status: CLOSED
Runner commit: `9e706b4`
Claim status: `NO_CLAIM`

## Objective

Freeze and execute a deterministic robustness protocol on the Phase 37 resolved six-config panel:

```text
EKF_projected, GRU_light, SO_SMO
```

The goal was to close the Phase 38 robustness KPI blockers for noise and temperature sensitivity, while keeping the scope diagnostic and preventing any premature BSE-Score.

## Definition Of Done

- Freeze the perturbation protocol before execution.
- Use the Phase 37 resolved micro-slice.
- Use the clean Phase 36/37 resolved run as baseline.
- Require the Phase 39 latency/compute profile as prerequisite evidence.
- Run deterministic noise and temperature perturbation scenarios.
- Compare perturbed voltage RMSE against clean voltage RMSE baseline.
- Emit scenario-level and aggregate robustness summaries.
- Preserve ranking and BSE-Score as disabled.
- Validate with tests, Ruff, whitespace checks, and secret scan.

## Frozen Protocol

Protocol:

```text
protocol_id=phase40-robustness-v1
claim_scope=resolved_micro_panel_voltage_residual_robustness_diagnostic
evaluation_reference=clean_unperturbed_voltage_trace
```

Scenarios:

```text
voltage_noise_5mV_seed4001
current_noise_50mA_seed4002
temperature_plus_5C
temperature_minus_5C
```

Input policy:

```text
filters receive perturbed voltage/current/temperature
RMSE is evaluated against the clean unperturbed voltage trace
```

Protocol SHA-256:

```text
03694f29e0e7df342aefcfd2992abb2adbb853cb9954dbfb00ba4d1065f955bb
```

## Implementation

Added to `bsebench-runner`:

```text
src/bsebench_runner/phase40_robustness_protocol_run.py
scripts/phase40_robustness_protocol_run.py
tests/test_phase40_robustness_protocol_run.py
outputs/phase40_robustness_protocol_run_20260510.json
```

The runner refuses execution if:

```text
Phase 37 resolved slice is not ready
baseline run is incomplete or contains sentinels
baseline config labels do not match the resolved slice
Phase 39 latency profile is incomplete
Phase 35 amendment is invalid
score policy is not disabled
```

## Real Run

Command used with Phase 9 / Phase 32 local caches:

```bash
uv run python scripts/phase40_robustness_protocol_run.py \
  --output outputs/phase40_robustness_protocol_run_20260510.json \
  --resolved-micro-slice-manifest outputs/phase37_resolved_micro_slice_20260510.json \
  --baseline-run-artifact outputs/phase36_amended_micro_run_20260510_phase37_resolved_panel.json \
  --latency-compute-profile outputs/phase39_latency_compute_profile_20260510.json \
  --checkpoints-dir data/audit_j_v1/checkpoints \
  --amendment-artifact ../bsebench-specs/outputs/phase35_method_panel_amendment_20260510.json \
  --n-max 32
```

Result:

```text
status=robustness_protocol_run_completed
n_scenarios=4
complete_cell_count=72
sentinel_cell_count=0
failure_trace_count=0
blockers=[]
```

## KPI Status

Available:

```text
robustness.noise_sensitivity
robustness.temperature_sensitivity
```

Metric:

```text
delta_rmse_mV_against_clean_baseline
```

Still not authorized:

```text
ranking
BSE-Score
state-accuracy robustness claim
```

## Aggregate Robustness

By perturbation family:

| Family | Complete cells | Mean delta RMSE mV | Max delta RMSE mV |
|---|---:|---:|---:|
| `measurement_noise` | 36 | `0.39210798740564295` | `8.227540981862065` |
| `temperature_shift` | 36 | `1.9787818236698618` | `73.08846105974476` |

By filter:

| Filter | Complete cells | Mean delta RMSE mV | Max delta RMSE mV | Mean relative RMSE ratio |
|---|---:|---:|---:|---:|
| `EKF_projected` | 24 | `0.9157870514267272` | `21.492954249835464` | `21.50998113755718` |
| `GRU_light` | 24 | `-0.03137245129062786` | `9.281135181179536` | `0.999885957881175` |
| `SO_SMO` | 24 | `2.6719201164771573` | `73.08846105974476` | `1.3874331364750134` |

Interpretation note:

```text
High relative ratios can be inflated when the clean baseline RMSE is near zero.
Use delta RMSE mV as the primary robustness diagnostic until normalization is frozen.
```

## Artifact Hash

| Artifact | SHA-256 |
|---|---|
| `bsebench-runner/outputs/phase40_robustness_protocol_run_20260510.json` | `24a8a7677ac9b619ebc3302f2f020e555bf400293c33a371457290b425696282` |

## Validation

Executed in `bsebench-runner`:

```bash
uv run pytest tests/test_phase40_robustness_protocol_run.py
uv run pytest tests/test_phase25_three_family_panel.py tests/test_phase29_real_micro_run.py tests/test_phase33_diagnostic_projection_run.py tests/test_phase36_amended_micro_run.py tests/test_phase37_dataset_panel_resolution.py tests/test_phase38_score_readiness_gate.py tests/test_phase39_latency_compute_profile.py tests/test_phase40_robustness_protocol_run.py
uv run ruff check src/bsebench_runner/phase37_dataset_panel_resolution.py src/bsebench_runner/phase38_score_readiness_gate.py src/bsebench_runner/phase39_latency_compute_profile.py src/bsebench_runner/phase40_robustness_protocol_run.py scripts/phase37_dataset_panel_resolution.py scripts/phase38_score_readiness_gate.py scripts/phase39_latency_compute_profile.py scripts/phase40_robustness_protocol_run.py tests/test_phase37_dataset_panel_resolution.py tests/test_phase38_score_readiness_gate.py tests/test_phase39_latency_compute_profile.py tests/test_phase40_robustness_protocol_run.py
git diff --check
```

Result:

```text
4 passed
31 passed
Ruff: All checks passed
git diff --check: clean
strict token scan: no raw Hugging Face token found
```

## Scientific Interpretation

Phase 40 closes the robustness KPI gap for the current resolved micro-panel. We now have:

- executable three-family benchmark core;
- six real harmonized dataset configs;
- clean baseline run with zero sentinels;
- latency and scoped compute evidence;
- deterministic robustness evidence for noise and temperature shifts.

This is a real benchmark-core milestone.

However, the complete target is still not fully closed because SOC/SOH state accuracy remains blocked by missing state truth in the current loader outputs, and BSE-Score weights/normalization are not frozen.

## Next Phase

Recommended Phase 41: score contract and gap ledger.

Definition of Done:

- consume Phase 36/37/38/39/40 artifacts;
- declare which KPI categories are available, diagnostic, or blocked;
- freeze a provisional score formula only if scientifically defensible;
- otherwise produce a formal BSE-Score blocked ledger;
- define the exact remaining path to final objective closure.
