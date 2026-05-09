# Phase 18 Final Closure Report - Narrow Profile-Axis Evidence Bundle

Generated: 2026-05-09 23:55 CEST

## Executive Verdict

Phase 18 is closed.

Final classification:

```text
claim_60_narrow_calce_a123_inr_ready_subset = EVIDENCE_GAP
claim_status = NO_CLAIM
public_profile_invariance_claim_allowed = false
```

The phase succeeded at narrowing and machine-checking the evidence chain, but
it did not produce numeric metric evidence or a computed profile-axis variance
/ Friedman audit. Therefore the scientifically rigorous conclusion remains an
evidence gap, not a claim-ready result.

## Repository Commits

| Repo | Phase 18 commit | Status |
| --- | --- | --- |
| `bsebench-datasets` | `0081f83` | pushed to `main` |
| `bsebench-runner` | `a7aaa07` | pushed to `main` |
| `bsebench-stats` | `106f141` | pushed to `main` |
| `bsebench-async-codex` | this report commit | pending at report creation |

No Phase 18 changes were required in `bsebench-specs`, `bsebench-website`, or
`bsebench-filters`.

## Delivered Artifacts

### Dataset Ready Subset

Artifact:

```text
bsebench-datasets/outputs/phase18_profile_axis_ready_subset_20260509.json
```

Source input:

```text
bsebench-datasets/outputs/phase9_profile_axis_readiness_20260509_calce_a123_inr_ready.json
```

Observed output:

| Field | Value |
| --- | --- |
| schema | `phase18_profile_axis_ready_subset_gate_v1` |
| status | `ready` |
| selected configs | `36` |
| excluded configs | `119` |
| subset fingerprint | `6c3d32e5441adf7f5ac0615cbb5cc9dfc8698bf4f11dd3bcea118c88ef7db345` |
| scientific verdict | `NO_GO_CLAIM` |
| claim ready allowed | `false` |
| HF upload allowed | `false` |

Interpretation: a narrow CALCE A123 dynamic plus CALCE INR dynamic dataset-side
subset is mechanically source/cache/Tier 2/empirical-ready according to the
supplied inventory. This is a selection gate only. It does not assert that the
profile-stress scientific claim is true.

### Runner Ready Plan

Artifact:

```text
bsebench-runner/outputs/phase18_profile_axis_ready_plan_20260509.json
```

Source input:

```text
bsebench-runner/outputs/phase9_calce_a123_inr_profile_axis_plan_20260509.json
```

Observed output:

| Field | Value |
| --- | --- |
| schema | `phase18_profile_axis_ready_plan_v1` |
| validation status | `pass` |
| source rows | `26` |
| retained ready rows | `16` |
| dropped blocked rows | `10` |
| blocking gaps | `0` |
| metric computation allowed | `false` |
| benchmark execution allowed | `false` |

Interpretation: the mixed Phase 9 runner plan was narrowed to rows whose
mechanical contracts pass. The retained plan is replay-plan-ready, but all
rows remain diagnostic/planned evidence, not executed benchmark evidence.

### Stats Metric Evidence Gate

Artifact:

```text
bsebench-stats/outputs/phase18_profile_axis_metric_evidence_20260509.json
```

Source input:

```text
bsebench-runner/outputs/phase18_profile_axis_ready_plan_20260509.json
```

Observed output:

| Field | Value |
| --- | --- |
| schema | `phase18_profile_axis_metric_evidence_v1` |
| classification | `EVIDENCE_GAP` |
| gate status | `blocked` |
| claim status | `NO_CLAIM` |
| claim_60 rows | `16` |
| profiles | `DST`, `FUDS`, `US06` |
| groups | `16` |
| not-run rows | `16` |
| numeric metric rows | `0` |
| release gate pass | `false` |

Blocking gaps:

```text
runner_rows_not_run
missing_numeric_metric_rows
no_numeric_result_rows
profile_axis_audit_not_ready
profile_axis_metric_comparability_not_ready
profile_axis_variance_preflight_not_computed
profile_axis_friedman_preflight_not_computed
profile_axis_blocking_gaps_present
```

Interpretation: the stats gate correctly refuses to promote the ready runner
plan into scientific evidence because there are no finite metric rows and no
computed profile-axis variance / Friedman audit.

## Code Delivered

`bsebench-datasets`:

