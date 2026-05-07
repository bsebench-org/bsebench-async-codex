# Community Estimator Submission Package Index

GLASSBOX integration artifact for Wave 5 worker W5-13.

Saved: 2026-05-07T21:31:25Z dispatch window.

Owned path:
`release/alpha/community-submission-package-index-20260507T213125Z.md`.

Branch:
`phase-8-4-m-community-submission-package-index-20260507T213125Z`.

## Objective

Index every artifact currently needed to assemble a community estimator
submission package for the universal BSEBench SOC/SOH benchmark, and identify
which assets are available, local-only, or still missing before the package can
be treated as integration-ready.

This index is a release-hardening map only. It does not integrate source
branches, run a benchmark, publish results, rank methods, register claims, or
approve a public report.

## Evidence Inspected

Commands were run from the CTO report worktree unless a sibling repo is named.

| Evidence | Command or path | Finding |
|---|---|---|
| Current branch | `git status --short --branch` | Branch is `phase-8-4-m-community-submission-package-index-20260507T213125Z`, tracking `origin/main`; this file was the only intended write. |
| Release tree | `rg --files release` | `release/` did not exist before this artifact. |
| Remote refresh | `git fetch --all --prune` | Remote Wave 0-5 refs refreshed. At final inspection, `origin/phase-8-4-d/e/f/g/h/i/j/k/l/n/p` existed; `origin/phase-8-4-o` did not. |
| Submission template branch | `git diff --name-status origin/main...origin/phase-8-0-s-universal-async-submission-template` | Adds contributor template and validation checklist. |
| Template content | `git show origin/phase-8-0-s...:templates/universal-contributor-submission-template.md` | Requires metadata, adapter contract, data/split declaration, provenance artifacts, metrics, source ledger, reproduction commands, and checklist. |
| Checklist content | `git show origin/phase-8-0-s...:docs/BSEBENCH-UNIVERSAL-CONTRIBUTOR-VALIDATION-CHECKLIST-2026-05-07.md` | Defines intake, plug-and-play, leakage, provenance, metric, source-ledger, reproduction, monthly readiness, and reviewer decision gates. |
| Lifecycle spec | `git show origin/phase-8-3-m...:specs/universal/submission-lifecycle-state-machine-20260507T204627Z.md` | Defines fail-closed states from intake to published report, including dependency restore, adapter smoke, sandbox smoke, replay, leakage, evidence, metrics, comparability, and freeze gates. |
| Interface matrix | `git show origin/phase-8-3-n...:audits/universal/estimator-interface-compatibility-matrix-20260507T204627Z.md` | Maps ECM, Kalman, observer, AI, hybrid, SOH-only, and future method classes to the visible runner hooks and blockers. |
| Runner contract | `/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-a-universal-runner-estimator-plugin-contract/src/bsebench_runner/estimator_contract.py` | Candidate contract requires a fresh factory and `step(t, voltage_V, current_A, temperature_C)` returning finite numeric `voltage_predicted`; extra numeric fields are allowed. |
| Runner submission smoke | `/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-f-universal-runner-submission-smoke/tests/test_submission_smoke.py` | Toy external estimator runs through the orchestrator, but it is same-process import and not a public sandbox. |
| Split leakage guard | `/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-d-universal-runner-leakage-split-guard/src/bsebench_runner/split_guard.py` | Calibration/evaluation overlap is detected by wrapper/profile/temperature config identity. |
| Source ledger spec | `git show origin/phase-8-3-k...:specs/universal/source-ledger-schema-20260507T204627Z.md` | Defines source rows, frozen BSEBench value rows, comparison bindings, claim bindings, and rejection cases. |
| Monthly artifact schema | `git show origin/phase-8-3-l...:specs/universal/monthly-snapshot-artifact-schema-20260507T204627Z.md` | Defines submission, method, dataset, metric, protocol, evidence, result, source-ledger, validation-gate, caveat, and freeze sections. |
| Definition of done | `git show origin/phase-8-3-x...:docs/universal/definition-of-done-20260507T204627Z.md` | Defines gates for code, data, metrics, integration, reports, claims, and residual risks. |
| Wave 5 docs integration | `git diff --name-status origin/main...origin/phase-8-4-d-async-universal-docs-integration-20260507T213125Z` | Remote branch `52a7b14d0c41ab56c315bd9e14d36bcf7f358248` integrates async docs, audits, runbooks, specs, templates, and validation artifacts. |
| Wave 5 remote availability | `git branch -r --list 'origin/phase-8-4-*'` | Remote refs existed for async docs integration, runner/stats/datasets/async validators, PR pack, merge-order record, RC manifest, public-claims redline gate, dry-run checklist, and 12h scoreboard; cross-repo API ledger was not a remote ref at final inspection. |

