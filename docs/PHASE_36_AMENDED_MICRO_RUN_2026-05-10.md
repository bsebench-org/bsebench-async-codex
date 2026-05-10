# Phase 36 Amended Micro-Run

Date: 2026-05-10
Status: CLOSED WITH DATASET BLOCKER
Runner commit: `d98ebca`
Claim status: `NO_CLAIM`

## Objective

Execute the real micro-slice with the Phase 35 amended method panel:

```text
EKF_projected, GRU_light, SO_SMO
```

The purpose was to confirm that the pre-registered ECM bounded-projection amendment removes the raw `EKF` output-contract blocker without authorizing ranking or BSE-Score.

## Definition Of Done

- Add a runner module that requires and validates the Phase 35 amendment artifact.
- Build an amended filter registry from the raw Audit J factories.
- Execute the Phase 28 real micro-slice with Phase 32 Tier 2 overlays.
- Preserve raw `EKF` failure provenance in execution policy.
- Keep ranking and BSE-Score disabled.
- Record remaining blockers with failure traces.
- Validate with targeted tests, Ruff, and whitespace checks.

## Implementation

Added to `bsebench-runner`:

```text
src/bsebench_runner/phase36_amended_micro_run.py
scripts/phase36_amended_micro_run.py
tests/test_phase36_amended_micro_run.py
outputs/phase36_amended_micro_run_20260510.json
```

The runner validates the critical Phase 35 fields locally before execution:

```text
schema_version=phase35_method_panel_amendment_v1
claim_status=NO_CLAIM
silent_replacement=false
posthoc_score_selection=false
ranking_authorized_now=false
bse_score_authorized_now=false
effective_method_ids=[EKF_projected, GRU_light, SO_SMO]
projection_policy.raw_method_id=EKF
projection_policy.executed_method_id=EKF_projected
projection_policy.policy_id=phase10-bounded-projection-v1
```

## Real Run Result

Command used with Phase 9 / Phase 32 local caches:

```bash
uv run python scripts/phase36_amended_micro_run.py \
  --output outputs/phase36_amended_micro_run_20260510.json \
  --micro-slice-manifest outputs/phase28_dataset_micro_slice_20260510.json \
  --checkpoints-dir data/audit_j_v1/checkpoints \
  --amendment-artifact ../bsebench-specs/outputs/phase35_method_panel_amendment_20260510.json \
  --n-max 32
```

Result:

```text
status=amended_micro_run_completed_with_blockers
sentinel_cell_count=3
failure_trace_count=3
```

Filter order:

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

Failure summary:

```text
EKF_projected:loader_failed:RepositoryNotFoundError count=1
GRU_light:loader_failed:RepositoryNotFoundError count=1
SO_SMO:loader_failed:RepositoryNotFoundError count=1
```

All remaining sentinels are on:

```text
calce_legacy-DST-T25
```

There are no `filter_step` failures in Phase 36.

## Artifact Hash

| Artifact | SHA-256 |
|---|---|
| `bsebench-runner/outputs/phase36_amended_micro_run_20260510.json` | `af400d14ff09347a403dd1c8a96c681cbd7741ee4ff1a52111e2241473833255` |

## Validation

Executed in `bsebench-runner`:

```bash
uv run pytest tests/test_phase25_three_family_panel.py tests/test_phase29_real_micro_run.py tests/test_phase33_diagnostic_projection_run.py tests/test_phase36_amended_micro_run.py
uv run ruff check src/bsebench_runner/phase36_amended_micro_run.py scripts/phase36_amended_micro_run.py tests/test_phase36_amended_micro_run.py
git diff --check
```

Result:

```text
15 passed
Ruff: All checks passed
git diff --check: clean
```

Secret scan on Phase 36 files found no raw Hugging Face token.

## Scientific Interpretation

Phase 36 validates the amended three-family execution path on the six real configs that currently load. The raw ECM output-contract blocker is resolved only through the pre-registered `EKF_projected` amendment; raw `EKF` failure evidence remains part of the provenance chain.

The benchmark is still not score-ready because `calce_legacy-DST-T25` is unresolved. Producing a headline ranking or BSE-Score now would conflate method performance with a dataset access gap.

## Next Phase

Recommended Phase 37: resolve or formally retire the `calce_legacy-DST-T25` blocker.

Definition of Done:

- determine whether a legitimate Tier 2 source exists for `calce_legacy-DST-T25`;
- do not substitute `calce_a123_dyn` for `calce_legacy`;
- either create a proper Tier 2 overlay for the legacy config or issue a formal retirement/exclusion record;
- rerun Phase 36 after the decision;
- keep score disabled until the dataset panel is either complete or formally accounted.
