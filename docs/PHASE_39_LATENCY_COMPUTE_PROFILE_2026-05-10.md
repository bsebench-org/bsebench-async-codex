# Phase 39 Latency And Compute Profile

Date: 2026-05-10
Status: CLOSED
Runner commit: `c11fdb8`
Claim status: `NO_CLAIM`

## Objective

Measure latency and limited compute evidence on the Phase 37 resolved six-config panel:

```text
EKF_projected, GRU_light, SO_SMO
```

This phase addressed the Phase 38 blockers for:

```text
time_to_first_estimation
inference_time_per_cycle
limited process CPU time
limited Python heap allocation evidence
```

It did not claim system RAM, CPU percent, GPU usage, robustness, SOC/SOH accuracy, ranking, or BSE-Score.

## Definition Of Done

- Reuse the Phase 37 resolved micro-slice.
- Require the Phase 35 method-panel amendment.
- Require the Phase 38 score-readiness gate.
- Profile all 18 method/config cells.
- Emit time-to-first-estimation and per-cycle latency.
- Emit scoped process CPU time.
- Emit scoped Python heap allocation deltas through `tracemalloc`.
- Keep RAM MB, CPU percent, GPU, ranking, and BSE-Score blocked.
- Validate with tests, Ruff, whitespace checks, and secret scan.

## Implementation

Added to `bsebench-runner`:

```text
src/bsebench_runner/phase39_latency_compute_profile.py
scripts/phase39_latency_compute_profile.py
tests/test_phase39_latency_compute_profile.py
outputs/phase39_latency_compute_profile_20260510.json
```

The runner profiles each filter/config cell independently. Dataset loading is measured separately and excluded from inference latency.

Measured:

```text
time_to_first_estimation_ns
inference_time_per_cycle_ns_mean
inference_time_per_cycle_ns_min
inference_time_per_cycle_ns_max
step_elapsed_ns_total
process_cpu_time_ns_total
python_memory_peak_delta_bytes_max
python_memory_current_delta_bytes_total
```

Measurement limits:

```text
memory = tracemalloc Python heap deltas only, not RSS or device RAM
CPU = process_time_ns only, not CPU percent
GPU = not measured
```

## Real Run

Command used with Phase 9 / Phase 32 local caches:

```bash
uv run python scripts/phase39_latency_compute_profile.py \
  --output outputs/phase39_latency_compute_profile_20260510.json \
  --resolved-micro-slice-manifest outputs/phase37_resolved_micro_slice_20260510.json \
  --checkpoints-dir data/audit_j_v1/checkpoints \
  --amendment-artifact ../bsebench-specs/outputs/phase35_method_panel_amendment_20260510.json \
  --score-readiness-gate outputs/phase38_score_readiness_gate_20260510.json \
  --n-max 32
```

Result:

```text
status=latency_compute_profile_completed
cells=18
failure_trace_count=0
blockers=[]
```

## KPI Status

Available:

```text
latency.time_to_first_estimation
latency.inference_time_per_cycle
compute.process_cpu_time, scope-limited
compute.python_heap_peak_delta, scope-limited
```

Still blocked:

```text
compute.ram_mb
compute.cpu_percent
compute.gpu
robustness.noise_sensitivity
robustness.temperature_sensitivity
state_precision.soc_accuracy
state_precision.soh_accuracy
bse_score
ranking
```

## Summary By Filter

| Filter | Complete cells | Mean time-to-first estimation ns | Mean per-cycle inference ns | Max Python heap peak delta bytes | Total process CPU ns |
|---|---:|---:|---:|---:|---:|
| `EKF_projected` | 6 | `14237498.333333334` | `1215842.046875` | `11003` | `242669300` |
| `GRU_light` | 6 | `449918.1666666667` | `120674.73958333333` | `0` | `27733000` |
| `SO_SMO` | 6 | `13228823.833333334` | `408247.4166666667` | `0` | `95000100` |

These numbers are valid for the current micro-panel/profiling process and should be treated as run evidence, not yet a final cloud-standardized benchmark claim.

## Artifact Hash

| Artifact | SHA-256 |
|---|---|
| `bsebench-runner/outputs/phase39_latency_compute_profile_20260510.json` | `3baeaa118a8ec48404356f5480b99c1864bf76a62de518ebbed2bf4243fd9b35` |

## Validation

Executed in `bsebench-runner`:

```bash
uv run pytest tests/test_phase39_latency_compute_profile.py
uv run pytest tests/test_phase25_three_family_panel.py tests/test_phase29_real_micro_run.py tests/test_phase33_diagnostic_projection_run.py tests/test_phase36_amended_micro_run.py tests/test_phase37_dataset_panel_resolution.py tests/test_phase38_score_readiness_gate.py tests/test_phase39_latency_compute_profile.py
uv run ruff check src/bsebench_runner/phase37_dataset_panel_resolution.py src/bsebench_runner/phase38_score_readiness_gate.py src/bsebench_runner/phase39_latency_compute_profile.py scripts/phase37_dataset_panel_resolution.py scripts/phase38_score_readiness_gate.py scripts/phase39_latency_compute_profile.py tests/test_phase37_dataset_panel_resolution.py tests/test_phase38_score_readiness_gate.py tests/test_phase39_latency_compute_profile.py
git diff --check
```

Result:

```text
4 passed
27 passed
Ruff: All checks passed
git diff --check: clean
strict token scan: no raw Hugging Face token found
```

## Scientific Interpretation

Phase 39 closes the first operational KPI gap after Phase 38. We now have measured latency and scoped compute evidence across all 18 cells in the resolved real-data micro-panel.

The result is useful, but deliberately bounded:

- latency is measured at step scope;
- memory is Python heap allocation evidence, not RAM MB;
- CPU is process CPU time, not CPU percent;
- GPU is unmeasured.

This is the right direction: the benchmark is becoming instrumented rather than just executable. The remaining scientific gaps are state-truth precision and robustness.

## Next Phase

Recommended Phase 40: robustness protocol freeze and perturbation runner.

Definition of Done:

- freeze a perturbation protocol before running it;
- define noise levels and temperature perturbation policy;
- run the same three methods and six configs under controlled perturbations;
- emit robustness deltas against the Phase 36/37 baseline;
- block any BSE-Score until robustness is measured and the score formula is frozen.
