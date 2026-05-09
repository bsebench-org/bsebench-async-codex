# Phase 29 Real Micro-Run Report

Date: 2026-05-10
Phase: 29
Status: CLOSED
Verdict: DIAGNOSTIC_BLOCKED at dataset loading, NO_CLAIM for benchmark results

## Objective

Run the three-family panel on the Phase 28 real Audit J micro-slice with a strict sample cap and record raw evidence.

This phase intentionally keeps all performance, ranking, KPI, and BSE-Score claims blocked.

## Definition Of Done

- A Phase 29 real micro-run module exists in `bsebench-runner`.
- The module consumes the Phase 28 micro-slice manifest.
- The module reconstructs a 7-config real split.
- The module executes the Phase 25 three-family panel through `run_benchmark`.
- Sentinel cells and failure traces are recorded.
- The run is capped with `n_max=32`.
- Tests, lint, whitespace checks, and artifact hash pass.

## Implementation

Repository: `bsebench-runner`

Added files:

- `src/bsebench_runner/phase29_real_micro_run.py`
- `scripts/phase29_real_micro_run.py`
- `tests/test_phase29_real_micro_run.py`
- `outputs/phase29_real_micro_run_20260510.json`

Updated file:

- `src/bsebench_runner/__init__.py`

## Real Micro-Run Result

Manifest summary:

```json
{
  "schema_version": "phase29_real_micro_run_v1",
  "phase": 29,
  "status": "micro_run_completed_with_blockers",
  "claim_status": "NO_CLAIM",
  "n_configs": 7,
  "n_max": 32,
  "sentinel_cell_count": 21,
  "failure_trace_count": 21
}
```

Panel:

- `EKF`
- `GRU_light`
- `SO_SMO`

Real micro-slice configs:

- `calce_legacy-DST-T25`
- `calce_a123_dyn-DST-T20`
- `panasonic-US06-T10`
- `nasa-CC-discharge-T24`
- `lg_hg2-WLTC_P066-T25`
- `yao-BCDC-T35`
- `calce_inr_dyn-DST-T25`

## Failure Diagnosis

All 21 cells failed at the loader stage:

| Config | Failed cells | Stage | Reason | Error type |
|---|---:|---|---|---|
| `calce_legacy-DST-T25` | 3 | loader | loader_failed | `RepositoryNotFoundError` |
| `calce_a123_dyn-DST-T20` | 3 | loader | loader_failed | `RepositoryNotFoundError` |
| `panasonic-US06-T10` | 3 | loader | loader_failed | `RepositoryNotFoundError` |
| `nasa-CC-discharge-T24` | 3 | loader | loader_failed | `RepositoryNotFoundError` |
| `lg_hg2-WLTC_P066-T25` | 3 | loader | loader_failed | `RepositoryNotFoundError` |
| `yao-BCDC-T35` | 3 | loader | loader_failed | `RepositoryNotFoundError` |
| `calce_inr_dyn-DST-T25` | 3 | loader | loader_failed | `RepositoryNotFoundError` |

The HF responses were 401 / repository not found for dataset repos such as:

- `bsebench-org/calce-a123-2014`
- `bsebench-org/calce-a123-2014-dynamic`
- `bsebench-org/panasonic-kollmeyer-2018`
- `bsebench-org/nasa-pcoe-saha-goebel-2007`

Interpretation: the runner reached real dataset loading, but the current environment lacks access to the required HF dataset repos or equivalent local Tier 2 cache roots.

## Validation

Commands executed in `bsebench-runner`:

```bash
uv run ruff format src/bsebench_runner/phase29_real_micro_run.py scripts/phase29_real_micro_run.py tests/test_phase29_real_micro_run.py src/bsebench_runner/__init__.py
uv run ruff check src/bsebench_runner/phase29_real_micro_run.py scripts/phase29_real_micro_run.py tests/test_phase29_real_micro_run.py src/bsebench_runner/__init__.py
uv run pytest tests/test_phase29_real_micro_run.py tests/test_phase28_dataset_micro_slice.py tests/test_orchestrator.py -q
uv run python scripts/phase29_real_micro_run.py --output outputs/phase29_real_micro_run_20260510.json --micro-slice-manifest outputs/phase28_dataset_micro_slice_20260510.json --checkpoints-dir data/audit_j_v1/checkpoints --n-max 32
git diff --check
```

Results:

- Ruff format: passed.
- Ruff check: passed.
- Unit/integration tests with injected registries: `20 passed`.
- Real micro-run: completed with blockers.
- Sentinel cells: `21`.
- Failure traces: `21`.
- Whitespace check: passed.

Artifact hash:

```text
e0e0e6c8f18ccb738fa04e82aa5c6ef5eef4ee48bbb9d90bc1d536ec1db3dd07  outputs/phase29_real_micro_run_20260510.json
```

## Scientific Guardrails

No KPI claim is authorized.

Reasons:

- No real trace cell completed.
- RMSE matrix is fully sentinel.
- The failures are dataset-access failures, not model-performance evidence.
- `GRU_light` remains untrained.
- BSE-Score remains blocked.

## Required Remediation Before Real Benchmark Claims

At least one of these must be resolved before real-data benchmark execution can proceed:

- Make the required HF dataset repos public or grant authenticated access.
- Provide a valid Hugging Face token in the execution environment.
- Configure local Tier 2 cache roots via the supported wrapper env vars.
- Re-run Phase 29 and require at least one non-sentinel completed cell before moving toward KPI computation.

## Next Phase

Phase 30 should have one objective:

Perform a final audit and handoff report for Phases 21-29, including the precise current state, blockers, scientific validity assessment, and the next remediation plan needed before benchmark KPI execution.
