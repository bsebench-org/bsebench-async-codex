# Phase 52 Blinded SOH Harness

Date: 2026-05-10
Status: CLOSED
Claim status: `NO_CLAIM`

## Objective

Build the blinded SOH split/materialization harness required before any real
SOH method implementation. This phase prepares leakage-safe inference inputs
and a sealed truth table; it does not compute SOH accuracy and does not
authorize the full BSE-Score.

## Definition Of Done

- Read eligible NASA B0005 SOH complete-cycle Parquet files from the local cache.
- Apply a deterministic chronological train/validation/test split because the
  local cache contains one cell and cannot support cell-group holdout.
- Materialize estimator-visible split tables without `soh_truth`, `capacity_Ah`,
  or `soc_truth`.
- Materialize truth labels in a separate sealed table for post-prediction
  evaluation only.
- Emit a JSON audit artifact with split counts, file hashes, leakage audit, and
  score authorization boundaries.
- Add tests for split isolation, forbidden-column exclusion, Phase 51 gating,
  and required source column validation.

## Artifact

```text
bsebench-runner/outputs/phase52_blinded_soh_harness_20260510.json
SHA256: 7ae2e6f3543d63c94c39fe92c79fb835334d5021e4f1a6b6793302123d0d041f
```

Materialized local cache:

```text
.phase52-local-cache/blinded_soh_harness_20260510/train_blinded.parquet
.phase52-local-cache/blinded_soh_harness_20260510/validation_blinded.parquet
.phase52-local-cache/blinded_soh_harness_20260510/test_blinded.parquet
.phase52-local-cache/blinded_soh_harness_20260510/sealed_truth_labels.parquet
```

The Parquet files are intentionally local-cache artifacts, not Git payloads.
The committed JSON records their paths, schemas, row counts, cycle IDs, and
hashes.

## Result

```text
status: blinded_soh_harness_materialized_execution_ready
eligible_cycles: 168
split_counts: train=100, validation=33, test=35
blockers: 0
```

Rows:

```text
train_blinded.parquet: 29361 rows
validation_blinded.parquet: 10355 rows
test_blinded.parquet: 10569 rows
sealed_truth_labels.parquet: 168 rows
```

Blinded inference columns:

```text
cell_id
t
V
I
T_meas
cycle_index
step_index
dataset_id
config_label
cycle_id
split
observation_horizon
```

Sealed truth columns:

```text
dataset_id
config_label
cell_id
cycle_id
cycle_index
split
soh_truth
capacity_Ah
```

## Leakage Audit

Forbidden inference columns:

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

Observed:

```text
forbidden_columns_by_blinded_split.train: []
forbidden_columns_by_blinded_split.validation: []
forbidden_columns_by_blinded_split.test: []
split_cycle_ids_disjoint: true
truth_table_is_separate_from_blinded_tables: true
truth_available_only_in_sealed_truth_table: true
```

Primary cell-group holdout is not feasible for the current B0005-only cache.
Phase 52 therefore uses the Phase 51 secondary split: chronological cycle
holdout.

## Execution Policy

```text
blinded_soh_inference_tables_ready: true
truth_join_authorized_only_after_predictions_are_sealed: true
phase53_method_implementation_authorized: true
soh_accuracy_claim_authorized_now: false
full_bse_score_authorized_now: false
```

## Validation

Commands executed in `bsebench-runner`:

```text
uv run --no-sync pytest tests/test_phase52_blinded_soh_harness.py -q
uv run --no-sync pytest tests/test_phase50_release_readiness_gate.py tests/test_phase51_soh_extension_contract.py tests/test_phase52_blinded_soh_harness.py -q
uv run --no-sync ruff check src/bsebench_runner/phase50_release_readiness_gate.py src/bsebench_runner/phase51_soh_extension_contract.py src/bsebench_runner/phase52_blinded_soh_harness.py scripts/phase50_release_readiness_gate.py scripts/phase51_soh_extension_contract.py scripts/phase52_blinded_soh_harness.py tests/test_phase50_release_readiness_gate.py tests/test_phase51_soh_extension_contract.py tests/test_phase52_blinded_soh_harness.py
uv run --no-sync python scripts/phase52_blinded_soh_harness.py ...
git diff --check
rg -n "hf_[A-Za-z0-9]{20,}" -S src scripts tests outputs/phase52_blinded_soh_harness_20260510.json
```

Observed validation:

```text
phase52 unit tests: 4 passed
phase50-52 combined tests: 12 passed
ruff: all checks passed
diff whitespace: clean
token scan: no Hugging Face token found
```

## Commit

Runner commit:

```text
9306bcc GLASSBOX materialize Phase 52 blinded SOH harness
```

## Next Phase

Phase 53 should implement the ECM latent-health SOH method against the blinded
tables. It must consume only the Phase 52 blinded split tables during inference
and may join `sealed_truth_labels.parquet` only after predictions are sealed.
