# GLASSBOX Phase 8 Alpha Risk Register - 2026-05-07

- Worker: W9-e
- Branch: `phase-8-8-e-phase8-risk-register-20260507T215348Z`
- Owned write-set: `risk/phase8/phase8-alpha-risk-register-20260507.md`
- Evidence posture: current risk register from pushed Wave 5 integration evidence, Wave 6 sidecars, Wave 7 alpha-readiness artifacts, and Wave 8 validation reports available at sampling time.
- Release posture: risk register only. This file does not approve an alpha release, merge integration branches, publish benchmark results, or register any scientific claim.

## Scope And Evidence

This register covers six Phase 8 alpha lanes: integration, license/access,
source ledger, compute reproducibility, claims wording, and governance. It is
intended to be useful before integration is merged. Unknown evidence is treated
as a blocker or follow-up gate, not as pass evidence.

Primary evidence inspected:

| Evidence | Ref or path | Current use |
| --- | --- | --- |
| W8 async docs validation | `origin/phase-8-7-a-async-docs-current-validation-20260507T214728Z:validation/wave-8/async-docs-current-validation-20260507.md` | Docs integration branch exists and range whitespace checks pass, but broad research-brief gate remains blocked by 16 legacy backlog brief failures. |
| W8 datasets validation | `origin/phase-8-7-b-datasets-current-validation-20260507T214728Z:validation/wave-8/datasets-current-validation-20260507.md` | Datasets integration head `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66` is fetchable; focused tests passed when tools were supplied ephemerally; raw loader sweep not run. |
| W8 stats/datasets cross-validation | `origin/phase-8-7-c-stats-datasets-cross-validation-20260507T214728Z:validation/wave-8/stats-datasets-cross-validation-20260507.md` | Stats head `08d7c2cef00a1830ac908310535e2320c41d2276` and datasets head `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66` are fetchable descendants with clean diff checks and no conflict markers in scoped paths. |
| W8 W6 closure audit | `origin/phase-8-7-d-w6-remaining-closure-audit-20260507T214728Z:validation/wave-8/w6-remaining-closure-audit-20260507.md` | All Wave 6 sidecars were closed as artifacts; W6-03, W6-05, and W6-08 remain downstream-blocked. Several sidecars are specs only. |
| W7 alpha blocker dashboard | `origin/phase-8-6-g-alpha-release-blocker-dashboard-20260507T214305Z:dashboards/alpha-release/blocker-dashboard-20260507.md` | Records P0 blocks across integration, claims/public report, datasets, reproducibility, and governance. No assembled alpha RC observed. |
| W7 acceptance test plan | `origin/phase-8-6-m-universal-v0-acceptance-test-plan-20260507T214305Z:specs/alpha/universal-v0-acceptance-test-plan-20260507.md` | Defines fail-closed acceptance gates; most lanes are testable in parts but blocked without assembled refs, frozen artifacts, and replay. |
| W7 license template validation | `origin/phase-8-6-f-dataset-license-clearance-template-20260507T214305Z:validation/wave-7/dataset-license-clearance-template-20260507.md` | Defines fail-closed license/access template; no source-specific upstream clearance records were available in the async report repo. |
| W7 public claims linter prototype | `origin/phase-8-6-b-public-claims-linter-prototype-20260507T214305Z:validation/wave-7/public-claims-linter-prototype-20260507.md` | Wording checker prototype exists; it does not inspect scientific evidence or claim registries. |
| Source-ledger fixture work | `outbox/phase-7-10-p-async-source-ledger-comparability-fixtures/SUMMARY.md` | Synthetic source-ledger comparability fixtures and checker passed, but real source ledgers remain absent from inspected alpha evidence. |
| Phase 8 cache probe | `outbox/phase-7-10-i-datasets-phase8-cache-probe/SUMMARY.md` | Availability buckets distinguish ready, missing, unreadable, and unknown metadata. |
| Compute and manifest drift work | `outbox/phase-7-10-b-runner-hinf-determinism-ci-summary/SUMMARY.md`, `outbox/phase-7-10-k-runner-hinf-manifest-drift-audit/SUMMARY.md` | Hash, manifest-link, non-finite JSON, and guardrail wording audits passed for their scoped Hinf evidence artifacts. |

## Severity Scale

| Severity | Meaning |
| --- | --- |
| P0 | Blocks alpha RC review or public-facing use until closed or explicitly excluded. |
| P1 | Blocks broad alpha confidence; may allow limited internal review with visible caveat. |
| P2 | Operational or documentation risk that should be closed before external expansion. |

## Risk Register

