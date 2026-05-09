# Phase 18 Task Graph - Narrow Profile-Axis Bundle

Generated: 2026-05-09 23:00 CEST

## Invariant

```text
NO_GO_CLAIM
```

## Dependency Flow

```text
datasets ready-subset selector
        |
        v
runner ready-row-only plan validator
        |
        v
stats metric availability gate
        |
        v
async-codex closure classification
```

## Parallel Tasks

| Task | Repo | Write scope | Acceptance |
| --- | --- | --- | --- |
| P18-01 | `bsebench-datasets` | Phase 18 source-ready subset helper/tests | focused tests, ruff, diff-check |
| P18-02 | `bsebench-runner` | Phase 18 ready plan helper/tests | focused tests, ruff, diff-check |
| P18-03 | `bsebench-stats` | Phase 18 metric evidence helper/tests | focused tests, ruff, diff-check |
| P18-04 | `bsebench-async-codex` | docs and closure report | diff-check, final repo audit |

## Final Classification Rule

The final `claim_60` state must be exactly one of:

- `CLAIM_READY`
- `MECHANICAL_ONLY`
- `EVIDENCE_GAP`
- `AUTH_OR_DATA_BLOCKED`
- `RETRACT_OR_SCOPE`

Default:

```text
EVIDENCE_GAP
```

`CLAIM_READY` is forbidden unless current-head source evidence, ready plan,
metric rows, stats audit, replay manifest, hashes, and Phase 16 wording
authorization are all complete.

