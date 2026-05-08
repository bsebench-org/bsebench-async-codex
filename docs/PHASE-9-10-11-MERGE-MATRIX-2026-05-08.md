# Phase 9/10/11 Merge Matrix - 2026-05-08

Generated at `2026-05-08T21:22:11+02:00` after read-only
`git fetch origin --prune` on the Phase 9/10/11 target repos. No merge
action was performed.

## Scope And Evidence Stance

- Scope: Phase 9/10/11 only. Later-phase branches are excluded from this
  matrix and validation order.
- Do-not-merge instruction: yes.
- Scientific closure status: NO-GO.
- Fail-closed evidence gates: cache/provenance/Tier2; source-ledger;
  empirical-run.
- A branch with clean `git merge-tree --write-tree origin/main <branch>` output
  is only conflict-clean against the current fetched baseline. It is not
  scientifically ready unless the evidence gates above are satisfied.
- Current local working copies for datasets, runner, stats, specs, and filters
  were behind their fetched `origin/main`; this matrix uses fetched refs and
  does not pull or alter those worktrees.
- Refill branches listed here are branch-level artifacts only. They do not
  replace the evidence gates above.

## Validation Order

| Step | Gate | Required result before moving on |
|---:|---|---|
| 1 | Scope guard | Confirm the branch is Phase 9/10/11-only and does not touch thesis, roadmap, protected registry, or protected claim files. |
| 2 | Freshness check | Re-run `git fetch origin --prune` and record the exact branch SHA under review. |
| 3 | Conflict rehearsal | Run `git merge-tree --write-tree origin/main <branch>`; any conflict row below must be rebased or superseded before validation. |
| 4 | Repo-local validation | Run the branch-owned focused tests, repo smoke tests, lint/format checks where available, and `git diff --check`. |
| 5 | Cross-repo contract check | Validate datasets -> runner -> stats -> specs/filter contract compatibility using the same branch SHAs in this matrix. |
| 6 | Evidence gate | Require cache/provenance/Tier2, source-ledger, and empirical-run evidence. Missing evidence keeps scientific closure at NO-GO. |
| 7 | Coordinator review | Review async checkpoint, blocker board, coordinator, and closure-plan branches only after steps 1-6 pass. |

## Repository Baselines

| Repo | fetched `origin/main` | Baseline note |
|---|---:|---|
| `bsebench-async-codex` | `989ab3c` | Async orchestration baseline. |
| `bsebench-datasets` | `88a9096` | Contains newer integration; use only as conflict baseline here. |
| `bsebench-runner` | `bcba5d1` | Contains newer integration; use only as conflict baseline here. |
| `bsebench-stats` | `6b09b1f` | Contains newer integration; use only as conflict baseline here. |
| `bsebench-specs` | `51917f0` | Contains newer integration; use only as conflict baseline here. |
| `bsebench-filters` | `8a36493` | Contains newer integration; use only as conflict baseline here. |

## Branch Matrix

