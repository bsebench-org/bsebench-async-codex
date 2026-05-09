# Phase 1-11 Trajectory Audit

Date: 2026-05-09 09:17 CEST

Scope: read-only trajectory audit across the thesis-side early phases and the
BSEBench organization work up to the Phase 9/10/11 checkpoint. This document is
an execution and research-integrity report. It does not change the scientific
roadmap, thesis prose, or any claim registry.

## Executive Verdict

BSEBench is directionally aligned with the universal SOC/SOH evaluation goal,
but the delivered center of gravity is still platform infrastructure, not
publication-grade scientific evidence.

The strongest current output is the fail-closed engineering stack: estimator
contracts, protocol metadata, dataset provenance guards, leakage guards, ETL
contracts, metric schemas, residual diagnostics, and strict report language. The
weakest current area is the executable end-to-end path: the universal estimator
contract exists, but the main runner still leans on legacy filter execution and
voltage-centric outputs in important paths.

Decision for execution:

- Keep all research claims in `NO_GO_CLAIM` until a source-ledger, provenance,
  cache, split, Tier2, artifact-hash, and replay bundle exists on current heads.
- Open Phase 12 only as a mechanical integration phase: cross-chemistry transfer
  contracts, inventory, parameter-freeze rules, and bounded smoke outputs.
- Do not add thesis wording or claim-registry changes from autonomous tasks.
- Prefer product work in `bsebench-runner`, `bsebench-datasets`,
  `bsebench-stats`, `bsebench-specs`, and `bsebench-filters` over more broad
  async-only reports.

## Evidence Read

