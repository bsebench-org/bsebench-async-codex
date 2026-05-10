# Phase 48 Operational Score Run

Date: 2026-05-10
Status: CLOSED
Runner commit: `1fbe3d6`
Claim status: `NO_CLAIM`

## Objective

Apply the frozen Phase 47 SOC operational-track score contract without changing weights, normalization, or claim boundaries.

## Score Name

```text
BSEBench-SOC-Operational-Track-Score
```

This is not the full BSE-Score.

## Implementation

Added to `bsebench-runner`:

```text
src/bsebench_runner/phase48_operational_score_run.py
scripts/phase48_operational_score_run.py
tests/test_phase48_operational_score_run.py
outputs/phase48_operational_score_run_20260510.json
```

## Real Run

Command:

```bash
uv run --no-sync python scripts/phase48_operational_score_run.py \
  --output outputs/phase48_operational_score_run_20260510.json \
  --phase47-operational-score-contract outputs/phase47_operational_score_contract_20260510.json \
  --phase39-latency-compute-profile outputs/phase39_latency_compute_profile_20260510.json \
  --phase40-robustness-protocol-run outputs/phase40_robustness_protocol_run_20260510.json \
  --phase45-truth-state-metrics outputs/phase45_truth_state_metrics_run_20260510.json
```

Result:

```text
status=operational_score_completed
leader=EKF_projected
leader_score=81.60985110163195
full_bse_score_authorized=False
```

## Ranking

| Rank | Method | Score |
|---:|---|---:|
| 1 | `EKF_projected` | 81.60985110163195 |
| 2 | `SO_SMO` | 78.49067438270191 |
| 3 | `GRU_light` | 56.66249700194294 |

## Component Scores

| Method | SOC Accuracy Subset | Latency | Compute Scope-Limited | Robustness |
|---|---:|---:|---:|---:|
| `EKF_projected` | 0.9999999997268858 | 0.43581095713106954 | 0.7001105658996502 | 0.8695986741402972 |
| `GRU_light` | 0.11215741538858753 | 0.9181698582012411 | 0.9400870620344 | 0.9575355107457836 |
| `SO_SMO` | 0.8963300821693638 | 0.5982613461014871 | 0.8347824826717442 | 0.6834428261487313 |

## Execution Policy

```text
operational_track_score_computed=True
operational_track_ranking_authorized=True
full_bse_score_authorized=False
full_bse_ranking_authorized=False
retrospective_relabel_as_full_bse_score_forbidden=True
```

## Artifact Hash

| Artifact | SHA-256 |
|---|---|
| `bsebench-runner/outputs/phase48_operational_score_run_20260510.json` | `0ab6554676391a33ba0de0e673170a28282927a5f3ff51728468ce5a4c4e1326` |

## Validation

Executed in `bsebench-runner`:

```bash
uv run --no-sync ruff check src/bsebench_runner/phase48_operational_score_run.py scripts/phase48_operational_score_run.py tests/test_phase48_operational_score_run.py
uv run --no-sync pytest tests/test_phase48_operational_score_run.py tests/test_phase47_operational_score_contract.py
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

This phase gives a usable benchmark artifact, but the claim is narrow:

```text
valid: SOC operational-track ranking on the current truth subset
invalid: full SOC+SOH BSE-Score
invalid: SOH method comparison
invalid: all-dataset SOC generalization
```

The result is valuable because it is transparent about scope. The next phase should produce a final handoff/audit report that states exactly what objective has been reached, what remains blocked, and what a future SOH-capable extension must implement.
