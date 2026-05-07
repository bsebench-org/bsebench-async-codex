# Phase 8 Merge-Candidate Matrix - 2026-05-07

Worker: W8-e
Branch: `phase-8-7-e-phase8-merge-candidate-matrix-20260507T214728Z`
Scope: current-state validation matrix only.

This matrix separates code integration candidates from report-only support
artifacts. A report-only artifact can be merge-useful while still documenting
that the underlying code, release, public report, or alpha dossier is blocked.
No release approval or scientific-performance claim is inferred from a clean
Markdown/support branch.

## Evidence Rules

- Evidence source: pushed branch heads and explicit validation artifacts only.
- Local-only W6/W7 branches are not counted as merge-ready evidence.
- `merge_tree=clean` means `git merge-tree --write-tree origin/main <branch>`
  exited successfully at the sampled ref.
- `diff_check=pass` means `git diff --check origin/main...<branch>` had no
  whitespace errors at the sampled ref.
- Code-repo checks were read-only against pushed refs in the runner, stats, and
  datasets repositories.

## Current Validation Snapshot

Commands run on 2026-05-07:

| Check | Scope | Result |
| --- | --- | --- |
| `git fetch origin --prune` | async/report repo | pass |
| `git -C bsebench-runner fetch origin --prune` | runner repo | pass |
| `git -C bsebench-stats fetch origin --prune` | stats repo | pass |
| `git -C bsebench-datasets fetch origin --prune` | datasets repo | pass |
| `git merge-tree --write-tree origin/main <branch>` | all pushed async/report Phase 8 W5/W6/W7 refs sampled below | pass |
| `git diff --check origin/main...<branch>` | all pushed async/report Phase 8 W5/W6/W7 refs sampled below | pass |
| `git diff --check origin/main...<branch>` | pushed W5 runner/stats/datasets integration refs | pass |

## W5 Code Integration Candidates

| Worker lane | Target repo | Pushed integration ref | Head | Current mechanical state | Explicit validation evidence | Matrix decision |
| --- | --- | --- | --- | --- | --- | --- |
| W5-01 runner | `bsebench-runner` | `origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z` | `e0664de` | ahead 12, behind 0, `merge_tree=clean`, `diff_check=pass` | W5 runner validator records `PASS_FOCUSED_REMOTE_VALIDATION`; integration commit body records focused, non-slow, ruff, format, and diff checks. W6 runner red-team lists additional promotion gates. | Code merge candidate with replay requirement before final merge. Not alpha/release evidence. |
| W5-02 stats | `bsebench-stats` | `origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` | `08d7c2c` | ahead 13, behind 0, `merge_tree=clean`, `diff_check=pass` | W5 stats validator records pushed-head validation with focused tests, export check, ruff, format, and diff checks. W6 stats red-team marks status `AMBER` and asks for a fresh clean validator pinned to `08d7c2c`. | Conditional code merge candidate. Requires fresh independent replay before treating as final GO evidence. |
| W5-03 datasets | `bsebench-datasets` | `origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z` | `6cbdc54` | ahead 13, behind 0, `merge_tree=clean`, `diff_check=pass` | W5 datasets validator is stale: it records `PENDING_REMOTE_PUSH`. W6 datasets red-team later observes the pushed head and worker-log gates, but explicitly requires successor clean-checkout replay. W7 blocker dashboard marks this as P0 for alpha readiness. | Not ready for code merge based on independent evidence. Needs successor validator on pushed head. |
| W5-04 async/docs | `bsebench-async-codex` | `origin/phase-8-4-d-async-universal-docs-integration-20260507T213125Z` | `52a7b14` | ahead 60, behind 0, `merge_tree=clean`, `diff_check=pass` | W5 async validator records `Status: BLOCKED, not integration-ready` because the pushed target failed `check-research-brief-gates.sh` with 16 failures. W6 async red-team says current whitespace replay is clean but keeps required actions for exact SHA validation. | Not ready for code/docs integration. Needs BRIEF-gate remediation and independent validator refresh. |

## W5 Report-Only Support Artifacts

These refs are useful as support or historical evidence, not as direct code
integration approval.

