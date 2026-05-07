# BSEBench Monthly Benchmark Dry-Run Checklist

GLASSBOX artifact for Wave 5 worker W5-14.

Saved: 2026-05-07T21:31:25Z task window.

Branch: `phase-8-4-n-monthly-benchmark-dry-run-checklist-20260507T213125Z`

Owned path: `runbooks/monthly-benchmark-dry-run-20260507T213125Z.md`

## Scope

This runbook defines a monthly benchmark dry-run checklist from dataset
availability through public report publication for the universal SOC/SOH
benchmark. It is an operational release-hardening artifact only.

This runbook does not execute a benchmark, publish results, rank methods, make
external comparisons, register scientific claims, edit thesis or manuscript
files, edit claim registries, edit `claims/registry.yaml`, edit `claim_55`, or
change the scientific roadmap.

If a dry-run step cannot bind a checklist item to a committed artifact,
validator command, output path, and caveat, the correct outcome is
`release_blocked` or `non_comparable`, not inferred success.

## Evidence Index

The checklist below is bound to these inspected artifacts and branch heads.
Paths are cited as `repo ref:path` where the artifact is not on this branch.

| Area | Artifact or command binding | Inspected ref |
|---|---|---|
| Universal benchmark charter | `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md` | current checkout |
| Research gate protocol | `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` | current checkout |
| Monthly workflow | `origin/phase-8-1-r-monthly-benchmark-workflow-design-20260507T193050Z:docs/universal/monthly-benchmark-workflow-20260507T193050Z.md` | `dba3ce242bb27fa783f633972378b36f6e1975c9` |
| Public release checklist | `origin/phase-8-0-w-universal-async-public-release-checklist:docs/BSEBENCH-PUBLIC-BENCHMARK-RELEASE-CHECKLIST-2026-05-07.md` | `1a337a630edea022a807e55c93d93a1cf1059084` |
| Monthly snapshot schema | `origin/phase-8-0-t-universal-async-monthly-snapshot-schema:docs/BSEBENCH-MONTHLY-SNAPSHOT-SCHEMA-2026-05-07.md` | `669a4eac635fcd28130833fb4ac07b9ca4fb9b32` |
| Snapshot artifact schema | `origin/phase-8-3-l-monthly-snapshot-artifact-schema-20260507T204627Z:specs/universal/monthly-snapshot-artifact-schema-20260507T204627Z.md` | `0f3b4bb76b1870a5a8cc030202c23551cf6b4cf7` |
| Community report outline | `origin/phase-8-3-w-community-benchmark-report-outline-20260507T204627Z:docs/universal/community-benchmark-report-outline-20260507T204627Z.md` | `5ea6996d03b3473b9dfc1b4ca2ea46a5ee5b3a40` |
| Phase 8 branch ledger | `origin/phase-8-3-h-phase8-branch-ledger-20260507T204627Z:ledgers/phase8/branch-ledger-20260507T204627Z.md` | `b5b0adf5ada72a4f6ed828dc0f382228bf66c15c` |
| Contributor submission template | `origin/phase-8-0-s-universal-async-submission-template:templates/universal-contributor-submission-template.md` | `8b8110b561029b7906a8ba27cd2613f5f1f25b91` |
| Source-ledger gate | `origin/phase-8-1-q-anti-hallucination-source-ledger-audit-20260507T193050Z:audits/universal/source-ledger-audit-20260507T193050Z.md` | `8a0923baaac7d25273b5fad6fddab14b76f1fe46` |
| Leakage taxonomy | `origin/phase-8-2-b-leakage-taxonomy-audit-20260507T193528Z:audits/methodology/leakage-taxonomy-20260507T193528Z.md` | `49883d635ce729a98ef68698ae882f4838bb0a2a` |
| Data licensing and availability | `origin/phase-8-2-i-data-licensing-availability-audit-20260507T193528Z:audits/methodology/data-licensing-availability-20260507T193528Z.md` | `02d53d8b88504b76fb24786e89054f1df9f1aa6f` |
| Dataset ETL acceptance | `origin/phase-8-3-o-dataset-etl-acceptance-matrix-20260507T204627Z:audits/universal/dataset-etl-acceptance-matrix-20260507T204627Z.md` | `c0bbafd9fc396f05ab10cbaa4867e6302c03bd8c` |
| Metrics acceptance | `origin/phase-8-3-p-metrics-acceptance-matrix-20260507T204627Z:audits/universal/metrics-acceptance-matrix-20260507T204627Z.md` | `6a1db5a87c4004b643a883cfd3fc957000b2b016` |
| Compute evidence tiers | `origin/phase-8-3-q-compute-evidence-tier-spec-20260507T204627Z:specs/universal/compute-evidence-tier-spec-20260507T204627Z.md` | `21f532d0afba3b659b664761f455309989e3d948` |
| Dataset ETL contract branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets rev-parse origin/phase-8-0-m-universal-datasets-etl-contract` | `6b6bab2df83b8b9c18a01842814c60debda41c9c` |
| Dataset ground-truth audit branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets rev-parse origin/phase-8-0-n-universal-datasets-ground-truth-audit` | `a52c81dd80b8e31de63719fbe874c45a9f68382f` |
| Dataset split metadata branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets rev-parse origin/phase-8-0-o-universal-datasets-split-metadata` | `2f0caba08b026cba1c448608394ffc33b1badbc2` |
| Dataset card schema branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets rev-parse origin/phase-8-0-p-universal-datasets-card-schema` | `e5f2305dfc2019d3676224b5409ebc536409b1ed` |
| Dataset equipment registry branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets rev-parse origin/phase-8-0-q-universal-datasets-equipment-registry` | `96566f9bdd1794ccf5d2ece556bd55cdad55ba41` |
| Dataset availability implementation branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets diff --name-status origin/main..origin/phase-8-0-r-universal-datasets-monthly-availability` | `c1af5d0b4c7fa09c23b8d0c15113c95e570c4fbd` |
| Runner protocol registry branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-runner rev-parse origin/phase-8-0-b-universal-runner-protocol-registry` | `acf95fa072d3a91e32669b66f7c170012d8289de` |
| Runner degraded initialization branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-runner rev-parse origin/phase-8-0-c-universal-runner-degraded-initialization` | `944a15213ed40e62788d668c442ff9ffa74393a1` |
| Runner leakage guard branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-runner diff --name-status origin/main..origin/phase-8-0-d-universal-runner-leakage-split-guard` | `5d8efab0c9533315ae9b3371ba74d05899ceaffc` |
| Runner compute profiling branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-runner rev-parse origin/phase-8-0-e-universal-runner-compute-profiling-hooks` | `2006dffa8aba6b6bd500657ee41973c828069d3e` |
| Runner submission smoke branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-runner rev-parse origin/phase-8-0-f-universal-runner-submission-smoke` | `ce792f35b96a3aaa544c8c21b7c859f68f8400cf` |
| Stats metric matrix branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-stats diff --name-status origin/main..origin/phase-8-0-g-universal-stats-metric-matrix` | `646bf3c084cb14aa3270216c6b64b8c42c02f42e` |
| Stats convergence branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-stats rev-parse origin/phase-8-0-h-universal-stats-convergence-metrics` | `eddb3451ef06c2229d8b4370e66ad14a10fb40e6` |
| Stats robustness branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-stats rev-parse origin/phase-8-0-i-universal-stats-robustness-noise-schema` | `0d7e275272cc3955e13d98717fea50dd44b90073` |
| Stats compute aggregator branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-stats rev-parse origin/phase-8-0-j-universal-stats-compute-cost-aggregator` | `f11a151fc7c07d7c0fc5f0900126becb0e16a441` |
| Stats ranking branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-stats rev-parse origin/phase-8-0-k-universal-stats-multi-axis-ranking` | `f42e0a0bcf0203aab36b1dbdc7127c7cd5deddc4` |
| Stats transfer branch | `git -C /mnt/c/doctorat/bsebench-org/bsebench-stats rev-parse origin/phase-8-0-l-universal-stats-transfer-matrix` | `59dfd52496aec8c946b2d8188774bdb3a6d021e0` |

