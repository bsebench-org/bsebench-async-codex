# BSEBench Monthly Snapshot Artifact Schema

GLASSBOX artifact for Wave 4 worker W4-12.

Saved: 2026-05-07T22:49:56+02:00.

Owned path:
`specs/universal/monthly-snapshot-artifact-schema-20260507T204627Z.md`.

Branch:
`phase-8-3-l-monthly-snapshot-artifact-schema-20260507T204627Z`.

## Objective

Draft the monthly benchmark snapshot artifact schema that ties contributor
submissions, datasets, metrics, protocol assignments, benchmark result rows,
source ledgers, and provenance into one auditable release artifact.

This is a schema and validation-gate specification. It is not a benchmark
result, public report, external comparison, claim registry update, thesis
artifact, manuscript artifact, or scientific roadmap change.

The schema is intended to harden BSEBench as a universal SOC/SOH benchmark for
ECMs, Kalman filters, observers, AI estimators, hybrid methods, and future
filters by making every published monthly number traceable to:

- an accepted submission packet;
- an immutable method or adapter identity;
- a declared dataset, profile, chemistry, temperature, aging state, and split;
- a declared metric definition and aggregation policy;
- a frozen run command, config hash, result hash, log, and environment record;
- an explicit comparability, leakage, compute, and provenance caveat;
- a source-ledger row when external comparison language is present.

## Evidence Inspected

Read-only evidence inspected in this worktree:

| Evidence | Command | Finding |
|---|---|---|
| Current branch and dirty state | `git status --short --branch` | Branch is `phase-8-3-l-monthly-snapshot-artifact-schema-20260507T204627Z`; no edits existed before this artifact. |
| Repository structure | `find . -maxdepth 3 -type f \| sed 's#^./##' \| sort \| head -200` | The checked-out branch had no `specs/` tree before this artifact. |
| Phase 8 branches | `git branch --all --list '*phase-8-*'` | Wave 1, Wave 2, Wave 3, and Wave 4 branch names are visible locally and/or remotely for this integration wave. |
| Phase 8 log counts | `for p in 0 1 2; do ... manual-phase-8-$p-*.log ...; done` | Wave 1 through Wave 3 have 48 manual logs: 24 Wave 1, 12 Wave 2, 12 Wave 3. |
| Usage-limit logs | `for f in ... manual-phase-8-2-*.log; do rg -q -i 'usage limit' "$f" ...; done` | Three Wave 3 logs hit the prior usage limit: `phase-8-2-j`, `phase-8-2-k`, and `phase-8-2-l`. |
| Completion-like log status | `tail -n 80 "$f" \| rg -q 'Branch pushed\|pushed:\|Commit:\|Implemented and pushed\|completed\|changed files'` | Excluding the three usage-limit logs, 45 Wave 1 through Wave 3 logs are completion-like. |
| Wave 1 submission intake | `git show origin/phase-8-0-s-universal-async-submission-template:templates/universal-contributor-submission-template.md` | The submission template requires method identity, family, license, code or archive identity, adapter contract, split declaration, provenance artifacts, requested metrics, source-ledger rows, and reproduction commands. |
| Wave 1 contributor checklist | `git show origin/phase-8-0-s-universal-async-submission-template:docs/BSEBENCH-UNIVERSAL-CONTRIBUTOR-VALIDATION-CHECKLIST-2026-05-07.md` | Intake, plug-and-play, leakage, provenance, metric, comparison-ledger, reproduction, and monthly-snapshot readiness gates already exist as reviewer checks. |
| Wave 1 monthly snapshot schema doc | `git show origin/phase-8-0-t-universal-async-monthly-snapshot-schema:docs/BSEBENCH-MONTHLY-SNAPSHOT-SCHEMA-2026-05-07.md` | The first monthly schema defines `bsebench.monthly_benchmark_snapshot.v1`, required release caveats, result-row caveats, evidence artifacts, source ledgers, method registry, dataset registry, protocols, ranking groups, and result rows. |
| Wave 1 JSON Schema | `git show origin/phase-8-0-t-universal-async-monthly-snapshot-schema:docs/schemas/bsebench-monthly-benchmark-snapshot-v1.schema.json` | The machine-readable schema validates a frozen snapshot shape but does not yet make submission lifecycle state, gate status, and cross-reference closure first-class release fields. |
| Wave 1 fixtures | `git show origin/phase-8-0-t-universal-async-monthly-snapshot-schema:docs/fixtures/monthly-benchmark-snapshot/valid-minimal.json` and `...invalid-missing-row-caveat.json` | Fixtures prove required caveat enforcement, including a negative case for a missing result-row leakage caveat. |
| Wave 2 monthly workflow | `git show origin/phase-8-1-r-monthly-benchmark-workflow-design-20260507T193050Z:docs/universal/monthly-benchmark-workflow-20260507T193050Z.md` | The workflow defines monthly states from intake through frozen snapshot and publication gates G0-G9. |

