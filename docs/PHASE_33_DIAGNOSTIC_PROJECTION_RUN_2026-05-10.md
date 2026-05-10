# Phase 33 Diagnostic Projection Run

Date: 2026-05-10
Status: CLOSED WITH EXPECTED BLOCKERS
Runner commit: `bc94f84`
Claim status: `NO_CLAIM`

## Objective

Run a diagnostic-only three-family micro-run using the existing Phase 10 bounded projection adapter around raw `EKF`, without replacing raw `EKF` failure evidence or authorizing ranking.

## Definition Of Done

- Keep raw Phase 32 `EKF` failures as claim-relevant truth.
- Add a separate diagnostic run with `EKF_projected`.
- Mark projection policy `claim_eligible=false`.
- Verify whether the only remaining sentinels are dataset loader failures.
- Do not compute or claim BSE-Score.

## Result

Phase 33 completed as intended:

```text
status=diagnostic_projection_completed_with_blockers
sentinel_cells=3/21
failure_trace_count=3
```

The only remaining sentinels are `calce_legacy-DST-T25` loader failures for:

- `EKF_projected`
- `GRU_light`
- `SO_SMO`

No `EKF_projected` filter-step failure remains on the six loadable real configs.

## Diagnostic Matrix

Filters:

```text
EKF_projected, GRU_light, SO_SMO
```

Config order:

```text
calce_legacy-DST-T25
calce_a123_dyn-DST-T20
panasonic-US06-T10
nasa-CC-discharge-T24
lg_hg2-WLTC_P066-T25
yao-BCDC-T35
calce_inr_dyn-DST-T25
```

RMSE matrix, mV:

```text
EKF_projected: [10000.0, 0.01098986948904848, 97.620641515813, 316.9210945529934, 26.195785614630008, 97.95512078088804, 56.68845443968433]
GRU_light:     [10000.0, 115.59096906266561, 627.7498102299072, 352.93535389122957, 77.19048959702502, 590.7083721695728, 492.1392516534149]
SO_SMO:        [10000.0, 3.556254073446374, 705.8640160874662, 854.5809320805795, 227.99029884235424, 677.3723961948413, 239.60050619545945]
```

This matrix is diagnostic only. It must not be used as a benchmark ranking.

## Projection Policy

```text
raw_filter=EKF
executed_filter=EKF_projected
policy_id=phase10-bounded-projection-v1
policy=unit_interval_projection
adaptation_claim=contract_bounding_only
claim_eligible=false
```

## Artifact Hash

| Artifact | SHA-256 |
|---|---|
| `bsebench-runner/outputs/phase33_diagnostic_projection_run_20260510.json` | `5e18cc402f786ede71603a1fc57ef0bb2a427e2e07c16a0565bf1fed0e5f829b` |

## Validation

Executed in `bsebench-runner`:

```bash
uv run pytest tests/test_phase29_real_micro_run.py tests/test_phase31_hf_access_proof.py tests/test_phase33_diagnostic_projection_run.py
uv run ruff check src/bsebench_runner/phase33_diagnostic_projection_run.py scripts/phase33_diagnostic_projection_run.py tests/test_phase33_diagnostic_projection_run.py
git diff --check
```

Result:

```text
9 passed
All checks passed
git diff --check clean
```

Secret scan on Phase 33 files found no raw HF token.

## Scientific Interpretation

Phase 33 proves that, once Phase 32 local Tier 2 overlays are active, the real-data pipeline can execute 18/21 diagnostic cells.

However:

- `EKF_projected` is not claim-eligible.
- raw `EKF` still has real contract failures from Phase 32.
- `calce_legacy` still lacks a real Tier 2 source.
- no ranking or BSE-Score is valid.

## Next Phase

Recommended Phase 34:

Goal: decide the claim-eligible path for the ECM family.

Options to evaluate rigorously:

1. Keep raw `EKF` and treat its contract failures as method failures.
2. Pre-register `EKF_projected` as a bounded estimator variant, with projection evidence and claim limits.
3. Replace `EKF` with another ECM-family method already contract-safe, such as `UKF_def`, if Phase 23 is formally amended.

Definition of Done:

- one decision record;
- no silent replacement of the frozen family;
- if a method changes, a formal Phase 23 amendment artifact;
- rerun Phase 29 or Phase 33 according to the decision.
