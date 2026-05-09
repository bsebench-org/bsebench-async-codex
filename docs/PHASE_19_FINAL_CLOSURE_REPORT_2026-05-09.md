# Phase 19 Final Closure Report - Narrow Profile-Axis Execution

Generated: 2026-05-09 23:59 CEST / 2026-05-09 21:59 UTC

## Final Verdict

Phase 19 is closed as an executed diagnostic evidence phase.

Final classification:

```text
EVIDENCE_GAP
NO_CLAIM
```

What changed versus Phase 18:

- Phase 18 had 16 ready runner rows with `not_run` status and zero metric rows.
- Phase 19 executed exactly those 16 rows through the current runner path.
- Phase 19 produced real RMSE cells where filters returned valid predictions.
- Phase 19 preserved failed/divergent cells as explicit sentinel evidence.
- The profile-axis statistical gate remains blocked because the metric panel is incomplete.

No public scientific claim, profile-invariance claim, leaderboard claim, or SOTA
claim is authorized.

## Artifacts

| Repo | Artifact | SHA256 | Status |
| --- | --- | --- | --- |
| `bsebench-datasets` | `outputs/phase19_profile_axis_provenance_crosswalk_20260509.json` | `d856dbfb6c18d52a5709b69914347a3804f7683845003758d233ed30d7ea1f3f` | ready |
| `bsebench-runner` | `outputs/phase19_profile_axis_runner_evidence_20260509.json` | `e50e77cba3e06e3b034ed2be693e45dda564e1fb82fbc01922ae9066f20d67f5` | executed |
| `bsebench-stats` | `outputs/phase19_profile_axis_metric_evidence_20260509.json` | `f1f943db24d52ca84be5922f3edbc2befa4e9d5108df684ae104caf93470dd16` | blocked gate |

## Dataset Crosswalk

Dataset-side Phase 19 crosswalk status: `ready`.

Observed:

- runner rows: `16`
- matched runner rows: `16`
- blocked runner rows: `0`
- dataset ready configs: `36`
- dataset ready configs not in runner plan: `20`
- expected runner identities: `16`
- local cache files checked: `16`
- Tier 2 files checked: `16`
- source files checked: `16`
- runner provenance files checked: `16`
- top-level blocking gaps: `0`

Interpretation: the 16 executed runner rows are traceable to Phase 18 ready
dataset/cache/source evidence. The 20 additional dataset-ready configs are not
lost; they are outside the narrow Phase 18 runner plan used for this execution
phase.

## Runner Execution

Runner-side status: real execution occurred.

Execution parameters:

- source plan: `outputs/phase18_profile_axis_ready_plan_20260509.json`
- runner API: `bsebench_runner.orchestrator.run_benchmark`
- rows executed: `16`
- filters executed: `10`
- max samples per config: `300`
- metric rows emitted: `160`
- usable non-sentinel metric rows: `112`
- sentinel or failed metric rows: `48`
- profile-type grouped rows: `30`
- execution blocking gaps: `0`

Non-sentinel cell counts by filter:

| Filter | Non-sentinel cells |
| --- | ---: |
| `AUKF_SR` | 13 |
| `DUKF` | 1 |
| `EKF` | 12 |
| `EnsembleMeta` | 12 |
| `FO_EKF` | 12 |
| `Hinf` | 12 |
| `ICRPF` | 7 |
| `JUKF_V6B` | 15 |
| `SO_SMO` | 16 |
| `UKF_def` | 12 |

Non-sentinel cell counts by config:

| Config | Non-sentinel cells |
| --- | ---: |
| `calce_a123_dyn-DST-T0` | 3 |
| `calce_a123_dyn-DST-T20` | 8 |
| `calce_a123_dyn-DST-T30` | 9 |
| `calce_a123_dyn-DST-T50` | 9 |
| `calce_a123_dyn-FUDS-T0` | 2 |
| `calce_a123_dyn-FUDS-T20` | 8 |
| `calce_a123_dyn-FUDS-T30` | 9 |
| `calce_a123_dyn-FUDS-T50` | 9 |
| `calce_a123_dyn-US06-T0` | 2 |
| `calce_a123_dyn-US06-T20` | 8 |
| `calce_a123_dyn-US06-T30` | 9 |
| `calce_a123_dyn-US06-T50` | 9 |
| `calce_inr_dyn-DST-T25` | 1 |
| `calce_inr_dyn-FUDS-T25` | 8 |
| `calce_inr_dyn-US06-T0` | 9 |
| `calce_inr_dyn-US06-T45` | 9 |

Runner Friedman output:

```text
error = NO_COMPLETE_CFGS
n_complete = 0
n_total = 16
chi2 = null
p_value = null
```

Interpretation: execution worked, but no complete 10-filter repeated panel
exists across the 16 configs. The sentinel values are visible and excluded from
usable evidence.

## Stats Gate

Stats-side Phase 19 metric evidence gate:

```text
classification = EVIDENCE_GAP
gate_status = blocked
claim_status = NO_CLAIM
```

Row classification:

- candidate metric rows: `160`
- real finite non-sentinel metric rows: `112`
- sentinel metric rows: `48`
- blocked rows: `0`
- not-run rows: `0`
- preflight-only rows: `0`
- metrics seen: `rmse_mV`
- units seen: `mV`
- groups seen: `16`
- profiles seen: `3`