## Available Package Assets

These artifacts exist as committed branch evidence and can be copied or merged
into a community submission package after normal integration review.

### CTO Report / Async Artifacts

| Package need | Asset path | Branch or ref | SHA | Status |
|---|---|---|---|---|
| Contributor packet template | `templates/universal-contributor-submission-template.md` | `origin/phase-8-0-s-universal-async-submission-template` | `8b8110b561029b7906a8ba27cd2613f5f1f25b91` | Available on remote branch. |
| Reviewer validation checklist | `docs/BSEBENCH-UNIVERSAL-CONTRIBUTOR-VALIDATION-CHECKLIST-2026-05-07.md` | `origin/phase-8-0-s-universal-async-submission-template` | `8b8110b561029b7906a8ba27cd2613f5f1f25b91` | Available on remote branch. |
| Monthly snapshot v1 doc/schema/fixtures | `docs/BSEBENCH-MONTHLY-SNAPSHOT-SCHEMA-2026-05-07.md`, `docs/schemas/bsebench-monthly-benchmark-snapshot-v1.schema.json`, `docs/fixtures/monthly-benchmark-snapshot/*.json` | `origin/phase-8-0-t-universal-async-monthly-snapshot-schema` | `669a4eac635fcd28130833fb4ac07b9ca4fb9b32` | Available on remote branch. |
| Public release checklist | `docs/BSEBENCH-PUBLIC-BENCHMARK-RELEASE-CHECKLIST-2026-05-07.md` | `origin/phase-8-0-w-universal-async-public-release-checklist` | `1a337a630edea022a807e55c93d93a1cf1059084` | Available on remote branch. |
| Monthly workflow | `docs/universal/monthly-benchmark-workflow-20260507T193050Z.md` | `origin/phase-8-1-r-monthly-benchmark-workflow-design-20260507T193050Z` | `dba3ce242bb27fa783f633972378b36f6e1975c9` | Available on remote branch. |
| Sandbox security audit | `audits/methodology/submission-sandbox-security-20260507T193528Z.md` | `origin/phase-8-2-g-submission-sandbox-security-audit-20260507T193528Z` | `29c26b8df96e64dc6b4a39410f3022fa3c41cec7` | Available on remote branch. |
| Reproducibility artifact manifest retry | `audits/methodology/reproducibility-artifact-manifest-retry-20260507T204627Z.md` | `origin/phase-8-3-a-retry-repro-artifact-manifest-20260507T204627Z` | `4185c09053d3a02ae260bdb650be13af71c98d48` | Available on remote branch. |
| Merge queue retry runbook | `runbooks/merge-queue-runbook-retry-20260507T204627Z.md` | `origin/phase-8-3-b-retry-merge-queue-runbook-20260507T204627Z` | `10415cd57641bbf3c3143e6514e6cffc4a2bd200` | Available on remote branch. |
| Worker triage retry runbook | `runbooks/worker-triage-relaunch-retry-20260507T204627Z.md` | `origin/phase-8-3-c-retry-worker-triage-runbook-20260507T204627Z` | `1bb6ad493ab76574bbe8cf6882932ab6e91c5482` | Available on remote branch. |
| Phase 8 branch ledger | `ledgers/phase8/branch-ledger-20260507T204627Z.md` | `origin/phase-8-3-h-phase8-branch-ledger-20260507T204627Z` | `b5b0adf5ada72a4f6ed828dc0f382228bf66c15c` | Available on remote branch. |
| Source-ledger schema spec | `specs/universal/source-ledger-schema-20260507T204627Z.md` | `origin/phase-8-3-k-source-ledger-schema-spec-20260507T204627Z` | `808d046ca467be270ef39852db1127e41bc8e101` | Available on remote branch. |
| Monthly snapshot artifact schema | `specs/universal/monthly-snapshot-artifact-schema-20260507T204627Z.md` | `origin/phase-8-3-l-monthly-snapshot-artifact-schema-20260507T204627Z` | `0f3b4bb76b1870a5a8cc030202c23551cf6b4cf7` | Available on remote branch. |
| Submission lifecycle state machine | `specs/universal/submission-lifecycle-state-machine-20260507T204627Z.md` | `origin/phase-8-3-m-submission-lifecycle-state-machine-20260507T204627Z` | `16748daa221dfe5b9d8eacc6ae753e61f7ea6293` | Available on remote branch. |
| Estimator interface compatibility matrix | `audits/universal/estimator-interface-compatibility-matrix-20260507T204627Z.md` | `origin/phase-8-3-n-estimator-interface-compatibility-matrix-20260507T204627Z` | `2356f8acf0ce9e787caa899dc0e9d8b1ca825425` | Available on remote branch. |
| Merge readiness dashboard | `dashboards/phase8/merge-readiness-dashboard-20260507T204627Z.md` | `origin/phase-8-3-t-phase8-merge-readiness-dashboard-20260507T204627Z` | `2d550ef7d1853480e42b043c38490d53b029967f` | Available on remote branch. |
| Universal definition of done | `docs/universal/definition-of-done-20260507T204627Z.md` | `origin/phase-8-3-x-universal-bsebench-definition-of-done-20260507T204627Z` | `8d3f428fe124af5bf85a7b02326140e41aae2fbd` | Available on remote branch. |
| Async docs/audits integration | `ledgers/phase8/docs-integration-ledger-20260507T213125Z.md` plus integrated docs, audits, runbooks, specs, templates, and validation artifacts | `origin/phase-8-4-d-async-universal-docs-integration-20260507T213125Z` | `52a7b14d0c41ab56c315bd9e14d36bcf7f358248` | Available on remote branch; broad docs integration artifact, not a community package by itself. |
| Runner integration validator | `validation/wave-5/runner-integration-validator-20260507T213125Z.md` | `origin/phase-8-4-e-runner-integration-validator-20260507T213125Z` | `f839fd8a611c2f44dac0b8b4a5495425a5fa4b24` | Available; records focused remote validation PASS for runner integration head `e0664de6e02dd45832068de427666dbcc2bd3d10`, with broader gates still open. |
| Stats integration validator | `validation/wave-5/stats-integration-validator-20260507T213125Z.md` | `origin/phase-8-4-f-stats-integration-validator-20260507T213125Z` | `1d905c010c635143cdef379d66ce1c7aad3e069f` | Available; records PENDING because the target stats integration branch was not pushed and had an unresolved local export conflict at inspection. |
| Datasets integration validator | `validation/wave-5/datasets-integration-validator-20260507T213125Z.md` | `origin/phase-8-4-g-datasets-integration-validator-20260507T213125Z` | `082f4a248154508dd75a58ba65e54fedffeb112d` | Available; records PENDING_REMOTE_PUSH for the target datasets integration branch. |
| Async integration validator | `validation/wave-5/async-integration-validator-20260507T213125Z.md` | `origin/phase-8-4-h-async-integration-validator-20260507T213125Z` | `a93af3822954aaabe3721e1ba7294ab1b5899d35` | Available; records an async block that must be reviewed before release use. |
| Phase 8 PR description pack | `pr/phase8/pr-description-pack-20260507T213125Z.md` | `origin/phase-8-4-i-phase8-pr-description-pack-20260507T213125Z` | `391029976a3aa9f1e4f174ac4f2e24293a7bc8a7` | Available on remote branch. |
| Merge-order decision record | `decisions/phase8/merge-order-20260507T213125Z.md` | `origin/phase-8-4-j-phase8-merge-order-decision-record-20260507T213125Z` | `1ebe51814e9ef7fb69ba07f154acc691f27bf326` | Available on remote branch. |
| Alpha RC manifest | `release/alpha/universal-rc-manifest-20260507T213125Z.md` | `origin/phase-8-4-k-release-candidate-manifest-20260507T213125Z` | `60649e96b8b344a17d9a46c3a066c7d77c0ca87c` | Available; manifest state is draft and publication state is blocked. |
| Public claims redline gate | `gates/public-claims-redline-gate-20260507T213125Z.md` | `origin/phase-8-4-l-public-claims-redline-gate-20260507T213125Z` | `b76ce0949e07cc3770c52090c0a50f00fb59ed9b` | Available on remote branch. |
| Monthly benchmark dry-run checklist | `runbooks/monthly-benchmark-dry-run-20260507T213125Z.md` | `origin/phase-8-4-n-monthly-benchmark-dry-run-checklist-20260507T213125Z` | `b24a433bd9fbd24cdade45302e6e8eb0f8d4cf87` | Available on remote branch. |
| 12h autonomy scoreboard | `dashboards/12h/autonomy-scoreboard-20260507T213125Z.md` | `origin/phase-8-4-p-12h-autonomy-scoreboard-20260507T213125Z` | `762a018e3417f336f84f330fda6c4ab8003a65cd` | Available on remote branch as operations context. |