## Findings

1. The existing monthly snapshot v1 schema is a useful base and should be kept
   as the result-bundle shape.
2. The release artifact still needs an explicit integration layer that makes
   submissions, dataset availability, metric definitions, validation gates, and
   provenance closure independently auditable.
3. A monthly snapshot must not be publishable when it has result rows that
   cannot be traced back to accepted submission packets, dataset availability
   records, metric definitions, protocol assignments, run evidence, and caveat
   fields.
4. The three Wave 3 usage-limit logs should be accounted for by Wave 4 retry
   artifacts before their topics are treated as completed evidence.
5. External comparison language must remain blocked unless every comparison row
   has a complete source ledger: stable source identity, retrieval date, exact
   metric, dataset, split or protocol, external value, frozen BSEBench value,
   comparability label, and caveat.

## Recommended Artifact Contract

Use `bsebench.monthly_snapshot_artifact.v1` as the release artifact contract.
It can embed or reference the existing
`bsebench.monthly_benchmark_snapshot.v1` JSON payload from Wave 1.

Top-level required sections:

| Section | Required | Purpose |
|---|---:|---|
| `schema_version` | yes | Constant `bsebench.monthly_snapshot_artifact.v1`. |
| `snapshot_identity` | yes | Names the month, candidate, release status, freeze timestamps, owner, and schema versions. |
| `immutable_refs` | yes | Records async/report, runner, stats, datasets, source-ledger, and artifact-bundle commits or hashes. |
| `submission_registry` | yes | Links each method row to an accepted, partial, blocked, rejected, or excluded submission packet. |
| `method_registry` | yes | Identifies ECMs, Kalman filters, observers, AI estimators, hybrid methods, baselines, and future method families. |
| `dataset_registry` | yes | Records dataset availability, license, cache identity, raw-source provenance, chemistry/profile/temperature/aging axes, and split IDs. |
| `metric_registry` | yes | Records metric definitions, units, directions, aggregation rules, missing-value handling, and failure policies. |
| `protocol_registry` | yes | Records task family, initialization policy, split policy, leakage guard, metric set, and dataset-method applicability. |
| `evidence_artifacts` | yes | Captures commands, configs, logs, output hashes, environment identity, replay notes, and artifact caveats. |
| `result_rows` | yes | Holds per-method, per-dataset, per-split, per-metric values or explicit invalid/missing/excluded statuses. |
| `source_ledgers` | yes | Holds external comparison evidence or an explicit `not_used` status. |
| `validation_gates` | yes | Captures pass/fail/blocking status for publication gates and validator commands. |
| `release_caveats` | yes | Summarizes coverage, comparability, leakage, provenance, source-ledger, ranking, and compute caveats. |
| `freeze_record` | yes | Records final publish decision, immutable artifact hashes, residual risks, and errata policy. |

## Required Fields

### `snapshot_identity`

Required fields:

| Field | Type | Rule |
|---|---|---|
| `snapshot_id` | string | Pattern `bsebench-monthly-YYYY-MM` with optional release-candidate suffix. |
| `snapshot_month` | string | Pattern `YYYY-MM`. |
| `cycle_window_start_utc` | datetime | Start of accepted submission window. |
| `cycle_window_end_utc` | datetime | End of accepted submission window. |
| `freeze_candidate_at_utc` | datetime | Timestamp when inputs become read-only for validation. |
| `frozen_at_utc` | datetime or null | Non-null only for frozen or published snapshots. |
| `release_status` | enum | `draft`, `release_candidate`, `frozen`, `published`, `withdrawn`, or `superseded`. |
| `release_owner` | string | Human or automation role responsible for the freeze record. |
| `schema_versions` | object | Snapshot, submission, source-ledger, protocol, metric, split, dataset-availability, and artifact schema IDs. |

Validation notes:

