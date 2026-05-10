# Phase 47 Operational Score Contract

Date: 2026-05-10
Status: CLOSED
Runner commit: `71996b5`
Claim status: `NO_CLAIM`

## Objective

Freeze a clearly named SOC operational-track score contract without authorizing the full SOC+SOH BSE-Score.

## Key Decision

The next score is authorized only under this name:

```text
BSEBench-SOC-Operational-Track-Score
```

It must not be called:

```text
BSE-Score
final BSEBench score
full benchmark score
```

## Implementation

Added to `bsebench-runner`:

```text
src/bsebench_runner/phase47_operational_score_contract.py
scripts/phase47_operational_score_contract.py
tests/test_phase47_operational_score_contract.py
outputs/phase47_operational_score_contract_20260510.json
```

## Real Run

Command:

```bash
uv run --no-sync python scripts/phase47_operational_score_contract.py \
  --output outputs/phase47_operational_score_contract_20260510.json \
  --phase39-latency-compute-profile outputs/phase39_latency_compute_profile_20260510.json \
  --phase40-robustness-protocol-run outputs/phase40_robustness_protocol_run_20260510.json \
  --phase43-hardware-compute-profile outputs/phase43_hardware_compute_profile_20260510.json \
  --phase45-truth-state-metrics outputs/phase45_truth_state_metrics_run_20260510.json \
  --phase46-soh-capability-gate outputs/phase46_soh_capability_gate_20260510.json
```

Result:

```text
status=operational_score_contract_frozen_full_score_blocked
track_next=True
full_bse_score_authorized=False
blockers=[]
```

## Contract

Score:

```text
score_id=bsebench_soc_operational_track_v0_1
score_name=BSEBench-SOC-Operational-Track-Score
scale=0_to_100_higher_is_better
not_the_full_bse_score=True
```

Formula:

```text
score = 100 * sum_c(weight_c * component_c)
component_c = sum_j(subweight_j * reciprocal_lower_is_better(x_j, ref_j))
reciprocal_lower_is_better(x, ref) = 1 / (1 + max(x, 0) / ref)
```

Weights:

```text
soc_accuracy_subset=0.45
latency_time=0.20
compute_cost_scope_limited=0.15
robustness_resilience=0.20
```

## Claim Boundaries

Allowed claim:

```text
Operational-track comparison of three methods on SOC subset accuracy, latency,
scope-limited compute, and diagnostic robustness.
```

Forbidden claims:

```text
full BSE-Score
full SOC+SOH benchmark completion
SOH accuracy comparison
state robustness comparison
all-dataset SOC generalization beyond the truth subset
fixed-cloud per-method RAM/GPU attribution
```

## Execution Policy

```text
operational_track_contract_frozen=True
operational_track_score_computation_authorized_next_phase=True
operational_track_ranking_authorized_next_phase=True
full_bse_score_authorized=False
full_bse_ranking_authorized=False
retrospective_relabel_as_full_bse_score_forbidden=True
```

## Artifact Hash

| Artifact | SHA-256 |
|---|---|
| `bsebench-runner/outputs/phase47_operational_score_contract_20260510.json` | `3f579bff9b894a77073aecd135c5e72a23fe748b0ba817e254a743f1a78c1f18` |

## Validation

Executed in `bsebench-runner`:

```bash
uv run --no-sync ruff check src/bsebench_runner/phase47_operational_score_contract.py scripts/phase47_operational_score_contract.py tests/test_phase47_operational_score_contract.py
uv run --no-sync pytest tests/test_phase47_operational_score_contract.py tests/test_phase46_soh_capability_gate.py
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

Phase 47 is a controlled compromise. It lets us compute and rank a valid operational SOC track without pretending that the original full SOC+SOH objective is complete.

The next phase can compute the score because the formula, weights, normalization, missing-metric policy, and claim boundaries are now frozen before calculation.