### Runner Assets

| Package need | Asset path | Branch or ref | SHA | Status |
|---|---|---|---|---|
| Minimal estimator adapter contract | `src/bsebench_runner/estimator_contract.py`, `tests/test_estimator_contract.py`, `tests/fixtures/toy_estimator_adapter.py` | `origin/phase-8-0-a-universal-runner-estimator-plugin-contract` | `7f590c24085395ea8c9a999e196c50defa00b139` | Available in runner repo branch. |
| Split leakage guard | `src/bsebench_runner/split_guard.py`, `tests/test_split_guard.py` | `origin/phase-8-0-d-universal-runner-leakage-split-guard` | `5d8efab0c9533315ae9b3371ba74d05899ceaffc` | Available in runner repo branch. |
| Toy external submission smoke | `examples/submissions/toy_external_estimator.py`, `examples/submissions/toy_external_submission_split.yaml`, `tests/test_submission_smoke.py` | `origin/phase-8-0-f-universal-runner-submission-smoke` | `ce792f35b96a3aaa544c8c21b7c859f68f8400cf` | Available in runner repo branch; same-process only. |

### Stats Assets

| Package need | Branch or ref | SHA | Status |
|---|---|---|---|
| Universal metric matrix: `src/bsebench_stats/metric_matrix.py` | `origin/phase-8-0-g-universal-stats-metric-matrix` | `646bf3c084cb14aa3270216c6b64b8c42c02f42e` | Available in stats repo branch. |
| Convergence metrics | `origin/phase-8-0-h-universal-stats-convergence-metrics` | `eddb3451ef06c2229d8b4370e66ad14a10fb40e6` | Available in stats repo branch. |
| Robustness noise schema | `origin/phase-8-0-i-universal-stats-robustness-noise-schema` | `0d7e275272cc3955e13d98717fea50dd44b90073` | Available in stats repo branch. |
| Compute-cost aggregator | `origin/phase-8-0-j-universal-stats-compute-cost-aggregator` | `f11a151fc7c07d7c0fc5f0900126becb0e16a441` | Available in stats repo branch. |
| Multi-axis ranking | `origin/phase-8-0-k-universal-stats-multi-axis-ranking` | `f42e0a0bcf0203aab36b1dbdc7127c7cd5deddc4` | Available in stats repo branch. |
| Transfer matrix | `origin/phase-8-0-l-universal-stats-transfer-matrix` | `59dfd52496aec8c946b2d8188774bdb3a6d021e0` | Available in stats repo branch. |