- `frozen_at_utc` must be null unless `release_status` is `frozen`,
  `published`, `withdrawn`, or `superseded`.
- Mutating `cycle_window_*`, `freeze_candidate_at_utc`, or base refs after
  `freeze_candidate_at_utc` requires a new candidate suffix.

### `immutable_refs`

Required fields:

| Field | Type | Rule |
|---|---|---|
| `async_report_commit` | sha1 | Commit containing the monthly snapshot artifact and public report. |
| `runner_commit` | sha1 | Commit used to execute protocols and generate raw evidence. |
| `stats_commit` | sha1 | Commit used to compute metrics and aggregations. |
| `datasets_commit` | sha1 | Commit used to resolve dataset manifests, splits, and availability. |
| `submission_bundle_sha256` | sha256 or null | Hash of frozen submission intake bundle, if bundled. |
| `source_ledger_bundle_sha256` | sha256 or null | Hash of source-ledger bundle, if external comparisons are used. |
| `artifact_manifest_sha256` | sha256 | Hash of the release artifact manifest or dossier index. |
| `public_report_sha256` | sha256 or null | Hash of public report, if generated. |

Validation notes:

- Comparable result rows require non-null runner, stats, datasets, and
  async/report commits.
- External comparison rows require non-null source-ledger bundle identity.
- Null hashes are allowed only with an explicit caveat and a gate status that
  prevents public comparison language.

### `submission_registry[]`

Each row links contributor intake to benchmark output.

Required fields:

| Field | Type | Rule |
|---|---|---|
| `submission_id` | string | Stable slug from the contributor packet. |
| `submission_type` | enum | `estimator_adapter`, `ecm_definition`, `observer`, `ai_estimator`, `hybrid_method`, `baseline`, `report_only`, or `other`. |
| `method_id` | string | Must match one `method_registry[].method_id`, unless status is `rejected`. |
| `method_family` | enum | `ecm`, `kalman_filter`, `observer`, `ai_estimator`, `hybrid`, `baseline`, or `other`. |
| `maintainer` | string | Maintainer or submitting organization. |
| `license` | string | SPDX ID or exact redistribution terms. |
| `code_url_or_archive` | string | Stable URL, release tag, local bundle path, or archive pointer. |
| `submission_commit_or_hash` | string | Git SHA, release digest, or archive checksum. |
| `entry_point` | string | Adapter path, executable, class, or `n/a` for report-only rows. |
| `runtime_environment_ref` | string | Environment manifest ID or caveated environment description. |
| `requested_metric_ids` | array | Metric IDs requested by the contributor. |
| `requested_protocol_ids` | array | Protocol IDs requested or assigned. |
| `intake_status` | enum | `received`, `accepted_for_smoke`, `accepted_for_benchmark`, `accepted_as_partial`, `blocked`, `rejected`, or `excluded`. |
| `submission_caveat` | string | Non-empty caveat describing scope, missing fields, or limits. |

Validation notes:

- A `result_rows[]` entry must not reference a submission with status
  `received`, `blocked`, or `rejected`.
- A submission with status `accepted_as_partial` may produce rows only with
  `comparability` set to `partial` or `not_comparable`.
- `requested_metric_ids` and `requested_protocol_ids` must resolve to the
  metric and protocol registries or be listed in `submission_caveat`.

### `method_registry[]`

Required fields:

| Field | Type | Rule |
|---|---|---|
| `method_id` | string | Stable method identifier used by result rows. |
| `display_name` | string | Public method label. |
| `method_family` | enum | `ecm`, `kalman_filter`, `observer`, `ai_estimator`, `hybrid`, `baseline`, or `other`. |
| `adapter_id` | string | Adapter or wrapper identifier. |
| `adapter_version` | string | Adapter schema or implementation version. |
| `training_data_policy` | string | Declares training and calibration data use. |
| `tuning_policy` | string | Declares hyperparameter and repeated-submission policy. |
| `determinism_policy` | string | Seeded, stochastic with seed, nondeterministic, or caveated. |
| `failure_behavior` | string | Invalid output, NaN, exception, diagnostic, fallback, or clipping behavior. |
| `method_caveat` | string | Non-empty caveat. |

Validation notes:

- Method family must be explicit; do not infer family from a display name.
- AI and hybrid methods require training, tuning, seed, and environment
  provenance before any comparable public result is allowed.
- Report-only methods can be archived but must be non-comparable unless their
  raw evidence and metric recomputation path are complete.

