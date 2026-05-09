# Phase 18 Opening Audit - Narrow Profile-Axis Bundle

Generated: 2026-05-09 23:00 CEST

## Opening Verdict

Phase 18 is open as a narrow evidence-bundle construction phase.

Allowed status:

```text
GO_NARROW_SUBSET
GO_READY_PLAN
GO_METRIC_EVIDENCE_GATE
NO_GO_CLAIM
```

Forbidden status:

```text
GO_PUBLIC_CLAIM
GO_PROFILE_INVARIANCE_CLAIM
GO_PERFORMANCE_CLAIM
GO_SOTA
GO_LEADERBOARD
```

## Scope

Phase 18 continues the Phase 17 target:

```text
claim_60_narrow_calce_a123_inr_ready_subset
```

The goal is to reduce the Phase 17 evidence gap by narrowing from the mixed
profile-axis inventory to rows that are already mechanically ready. The phase
does not prove profile invariance or robustness across profiles.

## Starting Evidence

Dataset readiness artifact:

```text
bsebench-datasets/outputs/phase9_profile_axis_readiness_20260509_calce_a123_inr_ready.json
```

Observed:

- `configs_total = 155`
- `ready_configs = 36`
- `not_ready_configs = 119`
- `source_ledger_status.ready = 105`
- `source_ledger_status.source_ledger_unavailable = 50`
- `tier2_cache_status.ready = 36`
- `tier2_cache_status.trace_unavailable = 119`

Runner plan artifact:

```text
bsebench-runner/outputs/phase9_calce_a123_inr_profile_axis_plan_20260509.json
```

Observed:

- `total_rows = 26`
- `ready_rows = 16`
- `blocked_rows = 10`
- `contract_validation.status = blocked`

Important interpretation: the mixed plan is blocked, but it contains ready
rows that may form a narrow mechanical subset.

## Phase 18 Work Packages

| Task | Repo | Output | Status |
| --- | --- | --- | --- |
| P18-01 | `bsebench-datasets` | ready-subset selector for profile-axis source evidence | launched |
| P18-02 | `bsebench-runner` | ready-row-only profile-axis plan validator | launched |
| P18-03 | `bsebench-stats` | metric availability gate for profile-axis variance audit | launched |
| P18-04 | `bsebench-async-codex` | opening audit, task graph, final closure report | in progress |

## Scientific Guardrails

Phase 18 may say:

- a narrow subset is mechanically source-ready;
- a plan has only ready rows;
- metric evidence is missing or available;
- the final classification remains `EVIDENCE_GAP` if metrics are absent.

Phase 18 may not say:

- claim_60 is verified;
- profile-axis invariance is proven;
- any method generalizes across profiles;
- any public performance result is established.

## Expected Conservative Outcome

The likely rigorous closure is:

```text
claim_60 = EVIDENCE_GAP
```

Reason: existing runner rows are `not_run`, and no current stats metric artifact
was found at Phase 17 closure. Phase 18 should make that blocker machine
checkable instead of hiding it.