### Dataset Assets

| Package need | Branch or ref | SHA | Status |
|---|---|---|---|
| ETL contract: `src/bsebench_datasets/etl_contract.py` | `origin/phase-8-0-m-universal-datasets-etl-contract` | `6b6bab2df83b8b9c18a01842814c60debda41c9c` | Available in datasets repo branch. |
| Ground-truth audit | `origin/phase-8-0-n-universal-datasets-ground-truth-audit` | `a52c81dd80b8e31de63719fbe874c45a9f68382f` | Available in datasets repo branch. |
| Split metadata: `splits/audit_j_v1.yaml`, `src/bsebench_datasets/splits.py` | `origin/phase-8-0-o-universal-datasets-split-metadata` | `2f0caba08b026cba1c448608394ffc33b1badbc2` | Available in datasets repo branch. |
| Dataset card schema: `src/bsebench_datasets/dataset_card.py` | `origin/phase-8-0-p-universal-datasets-card-schema` | `e5f2305dfc2019d3676224b5409ebc536409b1ed` | Available in datasets repo branch. |
| Equipment registry | `origin/phase-8-0-q-universal-datasets-equipment-registry` | `96566f9bdd1794ccf5d2ece556bd55cdad55ba41` | Available in datasets repo branch. |
| Monthly availability snapshot: `src/bsebench_datasets/availability.py` | `origin/phase-8-0-r-universal-datasets-monthly-availability` | `c1af5d0b4c7fa09c23b8d0c15113c95e570c4fbd` | Available in datasets repo branch. |

