# Phase 20 Task Graph - Sentinel Diagnostics

Generated: 2026-05-09 23:59 CEST / 2026-05-09 21:59 UTC

## Invariant

```text
NO_CLAIM until sentinel causes are understood, complete panels exist, and
profile-axis preflights compute on pre-registered evidence.
```

## Dependency Flow

```text
Phase 19 runner evidence
        |
        v
sentinel/non-sentinel diagnostic matrix
        |
        v
filter-side root-cause review
        |
        v
stats no-claim diagnostic gate
        |
        v
Phase 20 closure report and remediation plan
```

## Parallel Work

| Task | Owner Repo | Write Scope | Acceptance |
| --- | --- | --- | --- |
| P20-01 | `bsebench-runner` | sentinel diagnostics module/tests/artifact | exact Phase 19 input, finite JSON, explicit matrices |
| P20-02 | `bsebench-filters` | filter root-cause review artifact | evidence-backed hypotheses, no algorithm churn unless tested |
| P20-03 | `bsebench-stats` | no-claim diagnostic gate/tests/artifact | `EVIDENCE_GAP` when sentinels or incomplete panels remain |
| P20-04 | `bsebench-async-codex` | opening docs, integration, closure report | exact integrated verdict and repo cleanliness |

## Acceptance Criteria

- The Phase 20 artifacts must identify the same `48` sentinel cells from Phase 19.
- Any root-cause category must be evidence-backed or explicitly marked as a hypothesis.
- The stats gate must fail closed while sentinels remain.
- The final report must distinguish data readiness, execution feasibility, estimator stability, and statistical claim readiness.
- No public claim wording is allowed.

## Current Working Hypotheses

These are not conclusions:

- DUKF is nearly globally unstable on this narrow panel.
- ICRPF may have domain/profile sensitivity beyond a pure data-readiness issue.
- Multiple classical filters have a shared low-temperature failure mode.
- DST at low temperature may be the strongest stressor.
- SO_SMO appears mechanically robust on Phase 19, but this does not imply a scientific ranking.