| ID | Repo | Branch | SHA | Merge-tree state | Gate state | Action |
|---|---|---|---:|---|---|---|
| P9-DATASET-READINESS | `bsebench-datasets` | `phase-9-datasets-profile-axis-readiness-20260508T1028` | `f6e2ddc` | conflict: `src/bsebench_datasets/__init__.py` | Profile-axis readiness candidate; cache/provenance/Tier2 evidence still required. | Rebase before validation. |
| P9-DATASET-TIER2 | `bsebench-datasets` | `phase9-profile-tier2-cache-remediation-20260508T204118+0200` | `3f5eba5` | clean | Cache/provenance/Tier2 tooling candidate; source-ledger and empirical-run evidence still absent. | Validate only. |
| P9-DATASET-REFILL-TIER2-A | `bsebench-datasets` | `phase9-11-refill-p9-tier2-profile-cache-20260508T205326+0200` | `9b81ec7` | clean | Refill cache/provenance/Tier2 audit candidate; does not provide empirical-run evidence. | Validate with P9 dataset readiness. |
| P9-DATASET-REFILL-TIER2-B | `bsebench-datasets` | `phase9-11-refill-p9-tier2-profile-cache-20260508T205825+0200` | `0c2ee42` | conflict: `src/bsebench_datasets/__init__.py` | Refill cache/provenance/Tier2 audit candidate; conflict blocks validation. | Rebase before validation. |
| P9-RUNNER-INVENTORY | `bsebench-runner` | `phase-9-runner-profile-axis-inventory-20260508T123659Z` | `c7ebe71` | clean | Dry-run metadata inventory candidate; no empirical-run evidence. | Validate only. |
| P9-RUNNER-BUDGET | `bsebench-runner` | `phase-9-runner-profile-dispatch-budget-20260508T125510Z` | `9a1ff17` | clean | Dry-run scheduling guard candidate; no empirical-run evidence. | Validate after P9 runner inventory and stats comparability. |
| P9-RUNNER-EMPIRICAL-SCHEDULER | `bsebench-runner` | `phase9-empirical-runner-scheduler-20260508T204118+0200` | `51f7357` | clean | Scheduler candidate only; does not provide empirical-run evidence. | Validate after P9 cache/provenance/Tier2 gate. |
| P9-RUNNER-REFILL-SCHEDULER-A | `bsebench-runner` | `phase9-11-refill-p9-profile-empirical-scheduler-20260508T205557+0200` | `6450c02` | clean | Refill scheduler candidate only; does not provide empirical-run evidence. | Validate after P9 cache/provenance/Tier2 gate. |
| P9-RUNNER-REFILL-SCHEDULER-B | `bsebench-runner` | `phase9-11-refill-p9-profile-empirical-scheduler-20260508T205841+0200` | `2448e1a` | clean | Refill scheduler candidate only; does not provide empirical-run evidence. | Validate after P9 cache/provenance/Tier2 gate. |
| P9-STATS-COMPARABILITY | `bsebench-stats` | `phase-9-stats-profile-comparability-20260508T123659Z` | `4727da9` | clean | Comparability contract candidate; source-ledger and empirical-run evidence still required for verdict work. | Validate with P9 runner inventory output. |
| P9-STATS-VERDICT-INPUTS | `bsebench-stats` | `phase9-profile-verdict-inputs-20260508T204536+0200` | `e3d7dcb` | clean | Verdict-input validator candidate; scientific closure remains NO-GO. | Validate after empirical-run and source-ledger gates. |
| P9-STATS-REFILL-VERDICT-INPUTS | `bsebench-stats` | `phase9-11-refill-p9-profile-verdict-inputs-20260508T205859+0200` | `9275082` | clean | Refill verdict-input validator candidate; scientific closure remains NO-GO. | Validate after empirical-run and source-ledger gates. |
| P9-SPECS-SCHEMA | `bsebench-specs` | `phase-9-specs-profile-axis-schema-20260508T1040` | `5a292d1` | conflict: `scripts/export_schemas.py`, `src/bsebench_specs/__init__.py`, `tests/test_schema_export.py` | Schema candidate; conflict blocks validation. | Rebase before validation. |
| P9-FILTERS-SMOKE | `bsebench-filters` | `phase-9-filters-profile-axis-smoke-20260508T1040` | `c8bf72c` | conflict: `src/bsebench_filters/contract.py`, `src/bsebench_filters/smoke_contract.py` | Filter smoke candidate; conflict blocks validation. | Rebase before validation. |
| P10-DATASET-READINESS | `bsebench-datasets` | `phase-10-datasets-aging-readiness-gate-20260508T123659Z` | `e6f2bc7` | clean | Aging/SOH readiness gate candidate; cache/provenance/Tier2 evidence still required. | Validate only. |
| P10-DATASET-TIER2 | `bsebench-datasets` | `phase10-aging-tier2-cache-remediation-20260508T204118+0200` | `e7ed5ad` | clean | Cache/provenance/Tier2 tooling candidate; source-ledger and empirical-run evidence still absent. | Validate after P10 readiness gate. |
| P10-DATASET-REFILL-TIER2 | `bsebench-datasets` | `phase9-11-refill-p10-tier2-aging-cache-20260508T205829+0200` | `aec5907` | clean | Refill cache/provenance/Tier2 audit candidate; does not provide empirical-run evidence. | Validate after P10 readiness gate. |
| P10-RUNNER-BUDGET | `bsebench-runner` | `phase-10-runner-aging-predispatch-budget-20260508T123659Z` | `1fcd18d` | clean | Dry-run budget candidate; no empirical-run evidence. | Validate after P10 dataset readiness. |
| P10-RUNNER-EMPIRICAL-SCHEDULER | `bsebench-runner` | `phase10-aging-empirical-scheduler-20260508T204536+0200` | `4cd7130` | clean | Scheduler candidate only; does not provide empirical-run evidence. | Validate after P10 cache/provenance/Tier2 gate. |
| P10-RUNNER-REFILL-SCHEDULER-A | `bsebench-runner` | `phase9-11-refill-p10-aging-empirical-scheduler-20260508T205600+0200` | `a2c7cac` | clean | Refill scheduler candidate only; does not provide empirical-run evidence. | Validate after P10 cache/provenance/Tier2 gate. |
| P10-RUNNER-REFILL-SCHEDULER-B | `bsebench-runner` | `phase9-11-refill-p10-aging-empirical-scheduler-20260508T205847+0200` | `cbdea4b` | clean | Refill scheduler candidate only; does not provide empirical-run evidence. | Validate after P10 cache/provenance/Tier2 gate. |
| P10-STATS-INVARIANCE | `bsebench-stats` | `phase-10-stats-aging-invariance-contract-20260508T125510Z` | `d550366` | clean | Stats contract candidate; source-ledger and empirical-run evidence still required for verdict work. | Validate with P10 dataset and runner outputs. |
| P10-STATS-VERDICT-INPUTS | `bsebench-stats` | `phase10-aging-verdict-inputs-20260508T204536+0200` | `5c52ad5` | clean | Verdict-input validator candidate; scientific closure remains NO-GO. | Validate after empirical-run and source-ledger gates. |
| P10-STATS-REFILL-VERDICT-INPUTS | `bsebench-stats` | `phase9-11-refill-p10-aging-verdict-inputs-20260508T205905+0200` | `6d0eb61` | clean | Refill verdict-input validator candidate; scientific closure remains NO-GO. | Validate after empirical-run and source-ledger gates. |
| P10-SPECS-SCHEMA | `bsebench-specs` | `phase-10-specs-aging-soh-schema-20260508T1037` | `d308d74` | conflict: `scripts/export_schemas.py`, `src/bsebench_specs/__init__.py` | Schema candidate; conflict blocks validation. | Rebase before validation. |
| P10-FILTERS-SMOKE | `bsebench-filters` | `phase-10-filters-aging-soh-smoke-20260508T1037` | `d2d9251` | conflict: `src/bsebench_filters/contract.py`, `src/bsebench_filters/smoke_contract.py` | Filter smoke candidate; conflict blocks validation. | Rebase before validation. |
| P11-DATASET-SOURCE | `bsebench-datasets` | `phase-11-datasets-residual-source-readiness-20260508T1040` | `eb0f4bb` | conflict: `src/bsebench_datasets/__init__.py` | Residual-source readiness candidate; cache/provenance/Tier2 evidence still required. | Rebase before validation. |
| P11-DATASET-TIER2 | `bsebench-datasets` | `phase11-residual-tier2-cache-remediation-20260508T204118+0200` | `5cbf704` | clean | Cache/provenance/Tier2 tooling candidate; source-ledger and empirical-run evidence still absent. | Validate after P11 dataset source readiness. |
| P11-DATASET-REFILL-TIER2-A | `bsebench-datasets` | `phase9-11-refill-p11-tier2-residual-cache-20260508T205555+0200` | `71b5fed` | clean | Refill cache/provenance/Tier2 audit candidate; does not provide empirical-run evidence. | Validate after P11 dataset source readiness. |
| P11-DATASET-REFILL-TIER2-B | `bsebench-datasets` | `phase9-11-refill-p11-tier2-residual-cache-20260508T205835+0200` | `a3490d0` | clean | Refill cache/provenance/Tier2 audit candidate; does not provide empirical-run evidence. | Validate after P11 dataset source readiness. |
| P11-RUNNER-INPUT | `bsebench-runner` | `phase-11-runner-residual-input-contract-20260508T123659Z` | `933c29b` | conflict: `scripts/phase11_residual_input_contract.py`, `src/bsebench_runner/residual_input_contract.py`, `tests/test_phase11_residual_input_contract.py` | Residual input contract candidate; conflict blocks validation. | Rebase before validation. |
| P11-RUNNER-DRYRUN | `bsebench-runner` | `phase-11-runner-residual-dryrun-manifest-20260508T125510Z` | `ecd365a` | clean | Dry-run manifest candidate; no empirical-run evidence. | Validate after P11 runner input and stats decomp contracts. |
| P11-RUNNER-TRACE-SCHEDULER | `bsebench-runner` | `phase11-residual-trace-scheduler-20260508T204118+0200` | `e5b3dc9` | clean | Scheduler candidate only; does not provide empirical-run evidence. | Validate after P11 cache/provenance/Tier2 gate. |
| P11-RUNNER-REFILL-TRACE-SCHEDULER | `bsebench-runner` | `phase9-11-refill-p11-residual-trace-scheduler-20260508T205853+0200` | `36ceeeb` | clean | Refill scheduler candidate only; does not provide empirical-run evidence. | Validate after P11 cache/provenance/Tier2 gate. |
| P11-STATS-DECOMP | `bsebench-stats` | `phase-11-stats-residual-decomp-contract-20260508T123659Z` | `a9a0756` | clean | Stats decomposition contract candidate; source-ledger and empirical-run evidence still required for verdict work. | Validate with P11 runner dry-run output. |
| P11-STATS-VERDICT-INPUTS | `bsebench-stats` | `phase11-residual-verdict-inputs-20260508T204536+0200` | `6983bf9` | clean | Verdict-input preflight candidate; scientific closure remains NO-GO. | Validate after empirical-run and source-ledger gates. |
| P11-STATS-REFILL-VERDICT-INPUTS | `bsebench-stats` | `phase9-11-refill-p11-residual-verdict-inputs-20260508T205909+0200` | `592f052` | clean | Refill verdict-input validator candidate; scientific closure remains NO-GO. | Validate after empirical-run and source-ledger gates. |
| P11-SPECS-SCHEMA | `bsebench-specs` | `phase-11-specs-residual-contract-schema-20260508T1020` | `dc459b1` | conflict: `scripts/export_schemas.py`, `src/bsebench_specs/__init__.py`, `tests/test_schema_export.py` | Schema candidate; conflict blocks validation. | Rebase before validation. |
| P11-FILTERS-OUTPUT | `bsebench-filters` | `phase-11-filters-residual-output-contract-20260508T1040` | `f858009` | clean | Filter output contract candidate; no empirical-run evidence. | Validate after P11 specs schema is conflict-clean. |
| X-DATASETS-GAP-AUDIT | `bsebench-datasets` | `phase-9-11-datasets-final-gap-audit-20260508T203558+0200` | `7ebe748` | clean | Gap-audit candidate; records blockers but does not close evidence gates. | Validate after dataset rows above. |
| X-DATASETS-INTEGRATION | `bsebench-datasets` | `integrate/phase9-10-11-final-20260508T133442Z` | `0a5f8e9` | clean | Prior integration candidate; must be rechecked against new Tier2 remediation rows. | Validate only after all dataset conflicts are resolved. |
| X-RUNNER-GAP-AUDIT | `bsebench-runner` | `phase-9-11-runner-final-gap-audit-20260508T203558+0200` | `0d94f1b` | clean | Gap-audit candidate; records blockers but does not close evidence gates. | Validate after runner rows above. |
| X-RUNNER-INTEGRATION | `bsebench-runner` | `integrate/phase9-10-11-final-20260508T133442Z` | `f8fb60f` | clean | Prior integration candidate; must be rechecked against empirical scheduler rows. | Validate only after P11 input conflict is resolved. |
| X-RUNNER-REFILL-SMOKE | `bsebench-runner` | `phase9-11-refill-p9-11-dryrun-cli-smoke-20260508T210806+0200` | `7971263` | clean | Dry-run CLI smoke candidate; branch-level validation only. | Validate before empirical scheduler rows. |
| X-STATS-GAP-AUDIT | `bsebench-stats` | `phase-9-11-stats-final-gap-audit-20260508T203558+0200` | `009a848` | clean | Gap-audit candidate; records blockers but does not close evidence gates. | Validate after stats rows above. |
| X-STATS-INTEGRATION | `bsebench-stats` | `integrate/phase9-10-11-final-20260508T133442Z` | `b929c8f` | clean | Prior integration candidate; must be rechecked against verdict-input rows. | Validate after all stats rows above. |
| X-STATS-REFILL-LANGUAGE | `bsebench-stats` | `phase9-11-refill-p9-11-no-claims-linter-20260508T210820+0200` | `26db49e` | clean | Language linter candidate; branch-level validation only. | Validate before verdict-input rows. |
| X-SPECS-GAP-AUDIT | `bsebench-specs` | `phase-9-11-specs-final-gap-audit-20260508T203723+0200` | `e2180d9` | clean | Gap-audit candidate; records blockers but does not close evidence gates. | Validate after specs conflicts are resolved. |
| X-SPECS-INTEGRATION | `bsebench-specs` | `integrate/phase9-10-11-final-20260508T133442Z` | `4955754` | clean | Prior integration candidate; must be rechecked against schema-export audit. | Validate after specs conflicts are resolved. |
| X-SPECS-REFILL-SCHEMA-EXPORT | `bsebench-specs` | `phase9-11-refill-p9-11-schema-export-audit-20260508T205913+0200` | `7be3c02` | conflict: `tests/test_schema_export.py` | Refill schema-export audit candidate; conflict blocks validation. | Rebase before validation. |
| X-FILTERS-GAP-AUDIT | `bsebench-filters` | `phase-9-11-filters-final-gap-audit-20260508T203723+0200` | `5dc6daa` | clean | Gap-audit candidate; records blockers but does not close evidence gates. | Validate after filter conflicts are resolved. |
| X-FILTERS-INTEGRATION | `bsebench-filters` | `integrate/phase9-10-11-final-20260508T133442Z` | `1117d17` | clean | Prior integration candidate; must be rechecked against filter smoke/output rows. | Validate after filter conflicts are resolved. |
| X-FILTERS-REFILL-CONTRACT-EXPORT | `bsebench-filters` | `phase9-11-refill-p9-11-contract-export-audit-20260508T205915+0200` | `88bca3f` | clean | Refill contract/export audit candidate; branch-level validation only. | Validate with filter rows above. |
| X-ASYNC-CHECKPOINT | `bsebench-async-codex` | `phase9-11-refill-p9-11-checkpoint-report-20260508T205916+0200` | `4c6935f` | clean | Checkpoint report candidate; should stay conservative and evidence-gated. | Validate with async doc guard scripts. |
| X-ASYNC-BLOCKER-BOARD | `bsebench-async-codex` | `phase9-11-blocker-board-20260508T204118+0200` | `828583b` | clean | Blocker-board candidate; should not override evidence gates. | Validate after repo rows above are refreshed. |
| X-ASYNC-FINAL-MERGE-COORDINATOR | `bsebench-async-codex` | `phase9-11-final-merge-coordinator-20260508T204536+0200` | `6c4e86d` | clean | Coordinator candidate; records order only. | Hold until conflicts and evidence gaps are resolved. |
| X-ASYNC-CLOSURE-PLAN | `bsebench-async-codex` | `phase9-11-closure-pr-plan-20260508T204815+0200` | `361be4f` | clean | Closure-plan candidate; should remain a plan, not a result assertion. | Hold until conflicts and evidence gaps are resolved. |
| X-ASYNC-FINAL-SYNTHESIS | `bsebench-async-codex` | `phase-9-10-11-final-synthesis-20260508T203723+0200` | `b414fa4` | clean | Synthesis candidate; scientific closure remains NO-GO. | Hold until all evidence gates pass. |
| X-ASYNC-VERDICT-P9 | `bsebench-async-codex` | `phase-9-final-verdict-20260508T203558+0200` | `e51e724` | clean | Verdict document candidate; missing evidence keeps closure NO-GO. | Hold until P9 empirical-run and source-ledger gates pass. |
| X-ASYNC-VERDICT-P10 | `bsebench-async-codex` | `phase-10-final-verdict-20260508T203558+0200` | `bbc7883` | clean | Verdict document candidate; missing evidence keeps closure NO-GO. | Hold until P10 empirical-run and source-ledger gates pass. |
| X-ASYNC-VERDICT-P11 | `bsebench-async-codex` | `phase-11-final-verdict-20260508T203558+0200` | `ff18c52` | clean | Verdict document candidate; missing evidence keeps closure NO-GO. | Hold until P11 empirical-run and source-ledger gates pass. |
| X-ASYNC-EVIDENCE-LANGUAGE-AUDIT | `bsebench-async-codex` | `phase-9-10-11-anti-hallucination-audit-20260508T203801+0200` | `a513272` | clean | Language audit candidate; should enforce conservative wording. | Validate before any verdict document is considered. |
| X-ASYNC-ACCEPTANCE-GATE | `bsebench-async-codex` | `phase9-11-refill-p9-11-acceptance-gate-20260508T210932+0200` | `1d19c79` | clean | Acceptance-gate candidate; should keep tooling closure separate from scientific closure. | Validate after matrix and blocker-board review. |
| X-ASYNC-ANTI-CLAIM-AUDIT | `bsebench-async-codex` | `phase9-11-refill-p9-11-anti-claim-audit-20260508T210338+0200` | `feff1d6` | clean | Anti-claim audit candidate; branch-level validation only. | Validate before verdict documents. |
| X-ASYNC-PREVIOUS-MATRIX | `bsebench-async-codex` | `phase9-11-refill-p9-11-merge-matrix-20260508T210324+0200` | `052b958` | clean | Previous merge-matrix candidate; superseded by this refreshed baseline if this branch is accepted. | Validate only if needed for comparison. |

## Blockers

- Conflict blockers: the conflict rows above must be rebased or superseded
  before they can enter repo-local validation.
- Evidence blockers: cache/provenance/Tier2, source-ledger, and empirical-run
  evidence are not proven by this matrix. Scientific closure remains NO-GO.
- Sequencing blocker: prior integration branches must be rechecked after the
  newer Tier2 remediation, empirical scheduler, and verdict-input validator
  branches are validated.
- Baseline blocker: several fetched `origin/main` refs include newer
  integration, so validation must separate conflict mechanics from scientific
  acceptance and keep this work Phase 9/10/11-only.
