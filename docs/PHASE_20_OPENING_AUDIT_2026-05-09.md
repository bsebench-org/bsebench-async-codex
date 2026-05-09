# Phase 20 Opening Audit - Sentinel Root-Cause Diagnostics

Generated: 2026-05-09 23:59 CEST / 2026-05-09 21:59 UTC

## Opening Verdict

Phase 20 is open as a diagnostic phase only.

Allowed status:

```text
GO_SENTINEL_DIAGNOSTICS
GO_ROOT_CAUSE_HYPOTHESES
GO_NO_CLAIM_GATE
```

Forbidden status:

```text
GO_PUBLIC_CLAIM
GO_PROFILE_INVARIANCE_CLAIM
GO_LEADERBOARD
GO_FILTER_CHERRY_PICKING
```

## Input State From Phase 19

Runner artifact:

```text
bsebench-runner/outputs/phase19_profile_axis_runner_evidence_20260509.json
```

Observed:

- rows executed: `16`
- filters executed: `10`
- max samples per config: `300`
- metric cells: `160`
- usable non-sentinel cells: `112`
- sentinel or failed cells: `48`
- Friedman preflight: `NO_COMPLETE_CFGS`
- complete 10-filter configs: `0 / 16`

Stats artifact:

```text
bsebench-stats/outputs/phase19_profile_axis_metric_evidence_20260509.json
```

Observed:

- classification: `EVIDENCE_GAP`
- gate status: `blocked`
- claim status: `NO_CLAIM`
- blocking gaps:
  - `sentinel_metric_rows`
  - `profile_axis_audit_not_ready`
  - `profile_axis_variance_preflight_not_computed`
  - `profile_axis_friedman_preflight_not_computed`
  - `profile_axis_blocking_gaps_present`

Dataset crosswalk:

```text
bsebench-datasets/outputs/phase19_profile_axis_provenance_crosswalk_20260509.json
```

Observed:

- crosswalk status: `ready`
- runner rows matched: `16 / 16`
- blocked runner rows: `0`
- local cache files checked: `16`
- Tier 2 files checked: `16`
- source files checked: `16`

## Sentinel Pattern Snapshot

Sentinels by filter:

| Filter | Sentinel cells |
| --- | ---: |
| `DUKF` | 15 |
| `ICRPF` | 9 |
| `EKF` | 4 |
| `EnsembleMeta` | 4 |
| `FO_EKF` | 4 |
| `Hinf` | 4 |
| `UKF_def` | 4 |
| `AUKF_SR` | 3 |
| `JUKF_V6B` | 1 |
| `SO_SMO` | 0 |

Sentinels by profile:

| Profile | Sentinel cells |
| --- | ---: |
| `DST` | 20 |
| `FUDS` | 14 |
| `US06` | 14 |

Sentinels by temperature:

| Temperature C | Sentinel cells |
| ---: | ---: |
| `0` | 24 |
| `20` | 6 |
| `25` | 11 |
| `30` | 3 |
| `45` | 1 |
| `50` | 3 |

Interpretation at opening: failures are concentrated in a small set of filters
and in low-temperature / DST-heavy configurations, but this is only a pattern,
not a causal conclusion.

## Phase 20 Objective

Explain why Phase 19 cannot produce a complete profile-axis metric panel.

Minimum deliverables:

1. runner-side sentinel diagnostic matrix over the exact Phase 19 execution rows;
2. filter-side root-cause review with evidence-backed hypotheses only;
3. stats-side no-claim gate over the diagnostic output;
4. final closure report with explicit remediation recommendations;
5. clean repos and pushed commits.

## Scientific Guardrails

Phase 20 may say:

- which cells are sentinel/non-sentinel;
- which filters/configs/profiles/temperatures are most affected;
- whether local data provenance is still ready;
- which root-cause hypotheses are supported by current evidence;
- which corrections should be attempted next.

Phase 20 may not say:

- `claim_60` is validated;
- profile invariance is proven;
- a subset of filters is statistically justified after seeing results;
- any method is better or worse in a public benchmark sense.

Default final classification remains:

```text
EVIDENCE_GAP
NO_CLAIM
```

