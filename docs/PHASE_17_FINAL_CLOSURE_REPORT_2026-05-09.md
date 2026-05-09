# Phase 17 Final Closure Report - Profile-Axis Claim 60 Evidence Bundle

Generated: 2026-05-09 21:49 CEST

## Executive Verdict

Phase 17 is closed as a focused `claim_60` evidence-bundle infrastructure
phase.

Current scientific classification:

```text
claim_60 = EVIDENCE_GAP
```

Global status remains:

```text
NO_GO_CLAIM
```

Phase 17 did not verify profile-axis stress as a scientific claim. It delivered
the missing contracts and gates needed to make the next attempt auditable:
source/provenance gate, replay evidence-bundle gate, stats claim gate, and a
formal schema-level bundle contract.

## Scope Actually Closed

| Task | Repo | Delivered artifact | Status |
| --- | --- | --- | --- |
| P17-00 | `bsebench-specs` | Phase 17 `claim_60` evidence-bundle schema contract | closed |
| P17-01 | `bsebench-datasets` | profile-axis source/provenance bundle gate | closed |
| P17-02 | `bsebench-runner` | profile-axis replay evidence-bundle validator | closed |
| P17-03 | `bsebench-stats` | adversarial `claim_60` readiness classifier | closed |
| P17-04 | `bsebench-async-codex` | opening audit, task graph, closure report | closed |

No website or thesis claim update was made because the final state is not a
public result.

## Production Heads

| Repo | Head commit | Meaning |
| --- | --- | --- |
| `bsebench-async-codex` | `04312ab` before this closure report | Phase 16 closure baseline |
| `bsebench-specs` | `95d9d16` | `GLASSBOX add Phase 17 claim60 bundle contract` |
| `bsebench-datasets` | `121bae0` | `GLASSBOX add Phase 17 profile-axis source bundle` |
| `bsebench-runner` | `db1d531` | `GLASSBOX add Phase 17 profile-axis evidence bundle` |
| `bsebench-stats` | `221506a` | `GLASSBOX add Phase 17 claim60 gate` |
| `bsebench-website` | `c2ffdbb` | unchanged during Phase 17 |
| `bsebench-filters` | `cc75d9c` | unchanged during Phase 17 |

## What Was Built

### `bsebench-specs`

Added a formal Phase 17 bundle contract:

- schema version: `phase17_profile_axis_claim60_bundle_v1`;
- fixed `claim_id = claim_60`;
- verdict enum aligned with Phase 16;
- `GO_CLAIM` allowed only when verdict is `CLAIM_READY`;
- `CLAIM_READY` requires all evidence artifact kinds, all gates complete, and
  zero blockers;
- forbidden public wording is rejected in summaries and blocker details.

This is a schema-level guardrail. It does not prove the claim.

### `bsebench-datasets`

Added a profile-axis source-evidence bundle gate:

- bridges profile-axis readiness records with Phase 16 source-ledger records;
- accepts raw ledgers or pre-evaluated Phase 16 rows;
- requires source identity, source ledger, profile metadata, chemistry,
  trace identity, Tier 2 cache, local cache, and Phase 16 source-ledger
  readiness;
- declares `downloads_performed = false`;
- declares `uploads_performed = false`;
- keeps `claim_ready_state_allowed = false`.

This gate can say source evidence is complete or incomplete. It cannot say the
profile-axis stress claim is true.

### `bsebench-runner`

Added a metadata-only profile-axis evidence-bundle validator:

- bridges profile-axis plan output with Phase 16 replay manifest metadata;
- requires current repo identity, commit SHA, non-dirty worktree declaration,
  exact replay command, artifact hashes, ready profile-axis rows, and non-blocked
  plan status;
- blocks all-row-blocked plans;
- blocks unsafe claim wording;
- never runs benchmarks or computes metrics.

During review, the runner gate was hardened so `dirty=True` becomes an explicit
blocking gap.

### `bsebench-stats`

Added an adversarial `claim_60` gate:

- bridges profile-axis variance/readiness audits with Phase 16 adversarial
  claim-readiness reports;
- requires profile-axis audit readiness, comparability readiness, variance
  preflight, Friedman preflight, Phase 16 `CLAIM_READY`, evidence gate pass,
  release gate pass, and wording authorization;
