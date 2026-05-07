# BSEBench Monthly Community Benchmark Workflow

Saved: 2026-05-07T21:34:56+02:00. Scope: operational design for the
community monthly benchmark path from contributor submission to frozen snapshot.

## Purpose

This workflow defines how BSEBench should run a recurring, auditable public
benchmark cycle for SOC/SOH estimators, including ECMs, Kalman-family filters,
observers, AI estimators, and hybrid methods. It is a process contract, not a
result report. It does not assert external superiority, novelty, or claim
status.

The process has three design goals:

- make new methods plug into shared dataset, protocol, metric, and report
  machinery;
- make every public number traceable to immutable inputs, commands, outputs,
  caveats, and validators;
- prevent leakage, hidden tuning, missing provenance, and unsupported comparison
  language before a monthly snapshot is frozen.

## Inputs Inspected

The checked-out async repo currently contains top-level `docs/` files only for
the universal benchmark charter and parallel wave plan. No `async/docs` or
`docs/universal` tree existed in this branch before this report was added.

Read-only Wave 1 watchdog logs were inspected for the artifact contracts this
workflow must consume after those branches are integrated:

| Worker branch | Evidence from watchdog log | Workflow dependency |
|---|---|---|
| `phase-8-0-s-universal-async-submission-template` | Pushed commit `8b8110b561029b7906a8ba27cd2613f5f1f25b91`; added contributor submission template and validation checklist. | Intake packet and contributor checklist. |
| `phase-8-0-t-universal-async-monthly-snapshot-schema` | Pushed commit `669a4eac635fcd28130833fb4ac07b9ca4fb9b32`; added monthly snapshot schema and fixture cases. | Frozen snapshot JSON contract and caveat fields. |
| `phase-8-0-w-universal-async-public-release-checklist` | Pushed commit `1a337a630edea022a807e55c93d93a1cf1059084`; added public release checklist. | Publication gates and release sign-off record. |
| `phase-8-0-r-universal-datasets-monthly-availability` | Dataset repo log showed availability snapshot model/tests and repository snapshot validation. | Dataset availability input to each monthly cycle. |
| `phase-8-0-a`, `phase-8-0-b`, `phase-8-0-d`, `phase-8-0-g` logs | Logs showed estimator adapter smoke, protocol registry, split leakage guard, and metric matrix validation tests. | Adapter, protocol, leakage, and metric validators. |

Validator rule for concurrent branches: inspect the assigned worker log under
`/home/oakir/.local/state/bsebench-async-watchdog`; if a worker is still
running, wait and re-check instead of declaring failure. When a commit appears,
validate from the fetched branch or a read-only worktree.

## Snapshot Identity

Each monthly cycle must declare a freeze plan before accepting public numbers.

Required identifiers:

| Field | Required value |
|---|---|
| `snapshot_id` | `bsebench-monthly-YYYY-MM` |
| `cycle_window` | UTC start and end timestamps for accepted submissions. |
| `submission_cutoff` | UTC timestamp after which new methods move to the next cycle. |
| `freeze_candidate_at` | UTC timestamp when inputs become read-only for validation. |
| `frozen_at` | UTC timestamp when the approved snapshot is immutable. |
| `base_commits` | Commit SHAs for runner, stats, datasets, and async/report repos. |
| `schema_versions` | Snapshot, submission, protocol, metric, split, and dataset availability schema IDs. |
| `release_owner` | Person or automation role that signs the freeze record. |

The release owner must commit the freeze plan before benchmark execution starts.
Changing any field after `freeze_candidate_at` creates a new release candidate
ID; it must not silently mutate the existing candidate.

## State Machine

Every method entry and the overall monthly snapshot move through explicit
states. A state transition is valid only when the listed artifacts exist and
the named validator passes.