## Dry-Run Inputs

Create a release dossier before running any benchmark command. The dossier may
be a directory or single manifest, but it must record these fields.

| Field | Required value | Artifact or command binding |
|---|---|---|
| `snapshot_id` | `bsebench-monthly-YYYY-MM` or candidate suffix. | Monthly workflow snapshot identity section. |
| `candidate_id` | Immutable candidate identifier for the dry-run. | Release dossier path. |
| `cycle_window_start_utc` and `cycle_window_end_utc` | Submission window timestamps. | Freeze plan artifact. |
| `submission_cutoff_utc` | Cutoff after which new methods move to the next cycle. | Freeze plan artifact. |
| `freeze_candidate_at_utc` | Timestamp when inputs become read-only. | Freeze plan artifact. |
| `async_report_commit` | Commit containing report and checklist artifacts. | `git rev-parse HEAD`. |
| `runner_commit` | Runner branch or integration commit used for dry-run. | `git -C /mnt/c/doctorat/bsebench-org/bsebench-runner rev-parse <ref>`. |
| `stats_commit` | Stats branch or integration commit used for dry-run. | `git -C /mnt/c/doctorat/bsebench-org/bsebench-stats rev-parse <ref>`. |
| `datasets_commit` | Dataset branch or integration commit used for dry-run. | `git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets rev-parse <ref>`. |
| `schema_versions` | Snapshot, artifact, submission, metric, split, protocol, and source-ledger schema IDs. | Snapshot artifact schema and monthly snapshot schema artifacts. |
| `source_ledger_status` | `not_used`, `complete`, `partial`, or `blocked`. | Source-ledger audit and ledger artifact path. |
| `publish_decision` | `draft`, `blocked`, `publish_with_caveats`, or `publish`. | Final release checklist and freeze record. |

