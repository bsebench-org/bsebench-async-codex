# GLASSBOX Alpha Release Blocker Dashboard - 2026-05-07

Worker: W7-g
Branch: `phase-8-6-g-alpha-release-blocker-dashboard-20260507T214305Z`
Owned write-set: `dashboards/alpha-release/blocker-dashboard-20260507.md`
Evidence posture: read-only aggregation of local docs, local refs, remote refs,
and existing GLASSBOX artifacts.
Release posture: blocker dashboard only. This artifact does not approve, tag,
publish, freeze, or certify any alpha release.

## Scope

This dashboard aggregates blockers for the universal SOC/SOH benchmark alpha
path across five lanes:

- Integration blockers.
- Claim and public-report blockers.
- Dataset blockers.
- Reproducibility blockers.
- Governance and process blockers.

Unknowns are recorded as unknown. Missing inputs are blockers or follow-up
gates, not inferred pass evidence.

## Evidence Sample

Commands and refs inspected from the W7-g worktree:

```bash
git status --short --branch
git branch --all --verbose --no-abbrev | rg -i 'phase-8|alpha|release|gate|runner|stats|dataset|async|universal'
git diff --name-only origin/main...origin/<phase-8 branch>
git show origin/<branch>:<artifact-path>
sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md
sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md
sed -n '1,220p' docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md
```

Key source artifacts:

| Lane | Ref | Artifact | Status used here |
| --- | --- | --- | --- |
| Runner integration validator | `origin/phase-8-4-e-runner-integration-validator-20260507T213125Z` | `validation/wave-5/runner-integration-validator-20260507T213125Z.md` | Focused pushed-head validation recorded for runner integration head `e0664de6e02dd45832068de427666dbcc2bd3d10`; broader final gates remain residual. |
| Stats integration validator | `origin/phase-8-4-f-stats-integration-validator-20260507T213125Z` | `validation/wave-5/stats-integration-validator-20260507T213125Z.md` | Pushed-head validation recorded for stats integration head `08d7c2cef00a1830ac908310535e2320c41d2276`; full non-slow suite remains residual. |
| Datasets integration validator | `origin/phase-8-4-g-datasets-integration-validator-20260507T213125Z` | `validation/wave-5/datasets-integration-validator-20260507T213125Z.md` | Validator artifact records `PENDING_REMOTE_PUSH`; later red-team observed a pushed head but requires successor replay. |
| Async docs validator | `origin/phase-8-4-h-async-integration-validator-20260507T213125Z` | `validation/wave-5/async-integration-validator-20260507T213125Z.md` | Records pushed docs branch present but blocked by research BRIEF gate failures at sample time. |
| RC manifest | `origin/phase-8-4-k-release-candidate-manifest-20260507T213125Z` | `release/alpha/universal-rc-manifest-20260507T213125Z.md` | Draft manifest marks publication blocked and lists open blockers. |
| Cross-repo contract ledger | `origin/phase-8-4-o-cross-repo-api-contract-ledger-20260507T213125Z` | `ledgers/contracts/cross-repo-api-contract-ledger-20260507T213125Z.md` | Records contract mismatches and pushed integration heads; stats/datasets still need independent pushed-head replay in that ledger. |
| Alpha red-team | `origin/phase-8-5-f-alpha-release-redteam-20260507T213656Z` | `redteam/release/alpha-release-redteam-20260507T213656Z.md` | Publication decision from artifact is blocked. |
| Public claims gate | `origin/phase-8-4-l-public-claims-redline-gate-20260507T213125Z` | `gates/public-claims-redline-gate-20260507T213125Z.md` | Gate design exists; executable scanner is not present in that artifact. |
| Public no-claims checker spec | `origin/phase-8-5-k-public-report-no-claims-checker-spec-20260507T213656Z` | `specs/reports/no-claims-checker-20260507T213656Z.md` | Checker spec exists; implementation remains future work. |
| Compute reproducibility gate | `origin/phase-8-5-g-compute-reproducibility-pr-gate-20260507T213656Z` | `gates/compute/compute-reproducibility-pr-gate-20260507T213656Z.md` | Compute comparison gates defined; public compute aggregation requires tier, scope, backend, hardware, repeat, and caveat fields. |
| Dataset license audit | `origin/phase-8-2-i-data-licensing-availability-audit-20260507T193528Z` | `audits/methodology/data-licensing-availability-20260507T193528Z.md` | Dataset publication states and rights/access blockers defined; current catalog has missing license and redistribution gaps. |
| Repro manifest audit | `origin/phase-8-3-a-retry-repro-artifact-manifest-20260507T204627Z` | `audits/methodology/reproducibility-artifact-manifest-retry-20260507T204627Z.md` | Universal monthly snapshot manifest contract defined; integrated manifest validator not yet implemented. |

