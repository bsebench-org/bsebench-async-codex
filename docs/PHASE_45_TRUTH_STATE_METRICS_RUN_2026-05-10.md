# Phase 45 Truth State Metrics Run

Date: 2026-05-10
Status: CLOSED
Runner commit: `1747c46`
Claim status: `NO_CLAIM`

## Objective

Rerun the three-family resolved micro-panel after Phase 44 truth exposure repairs and authorize only state metrics where truth and estimates overlap.

This phase is intentionally not a final score phase. It measures what is now scientifically measurable and keeps the BSE-Score disabled.

## Definition Of Done

- Use the Phase 44 repaired local Yao Tier 2 cache.
- Use the local NASA Phase 10 cache exposing admissible `soh_truth`.
- Rerun the resolved six-config, three-method micro-panel.
- Produce SOC/SOH availability counts by target, filter, and config.
- Emit exact unavailable reasons: `truth_missing`, `estimate_missing`, or execution blockers.
- Authorize reduced truth-subset state metrics only where valid.
- Keep final BSE-Score and ranking disabled.
- Validate with tests, Ruff, whitespace check, and secret scan.

## Implementation

Added to `bsebench-runner`:

```text
src/bsebench_runner/phase45_truth_state_metrics_run.py
scripts/phase45_truth_state_metrics_run.py
tests/test_phase45_truth_state_metrics_run.py
outputs/phase45_truth_state_metrics_run_20260510.json
```

The Phase 45 builder wraps the existing Phase 36 amended run, inspects `state_metrics`, and emits a decision artifact:

```text
available_state_metric_rows
state_metric_summary.soc
state_metric_summary.soh
truth_exposure_check
remaining_final_score_blockers
execution_policy
```

## Runtime Dependency Note

This phase must run with the local Phase 44 `bsebench-datasets` repair installed, or with an equivalent published datasets commit. During the run, the runner environment used:

```bash
uv pip install -e ../bsebench-datasets
uv run --no-sync ...
```

This prevents `uv run` from replacing the local repaired datasets package with the older pinned Git dependency.

## Real Run

Command:

```bash
export BSEBENCH_CALCE_A123_DYN_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase9-local-cache/calce_a123_dyn_20260509
export BSEBENCH_CALCE_INR_DYN_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase9-local-cache/calce_inr_dyn_20260509
export BSEBENCH_PANASONIC_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase32-local-cache/panasonic_tier2_20260510
export BSEBENCH_LG_HG2_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase32-local-cache/lg_hg2_tier2_20260510
export BSEBENCH_YAO_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase44-local-cache/yao_tier2_truth_20260510
export BSEBENCH_NASA_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase10-local-cache/nasa_pcoe_b0005_20260509

uv run --no-sync python scripts/phase45_truth_state_metrics_run.py \
  --output outputs/phase45_truth_state_metrics_run_20260510.json \
  --resolved-micro-slice-manifest outputs/phase37_resolved_micro_slice_20260510.json \
  --checkpoints-dir data/audit_j_v1/checkpoints \
  --amendment-artifact ../bsebench-specs/outputs/phase35_method_panel_amendment_20260510.json \
  --phase42-state-truth-policy outputs/phase42_state_truth_policy_20260510.json \
  --phase44-truth-exposure-validation ../bsebench-datasets/outputs/phase44_truth_exposure_validation_20260510.json \
  --n-max 32
```

Result:

```text
status=truth_state_metrics_completed_with_scientific_blockers
soc_available=3/18
soh_available=0/18
bse_score_authorized=False
```

## Truth Exposure Check

Expected versus observed:

```text
expected_soc_truth_config_labels=[yao-BCDC-T35]
observed_soc_truth_config_labels=[yao-BCDC-T35]
missing_expected_soc_truth_config_labels=[]

expected_soh_truth_config_labels=[nasa-CC-discharge-T24]
observed_soh_truth_config_labels=[nasa-CC-discharge-T24]
missing_expected_soh_truth_config_labels=[]
```

Interpretation: Phase 44 truth exposure is correctly visible to the runner.

## State Metric Verdict

SOC:

```text
status=available_truth_subset
available_cell_count=3/18
truth_present_cell_count=3/18
available_config_labels=[yao-BCDC-T35]
truth_missing=15
```

SOH:

```text
status=blocked_no_available_cells
available_cell_count=0/18
truth_present_cell_count=3/18
truth_present_config_labels=[nasa-CC-discharge-T24]
estimate_missing=3
truth_missing=15
```

## Available SOC Rows

| Filter | Config | RMSE | MAE | MAXE |
|---|---|---:|---:|---:|
| `EKF_projected` | `yao-BCDC-T35` | 1.5814368480001765e-11 | 1.550280737117049e-11 | 1.7237655747237568e-11 |
| `GRU_light` | `yao-BCDC-T35` | 0.5073700887180179 | 0.5073700011205104 | 0.5077486301422487 |
| `SO_SMO` | `yao-BCDC-T35` | 0.006182488697713783 | 0.00567414839143017 | 0.00974532209050294 |

These are unitless SOC errors because `soc_truth` and `soc_estimated` are both normalized SOC fractions.

## Execution Policy

Authorized now:

```text
reduced_truth_subset_state_metrics_authorized=True
soc_accuracy_authorized_subset=True
state_max_error_authorized_subset=True
```

Still disabled:

```text
soh_accuracy_authorized_subset=False
ranking_authorized=False
bse_score_authorized=False
final_bse_score_blocked=True
```

## Remaining Scientific Blockers

```text
bse_score_weights_not_frozen
normalization_policy_not_frozen
reduced_panel_score_policy_not_frozen
soc_accuracy_available_only_on_truth_subset
soc_truth_not_complete_across_resolved_panel
soh_accuracy_blocked_estimate_missing_for_truth_cells
soh_truth_not_complete_across_resolved_panel
```

## Artifact Hash

| Artifact | SHA-256 |
|---|---|
| `bsebench-runner/outputs/phase45_truth_state_metrics_run_20260510.json` | `5ae72296bf26b34386f733a810c71ee81d388c38036c765aa873b55086a20380` |

## Validation

Executed in `bsebench-runner`:

```bash
uv run --no-sync ruff check src/bsebench_runner/phase45_truth_state_metrics_run.py scripts/phase45_truth_state_metrics_run.py tests/test_phase45_truth_state_metrics_run.py
uv run --no-sync pytest tests/test_phase45_truth_state_metrics_run.py tests/test_phase43_hardware_compute_profile.py tests/test_orchestrator.py
git diff --check
rg -n "hf_[A-Za-z0-9]{20,}" . --glob '!uv.lock' --glob '!**/.venv/**' --glob '!outputs/phase31_hf_access_proof_*.json'
```

Result:

```text
Ruff: All checks passed
19 passed
git diff --check: clean
TOKEN_SCAN=OK
```

## Scientific Interpretation

Phase 45 resolves one blocker and sharpens another:

```text
SOC accuracy: available only on Yao truth subset
SOC max error: available only on Yao truth subset
SOH truth: visible to runner on NASA
SOH accuracy: still blocked because the three current methods emit no SOH estimate
Final BSE-Score: still blocked
```

The correct next phase is not to force a score. The next phase must either add an auditable SOH-estimation path for the three method families or formally split BSEBench v1 scoring into SOC-only and SOH-capability tracks.
