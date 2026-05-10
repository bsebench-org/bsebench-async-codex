# Phase 55 Hybrid Observer SOH Baseline

Date: 2026-05-10
Status: CLOSED
Claim status: `THIRD_FAMILY_DIAGNOSTIC_ONLY`

## Objective

Implement the third SOH-capable method family against the Phase 52 blinded SOH
harness. This phase completes the material three-family SOH panel, but it does
not authorize the final BSE-Score or final ranking. That decision is deferred
to a dedicated score gate.

## Definition Of Done

- Require Phase 52 blinded SOH harness readiness.
- Require Phase 53 ECM latent-health diagnostic completion.
- Require Phase 54 sequence reservoir diagnostic completion.
- Implement a hybrid/nonlinear-observer method that is distinct from the direct
  capacity observer and from the sequence ML model.
- Use only allowed runtime observations during inference.
- Use `soh_truth` only for train fitting and post-prediction metrics.
- Write train, validation, and test prediction files without truth columns.
- Report SOH RMSE, MAE, and maximum error by split.
- Keep SOH benchmark claim, final BSE-Score, and final ranking unauthorized.

## Artifact

```text
bsebench-runner/outputs/phase55_hybrid_observer_soh_20260510.json
SHA256: 49d19ce49373121641c31fc783e52ecfa96ba43d95823f8668e310d4a780df34
```

Local prediction cache:

```text
.phase55-local-cache/hybrid_observer_soh_20260510/train_hybrid_observer_soh_predictions.parquet
.phase55-local-cache/hybrid_observer_soh_20260510/validation_hybrid_observer_soh_predictions.parquet
.phase55-local-cache/hybrid_observer_soh_20260510/test_hybrid_observer_soh_predictions.parquet
```

Prediction file hashes:

```text
train:      57a5558e7b8d3f5c5944c7080071a3c56c4ebfe1b00056126cfc2c415cabd024
validation: caccdb1599358ff482ce478e8c8b4c58142f3a0ad415ad7e7e3c6dc960dbc3f6
test:       df3f8b15c3b4dbe37acaa317735faa9aea1f622c8e31d0e0f24933f669bca4a0
```

## Method

```text
family_id: hybrid_observer_health
method_name: physics_informed_fading_memory_soh_observer_v0
method_type: physics_informed_hybrid_fading_memory_observer
```

Observer equation:

```text
z_k = q_proxy_k + beta^T phi_k
h_k = min(h_{k-1} + gain * (z_k - h_{k-1}), h_{k-1} + epsilon)
```

Training record:

```text
training_split: train
train_cycle_count: 100
nominal_capacity_Ah: 1.8598027864153583
nominal_capacity_calibration_cycle_count: 100
ridge_alpha: 0.001
observer_gain: 0.65
monotonic_increase_tolerance: 0.002
residual_readout_weight_count: 7
truth_columns_used_for_training: soh_truth
capacity_Ah_used_for_training: false
validation_used_for_model_selection: false
test_truth_available_during_inference: false
```

Residual features:

```text
voltage_drop_per_Ah
voltage_slope_V_per_s
temperature_mean_C
temperature_span_C
duration_s
mean_discharge_current_A
```

## Diagnostic Results

These metrics are valid for Phase 55 diagnostic assessment only. The panel is
now materially complete, but the benchmark claim still requires a dedicated
score gate.

```text
train:
  cycles: 100
  SOH RMSE: 0.007407235847626396
  SOH MAE:  0.0035304101970246417
  SOH MAXE: 0.044212421353036824

validation:
  cycles: 33
  SOH RMSE: 0.0032986959999887215
  SOH MAE:  0.0018943536325898896
  SOH MAXE: 0.011823928383855709

test:
  cycles: 35
  SOH RMSE: 0.00499120934120329
  SOH MAE:  0.0021369831816688547
  SOH MAXE: 0.019542278689054227
```

## Leakage Audit

Observed:

```text
forbidden_columns_in_predictions.train: []
forbidden_columns_in_predictions.validation: []
forbidden_columns_in_predictions.test: []
prediction_files_written_before_truth_join: true
capacity_Ah_used_as_runtime_input: false
soh_truth_used_as_runtime_input: false
blockers: 0
```

The method uses `soh_truth` for train fitting and post-prediction metric
computation only. It does not use Phase 53 or Phase 54 predictions as inputs,
so it is not a post-hoc blend of the previous families.

## Scientific Boundary

Current SOH panel status:

```text
family 1: ecm_latent_health_filter available from Phase 53, provisional physics baseline
family 2: sequence_model_soh available from Phase 54
family 3: hybrid_observer_health available from Phase 55
```

Execution policy:

```text
third_family_soh_predictions_available: true
three_family_soh_panel_available: true
soh_accuracy_benchmark_claim_authorized_now: false
full_bse_score_authorized_now: false
phase56_three_family_soh_score_gate_authorized: true
```

Phase 55 completes the missing family implementation, not the claim
authorization. Phase 56 must validate claim boundaries, compute candidate SOH
rankings, and decide whether the full score can be released.

## Validation

Commands executed in `bsebench-runner`:

```text
uv run --no-sync pytest tests/test_phase55_hybrid_observer_soh.py -q
uv run --no-sync ruff check src/bsebench_runner/phase55_hybrid_observer_soh.py scripts/phase55_hybrid_observer_soh.py tests/test_phase55_hybrid_observer_soh.py
uv run --no-sync python scripts/phase55_hybrid_observer_soh.py --output outputs/phase55_hybrid_observer_soh_20260510.json --phase52-blinded-soh-harness outputs/phase52_blinded_soh_harness_20260510.json --phase53-ecm-latent-health-soh outputs/phase53_ecm_latent_health_soh_20260510.json --phase54-sequence-reservoir-soh outputs/phase54_sequence_reservoir_soh_20260510.json --prediction-root ../.phase55-local-cache/hybrid_observer_soh_20260510
uv run --no-sync pytest tests/test_phase50_release_readiness_gate.py tests/test_phase51_soh_extension_contract.py tests/test_phase52_blinded_soh_harness.py tests/test_phase53_ecm_latent_health_soh.py tests/test_phase54_sequence_reservoir_soh.py tests/test_phase55_hybrid_observer_soh.py -q
uv run --no-sync ruff check src/bsebench_runner/phase50_release_readiness_gate.py src/bsebench_runner/phase51_soh_extension_contract.py src/bsebench_runner/phase52_blinded_soh_harness.py src/bsebench_runner/phase53_ecm_latent_health_soh.py src/bsebench_runner/phase54_sequence_reservoir_soh.py src/bsebench_runner/phase55_hybrid_observer_soh.py scripts/phase50_release_readiness_gate.py scripts/phase51_soh_extension_contract.py scripts/phase52_blinded_soh_harness.py scripts/phase53_ecm_latent_health_soh.py scripts/phase54_sequence_reservoir_soh.py scripts/phase55_hybrid_observer_soh.py tests/test_phase50_release_readiness_gate.py tests/test_phase51_soh_extension_contract.py tests/test_phase52_blinded_soh_harness.py tests/test_phase53_ecm_latent_health_soh.py tests/test_phase54_sequence_reservoir_soh.py tests/test_phase55_hybrid_observer_soh.py
git diff --check
rg -n "hf_[A-Za-z0-9]{20,}" -S src scripts tests outputs/phase55_hybrid_observer_soh_20260510.json
```

Observed validation:

```text
phase55 unit tests: 4 passed
phase50-55 targeted tests: 24 passed
ruff: all checks passed
diff whitespace: clean
token scan: no Hugging Face token found
```

## Commit

Runner commit:

```text
2e23b09 GLASSBOX run Phase 55 hybrid SOH observer
```

## Next Phase

Phase 56 should perform the three-family SOH score gate. It should check that
all prediction files are present, truth joins are post-inference only, metrics
are comparable across families, and score/ranking authorization is scientifically
defensible before any final BSE-Score is emitted.
