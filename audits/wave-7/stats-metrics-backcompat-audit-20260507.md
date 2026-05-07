# GLASSBOX Stats Metrics Backcompat Audit

- Worker: W7-j
- Wave: 7 alpha-readiness, gate implementation, and independent integration audit
- Created: 2026-05-07
- Branch: `phase-8-6-j-stats-metrics-backcompat-audit-20260507T214305Z`
- Owned write-set: `audits/wave-7/stats-metrics-backcompat-audit-20260507.md`
- Source repo inspected read-only: `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- Stats integration branch inspected:
  `phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z`
- Inspected integration head:
  `08d7c2cef00a1830ac908310535e2320c41d2276`

## Objective

Audit the Wave 1 stats integration surface for metric API compatibility,
ranking ambiguity, and compute-cost evidence gaps before alpha promotion. This
artifact is a sidecar audit only. It does not edit stats source, runner source,
datasets source, thesis files, manuscript files, claim registry files,
`claims/registry.yaml`, `claim_55`, or the scientific roadmap.

## Evidence Inspected

| Evidence | Result |
| --- | --- |
| Stats integration worktree status | Clean, tracking `origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` at `08d7c2c`. |
| Integration diff | Adds `metric_matrix.py`, `convergence.py`, `robustness_noise_schema.py`, `compute_cost.py`, `multi_axis_ranking.py`, `transfer_matrix.py`, matching tests, and additive `src/bsebench_stats/__init__.py` exports. |
| Export surface | Top-level package exports all six Wave 1 helper groups and schema constants. |
| Prior Wave 4 metrics acceptance matrix | Requires explicit metric family/unit, public macro comparison-unit aggregation, visible failed rows, compute evidence tiers, and report caveats. |
| Prior Wave 4 compute evidence tier spec | Requires compute tier, measurement scope, hardware/environment identity, backend stratification, repeat policy, and caveats before compute comparison. |
| Prior Wave 5 stats validator | Reported pushed head `08d7c2c`, focused Wave 1 stats tests `52 passed`, top-level export check passed, scoped Ruff checks passed, and stats `git diff --check` passed. |
| Prior Wave 6 stats red-team | Flagged schema dispatch, aggregation ambiguity, compute stratification, ranking misuse, and missing cross-module gates. |
| Cross-repo API contract ledger | Records C08 stats contracts plus mismatches M05, M06, and M07 around sample-pooled metrics, sentinel policy, and compute evidence metadata. |

## Commands Run

```bash
git status --short --branch
git branch --all --verbose --no-abbrev | rg -i 'stats|metric|wave|phase|runner|dataset|async'
find /mnt/c/doctorat/bsebench-org -maxdepth 2 -type d \( -name '*stats*' -o -name '*runner*' -o -name '*datasets*' -o -name '*bsebench*' \) | sort
git show phase-8-3-p-metrics-acceptance-matrix-20260507T204627Z:audits/universal/metrics-acceptance-matrix-20260507T204627Z.md
git show phase-8-3-q-compute-evidence-tier-spec-20260507T204627Z:specs/universal/compute-evidence-tier-spec-20260507T204627Z.md
git show phase-8-4-f-stats-integration-validator-20260507T213125Z:validation/wave-5/stats-integration-validator-20260507T213125Z.md
git show phase-8-5-b-stats-integration-redteam-20260507T213656Z:redteam/wave5/stats-integration-redteam-20260507T213656Z.md
git show phase-8-4-o-cross-repo-api-contract-ledger-20260507T213125Z:ledgers/contracts/cross-repo-api-contract-ledger-20260507T213125Z.md
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z status --short --branch
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z rev-parse HEAD
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z log --oneline --decorate --max-count=5
rg -n 'SCHEMA_VERSION|schema_version|aggregate|pooled|sample|macro|unit|rmse|mae|maxe|ranking|rank|weighted|compute_evidence|evidence_tier|runtime|wall_time|hardware|measurement_scope|tracemalloc' src/bsebench_stats tests
sed -n '1,260p' src/bsebench_stats/__init__.py
sed -n '1,300p' src/bsebench_stats/metric_matrix.py
sed -n '1,340p' src/bsebench_stats/multi_axis_ranking.py
sed -n '1,340p' src/bsebench_stats/compute_cost.py
sed -n '1,240p' tests/test_compute_cost.py
sed -n '1,260p' tests/test_metric_matrix.py
sed -n '1,320p' tests/test_multi_axis_ranking.py
sed -n '1,300p' src/bsebench_stats/convergence.py
sed -n '1,260p' src/bsebench_stats/transfer_matrix.py
sed -n '1,260p' tests/test_convergence.py
sed -n '1,280p' tests/test_transfer_matrix.py
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats diff --check origin/main..origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats grep -n -E '<<<<<<<|=======|>>>>>>>' origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z -- src tests
git diff --check
```

The conflict-marker grep exited 1 with no matches. That is the expected
no-match result for this check.

## API Compatibility Findings

| ID | Finding | Severity | Evidence | Gate |
| --- | --- | --- | --- | --- |
| API-1 | Top-level additive exports are compatible with the observed Wave 1 helper surface. | PASS | `__init__.py` exports metric matrix, convergence, robustness, compute, ranking, and transfer helpers. | Keep a top-level export regression test for all public Wave 1 helpers. |
| API-2 | Schema strings are unique for the new helper families, but not every report has a common public report envelope. | AMBER | New schema constants include `metric_matrix_v1`, `convergence_recovery_metrics_v1`, `robustness_noise_report_v1`, `compute_cost_aggregate_v1`, `multi_axis_ranking_report_v1`, and transfer schemas. | Add a registry test for `(report_type, schema_version)` and a report adapter that injects `report_type`, `metric_family`, `unit`, split role, and evidence status. |
| API-3 | Metric matrix inputs accept `errors`, `error`, or `residual_mV`, but the report does not bind target signal or unit. | AMBER | `metric_matrix.py` computes generic error arrays and exposes labels only as cell/profile/filter axes. | Runner-to-stats payload must bind `target_signal`, `metric_family`, `unit`, warmup/mask policy, split ID, and comparison unit ID. |
| API-4 | Failed/non-ok metric cells are rejected instead of retained as explicit failed result rows. | AMBER | `_raw_error_values` requires `status == 'ok'`; tests expect non-ok status to raise. | Public reporting needs visible `failed`, `missing`, `invalid`, `diverged`, or `excluded` rows instead of silent omission or hard process failure. |
| API-5 | Convergence helper is trace-level only and lacks degraded-initialization protocol identity. | AMBER | `compute_convergence_recovery_metrics` returns threshold and timing fields but no `protocol_id`, low/high wrong-start `case_id`, dataset, or split identity. | Report adapter must preserve `forced_wrong_initial_soc_v1` and distinct case rows before aggregation. |

## Metric Aggregation Findings

| ID | Finding | Severity | Evidence | Gate |
| --- | --- | --- | --- | --- |
| MET-1 | RMSE, MAE, and MAXE are computed over finite 1D arrays and complete declared grids. | PASS | `compute_error_metrics`, `build_metric_matrix_report`, and `tests/test_metric_matrix.py`. | Keep finite/non-empty/grid-complete tests. |
| MET-2 | Public aggregate ambiguity remains because the implemented aggregate is sample-pooled. | BLOCKER for public metric tables | `_aggregation_schema` states RMSE/MAE are pooled over raw sums weighted by sample count; tests assert pooled sample sums. | Add macro comparison-unit aggregation and label pooled values as secondary diagnostics. |
| MET-3 | SOC/SOH percentage-point semantics are not represented in the stats API. | BLOCKER for SOC/SOH public scoring | Metric helper works on raw numeric errors; no conversion or validation of fraction-to-percentage-point units is present. | Require unit-normalized state errors before metric ingestion or add explicit conversion metadata and tests. |
| MET-4 | Legacy voltage diagnostic compatibility is not enough for SOC/SOH reporting. | AMBER | The helper accepts `residual_mV`, while cross-repo ledger M06 warns against copying sentinel-style voltage behavior to state metrics. | Limit sentinel-style handling to legacy voltage diagnostics; state metrics need structured status rows. |

## Ranking Ambiguity Findings

| ID | Finding | Severity | Evidence | Gate |
| --- | --- | --- | --- | --- |
| RANK-1 | Ranking helper correctly marks output as mechanical and relative to the supplied panel. | PASS | `mechanical_evidence_only: True`, `scientific_verdict: none`, and `comparison_scope: relative_to_supplied_panel`. | Preserve these fields in any report adapter. |
| RANK-2 | Weighted axis ranks are easy to misuse because arbitrary axes and weights can invert order. | BLOCKER for public ranked summaries | `build_multi_axis_ranking_report` computes `weighted_mean_axis_rank` from supplied axes; tests include SOC RMSE, stress coverage, and runtime weights. | Require an explicit ranking-policy record, source ledger status, uncertainty caveat, and public wording review before any sorted public summary. |
| RANK-3 | Ranking does not require uncertainty, statistical testing, or macro/pooled distinction. | AMBER | Default caveats state these are out of scope unless supplied separately. | Public report code must block ranking when required uncertainty, aggregation policy, or source-ledger fields are absent. |

## Compute-Cost Evidence Findings

| ID | Finding | Severity | Evidence | Gate |
| --- | --- | --- | --- | --- |
| COMP-1 | Runtime is required and optional memory/cost/FLOP coverage is explicit. | PASS | `aggregate_compute_costs` requires a positive runtime alias and returns coverage for optional fields. | Keep required-runtime and negative-field tests. |
| COMP-2 | Evidence-tier metadata is absent from the integrated compute aggregate. | BLOCKER for compute comparison | `compute_cost.py` has no `compute_evidence_tier`, `measurement_scope`, `hardware_profile_id`, environment, timer backend, memory backend, or repeat policy fields. | Add C0-C5 tier metadata and stratified grouping before sorting or comparing compute rows. |
| COMP-3 | Runtime aliases can mask incompatible scopes. | AMBER | `_RUNTIME_FIELDS` accepts `runtime_seconds`, `wall_time_seconds`, `elapsed_seconds`, and nested profiles, but the selected alias is only recorded as source field. | Reject conflicting aliases or emit explicit precedence and scope metadata. |
| COMP-4 | Memory aliases can mix incompatible backends. | AMBER | `_MEMORY_FIELDS` accepts generic `memory_peak_mb`, `peak_rss_mb`, and other aliases without backend identity. | Require backend-specific fields such as Python allocation telemetry versus process RSS, and group only compatible backends. |
| COMP-5 | Runner profiling raw units are not fully bridged to stats aggregate. | AMBER | Cross-repo ledger C07 records runner raw wall-clock nanoseconds and Python allocation telemetry; stats aggregate expects seconds/MB aliases. | Add explicit raw-to-aggregate conversion tests using runner profiling output. |

## Transfer And Generalization Notes

The transfer helper is compatible as a mechanical source x target matrix, but
its default axes are only `chemistry`, `profile`, and `domain`. Universal
monthly reports still need first-class temperature, aging/SOH bin, dataset, and
equipment-family axes where the dataset supports them. Missing transfer cells
are encoded as JSON null metrics and zero counts, which is suitable for
inspection, but public summaries must not hide those null cells behind one
aggregate number.

## Required Alpha Gates

1. Run the focused Wave 1 stats suite and non-slow stats suite on the pinned
   integration head before promotion; prior artifacts record this as passed,
   but the alpha gate should pin the exact SHA again.
2. Add a cross-module schema registry test for all public stats payloads.
3. Add metric report adapter tests requiring `metric_family`, `target_signal`,
   `unit`, `comparison_unit_id`, split identity, and failed-row policy.
4. Add macro comparison-unit aggregates for metric matrix reports and a fixture
   where sample-pooled and macro ordering disagree.
5. Add compute evidence-tier fields, measurement scope, hardware/environment
   identity, backend identity, and repeat policy before any compute comparison.
6. Add runner-profiling-to-stats compute conversion tests for nanoseconds and
   byte telemetry.
7. Add a public wording gate for sorted summaries, external comparison text,
   and any claim-like interpretation of mechanical ranks.

## Blockers

- Public SOC/SOH metric tables are blocked until state target signals, units,
  comparison units, split identity, macro aggregation, and explicit failed rows
  are present.
- Public sorted multi-axis summaries are blocked until ranking policy,
  source-ledger status, uncertainty caveats, and wording checks are enforced.
- Public compute comparisons are blocked until C0-C5 evidence tiers,
  measurement scope, backend, hardware/software identity, repeat policy, and
  stratified aggregation are present.
- Transfer/generalization summaries are blocked for full universal reporting
  until temperature, aging/SOH bin, dataset, and equipment axes are represented
  or explicitly marked unavailable.

## Non-Claims

- This audit does not validate any SOC/SOH score, estimator ordering, external
  comparison, public benchmark result, or scientific conclusion.
- This audit does not assert that the stats integration branch is merged into a
  release branch or ready for public reporting.
- This audit does not evaluate method quality or make comparative performance
  claims.

## Validation

| Command | Status | Notes |
| --- | --- | --- |
| Read-only stats integration inspection | PASS | Inspected source, tests, export surface, and pushed head `08d7c2c`. |
| Stats integration `git diff --check` | PASS | No whitespace errors for `origin/main..origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z`. |
| Stats integration conflict-marker grep | PASS | No matches under `src` or `tests`; command exited 1 as expected for no matches. |
| Report repo `git diff --check` | PASS | No whitespace errors after artifact creation. |
