# Phase 19 Opening Audit - Execute Narrow Profile-Axis Rows

Generated: 2026-05-09 23:28 CEST / 2026-05-09 21:28 UTC

## Opening Verdict

Phase 19 is open.

Allowed status:

```text
GO_NARROW_EXECUTION
GO_FINITE_METRIC_ROWS
GO_PROFILE_AXIS_PREFLIGHT
NO_CLAIM
```

Forbidden status:

```text
GO_PUBLIC_CLAIM
GO_PROFILE_INVARIANCE_CLAIM
GO_SOTA
GO_LEADERBOARD
```

## Input State From Phase 18

Runner artifact:

```text
bsebench-runner/outputs/phase18_profile_axis_ready_plan_20260509.json
```

Observed:

- retained ready rows: `16`
- source rows: `26`
- dropped blocked rows: `10`
- validation status: `pass`
- row result status before Phase 19: `not_run`

Dataset artifact:

```text
bsebench-datasets/outputs/phase18_profile_axis_ready_subset_20260509.json
```

Observed:

- selected configs: `36`
- excluded configs: `119`
- subset fingerprint:
  `6c3d32e5441adf7f5ac0615cbb5cc9dfc8698bf4f11dd3bcea118c88ef7db345`

Stats artifact:

```text
bsebench-stats/outputs/phase18_profile_axis_metric_evidence_20260509.json
```

Observed:

- classification: `EVIDENCE_GAP`
- claim status: `NO_CLAIM`
- claim_60 rows: `16`
- not-run rows: `16`
- numeric metric rows: `0`

## Phase 19 Objective

Convert the Phase 18 ready runner rows from `not_run` metadata into audited
execution evidence.

Minimum deliverables:

1. a runner-side Phase 19 execution artifact over exactly the 16 ready rows;
2. finite metric rows only where the estimator actually produced finite values;
3. explicit sentinels / blocked cells for failed estimators, never hidden;
4. a stats-side metric evidence gate over the Phase 19 runner output;
5. a final closure report preserving `NO_CLAIM` unless all gates pass.

## Initial Execution Probe

A local probe against one ready row (`calce_a123_dyn-DST-T0`) and all ten
Audit J filters at `n_max=300` completed without process failure.

Observed finite RMSE values:

```text
AUKF_SR = 25.05832774906922
JUKF_V6B = 0.8053304789604616
SO_SMO = 485.6947637843029
```

Observed sentinel values:

```text
Hinf, EKF, DUKF, FO_EKF, ICRPF, UKF_def, EnsembleMeta = 10000.0
```

Interpretation: actual execution is feasible, but per-filter failures must be
represented as blocked/sentinel cells. They are not finite metric evidence.

## Work Packages

| Task | Repo | Scope | Status |
| --- | --- | --- | --- |
| P19-01 | `bsebench-runner` | execute/dispatch Phase 18 ready rows or fail closed | launched |
| P19-02 | `bsebench-stats` | consume Phase 19 runner output and gate metric evidence | launched |
| P19-03 | `bsebench-datasets` | crosswalk runner rows to ready subset/cache provenance | launched |
| P19-04 | `bsebench-async-codex` | integration, audit, closure report | in progress |

## Scientific Guardrails

Phase 19 may say:

- which ready rows were actually attempted;
- which filter/config cells produced finite RMSE;
- which filter/config cells produced sentinel or failed;
- whether profile-axis variance/Friedman preflight is computable.

Phase 19 may not say:

- `claim_60` is verified;
- profile invariance is proven;
- any method generalizes across profiles;
- any public performance or SOTA result is established.

Default final classification remains:

```text
EVIDENCE_GAP
```

Promotion above `EVIDENCE_GAP` requires finite comparable metric rows, complete
profile panels, computed variance and Friedman preflights, and wording
authorization.
