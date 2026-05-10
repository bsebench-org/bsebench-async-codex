# Phase 53 ECM Latent-Health SOH Baseline

Date: 2026-05-10
Status: CLOSED
Claim status: `SINGLE_FAMILY_DIAGNOSTIC_ONLY`

## Objective

Implement the first SOH-capable method family against the Phase 52 blinded SOH
harness. The method must consume only estimator-visible blinded inputs during
inference, seal predictions before truth joins, and report SOH diagnostic
metrics without authorizing a final BSE-Score or final model ranking.

## Definition Of Done

- Consume the Phase 52 harness artifact and validate its execution-ready status.
- Train/calibrate only on Phase 52 train labels, with truth unavailable during
  validation and test inference.
- Produce train, validation, and test prediction files with no `soh_truth`,
  `capacity_Ah`, or other forbidden truth columns.
- Join sealed truth labels only after prediction files have been written.
- Emit diagnostic SOH RMSE, MAE, and maximum error by split.
- Document whether the method satisfies the Phase 51 ECM-latent-health family
  contract or remains a provisional physics baseline.
- Add tests for leakage blocking, Phase 52 gating, prediction persistence, and
  metric generation.

## Artifact

```text
bsebench-runner/outputs/phase53_ecm_latent_health_soh_20260510.json
SHA256: 29d0d336c0d406adfa09586644b3020712a4d9d4c18bae7d25a38171e9b439f3
```

Local prediction cache:

```text
.phase53-local-cache/ecm_latent_health_soh_20260510/train_ecm_latent_health_soh_predictions.parquet
.phase53-local-cache/ecm_latent_health_soh_20260510/validation_ecm_latent_health_soh_predictions.parquet
.phase53-local-cache/ecm_latent_health_soh_20260510/test_ecm_latent_health_soh_predictions.parquet
```

Prediction file hashes:

```text
train:      c5d179ff68c0e3a2fab48b6a7c8a6cf9625819853cc2196fdd8b0e7412ce9e57
validation: 0c88547cccc5bae65be17f7e9322fa3e113610c59fc56bc3c80c09e60fd9e239
test:       4bb0d16a19856d26b35c2b2d588083e56dfade3e04367090f75a652959899bc5
```

## Method

```text
family_id: ecm_latent_health_filter
method_name: coulomb_counted_capacity_latent_health_v0
method_type: physics_capacity_latent_health_observer
inference_formula: soh_estimated = complete_cycle_discharge_throughput_Ah / train_calibrated_nominal_capacity_Ah
nominal_capacity_Ah: 1.8598027864153583
```

Runtime inputs:

```text
t
I
V
T_meas
cycle_id
cell_id
```

Forbidden runtime inputs:

```text
SOC
SOH
capacity_Ah
charge_capacity_Ah
discharge_capacity_Ah
end_of_life_label
measured_capacity_Ah
remaining_useful_life
rul_truth
soc_truth
soh_truth
```

## Diagnostic Results

These metrics are valid for Phase 53 diagnostic assessment only. They are not a
final benchmark ranking because Phase 53 covers one SOH method family, not the
full three-family SOH panel.

```text
train:
  cycles: 100
  SOH RMSE: 0.0007168071484171412
  SOH MAE:  0.00048031192156288707
  SOH MAXE: 0.0013177338614831502

validation:
  cycles: 33
  SOH RMSE: 0.00016646582230363791
  SOH MAE:  0.00016277578098848822
  SOH MAXE: 0.00021321775443072788

test:
  cycles: 35
  SOH RMSE: 0.0002689858374097065
  SOH MAE:  0.0002655290130590166
  SOH MAXE: 0.0003547286258147597
```

## Leakage Audit

Observed:

```text
prediction_files_written_before_truth_join: true
forbidden_columns_in_predictions.train: []
forbidden_columns_in_predictions.validation: []
forbidden_columns_in_predictions.test: []
truth_join_authorized_only_after_predictions_are_sealed: true
blockers: 0
```

The method uses `soh_truth` only for train calibration and post-prediction
metric computation. It does not use `capacity_Ah` as runtime input or
calibration input.

## Scientific Boundary

The method is a physics-informed capacity latent-health observer based on
complete-cycle coulomb counting. It is useful as a transparent first SOH
baseline, but it is not yet a full Thevenin or Dual Polarization ECM coupled to
EKF/UKF state-health estimation.

Contract alignment:

```text
phase51_family_id: ecm_latent_health_filter
latent_health_state_estimated: true
complete_cycle_coulomb_count_from_blinded_current: true
full_thevenin_or_dual_polarization_voltage_state_model: false
ekf_or_ukf_dual_estimation_used: false
final_three_family_score_eligibility: provisional_physics_baseline
```

Therefore Phase 53 does not authorize the final BSE-Score. A later phase must
either upgrade this family to a full ECM/EKF-or-UKF implementation or explicitly
accept this transparent observer as the Phase 51 physics-family baseline after
panel review.

## Validation

Commands executed in `bsebench-runner`:

```text
uv run --no-sync python scripts/phase53_ecm_latent_health_soh.py --output outputs/phase53_ecm_latent_health_soh_20260510.json --phase52-blinded-soh-harness outputs/phase52_blinded_soh_harness_20260510.json --prediction-root ../.phase53-local-cache/ecm_latent_health_soh_20260510
uv run --no-sync pytest tests/test_phase50_release_readiness_gate.py tests/test_phase51_soh_extension_contract.py tests/test_phase52_blinded_soh_harness.py tests/test_phase53_ecm_latent_health_soh.py -q
uv run --no-sync ruff check src/bsebench_runner/phase50_release_readiness_gate.py src/bsebench_runner/phase51_soh_extension_contract.py src/bsebench_runner/phase52_blinded_soh_harness.py src/bsebench_runner/phase53_ecm_latent_health_soh.py scripts/phase50_release_readiness_gate.py scripts/phase51_soh_extension_contract.py scripts/phase52_blinded_soh_harness.py scripts/phase53_ecm_latent_health_soh.py tests/test_phase50_release_readiness_gate.py tests/test_phase51_soh_extension_contract.py tests/test_phase52_blinded_soh_harness.py tests/test_phase53_ecm_latent_health_soh.py
git diff --check
rg -n "hf_[A-Za-z0-9]{20,}" -S src scripts tests outputs/phase53_ecm_latent_health_soh_20260510.json
```

Observed validation:

```text
phase50-53 targeted tests: 16 passed
ruff: all checks passed
diff whitespace: clean
token scan: no Hugging Face token found
```

## Commits

Runner commit:

```text
985b8c7 GLASSBOX run Phase 53 ECM latent-health SOH baseline
```

## Next Phase

Phase 54 should implement the second SOH family, a data-driven estimator
trained on Phase 52 train labels and evaluated with the same sealed-prediction
protocol. The target should be an intentionally simple, reproducible baseline
first, before any complex deep sequence model.