| State | Entry artifact | Exit validator | Next state |
|---|---|---|---|
| `intake_received` | Contributor submission packet. | Intake validator confirms required metadata, method family, code identity, and requested metrics. | `intake_scoped` or `submission_incomplete` |
| `intake_scoped` | Accepted scope record with method ID, requested protocols, and missing-data caveats. | Guardrail scan confirms no protected-file request and no unsupported claim language. | `adapter_smoke_pending` |
| `adapter_smoke_pending` | Method adapter archive, commit, lockfile, and reproduction commands. | Estimator adapter smoke validator runs a minimal contract check without editing benchmark internals. | `adapter_smoke_passed` or `adapter_rejected` |
| `adapter_smoke_passed` | Adapter smoke report and method metadata. | Protocol assignment validator maps method to supported SOC/SOH, robustness, transfer, and compute axes. | `protocol_assigned` |
| `protocol_assigned` | Protocol registry snapshot and dataset availability snapshot. | Dataset availability validator confirms each requested dataset/profile can be evaluated or is explicitly marked missing. | `preflight_candidate` |
| `preflight_candidate` | Run manifest, split manifest, leakage guard report, environment plan. | Split/leakage validator proves calibration, training, tuning, and blind evaluation separation. | `execution_ready` or `blocked_leakage` |
| `execution_ready` | Frozen run manifest and replay command list. | Execution validator confirms commands are dry-run clean, output paths are unique, and required caches are declared. | `benchmark_executed` |
| `benchmark_executed` | Raw result bundle, logs, config hashes, result hashes. | Reproducibility validator checks artifact identity and reruns the smallest deterministic replay where practical. | `result_ingested` |
| `result_ingested` | Metric matrix, convergence, robustness, compute, and transfer reports. | Stats validator checks schema, complete grid accounting, finite values, failed-run counts, and aggregation caveats. | `validator_review` |
| `validator_review` | Validator dossier with pass/fail records and residual gaps. | Release owner verifies all invalid, missing, excluded, partial, or non-comparable rows remain visible. | `release_candidate` |
| `release_candidate` | Monthly snapshot JSON and public report draft. | Publication gates G0-G9 pass. | `frozen_snapshot` or `release_blocked` |
| `frozen_snapshot` | Signed freeze record, immutable artifact bundle, tag or branch ref. | Hash audit confirms no post-freeze mutation. | `published_snapshot` |
| `published_snapshot` | Public report, snapshot JSON, caveat table, and artifact links. | Post-publication monitor accepts errata only as append-only records. | `closed` or `erratum_opened` |

Terminal or side states:

- `submission_incomplete`: required submission fields are missing by the
  cutoff.
- `adapter_rejected`: adapter cannot satisfy the public method contract.
- `blocked_leakage`: split guard finds calibration/evaluation overlap or an
  undeclared use of evaluation labels.
- `non_comparable`: result can be archived but cannot be included in comparable
  public tables.
- `release_blocked`: at least one publication gate fails.
- `erratum_opened`: a frozen snapshot remains immutable while a correction note
  or replacement snapshot is prepared.

## Required Artifacts

Artifacts are immutable after `freeze_candidate_at` unless the release owner
creates a new release candidate ID.

| Artifact | Producer | Required fields |
|---|---|---|
| Submission packet | Contributor | Method ID, method family, contact, code URL or archive, commit or version, dependencies, estimator interface, supported outputs, requested metrics, training/calibration/evaluation disclosure, reproduction commands, known unsupported regimes. |
| Contributor checklist | Contributor and intake reviewer | Placeholder resolution, no benchmark-internal edits, split disclosure, provenance artifact list, comparison ledger status, claim-language guardrail. |
| Dataset availability snapshot | Datasets lane | Snapshot month, generated timestamp, manifest/prospect records, chemistry/profile/task coverage, Tier 1/Tier 2 status, blockers, policy caveat that availability is not remote uptime proof. |
| Protocol registry snapshot | Runner lane | Protocol ID, dataset IDs, estimator adapter IDs, initialization policy ID, metric IDs, primary metric if any, component references, schema version. |
| Run manifest | Release owner and runner | Snapshot ID, method IDs, protocol IDs, dataset/profile/cell IDs, split IDs, config hashes, output paths, resource limits, cache identities, random seeds. |
| Leakage guard report | Runner/datasets validator | Calibration split ID, tuning split ID if used, evaluation split ID, overlap set, normalization/preprocessing fit scope, pass/fail status. |
| Raw evidence bundle | Runner | Logs, raw predictions or per-step outputs where permitted, config hash, result hash, command, environment identity, non-finite and timeout records. |
| Metric reports | Stats lane | Accuracy, maximum error, convergence/recovery, robustness, compute, transfer, aggregation level, counts, missing/failed/invalid rows. |
| Source ledger | Comparison reviewer | Stable URL or DOI, retrieval date, exact metric, dataset, split, external value, frozen BSEBench value, comparability label, caveat. |
| Monthly snapshot JSON | Async/report lane | Snapshot identity, method rows, dataset availability reference, result rows, caveats, provenance, validation statuses. |
| Release checklist | Release owner | Anti-leakage, source-ledger, report-quality, artifact-freeze, and protected-file gates with timestamped sign-off. |
| Freeze record | Release owner | Frozen commit SHAs, artifact hashes, schema versions, validators, known residual risks, publish decision. |