### `dataset_registry[]`

Required fields:

| Field | Type | Rule |
|---|---|---|
| `dataset_id` | string | Stable dataset/profile/cellset identifier. |
| `display_name` | string | Public dataset label. |
| `availability_snapshot_id` | string | Dataset availability artifact ID. |
| `chemistry` | string | Chemistry or `unknown` with caveat. |
| `profile_axis` | string | Drive/load/profile axis covered. |
| `temperature_axis` | string | Temperature condition axis covered. |
| `aging_axis` | string | SOH/aging condition axis covered. |
| `task_family` | enum | `soc`, `soh`, or `soc_soh`. |
| `raw_source_ref` | string | Raw data source, DOI, URL, cache, or local-source ref. |
| `cache_sha256` | sha256 or null | Frozen cache hash when available. |
| `license_status` | enum | `redistributable`, `local_only`, `restricted`, `unknown`, or `not_applicable`. |
| `split_ids` | array | Split IDs available for the snapshot. |
| `ground_truth_ref` | string | Ground truth source or generation artifact. |
| `dataset_caveat` | string | Non-empty caveat. |

Validation notes:

- Comparable rows require a dataset row with declared split IDs, license status,
  raw source provenance, and availability snapshot.
- `unknown` fields are allowed only when the result row is non-comparable or
  the caveat explains why the field cannot affect the reported metric.
- Remote availability is not implied by local cache availability.

### `metric_registry[]`

Required fields:

| Field | Type | Rule |
|---|---|---|
| `metric_id` | string | Stable metric identifier used by result rows. |
| `display_name` | string | Public metric label. |
| `task_family` | enum | `soc`, `soh`, `soc_soh`, `compute`, `robustness`, `transfer`, or `other`. |
| `unit` | string | Exact unit, or `dimensionless` with caveat. |
| `direction` | enum | `lower_is_better`, `higher_is_better`, or `not_ranked`. |
| `aggregation` | string | Aggregation axis and statistic. |
| `finite_value_policy` | string | Handling of NaN, inf, timeout, missing, and invalid outputs. |
| `missing_run_policy` | string | Whether missing rows are counted, excluded, or blocked. |
| `ranking_eligible` | boolean | True only when metric is eligible for ranking groups. |
| `metric_definition_ref` | string | Stats module, schema, equation, or artifact pointer. |
| `metric_caveat` | string | Non-empty caveat. |

Validation notes:

- Result rows must reference a metric ID, not a free-text metric label.
- Failed, invalid, timeout, or missing runs must remain visible in row counts.
- Multi-axis scores must preserve component axes; a single hidden aggregate is
  not enough for public comparability.

### `protocol_registry[]`

Required fields:

| Field | Type | Rule |
|---|---|---|
| `protocol_id` | string | Stable protocol identifier. |
| `protocol_version` | string | Protocol registry version. |
| `task_family` | enum | `soc`, `soh`, or `soc_soh`. |
| `dataset_ids` | array | Dataset IDs covered by the protocol. |
| `metric_ids` | array | Metric IDs computed by the protocol. |
| `initialization_policy` | enum | `nominal`, `degraded`, `mixed`, or `unknown`. |
| `split_policy_id` | string | Split policy or split manifest ID. |
| `leakage_guard_id` | string | Leakage guard report or validator ID. |
| `resource_limits_ref` | string | Runtime, memory, accelerator, timeout, or sandbox policy ref. |
| `protocol_caveat` | string | Non-empty caveat. |

Validation notes:

- Protocol dataset and metric IDs must resolve.
- Comparable rows require a protocol with a passing leakage guard.
- Degraded initialization results must identify the degraded-initialization
  policy and recovery/convergence metrics used.

### `evidence_artifacts[]`

Required fields:

| Field | Type | Rule |
|---|---|---|
| `evidence_artifact_id` | string | Stable evidence identifier. |
| `submission_id` | string | Submission that produced or owns this evidence. |
| `protocol_id` | string | Protocol executed or audited. |
| `run_id` | string | Stable run identifier. |
| `run_command` | string | Exact command used to generate the evidence. |
| `config_sha256` | sha256 | Hash of frozen config. |
| `result_sha256` | sha256 | Hash of raw result or metric table. |
| `log_sha256` | sha256 or null | Hash of execution log when available. |
| `environment_ref` | string | Lockfile, environment export, container digest, or caveated description. |
| `generated_at_utc` | datetime | Evidence generation timestamp. |
| `replay_status` | enum | `not_run`, `passed`, `failed`, `not_practical`, or `blocked`. |
| `artifact_caveat` | string | Non-empty caveat. |