- rejects broad profile-invariance wording unless Phase 16 explicitly
  authorizes it;
- does not echo supplied claim wording into output JSON;
- emits exactly one classification.

This gate can classify a complete synthetic fixture as `CLAIM_READY`, but the
current project state does not satisfy the required evidence chain.

## Validation Evidence

| Repo | Validation run | Result |
| --- | --- | --- |
| `bsebench-specs` | schema export, Phase 17 tests, schema-export tests, ruff, diff-check | `20 passed`; ruff passed; diff-check passed |
| `bsebench-datasets` | Phase 17 source bundle, Phase 16 source ledger, profile-axis readiness tests, ruff, diff-check | `21 passed`; ruff passed; diff-check passed |
| `bsebench-runner` | Phase 17 evidence bundle, Phase 16 replay manifest, profile-axis planner tests, ruff, diff-check | `18 passed`; ruff passed; diff-check passed |
| `bsebench-stats` | Phase 17 claim gate, Phase 16 adversarial gate, profile-axis variance tests, ruff, diff-check | `42 passed`; ruff passed; diff-check passed |

The validation is focused and appropriate to the Phase 17 changes. It is not a
full re-execution of every benchmark workflow.

## Current-Artifact Audit

Existing Phase 9 artifacts were reviewed before closure.

Dataset readiness artifact:

```text
bsebench-datasets/outputs/phase9_profile_axis_readiness_20260509_calce_a123_inr_ready.json
```

Observed summary:

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

Observed summary:

- `total_rows = 26`
- `ready_rows = 16`
- `blocked_rows = 10`
- `contract_validation.status = blocked`

Stats current artifact:

```text
no current Phase 17 profile-axis stats audit artifact found in bsebench-stats/outputs
```

This means the current evidence chain is incomplete. The correct classification
is `EVIDENCE_GAP`.

## Final Claim 60 Classification

| Gate | Current state | Effect |
| --- | --- | --- |
| Source/provenance | partial | 36 ready configs exist, but 119 remain not ready and 50 source-ledger gaps remain |
| Runner replay bundle | blocked | existing profile-axis plan has `contract_validation.status = blocked` |
| Stats profile-axis audit | missing current artifact | no current Phase 17 stats audit output is available |
| Phase 16 claim-readiness | not applied to a complete current bundle | no complete bundle exists to authorize wording |
| Public claim wording | not authorized | no broad profile-invariance statement is allowed |

Final:

```text
claim_60 = EVIDENCE_GAP
```

This is a successful rigorous closure because the pipeline now fails closed
with explicit blockers instead of allowing a premature claim.

## Explicit Non-Actions

Phase 17 did not:

- upload to Hugging Face;
- fetch private datasets;
- publish or authorize claim_60;
- edit thesis text as if claim_60 were proven;
- assert profile invariance;
- assert robustness across profiles;
- assert leaderboard, SOTA, or superiority status;
- use historical branches as evidence.

## Remaining Work

To move `claim_60` beyond `EVIDENCE_GAP`, the next phase must produce a real
current-head bundle:

1. resolve source-ledger gaps for the chosen profile-axis subset;
2. narrow the profile-axis target to a fully ready subset rather than the mixed
   155-config inventory;
3. regenerate a profile-axis plan with `contract_validation.status = pass`;
4. produce a profile-axis stats audit artifact under current heads;
5. produce a Phase 16 claim-readiness report over the actual evidence bundle;
6. run the Phase 17 stats gate on those actual artifacts;
7. keep public wording blocked unless the wording gate explicitly authorizes a
   narrow statement.

Recommended next target:

```text
claim_60_narrow_calce_a123_inr_ready_subset
```

The work should be narrow enough that every source, cache, split, replay, stats
artifact, and hash can be named.

## Closure Decision

Phase 17 is closed.

Allowed to proceed:

- Phase 18 focused empirical bundle construction for a narrow profile-axis
  subset;
- branch-debt archival review;
- current-head artifact generation for profile-axis stats.

Not allowed:

- public claim_60 verification;
- broad profile-invariance wording;
- performance or superiority claims.

