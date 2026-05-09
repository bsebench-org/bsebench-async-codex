# Phase 27 Three-Family Dry-Run Report

Date: 2026-05-10
Phase: 27
Status: CLOSED
Verdict: PASS for bounded runner dry-run, NO_CLAIM for dataset benchmark results

## Objective

Run a minimal bounded dry-run for the Phase 25 three-family panel to prove that the runner can execute `EKF`, `GRU_light`, and `SO_SMO` end to end.

This phase deliberately uses a synthetic runner fixture. It does not claim performance on harmonized datasets.

## Definition Of Done

- A Phase 27 dry-run module exists in `bsebench-runner`.
- The dry-run executes the three-family panel through `run_benchmark`.
- The dry-run is bounded by `n_max=8`.
- Raw RMSE evidence is recorded.
- Failure traces and sentinel cells are counted.
- Manifest explicitly states that harmonized dataset claims are not authorized.
- Tests, lint, whitespace checks, and artifact hash pass.

## Implementation

Repository: `bsebench-runner`

Added files:

- `src/bsebench_runner/phase27_three_family_dry_run.py`
- `scripts/phase27_three_family_dry_run.py`
- `tests/test_phase27_three_family_dry_run.py`
- `outputs/phase27_three_family_dry_run_20260510.json`

Updated file:

- `src/bsebench_runner/__init__.py`

## Dry-Run Scope

Manifest scope:

```json
{
  "kind": "synthetic_runner_fixture",
  "harmonized_dataset_claim": false,
  "split_id": "phase27_three_family_synthetic_dry_run",
  "n_configs": 2,
  "n_max": 8
}
```

The synthetic split contains two profiles:

- `phase27_synthetic-PULSE_A-T25`
- `phase27_synthetic-PULSE_B-T10`

## Result Summary

Manifest summary:

```json
{
  "schema_version": "phase27_three_family_dry_run_v1",
  "phase": 27,
  "status": "dry_run_completed",
  "claim_status": "NO_CLAIM",
  "filter_names": ["EKF", "GRU_light", "SO_SMO"],
  "sentinel_cell_count": 0,
  "failure_trace_count": 0,
  "blockers": []
}
```

Raw diagnostic RMSE matrix in mV:

| Filter | `PULSE_A-T25` | `PULSE_B-T10` |
|---|---:|---:|
| `EKF` | 5.2643 | 10.1918 |
| `GRU_light` | 300.0834 | 258.6301 |
| `SO_SMO` | 58.8624 | 94.4965 |

These values are diagnostic only. They are not benchmark results and must not be used as method rankings.

## Execution Policy

The manifest records:

- `full_benchmark_executed: false`
- `ranking_authorized: false`
- `bse_score_authorized: false`
- `raw_friedman_verdict_for_diagnostics_only: true`

## Validation

Commands executed in `bsebench-runner`:

```bash
uv run ruff format src/bsebench_runner/phase27_three_family_dry_run.py scripts/phase27_three_family_dry_run.py tests/test_phase27_three_family_dry_run.py src/bsebench_runner/__init__.py
uv run ruff check src/bsebench_runner/phase27_three_family_dry_run.py scripts/phase27_three_family_dry_run.py tests/test_phase27_three_family_dry_run.py src/bsebench_runner/__init__.py
uv run python scripts/phase27_three_family_dry_run.py --output outputs/phase27_three_family_dry_run_20260510.json --checkpoints-dir data/audit_j_v1/checkpoints --n-max 8
uv run pytest tests/test_phase27_three_family_dry_run.py tests/test_phase26_execution_preflight.py tests/test_orchestrator.py -q
git diff --check
```

Results:

- Ruff format: passed.
- Ruff check: passed.
- Dry-run manifest generation: passed.
- Dry-run status: `dry_run_completed`.
- Sentinel cells: `0`.
- Failure traces: `0`.
- Tests: `20 passed`.
- Whitespace check: passed.

Artifact hash:

```text
7b50777c7b0140b5917dc12ed4a9990e3ec00d23308c8b51853b839575e8cb31  outputs/phase27_three_family_dry_run_20260510.json
```

## Scientific Guardrails

This phase proves executable integration only.

It does not prove:

- real dataset compatibility,
- harmonized dataset coverage,
- final precision,
- latency,
- compute cost,
- robustness,
- BSE-Score.

The high `GRU_light` diagnostic RMSE is expected for an untrained deterministic contract baseline. It reinforces the Phase 24 warning that ML/DL training artifacts must be frozen before scientific scoring.

## Next Phase

Phase 28 should have one objective:

Bind the benchmark path to real harmonized dataset evidence by creating a minimal dataset availability and micro-slice selection manifest, without launching a broad benchmark run.