## Local-Only Or Pending Assets

These items were observed locally but should not be used as remote release
evidence until pushed or otherwise superseded by an integrated branch.

| Asset | Local ref | SHA | Release status |
|---|---|---|---|
| Cross-repo API contract ledger | `phase-8-4-o-cross-repo-api-contract-ledger-20260507T213125Z` | `69761bf62eb9c27b5d10c98f9d7be8b3497d406c` | Local ref exists at `origin/main` base; no remote branch and no inspected artifact diff. |

## Missing Assets For A Complete Community Package

The package is not complete until these exact assets exist and cross-reference
the available artifacts above.

| Missing asset | Why it matters | Blocking effect |
|---|---|---|
| Filled community estimator submission packet | The template exists, but no real external estimator package with resolved metadata, maintainer, license, code/archive hash, entry point, environment, data use, and requested metrics was inspected. | Blocks real contributor intake. |
| Machine-readable `submission_lifecycle.json` | The lifecycle spec exists, but no concrete per-submission state history, transition artifacts, decisions, and validator outputs were inspected. | Blocks lifecycle replay and monthly inclusion. |
| Static risk report for a concrete submission | The sandbox security audit exists, but no package-specific network/subprocess/file-write/credential scan report was inspected. | Blocks executable submission smoke beyond toy fixtures. |
| Dependency restore record | No lockfile, environment export, container digest, install log, or runtime hash for a real community submission was inspected. | Blocks reproducibility and public execution. |
| Sandboxed smoke bundle | The runner has a toy same-process smoke test; no isolated process/container smoke bundle for public contributor code was inspected. | Blocks public executable intake. |
| Determinism replay report | No fresh-root replay comparison for a concrete submitted estimator was inspected. | Blocks benchmark scheduling for stochastic or stateful methods. |
| Leakage review report for the submitted package | The split guard exists, but no calibration/training/validation/evaluation review for a concrete submission was inspected. | Blocks comparability and leakage gate. |
| Frozen protocol assignment | No per-submission mapping to dataset IDs, split IDs, initialization policy, metric IDs, resource limits, and leakage guard ID was inspected. | Blocks benchmark scheduling. |
| Evidence artifact manifest for the submitted package | No command, config hash, result hash, log hash, environment ref, replay status, and artifact caveat for a concrete run was inspected. | Blocks public values and release freeze. |
| Raw metric table and report bundle | The stats metric assets exist, but no generated community package metric table or report bundle was inspected. | Blocks monthly result row publication. |
| Completed source ledger for external comparisons | Source-ledger schema exists, but no completed DOI/stable URL, retrieval date, metric, dataset, split, reported value, BSEBench value, comparability, and caveat rows were inspected for a real comparison. | Blocks SOTA, novelty, leaderboard, breakthrough, verified-claim, or other comparison language. |
| Frozen monthly snapshot candidate JSON | Monthly schemas exist, but no concrete candidate tying submission, method, dataset, metric, protocol, evidence, result, source-ledger, validation-gate, caveat, and freeze sections was inspected. | Blocks monthly snapshot freeze. |
| Release artifact manifest hash bundle | No package-level manifest listing exact files and SHA256 hashes for the community submission package was inspected. | Blocks immutable release candidate identity. |
| Remaining Wave 5 remote refs | `origin/phase-8-4-o-cross-repo-api-contract-ledger-20260507T213125Z` was absent at final inspection, while `d/e/f/g/h/i/j/k/l/n/p` were available. | Blocks treating the cross-repo API ledger as remote release evidence. |