Required setup command ledger:

```bash
git fetch origin --prune
git status --short --branch
git diff --name-only HEAD
git rev-parse HEAD
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner rev-parse <runner-ref>
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats rev-parse <stats-ref>
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets rev-parse <datasets-ref>
```

Stop condition: any ref is local-only, dirty without a committed artifact, or
missing from the release dossier.

## Checklist

Each item below must be checked with an artifact or command. The dry-run record
must include the observed status, output path, timestamp, and caveat.

### 1. Dataset Availability And Rights

| ID | Checklist item | Artifact or command binding | Pass record | Stop condition |
|---|---|---|---|---|
| D1 | Freeze the dataset repo ref and availability snapshot month. | `git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets rev-parse <datasets-ref>` and the availability snapshot artifact. | Dataset ref and `snapshot_month` recorded. | Missing dataset ref or mutable availability input. |
| D2 | Validate prospect catalog and strict manifest or availability projection. | `uv run pytest tests/test_prospect_catalog.py -q`; `uv run pytest tests/test_availability_snapshot.py -q` after availability branch integration. | Counts by status, blockers, license gaps, and Tier 1/Tier 2 state recorded. | Catalog, manifest, or projection cannot parse and no explicit blocker is recorded. |
| D3 | Classify each dataset row as `benchmark_ready`, `tier2_metadata_ready`, `tier1_only`, `prospect_allowed_not_mirrored`, `prospect_license_review`, `restricted_or_manual_access`, or `blocked`. | Data licensing availability audit state table and availability JSON/CSV. | Every row has state and caveat. | A row is reported as runnable without loader, rights, split, and cache evidence. |
| D4 | Verify license, redistribution, source URL or DOI, retrieval date, and file inventory. | Dataset card or source-ledger artifact; data licensing audit required fields. | Rights reviewer, retrieval date, license status, hashes, and caveat recorded. | Missing license or redistribution evidence for a public runnable row. |
| D5 | Verify Tier 2 loader readiness for every benchmark-ready row. | Loader probe command for exact split/profile/cell; availability snapshot row. | Required files, cache root, loader ID, probe status, and missing files recorded. | Dataset availability is inferred from catalog-only or remote uptime assumptions. |
| D6 | Bind raw ETL acceptance for raw-equipment sources. | Dataset ETL acceptance matrix; raw parser fixture command when implemented. | Vendor, format, sign convention, timebase, source hashes, and parser version recorded. | Arbin, Maccor, Neware, or unknown raw source is accepted without source-family evidence and caveats. |
| D7 | Bind ground-truth construction to source evidence. | Ground-truth metadata artifact or dataset card fields. | SOC/SOH method, capacity source, OCV or rest policy, integration rule, reset policy, and leakage scope recorded. | Ground truth is unknown for a comparable result row. |

### 2. Submission Intake

| ID | Checklist item | Artifact or command binding | Pass record | Stop condition |
|---|---|---|---|---|
| S1 | Freeze each contributor submission packet before adapter smoke. | Submission template and contributor checklist from `origin/phase-8-0-s-universal-async-submission-template`. | Submission ID, method ID, method family, license, code URL or archive, commit/hash, entry point, and dependencies recorded. | Method is benchmarked from uncommitted, mutable, or undocumented code. |
| S2 | Record training, calibration, tuning, pretrained weight, and repeated-submission disclosure. | Submission packet fields and contributor checklist. | Disclosure artifact path and reviewer decision recorded. | Evaluation data use is not disclosed or reviewer cannot distinguish calibration from blind evaluation. |
| S3 | Scan intake materials for protected-file requests and unsupported claim wording. | `scripts/check-research-brief-gates.sh --dry-run <BRIEF.md>` when a BRIEF exists; source-ledger audit rejection cases. | Guardrail scan command and output path recorded. | Intake requires thesis, manuscript, claim registry, `claims/registry.yaml`, `claim_55`, or roadmap edits. |
| S4 | Assign lifecycle state. | Monthly workflow state machine. | State is one of `intake_received`, `intake_scoped`, `submission_incomplete`, `adapter_rejected`, `blocked_leakage`, `non_comparable`, or later valid state. | State transition lacks entry artifact or exit validator. |

