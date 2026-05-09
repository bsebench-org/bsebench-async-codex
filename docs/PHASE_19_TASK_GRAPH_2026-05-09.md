# Phase 19 Task Graph - Narrow Execution and Metric Evidence

Generated: 2026-05-09 23:28 CEST / 2026-05-09 21:28 UTC

## Invariant

```text
NO_CLAIM until finite metrics, complete panels, computed profile-axis
preflights, and wording authorization all pass.
```

## Dependency Flow

```text
Phase 18 ready subset
        |
        v
datasets crosswalk/cache provenance
        |
        v
runner exact 16-row execution
        |
        v
finite metric rows + explicit sentinel cells
        |
        v
stats metric evidence gate
        |
        v
profile-axis variance / Friedman preflight if sufficient
        |
        v
Phase 19 closure classification
```

## Parallel Work

| Task | Owner Repo | Write Scope | Acceptance |
| --- | --- | --- | --- |
| P19-01 | `bsebench-runner` | Phase 19 execution helper/tests/artifact | real execution where possible, fail-closed cells, no fake metrics |
| P19-02 | `bsebench-stats` | Phase 19 metric consumer/tests/artifact | finite metric rows only, no claim promotion |
| P19-03 | `bsebench-datasets` | Phase 19 crosswalk/provenance helper/tests/artifact | every runner row mapped to ready dataset evidence or blocked |
| P19-04 | `bsebench-async-codex` | audit docs and closure report | final integrated verdict and repo cleanliness |

## Non-Negotiable Evidence Rules

- `10000.0` divergence sentinel is not finite success evidence.
- A failed filter/config cell must remain visible in the artifact.
- Profile-axis variance/Friedman preflight may only run on finite, comparable
  metric rows with enough repeated groups.
- Missing rows, incomplete panels, mixed units, or non-current provenance force
  `EVIDENCE_GAP`.
- A public claim is forbidden in Phase 19 even if mechanical preflights improve.

## Completion Rule

Phase 19 closes when all touched repos have:

- generated Phase 19 artifacts or explicit fail-closed reports;
- focused tests passing;
- ruff / format / diff-check passing;
- pushed commits on `main`;
- final async closure report with exact classification.