Primary governance and target documents:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
- `docs/RESEARCH-ROADMAP-2026-05-06.md`
- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`
- `docs/AI-RISKS-2026-05-06.md`
- `docs/POST_PHASE_11_GENERAL_AUDIT_PLAN_2026-05-08.md`
- `docs/PHASE_9_FINAL_AUDIT_VALIDATION_REPORT_2026-05-09.md`
- `docs/PHASE_10_FINAL_AUDIT_VALIDATION_REPORT_2026-05-09.md`
- `docs/PHASE_11_FINAL_AUDIT_VALIDATION_REPORT_2026-05-09.md`
- `docs/PHASE_9_10_11_TRANSVERSE_AUDIT_2026-05-09.md`

Subagent read-only audits used as inputs:

- Phases 1-6 archival/readiness audit.
- Phases 7-8 plus downstream inheritance audit.
- Global trajectory audit across BSEBench contracts and runner path.

## Phase Status

| Phase | Current status | What is solid | What blocks claim use |
| --- | --- | --- | --- |
| 1 | `UNKNOWN_ARCHIVAL` | Draft BPCRLB code and oracle tests exist in thesis-side material. | No current CALCE multi-run artifact bundle found in this audit. |
| 2 | `UNKNOWN_ARCHIVAL` | Statistical-consistency preregistration exists. | No current executed result bundle found in this audit. |
| 3 | `UNKNOWN_ARCHIVAL` | Cross-profile idea exists, later supported by Phase 9 tooling. | No full profile-axis empirical matrix found here. |
| 4 | `NO_GO_CLAIM` | Cross-chemistry question is correctly recognized as high-value. | Earlier broad chemistry inference was descoped; available chemistry support is insufficient for claim language. |
| 5 | `NO_GO_CLAIM` | Aging/SOH contracts and smoke machinery exist through Phase 10. | SOH axis support is not stratified enough for scientific interpretation. |
| 6 | `GO_TOOLING`, `NO_GO_CLAIM` | CALCE/NASA infrastructure, registry work, chi-square sweep, stats tooling, and loaders are the strongest early outputs. | Needs a current evidence ledger with hashes and source identities before claim use. |
| 7 | `GO_TOOLING`, `NO_GO_CLAIM` | Hinf mechanics, residual tooling, research gates, source-ledger scaffolding, and claim-language guards exist. | Hinf claim identity is unsafe; real evidence runs were fragile or blocked. |
| 8 | `GO_INFRA_DIRECTION`, `NO_GO_CLAIM` | Universal benchmark charter, submission/release guardrails, estimator contracts, metric schemas, leakage and ground-truth contracts. | Integration is uneven; some wave outputs were conflict-heavy or report-only. |
| 9 | `GO_TOOLING`, `GO_EMPIRICAL_SMOKE`, `NO_GO_CLAIM` | Profile-axis contracts and bounded smoke evidence exist. | SOC/SOH truth and full profile matrix are not sufficient for scientific interpretation. |
| 10 | `GO_TOOLING`, `GO_EMPIRICAL_SMOKE`, `NO_GO_CLAIM` | Aging/SOH plan, strict smoke artifacts, and fail-closed preflight exist; strict smoke was refreshed on runner commit `cc9e89b`. | One SOH group and one ready config cannot support aging/SOH claim language. |
| 11 | `GO_TOOLING`, `GO_EMPIRICAL_SMOKE`, `NO_GO_CLAIM` | Residual manifest, diagnostics readiness, and sensitivity reporting exist. | Sample imbalance and mechanical-only verdict block scientific interpretation. |

## Universal Benchmark Alignment

The target is right: BSEBench should become a reusable community evaluation
framework for SOC/SOH estimators across ECMs, Kalman-family filters, observers,
AI estimators, and future algorithms. The current work supports that target in
four important ways.

1. **Contracts are emerging.** The runner has an estimator contract; stats has
   metric and transfer schemas; datasets has ground-truth, ETL, split, and
   leakage contracts.
2. **Fail-closed culture improved.** Reports now avoid unsupported claim
   language and force `NO_GO_CLAIM` when evidence is incomplete.
3. **Axes are mapped.** Chemistry, profile, aging/SOH, residual, and transfer
   axes are visible in the roadmap and codebase.
4. **Community workflow is framed.** Submission templates, monthly snapshot
   ideas, provenance fields, and source-ledger rules are present.

The current gap is execution coupling. The universal contract must become the
primary run path, and legacy filters should become adapters. A framework cannot
be universal if the main path still depends on legacy filter conventions.

## Methodology Integrity Assessment

| Pillar | Status | Audit finding |
| --- | --- | --- |
| Accuracy metrics | Partial | RMSE/MAE/MAXE style metric support exists, but SOC/SOH availability still depends on trustworthy truth columns. |
| Robustness metrics | Partial | Degraded initialization and residual/noise axes exist, but balanced evidence is still thin. |
| Cost metrics | Partial | Compute-cost contracts exist; broad reproducible cost capture is not yet primary-path. |
| Generalization | Partial | Chemistry/profile/aging/transfer axes exist, but real cross-axis matrices remain sparse. |
| Ground truth | Blocker | Evidence contracts exist, but the runner path must require them for SOC/SOH metric eligibility. |
| Anti-leakage | Good direction | Leakage guards exist; they must be promoted into every calibration/evaluation path. |
| ETL harmonization | Partial | ETL vector contracts exist; raw equipment diversity still needs stronger end-to-end ingestion. |
| Plug-and-play API | Partial | Contract exists; external estimator submission lifecycle still needs a fully runnable path. |

## Trajectory Errors Found

1. **Activity was overvalued versus deliverables.** A high `codex exec` count
   without current-head artifacts, hashes, tests, and mergeable product commits
   creates noise.
2. **Reports outpaced integration.** Phase 8 and later produced useful
   governance, but too much work landed as broad async artifacts instead of
   product-path changes.
3. **Old reports can contradict newer guardrails.** Several legacy prereg or
   planning documents still carry earlier assumptions. New reports must include
   snapshot date, scope, and supersession notes.
4. **Scientific wording needs hard separation.** Mechanical evidence,
   diagnostics, source-ledger comparison, and claim registration must remain
   separate lanes.
5. **Ground truth is the core blocker.** Without auditable SOC/SOH evidence, the
   benchmark can run diagnostics but cannot support external-facing scientific
   interpretation.

## Decisions Before Phase 12

Phase 12 may open only under these conditions:

- It is scoped to cross-chemistry transfer mechanics, not claim language.
- Each task has a disjoint write set.
- Every worker brief states the exact validation command and expected artifact.
- Runner/datasets/stats/specs/filters work is preferred over async-only prose.
- A task is not accepted unless it either changes product code, adds executable
  checks, or creates a current-head artifact ledger.

## Phase 12 Opening Task Graph

Ready tasks after this audit:

| Task | Repo | Scope | Dependency | Output |
| --- | --- | --- | --- | --- |
| P12-SPECS-1 | `bsebench-specs` | Integrate transfer contract/schema on current head. | This audit. | Schema plus focused tests. |
| P12-DATASETS-1 | `bsebench-datasets` | Produce cross-chemistry inventory with source identity and truth-readiness flags. | This audit. | Inventory artifact plus unit tests. |
| P12-STATS-1 | `bsebench-stats` | Transfer coefficient preflight, fail-closed on missing axes. | P12-SPECS-1 can run in parallel if API stable. | Validator tests and fixture. |
| P12-RUNNER-1 | `bsebench-runner` | Bridge inventory into transfer plans without executing large runs. | P12-DATASETS-1. | Plan fixture plus smoke test. |
| P12-FILTERS-1 | `bsebench-filters` | Parameter-freeze metadata contract for transfer tasks. | P12-SPECS-1. | Adapter metadata tests. |
| P12-ASYNC-1 | `bsebench-async-codex` | Worker brief pack and dashboard with artifact-hash requirement. | This audit. | Briefs only, no claim wording. |
| P12-RUNNER-2 | `bsebench-runner` | Bounded transfer smoke on cached small data. | P12-DATASETS-1 and P12-RUNNER-1. | Local artifact with hashes. |
| P12-AUDIT-1 | `bsebench-async-codex` | Opening checkpoint after first product commits. | First P12 product commit. | Short audit report. |

## Next Execution Policy

- Minimum useful parallelism: 5 product workers plus 1 audit worker.
- Maximum useful parallelism right now: 8 workers. Beyond that, write-scope
  collisions and stale reports become more likely than useful throughput.
- The backlog should always contain at least six ready or dependency-labeled
  tasks, but tasks must be useful and independently checkable.
- Status reporting should include delta since last report, current active task
  count, blocked tasks, last product commit, last async commit, and next gate.

## Final Direction Check

We are still on the right path if the next work makes the universal evaluation
path executable end to end:

`dataset source -> ETL -> truth evidence -> leakage-safe split -> estimator API -> metrics -> transfer/robustness reports -> artifact ledger`.

We are off path if the next work mostly increases reports, worker counts, or
dataset counts without improving that executable chain.