### 3. Adapter, Protocol, And Split Preflight

| ID | Checklist item | Artifact or command binding | Pass record | Stop condition |
|---|---|---|---|---|
| A1 | Run public estimator adapter smoke checks. | Runner submission smoke branch; future command `uv run pytest tests/test_submission_smoke.py -q` from runner integration ref. | Adapter smoke report path, command, method ID, output schema, and failure behavior recorded. | Adapter touches dataset loaders, metrics, or split internals without a declared wrapper. |
| A2 | Resolve protocol assignments. | Runner protocol registry branch and monthly workflow `protocol_assigned` state. | `protocol_id`, metric IDs, dataset IDs, initialization policy, and resource limits recorded. | Protocol reference is free text or missing schema/version identity. |
| A3 | Verify degraded initialization policy where required. | Runner degraded-initialization branch and metrics convergence acceptance matrix. | Case ID, initial SOC/SOH policy, threshold, hold policy, and caveat recorded. | Recovery/convergence values are reported without the initialization fixture identity. |
| A4 | Run split overlap guard. | Runner leakage guard branch command `uv run pytest tests/test_split_guard.py -q`; split manifest artifact. | Calibration, training, validation, tuning, and blind evaluation split IDs plus overlap count recorded. | Non-zero overlap at the declared leakage boundary for a comparable row. |
| A5 | Validate split metadata. | Datasets split metadata branch; split manifest artifact. | Split role, leakage boundary, config ID fields, forbidden uses, and freeze timestamp recorded. | Split relies only on prose such as held out without machine-readable roles. |

### 4. Anti-Leakage Gate

This gate is blocking for every comparable result row.

| Leakage class | Required dry-run check | Artifact or command binding | Block when |
|---|---|---|---|
| L0 process leakage | Evidence uses committed and pushed refs only. | `git status --short --branch`, `git rev-parse`, branch ledger. | Dirty or local-only evidence is used as a public value. |
| L1 split-identity leakage | Calibration/tuning/evaluation key sets are disjoint. | Split guard output and split manifest. | Any overlap exists at the declared boundary. |
| L2 calibration-policy leakage | Forbidden uses are checked for held-out splits. | Split metadata and leakage manifest. | Evaluation data is used for ECM identification, hyperparameter tuning, normalization fit, model selection, or threshold selection. |
| L3 temporal, cell, cycle, source leakage | Declared boundary keys are disjoint beyond config tuple where available. | Dataset split manifest with cell, cycle, source, and time-window keys. | Same physical cell, cycle window, source file, or future segment leaks across roles. |
| L4 ground-truth and label leakage | Estimator inference receives only allowed input signals. | Adapter smoke fixture and ground-truth metadata. | SOC/SOH labels, residuals, or post-hoc corrections enter inference or reset logic. |
| L5 metric and post-hoc selection leakage | Metric set, sample cap, aggregation, and invalid-output policy are frozen before execution. | Run manifest and metrics acceptance matrix. | Failed rows or unfavorable subsets are removed after viewing scores. |
| L6 cache, manifest, and ETL leakage | Source/cache manifest and transform hashes are split-scoped. | Dataset availability, ETL matrix, and cache manifest hashes. | ETL transform is fit on all data before splitting or cache identity is mutable. |
| L7 submission and feedback leakage | Submission SHA is frozen before blind evaluation. | Submission packet and run manifest. | Adapter code changes after blind scores without moving to a new snapshot. |

Minimum anti-leakage dry-run commands:

```bash
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner rev-parse <runner-ref>
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets rev-parse <datasets-ref>
uv run pytest tests/test_split_guard.py -q
python -m bsebench_runner.validate_leakage_manifest <run-manifest.json>
```

If the future `validate_leakage_manifest` command is not implemented in the
candidate refs, the dry-run must record `blocked_missing_leakage_validator` or
`not_comparable` for affected rows.

### 5. Execution Dry-Run