Profile-axis audit summary:

- comparability: ready (`rmse_mV`, `mV`)
- numeric result rows used: `112`
- profile-axis audit status: `blocked`
- variance preflight status: `blocked`
- Friedman preflight status: `blocked`

Blocking gap IDs:

```text
sentinel_metric_rows
profile_axis_audit_not_ready
profile_axis_variance_preflight_not_computed
profile_axis_friedman_preflight_not_computed
profile_axis_blocking_gaps_present
```

Interpretation: the evidence advanced from metadata-only to real execution, but
the finite panel remains incomplete. The correct scientific posture is still
`EVIDENCE_GAP`.

## Validation

Datasets:

```text
uv run pytest tests/test_phase18_profile_axis_ready_subset.py tests/test_phase19_profile_axis_provenance_crosswalk.py -q
uv run ruff check src/bsebench_datasets/phase19_profile_axis_provenance_crosswalk.py tests/test_phase19_profile_axis_provenance_crosswalk.py scripts/phase19_profile_axis_provenance_crosswalk.py src/bsebench_datasets/__init__.py
uv run ruff format --check src/bsebench_datasets/phase19_profile_axis_provenance_crosswalk.py tests/test_phase19_profile_axis_provenance_crosswalk.py scripts/phase19_profile_axis_provenance_crosswalk.py
git diff --check
```

Result: passed.

Runner:

```text
uv run pytest tests/test_phase18_profile_axis_ready_plan.py tests/test_phase19_runner_evidence.py -q
uv run ruff check src/bsebench_runner/phase19_runner_evidence.py tests/test_phase19_runner_evidence.py src/bsebench_runner/__init__.py
uv run ruff format --check src/bsebench_runner/phase19_runner_evidence.py tests/test_phase19_runner_evidence.py
git diff --check
```

Result: passed.

Stats:

```text
uv run pytest tests/test_phase18_profile_axis_metric_evidence.py tests/test_phase19_profile_axis_metric_evidence.py tests/test_profile_axis_variance.py -q
uv run ruff check src/bsebench_stats/phase19_profile_axis_metric_evidence.py tests/test_phase19_profile_axis_metric_evidence.py scripts/phase19_profile_axis_metric_evidence.py src/bsebench_stats/__init__.py
uv run ruff format --check src/bsebench_stats/phase19_profile_axis_metric_evidence.py tests/test_phase19_profile_axis_metric_evidence.py scripts/phase19_profile_axis_metric_evidence.py
git diff --check
```

Result: passed.

## Code Changes

`bsebench-datasets`:

- added a Phase 19 runner/dataset provenance crosswalk builder;
- added a CLI script for deterministic artifact generation;
- added focused tests for ready crosswalk, ambiguous identity, missing Tier 2
  file, and deterministic writes;
- exported Phase 19 crosswalk APIs from `bsebench_datasets`.

`bsebench-runner`:

- added a Phase 19 execution evidence builder over the Phase 18 ready rows;
- added strict JSON sanitization for non-finite Friedman fields;
- added explicit sentinel-cell exposure;
- added non-sentinel/usable metric counts;
- added profile-type grouped diagnostic rows that exclude sentinel values from
  means when possible and mark groups containing sentinels;
- added focused tests for execution, fail-closed preflight, preflight-only mode,
  sentinel exposure, and all-sentinel no-claim behavior;
- exported Phase 19 runner APIs from `bsebench_runner`.

`bsebench-stats`:

- added a Phase 19 metric-evidence consumer;
- excluded sentinel values from finite success evidence;
- fed only real finite non-sentinel rows into the profile-axis audit;
- blocked claim promotion when sentinels or incomplete panels are present;
- added tests for mechanical success, preflight-only rows, blocked rows,
  sentinel rows, non-finite values, file IO, and top-level export;
- exported Phase 19 metric APIs from `bsebench_stats`.

## Scientific Lessons

1. Phase 18 readiness was necessary but not sufficient.
   It correctly identified rows that can be attempted, but it did not imply
   estimator stability.

2. The narrow CALCE A123/INR profile axis has enough data to execute but not
   enough complete filter coverage for a profile-invariance test.

3. Several filters produce valid RMSE on many configs, but sentinel behavior is
   structured enough that global 10-filter Friedman evidence is unavailable.

4. Treating `10000.0` as a normal finite metric would have created a false
   readiness signal. Phase 19 now blocks that path explicitly.

5. The next phase should either improve filter robustness on sentinel-heavy
   configs or define a pre-registered narrower filter subset before any
   comparative statistical claim is considered.

## Next Work

Recommended Phase 20 direction:

1. Diagnose sentinel-heavy cells by filter/config with logs and residual traces.
2. Separate algorithm failure, parameterization failure, and data-domain
   incompatibility.
3. Decide whether a justified, pre-registered subset of filters is scientifically
   valid, or whether robustness fixes must come first.
4. Re-run the same gate only after the panel is complete enough for variance and
   Friedman preflight computation.

Until then, the only allowed statement is:

```text
Phase 19 executed the 16 Phase 18 ready profile-axis rows and found 112 usable
RMSE cells plus 48 sentinel/failed cells. The profile-axis claim remains an
evidence gap.
```
