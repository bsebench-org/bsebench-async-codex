# Phase 17 Task Graph - Claim 60 Evidence Bundle

Generated: 2026-05-09 21:41 CEST

## Operating Mode

Phase 17 is a focused evidence-bundle construction phase for:

```text
Profile-axis stress / claim_60
```

Global invariant:

```text
NO_GO_CLAIM
```

## Parallel Wave

| Task | Repo | Ownership boundary | Output | Status |
| --- | --- | --- | --- | --- |
| P17-01 | `bsebench-datasets` | source/provenance helper and focused tests only | profile-axis source bundle gate | launched |
| P17-02 | `bsebench-runner` | replay/evidence bundle helper and focused tests only | profile-axis replay bundle validator | launched |
| P17-03 | `bsebench-stats` | stats/claim-readiness helper and focused tests only | claim_60 adversarial classifier | launched |
| P17-04 | `bsebench-async-codex` | docs and closure only | opening audit, task graph, final report | in progress |

The tasks are split across repos to avoid write conflicts. No worker should
edit another repo.

## Dependency Flow

```text
datasets source/provenance gate
        |
        v
runner replay/evidence bundle validator
        |
        v
stats claim_60 adversarial gate
        |
        v
async-codex closure report
```

The implementation can be validated with synthetic or fixture payloads as long
as the report clearly states that this is gate validation, not empirical claim
proof.

## Acceptance Criteria

Each code task must satisfy:

- fail-closed default;
- finite JSON-ready report;
- no private data fetch;
- no Hugging Face upload;
- no public scientific claim wording;
- focused tests passing;
- `ruff` passing for touched Python files;
- `git diff --check` passing.

## Final Classification Rule

At closure, `claim_60` must be exactly one of:

- `CLAIM_READY`
- `MECHANICAL_ONLY`
- `EVIDENCE_GAP`
- `AUTH_OR_DATA_BLOCKED`
- `RETRACT_OR_SCOPE`

Default if any uncertainty remains:

```text
EVIDENCE_GAP
```

## Current Expectation

The likely rigorous outcome is not `CLAIM_READY`. It is a stronger,
machine-checkable path from Phase 9 mechanical smoke to Phase 16 claim
readiness, with blockers made explicit.