Validation notes:

- A public value must map to at least one evidence artifact.
- `replay_status` of `failed` or `blocked` prevents comparable publication for
  rows derived from that evidence unless the row is marked invalid, missing, or
  excluded.
- Hashes must identify immutable content, not just directories.

### `result_rows[]`

Required fields:

| Field | Type | Rule |
|---|---|---|
| `row_id` | string | Stable row identifier. |
| `submission_id` | string | Must resolve to `submission_registry[]`. |
| `method_id` | string | Must resolve to `method_registry[]`. |
| `dataset_id` | string | Must resolve to `dataset_registry[]`. |
| `split_id` | string | Must be listed in the referenced dataset row. |
| `protocol_id` | string | Must resolve to `protocol_registry[]`. |
| `metric_id` | string | Must resolve to `metric_registry[]`. |
| `evidence_artifact_id` | string | Must resolve to `evidence_artifacts[]`. |
| `value` | number or null | Null allowed only for `missing`, `invalid`, or `excluded` rows. |
| `status` | enum | `valid`, `invalid`, `missing`, `excluded`, or `blocked`. |
| `comparability` | enum | `comparable`, `partial`, `not_comparable`, or `not_applicable`. |
| `rank` | integer or null | Non-null only for valid, comparable rows in a ranking group. |
| `ranking_group_id` | string or null | Ranking group or null. |
| `caveats` | object | Required row caveats listed below. |

Required row caveats:

- `comparability_caveat`
- `dataset_caveat`
- `split_caveat`
- `metric_caveat`
- `leakage_caveat`
- `provenance_caveat`
- `compute_caveat`
- `exclusion_caveat`

Validation notes:

- No result row may have an empty caveat string.
- `rank` must be null unless `status` is `valid`, `comparability` is
  `comparable`, the metric is ranking eligible, and the ranking group includes
  the row ID.
- `value` must be null for `missing`, `excluded`, and `blocked` rows.
- Invalid, missing, excluded, blocked, partial, and non-comparable rows must
  remain visible; they must not be silently removed from the snapshot.

### `source_ledgers[]`

Required fields:

| Field | Type | Rule |
|---|---|---|
| `source_ledger_id` | string | Stable source-ledger identifier. |
| `status` | enum | `not_used`, `complete`, `partial`, or `blocked`. |
| `source_id` | string or null | External source row ID when used. |
| `doi_or_stable_url` | string or null | Stable external source identifier. |
| `retrieved_at` | date or null | ISO date when external source was retrieved. |
| `external_metric` | string or null | Exact external metric and unit. |
| `external_dataset` | string or null | Exact external dataset, profile, and split when available. |
| `external_value` | string or null | Reported value plus table, figure, page, or artifact location. |
| `bsebench_row_id` | string or null | Frozen BSEBench result row being compared. |
| `comparability` | enum | `comparable`, `partial`, `not_comparable`, or `not_applicable`. |
| `source_ledger_caveat` | string | Non-empty caveat. |

Validation notes:

- Any public external comparison language requires at least one `complete`
  source-ledger row.
- Missing DOI or stable URL, retrieval date, exact metric, dataset, split,
  external value, BSEBench row ID, or caveat forces `partial`,
  `not_comparable`, or `blocked`.
- Source ledgers do not by themselves create SOTA, novelty, breakthrough, or
  verified-claim status.

### `validation_gates[]`

Each gate records a validator result. Gate statuses are:

`not_run`, `passed`, `failed`, `blocked`, `not_applicable`.

Required fields for every gate:

| Field | Type | Rule |
|---|---|---|
| `gate_id` | string | Stable gate identifier. |
| `gate_name` | string | Human-readable gate name. |
| `status` | enum | Gate status. |
| `blocking` | boolean | True when failure prevents freeze or publication. |
| `validator_command` | string | Exact command, script, or manual inspection command. |
| `validator_output_ref` | string | Artifact path, log path, or concise manual evidence pointer. |
| `checked_at_utc` | datetime | Validation timestamp. |
| `gate_caveat` | string | Non-empty caveat. |

Required publication gates:

| Gate | Name | Blocking Rule |
|---|---|---|
| `G0_SCOPE` | Protected-file and write-set gate | Fails if thesis, manuscript, claim registry, `claims/registry.yaml`, `claim_55`, roadmap, or unrelated files are modified. |
| `G1_SUBMISSION` | Submission completeness gate | Fails if any included method lacks a resolved submission packet and checklist decision. |
| `G2_ADAPTER` | Adapter contract gate | Fails if executable methods lack smoke validation or explicit exclusion. |
| `G3_DATASET` | Dataset availability gate | Fails if reported rows lack availability, license, split, or provenance records. |
| `G4_SPLIT_LEAKAGE` | Split and leakage gate | Fails if calibration, training, validation, tuning, and evaluation separation is missing or violated. |
| `G5_EVIDENCE` | Evidence provenance gate | Fails if public values lack command, config hash, result hash, output path, and commit identity. |
| `G6_METRICS` | Metrics integrity gate | Fails if metric definitions, units, aggregation, finite-value policy, or missing-run counts are incomplete. |
| `G7_SOURCE_LEDGER` | External comparison source-ledger gate | Fails if comparison language lacks complete source-ledger rows. |
| `G8_REPORT_QUALITY` | Report caveat and anti-hallucination gate | Fails if prose hides invalid rows, caveats, limitations, or unsupported ranking context. |
| `G9_FREEZE` | Freeze immutability gate | Fails if snapshot JSON, report, release checklist, and artifact hashes do not point to the same candidate. |

## Cross-Reference Invariants

The artifact is invalid unless all invariants hold:

1. Every `result_rows[].submission_id` resolves to exactly one
   `submission_registry[].submission_id`.
2. Every `result_rows[].method_id` resolves to exactly one
   `method_registry[].method_id`.
3. Every `result_rows[].dataset_id` resolves to exactly one
   `dataset_registry[].dataset_id`.
4. Every `result_rows[].split_id` appears in the referenced dataset row's
   `split_ids`.
5. Every `result_rows[].metric_id` resolves to exactly one
   `metric_registry[].metric_id`.
6. Every `result_rows[].protocol_id` resolves to exactly one
   `protocol_registry[].protocol_id`.
7. Every `result_rows[].evidence_artifact_id` resolves to exactly one
   `evidence_artifacts[].evidence_artifact_id`.
8. Every `source_ledgers[].bsebench_row_id`, when non-null, resolves to exactly
   one `result_rows[].row_id`.
9. Every ranking group includes only valid, comparable rows whose metric has
   `ranking_eligible=true`.
10. Every status other than `valid` has a visible caveat and a null value when
    a numeric value would imply publication-quality evidence.
11. Every public comparison row has complete source-ledger evidence or is marked
    `partial`, `not_comparable`, or `blocked`.
12. Every frozen or published snapshot has all blocking gates passed or marked
    `not_applicable` with a non-empty rationale.

## Pass/Fail Recommendations

Recommended freeze decision rules:

| Condition | Decision |
|---|---|
| Any blocking gate is `failed`, `blocked`, or `not_run` | Do not freeze. |
| Any comparable row lacks submission, dataset, metric, protocol, or evidence closure | Do not freeze. |
| Any public comparison text lacks a complete source ledger | Remove comparison text or do not publish. |
| Any result row lacks one of the required caveat fields | Do not freeze. |
| Any protected file is modified | Do not freeze; remove the protected-file change from the release lane. |
| All blocking gates pass and residual risks are recorded | Candidate may be frozen as a benchmark artifact. |

Recommended integration path:

1. Keep the Wave 1 `bsebench.monthly_benchmark_snapshot.v1` payload for result
   rows, method registry, dataset registry, protocols, ranking groups, release
   caveats, evidence artifacts, and source ledgers.
2. Add this artifact-level contract as a release dossier wrapper around that
   payload.
3. Promote `submission_registry`, `metric_registry`, `validation_gates`, and
   `freeze_record` to first-class machine-checkable sections before public
   monthly publication.
4. Treat the three prior usage-limit Wave 3 topics as unresolved until their
   retry branches produce committed and pushed artifacts.

## Residual Risks

- The Wave 1 and Wave 2 monthly artifacts were inspected from branch objects,
  not from a merged mainline release. Their final paths may change during
  integration.
- This artifact defines a schema and validation contract only. It does not
  implement JSON Schema, validator code, runner execution, stats computation,
  dataset ETL, or public report generation.
