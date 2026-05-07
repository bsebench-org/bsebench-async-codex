# BSEBench Universal 48h Backlog

Generated: 2026-05-07T19:37:45Z
Worker: BACKLOG
Scope: `backlog/48h/universal-backlog-20260507T193050Z.md`

## GLASSBOX Snapshot

### Objective

Build a 48-hour autonomous useful-work backlog for the BSEBench universal
benchmark direction. The backlog favors disjoint write sets, falsifiable
validation, and validation agents that wait for active workers before judging
unfinished branches.

### Current Wave State

Evidence inspected from local docs, branch logs under
`/home/oakir/.local/state/bsebench-async-watchdog`, visible worktrees under
`/mnt/c/doctorat/bsebench-org`, and remote branch heads.

- Wave 1 runner branches `phase-8-0-a` through `phase-8-0-f` have active worker
  processes and watchdog logs showing implementation or focused validation.
  Remote `phase-8-0-*` heads were not visible in `bsebench-runner` at the
  snapshot.
- Wave 1 stats branches `phase-8-0-g` through `phase-8-0-l` have active worker
  processes and watchdog logs showing implementation or focused validation.
  Remote `phase-8-0-*` heads were not visible in `bsebench-stats` at the
  snapshot.
- Wave 1 datasets branches `phase-8-0-m` through `phase-8-0-r` have active
  worker processes and watchdog logs showing implementation or focused
  validation. Remote `phase-8-0-*` heads were not visible in
  `bsebench-datasets` at the snapshot.
- Wave 1 async branches `phase-8-0-s` through `phase-8-0-x` have remote heads:
  `8b8110b` submission intake, `669a4ea` monthly snapshot schema, `9ee3b55`
  charter gate, `cbd60b3` disjoint wave planner, `1a337a6` public release
  checklist, and `ce60824` no-idle capacity policy.
- Wave 2 validator and audit branches `phase-8-1-k` through `phase-8-1-u` are
  present as separate worktrees. Watchdog process inspection showed active
  validator/audit workers for runner, stats, datasets, async, integration,
  API-gap, source-ledger, monthly workflow, Phase 17 delivery, CI budget, and
  public-release risk tasks.
- This BACKLOG branch is separate from those worktrees and owns only this file.

### Guardrails For Every Candidate

- No thesis, manuscript, claim registry, `claims/registry.yaml`, `claim_55`, or
  scientific roadmap edits.
- No unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim
  statements. Any comparison task must first produce a source ledger with
  stable URL or DOI, retrieval date, exact metric, dataset, split, BSEBench
  frozen value, and comparability caveat.
- Validators must inspect assigned watchdog logs first. If the assigned worker
  is still running, they must wait and re-check instead of declaring failure.
- Every worker must commit with GLASSBOX metadata and no `Co-Authored-By Claude`.
- Every task must preserve the universal benchmark objective: plug-and-play
  estimators, comparable metrics, leakage safety, provenance, and monthly
  benchmark readiness.

## Validation Agent Pool

| Agent | Scope | Required behavior |
| --- | --- | --- |
| `VAL-RUN` | Runner branches and runner-facing contracts. | Validate committed branch heads only. If no remote head exists and watchdog shows active worker processes, record `pending_active_worker` and re-check later. |
| `VAL-STATS` | Stats branches and metric/report contracts. | Run focused tests from fetched branches, inspect schema failure modes, and reject reports that coerce missing or invalid evidence into numeric cells. |
| `VAL-DATA` | Dataset schema, provenance, split, and availability branches. | Validate read-only provenance behavior, schema rejection cases, and absence of machine-local paths in committed evidence. |
| `VAL-ASYNC` | Async policy, templates, BRIEF gates, source ledgers, and release docs. | Run shell tests and lints where available, and scan for unsupported claim language. |
| `VAL-INTEG` | Cross-repo integration after branches are pushed. | Build conflict maps from remote heads and validate from fetched branches or read-only worktrees. |
| `VAL-LEDGER` | Source-ledger and comparison safety. | Reject comparison wording without the complete source ledger fields listed above. |

## 48h Candidate Queue

Each row has a single owned write set. Dependencies are branch-level gates, not
permission to edit those branches.