| ID | Lane | Severity | Risk | Current evidence, not claim | Owner | Action | Exit criterion |
| --- | --- | --- | --- | --- | --- | --- | --- |
| P8-RISK-001 | Integration | P0 | No assembled alpha RC ref spanning runner, stats, datasets, and async/report artifacts. | W7-g and W7-m both record no assembled pushed alpha refs. W8 validations check individual heads only. | Release integrator | Create explicit RC dossier with full SHAs for all participating repos and async/report artifacts. | Dossier contains fetchable full SHAs, changed-file surfaces, validation commands, pass/fail status, artifact hashes, and residual blockers for every participating ref. |
| P8-RISK-002 | Integration | P0 | Post-merge validation is incomplete because current evidence is branch-head or focused replay, not final assembled-tree replay. | W8-b focused datasets tests passed in an archive with `60 passed`, but raw loader sweep was not run. W8-c did not rerun full source suites. W8-a docs broad brief gate remains blocked. | Repo validators | Run post-merge or assembled-ref validation for runner, stats, datasets, and async/report from clean checkouts. | Non-slow tests, lint/format where applicable, `git diff --check`, conflict-marker scans, protected-path scans, and documented skip/blocker reasons pass on exact assembled refs. |
| P8-RISK-003 | Integration | P1 | Cross-repo contract drift can survive isolated branch validation. | W8-c carries W6/W7 cautions around API boundaries, dataset identity, target binding, `dt_s`, compute fields, and availability semantics. | Cross-repo contract owner | Reconcile runner/stats/datasets contract ledger against current integration heads. | Contract matrix records every field owner, schema version, required/optional status, negative fixture, and downstream consumer before alpha RC review. |
| P8-RISK-004 | License/access | P0 | Public runnable dataset rows may imply access or redistribution rights that are not cleared. | W7-f license validation says source-specific upstream clearance records are absent in the async report repo and unknown redistribution must fail closed. W8-d marks W6-08 downstream blocked. | Dataset/license owner | Complete per-dataset clearance records with source URL, retrieval date, terms, raw and derived redistribution decisions, attribution, and reviewer. | Every public row has a dated clearance decision; unknown, contradictory, expired, gated, or missing evidence rows are excluded or visibly marked blocked. |
| P8-RISK-005 | License/access | P1 | Local cache readiness may be mistaken for public availability. | Phase 8 cache probe distinguishes ready, missing, unreadable, and unknown metadata; W7-f requires caveats for non-redistributed or aggregate-only datasets. | Dataset availability owner | Bind cache status to release rows separately from license/access status. | Release dossier has separate fields for source access, raw redistribution, derived redistribution, local cache status, loader probe status, and public caveat text. |
| P8-RISK-006 | Source ledger | P0 | Public comparison or claim-like text lacks real source, frozen value, comparability, and line/table binding ledgers. | W7-g records this as a P0 blocker. Phase 7-10-p added synthetic comparability fixtures only; no real alpha source-ledger bundle was inspected. | Source-ledger owner | Build canonical ledgers for exact public artifacts or remove comparison-style wording. | Each public table, caption, and comparison sentence has source IDs, retrieval dates, metric/dataset/split/method basis, comparability status, frozen value, and binding to exact text lines. |
| P8-RISK-007 | Source ledger | P1 | Synthetic source-ledger fixtures may be overinterpreted as evidence readiness. | Phase 7-10-p explicitly uses synthetic fixture values and says they are not literature evidence. | Async gate owner | Keep fixture checks labeled as schema/gate tests only. | Release dossier separates fixture validation from real source evidence and blocks any public source comparison without real ledger rows. |
| P8-RISK-008 | Compute reproducibility | P0 | Compute rows are not comparable without evidence-tier and environment stratification. | W7-g and W7-m require tier, scope, backend, hardware/platform, repeat policy, and caveats. Current evidence shows gate specs and scoped audits, not a complete alpha compute dossier. | Compute evidence owner | Define and populate compute evidence records for every reported compute field. | Every compute row has runtime unit, clock source, memory backend or unavailable reason, hardware/platform, repeat count, scope, backend, lockfile status, and caveat. |
| P8-RISK-009 | Compute reproducibility | P1 | Frozen artifact and replay links are incomplete for monthly snapshot-style alpha output. | W7-m marks frozen monthly snapshot artifact blocked. W7-g records no integrated snapshot manifest plus validator run. | Reproducibility owner | Create snapshot or explicitly exclude snapshot from alpha scope; hash committed artifacts. | Snapshot JSON/report/freeze record exists with SHA-256 hashes, generation commands, replay results, repo refs, caveats, and validator output, or the release dossier states no snapshot is included. |
| P8-RISK-010 | Claims wording | P0 | Public text may contain unsupported comparison or promotional language before evidence and binding are complete. | W7-b public wording prototype passed fixture tests but is a text prototype only. Phase 7-10-j adds another claim-language linter for async briefs; neither validates scientific evidence. | Public text owner | Run wording scans on exact release notes, README snippets, tables, captions, reports, and docs; classify each hit. | Exact public artifacts have scan output plus manual classification; unsupported public prose is removed or blocked, while policy/example hits are documented as non-public guardrail context. |
| P8-RISK-011 | Claims wording | P1 | Guardrail linter false positives or false negatives can produce either noisy gates or missed unsupported wording. | W7-b same-line context rule is conservative and does not inspect registries or external papers. | Claims gate owner | Pair automated scans with manual redline matrix for exact artifacts. | Redline matrix records file, line, phrase, context, disposition, reviewer, and source-ledger binding or removal action. |
| P8-RISK-012 | Governance | P0 | Public-release gates are mostly specs/reports until executable or signed manual gates run on exact artifacts. | W8-d says several W6 sidecars are specifications or runbooks only. W7-g governance lane is P0 blocked. | Release manager | Convert gate specs into executable checks or mandatory GLASSBOX signoff forms before RC review. | RC dossier includes executed gate outputs or signed manual reviews for claims wording, protected paths, license/access, source ledger, compute evidence, snapshot manifest, and post-merge CI triage. |
| P8-RISK-013 | Governance | P1 | Branch-head drift can invalidate sampled validation evidence. | W7-g unknowns note branches moved during earlier sampling and require refetch before decisions. W8-c says any newer stats/datasets SHA requires replay. | Merge queue owner | Pin and freeze validation refs immediately before merge or alpha RC review. | `git fetch --prune`, full SHA pinning, diff hygiene, and validation replay are recorded after any head movement and before relying on evidence. |
| P8-RISK-014 | Governance | P1 | Protected-path or forbidden-edit violations could enter via integration pressure. | Current Wave 8 reports include protected-path scans where scoped. This W9-e task is limited to the risk register only. | Gatekeeper | Keep protected-path scans hard-fail for thesis, manuscript, claim registry, `claims/registry.yaml`, `claim_55`, roadmap, and source repo edits outside assigned scope. | Release dossier records protected-path scan commands and zero unexpected protected edits across all participating refs. |
| P8-RISK-015 | Datasets | P0 | Dataset ground-truth and leakage controls are not ready for public runnable rows without target-only evidence closure. | W7-g records dataset target and leakage concerns; W7-m marks dataset acceptance testable in parts but blocked for public v0 until status, license, split, and cache evidence are frozen. | Dataset science owner | Add target-only ground-truth audit rows and leakage negative fixtures for release-scope datasets. | Every release-scope dataset row records target signal, truth derivation method, estimator input exclusion, split/leakage boundary, negative leakage fixture, and caveat for missing or metadata-only evidence. |
| P8-RISK-016 | Metrics/reporting | P1 | Public metric tables may aggregate incompatible rows or hide invalid/failed rows. | W7-g records missing common release envelope and aggregation closure. W7-m requires per-cell/profile rows and invalid-run visibility. | Stats/report owner | Define release envelope for metric family, unit, task, target signal, aggregation policy, and failure policy. | Report tables include denominator policy, invalid/failed/skipped row counts, per-cell/profile detail or linked artifact, aggregation scope, and caveats. |