| Ref | Head | Kind | Current checks | Evidence status | Matrix decision |
| --- | --- | --- | --- | --- | --- |
| `origin/phase-8-4-e-runner-integration-validator-20260507T213125Z` | `f839fd8` | report-only validator | `merge_tree=clean`, `diff_check=pass` | Runner validator records focused remote pass. | Merge candidate as support artifact. |
| `origin/phase-8-4-f-stats-integration-validator-20260507T213125Z` | `ca913c8` | report-only validator | `merge_tree=clean`, `diff_check=pass` | Stats validator records pushed-head pass evidence, with earlier conflict history. | Merge candidate as support artifact, but W6 asks for fresh replay before code GO. |
| `origin/phase-8-4-g-datasets-integration-validator-20260507T213125Z` | `082f4a2` | report-only validator | `merge_tree=clean`, `diff_check=pass` | Stale relative to later pushed datasets head; records pending remote push. | Merge only as historical/blocker evidence; not readiness evidence. |
| `origin/phase-8-4-h-async-integration-validator-20260507T213125Z` | `cb4d01e` | report-only validator | `merge_tree=clean`, `diff_check=pass` | Blocking validator for W5-04 BRIEF-gate failure. | Merge only as blocker evidence; not readiness evidence. |
| `origin/phase-8-4-i-phase8-pr-description-pack-20260507T213125Z` | `3910299` | report-only PR pack | `merge_tree=clean`, `diff_check=pass` | Records validation commands and holds. | Merge candidate as support artifact. |
| `origin/phase-8-4-j-phase8-merge-order-decision-record-20260507T213125Z` | `1ebe518` | report-only decision record | `merge_tree=clean`, `diff_check=pass` | Records merge order, dependencies, rollback gates. | Merge candidate as support artifact. |
| `origin/phase-8-4-k-release-candidate-manifest-20260507T213125Z` | `60649e9` | report-only draft manifest | `merge_tree=clean`, `diff_check=pass` | Manifest marks publication blocked and lists open blockers. | Merge candidate as blocked-state support artifact. |
| `origin/phase-8-4-l-public-claims-redline-gate-20260507T213125Z` | `b76ce09` | report-only gate design | `merge_tree=clean`, `diff_check=pass` | Design artifact; executable gate not proven. | Merge candidate as support artifact, not executable release proof. |
| `origin/phase-8-4-m-community-submission-package-index-20260507T213125Z` | `bb1bad5` | report-only index | `merge_tree=clean`, `diff_check=pass` | Indexes inputs and missing assets. | Merge candidate as support artifact. |
| `origin/phase-8-4-n-monthly-benchmark-dry-run-checklist-20260507T213125Z` | `b24a433` | report-only runbook | `merge_tree=clean`, `diff_check=pass` | Checklist only. | Merge candidate as support artifact. |
| `origin/phase-8-4-o-cross-repo-api-contract-ledger-20260507T213125Z` | `0467688` | report-only ledger | `merge_tree=clean`, `diff_check=pass` | Records cross-repo contract gaps. | Merge candidate as support artifact. |
| `origin/phase-8-4-p-12h-autonomy-scoreboard-20260507T213125Z` | `762a018` | report-only dashboard | `merge_tree=clean`, `diff_check=pass` | Operational scoreboard. | Merge candidate as support artifact. |

## W6 Sidecars

All pushed W6 sidecars sampled below are report-only support artifacts. Their
clean merge/diff state does not override the blockers they document.

| Ref | Head | Kind | Current checks | Evidence status | Matrix decision |
| --- | --- | --- | --- | --- | --- |
| `origin/phase-8-5-a-runner-integration-redteam-20260507T213656Z` | `0ccb47f` | report-only red-team | `merge_tree=clean`, `diff_check=pass` | Lists runner promotion gates and residual API risks. | Merge candidate as support artifact. |
| `origin/phase-8-5-b-stats-integration-redteam-20260507T213656Z` | `f559126` | report-only red-team | `merge_tree=clean`, `diff_check=pass` | Marks stats status `AMBER`; requires fresh clean validator before final GO. | Merge candidate as support artifact; not code GO. |
| `origin/phase-8-5-c-datasets-integration-redteam-20260507T213656Z` | `eaf0bcb` | report-only red-team | `merge_tree=clean`, `diff_check=pass` | Blocks datasets merge/release readiness until successor pushed-head validation. | Merge candidate as blocker evidence. |
| `origin/phase-8-5-d-async-docs-integration-redteam-20260507T213656Z` | `aaa6fe6` | report-only red-team | `merge_tree=clean`, `diff_check=pass` | Records stale evidence and required exact-SHA gates. | Merge candidate as blocker/risk evidence. |
| `origin/phase-8-5-e-universal-schema-diff-matrix-20260507T213656Z` | `b0d9614` | report-only audit | `merge_tree=clean`, `diff_check=pass` | Schema mismatch matrix. | Merge candidate as support artifact. |
| `origin/phase-8-5-f-alpha-release-redteam-20260507T213656Z` | `7d95ca8` | report-only red-team | `merge_tree=clean`, `diff_check=pass` | Publication decision from artifact is `blocked`. | Merge candidate as blocked-state support artifact. |
| `origin/phase-8-5-g-compute-reproducibility-pr-gate-20260507T213656Z` | `84b9ffa` | report-only gate design | `merge_tree=clean`, `diff_check=pass` | Defines compute reproducibility gate. | Merge candidate as support artifact. |
| `origin/phase-8-5-h-dataset-license-redteam-20260507T213656Z` | `17fad26` | report-only red-team | `merge_tree=clean`, `diff_check=pass` | Blocks broad public dataset snapshots without strict license/access proof. | Merge candidate as blocker evidence. |
| `origin/phase-8-5-i-anti-leakage-scenario-catalog-20260507T213656Z` | `34fd501` | report-only catalog | `merge_tree=clean`, `diff_check=pass` | Scenario catalog only. | Merge candidate as support artifact. |
| `origin/phase-8-5-j-submission-adversarial-test-spec-20260507T213656Z` | `4963736` | report-only spec | `merge_tree=clean`, `diff_check=pass` | Defines adversarial submission gates. | Merge candidate as support artifact. |
| `origin/phase-8-5-k-public-report-no-claims-checker-spec-20260507T213656Z` | `d18d94d` | report-only spec | `merge_tree=clean`, `diff_check=pass` | Checker spec only; not executable proof. | Merge candidate as support artifact. |
| `origin/phase-8-5-l-post-merge-ci-triage-runbook-20260507T213656Z` | `e6c81c9` | report-only runbook | `merge_tree=clean`, `diff_check=pass` | CI triage policy. | Merge candidate as support artifact. |