## Minimum Package Assembly Order

1. Merge or copy the contributor template and validation checklist after
   resolving conflicts with the local Wave 5 docs integration branch.
2. Integrate runner adapter contract, split guard, and toy smoke only after
   runner-focused validation confirms the branch SHAs and tests.
3. Integrate stats metric assets and dataset ETL/split/availability assets only
   after their package-level validators record commands and pass/fail results.
4. Create one filled submission packet for each community estimator.
5. Attach package-specific static risk, dependency restore, sandbox smoke,
   determinism replay, leakage review, protocol assignment, and evidence
   manifest artifacts.
6. Generate raw metric tables and monthly snapshot candidate rows only from
   frozen evidence manifests.
7. Add source-ledger rows only when external comparison text is requested.
8. Freeze the package with an artifact manifest and validation gates before any
   public report prose is drafted.

## Guardrail Status

| Guardrail | Status |
|---|---|
| Protected files | This artifact did not edit thesis files, manuscript files, claim registry files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap. |
| Public claim language | This artifact makes no SOTA, novelty, leaderboard, breakthrough, or verified-claim statement. |
| GLASSBOX preservation | Source branches are referenced by branch and SHA instead of squashing or rewriting their validation context. |
| Integration action | No branch was merged or cherry-picked by this worker because the owned write-set is this index only. |

## Validation Run For This Artifact

Required validation:

```bash
git diff --check
```

Additional inspection commands already run:

```bash
git fetch --all --prune
git branch -r --list 'origin/phase-8-4-*'
git diff --name-status origin/main...origin/phase-8-0-s-universal-async-submission-template
git show origin/phase-8-0-s-universal-async-submission-template:templates/universal-contributor-submission-template.md
git show origin/phase-8-3-m-submission-lifecycle-state-machine-20260507T204627Z:specs/universal/submission-lifecycle-state-machine-20260507T204627Z.md
git show origin/phase-8-3-n-estimator-interface-compatibility-matrix-20260507T204627Z:audits/universal/estimator-interface-compatibility-matrix-20260507T204627Z.md
sed -n '1,260p' /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-a-universal-runner-estimator-plugin-contract/src/bsebench_runner/estimator_contract.py
sed -n '1,260p' /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-f-universal-runner-submission-smoke/tests/test_submission_smoke.py
```

Expected release decision from this index: package assembly can start from the
available assets, but a complete community estimator submission package remains
blocked until the missing concrete submission, execution, evidence, source
ledger, and freeze artifacts are produced.
