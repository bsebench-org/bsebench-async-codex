# Phase 54 Sequence Reservoir SOH Baseline

Date: 2026-05-10
Status: CLOSED
Claim status: `SECOND_FAMILY_DIAGNOSTIC_ONLY`

## Objective

Implement the second SOH-capable method family against the Phase 52 blinded SOH
harness. This phase adds a data-driven sequence estimator trained only on the
train split and evaluated through sealed predictions before truth joins. It
does not authorize the final BSE-Score because the third SOH family is still
missing.

## Definition Of Done

- Require Phase 52 blinded SOH harness readiness.
- Require Phase 53 ECM latent-health diagnostic completion before adding the
  second SOH family.
- Train a deterministic data-driven sequence model from allowed observations
  only: `t`, `V`, `I`, `T_meas`, `cycle_id`, and `cell_id`.
- Use `soh_truth` only for supervised training on train and post-prediction
  metrics.
- Write train, validation, and test prediction files without truth columns.
- Report SOH RMSE, MAE, and maximum error by split.
- Keep SOH benchmark claim, final BSE-Score, and final ranking unauthorized.
- Add tests for leakage blocking, Phase 53 gating, prediction schema, and JSON
  persistence.

## Artifact

```text
bsebench-runner/outputs/phase54_sequence_reservoir_soh_20260510.json
SHA256: f95a4776a2cf852e354866fab0324f9107fa231c4e312b8e6ef2e3ae40af0196
```

Local prediction cache:

```text
.phase54-local-cache/sequence_reservoir_soh_20260510/train_sequence_reservoir_soh_predictions.parquet
.phase54-local-cache/sequence_reservoir_soh_20260510/validation_sequence_reservoir_soh_predictions.parquet
.phase54-local-cache/sequence_reservoir_soh_20260510/test_sequence_reservoir_soh_predictions.parquet
```

Prediction file hashes:

```text
train:      fc5c1a2cdf7192c21373ddfc2db74625a3b459e2bd42d8eb417f4038ecdde020
validation: f61002cc262f92846b50c6f77c4e197a89a2e04f4ee7014ecb05c4737e81ff93
test:       fb502fccccb4675675a5de539df5cbea796af74bbc465966bfd2bdd3472c6a15
```

## Method

```text
family_id: sequence_model_soh
method_name: deterministic_reservoir_ridge_soh_v0
method_type: data_driven_fixed_reservoir_sequence_model
model: fixed recurrent reservoir encoder + supervised ridge readout
hidden_size: 16
ridge_alpha: 0.0001
reservoir_seed: 20260510
```

Model equation:

```text
h_t = tanh(W_in x_t + W h_{t-1} + b)
soh_estimated = clip([1, h_T]^T beta, 0, 1.5)
```

Input channels:

```text
elapsed_fraction
voltage_V
current_A
temperature_C
cumulative_discharge_Ah
voltage_drop_from_cycle_start_V
```

Training record:

```text
training_split: train
train_cycle_count: 100
readout_weight_count: 17
train_design_rank: 17
truth_columns_used_for_training: soh_truth
capacity_Ah_used_for_training: false
validation_used_for_model_selection: false
test_truth_available_during_inference: false
```

## Diagnostic Results

These metrics are valid for Phase 54 diagnostic assessment only. They are not a
final benchmark ranking because Phase 54 covers two SOH families out of the
required three-family panel.

```text
train:
  cycles: 100
  SOH RMSE: 0.003011278181442264
  SOH MAE:  0.0022675544539690917
  SOH MAXE: 0.010499270907642133
  clipped predictions: 0

validation:
  cycles: 33
  SOH RMSE: 0.007684325632177543
  SOH MAE:  0.006678505508698239
  SOH MAXE: 0.014084558536762604
  clipped predictions: 0

test:
  cycles: 35
  SOH RMSE: 0.0070473093963856264
  SOH MAE:  0.006240843097880194
  SOH MAXE: 0.012661559345432671
  clipped predictions: 0
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

The model uses `soh_truth` for train supervision and post-prediction metric
computation only. It does not use `capacity_Ah` as a runtime input or training
feature.

## Scientific Boundary

This phase satisfies the second family requirement with a lightweight,
deterministic data-driven sequence model. It is intentionally not a global mean
predictor and consumes complete-cycle time series observations through a fixed
recurrent encoder.

Current SOH panel status:

```text
family 1: ecm_latent_health_filter available from Phase 53, provisional physics baseline
family 2: sequence_model_soh available from Phase 54
family 3: hybrid_observer_health missing
```

Therefore:

```text
two_of_three_soh_families_available: true
soh_accuracy_benchmark_claim_authorized_now: false
full_bse_score_authorized_now: false
```

## Validation

Commands executed in `bsebench-runner`:

```text
uv run --no-sync pytest tests/test_phase54_sequence_reservoir_soh.py -q
uv run --no-sync ruff check src/bsebench_runner/phase54_sequence_reservoir_soh.py scripts/phase54_sequence_reservoir_soh.py tests/test_phase54_sequence_reservoir_soh.py
uv run --no-sync python scripts/phase54_sequence_reservoir_soh.py --output outputs/phase54_sequence_reservoir_soh_20260510.json --phase52-blinded-soh-harness outputs/phase52_blinded_soh_harness_20260510.json --phase53-ecm-latent-health-soh outputs/phase53_ecm_latent_health_soh_20260510.json --prediction-root ../.phase54-local-cache/sequence_reservoir_soh_20260510
uv run --no-sync pytest tests/test_phase50_release_readiness_gate.py tests/test_phase51_soh_extension_contract.py tests/test_phase52_blinded_soh_harness.py tests/test_phase53_ecm_latent_health_soh.py tests/test_phase54_sequence_reservoir_soh.py -q
uv run --no-sync ruff check src/bsebench_runner/phase50_release_readiness_gate.py src/bsebench_runner/phase51_soh_extension_contract.py src/bsebench_runner/phase52_blinded_soh_harness.py src/bsebench_runner/phase53_ecm_latent_health_soh.py src/bsebench_runner/phase54_sequence_reservoir_soh.py scripts/phase50_release_readiness_gate.py scripts/phase51_soh_extension_contract.py scripts/phase52_blinded_soh_harness.py scripts/phase53_ecm_latent_health_soh.py scripts/phase54_sequence_reservoir_soh.py tests/test_phase50_release_readiness_gate.py tests/test_phase51_soh_extension_contract.py tests/test_phase52_blinded_soh_harness.py tests/test_phase53_ecm_latent_health_soh.py tests/test_phase54_sequence_reservoir_soh.py
git diff --check
rg -n "hf_[A-Za-z0-9]{20,}" -S src scripts tests outputs/phase54_sequence_reservoir_soh_20260510.json
```

Observed validation:

```text
phase54 unit tests: 4 passed
phase50-54 targeted tests: 20 passed
ruff: all checks passed
diff whitespace: clean
token scan: no Hugging Face token found
```

## Commit

Runner commit:

```text
9b6690a GLASSBOX run Phase 54 sequence SOH baseline
```

## Next Phase

Phase 55 should implement the third SOH family, `hybrid_observer_health`, on
the same Phase 52 harness. The method must be distinct from both Phase 53 and
Phase 54, produce sealed predictions, and still keep the final score locked
until a dedicated three-family SOH score gate validates all prerequisites.