## W7 Sidecars

| Ref | Head | Kind | Current checks | Evidence status | Matrix decision |
| --- | --- | --- | --- | --- | --- |
| `origin/phase-8-6-b-public-claims-linter-prototype-20260507T214305Z` | `e0dcf18` | guardrail prototype code plus validation note | `merge_tree=clean`, `diff_check=pass` | Validation note records shell syntax, pass fixtures, expected-fail fixture, staged scan, and diff checks. | Merge candidate as prototype support. Not final public-report gate. |
| `origin/phase-8-6-e-monthly-snapshot-cli-contract-20260507T214305Z` | `3fd23a7` | report-only contract spec | `merge_tree=clean`, `diff_check=pass` | Contract defines required CLI behavior and blockers. | Merge candidate as support artifact. |
| `origin/phase-8-6-f-dataset-license-clearance-template-20260507T214305Z` | `d9e757c` | report-only template plus validation note | `merge_tree=clean`, `diff_check=pass` | Validation records fail-closed template design and missing license evidence blockers. | Merge candidate as support/blocker artifact. |
| `origin/phase-8-6-g-alpha-release-blocker-dashboard-20260507T214305Z` | `d487120` | report-only dashboard | `merge_tree=clean`, `diff_check=pass` | Dashboard lists P0/P1 blockers and unknowns. | Merge candidate as blocker dashboard, not release approval. |
| `origin/phase-8-6-o-frozen-artifact-hash-manifest-template-20260507T214305Z` | `93f80d4` | report-only template | `merge_tree=clean`, `diff_check=pass` | Template explicitly models missing/unhashable/dirty/provenance/validator blockers. | Merge candidate as support artifact. |
| `origin/phase-8-6-p-external-estimator-security-threat-model-20260507T214305Z` | `5dbe292` | report-only threat model | `merge_tree=clean`, `diff_check=pass` | Threat model records required controls and unknown implementation status. | Merge candidate as support artifact. |

No pushed origin ref was found for these planned W7 sidecars at sampling time:

- `phase-8-6-a-merge-gate-controller-prototype-20260507T214305Z`
- `phase-8-6-c-source-ledger-fixture-pack-20260507T214305Z`
- `phase-8-6-d-submission-contract-golden-examples-20260507T214305Z`
- `phase-8-6-h-integration-pr-bodies-ready-20260507T214305Z`
- `phase-8-6-i-runner-protocol-backcompat-audit-20260507T214305Z`
- `phase-8-6-j-stats-metrics-backcompat-audit-20260507T214305Z`
- `phase-8-6-k-datasets-etl-backcompat-audit-20260507T214305Z`
- `phase-8-6-l-async-docs-gate-replay-20260507T214305Z`
- `phase-8-6-m-universal-v0-acceptance-test-plan-20260507T214305Z`
- `phase-8-6-n-monthly-report-redaction-policy-20260507T214305Z`

Matrix decision for the unpushed sidecars: not ready; no pushed evidence.

## Merge Order Recommendation

1. Merge report-only support artifacts first, preserving blocker wording:
   W5 support reports, W6 red-team/spec/runbook sidecars, and pushed W7
   alpha-readiness support artifacts.
2. Do not use W5-07 or W5-08 as GO evidence. Merge them only if the desired
   history includes stale/blocking validation artifacts.
3. For code integration, prioritize runner and stats only after fresh clean
   replay at the exact pushed heads. Keep datasets and async/docs out of the
   code/docs integration queue until their blocker validators are refreshed.
4. Keep release/public-report gates blocked until an assembled RC ref, frozen
   artifact manifest, source-ledger closure, exact public text review, and
   post-merge validation are recorded.

## Blockers

- W5-03 datasets has a pushed clean branch, but independent validation is stale
  relative to the pushed head.
- W5-04 async/docs has a pushed clean branch, but the explicit W5 validator
  records BRIEF-gate failure.
- W6 and W7 support artifacts document release, dataset-license, source-ledger,
  public-report, and frozen-artifact gaps; those gaps remain blockers for alpha
  readiness.
- Several planned W7 sidecars have no pushed origin refs and therefore cannot
  be counted as current merge candidates.
