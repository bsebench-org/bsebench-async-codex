# Phase 46 SOH Capability Gate

Date: 2026-05-10
Status: CLOSED
Runner commit: `ee13f30`
Claim status: `NO_CLAIM`

## Objective

Decide whether the current three-family method panel can support SOH accuracy claims after Phase 45, without oracle leakage or cosmetic outputs.

## Definition Of Done

- Inspect Phase 45 SOH evidence.
- Confirm whether NASA SOH truth is visible to the runner.
- Confirm whether the three methods emit SOH estimates.
- Reject invalid SOH shortcuts.
- Define the next allowed path.
- Keep final BSE-Score and ranking disabled.
- Emit a machine-readable gate artifact.

## Implementation

Added to `bsebench-runner`:

```text
src/bsebench_runner/phase46_soh_capability_gate.py
scripts/phase46_soh_capability_gate.py
tests/test_phase46_soh_capability_gate.py
outputs/phase46_soh_capability_gate_20260510.json
```

## Real Run

Command:

```bash
uv run --no-sync python scripts/phase46_soh_capability_gate.py \
  --output outputs/phase46_soh_capability_gate_20260510.json \
  --phase45-truth-state-metrics outputs/phase45_truth_state_metrics_run_20260510.json \
  --phase44-truth-exposure-validation ../bsebench-datasets/outputs/phase44_truth_exposure_validation_20260510.json \
  --amendment-artifact ../bsebench-specs/outputs/phase35_method_panel_amendment_20260510.json
```

Result:

```text
status=soh_capability_gate_closed_no_go
soh_available=0
soh_truth_present=3
soh_estimate_missing=3
full_bse_score_authorized=False
```

## Evidence

The runner sees SOH truth:

```text
truth_present_config_labels=[nasa-CC-discharge-T24]
truth_present_cell_count=3
```

The current panel emits no SOH estimates:

```text
available_cell_count=0
estimate_missing_cell_count=3
```

Therefore the blocker is method capability, not loader truth exposure.

## Rejected Shortcuts

Rejected:

```text
oracle_soh_truth_or_capacity_passthrough
constant_nominal_soh_prior
shared_auxiliary_soh_head
partial_trace_coulomb_soh
```

No-go rules:

```text
no_oracle_truth_passthrough
no_capacity_leakage_without_blinding
no_cosmetic_family_parity
no_partial_trace_full_capacity_claim
```

## Decision

```text
current_three_family_panel_soh_ready=False
soh_accuracy_claim_authorized=False
full_bse_score_authorized=False
ranking_authorized=False
```

Reason:

```text
The current panel exposes SOH truth on NASA but emits no SOH estimates.
Oracle truth, capacity leakage, constant nominal SOH, and shared cosmetic heads
are rejected for final benchmark claims.
```

## Required Before Full SOH Benchmark

```text
Define an SOH allowed-input contract that excludes soh_truth and capacity_Ah leakage.
Run complete-cycle SOH protocols instead of n_max=32 partial traces.
Implement or register three SOH-capable method variants aligned with the families.
Validate time-to-first-SOH separately from time-to-first-SOC.
Freeze SOH normalization and weighting before any full BSE-Score.
```

## Artifact Hash

| Artifact | SHA-256 |
|---|---|
| `bsebench-runner/outputs/phase46_soh_capability_gate_20260510.json` | `07dac8f08b19e306f769776d037869999a0f36644e01c0a123089244546799ac` |

## Validation

Executed in `bsebench-runner`:

```bash
uv run --no-sync ruff check src/bsebench_runner/phase46_soh_capability_gate.py scripts/phase46_soh_capability_gate.py tests/test_phase46_soh_capability_gate.py
uv run --no-sync pytest tests/test_phase46_soh_capability_gate.py tests/test_phase45_truth_state_metrics_run.py
git diff --check
rg -n "hf_[A-Za-z0-9]{20,}" . --glob '!uv.lock' --glob '!**/.venv/**' --glob '!outputs/phase31_hf_access_proof_*.json'
```

Result:

```text
Ruff: All checks passed
6 passed
git diff --check: clean
TOKEN_SCAN=OK
```

## Scientific Interpretation

This phase protects the benchmark from a false “complete” claim. We now have:

```text
SOC subset metrics: valid on Yao
SOH truth exposure: valid on NASA
SOH method comparison: not valid yet
Full BSE-Score: not valid yet
```

The next phase should define a formally named target-track score. That score can rank only the targets that are currently valid, while preserving a hard distinction from the future full SOC+SOH BSE-Score.