## Dashboard Summary

| Lane | Current blocker level | Reason |
| --- | --- | --- |
| Integration | `P0 block` | No assembled, pushed, post-merge validated alpha RC spanning runner, stats, datasets, and async/report refs was observed. |
| Claim and public report | `P0 block` | No completed canonical source ledger, frozen value ledger, comparison ledger, and line/table binding matrix was inspected for any candidate public text. |
| Dataset | `P0 block` | Dataset availability, license, split, ground-truth, cache, and loader-readiness evidence is incomplete for public runnable rows. |
| Reproducibility | `P0 block` | A universal monthly snapshot manifest contract exists, but no integrated snapshot manifest plus validator run was observed. |
| Governance | `P0 block` | Public-release gates are mostly specs and reports; final executable or manual redline signoff for exact public artifacts is missing. |

## P0 Blockers

| ID | Lane | Blocker | Evidence | Required close-out |
| --- | --- | --- | --- | --- |
| ARB-P0-001 | Integration | No assembled alpha RC ref exists across all involved repos and report artifacts. | W5 RC manifest states `alpha-rc-manifest-draft` and publication blocked; W6 alpha red-team says no assembled public release artifact was observed. | Create explicit assembled RC refs or dossier for runner, stats, datasets, and async/report; pin full SHAs and run post-merge gates on those exact refs. |
| ARB-P0-002 | Integration | Dataset integration validation is stale relative to later pushed head evidence. | W5 datasets validator records `PENDING_REMOTE_PUSH`; W6 datasets red-team later observed pushed head `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66` but requires successor replay. | Re-run independent datasets focused and non-slow gates from a clean checkout of the pushed head; record conflict-marker scan and package export checks. |
| ARB-P0-003 | Integration | Async docs integration cannot be used as release approval. | W5 async validator records a gate failure for `check-research-brief-gates.sh` on the pushed docs branch at sample time; W6 async red-team says the validator ref itself contributes no new validation artifact in its sampled refs. | Pin current docs integration SHA, re-run doc/shell/BRIEF/protected-path/claim-language gates, and produce a real validator artifact for the exact ref. |
| ARB-P0-004 | Claim/public report | Public report text lacks completed source, frozen evidence, comparison, and claim-binding ledgers. | W5 public claims gate and W6 alpha red-team both block public comparison or claim-like wording without these ledgers. | Commit canonical ledgers and line/table binding rows for the exact candidate public text, or keep public text limited to neutral status and caveats. |
| ARB-P0-005 | Claim/public report | Public redline gate is design-only, not an executable release preflight. | W5 public claims gate is Markdown; W6 async red-team notes no inspected executable report/text gate. W6 no-claims checker is also a spec. | Implement an executable checker or complete a manual GLASSBOX redline matrix for every exact report, release note, README snippet, table, and caption. |
| ARB-P0-006 | Dataset | Public runnable dataset rows cannot be inferred from catalog or availability metadata. | Dataset license audit reports unknown redistribution rights, missing licenses, Tier 2 incompleteness, local cache gaps, and strict manifest drift. | For each runnable row, record license/access decision, source identity, hashes, loader probe, split/protocol IDs, cache status, and visible caveat. |
| ARB-P0-007 | Dataset | SOC/SOH ground-truth readiness needs target-only and evidence-ready closure. | Datasets red-team identifies `not_applicable` ambiguity, metadata-only OCV/coulomb-counting audits, and target leakage risk. | Require ready ground-truth evidence, target-only truth separation, source-ledger-backed recomputation or metadata-only caveat, and runner-facing leakage tests. |
| ARB-P0-008 | Reproducibility | Universal monthly snapshot manifest and validator are absent as integrated artifacts. | Repro manifest retry audit defines required manifest fields and states the universal monthly snapshot manifest does not yet exist as an integrated artifact. | Add machine-readable manifest, hash every committed artifact, record exact commands and replay results, and run a validator that fails on missing replay/provenance fields. |
| ARB-P0-009 | Metrics/reporting | Public metric tables lack a common release envelope and aggregation closure. | Stats red-team lists missing common report envelope, macro versus pooled ambiguity, compute stratification gaps, and convergence protocol/case preservation gaps. | Require report type, metric family, unit, comparison unit, aggregation policy, failed-row policy, protocol/case IDs, and caveats before any public table. |
| ARB-P0-010 | Compute | Compute rows are not publication-comparable without evidence-tier stratification. | Compute reproducibility PR gate requires tier, scope, backend, hardware/platform, repeat policy, and caveats; runner/stats hooks alone are insufficient. | Add or bind compute evidence records to tiers and group by compatible measurement scopes, backends, hardware profiles, locks, and repeat policies. |

## P1 Blockers