| ID | Lane | Target repo | Owned write set | Useful deliverable | Dependencies | Validator | Falsifiable validation |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `B48-01` | Runner | `bsebench-runner` | `src/bsebench_runner/universal_plan.py`, `tests/test_universal_plan.py` | Dry-run universal protocol plan compiler that expands dataset, estimator, initialization, metric, and split IDs without executing data loaders. | Wait for `phase-8-0-b` protocol registry and `phase-8-0-o` split metadata heads. | `VAL-RUN` | `uv run pytest tests/test_universal_plan.py -q`; fail if plan accepts unknown IDs, future-sample policies, or duplicate evaluation cells. |
| `B48-02` | Runner | `bsebench-runner` | `src/bsebench_runner/initialization_executor.py`, `tests/test_initialization_executor.py` | Hook degraded-initialization policies into toy estimator reset paths so recovery protocols can be executed consistently. | Wait for `phase-8-0-a`, `phase-8-0-c`, and stats convergence metrics. | `VAL-RUN` | Focused pytest must prove wrong-SOC fixtures alter initial state and fail loudly when an estimator ignores reset. |
| `B48-03` | Runner | `bsebench-runner` | `src/bsebench_runner/split_guard_cli.py`, `tests/test_split_guard_cli.py` | CLI-level calibration/evaluation split guard that reads split metadata and blocks overlapping configs before benchmark execution. | Wait for `phase-8-0-d` and `phase-8-0-o`. | `VAL-RUN` | CLI fixture must exit non-zero on overlap, print exact overlapping tuple, and pass for disjoint calibration/evaluation fixtures. |
| `B48-04` | Runner | `bsebench-runner` | `src/bsebench_runner/profiling_export.py`, `tests/test_profiling_export.py` | Export compute profiling metadata as a JSON sidecar with runner version, estimator ID, per-cell timing, and memory backend. | Wait for `phase-8-0-e` and stats compute-cost aggregator. | `VAL-RUN` | Tests must reject negative runtime, missing estimator IDs, non-finite values, and schema-version drift. |
| `B48-05` | Runner | `bsebench-runner` | `src/bsebench_runner/submission_loader.py`, `tests/test_submission_loader.py` | Load a contributor estimator adapter from a local path while keeping dataset loading and metrics outside contributor code. | Wait for `phase-8-0-f` and async submission template. | `VAL-RUN` | Test fixture must load a valid toy submission and reject modules that try to define dataset loaders or metric overrides. |
| `B48-06` | Runner | `bsebench-runner` | `src/bsebench_runner/estimator_output_validation.py`, `tests/test_estimator_output_validation.py` | Standard invalid-output policy for NaN, infinite, out-of-range SOC, missing SOH, and estimator exceptions. | Wait for estimator plugin contract. | `VAL-RUN` | Tests must prove invalid outputs become explicit failed cells, not numeric scores or silently dropped samples. |
| `B48-07` | Runner | `bsebench-runner` | `src/bsebench_runner/cross_domain_manifest.py`, `tests/test_cross_domain_manifest.py` | Cross-chemistry/profile/temperature dry-run manifest builder for universal benchmark matrices. | Wait for dataset card schema and split metadata. | `VAL-INTEG` | Fixture must enumerate all requested cells, mark missing cells as unavailable with reasons, and never fabricate evidence rows. |
| `B48-08` | Runner | `bsebench-runner` | `tests/fixtures/universal_estimators.py`, `tests/test_universal_estimator_fixtures.py` | Toy ECM, observer, AI-estimator, and hybrid-method fixtures that all satisfy the same adapter contract. | Wait for estimator plugin contract. | `VAL-RUN` | Test must run all toy methods through one shared interface and fail if any fixture needs dataset-specific code. |
| `B48-09` | Stats | `bsebench-stats` | `src/bsebench_stats/metric_matrix_export.py`, `tests/test_metric_matrix_export.py` | Machine-readable RMSE, MAE, MAXE, per-cell/profile report exporter with invalid-cell accounting. | Wait for `phase-8-0-g`. | `VAL-STATS` | Focused tests must reject incomplete grids, non-finite metrics, duplicate cells, and missing invalid-run caveats. |
| `B48-10` | Stats | `bsebench-stats` | `src/bsebench_stats/convergence_panel.py`, `tests/test_convergence_panel.py` | Aggregate recovery/convergence metrics across degraded-initialization protocols without reducing failures to a single mean. | Wait for `phase-8-0-h` and runner degraded initialization. | `VAL-STATS` | Tests must keep unrecovered cells visible and reject a panel where all methods fail to converge. |
| `B48-11` | Stats | `bsebench-stats` | `src/bsebench_stats/robustness_noise_summary.py`, `tests/test_robustness_noise_summary.py` | Summarize Gaussian and non-Gaussian perturbation reports with perturbation identity, seed policy, and invalid-output counts. | Wait for `phase-8-0-i`. | `VAL-STATS` | Tests must reject unknown perturbation classes, missing seed policy, and summaries that omit invalid cells. |
| `B48-12` | Stats | `bsebench-stats` | `src/bsebench_stats/compute_cost_report.py`, `tests/test_compute_cost_report.py` | Compute-cost report that separates wall time, memory, hardware notes, and missing-cost caveats. | Wait for `phase-8-0-j` and runner profiling sidecar. | `VAL-STATS` | Tests must reject negative or zero runtime and must preserve missing memory as `unknown`, not `0`. |
| `B48-13` | Stats | `bsebench-stats` | `src/bsebench_stats/ranking_sensitivity.py`, `tests/test_ranking_sensitivity.py` | Multi-axis ranking sensitivity audit over multiple weight sets with neutral wording and caveats. | Wait for `phase-8-0-k`. | `VAL-LEDGER` | Tests must show rank changes under weight changes and reject output that uses banned claim-language fields without a source ledger. |
| `B48-14` | Stats | `bsebench-stats` | `src/bsebench_stats/transfer_completeness.py`, `tests/test_transfer_completeness.py` | Transfer-matrix completeness gate for source/target chemistry, profile, temperature, and aging axes. | Wait for `phase-8-0-l` and dataset card schema. | `VAL-STATS` | Tests must fail on duplicate transfer cells, missing source/target caveats, and mixed split IDs. |
| `B48-15` | Stats | `bsebench-stats` | `src/bsebench_stats/failure_taxonomy.py`, `tests/test_failure_taxonomy.py` | Common taxonomy for timeout, invalid output, unsupported method, missing data, and loader failure across reports. | Can start after metric matrix branch is visible. | `VAL-STATS` | Tests must map synthetic failures deterministically and reject unknown status labels unless explicitly registered. |
| `B48-16` | Stats | `bsebench-stats` | `src/bsebench_stats/uncertainty_schema.py`, `tests/test_uncertainty_schema.py` | Neutral uncertainty interval schema for benchmark reports, with no claim promotion. | Can start after metric matrix exporter. | `VAL-STATS` | Tests must reject intervals missing method, dataset, split, confidence level, or finite bounds. |
| `B48-17` | Datasets | `bsebench-datasets` | `src/bsebench_datasets/etl_contract_validator.py`, `tests/test_etl_contract_validator.py` | Validator for harmonized `V`, `I`, `T`, `dt`, SOC, and SOH field contracts in dataset adapters. | Wait for `phase-8-0-m`. | `VAL-DATA` | Tests must reject missing required fields, wrong units, non-monotonic time, and undocumented resampling. |
| `B48-18` | Datasets | `bsebench-datasets` | `src/bsebench_datasets/ground_truth_inventory.py`, `tests/test_ground_truth_inventory.py` | Ground-truth evidence inventory that records coulomb-counting, OCV recalibration, or documented gaps. | Wait for `phase-8-0-n`. | `VAL-DATA` | Tests must classify ready/gap/not-applicable records and fail if a gap is reported as ready. |
| `B48-19` | Datasets | `bsebench-datasets` | `src/bsebench_datasets/split_manifest_builder.py`, `tests/test_split_manifest_builder.py` | Build calibration/evaluation split manifests from dataset cards and adapter metadata. | Wait for `phase-8-0-o` and card schema. | `VAL-DATA` | Tests must reject overlapping configs and must emit split IDs stable under input ordering. |
| `B48-20` | Datasets | `bsebench-datasets` | `src/bsebench_datasets/dataset_card_audit.py`, `tests/test_dataset_card_audit.py` | Dataset-card completeness audit for chemistry, profile, temperature, aging/SOH, equipment, license, and provenance fields. | Wait for `phase-8-0-p` and equipment registry. | `VAL-DATA` | Tests must fail cards with missing required universal benchmark axes or ambiguous provenance. |
| `B48-21` | Datasets | `bsebench-datasets` | `src/bsebench_datasets/equipment_aliases.py`, `tests/test_equipment_aliases.py` | Normalize Arbin, Maccor, and unknown-equipment aliases while preserving raw vendor provenance. | Wait for `phase-8-0-q`. | `VAL-DATA` | Tests must reject alias collisions and prove raw equipment labels are retained in audit output. |
| `B48-22` | Datasets | `bsebench-datasets` | `src/bsebench_datasets/availability_diff.py`, `tests/test_availability_diff.py` | Monthly dataset availability diff between two snapshots with added, removed, changed, and blocked records. | Wait for `phase-8-0-r`. | `VAL-DATA` | Tests must detect status changes and fail if remote availability is inferred without local manifest evidence. |
| `B48-23` | Datasets | `bsebench-datasets` | `scripts/audit-cache-provenance-redaction.py`, `tests/test_cache_provenance_redaction.py` | Audit that committed provenance reports do not leak machine-local cache paths or credentials. | Can start after any provenance report exists. | `VAL-DATA` | Test fixtures must include bad absolute paths and token-like strings that the audit rejects. |
| `B48-24` | Datasets | `bsebench-datasets` | `src/bsebench_datasets/aging_metadata.py`, `tests/test_aging_metadata.py` | Aging/SOH metadata readiness schema for Phase 10 and Phase 12 transfer tasks. | Wait for dataset card schema. | `VAL-DATA` | Tests must reject records without cycle count, SOH reference method, timestamp basis, or missing-data caveat. |
| `B48-25` | Async | `bsebench-async-codex-cto-report` | `scripts/generate-brief-from-backlog-row.sh`, `tests/test-generate-brief-from-backlog-row.sh` | Generate BRIEF skeletons from backlog rows while preserving write-set, dependency, validation, and guardrail fields. | Wait for async charter gate branch. | `VAL-ASYNC` | Shell tests must reject rows without universal value, validation command, owned write set, or forbidden-file guardrail. |
| `B48-26` | Async | `bsebench-async-codex-cto-report` | `scripts/check-disjoint-wave-manifest.sh`, `tests/test-check-disjoint-wave-manifest.sh` | CI-safe wrapper around the disjoint wave planner for future parallel waves. | Wait for `phase-8-0-v`. | `VAL-ASYNC` | Tests must fail overlapping write sets, protected paths, duplicate branches, and empty validation fields. |
| `B48-27` | Async | `bsebench-async-codex-cto-report` | `scripts/check-monthly-snapshot-fixtures.sh`, `tests/test-check-monthly-snapshot-fixtures.sh` | Shell validation for monthly snapshot schema fixtures and invalid examples. | Wait for `phase-8-0-t`. | `VAL-ASYNC` | Test must pass valid fixture and require invalid fixture to fail for a known reason. |
| `B48-28` | Async | `bsebench-async-codex-cto-report` | `scripts/check-source-ledger.sh`, `tests/test-check-source-ledger.sh` | Source-ledger required-field linter for any comparison or public report task. | Wait for source-ledger audit branch or run standalone with fixtures. | `VAL-LEDGER` | Tests must fail missing DOI/stable URL, retrieval date, metric, dataset, split, frozen BSEBench value, or caveat. |
| `B48-29` | Async | `bsebench-async-codex-cto-report` | `scripts/validator-wait-recheck.sh`, `tests/test-validator-wait-recheck.sh` | Validator helper that records `pending_active_worker` when branch logs show live workers and no pushed head. | Can start immediately. | `VAL-ASYNC` | Shell tests must prove live-worker fixture returns pending, pushed-head fixture returns ready, and dead/no-head fixture escalates. |
| `B48-30` | Async | `bsebench-async-codex-cto-report` | `reports/integration/universal-wave-merge-envelope-template.md`, `tests/test-merge-envelope-template.sh` | Merge-readiness envelope template requiring changed files, commands, branch SHA, guardrail scan, and residual risks. | Wait for validator branches. | `VAL-INTEG` | Test must reject missing SHA, missing validation command, protected path edits, or unsupported claim wording. |
| `B48-31` | Integration | `bsebench-async-codex-cto-report` | `reports/integration/phase-8-wave1-conflict-map-<timestamp>.md` | Read-only conflict map from remote heads after runner/stats/datasets/async workers finish. | Wait for Wave 1 heads or active-worker timeout policy. | `VAL-INTEG` | Report must list every branch, remote SHA or pending state, changed file paths, conflicts, and next action. |
| `B48-32` | Integration | `bsebench-async-codex-cto-report` | `reports/validation/phase-8-wave1-validation-matrix-<timestamp>.md` | Validation matrix assigning one validator result per Wave 1 branch. | Wait for `B48-31` and validator logs. | `VAL-INTEG` | Matrix must not approve branches without remote SHA, GLASSBOX commit check, focused validation, and guardrail scan. |
| `B48-33` | Public workflow | `bsebench-async-codex-cto-report` | `reports/monthly/monthly-dry-run-envelope-<timestamp>.md` | Dry-run envelope for a monthly benchmark snapshot using fixtures only, with all caveat fields visible. | Wait for monthly schema and source-ledger linter. | `VAL-ASYNC` | Report must fail if any public-facing row lacks split, metric, failure accounting, source ledger status, or caveat. |
| `B48-34` | Public workflow | `bsebench-async-codex-cto-report` | `reports/release/public-risk-register-delta-<timestamp>.md` | Risk-register delta after Wave 1 and Wave 2 results, tied to concrete blockers and owners. | Wait for public-release risk branch or existing checklist. | `VAL-INTEG` | Report must name owner, evidence path, severity, unblock command, and acceptance gate for every high risk. |
| `B48-35` | Research gate | `bsebench-async-codex-cto-report` | `reports/source-ledger/source-ledger-redteam-<timestamp>.md` | Red-team audit of any comparison-eligible prose or fixtures, without making external performance claims. | Wait for source-ledger linter or run as manual audit. | `VAL-LEDGER` | Audit must list exact files scanned, banned language hits, missing ledger fields, and a pass/fail decision. |
| `B48-36` | Ops | `bsebench-async-codex-cto-report` | `reports/ops/no-idle-capacity-audit-<timestamp>.md` | No-idle capacity audit that distinguishes useful queued work from duplicate or blocked work. | Wait for no-idle policy branch. | `VAL-ASYNC` | Report must list running, queued, blocked, and reserve tasks with reasons; fail if it recommends duplicate write sets. |