| ID | Checklist item | Artifact or command binding | Pass record | Stop condition |
|---|---|---|---|---|
| E1 | Freeze run manifest before execution. | Run manifest artifact. | Snapshot ID, method IDs, protocol IDs, dataset/profile/cell IDs, split IDs, config hashes, output paths, resource limits, cache identities, and seeds recorded. | Manifest is edited after execution without a new candidate ID. |
| E2 | Confirm output paths are unique and under the candidate artifact root. | Execution validator command or manifest linter. | Output path list and collision check output recorded. | Any output path can overwrite another method, protocol, or candidate. |
| E3 | Record exact benchmark command for every method/protocol/dataset row. | Run manifest `run_command` fields. | Command, working directory, environment ref, and expected outputs recorded. | Public value lacks a generation command. |
| E4 | Run dry-run mode or smallest smoke execution before full run. | Runner command, for example `python -m bsebench_runner ... --dry-run` when integrated. | Dry-run output path and zero/blocked status recorded. | Command is not available and no failure report is written. |
| E5 | Capture failures as rows. | Raw evidence bundle and result rows. | Timeout, exception, invalid output, non-finite output, missing cache, and skipped row counts recorded. | Failed rows are hidden from metrics or report tables. |

### 6. Metrics And Stats Ingestion

| ID | Checklist item | Artifact or command binding | Pass record | Stop condition |
|---|---|---|---|---|
| M1 | Validate accuracy metrics use explicit units. | Metrics acceptance matrix; stats metric matrix command `uv run pytest tests/test_metric_matrix.py -q` after integration. | RMSE, MAE, MAXE, metric family, unit, direction, and aggregation policy recorded. | SOC/SOH percentage-point values are mixed with voltage mV diagnostics. |
| M2 | Preserve failed, invalid, missing, excluded, timeout, and non-finite rows. | Metric report and monthly snapshot result rows. | Row counts and caveats recorded. | Rows are dropped or replaced with fabricated favorable sentinel values. |
| M3 | Validate convergence/recovery metrics. | Convergence metrics branch and metrics acceptance matrix. | Case ID, threshold, hold policy, convergence status, time, area, and out-of-band counts recorded. | Low/high wrong-start cases are collapsed without policy. |
| M4 | Validate robustness and transfer matrices. | Robustness and transfer branch artifacts; monthly snapshot protocol rows. | Noise family, seeds, source/target axis, split role, and complete grid accounting recorded. | Missing estimator-condition or source-target cells are hidden. |
| M5 | Validate compute evidence tier. | Compute evidence tier spec and compute-cost aggregation output. | `compute_evidence_tier`, scope, backend, platform, repeats, coverage, and caveat recorded. | C0 missing evidence is sorted beside measured evidence, or wall time is presented as hardware independent. |
| M6 | Bind every metric table to evidence artifacts. | Monthly snapshot artifact schema `evidence_artifacts[]` and `result_rows[]`. | Each value resolves to command, config hash, result hash, output path, commit, and caveat. | Any public value lacks evidence closure. |

### 7. Source-Ledger And Claim-Language Gate

This gate is blocking before public prose, captions, tables, release notes, or
README snippets contain external comparison or claim-promotion language.

| ID | Checklist item | Artifact or command binding | Pass record | Stop condition |
|---|---|---|---|---|
| C1 | Decide whether external comparisons are used. | Source-ledger status in release dossier. | `source_ledger_status` is `not_used`, `complete`, `partial`, or `blocked`. | Report contains external comparison text while status is `not_used` or `blocked`. |
| C2 | Validate source-ledger required fields for every external number. | Source-ledger audit required row fields. | Stable source ID, title, DOI or stable URL, retrieval date, source location, method, metric, dataset, split, external value, frozen BSEBench value, artifact, command, comparability, and caveat recorded. | Any required field is missing for positive comparison wording. |
| C3 | Build claim-to-ledger acceptance matrix. | Source-ledger audit matrix fields. | Report path, line/table ref, trigger terms, source ledger IDs, evidence IDs, decision, and reviewer note recorded. | A line, table cell, or caption with comparison meaning has no matrix row. |
| C4 | Run wording scan. | `rg -n "SOTA|novel|breakthrough|verified|leaderboard|overall best|better than prior work" <report-path>` | Matches are either absent or bound to blocked-wording, caveat, or source-ledger-approved contexts. | Unsupported comparison or claim-promotion wording appears. |
| C5 | Downgrade partial comparisons. | Source-ledger comparability labels. | `partial` rows support caveat or gap statements only; `not_comparable` rows support gap statements only. | A partial or not-comparable row supports positive comparison prose. |

Minimum source-ledger dry-run commands:

```bash
rg -n "SOTA|novel|breakthrough|verified|leaderboard|overall best|better than prior work" <candidate-report.md>
python -m bsebench_report.validate_source_ledger <source-ledger.json>
python -m bsebench_report.build_claim_to_ledger_matrix <candidate-report.md> <source-ledger.json>
```