## Validators

Validators must produce concrete pass/fail output with artifact paths and
commands. "Looks fine" is not a validator result.

| Validator | Required checks | Failure action |
|---|---|---|
| Intake validator | Submission packet complete; method family declared; requested metrics supported or caveated; no protected-file request. | Mark `submission_incomplete` or ask for a corrected packet before cutoff. |
| Claim-language guard | No SOTA, novelty, breakthrough, verified-claim, or unsupported comparison wording without a completed source ledger. | Block public prose and mark comparison rows `partial` or `not_comparable`. |
| Adapter smoke validator | Public estimator adapter factory creates a fresh estimator; `step` output schema is valid; failure behavior is declared. | Mark `adapter_rejected`. |
| Protocol validator | All protocol references resolve; initialization policy is explicit; degraded initialization and invalid-output policy are declared when required. | Block `protocol_assigned` transition. |
| Dataset availability validator | Dataset/profile/cell availability is declared; license, cache, chemistry, temperature, aging/SOH, and blocker fields are visible. | Exclude missing axes or block if a required axis lacks provenance. |
| Split/leakage validator | Calibration, training, validation, and blind evaluation scopes are disjoint; preprocessing fit scope excludes blind labels; repeated submissions are not used for tuning unless caveated. | Mark `blocked_leakage` or `non_comparable`. |
| Execution validator | Run manifest paths are unique; commands match frozen config; caches and seeds are declared; timeouts and failures are captured. | Block ingestion until evidence is rerun or caveated. |
| Reproducibility validator | Config and result hashes match; smallest replay or read-only audit reproduces declared artifact identity. | Block freeze or record explicit residual risk. |
| Stats validator | Metric matrix shape, finite-value policy, aggregation counts, failed-run counts, and caveat fields pass schema checks. | Mark affected rows `invalid`, `missing`, or `excluded`. |
| Source-ledger reviewer | Every external comparison number has stable source identity, retrieval date, exact metric, dataset, split, frozen BSEBench value, and comparability caveat. | Remove comparison prose or mark row `partial`/`not_comparable`. |
| Publication validator | Release checklist passes; no protected files edited; no hidden failed runs; no unsupported single-axis public ranking. | Mark `release_blocked`. |
| Freeze auditor | Frozen refs, artifact hashes, snapshot JSON, report, and checklist all point to the same release candidate. | Reject freeze and create a new candidate ID. |

## Publication Gates

These gates are required before `release_candidate` can become
`frozen_snapshot`.

| Gate | Pass condition |
|---|---|
| G0 - Scope | Diff contains only allowed release/report artifacts; no thesis, manuscript, claim registry, roadmap, `claims/registry.yaml`, or `claim_55` edits. |
| G1 - Submission completeness | Every included method has an accepted submission packet and resolved checklist. |
| G2 - Adapter contract | Every included method passes adapter smoke or is explicitly excluded with reason. |
| G3 - Dataset availability | Dataset availability snapshot is attached and each reported row references declared availability. |
| G4 - Split integrity | Leakage guard reports pass for all comparable rows. |
| G5 - Evidence provenance | Every public value maps to a run command, config hash, result hash, output path, and commit SHA. |
| G6 - Metrics integrity | Metric reports validate, failed/invalid/missing rows are counted, and aggregation caveats are visible. |
| G7 - Comparison source ledger | Any external comparison text has a complete source ledger row; missing fields force `partial` or `not_comparable`. |
| G8 - Report quality | Public tables separate metric axes and do not hide invalid rows or caveats. |
| G9 - Freeze immutability | Snapshot JSON, report, release checklist, and artifact hashes are frozen under a tag or immutable branch ref. |