## Dependency Waves

1. First validation window: `VAL-RUN`, `VAL-STATS`, and `VAL-DATA` re-check Wave
   1 remote heads. Branches still running remain pending, not failed.
2. Contract hardening window: run `B48-01` through `B48-24` after their Wave 1
   dependencies are pushed and fetched.
3. Async safety window: run `B48-25` through `B48-30` to convert this backlog
   into repeatable BRIEF, disjointness, source-ledger, and validator gates.
4. Integration window: run `B48-31` through `B48-36` only after enough branch
   heads exist to make conflict and release-risk reports factual.

## Explicit Non-Work

The following are excluded as busy work or unsafe autonomous work:

- style-only prose sweeps that do not add a gate, schema, validator, or
  falsifiable report;
- roadmap reshuffling, thesis prose, manuscript edits, or claim registry edits;
- any result phrased as verified science or public comparative performance
  without a complete source ledger and frozen BSEBench artifact;
- duplicate validators checking the same branch while a worker is still active;
- expensive empirical reruns unless a candidate explicitly requires a dry-run
  fixture or the upstream branch already produced the necessary artifacts.

## Evidence Commands

Commands run for this report:

```bash
pwd && git status --short --branch
rg --files | rg '(^backlog/|GLASSBOX|48h|backlog)'
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 3 -type f | sort | tail -120
sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md
sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md
sed -n '1,180p' docs/CTO-48H-AUTONOMY-PLAN-2026-05-07.md
sed -n '1,220p' cto/AUTONOMY_BACKLOG/README.md
tail -n 25 /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-0-*.log
tail -n 50 /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-1-*.log
find /mnt/c/doctorat/bsebench-org -maxdepth 1 -type d -name 'bsebench-*phase-8-*' -printf '%f\n' | sort
find cto/AUTONOMY_BACKLOG -maxdepth 2 -name BRIEF.md -print | sort
for repo in bsebench-runner bsebench-stats bsebench-datasets bsebench-async-codex bsebench-async-codex-cto-report; do
  git -C "/mnt/c/doctorat/bsebench-org/$repo" ls-remote --heads origin 'phase-8-0-*' 'phase-8-1-*'
done
ps -ef | rg 'phase-8-0|phase-8-1' | rg -v 'rg '
```

One broad `git status` sweep over all active phase-8 worktrees was stopped
after it blocked inside an active worktree status command. It is not used as
approval or failure evidence.

## Local Validation

Completed after writing this file:

```bash
rg -n '^\| `B48-[0-9]+`' backlog/48h/universal-backlog-20260507T193050Z.md | wc -l
git diff --check
find backlog -type f -print | sort
```

Results:

- Candidate count: `36`, satisfying the minimum of 24.
- `git diff --check`: passed with no output.
- Owned-file scope: only `backlog/48h/universal-backlog-20260507T193050Z.md`
  exists under the new `backlog/` path.

## Residual Risks

- Runner, stats, and datasets Wave 1 branches were still active or not remotely
  visible at the snapshot. This backlog therefore assigns wait/re-check
  validators instead of treating absent heads as failures.
- Candidate write sets may need path adjustments after Wave 1 branches land.
  The disjointness rule still applies: adjust file paths, not ownership.
- The backlog is a planning artifact. It does not validate or approve any Wave
  1 implementation by itself.