If the future `bsebench_report` commands are not implemented in the candidate
refs, the dry-run must record a manual inspection artifact and block external
comparison language unless the ledger can still be reviewed field-by-field.

### 8. Snapshot Artifact Generation

| ID | Checklist item | Artifact or command binding | Pass record | Stop condition |
|---|---|---|---|---|
| J1 | Generate monthly snapshot JSON. | Monthly snapshot schema and JSON Schema fixture path. | Snapshot JSON path, schema version, hash, and validation command recorded. | Snapshot lacks required release caveats or result-row caveats. |
| J2 | Generate artifact-level release wrapper. | Snapshot artifact schema `bsebench.monthly_snapshot_artifact.v1`. | Submission registry, method registry, dataset registry, metric registry, protocol registry, evidence artifacts, result rows, source ledgers, validation gates, release caveats, and freeze record recorded. | Cross-reference invariants fail. |
| J3 | Validate schema fixtures or candidate JSON. | JSON Schema command from monthly snapshot schema. | Validator output path and error count recorded. | Invalid fixture passes, valid fixture fails, or candidate JSON is not checked. |
| J4 | Validate hashes. | `sha256sum <artifact>` for snapshot JSON, report, source ledger, release checklist, and evidence bundle. | Hash ledger recorded. | Hashes are missing and no explicit caveat blocks publication. |

### 9. Public Report Dry-Run

| ID | Checklist item | Artifact or command binding | Pass record | Stop condition |
|---|---|---|---|---|
| R1 | Use required front matter. | Community report outline front matter table. | Report ID, snapshot ID, release status, report commit, snapshot JSON path/hash, release dossier, base commits, source-ledger status, and publish decision recorded. | Front matter cannot identify frozen inputs. |
| R2 | Separate scope, submissions, datasets, metrics, results, caveats, reproducibility, and decision sections. | Community report outline sections 1 through 10. | Section checklist recorded. | Numeric values appear before metric definitions and caveats. |
| R3 | Keep invalid, missing, excluded, partial, and not-comparable rows visible. | Snapshot result rows and caveat tables. | Caveat/exclusion table path recorded. | Report hides failed or invalid rows that affect interpretation. |
| R4 | Restrict rankings to named ranking groups. | Snapshot schema ranking groups and report outline. | `ranking_group_id`, eligible row set, aggregation policy, and caveat recorded. | Unqualified overall rank or single-axis public ordering lacks policy. |
| R5 | Bind every value cell to a result row. | Report preflight or manual table audit. | Each value cell maps to `result_row_id`, `metric_id`, `protocol_id`, `method_id`, `dataset_id`, `split_id`, `evidence_artifact_id`, status, comparability, and caveat. | A numeric cell cannot be traced to snapshot JSON. |
| R6 | Record reproducibility commands. | Report reproducibility section and release dossier. | Replay command, artifact path, hash, environment ref, and mismatch count recorded. | Report says replay passed without saying what was compared. |

### 10. Release Checklist, Freeze, And Publication

| ID | Checklist item | Artifact or command binding | Pass record | Stop condition |
|---|---|---|---|---|
| F1 | Run protected-file and write-set gate. | `git diff --name-only <base>..HEAD`; public release checklist G0. | Only release/report artifacts are changed. | Thesis, manuscript, claim registry, `claims/registry.yaml`, `claim_55`, roadmap, or unrelated files are modified. |
| F2 | Run release checklist G0 through G9. | Public release checklist and monthly workflow publication gates. | Each gate has status, validator command, output ref, checked timestamp, and caveat. | Any blocking gate is `failed`, `blocked`, or `not_run`. |
| F3 | Freeze snapshot refs and hashes. | Freeze record in release dossier. | Runner, stats, datasets, async/report, source ledger, snapshot JSON, public report, checklist, and artifact bundle hashes recorded. | Snapshot JSON, report, checklist, and hashes point to different candidates. |
| F4 | Publish or block decision. | Release sign-off record. | Decision is `publish`, `publish_with_caveats`, or `blocked`, with residual risks. | Decision is made without release owner, commands, caveats, or artifact hashes. |
| F5 | Define errata policy. | Community report outline errata section. | Append-only errata path and replacement snapshot rule recorded. | Frozen report is silently rewritten. |

## Required Validation Gate Set

The release dossier must include these `validation_gates[]` entries from the
snapshot artifact schema. Gate IDs are stable and blocking unless explicitly
marked `not_applicable` with a caveat.

