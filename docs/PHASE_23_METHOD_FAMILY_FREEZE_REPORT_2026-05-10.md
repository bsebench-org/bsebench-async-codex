# Phase 23 Method Family Freeze Report

Date: 2026-05-10
Phase: 23
Status: CLOSED
Verdict: PASS for method-family pre-registration, NO_CLAIM for benchmark ranking

## Objective

Freeze the three benchmark method families before any future score-producing run so that model choice is not driven by observed benchmark performance.

This phase does not authorize ranking, accuracy claims, or BSE-Score claims. It only creates a versioned contract that fixes the representative method families and fallback policy.

## Definition Of Done

- A machine-readable method-family freeze contract exists in `bsebench-specs`.
- The contract covers exactly three distinct families:
  - physics/ECM classical filtering,
  - pure data-driven ML/DL sequence modeling,
  - nonlinear observer or hybrid method.
- The contract forbids score peeking and post-hoc family selection.
- The ML/DL family is explicitly marked as pending implementation for Phase 24.
- JSON schema export includes the new contract.
- Tests and lint pass.
- The phase result is logged with artifact hashes.

## Implemented Contract

Repository: `bsebench-specs`

Implemented files:

- `src/bsebench_specs/phase23_method_family_freeze.py`
- `scripts/phase23_method_family_freeze.py`
- `tests/test_phase23_method_family_freeze.py`
- `schemas/phase23_method_family_freeze.schema.json`
- `outputs/phase23_method_family_freeze_20260510.json`

Updated files:

- `src/bsebench_specs/__init__.py`
- `scripts/export_schemas.py`
- `tests/test_schema_export.py`

## Frozen Families

| Slot | Family type | Representative | Fallback | Status | Trainable | Notes |
|---|---|---:|---:|---|---|---|
| `family_1_ecm_classical` | `ecm_classical_filter` | `EKF` | `UKF_def` | implemented | no | Physics/ECM plus classical Kalman filter baseline. |
| `family_2_data_driven_sequence` | `data_driven_ml` | `GRU_light` | `LSTM_light` | pending Phase 24 | yes | Pure ML/DL sequence family; architecture, training split, normalization, seed, and early stopping remain to be frozen before scoring. |
| `family_3_nonlinear_observer` | `nonlinear_observer_or_hybrid` | `SO_SMO` | `Hinf` | implemented | no | Sliding-mode observer family, distinct from Kalman and data-driven sequence models. |

## Selection Policy

The generated contract records:

- `ranking_authorized: false`
- `frozen_before_final_results: true`
- `excludes_score_peeking: true`
- `allows_fallback_only_if_primary_unavailable: true`
- each method family has `no_posthoc_selection: true`

This means future phases may implement missing adapters and execute benchmark runs, but they must not swap families or pick a better-looking method after seeing results.

## Validation

Commands executed in `bsebench-specs`:

```bash
uv run ruff format src/bsebench_specs/phase23_method_family_freeze.py tests/test_phase23_method_family_freeze.py tests/test_schema_export.py scripts/phase23_method_family_freeze.py scripts/export_schemas.py src/bsebench_specs/__init__.py
uv run ruff check src/bsebench_specs/phase23_method_family_freeze.py tests/test_phase23_method_family_freeze.py tests/test_schema_export.py scripts/phase23_method_family_freeze.py scripts/export_schemas.py src/bsebench_specs/__init__.py
uv run python scripts/export_schemas.py schemas
uv run python scripts/phase23_method_family_freeze.py --output outputs/phase23_method_family_freeze_20260510.json
uv run pytest tests/test_phase23_method_family_freeze.py tests/test_schema_export.py -q
git diff --check
```

Results:

- Ruff format: passed.
- Ruff check: passed.
- Schema export: passed.
- Phase 23 artifact generation: passed.
- Tests: `20 passed`.
- Whitespace check: passed.

Artifact hashes:

```text
04822e402d07522072983f22c0b19042664a5cad6b56bbecfae7f01f551034dc  outputs/phase23_method_family_freeze_20260510.json
3b8daa822f85bc736d45914d5f693edbedd7de2f2dfe5adb4cd0bf7bb2f54774  schemas/phase23_method_family_freeze.schema.json
```

## Scientific Guardrails

Phase 23 intentionally keeps the benchmark in `NO_CLAIM` status.

Reasons:

- Phase 22 found no strict stable complete panel yet.
- Historical sentinel failures still need root-cause traces from future instrumented runs.
- The data-driven ML/DL family is pre-registered but not yet implemented.
- BSE-Score and final ranking remain blocked until the benchmark has a validated panel, a complete KPI manifest, and reproducible execution traces.

## Lessons

The project now has a clean anti-p-hacking control point: the three comparison families are frozen before final benchmark execution. This improves scientific defensibility because future results can be interpreted as outcomes of a pre-registered design rather than model shopping.

The main remaining risk is not family selection; it is execution readiness. The next phase must turn the pending ML/DL slot into a minimal, reproducible, testable baseline without broadening the benchmark claim.

## Next Phase

Phase 24 should have one objective:

Implement and freeze the `GRU_light` data-driven sequence baseline contract, including adapter entrypoint, deterministic seed policy, input/output schema, training or calibration boundary, and tests proving it can be invoked by the benchmark pipeline without score peeking.
