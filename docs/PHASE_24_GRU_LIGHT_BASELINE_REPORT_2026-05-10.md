# Phase 24 GRU_light Baseline Report

Date: 2026-05-10
Phase: 24
Status: CLOSED
Verdict: PASS for executable ML/DL family contract, NO_CLAIM for benchmark scoring

## Objective

Turn the Phase 23 pre-registered data-driven method slot into an executable, deterministic baseline adapter.

The objective was not to train or rank a model. The objective was to make `GRU_light` importable, invocable through the same `StateEstimator` surface as the existing filters, and traceable through a Phase 24 manifest.

## Definition Of Done

- `GRU_light` exists as a package export in `bsebench-filters`.
- The adapter exposes `step`, `get_state`, and `get_innovation`.
- The adapter returns finite `voltage_predicted` and bounded `soc_estimated`.
- Execution is deterministic for a fixed seed and input sequence.
- The adapter is marked as a data-driven ML/DL family baseline.
- The manifest explicitly blocks benchmark scoring until training artifacts are frozen.
- Tests, lint, whitespace checks, and artifact hashing pass.

## Implementation

Repository: `bsebench-filters`

Added files:

- `src/bsebench_filters/gru_light.py`
- `scripts/phase24_gru_light_manifest.py`
- `tests/test_phase24_gru_light.py`
- `outputs/phase24_gru_light_manifest_20260510.json`

Updated files:

- `src/bsebench_filters/__init__.py`
- `tests/test_filters_fast.py`
- `tests/test_smoke_contract.py`

## Adapter Contract

Method identity:

- method id: `GRU_light`
- entrypoint: `bsebench_filters.gru_light.GRULight`
- family type: `data_driven_ml`
- schema version: `phase24_gru_light_baseline_v1`
- seed: `240024`
- default hidden dimension: `4`

Input features:

- `voltage_V`
- `current_A`
- `temperature_C`
- `dt_s`

Outputs:

- `soc_estimated`
- `voltage_predicted`

The implementation is a NumPy-only GRU-style recurrent cell. It avoids adding PyTorch or another heavy dependency at this phase. That keeps the benchmark package lightweight while preserving an executable sequence-model surface.

## Scientific Guardrails

The baseline is intentionally marked:

- `claim_status: NO_CLAIM`
- `training_status: untrained_deterministic_contract`
- `posthoc_selection_allowed: false`
- `ranking_authorized: false`

This is important: Phase 24 does not pretend that an untrained deterministic recurrent adapter is a scientifically meaningful trained ML model. It only closes the missing executable slot from Phase 23.

Before this method can be used for benchmark scoring, a later phase must freeze:

- dataset split id,
- normalization statistics,
- optimizer,
- loss function,
- early-stop rule,
- weight artifact SHA-256.

## Validation

Commands executed in `bsebench-filters`:

```bash
uv run ruff format src/bsebench_filters/gru_light.py src/bsebench_filters/__init__.py scripts/phase24_gru_light_manifest.py tests/test_phase24_gru_light.py tests/test_filters_fast.py tests/test_smoke_contract.py
uv run ruff check src/bsebench_filters/gru_light.py src/bsebench_filters/__init__.py scripts/phase24_gru_light_manifest.py tests/test_phase24_gru_light.py tests/test_filters_fast.py tests/test_smoke_contract.py
uv run python scripts/phase24_gru_light_manifest.py --output outputs/phase24_gru_light_manifest_20260510.json
uv run pytest tests/test_phase24_gru_light.py tests/test_filters_fast.py tests/test_smoke_contract.py tests/test_phase9_10_11_exports.py -q
git diff --check
```

Results:

- Ruff format: passed.
- Ruff check: passed.
- Manifest generation: passed.
- Tests: `36 passed`.
- Whitespace check: passed.

Artifact hash:

```text
cf5e4fbc51147068f664a6f619b63225d57339fb166af4da68dad033467dd6d4  outputs/phase24_gru_light_manifest_20260510.json
```

## Boundary Decision

`GRU_light` was not added to the historical Audit J default registry in Phase 24.

Reason: the default registry currently reproduces a 10-filter historical panel. Adding a new ML/DL adapter there would silently change the meaning of that registry and could corrupt comparisons to prior Audit J evidence. Integration into a benchmark candidate registry should be done in a dedicated future phase with an explicit panel contract.

## Lessons

This phase separated adapter executability from scientific readiness. That is the right trajectory: first make the method family concrete and testable, then freeze training and scoring rules, then run benchmark panels.

The key remaining risk is training provenance. Without frozen splits, normalization, loss, optimizer, and weight hash, any ML/DL result would be non-reproducible and vulnerable to post-hoc tuning.

## Next Phase

Phase 25 should have one objective:

Define the benchmark execution panel contract for the three frozen families, including how `EKF`, `GRU_light`, and `SO_SMO` are selected as candidate methods without mutating the historical 10-filter Audit J registry.
