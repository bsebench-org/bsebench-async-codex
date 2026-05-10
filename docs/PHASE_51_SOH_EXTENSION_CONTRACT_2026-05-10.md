# Phase 51 SOH Extension Contract

Date: 2026-05-10
Status: CLOSED
Claim status: `NO_CLAIM`

## Objective

Freeze the scientific contract required to extend the current SOC operational
track into a real SOC+SOH benchmark with three method families, without target
leakage, cosmetic SOH outputs, or retrospective score relabelling.

## Definition Of Done

- Use Phase 46 as the explicit no-go evidence for current SOH claims.
- Use Phase 50 as the local reproducibility gate.
- Define admissible SOH truth, runtime inputs, forbidden inference columns, and
  evaluation-only columns.
- Define three genuinely distinct SOH-capable method families.
- Pre-register the candidate full BSE score while keeping it unauthorized until
  all required metrics are populated by real held-out executions.

## Artifact

```text
bsebench-runner/outputs/phase51_soh_extension_contract_20260510.json
SHA256: 4544dcf8601da06a51947a8bcf7341d5a407d9b2f1f4449a1b89e9214ddef304
```

## Result

```text
status: soh_extension_contract_frozen_execution_pending
families: 3
soh_method_implementation_authorized_next_phase: true
soh_accuracy_claim_authorized_now: false
full_bse_score_authorized_now: false
full_bse_ranking_authorized_now: false
blockers: 0
```

Phase 51 authorizes implementation work for SOH methods. It does not authorize
SOH accuracy claims or the final BSE-Score yet.

## Three Families

```text
1. physics_ecm_filter
   Thevenin or dual-polarization ECM with EKF/UKF/dual-estimation latent health
   state, such as capacity scale or resistance growth.

2. data_driven_ml
   GRU, LSTM, TCN, or lightweight Transformer trained to emit SOH from allowed
   observations only.

3. hybrid_or_nonlinear_observer
   Distinct hybrid observer, physics-informed ML, RLS health estimator, or
   sliding-mode health observer.
```

## Leakage Rules

Forbidden at inference:

```text
soh_truth
SOH
capacity_Ah
measured_capacity_Ah
discharge_capacity_Ah
charge_capacity_Ah
remaining_useful_life
rul_truth
end_of_life_label
```

Evaluation-only:

```text
soh_truth
capacity_Ah
measured_capacity_Ah
nominal_capacity_Ah_for_truth_normalization
```

## Metrics

Precision:

```text
soh_rmse
soh_mae
soh_maxe
```

Latency:

```text
time_to_first_soh_estimation_s
inference_wall_time_per_cycle_ns
inference_cpu_time_per_cycle_ns
```

Compute:

```text
peak_rss_mb
python_heap_peak_delta_bytes
cpu_percent_process
gpu_memory_peak_mb
gpu_policy
```

Robustness:

```text
noise_delta_soh_rmse
temperature_slice_delta_soh_rmse
missing_sample_delta_soh_rmse
```

## Candidate Score

The full score is pre-registered as:

```text
BSEBench-SOC-SOH-Full-Score-Candidate
```

Weights:

```text
soc_accuracy: 0.25
soh_accuracy: 0.25
latency_time: 0.15
compute_cost: 0.15
robustness_resilience: 0.20
```

Authorization rule:

```text
The candidate score becomes computable only after all three method families
emit SOC and SOH estimates on the eligible held-out panel and all required
metrics are present.
```

## Validation

Commands executed in `bsebench-runner`:

```text
uv run --no-sync pytest tests/test_phase50_release_readiness_gate.py tests/test_phase51_soh_extension_contract.py -q
uv run --no-sync ruff check src/bsebench_runner/phase50_release_readiness_gate.py src/bsebench_runner/phase51_soh_extension_contract.py scripts/phase50_release_readiness_gate.py scripts/phase51_soh_extension_contract.py tests/test_phase50_release_readiness_gate.py tests/test_phase51_soh_extension_contract.py
uv run --no-sync python scripts/phase51_soh_extension_contract.py ...
git diff --check
rg -n "hf_[A-Za-z0-9]{20,}" -S src scripts tests outputs/phase50_release_readiness_gate_20260510.json outputs/phase51_soh_extension_contract_20260510.json
```

Observed validation:

```text
tests: 8 passed
ruff: all checks passed
diff whitespace: clean
token scan: no Hugging Face token found
```

## Next Work

```text
Phase 52: Build blinded SOH split/materialization harness.
Phase 53: Implement ECM latent-health SOH method and leakage audit.
Phase 54: Implement ML sequence SOH baseline and deterministic training protocol.
Phase 55: Implement hybrid/nonlinear-observer SOH method.
Phase 56: Run complete SOH metrics, compute telemetry, robustness, and score gate.
```