| ID | Lane | Blocker | Evidence | Required close-out |
| --- | --- | --- | --- | --- |
| ARB-P1-001 | Runner | Runner integration still has API boundary and negative-test risks. | Runner red-team notes submodule/root import ambiguity, estimator contract not enforced by `run_benchmark`, split guard opt-in behavior, and positive-only submission smoke. | Add public import contract tests, negative estimator output tests, protocol-driven initialization, split-guard enforcement, and negative submission fixtures. |
| ARB-P1-002 | Stats | Stats pushed-head pass evidence should be refreshed independently. | W5 stats validator records pushed-head validation, but W6 stats red-team still recommends a fresh clean validator pinned to `08d7c2cef00a1830ac908310535e2320c41d2276`. | Re-run focused tests, non-slow suite, export import checks, conflict-marker scan, lint/format, and `git diff --check` from a clean fetched checkout. |
| ARB-P1-003 | Cross-repo contracts | Runner, datasets, and stats contracts do not yet fully align. | Cross-repo ledger records mismatches on `dt_s`, optional SOC/SOH outputs, runner leakage guard coverage, target-signal binding, compute tier fields, and availability semantics. | Resolve or explicitly caveat each mismatch before using the contract set as a release dossier. |
| ARB-P1-004 | Dataset schemas | Dataset identity and target names are fragmented across component schemas. | Datasets red-team reports `dataset_id`, `name`, and `dataset_name` collisions plus target-name ambiguity across ETL, splits, cards, and availability. | Add canonical dataset identity and target-normalization fixtures, including negative mismatched-ID cases. |
| ARB-P1-005 | Access examples | Public examples may depend on credentials or local caches. | Alpha red-team notes prior example review saw authenticated-access failure; dataset audit notes gated and request-based access states. | Keep examples pinned to public mirrors or record exact authenticated/local-cache requirements and mark unauthenticated replay as a gap. |
| ARB-P1-006 | Governance | Forbidden-path and claim-language scans require classification. | Async docs red-team notes raw phrase hits are expected in policy and negative examples; protected-path scan remains hard gate. | Run protected-path scans as hard failures; classify claim-language hits by context and block only unsupported public prose. |

## Unknowns

| ID | Unknown | Why unknown | Required evidence |
| --- | --- | --- | --- |
| ARB-U-001 | Whether Wave 6/7 implementation prototype branches after this dashboard have completed gates. | W7-g sampled local and remote refs visible in this worktree at creation time; other workers may still be active. | Re-fetch and re-run branch diff, changed-path, and gate checks immediately before any merge or publication decision. |
| ARB-U-002 | Whether all runner, stats, and datasets integration branches still point to the sampled SHAs. | Branches moved during earlier validators and red-team sampling. | Pin full SHAs in a release dossier and reject unrecorded head drift. |
| ARB-U-003 | Whether public report candidate text exists. | No generated public alpha report, snapshot JSON, or release note artifact was inspected in W7-g. | Provide exact candidate artifact paths, hashes, source ledgers, and text-binding reviews. |
| ARB-U-004 | Whether dataset licenses/access states changed after the data-rights audit. | Licensing and access are time-sensitive and source-controlled outside this repo. | Re-run source/license retrieval with dated evidence for the release month. |

## Minimum Close-Out Sequence

1. Pin exact runner, stats, datasets, and async/report refs with full SHAs.
2. Re-run repo-specific post-merge gates on assembled refs, not live worker
   worktrees or stale logs.
3. Produce the monthly snapshot manifest with artifact hashes, command records,
   replay results, dataset provenance, metric definitions, caveats, and failure
   rows.
4. Complete dataset license/access/loader/split/cache evidence for every
   runnable dataset row.
5. Complete canonical source ledgers and exact public text bindings, or remove
   public comparison and claim-like language.
6. Run protected-path scans, claim-language classification, `git diff --check`,
   shell gates, schema gates, and conflict-marker scans.
7. Record residual risks and explicit non-claims in the release dossier.

## Non-Claims

This dashboard does not:

- state that an alpha release is ready;
- publish or freeze benchmark results;
- rank methods, datasets, or snapshots;
- compare BSEBench outputs with external results;
- validate SOC/SOH numerical evidence;
- approve dataset redistribution rights;
- edit thesis files, manuscript files, claim registry files,
  `claims/registry.yaml`, `claim_55`, or the scientific roadmap.

## W7-g Validation Plan

Required local validation for this scoped branch:

```bash
git diff --check
git diff --name-only origin/main...HEAD
git diff --name-only origin/main...HEAD | rg '(^|/)(thesis|manuscript|claims/registry\.yaml|claim_55|RESEARCH-ROADMAP)' || true
```

Expected changed path:

```text
dashboards/alpha-release/blocker-dashboard-20260507.md
```