## Immediate Alpha Close-Out Queue

1. Assemble and pin RC refs for runner, stats, datasets, and async/report.
2. Re-run post-merge or assembled-ref validation on clean checkouts.
3. Freeze license/access/cache/split/source-ledger evidence for every public row.
4. Create or explicitly exclude the monthly snapshot artifact.
5. Run public text scans and manual redline binding on exact artifacts.
6. Convert spec-only governance sidecars into executed gates or signed reviews.
7. Re-fetch and replay validation if any branch head changes.

## Blockers

- No assembled alpha RC ref or release dossier was inspected.
- Async docs broad research-brief gate remains blocked in W8-a by 16 legacy
  backlog brief failures.
- Real source-ledger, frozen-value, comparability, and public-text binding
  ledgers were not inspected for alpha artifacts.
- Dataset license/access clearance records are incomplete in inspected async
  evidence.
- Frozen monthly snapshot artifact and integrated validator run were not
  inspected.
- Several W6/W7 artifacts are specifications or dashboards only; they do not
  prove enforcement.

## Local Validation

Required for this W9-e branch:

```bash
git diff --check
```

Expected changed path:

```text
risk/phase8/phase8-alpha-risk-register-20260507.md
```

## Non-Claims

This file records risks, blockers, actions, and exit criteria. It does not make
benchmark-result claims, public comparison claims, release-readiness claims, or
scientific validation claims. It does not edit thesis files, manuscript files,
claim registry files, `claims/registry.yaml`, `claim_55`, the scientific
roadmap, or runner/stats/datasets source repositories.