## Freeze And Publication Rules

Freezing a snapshot means:

- the release owner records the exact runner, stats, datasets, and async/report
  commits;
- the monthly snapshot JSON is schema-valid and points to immutable artifacts;
- all public values have hashes or explicit unavailable-hash caveats;
- all validators have timestamped pass/fail records;
- every excluded or non-comparable method remains visible in the caveat table;
- later corrections are append-only errata or replacement snapshots, not silent
  edits to the frozen record.

Publication may use public tables or multi-axis rankings only within the frozen
snapshot scope and with visible caveats. It must not describe a result as SOTA,
novel, breakthrough, or verified for a thesis/claim registry unless a separate
source-ledger and claim-registration lane has completed.

## Falsification Conditions

The monthly snapshot is not publishable if any condition is true:

- a result row cannot be traced to a frozen command, config, output, and commit;
- calibration, tuning, or preprocessing used blind evaluation data without a
  public non-comparable caveat;
- dataset availability or license status is missing for a reported row;
- a metric aggregation hides failed, invalid, timeout, or missing runs;
- external comparison prose lacks the complete source ledger fields;
- any protected thesis, manuscript, registry, roadmap, `claim_55`, or
  `claims/registry.yaml` file is modified;
- a Wave 1 dependency branch is still running and was treated as failed without
  re-checking its watchdog log.

## Concrete Next Actions

1. After Wave 1 branches are merged, replace the branch-log references in this
   report with exact merged artifact paths for the submission template, monthly
   snapshot schema, release checklist, and dataset availability snapshot.
2. Add a release-owner freeze plan template that writes the `snapshot_id`,
   dates, base commits, schemas, and validator roster before execution starts.
3. Add a machine-checkable monthly release dossier index that lists every
   required artifact path and hash for a candidate snapshot.
4. Add a read-only validator playbook for fetching Wave 1 branches and checking
   their artifacts without modifying worker worktrees.
5. Add a small negative fixture for each publication gate so future validators
   can prove that missing leakage, source ledger, caveat, or hash fields block
   publication.

## GLASSBOX Validation Report

Timestamp: 2026-05-07T21:34:56+02:00.

Evidence gathered:

- `rg --files docs | sort | sed -n '1,160p'` showed only top-level docs before
  this report; no `docs/universal` path was present.
- `find . -path '*docs*' -type f | sort | sed -n '1,240p'` found no
  `async/docs` tree in this checked-out branch.
- `sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
  confirmed monthly community snapshots are a charter goal and must include
  provenance, split, leakage, caveats, and invalid-comparability handling.
- `sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`
  confirmed Wave 1 universal runner, stats, datasets, and async/public
  benchmark tasks.
- `tail -n 120` on the Wave 1 async and dataset watchdog logs confirmed pushed
  or implemented artifacts for submission intake, monthly snapshot schema,
  public release checklist, and dataset availability.
- `tail -n 90` on the runner/stats watchdog logs confirmed adapter smoke,
  protocol registry, split leakage guard, and metric matrix validator work in
  the corresponding branches.

Pre-commit validation commands and observed results:

```bash
git status --short --branch
# Result: only docs/universal/monthly-benchmark-workflow-20260507T193050Z.md
# changed in this worktree.

git diff --check
# Result: passed.

git diff --name-only HEAD
# Result: docs/universal/monthly-benchmark-workflow-20260507T193050Z.md.

git diff --stat HEAD
# Result: 1 file changed, doc-only insertion.

rg -n "SOTA|novelty|leaderboard|breakthrough|verified-claim|claim_55|claims/registry.yaml|thesis|manuscript|roadmap" \
  docs/universal/monthly-benchmark-workflow-20260507T193050Z.md
# Result: terms appear only in guardrail, publication-blocking, or
# protected-file contexts; no result claim is made.
```

Residual risks:

- Wave 1 artifacts were read from worker watchdog logs, not from merged files in
  this branch. The exact file paths must be reconciled after those branches are
  merged.
- This report is an operational workflow only. It does not implement runners,
  stats code, schemas, or validators.
- Dataset availability does not prove remote uptime or legal redistributability
  unless the dataset lane records those fields.
- No source ledger is populated here, so this report must not be used as a
  scientific comparison or claim-registration artifact.