- Source-ledger completeness can be checked mechanically for field presence,
  but scientific comparability still requires reviewer judgment.
- Dataset availability rows can prove local manifest and cache state, but they
  do not prove remote uptime or redistributability unless the dataset lane
  records those facts.
- Hashes prove artifact identity only when the release process freezes exact
  bytes and records the hash command.

## Explicit Non-Claims

This artifact does not claim:

- BSEBench has published a monthly benchmark snapshot.
- Any method is best, SOTA, novel, a leaderboard winner, a breakthrough, or a
  verified scientific claim.
- Any external paper, repository, report, or benchmark is comparable to
  BSEBench without a completed source ledger.
- Any dataset is redistributable, remotely available, or legally cleared unless
  a dataset availability and license artifact says so.
- Any Wave 3 usage-limit task is complete without a retry artifact, commit SHA,
  and pushed branch.

## Validation Commands For This Artifact

Commands run while drafting:

```bash
pwd && git status --short --branch
rg --files specs | sort
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f | sort | wc -l
find . -maxdepth 3 -type f | sed 's#^./##' | sort | head -200
git branch --all --list '*phase-8-*'
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 2 -type f | sed 's#/home/oakir/.local/state/bsebench-async-watchdog/##' | sort | rg 'phase-8|Phase 8|wave|Wave|monthly|snapshot'
git ls-tree -r --name-only origin/phase-8-0-t-universal-async-monthly-snapshot-schema | sort
git ls-tree -r --name-only origin/phase-8-1-r-monthly-benchmark-workflow-design-20260507T193050Z | sort
for p in 0 1 2 3; do printf 'phase-8-%s ' "$p"; find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name "manual-phase-8-$p-*.log" | wc -l; done
git show origin/phase-8-0-t-universal-async-monthly-snapshot-schema:docs/BSEBENCH-MONTHLY-SNAPSHOT-SCHEMA-2026-05-07.md
git show origin/phase-8-0-t-universal-async-monthly-snapshot-schema:docs/schemas/bsebench-monthly-benchmark-snapshot-v1.schema.json
git show origin/phase-8-1-r-monthly-benchmark-workflow-design-20260507T193050Z:docs/universal/monthly-benchmark-workflow-20260507T193050Z.md
git show origin/phase-8-0-s-universal-async-submission-template:templates/universal-contributor-submission-template.md
git show origin/phase-8-0-s-universal-async-submission-template:docs/BSEBENCH-UNIVERSAL-CONTRIBUTOR-VALIDATION-CHECKLIST-2026-05-07.md
for f in /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-2-*.log; do if rg -q -i 'usage limit' "$f"; then basename "$f"; fi; done
for f in /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-[012]-*.log; do b=$(basename "$f"); if rg -q -i 'usage limit' "$f"; then printf 'usage_limit %s\n' "$b"; elif tail -n 80 "$f" | rg -q 'Branch pushed|pushed:|Commit:|Implemented and pushed|completed|changed files'; then printf 'completion_like %s\n' "$b"; else printf 'unclear %s\n' "$b"; fi; done | awk '{count[$1]++} END {for (k in count) print k, count[k]}'
tail -n 120 /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-2-j-reproducibility-artifact-manifest-audit-20260507T193528Z.log
tail -n 120 /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-2-k-merge-queue-runbook-20260507T193528Z.log
tail -n 120 /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-2-l-worker-triage-and-relaunch-runbook-20260507T193528Z.log
date -Iseconds
```

Pre-commit validation commands:

```bash
git diff --check
git diff --check --cached
git diff --check HEAD
git diff --name-only HEAD
git diff --cached --name-only
git status --short --branch
```

Observed validation results before commit:

- `git diff --check` returned no whitespace errors.
- `git diff --check --cached` returned no whitespace errors after staging this
  artifact.
- `git diff --cached --name-only` listed only
  `specs/universal/monthly-snapshot-artifact-schema-20260507T204627Z.md`.
- `git diff --cached --stat` reported one file changed with doc-only
  insertions.
- Guardrail scan for `SOTA`, `novel`, `leaderboard`, `breakthrough`,
  `verified-claim`, `claim_55`, `claims/registry.yaml`, `thesis`,
  `manuscript`, and `roadmap` found those terms only in explicit non-claim,
  protected-file, or blocking-gate contexts.
