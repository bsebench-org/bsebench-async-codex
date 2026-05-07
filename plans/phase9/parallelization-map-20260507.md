# Phase 9 Parallelization Map - 2026-05-07

Owner: W9-k
Scope: report-only implementation map for the next profile-axis wave after
Phase 8 integration.

This plan is a dispatch artifact, not a scientific result. It makes no
external-performance, public ranking, publication-readiness, or claim-verdict
statement.

## Planning Inputs

- Universal benchmark charter:
  `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
- Parallel wave charter:
  `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`
- Research gate protocol:
  `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`
- Phase 8 validation reports inspected read-only from local branch refs:
  W8-a async docs, W8-b datasets, W8-c stats/datasets cross-validation,
  W8-e merge-candidate matrix, and W8-f alpha missing-artifacts tasklist.

## Current Evidence Snapshot

The following evidence is useful for planning but is not treated as final
post-merge truth:

| Area | Current evidence | Planning implication |
| --- | --- | --- |
| Runner Phase 8 integration | W8-e records pushed runner integration head `e0664de` as mechanically clean and a code merge candidate with replay requirement. | Phase 9 runner tasks may be prepared, but empirical execution waits for exact post-merge runner replay. |
| Stats Phase 8 integration | W8-c records pushed stats integration head `08d7c2c`, fast-forward ancestry, clean diff, and no source/test conflict markers. W8-e still requires fresh independent replay before final GO evidence. | Stats profile-axis contracts can be split now; final execution waits for clean post-merge stats validation. |
| Datasets Phase 8 integration | W8-b records pushed datasets integration head `6cbdc54`, clean diff, and focused tests passing with ephemeral `uv --with` tools. Bare `uv run ruff` and `uv run pytest` were blocked by missing default tools. | Datasets profile metadata tasks must include dependency-tool checks and mark bare-tool gaps separately from code failures. |
| Async/docs Phase 8 integration | W8-a records current pushed async docs head `52a7b14` and clean shell gates, but the broad BRIEF gate still fails on 16 legacy backlog briefs. | Async Phase 9 dispatch must not depend on the broad gate being green until the legacy backlog issue is remediated or scoped. |
| Alpha readiness | W8-e and W8-f carry release, source-ledger, license, frozen-artifact, public-text, and post-merge validation blockers. | Phase 9 must remain evidence-generation and infrastructure only; no release or public-report conclusion is authorized. |
| Phase 9 BRIEF gate scope | Current `scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-9-parallelization-map-20260507/BRIEF.md` skipped this BRIEF because the checker scope is Phase 7/8/11. | Phase 9 dispatch needs an async gate-scope update or an explicit operator waiver before relying on Phase 9 backlog checks. |

Unknowns:

- Whether Phase 8 integration branches have been merged into their source
  repository `main` refs after the W8 reports.
- Whether unpushed W7 sidecars have since been pushed or superseded.
- Whether local profile metadata is complete enough to enumerate all Phase 9
  profile rows without new dataset adapter work.

## Stop Rules

Stop or mark blocked if any of these occur:

- A task needs edits to thesis, manuscript, claim registry, `claims/registry.yaml`,
  `claim_55`, or the scientific roadmap.
- A task would write outside its declared owned write-set.
- A profile row lacks dataset identity, chemistry or explicit unknown marker,
  profile/protocol, split/run condition, metric unit, provenance source, or
  comparability caveat.
- A worker tries to convert mechanical profile-axis evidence into a claim
  verdict or public benchmark conclusion.
- A Phase 8 post-merge replay changes an API contract used by this map.

## Wave Order

Wave 9.0 is report/control-plane readiness and may run before code execution.
Wave 9.1 prepares disjoint source-repo contracts. Wave 9.2 wires those contracts
together after Wave 9.1 branches are merged or rebased onto a common source
head. Wave 9.3 is dry-run orchestration only. Empirical profile-axis execution
is outside this map until all required provenance and comparability gates pass.

## Wave 9.0 - Control Plane

| ID | Target repo | Branch | Owned write-set | Dependency | Falsification gate | Validation |
| --- | --- | --- | --- | --- | --- | --- |
| A0.1 Phase 8 exact-head replay ledger | `bsebench-async-codex-cto-report` | `phase-9-0-a-phase8-exact-head-replay-ledger` | `validation/phase9/phase8-exact-head-replay-ledger-20260507.md` only | W8 reports | If any cited source ref is absent, moved, or not replayed at exact SHA, mark unknown or blocked. | `git diff --check` |
| A0.2 Phase 9 dispatch ledger | `bsebench-async-codex-cto-report` | `phase-9-0-b-dispatch-ledger` | `plans/phase9/dispatch-ledger-20260507.md` only | This map | If any same-wave task has overlapping files or an unpinned target branch, the ledger fails. | `git diff --check` |
| A0.3 Phase 9 BRIEF gate scope | `bsebench-async-codex-cto-report` | `phase-9-0-c-phase9-brief-gate-scope` | `scripts/check-research-brief-gates.sh`; `tests/check-research-brief-gates.sh` or nearest existing shell-test path | This map | The gate fails if `phase-9-*` BRIEFs are skipped or if legacy Phase 7 failures are reported as remediated without evidence. | `bash -n scripts/check-research-brief-gates.sh`; focused shell test proving Phase 9 BRIEFs are checked; `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-9-*/BRIEF.md`; `git diff --check` |

## Wave 9.1 - Disjoint Source Contracts

These tasks are parallelizable because their owned source files do not overlap.

### Runner

| ID | Branch | Owned write-set | Goal | Falsification gate | Validation |
| --- | --- | --- | --- | --- | --- |
| R1 profile config inventory | `phase-9-1-a-runner-profile-config-inventory` | `src/bsebench_runner/profile_config_inventory.py`; `tests/test_profile_config_inventory.py` | Add a dry-run JSON inventory for candidate dataset/config/profile/filter rows without running filters. | Unknown loader, filter, split, or profile metadata must produce explicit `unknown` or `not_ready`, not inferred readiness. | Focused pytest for ready/unknown/not-ready rows; `uv run --locked --all-extras pytest tests/ -m "not slow" -q`; `uv run --locked --all-extras ruff check .`; `uv run --locked --all-extras ruff format --check .`; `git diff --check` |
| R2 profile protocol skeleton | `phase-9-1-b-runner-profile-protocol-skeleton` | `src/bsebench_runner/profile_axis_protocol.py`; `tests/test_profile_axis_protocol.py` | Define profile-axis protocol objects separating estimator, dataset row, initialization policy, split, metric request, and artifact identity. | Protocol construction fails if calibration and evaluation roles are indistinguishable. | Focused protocol tests; non-slow pytest; ruff; format check; `git diff --check` |
| R3 degraded-initialization profile fixtures | `phase-9-1-c-runner-profile-degraded-init-fixtures` | `src/bsebench_runner/profile_degraded_initialization.py`; `tests/test_profile_degraded_initialization.py` | Add reusable wrong-initial-SOC fixtures for profile-axis dry runs. | Fixture must reject missing true-initial reference or undocumented override policy. | Focused fixture tests; non-slow pytest; ruff; format check; `git diff --check` |
| R4 profile artifact manifest schema | `phase-9-1-d-runner-profile-artifact-manifest` | `src/bsebench_runner/profile_artifact_manifest.py`; `tests/test_profile_artifact_manifest.py` | Define hashable output-manifest schema for later profile-axis runs. | Manifest fails if source commit, config identity, dataset row, split, or validation command is missing. | Focused schema tests; non-slow pytest; ruff; format check; `git diff --check` |

### Stats

| ID | Branch | Owned write-set | Goal | Falsification gate | Validation |
| --- | --- | --- | --- | --- | --- |
| S1 profile metric row schema | `phase-9-1-e-stats-profile-metric-row-schema` | `src/bsebench_stats/profile_metric_rows.py`; `tests/test_profile_metric_rows.py` | Add finite JSON-safe rows for RMSE, MAE, MAXE, convergence, and compute-cost references by profile. | Missing unit, sample count, aggregation rule, or profile identifier fails loud. | Focused schema tests; non-slow pytest; ruff; format check; `git diff --check` |
| S2 profile variance test fixtures | `phase-9-1-f-stats-profile-variance-fixtures` | `src/bsebench_stats/profile_variance.py`; `tests/test_profile_variance.py` | Add synthetic Friedman-style profile-axis variance fixtures over mechanical input rows. | Test refuses unequal or missing profile blocks unless an explicit missingness policy is supplied. | Focused synthetic tests; non-slow pytest; ruff; format check; `git diff --check` |
| S3 profile PCRLB/MAD aggregation | `phase-9-1-g-stats-profile-floor-aggregation` | `src/bsebench_stats/profile_floor_aggregation.py`; `tests/test_profile_floor_aggregation.py` | Aggregate PCRLB/MAD-style floor inputs by profile with caveats and uncertainty fields. | Non-finite, dimensionally inconsistent, or source-unknown inputs fail or become `not_comparable`. | Focused valid/non-finite/unit-gap tests; non-slow pytest; ruff; format check; `git diff --check` |
| S4 profile sensitivity report | `phase-9-1-h-stats-profile-sensitivity-report` | `src/bsebench_stats/profile_sensitivity_report.py`; `tests/test_profile_sensitivity_report.py` | Report whether profile-axis mechanical status changes under leave-one-profile-out or weighting choices. | If status changes under a reasonable sensitivity grid, output must mark threshold/weight dependence. | Focused stable/dependent/invalid tests; non-slow pytest; ruff; format check; `git diff --check` |

### Datasets

| ID | Branch | Owned write-set | Goal | Falsification gate | Validation |
| --- | --- | --- | --- | --- | --- |
| D1 profile taxonomy contract | `phase-9-1-i-datasets-profile-taxonomy-contract` | `src/bsebench_datasets/profile_taxonomy.py`; `tests/test_profile_taxonomy.py` | Define canonical profile labels and alias handling for DST, FUDS, US06, WLTC, BCDC, OCV-pulse, and unknown. | Alias mapping cannot infer chemistry, split, or equipment from filenames alone. | Focused alias/unknown tests; non-slow pytest; ruff; format check; `git diff --check` |
| D2 profile availability snapshot | `phase-9-1-j-datasets-profile-availability-snapshot` | `src/bsebench_datasets/profile_availability.py`; `tests/test_profile_availability.py` | Produce read-only profile availability rows with cache, provenance, and metadata status. | Missing local assets, unreadable assets, and unknown metadata must be distinct states. | Focused ready/missing/unreadable/unknown tests; one read-only local command; non-slow pytest; ruff; format check; `git diff --check` |
| D3 profile split metadata audit | `phase-9-1-k-datasets-profile-split-audit` | `src/bsebench_datasets/profile_split_audit.py`; `tests/test_profile_split_audit.py` | Audit calibration/evaluation split metadata for profile-axis candidates. | Any row with ambiguous calibration, tuning, or evaluation role is `not_ready`. | Focused split-role tests; non-slow pytest; ruff; format check; `git diff --check` |
| D4 profile provenance gap report | `phase-9-1-l-datasets-profile-provenance-gaps` | `src/bsebench_datasets/profile_provenance_gaps.py`; `tests/test_profile_provenance_gaps.py` | Report equipment, units, cadence, temperature, aging/SOH, and source gaps for candidate profile rows. | Unknown units, cadence, temperature, or source identity must remain a gap. | Focused gap tests; one read-only command; non-slow pytest; ruff; format check; `git diff --check` |

## Wave 9.2 - Integration Glue After Wave 9.1

These tasks should wait until the matching Wave 9.1 source contracts are merged
or rebased onto a shared integration base.

| ID | Target repo | Branch | Owned write-set | Depends on | Falsification gate | Validation |
| --- | --- | --- | --- | --- | --- | --- |
| R5 profile dry-run manifest builder | `bsebench-runner` | `phase-9-2-a-runner-profile-dryrun-manifest-builder` | `src/bsebench_runner/profile_dryrun_manifest.py`; `tests/test_profile_dryrun_manifest.py` | R1, R2, D1, D2, D3 | If any dataset row cannot be linked to profile taxonomy, split metadata, estimator contract, and artifact manifest identity, mark `not_ready`. | Focused dry-run tests; real dry-run over current candidate metadata; non-slow pytest; ruff; format check; `git diff --check` |
| S5 profile report assembler | `bsebench-stats` | `phase-9-2-b-stats-profile-report-assembler` | `src/bsebench_stats/profile_report_assembler.py`; `tests/test_profile_report_assembler.py` | S1, S2, S3, S4, R4 | If rows from different splits, units, or provenance tiers are combined without caveats, fail. | Focused assembly tests; non-slow pytest; ruff; format check; `git diff --check` |
| D5 profile candidate export | `bsebench-datasets` | `phase-9-2-c-datasets-profile-candidate-export` | `src/bsebench_datasets/profile_candidate_export.py`; `tests/test_profile_candidate_export.py` | D1, D2, D3, D4 | Export refuses rows missing profile label, provenance status, or split role. | Focused export tests; read-only export command; non-slow pytest; ruff; format check; `git diff --check` |
| A2.1 Phase 9 contract ledger | `bsebench-async-codex-cto-report` | `phase-9-2-d-profile-contract-ledger` | `ledgers/phase9/profile-axis-contract-ledger-20260507.md` only | R1-R4, S1-S4, D1-D4 | If any code contract is cited without exact commit SHA, branch, and validation status, mark unknown. | `git diff --check` |

## Wave 9.3 - Dry-Run Orchestration Only

| ID | Target repo | Branch | Owned write-set | Depends on | Falsification gate | Validation |
| --- | --- | --- | --- | --- | --- | --- |
| R6 profile-axis dry-run CLI | `bsebench-runner` | `phase-9-3-a-runner-profile-axis-dryrun-cli` | `src/bsebench_runner/profile_axis_cli.py`; `tests/test_profile_axis_cli.py` | R5, D5 | CLI must not run filters; it only emits deterministic dry-run manifests and readiness states. | Focused CLI tests; real dry-run command; non-slow pytest; ruff; format check; `git diff --check` |
| S6 profile-axis dry-run report CLI | `bsebench-stats` | `phase-9-3-b-stats-profile-axis-dryrun-report-cli` | `src/bsebench_stats/profile_axis_cli.py`; `tests/test_profile_axis_cli.py` | S5, R6 manifest sample | CLI must refuse incomplete manifests and must not emit conclusions over placeholder data. | Focused CLI tests; dry-run report command over fixture; non-slow pytest; ruff; format check; `git diff --check` |
| A3.1 Phase 9 dispatch BRIEF pack | `bsebench-async-codex-cto-report` | `phase-9-3-c-phase9-dispatch-brief-pack` | `cto/AUTONOMY_BACKLOG/phase-9-*/BRIEF.md`; no source repo files | This map and A2.1 | Every BRIEF must pass research gates and must preserve disjoint write-set declarations. | `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-9-*/BRIEF.md`; `git diff --check` |

## Merge Rules

- Merge source-repo Wave 9.1 tasks only after exact-branch focused tests and
  whitespace gates pass.
- Do not merge Wave 9.2 glue until its dependency branches are in a common
  integration base or the worker records a clean rebase and rerun.
- Merge report-only ledgers only as blocker/support evidence unless they cite
  exact source commits and validation commands.
- Treat W8 report evidence as planning context until the relevant branch is
  merged or a post-merge replay ledger supersedes it.

## Blockers Carried Into Dispatch

1. Phase 8 integration is not known merged from this worktree.
2. Async docs broad BRIEF gate failure remains current in W8-a unless a newer
   scoped or fixed gate report supersedes it.
3. Current research-BRIEF gate scope skips `phase-9-*` backlog paths, so Phase
   9 dispatch needs A0.3 or an explicit operator decision before relying on the
   checker.
4. Datasets default `uv run` tool availability is a dependency gap; future
   workers must distinguish missing developer tools from implementation failure.
5. Alpha/public artifacts, source-ledger closure, license/cache evidence, frozen
   manifests, and public text review remain outside Phase 9 code execution and
   cannot be inferred from this plan.

## Validation For This Artifact

Required local validation:

```bash
git diff --check
```