- Added `phase18_profile_axis_ready_subset.py`.
- Added deterministic JSON writer and public exports.
- Added tests for ready selection, blocking gaps, conflicting identity, missing
  inputs, unsupported target IDs, and deterministic output.

`bsebench-runner`:

- Added `phase18_profile_axis_ready_plan.py`.
- Added a fail-closed ready-row-only validator over the existing profile-axis
  plan.
- Added tests for pass, blocked rows, empty ready subset, and deterministic
  artifact output.

`bsebench-stats`:

- Added `phase18_profile_axis_metric_evidence.py`.
- Added direct support for Phase 18 runner ready-plan artifact shape.
- Added nested `result.status` detection so `not_run` rows are not missed.
- Added tests for complete metric rows, ignored non-claim rows, nested claim
  IDs, runner `not_run` rows, missing metrics, supplied audit gating, file
  runner output, and top-level export.

## Validation Run

`bsebench-datasets`:

```text
uv run pytest tests/test_phase18_profile_axis_ready_subset.py \
  tests/test_phase17_profile_axis_source_bundle.py \
  tests/test_profile_axis_readiness.py -m "not slow" -q
```

Result:

```text
23 passed
```

Additional checks:

```text
uv run ruff check src/bsebench_datasets/phase18_profile_axis_ready_subset.py \
  tests/test_phase18_profile_axis_ready_subset.py src/bsebench_datasets/__init__.py
uv run ruff format --check src/bsebench_datasets/phase18_profile_axis_ready_subset.py \
  tests/test_phase18_profile_axis_ready_subset.py src/bsebench_datasets/__init__.py
git diff --check
```

Result: passed.

`bsebench-runner`:

```text
uv run pytest tests/test_phase18_profile_axis_ready_plan.py \
  tests/test_phase17_profile_axis_evidence_bundle.py \
  tests/test_profile_axis_planner.py -q
```

Result:

```text
16 passed
```

Additional checks:

```text
uv run ruff check src/bsebench_runner/phase18_profile_axis_ready_plan.py \
  tests/test_phase18_profile_axis_ready_plan.py src/bsebench_runner/__init__.py
git diff --check
```

Result: passed.

`bsebench-stats`:

```text
uv run pytest tests/test_phase18_profile_axis_metric_evidence.py \
  tests/test_phase17_profile_axis_claim60_gate.py \
  tests/test_profile_axis_variance.py -q
```

Result:

```text
36 passed
```

Additional checks:

```text
uv run ruff check src/bsebench_stats/phase18_profile_axis_metric_evidence.py \
  tests/test_phase18_profile_axis_metric_evidence.py src/bsebench_stats/__init__.py
uv run ruff format --check src/bsebench_stats/phase18_profile_axis_metric_evidence.py \
  tests/test_phase18_profile_axis_metric_evidence.py src/bsebench_stats/__init__.py
git diff --check
```

Result: passed.

## Scientific Decision

Phase 18 narrows the evidence chain but does not close `claim_60`.

What is now supported:

- There is a stable, fingerprinted, dataset-side ready subset of 36 CALCE A123
  / CALCE INR dynamic configs.
- There is a runner-side ready replay plan containing 16 rows.
- The stats gate can consume the Phase 18 runner artifact directly and fails
  closed when rows are not executed or metrics are absent.

What is not supported:

- No finite profile-axis metric rows exist in the Phase 18 evidence artifact.
- No profile-axis variance preflight is computed for current metric rows.
- No Friedman preflight is computed for current metric rows.
- No public profile-invariance, generalization, robustness, SOTA, or benchmark
  performance claim is allowed.

Therefore:

```text
CLAIM_READY = false
MECHANICAL_ONLY = false for the full claim
EVIDENCE_GAP = true
```

## Next Phase Handoff

The next scientifically valid phase should not widen the claim wording. It
should either:

1. execute the 16 ready runner rows under a declared replay protocol and emit
   finite metric rows with hashes, or
2. explicitly preserve `claim_60 = EVIDENCE_GAP` and move to another evidence
   target.

Minimum next gates before any claim promotion:

- metric rows must be finite and comparable;
- every row must have explicit provenance and current-head source linkage;
- profile groups must form a complete repeated panel;
- profile-axis variance preflight must be computed;
- Friedman preflight must be computed;
- Phase 16 wording authorization must allow the exact wording;
- final report must keep `NO_CLAIM` unless all checks pass.

