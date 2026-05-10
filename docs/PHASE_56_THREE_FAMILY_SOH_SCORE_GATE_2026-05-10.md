# Phase 56 Three-Family SOH Score Gate

Date: 2026-05-10
Status: CLOSED
Claim status: `PARTIAL_CLAIM`

## Objective

Audit the SOH panel produced by Phases 53, 54, and 55, then authorize only the
claims that are scientifically defensible. This phase decides whether the
three-family SOH benchmark can report a held-out precision ranking and whether
the full BSE-Score can be emitted.

## Definition Of Done

- Verify Phase 52 blinded harness readiness.
- Verify Phase 53, Phase 54, and Phase 55 completion.
- Confirm the three required SOH families are present:
  `ecm_latent_health_filter`, `sequence_model_soh`, and `hybrid_observer_health`.
- Confirm prediction tables do not contain truth columns.
- Confirm train, validation, and test cycle alignment across all three families.
- Confirm comparable SOH RMSE, MAE, and maximum-error metrics exist.
- Produce a held-out test SOH precision ranking.
- Explicitly decide whether full BSE-Score and full ranking are authorized.

## Artifact

```text
bsebench-runner/outputs/phase56_three_family_soh_score_gate_20260510.json
SHA256: 1736c34f6a6c70f01fb4da142028b197b1d3fb035323d9175620d753a2090db3
```

## Gate Result

```text
status: three_family_soh_precision_ranking_authorized_full_bse_score_blocked
blockers: 0
three_family_soh_panel_available: true
soh_precision_ranking_authorized: true
soh_accuracy_benchmark_claim_authorized_now: true
full_bse_score_authorized_now: false
full_bse_ranking_authorized_now: false
```

Authorized claim:

```text
Three SOH-capable families produced leakage-checked complete-cycle SOH
predictions on the same Phase 52 NASA B0005 train/validation/test splits; a SOH
precision ranking by held-out test RMSE is authorized.
```

## SOH Precision Ranking

Held-out test split, 35 cycles, ranked by SOH RMSE ascending:

```text
rank 1
family: ecm_latent_health_filter
method: coulomb_counted_capacity_latent_health_v0
test SOH RMSE: 0.0002689858374097065
test SOH MAE:  0.0002655290130590166
test SOH MAXE: 0.0003547286258147597

rank 2
family: hybrid_observer_health
method: physics_informed_fading_memory_soh_observer_v0
test SOH RMSE: 0.00499120934120329
test SOH MAE:  0.0021369831816688547
test SOH MAXE: 0.019542278689054227

rank 3
family: sequence_model_soh
method: deterministic_reservoir_ridge_soh_v0
test SOH RMSE: 0.0070473093963856264
test SOH MAE:  0.006240843097880194
test SOH MAXE: 0.012661559345432671
```

## Leakage And Alignment Audit

Observed:

```text
forbidden truth columns in prediction files: none
train row count by family: 100
validation row count by family: 33
test row count by family: 35
cycle_alignment_by_split.train: true
cycle_alignment_by_split.validation: true
cycle_alignment_by_split.test: true
truth_join_policy: truth labels remain outside prediction tables
```

Prediction tables were produced before metric truth joins. No prediction file
contains `soh_truth`, `capacity_Ah`, `SOC`, `SOH`, `rul_truth`, or equivalent
truth/target columns.

## Full BSE-Score Decision

The full BSE-Score remains blocked. This is intentional and correct.

Blocking reasons:

```text
SOH latency has not yet been measured for the three-family panel.
SOH RAM/CPU/GPU compute cost has not yet been measured for the three-family panel.
SOH robustness/noise/temperature stress metrics have not yet been measured.
Phase 53 physics-family method remains a provisional capacity observer, not full ECM EKF/UKF.
```

Interpretation:

```text
SOH precision objective: reached.
Three SOH families objective: reached.
Leakage-safe SOH ranking objective: reached.
Full BSE-Score objective: not reached yet.
```

## Validation

Commands executed in `bsebench-runner`:

```text
uv run --no-sync pytest tests/test_phase56_three_family_soh_score_gate.py -q
uv run --no-sync ruff check src/bsebench_runner/phase56_three_family_soh_score_gate.py scripts/phase56_three_family_soh_score_gate.py tests/test_phase56_three_family_soh_score_gate.py
uv run --no-sync python scripts/phase56_three_family_soh_score_gate.py --output outputs/phase56_three_family_soh_score_gate_20260510.json --phase52-blinded-soh-harness outputs/phase52_blinded_soh_harness_20260510.json --phase53-ecm-latent-health-soh outputs/phase53_ecm_latent_health_soh_20260510.json --phase54-sequence-reservoir-soh outputs/phase54_sequence_reservoir_soh_20260510.json --phase55-hybrid-observer-soh outputs/phase55_hybrid_observer_soh_20260510.json
uv run --no-sync pytest tests/test_phase50_release_readiness_gate.py tests/test_phase51_soh_extension_contract.py tests/test_phase52_blinded_soh_harness.py tests/test_phase53_ecm_latent_health_soh.py tests/test_phase54_sequence_reservoir_soh.py tests/test_phase55_hybrid_observer_soh.py tests/test_phase56_three_family_soh_score_gate.py -q
uv run --no-sync ruff check src/bsebench_runner/phase50_release_readiness_gate.py src/bsebench_runner/phase51_soh_extension_contract.py src/bsebench_runner/phase52_blinded_soh_harness.py src/bsebench_runner/phase53_ecm_latent_health_soh.py src/bsebench_runner/phase54_sequence_reservoir_soh.py src/bsebench_runner/phase55_hybrid_observer_soh.py src/bsebench_runner/phase56_three_family_soh_score_gate.py scripts/phase50_release_readiness_gate.py scripts/phase51_soh_extension_contract.py scripts/phase52_blinded_soh_harness.py scripts/phase53_ecm_latent_health_soh.py scripts/phase54_sequence_reservoir_soh.py scripts/phase55_hybrid_observer_soh.py scripts/phase56_three_family_soh_score_gate.py tests/test_phase50_release_readiness_gate.py tests/test_phase51_soh_extension_contract.py tests/test_phase52_blinded_soh_harness.py tests/test_phase53_ecm_latent_health_soh.py tests/test_phase54_sequence_reservoir_soh.py tests/test_phase55_hybrid_observer_soh.py tests/test_phase56_three_family_soh_score_gate.py
git diff --check
rg -n "hf_[A-Za-z0-9]{20,}" -S src scripts tests outputs/phase56_three_family_soh_score_gate_20260510.json
```

Observed validation:

```text
phase56 unit tests: 4 passed
phase50-56 targeted tests: 28 passed
ruff: all checks passed
diff whitespace: clean
token scan: no Hugging Face token found
```

## Commit

Runner commit:

```text
9e599f7 GLASSBOX gate three-family SOH precision ranking
```

## Next Phase

Phase 57 should measure or gate SOH latency, RAM, CPU/GPU policy, and
robustness/stress metrics for the three-family panel. Only after those metric
families are present should a final BSE-Score be reconsidered.