| Gate ID | Name | Required validator output |
|---|---|---|
| `G0_SCOPE` | Protected-file and write-set gate | `git diff --name-only` output and protected path scan. |
| `G1_SUBMISSION` | Submission completeness gate | Intake checklist decision for every included or excluded method. |
| `G2_ADAPTER` | Adapter contract gate | Adapter smoke command output or exclusion reason. |
| `G3_DATASET` | Dataset availability gate | Availability snapshot, license fields, loader probe, and dataset caveats. |
| `G4_SPLIT_LEAKAGE` | Split and leakage gate | Split guard, leakage manifest, overlap count, and forbidden-use check. |
| `G5_EVIDENCE` | Evidence provenance gate | Command, config hash, result hash, output path, commit, and replay status. |
| `G6_METRICS` | Metrics integrity gate | Metric schema, units, aggregation, finite policy, failed-row counts. |
| `G7_SOURCE_LEDGER` | External comparison source-ledger gate | Source-ledger rows and claim-to-ledger matrix, or `not_used` status. |
| `G8_REPORT_QUALITY` | Report caveat and wording gate | Value-cell binding, caveat table, wording scan, and report outline checklist. |
| `G9_FREEZE` | Freeze immutability gate | Snapshot/report/checklist/artifact hashes under one candidate ID. |

## Dry-Run Failure Report Template

If any blocking gate fails, write a failure report instead of forcing
publication. The report should include:

```yaml
failure_report:
  snapshot_id: bsebench-monthly-YYYY-MM-rcN
  failed_gate_id: G4_SPLIT_LEAKAGE
  status: blocked
  validator_command: exact command or manual inspection command
  validator_output_ref: path/to/log-or-report
  affected_rows:
    - result_row_id_or_entity_id
  artifact_refs:
    runner_commit: sha
    stats_commit: sha
    datasets_commit: sha
    async_report_commit: sha
  stop_condition: concrete falsification condition
  next_action: retry, exclude, mark_non_comparable, or open_fix_task
  caveat: why this blocks public release or comparison
```

## Final Dry-Run Acceptance Criteria

A monthly benchmark dry-run is accepted only when all statements below are true:

- Every checklist item has an artifact path or command output.
- Every public value resolves to a frozen command, config hash, result hash,
  output path, commit, and caveat.
- Every comparable row passes anti-leakage gates or is downgraded out of
  comparability.
- Every external comparison phrase has a complete source-ledger row and
  claim-to-ledger matrix decision, or comparison language is removed.
- Every invalid, failed, missing, excluded, partial, and not-comparable row
  remains visible.
- Snapshot JSON, report, release checklist, source ledger, and evidence bundle
  hashes point to the same candidate.
- Protected files are untouched.
- `git diff --check` passes for the release branch.

## Residual Risks

- Many cited artifacts are branch artifacts, not merged mainline files in this
  checkout. The release owner must re-bind paths after integration.
- Some future commands listed here are expected validator entry points. If they
  are unavailable in the candidate refs, the dry-run must record a manual
  validator artifact or block the affected gate.
- Dataset licenses, access controls, and mirrors can change. Each public
  monthly snapshot needs fresh retrieval dates and rights decisions.
- Source-ledger field completeness can be checked mechanically, but scientific
  comparability still needs reviewer judgment.
- This runbook defines gates. It does not prove any method, dataset, metric, or
  report is ready for public release.

## Explicit Non-Claims

- This runbook does not claim that BSEBench has published a monthly benchmark.
- This runbook does not claim that any method is better than another.
- This runbook does not make SOTA, novelty, leaderboard, breakthrough, or
  verified-claim statements.
- This runbook does not approve any dataset license or redistribution right.
- This runbook does not validate any SOC/SOH result, compute result, robustness
  result, transfer result, or external comparison.
- This runbook does not edit thesis files, manuscript files, claim registries,
  `claims/registry.yaml`, `claim_55`, or the scientific roadmap.

## GLASSBOX Validation To Record

Commands used while drafting this runbook:

```bash
git status --short --branch
rg --files -g 'runbooks/**' -g '*checklist*' -g '*dry-run*' -g 'docs/**'
git branch -r | sed -n '1,120p'
git fetch origin --prune
git diff --name-status origin/main..origin/phase-8-1-r-monthly-benchmark-workflow-design-20260507T193050Z
git diff --name-status origin/main..origin/phase-8-0-w-universal-async-public-release-checklist
git diff --name-status origin/main..origin/phase-8-0-t-universal-async-monthly-snapshot-schema
git diff --name-status origin/main..origin/phase-8-3-l-monthly-snapshot-artifact-schema-20260507T204627Z
git diff --name-status origin/main..origin/phase-8-3-w-community-benchmark-report-outline-20260507T204627Z
git diff --name-status origin/main..origin/phase-8-3-h-phase8-branch-ledger-20260507T204627Z
git diff --name-status origin/main..origin/phase-8-1-q-anti-hallucination-source-ledger-audit-20260507T193050Z
git diff --name-status origin/main..origin/phase-8-2-b-leakage-taxonomy-audit-20260507T193528Z
git diff --name-status origin/main..origin/phase-8-2-i-data-licensing-availability-audit-20260507T193528Z
git diff --name-status origin/main..origin/phase-8-3-o-dataset-etl-acceptance-matrix-20260507T204627Z
git diff --name-status origin/main..origin/phase-8-3-p-metrics-acceptance-matrix-20260507T204627Z
git diff --name-status origin/main..origin/phase-8-3-q-compute-evidence-tier-spec-20260507T204627Z
git show origin/phase-8-1-r-monthly-benchmark-workflow-design-20260507T193050Z:docs/universal/monthly-benchmark-workflow-20260507T193050Z.md
git show origin/phase-8-0-w-universal-async-public-release-checklist:docs/BSEBENCH-PUBLIC-BENCHMARK-RELEASE-CHECKLIST-2026-05-07.md
git show origin/phase-8-3-l-monthly-snapshot-artifact-schema-20260507T204627Z:specs/universal/monthly-snapshot-artifact-schema-20260507T204627Z.md
git show origin/phase-8-0-t-universal-async-monthly-snapshot-schema:docs/BSEBENCH-MONTHLY-SNAPSHOT-SCHEMA-2026-05-07.md
git show origin/phase-8-3-w-community-benchmark-report-outline-20260507T204627Z:docs/universal/community-benchmark-report-outline-20260507T204627Z.md
git show origin/phase-8-3-h-phase8-branch-ledger-20260507T204627Z:ledgers/phase8/branch-ledger-20260507T204627Z.md
git show origin/phase-8-1-q-anti-hallucination-source-ledger-audit-20260507T193050Z:audits/universal/source-ledger-audit-20260507T193050Z.md
git show origin/phase-8-2-b-leakage-taxonomy-audit-20260507T193528Z:audits/methodology/leakage-taxonomy-20260507T193528Z.md
git show origin/phase-8-2-i-data-licensing-availability-audit-20260507T193528Z:audits/methodology/data-licensing-availability-20260507T193528Z.md
git show origin/phase-8-3-o-dataset-etl-acceptance-matrix-20260507T204627Z:audits/universal/dataset-etl-acceptance-matrix-20260507T204627Z.md
git show origin/phase-8-3-p-metrics-acceptance-matrix-20260507T204627Z:audits/universal/metrics-acceptance-matrix-20260507T204627Z.md
git show origin/phase-8-3-q-compute-evidence-tier-spec-20260507T204627Z:specs/universal/compute-evidence-tier-spec-20260507T204627Z.md
git rev-parse origin/phase-8-0-s-universal-async-submission-template
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets rev-parse origin/phase-8-0-r-universal-datasets-monthly-availability
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner rev-parse origin/phase-8-0-d-universal-runner-leakage-split-guard
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats rev-parse origin/phase-8-0-g-universal-stats-metric-matrix
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets rev-parse origin/phase-8-0-n-universal-datasets-ground-truth-audit origin/phase-8-0-o-universal-datasets-split-metadata origin/phase-8-0-p-universal-datasets-card-schema origin/phase-8-0-q-universal-datasets-equipment-registry origin/phase-8-0-m-universal-datasets-etl-contract
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner rev-parse origin/phase-8-0-c-universal-runner-degraded-initialization origin/phase-8-0-b-universal-runner-protocol-registry origin/phase-8-0-f-universal-runner-submission-smoke origin/phase-8-0-e-universal-runner-compute-profiling-hooks
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats rev-parse origin/phase-8-0-h-universal-stats-convergence-metrics origin/phase-8-0-i-universal-stats-robustness-noise-schema origin/phase-8-0-j-universal-stats-compute-cost-aggregator origin/phase-8-0-k-universal-stats-multi-axis-ranking origin/phase-8-0-l-universal-stats-transfer-matrix
```

Pre-commit validation required for this branch:

```bash
git diff --check
git diff --name-only HEAD
rg -n "SOTA|novel|breakthrough|verified|leaderboard|overall best|better than prior work|claim_55|claims/registry.yaml|thesis|manuscript|roadmap" runbooks/monthly-benchmark-dry-run-20260507T213125Z.md
```

Expected wording-scan interpretation: matches are allowed only in guardrail,
blocked-language, protected-file, explicit non-claim, source-ledger, or
validation contexts. This runbook must not contain result claims or external
comparison claims.
