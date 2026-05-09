# Phase 25 Three-Family Panel Report

Date: 2026-05-10
Phase: 25
Status: CLOSED
Verdict: PASS for panel contract, NO_CLAIM for benchmark ranking

## Objective

Define the benchmark execution panel for the three pre-registered method families without mutating the historical Audit J default registry.

The panel is a pre-execution contract. It does not run the benchmark, compute KPIs, or rank methods.

## Definition Of Done

- A separate Phase 25 runner module builds a three-method registry.
- The panel contains exactly:
  - `EKF`,
  - `GRU_light`,
  - `SO_SMO`.
- The historical Audit J default registry remains at exactly 10 filters.
- `GRU_light` is sourced from the Phase 24 executable baseline contract.
- The manifest records no post-hoc selection and no ranking authorization.
- Tests prove the Phase 25 panel does not mutate the default registry.
- The runner lockfile points to the Phase 24 `bsebench-filters` commit that exports `GRULight`.

## Implementation

Repository: `bsebench-runner`

Added files:

- `src/bsebench_runner/phase25_three_family_panel.py`
- `scripts/phase25_three_family_panel_manifest.py`
- `tests/test_phase25_three_family_panel.py`
- `outputs/phase25_three_family_panel_20260510.json`

Updated files:

- `src/bsebench_runner/__init__.py`
- `uv.lock`

## Frozen Panel

| Slot | Family type | Primary filter | Fallback | Source |
|---|---|---:|---:|---|
| `family_1_ecm_classical` | `ecm_classical_filter` | `EKF` | `UKF_def` | Audit J v1 default registry |
| `family_2_data_driven_sequence` | `data_driven_ml` | `GRU_light` | `LSTM_light` | Phase 24 GRU_light contract |
| `family_3_nonlinear_observer` | `nonlinear_observer_or_hybrid` | `SO_SMO` | `Hinf` | Audit J v1 default registry |

Manifest summary:

```json
{
  "schema_version": "phase25_three_family_panel_v1",
  "phase": 25,
  "claim_status": "NO_CLAIM",
  "status": "ready_for_phase26_execution_preflight",
  "panel_filter_names": ["EKF", "GRU_light", "SO_SMO"],
  "blockers": []
}
```

## Registry Guardrails

The Phase 25 module deliberately builds a new registry:

1. Build the existing Audit J default registry.
2. Copy only the `EKF` and `SO_SMO` factories into a separate panel registry.
3. Add `GRU_light` from `bsebench_filters.gru_light.default_gru_light_config`.

The historical default registry remains unchanged:

- expected default registry count: `10`
- actual default registry count: `10`
- panel registry count: `3`
- default registry mutated: `false`

## Validation

Commands executed in `bsebench-runner`:

```bash
uv sync --upgrade-package bsebench-filters
uv sync --extra dev
uv run ruff format src/bsebench_runner/phase25_three_family_panel.py scripts/phase25_three_family_panel_manifest.py tests/test_phase25_three_family_panel.py src/bsebench_runner/__init__.py
uv run ruff check src/bsebench_runner/phase25_three_family_panel.py scripts/phase25_three_family_panel_manifest.py tests/test_phase25_three_family_panel.py src/bsebench_runner/__init__.py
uv run python scripts/phase25_three_family_panel_manifest.py --output outputs/phase25_three_family_panel_20260510.json --checkpoints-dir data/audit_j_v1/checkpoints
uv run pytest tests/test_phase25_three_family_panel.py tests/test_default_registries.py -q
git diff --check
```

Results:

- Dependency sync: passed, `bsebench-filters` updated to commit `6e53cf88f15256cab6af039223d95859cc441ef7`.
- Ruff format: passed.
- Ruff check: passed.
- Manifest generation: passed.
- Tests: `16 passed, 1 skipped`.
- Skip reason: legacy slow construction test skipped because `BSEBENCH_LEGACY_AUTORESEARCH_DIR` was not set.
- Whitespace check: passed.

Artifact hash:

```text
b58215bb3baddfcf57f0c579ca70aa5bc526d5397af72951dd105742f287d3d2  outputs/phase25_three_family_panel_20260510.json
```

## Scientific Guardrails

Phase 25 still records `NO_CLAIM`.

Reasons:

- It defines candidate identity only.
- It does not run datasets.
- It does not compute precision, latency, compute, robustness, or BSE-Score.
- `GRU_light` remains an untrained deterministic contract baseline until a later training-freeze phase.
- Phase 22 stable-panel issues and sentinel-trace gaps still affect final benchmark claims.

## Next Phase

Phase 26 should have one objective:

Build an execution preflight for the three-family panel that checks dataset-loader availability, method factory construction, smoke execution, planned KPI fields, and fail-closed blockers before any full benchmark run.
