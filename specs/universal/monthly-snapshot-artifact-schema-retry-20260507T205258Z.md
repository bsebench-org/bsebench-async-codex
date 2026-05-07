# BSEBench Universal Monthly Snapshot Artifact Schema

GLASSBOX metadata:
- Worker: W4-25
- Branch: phase-8-3-y-monthly-snapshot-artifact-schema-retry-20260507T205258Z
- Artifact path: specs/universal/monthly-snapshot-artifact-schema-retry-20260507T205258Z.md
- Created on: 2026-05-07
- Scope: schema/spec artifact only

## Purpose

This document defines the concrete artifact schema for a monthly BSEBench
universal benchmark snapshot. The artifact ties together submitted methods,
datasets, protocols, metrics, raw evidence, source ledgers, validation state,
public report constraints, and residual risks into one auditable release unit.

The schema is a wrapper around the Wave 1
`bsebench.monthly_benchmark_snapshot.v1` payload. It adds release-level
provenance, lifecycle state, anti-leakage review evidence, compute evidence,
hash discipline, report constraints, and fail-closed publication rules.

This document is a specification. It does not publish benchmark results, assert
method superiority, or upgrade any claim beyond the evidence and source-ledger
status captured by a future completed snapshot.

## Inspected Inputs

The following local artifacts and logs were inspected to derive this schema.

| Area | Evidence inspected | Schema implication |
| --- | --- | --- |
| Wave 1 benchmark charter | `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md` | Snapshot must support universal SOC/SOH scope, plug-and-play methods, leakage controls, caveats, and invalid-comparability states. |
| Wave 1 work plan | `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md` | Snapshot must connect monthly dataset availability, submission template, monthly schema, and release checklist workstreams. |
| Research gate protocol | `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` | Evidence provenance, source ledger, hashes, caveats, and non-claim constraints are required release gates. |
| Dataset availability worker log | `manual-phase-8-0-r-universal-datasets-monthly-availability.log`, commit `c1af5d0b4c7fa09c23b8d0c15113c95e570c4fbd` | Dataset registry must capture availability snapshot status, source refs, cache hashes, license status, blockers, and non-uptime caveats. |
| Submission template worker log | `manual-phase-8-0-s-universal-async-submission-template.log`, commit `8b8110b561029b7906a8ba27cd2613f5f1f25b91` | Submission records must include code identity, adapter contract, data/split declaration, metric request, artifacts, and source-ledger declarations. |
| Monthly schema worker log | `manual-phase-8-0-t-universal-async-monthly-snapshot-schema.log`, commit `669a4eac635fcd28130833fb4ac07b9ca4fb9b32` | Artifact must preserve Wave 1 `snapshot_identity`, `evidence_artifacts`, `source_ledgers`, `method_registry`, `dataset_registry`, `protocols`, `ranking_groups`, and `result_rows`. |
| Public release checklist worker log | `manual-phase-8-0-w-universal-async-public-release-checklist.log`, commit `1a337a630edea022a807e55c93d93a1cf1059084` | Public report constraints must be explicit and block publication on unresolved leakage, ledger, provenance, report-quality, or freeze gates. |
| Wave 2 monthly workflow log | `manual-phase-8-1-r-monthly-benchmark-workflow-design-20260507T193050Z.log`, commit `dba3ce242bb27fa783f633972378b36f6e1975c9` | Artifact must carry state-machine outputs, publication gates G0-G9, falsification conditions, freeze rules, and residual risks. |
| Existing Wave 1 monthly schema files | `docs/BSEBENCH-MONTHLY-SNAPSHOT-SCHEMA-2026-05-07.md`, `docs/schemas/bsebench-monthly-benchmark-snapshot-v1.schema.json` in the Wave 1 monthly schema worktree | Artifact should be compatible with `bsebench.monthly_benchmark_snapshot.v1` while adding stricter wrapper metadata. |
| Prior W4-12 snapshot artifact schema | `specs/universal/monthly-snapshot-artifact-schema-20260507T204627Z.md` in the W4-12 worktree | Retry keeps the same release-wrapper direction and makes required fields, invariants, and public-report constraints more concrete. |
| Submission lifecycle state machine | `specs/universal/submission-lifecycle-state-machine-20260507T204627Z.md` in the W4-13 worktree | Artifact must store per-submission states, transitions, validator outputs, release gate state, errata, closure, and withdrawal. |
| Runner submission smoke worktree | `bsebench-runner-phase-8-0-f-universal-runner-submission-smoke` | Evidence records must link adapter smoke output, runner version, split ID, metric output, and replay command. |
| Stats metric and compute worktrees | `bsebench-stats-phase-8-0-i-universal-stats-metric-matrix`, `bsebench-stats-phase-8-0-j-universal-stats-compute-cost-aggregator` | Metric registry and compute evidence must capture definition refs, finite-value policy, runtime, memory, cost, coverage, and missing-data policy. |

## Schema Identity

Recommended schema identifier:

```text
bsebench.monthly_snapshot_artifact.v1
```

Recommended file name:

```text
monthly-snapshot-artifact-YYYY-MM.json
```

Recommended JSON Schema file name:

```text
bsebench-monthly-snapshot-artifact-v1.schema.json
```

The artifact is immutable after freeze. Corrections after publication must use
an erratum record and a new artifact hash rather than changing the released
bytes in place.

## Top-Level Required Object

Every monthly snapshot artifact must contain these top-level keys:

```json
{
  "schema_version": "bsebench.monthly_snapshot_artifact.v1",
  "snapshot_identity": {},
  "immutable_refs": {},
  "artifact_index": [],
  "submission_registry": [],
  "submission_lifecycle": [],
  "method_registry": [],
  "dataset_registry": [],
  "metric_registry": [],
  "protocol_registry": [],
  "anti_leakage_reviews": [],
  "compute_evidence": [],
  "evidence_artifacts": [],
  "result_rows": [],
  "source_ledgers": [],
  "validation_gates": [],
  "public_report_constraints": {},
  "release_caveats": {},
  "freeze_record": {},
  "residual_risks": [],
  "errata": []
}
```

All timestamp fields use RFC 3339 UTC strings with a trailing `Z`. All file
hashes use lowercase hexadecimal SHA-256 unless the field name explicitly says
`commit_sha`, in which case the value is a Git commit SHA from the referenced
repository. Nullable values are only allowed where the field definition says so,
and every null must have a sibling caveat explaining why the value is absent.

## Enumerations

Release status:

```text
draft
release_candidate
frozen
published
withdrawn
superseded
```

Validation status:

```text
pass
pass_with_caveat
fail
blocked
not_applicable
not_run
```

Submission decision:

```text
received
accepted_for_smoke
accepted_for_benchmark
accepted_as_partial
blocked
rejected
withdrawn
excluded
```

Result status:

```text
valid
valid_with_caveat
partial
missing
invalid
timeout
blocked
excluded
withdrawn
```

Comparability:

```text
comparable
comparable_with_caveat
partial
not_comparable
internal_only
unknown
```

Risk severity:

```text
low
medium
high
blocking
```

Source ledger status:

```text
complete
complete_with_caveat
incomplete
not_applicable
blocked
withdrawn
```

## Field Definitions

### `snapshot_identity`

Required fields:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `snapshot_id` | string | yes | Stable ID, for example `bsebench-universal-2026-05`. |
| `snapshot_month` | string | yes | Month in `YYYY-MM` form. |
| `cycle_window_start` | string | yes | UTC timestamp for submission-cycle opening. |
| `cycle_window_end` | string | yes | UTC timestamp for submission-cycle closing. |
| `freeze_candidate_at` | string | yes | UTC timestamp when candidate bytes were first proposed for freeze. |
| `frozen_at` | string or null | yes | UTC timestamp for frozen artifact bytes, null before freeze with caveat. |
| `release_status` | enum | yes | One of the release status values. |
| `owner` | string | yes | Person, role, or automation account accountable for the snapshot. |
| `benchmark_scope` | array[string] | yes | Task families covered by this snapshot, such as `soc`, `soh`, `runtime`, `robustness`. |
| `artifact_schema_version` | string | yes | Must equal this schema identifier. |
| `embedded_snapshot_schema_version` | string | yes | Wave 1 payload schema, normally `bsebench.monthly_benchmark_snapshot.v1`. |
| `identity_caveat` | string | yes | Human-readable limitations on the snapshot identity or scope. |

### `immutable_refs`

Required fields:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `async_report_repo` | string | yes | Repository URL or local canonical repository ID for report/spec artifacts. |
| `async_report_branch` | string | yes | Branch used to assemble the artifact. |
| `async_report_commit_sha` | string | yes | Git commit SHA that produced this artifact. |
| `runner_repo` | string | yes | Runner repository ID or URL. |
| `runner_commit_sha` | string | yes | Runner commit used for evidence generation. |
| `datasets_repo` | string | yes | Dataset repository ID or URL. |
| `datasets_commit_sha` | string | yes | Dataset code/metadata commit used by the snapshot. |
| `stats_repo` | string | yes | Stats/metrics repository ID or URL. |
| `stats_commit_sha` | string | yes | Stats/metrics commit used for metric computation. |
| `submission_bundle_sha256` | string | yes | SHA-256 over the canonical bundle of accepted submission manifests. |
| `source_ledger_bundle_sha256` | string | yes | SHA-256 over the canonical bundle of source ledgers. |
| `artifact_manifest_sha256` | string | yes | SHA-256 over `artifact_index` after deterministic serialization. |
| `embedded_snapshot_sha256` | string | yes | SHA-256 of the embedded Wave 1 monthly snapshot payload. |
| `public_report_sha256` | string or null | yes | SHA-256 of the public report bytes, null before report generation with caveat. |
| `hash_algorithm` | string | yes | Must be `sha256`. |
| `hash_command` | string | yes | Exact command used to compute file hashes, for example `sha256sum <path>`. |
| `refs_caveat` | string | yes | Limitations on immutable references. |

### `artifact_index`

Each entry describes one file that is part of the frozen release package.

Required fields per entry:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `artifact_id` | string | yes | Stable ID referenced elsewhere in the artifact. |
| `artifact_type` | string | yes | Example values: `submission_manifest`, `source_ledger`, `raw_result`, `metric_table`, `run_log`, `environment`, `public_report`, `schema`, `dataset_card`, `split_manifest`. |
| `path` | string | yes | Repository-relative or package-relative path. |
| `sha256` | string | yes | SHA-256 of the exact bytes. |
| `size_bytes` | integer | yes | Byte size of the exact file. |
| `created_at` | string | yes | UTC creation timestamp or deterministic package timestamp. |
| `generated_by_command` | string | yes | Exact command or `manual` with reviewer ID and caveat. |
| `producer_commit_sha` | string | yes | Git commit SHA for the producing toolchain. |
| `content_semantics` | string | yes | Short description of what the artifact proves. |
| `artifact_caveat` | string | yes | Limitations or known gaps for this file. |

### `submission_registry`

One entry is required for every submission that enters the monthly cycle,
including rejected, blocked, withdrawn, and excluded submissions. This prevents
public reports from silently omitting failed or non-comparable entries.

Required fields per entry:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `submission_id` | string | yes | Stable monthly submission ID. |
| `submission_version` | string | yes | Submitter-provided version or monthly intake version. |
| `method_id` | string | yes | References `method_registry.method_id`. |
| `submission_type` | enum | yes | `ecm`, `ml`, `hybrid`, `baseline`, `external_reference`, or `other`. |
| `task_families` | array[string] | yes | Task families the submitter requested. |
| `maintainer` | string | yes | Submitter or maintainer identity. |
| `license` | string | yes | License name or `unknown` with caveat. |
| `code_url` | string or null | yes | Stable URL when public code exists. |
| `code_archive_artifact_id` | string or null | yes | References `artifact_index` when an archive is used. |
| `code_commit_sha` | string or null | yes | Commit SHA for public repository submissions. |
| `code_archive_sha256` | string or null | yes | SHA-256 for archive submissions. |
| `entry_point` | string | yes | Adapter import path or executable entry point. |
| `runtime_environment_artifact_id` | string | yes | References environment lock/export artifact. |
| `dependency_lock_artifact_id` | string or null | yes | Dependency lockfile artifact, null only with caveat. |
| `declared_training_data` | array[string] | yes | Dataset IDs or external data declarations used for fitting. |
| `declared_calibration_data` | array[string] | yes | Dataset IDs or external data declarations used for calibration. |
| `declared_tuning_data` | array[string] | yes | Dataset IDs or external data declarations used for hyperparameter tuning. |
| `declared_evaluation_data` | array[string] | yes | Dataset IDs expected for evaluation; may be empty for hidden splits. |
| `requested_metrics` | array[string] | yes | Metric IDs requested by submitter. |
| `requested_protocols` | array[string] | yes | Protocol IDs requested by submitter. |
| `decision` | enum | yes | One of the submission decision values. |
| `decision_at` | string | yes | UTC timestamp for latest decision. |
| `decision_reason` | string | yes | Reviewer or automation rationale. |
| `visibility` | enum | yes | `public`, `redacted`, `private_until_release`, or `withheld`. |
| `submission_caveat` | string | yes | Known submission limitations. |

### `submission_lifecycle`

This section stores the state-machine evidence for each submission. It mirrors
the monthly workflow and submission lifecycle specs so that the release artifact
can explain why a submission is benchmarked, partial, blocked, or excluded.

Required fields per entry:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `submission_id` | string | yes | References `submission_registry.submission_id`. |
| `current_state` | string | yes | Latest lifecycle state, such as `monthly_candidate`, `frozen_snapshot`, `release_blocked`, `withdrawn`, or `rejected`. |
| `terminal` | boolean | yes | Whether no further monthly transitions are expected. |
| `transitions` | array[object] | yes | Ordered transition history. |
| `required_validator_ids` | array[string] | yes | Validation gate IDs required for this submission. |
| `passed_validator_ids` | array[string] | yes | Validator IDs that passed or passed with caveat. |
| `blocking_validator_ids` | array[string] | yes | Validator IDs blocking release inclusion. |
| `reviewer` | string | yes | Reviewer, role, or automation account for latest lifecycle decision. |
| `lifecycle_caveat` | string | yes | Lifecycle ambiguity, retry history, or human-review caveat. |

Each `transitions[]` object requires:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `from_state` | string or null | yes | Null only for initial intake. |
| `to_state` | string | yes | New lifecycle state. |
| `transition_at` | string | yes | UTC timestamp. |
| `trigger` | string | yes | Command, reviewer action, or event. |
| `evidence_artifact_ids` | array[string] | yes | Evidence artifacts supporting the transition. |
| `decision` | enum | yes | `pass`, `pass_with_caveat`, `fail`, `blocked`, or `withdrawn`. |
| `residual_risk_ids` | array[string] | yes | References release-level risks when applicable. |
| `transition_caveat` | string | yes | Transition-specific limitations. |

### `method_registry`

Required fields per entry:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `method_id` | string | yes | Stable method ID. |
| `display_name` | string | yes | Report display name. |
| `method_family` | string | yes | `ecm`, `ml`, `hybrid`, `baseline`, `external_reference`, or `other`. |
| `adapter_contract_version` | string | yes | Adapter contract version. |
| `adapter_entry_point` | string | yes | Import path or executable entry point. |
| `determinism_mode` | string | yes | `deterministic`, `seeded`, `stochastic`, or `unknown`. |
| `seed_policy` | string | yes | Required seed handling for replay. |
| `training_status` | string | yes | `pretrained`, `trained_in_cycle`, `calibrated_only`, `no_training`, or `unknown`. |
| `external_services` | array[string] | yes | Network or service dependencies; empty if none. |
| `failure_behavior` | string | yes | How invalid inputs, missing outputs, and timeouts are represented. |
| `method_caveat` | string | yes | Known method limitations or comparability caveats. |

### `dataset_registry`

Required fields per entry:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `dataset_id` | string | yes | Stable dataset ID used in result rows. |
| `display_name` | string | yes | Public display name. |
| `availability_snapshot_id` | string | yes | Monthly dataset availability snapshot ID. |
| `availability_status` | string | yes | Availability status from the dataset snapshot. |
| `record_source` | string | yes | Source of the dataset record. |
| `raw_source_ref` | string | yes | Stable URL, DOI, local acquisition ref, or reason unavailable. |
| `cache_artifact_id` | string or null | yes | Cached dataset artifact, null only with caveat. |
| `cache_sha256` | string or null | yes | SHA-256 of cached dataset bytes or manifest. |
| `license_status` | string | yes | `known`, `restricted`, `unknown`, `not_redistributable`, or equivalent local enum. |
| `chemistry_tags` | array[string] | yes | Chemistry labels when known. |
| `task_families` | array[string] | yes | Task families supported by this dataset. |
| `temperature_tags` | array[string] | yes | Temperature profile tags when known. |
| `aging_profile_tags` | array[string] | yes | Aging profile tags when known. |
| `split_manifest_artifact_id` | string | yes | References the split manifest in `artifact_index`. |
| `split_ids` | array[string] | yes | Split IDs available for protocols. |
| `ground_truth_ref` | string | yes | Source of SOC/SOH labels or reason unavailable. |
| `dataset_card_artifact_id` | string | yes | References dataset card artifact. |
| `dataset_caveat` | string | yes | Availability, licensing, representativeness, or preprocessing caveat. |

### `metric_registry`

Metric definitions must be versioned and independent from any public report
wording. A result row cannot invent metric semantics.

Required fields per entry:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `metric_id` | string | yes | Stable metric ID, for example `soc_rmse`, `soc_mae`, `soc_maxe`, `soh_rmse`, `runtime_seconds`, `memory_peak_mb`, or `cost_usd`. |
| `display_name` | string | yes | Public display label. |
| `task_family` | string | yes | `soc`, `soh`, `runtime`, `robustness`, `transfer`, or `other`. |
| `unit` | string | yes | Measurement unit. |
| `direction` | enum | yes | `lower_is_better`, `higher_is_better`, `target_is_better`, or `not_ranked`. |
| `aggregation_axes` | array[string] | yes | Axes aggregated over, such as `cell`, `cycle`, `temperature`, `profile`, `seed`, `fold`. |
| `aggregation_method` | string | yes | Exact aggregation function. |
| `finite_value_policy` | string | yes | How NaN, Inf, missing output, timeout, and invalid output are handled. |
| `missing_value_policy` | string | yes | Required status and caveat behavior for missing values. |
| `ranking_eligible` | boolean | yes | Whether the metric may participate in a ranking group. |
| `definition_ref` | string | yes | File path, function, or document anchor defining the metric. |
| `definition_commit_sha` | string | yes | Stats repository commit SHA containing the definition. |
| `metric_caveat` | string | yes | Metric-specific limitations. |

### `protocol_registry`

Required fields per entry:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `protocol_id` | string | yes | Stable protocol ID. |
| `protocol_version` | string | yes | Protocol version. |
| `task_family` | string | yes | Task family this protocol evaluates. |
| `dataset_ids` | array[string] | yes | Dataset IDs allowed for this protocol. |
| `split_ids` | array[string] | yes | Split IDs allowed for this protocol. |
| `metric_ids` | array[string] | yes | Metric IDs computed by this protocol. |
| `initialization_policy` | string | yes | SOC/SOH initialization and warmup policy. |
| `calibration_policy` | string | yes | Calibration data and fitting scope. |
| `tuning_policy` | string | yes | Hyperparameter tuning scope. |
| `evaluation_policy` | string | yes | Evaluation data and hidden-label policy. |
| `resource_limits` | object | yes | Time, memory, accelerator, and retry limits. |
| `leakage_guard_ids` | array[string] | yes | Anti-leakage review IDs required by this protocol. |
| `protocol_caveat` | string | yes | Protocol limitations. |

### `anti_leakage_reviews`

Every benchmarked result row must reference at least one anti-leakage review
covering its submission, dataset, split, and protocol. A review must fail
closed when evidence is missing.

Required fields per entry:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `anti_leakage_review_id` | string | yes | Stable review ID. |
| `submission_id` | string | yes | References `submission_registry`. |
| `method_id` | string | yes | References `method_registry`. |
| `dataset_id` | string | yes | References `dataset_registry`. |
| `protocol_id` | string | yes | References `protocol_registry`. |
| `training_split_ids` | array[string] | yes | Splits used for training or fitting. |
| `calibration_split_ids` | array[string] | yes | Splits used for calibration. |
| `tuning_split_ids` | array[string] | yes | Splits used for model or hyperparameter selection. |
| `validation_split_ids` | array[string] | yes | Splits used for validation. |
| `evaluation_split_ids` | array[string] | yes | Splits used for benchmark scoring. |
| `overlap_check_artifact_id` | string | yes | Artifact proving split-overlap check result. |
| `preprocessing_fit_scope` | string | yes | Scope for normalizers, feature extractors, or filters. |
| `label_access_check` | string | yes | Evidence that evaluation labels were not used for fitting or tuning. |
| `future_sample_check` | string | yes | Evidence that future information was not used in causal protocols. |
| `public_output_tuning_check` | string | yes | Evidence that public results were not used to tune the submission inside the cycle. |
| `external_training_data_review` | string | yes | Review of external data declarations and compatibility. |
| `status` | enum | yes | Validation status. |
| `blocking` | boolean | yes | True when unresolved leakage risk blocks release inclusion. |
| `reviewer` | string | yes | Reviewer, role, or automation account. |
| `reviewed_at` | string | yes | UTC timestamp. |
| `anti_leakage_caveat` | string | yes | Residual leakage uncertainty or explicit `none_known`. |

### `compute_evidence`

Compute evidence is required for every result row that reports runtime,
memory, cost, deployment, or resource-normalized metrics. It is also required
as contextual evidence for non-compute metrics when public tables compare
methods with materially different resource profiles.

Required fields per entry:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `compute_evidence_id` | string | yes | Stable compute evidence ID. |
| `submission_id` | string | yes | References `submission_registry`. |
| `run_id` | string | yes | Runner run ID. |
| `protocol_id` | string | yes | References `protocol_registry`. |
| `dataset_id` | string | yes | References `dataset_registry`. |
| `split_id` | string | yes | Evaluated split. |
| `hardware` | object | yes | CPU, memory, accelerator, and storage summary. |
| `operating_system` | string | yes | OS name/version. |
| `runner_version` | string | yes | Runner package version or commit. |
| `measurement_tool` | string | yes | Tool used to measure runtime/memory/cost. |
| `sampling_interval_seconds` | number or null | yes | Sampling interval, null only if event-based with caveat. |
| `run_count` | integer | yes | Number of repeated runs included. |
| `runtime_seconds` | number or null | yes | Wall-clock runtime; null only with `compute_status != pass`. |
| `per_step_runtime_seconds` | number or null | yes | Per-step runtime when meaningful. |
| `memory_peak_mb` | number or null | yes | Peak memory in MB. |
| `cost_usd` | number or null | yes | Estimated cost in USD, null when not estimated with caveat. |
| `coverage_count` | integer | yes | Number of expected evaluations covered. |
| `coverage_fraction` | number | yes | Fraction in `[0, 1]`. |
| `log_artifact_id` | string | yes | Runtime or profiler log artifact. |
| `environment_artifact_id` | string | yes | Environment export artifact. |
| `compute_status` | enum | yes | Validation status. |
| `compute_caveat` | string | yes | Hardware, measurement, missing-data, or cost-estimation caveat. |

### `evidence_artifacts`

Evidence artifacts connect commands, input hashes, output hashes, and review
status. They must be sufficient for a future auditor to replay or falsify a
snapshot row.

Required fields per entry:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `evidence_artifact_id` | string | yes | Stable evidence ID. |
| `artifact_ids` | array[string] | yes | References `artifact_index` entries that make up this evidence bundle. |
| `submission_id` | string or null | yes | Submission ID or null for release-level evidence. |
| `run_id` | string or null | yes | Runner run ID when evidence comes from execution. |
| `command` | string | yes | Exact command used. |
| `working_directory` | string | yes | Repository-relative or package-relative working directory. |
| `input_artifact_ids` | array[string] | yes | Input artifact references. |
| `input_sha256` | object | yes | Map from input path/ref to SHA-256. |
| `config_artifact_id` | string or null | yes | Config artifact reference. |
| `config_sha256` | string or null | yes | Config hash. |
| `output_artifact_ids` | array[string] | yes | Output artifact references. |
| `output_sha256` | object | yes | Map from output path/ref to SHA-256. |
| `stdout_log_artifact_id` | string or null | yes | Stdout log artifact. |
| `stderr_log_artifact_id` | string or null | yes | Stderr log artifact. |
| `environment_artifact_id` | string | yes | Environment lock/export artifact. |
| `producer_commit_sha` | string | yes | Commit SHA for the tool that produced the evidence. |
| `generated_at` | string | yes | UTC timestamp. |
| `replay_status` | enum | yes | Validation status for replay. |
| `reviewer` | string | yes | Reviewer, role, or automation account. |
| `evidence_caveat` | string | yes | Replay, provenance, or environment limitations. |

### `result_rows`

Each row is one measured value or one explicit non-result for a
submission-method-dataset-split-protocol-metric tuple.

Required fields per entry:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `row_id` | string | yes | Stable result row ID. |
| `submission_id` | string | yes | References `submission_registry`. |
| `method_id` | string | yes | References `method_registry`. |
| `dataset_id` | string | yes | References `dataset_registry`. |
| `split_id` | string | yes | References `dataset_registry.split_ids`. |
| `protocol_id` | string | yes | References `protocol_registry`. |
| `metric_id` | string | yes | References `metric_registry`. |
| `metric_value` | number or null | yes | Numeric value, null for missing/invalid/blocked rows. |
| `metric_unit` | string | yes | Must match `metric_registry.unit`. |
| `status` | enum | yes | Result status. |
| `comparability` | enum | yes | Comparability state. |
| `evidence_artifact_id` | string | yes | References `evidence_artifacts`. |
| `anti_leakage_review_id` | string | yes | References `anti_leakage_reviews`. |
| `compute_evidence_id` | string or null | yes | Required for compute or resource-context rows; null otherwise with caveat. |
| `source_ledger_ids` | array[string] | yes | Source ledger IDs supporting external comparisons; empty for internal-only rows. |
| `ranking_group_id` | string or null | yes | Ranking group ID, null when not ranked. |
| `rank` | integer or null | yes | Rank within group, null unless row is valid, comparable, and ranking eligible. |
| `aggregate_sample_count` | integer | yes | Count of samples included in metric aggregation. |
| `missing_sample_count` | integer | yes | Count of missing or invalid expected samples. |
| `timeout_count` | integer | yes | Count of timed-out expected samples. |
| `failure_count` | integer | yes | Count of failed expected samples. |
| `result_caveat` | string | yes | Row-specific caveat. |

### `source_ledgers`

The source ledger is required for any public report text or table that compares
BSEBench results against external literature, external benchmark claims, prior
published values, or public method descriptions. Rows with no such comparison
may use `not_applicable`, but the public report must not imply external
comparability for those rows.

Required fields per entry:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `ledger_id` | string | yes | Stable ledger row ID. |
| `status` | enum | yes | Source ledger status. |
| `source_id` | string | yes | Stable source ID used within the monthly release. |
| `title` | string | yes | Source title. |
| `doi_or_stable_url` | string | yes | DOI, stable URL, or explicit unavailable reason. |
| `retrieved_at` | string | yes | UTC retrieval timestamp. |
| `retrieval_artifact_id` | string | yes | Artifact proving retrieved source metadata or excerpt. |
| `external_method_name` | string | yes | Method name as reported by the source. |
| `external_metric` | string | yes | Metric name as reported by the source. |
| `external_dataset` | string | yes | Dataset as reported by the source. |
| `external_split` | string | yes | Split/protocol as reported by the source. |
| `external_value` | string | yes | Value exactly as normalized into ledger form. |
| `external_unit` | string | yes | Unit as reported or normalized. |
| `bsebench_row_id` | string or null | yes | Result row being compared, null for source-only context. |
| `bsebench_metric_id` | string or null | yes | BSEBench metric ID when applicable. |
| `bsebench_dataset_id` | string or null | yes | BSEBench dataset ID when applicable. |
| `bsebench_split_id` | string or null | yes | BSEBench split ID when applicable. |
| `bsebench_value` | number or null | yes | BSEBench value when applicable. |
| `normalization_notes` | string | yes | Unit conversion or semantic normalization notes. |
| `comparability` | enum | yes | Comparability state. |
| `reviewer` | string | yes | Reviewer, role, or automation account. |
| `reviewed_at` | string | yes | UTC timestamp. |
| `source_ledger_caveat` | string | yes | Caveat required even when status is complete. |

### `validation_gates`

The monthly artifact uses release gates G0-G9. A published snapshot requires
all blocking gates to be `pass`, `pass_with_caveat`, or `not_applicable` with a
non-empty caveat and reviewer approval.

Required gates:

| Gate | Name | Blocking | Minimum evidence |
| --- | --- | --- | --- |
| `G0` | Scope and intake completeness | yes | Snapshot scope, submission inventory, and explicit exclusions. |
| `G1` | Submission manifest completeness | yes | Required submission fields, artifacts, licenses, and entry points. |
| `G2` | Adapter, sandbox, security, and deterministic replay | yes | Smoke logs, static-risk review, dependency restore, sandbox result, replay output. |
| `G3` | Dataset availability and license review | yes | Monthly availability snapshot, dataset cards, split manifests, cache hashes, blockers. |
| `G4` | Anti-leakage and split integrity | yes | Anti-leakage reviews, split overlap checks, training/calibration/tuning/evaluation separation. |
| `G5` | Evidence provenance and hashes | yes | Commands, input/output hashes, environment, run logs, replay status. |
| `G6` | Metric integrity and finite-value policy | yes | Metric registry refs, aggregation policy, invalid/missing/timeout handling. |
| `G7` | Source ledger and comparability review | yes when external comparison is public | Completed source ledgers, retrieval evidence, caveats, and normalized comparison notes. |
| `G8` | Public report constraints | yes | Report template checks, caveat table, forbidden-language scan, no unsupported table claims. |
| `G9` | Freeze immutability and publication manifest | yes | Artifact index, package hash, report hash, sign-off record, errata linkage. |

Required fields per gate entry:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `gate_id` | string | yes | One of `G0` through `G9`. |
| `gate_name` | string | yes | Human-readable gate name. |
| `status` | enum | yes | Validation status. |
| `blocking` | boolean | yes | Whether this gate can block publication. |
| `scope` | string | yes | `release`, `submission`, `dataset`, `protocol`, `result_row`, or `report`. |
| `affected_ids` | array[string] | yes | IDs affected by this gate. |
| `validator_command` | string | yes | Exact command, reviewer checklist ID, or `manual:<reviewer>` with caveat. |
| `input_artifact_ids` | array[string] | yes | Evidence inputs. |
| `output_artifact_id` | string | yes | Evidence output artifact. |
| `checked_at` | string | yes | UTC timestamp. |
| `reviewer` | string | yes | Reviewer, role, or automation account. |
| `residual_risk_ids` | array[string] | yes | Risks that remain after this gate. |
| `gate_caveat` | string | yes | Required caveat, including `none_known` when appropriate. |

### `public_report_constraints`

This object controls what a public report may say when generated from the
snapshot artifact.

Required fields:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `public_report_artifact_id` | string or null | yes | Artifact ID for the generated report, null before report generation. |
| `public_report_sha256` | string or null | yes | SHA-256 of report bytes, null before report generation. |
| `report_generator_command` | string | yes | Exact command used to generate the report. |
| `allowed_snapshot_ids` | array[string] | yes | Snapshot IDs that report tables may cite. |
| `required_caveat_sections` | array[string] | yes | Required caveat sections in the public report. |
| `forbidden_language_patterns` | array[string] | yes | Terms or regex patterns that require a completed ledger and reviewer exception. |
| `ranking_policy` | string | yes | Ranking constraints for comparable rows and ranking-eligible metrics only. |
| `invalid_row_display_policy` | string | yes | How missing, invalid, blocked, partial, and excluded rows must appear. |
| `source_ledger_public_policy` | string | yes | Rule requiring source-ledger citation before external comparison language. |
| `residual_risk_public_policy` | string | yes | Rule requiring public disclosure of non-blocking risks. |
| `redaction_policy` | string | yes | What may be redacted and how redactions are labeled. |
| `report_status` | enum | yes | Validation status for the report. |
| `report_caveat` | string | yes | Report-specific caveat. |

Minimum report constraints:

- A row with `comparability` other than `comparable` or
  `comparable_with_caveat` cannot appear in a comparative ranking table.
- A row with `status` other than `valid` or `valid_with_caveat` must be shown
  as non-result, blocked, partial, excluded, or missing; it cannot be silently
  dropped from submission accounting.
- External comparison prose requires at least one referenced source ledger with
  `status` equal to `complete` or `complete_with_caveat`.
- A public report must include `snapshot_id`, `snapshot_month`,
  `artifact_manifest_sha256`, `embedded_snapshot_sha256`, and
  `public_report_sha256`.
- A public report must include residual risks whose severity is `medium`,
  `high`, or `blocking`. Blocking residual risks must force
  `release_status != published`.

### `release_caveats`

Required fields:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `coverage_caveat` | string | yes | Coverage limitations for tasks, datasets, metrics, or methods. |
| `comparability_caveat` | string | yes | Limits on cross-method or external comparison. |
| `leakage_caveat` | string | yes | Residual leakage uncertainty. |
| `provenance_caveat` | string | yes | Provenance gaps, replay limitations, or environment limitations. |
| `source_ledger_caveat` | string | yes | Source-ledger coverage limitations. |
| `compute_caveat` | string | yes | Runtime, hardware, memory, or cost limitations. |
| `ranking_caveat` | string | yes | Ranking limitations or statement that no ranking is published. |
| `public_report_caveat` | string | yes | Public-report limitations. |
| `residual_risk_caveat` | string | yes | Summary of unresolved non-blocking risks. |

### `freeze_record`

Required fields:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `freeze_id` | string | yes | Stable freeze record ID. |
| `freeze_requested_at` | string | yes | UTC timestamp. |
| `frozen_at` | string or null | yes | UTC timestamp, null before freeze. |
| `freeze_requested_by` | string | yes | Role, person, or automation account. |
| `freeze_approved_by` | string or null | yes | Approver, null before approval with caveat. |
| `artifact_manifest_sha256` | string | yes | SHA-256 of frozen artifact manifest. |
| `snapshot_artifact_sha256` | string | yes | SHA-256 of full monthly snapshot artifact JSON. |
| `embedded_snapshot_sha256` | string | yes | SHA-256 of embedded Wave 1 snapshot payload. |
| `public_report_sha256` | string or null | yes | SHA-256 of report bytes, null before report generation. |
| `blocking_gate_status` | object | yes | Map from gate ID to status. |
| `publish_decision` | enum | yes | `publish`, `hold`, `withdraw`, or `supersede`. |
| `publish_decision_reason` | string | yes | Rationale for decision. |
| `errata_policy` | string | yes | How post-freeze corrections are handled. |
| `freeze_caveat` | string | yes | Freeze limitations or `none_known`. |

### `residual_risks`

Residual-risk disclosure is required for all known risks, including risks that
do not block publication. Public reports must carry the public wording for all
medium, high, and blocking risks.

Required fields per entry:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `risk_id` | string | yes | Stable risk ID. |
| `title` | string | yes | Short risk title. |
| `severity` | enum | yes | Risk severity. |
| `blocking` | boolean | yes | True if publication is blocked while unresolved. |
| `affected_submission_ids` | array[string] | yes | Affected submissions. |
| `affected_dataset_ids` | array[string] | yes | Affected datasets. |
| `affected_protocol_ids` | array[string] | yes | Affected protocols. |
| `affected_result_row_ids` | array[string] | yes | Affected result rows. |
| `affected_artifact_ids` | array[string] | yes | Affected release artifacts. |
| `detected_by_gate_id` | string | yes | Gate that detected or owns the risk. |
| `owner` | string | yes | Risk owner. |
| `mitigation` | string | yes | Planned or completed mitigation. |
| `publish_consequence` | string | yes | How the risk affects publication, ranking, caveats, or exclusions. |
| `public_wording` | string | yes | Required report wording or explicit redaction rationale. |
| `status` | enum | yes | `open`, `mitigated`, `accepted`, `blocked`, or `closed`. |
| `reviewed_at` | string | yes | UTC timestamp. |
| `risk_caveat` | string | yes | Risk-specific caveat. |

### `errata`

Required fields per entry:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `erratum_id` | string | yes | Stable erratum ID. |
| `opened_at` | string | yes | UTC timestamp. |
| `status` | enum | yes | `open`, `fixed_in_superseding_snapshot`, `withdrawn`, or `closed_no_change`. |
| `affected_snapshot_artifact_sha256` | string | yes | Hash of the affected released artifact. |
| `affected_ids` | array[string] | yes | Affected rows, submissions, datasets, gates, or report artifacts. |
| `description` | string | yes | Erratum description. |
| `public_notice_artifact_id` | string or null | yes | Public notice artifact, null before publication with caveat. |
| `replacement_snapshot_id` | string or null | yes | Superseding snapshot ID if any. |
| `erratum_caveat` | string | yes | Erratum limitations. |

## Cross-Reference Invariants

The artifact validator must enforce these invariants:

1. Every `result_rows[].submission_id` resolves to
   `submission_registry[].submission_id`.
2. Every `result_rows[].method_id` resolves to `method_registry[].method_id`
   and matches the referenced submission's `method_id`.
3. Every `result_rows[].dataset_id` resolves to `dataset_registry[].dataset_id`.
4. Every `result_rows[].split_id` appears in the referenced
   `dataset_registry[].split_ids`.
5. Every `result_rows[].protocol_id` resolves to
   `protocol_registry[].protocol_id` and the row dataset, split, and metric are
   allowed by that protocol.
6. Every `result_rows[].metric_id` resolves to `metric_registry[].metric_id`.
7. Every result row references a valid `evidence_artifacts` entry and a valid
   `anti_leakage_reviews` entry.
8. Any row reporting a compute or resource metric references a valid
   `compute_evidence` entry with `compute_status` equal to `pass` or
   `pass_with_caveat`.
9. `rank` is null unless the row status is `valid` or `valid_with_caveat`, the
   row comparability is `comparable` or `comparable_with_caveat`, and the metric
   is `ranking_eligible`.
10. A result row with `decision` indirectly inherited from
    `submission_registry` as `accepted_as_partial`, `blocked`, `rejected`,
    `withdrawn`, or `excluded` cannot be ranked.
11. Source-ledger-backed public comparison requires all referenced
    `source_ledgers[]` entries to be `complete` or `complete_with_caveat`.
12. Any external comparison in a public report must cite the relevant
    `ledger_id`, `bsebench_row_id`, and `source_ledger_caveat`.
13. All `artifact_id`, `evidence_artifact_id`, `compute_evidence_id`,
    `anti_leakage_review_id`, `gate_id`, `risk_id`, and `row_id` values are
    unique within their respective arrays.
14. Every SHA-256 field must be lowercase hexadecimal and must describe the
    exact bytes released, not a regenerated or pretty-printed variant.
15. A `published` artifact requires all blocking `validation_gates` to be
    `pass`, `pass_with_caveat`, or explicitly `not_applicable` with a non-empty
    caveat and reviewer.
16. A `published` artifact cannot contain an open residual risk with
    `blocking: true`.
17. `public_report_constraints.public_report_sha256` must match
    `immutable_refs.public_report_sha256` and `freeze_record.public_report_sha256`
    when a report exists.
18. `freeze_record.snapshot_artifact_sha256` must be computed after canonical
    serialization of the complete artifact excluding only the hash field itself,
    with the canonicalization rule documented in `freeze_record.freeze_caveat`.
19. Every non-empty caveat field must contain actionable limitations or the
    literal value `none_known`; empty strings are invalid.
20. Nulls are invalid unless the field explicitly permits null and the sibling
    caveat explains why the evidence is absent.

## Minimal Machine-Readable Skeleton

The following skeleton is intentionally incomplete. It shows required shape,
not real release values.

```json
{
  "schema_version": "bsebench.monthly_snapshot_artifact.v1",
  "snapshot_identity": {
    "snapshot_id": "bsebench-universal-YYYY-MM",
    "snapshot_month": "YYYY-MM",
    "cycle_window_start": "YYYY-MM-01T00:00:00Z",
    "cycle_window_end": "YYYY-MM-DDT23:59:59Z",
    "freeze_candidate_at": "YYYY-MM-DDT00:00:00Z",
    "frozen_at": null,
    "release_status": "draft",
    "owner": "role-or-account",
    "benchmark_scope": ["soc", "soh", "runtime"],
    "artifact_schema_version": "bsebench.monthly_snapshot_artifact.v1",
    "embedded_snapshot_schema_version": "bsebench.monthly_benchmark_snapshot.v1",
    "identity_caveat": "draft skeleton only"
  },
  "immutable_refs": {
    "async_report_repo": "owner/repo-or-local-id",
    "async_report_branch": "branch",
    "async_report_commit_sha": "0000000000000000000000000000000000000000",
    "runner_repo": "owner/runner",
    "runner_commit_sha": "0000000000000000000000000000000000000000",
    "datasets_repo": "owner/datasets",
    "datasets_commit_sha": "0000000000000000000000000000000000000000",
    "stats_repo": "owner/stats",
    "stats_commit_sha": "0000000000000000000000000000000000000000",
    "submission_bundle_sha256": "0000000000000000000000000000000000000000000000000000000000000000",
    "source_ledger_bundle_sha256": "0000000000000000000000000000000000000000000000000000000000000000",
    "artifact_manifest_sha256": "0000000000000000000000000000000000000000000000000000000000000000",
    "embedded_snapshot_sha256": "0000000000000000000000000000000000000000000000000000000000000000",
    "public_report_sha256": null,
    "hash_algorithm": "sha256",
    "hash_command": "sha256sum <path>",
    "refs_caveat": "draft skeleton only"
  },
  "artifact_index": [],
  "submission_registry": [],
  "submission_lifecycle": [],
  "method_registry": [],
  "dataset_registry": [],
  "metric_registry": [],
  "protocol_registry": [],
  "anti_leakage_reviews": [],
  "compute_evidence": [],
  "evidence_artifacts": [],
  "result_rows": [],
  "source_ledgers": [],
  "validation_gates": [],
  "public_report_constraints": {
    "public_report_artifact_id": null,
    "public_report_sha256": null,
    "report_generator_command": "not run",
    "allowed_snapshot_ids": ["bsebench-universal-YYYY-MM"],
    "required_caveat_sections": [
      "coverage",
      "comparability",
      "leakage",
      "provenance",
      "source_ledger",
      "compute",
      "residual_risks"
    ],
    "forbidden_language_patterns": [
      "unqualified best",
      "unqualified external superiority",
      "unqualified verified claim"
    ],
    "ranking_policy": "rank comparable valid rows only",
    "invalid_row_display_policy": "show missing, invalid, blocked, partial, excluded, and withdrawn rows in accounting",
    "source_ledger_public_policy": "external comparison language requires complete or complete_with_caveat ledger entries",
    "residual_risk_public_policy": "publish medium, high, and blocking residual risks; blocking risks prevent publication",
    "redaction_policy": "label every redaction and preserve validation status",
    "report_status": "not_run",
    "report_caveat": "draft skeleton only"
  },
  "release_caveats": {
    "coverage_caveat": "draft skeleton only",
    "comparability_caveat": "draft skeleton only",
    "leakage_caveat": "draft skeleton only",
    "provenance_caveat": "draft skeleton only",
    "source_ledger_caveat": "draft skeleton only",
    "compute_caveat": "draft skeleton only",
    "ranking_caveat": "draft skeleton only",
    "public_report_caveat": "draft skeleton only",
    "residual_risk_caveat": "draft skeleton only"
  },
  "freeze_record": {
    "freeze_id": "freeze-YYYY-MM",
    "freeze_requested_at": "YYYY-MM-DDT00:00:00Z",
    "frozen_at": null,
    "freeze_requested_by": "role-or-account",
    "freeze_approved_by": null,
    "artifact_manifest_sha256": "0000000000000000000000000000000000000000000000000000000000000000",
    "snapshot_artifact_sha256": "0000000000000000000000000000000000000000000000000000000000000000",
    "embedded_snapshot_sha256": "0000000000000000000000000000000000000000000000000000000000000000",
    "public_report_sha256": null,
    "blocking_gate_status": {
      "G0": "not_run",
      "G1": "not_run",
      "G2": "not_run",
      "G3": "not_run",
      "G4": "not_run",
      "G5": "not_run",
      "G6": "not_run",
      "G7": "not_run",
      "G8": "not_run",
      "G9": "not_run"
    },
    "publish_decision": "hold",
    "publish_decision_reason": "draft skeleton only",
    "errata_policy": "post-freeze corrections require erratum and superseding artifact hash",
    "freeze_caveat": "draft skeleton only"
  },
  "residual_risks": [],
  "errata": []
}
```

## Validator Requirements

A future validator for this schema should implement these checks before a
snapshot can move from `release_candidate` to `frozen` or `published`:

1. JSON Schema validation for required fields, enum values, object types, and
   nullable-field caveat rules.
2. Cross-reference validation for every ID listed in the invariants section.
3. Hash validation for every `artifact_index[].sha256` and every bundle hash in
   `immutable_refs`.
4. Commit-reference validation for report, runner, datasets, and stats repos.
5. Source-ledger validation for every public external comparison.
6. Anti-leakage validation for every result row.
7. Metric-definition validation against the stats repository commit.
8. Compute-evidence validation for compute rows and resource-context rows.
9. Public-report validation before publication, including report hash match and
   forbidden-language review.
10. Residual-risk validation that blocks publication when any open risk has
    `blocking: true`.

## Publication Semantics

Publication is fail-closed:

- Missing provenance blocks benchmark inclusion or marks the affected row as
  `blocked`.
- Missing hashes block freeze.
- Missing anti-leakage evidence blocks comparable result rows.
- Missing metric definitions block metric ingestion.
- Missing compute evidence blocks compute/resource metrics and must caveat any
  comparison that depends on runtime, memory, cost, or deployment resource.
- Missing source ledger evidence blocks external comparison language.
- Missing residual-risk disclosure blocks public report generation.
- Open blocking risks block publication.

## Validation Performed For This Spec Artifact

Required-field coverage check for this document must confirm that the spec
contains explicit fields for:

- `provenance` through `evidence_artifacts`, `immutable_refs`, commands, input
  hashes, output hashes, environment artifacts, and replay status.
- `hashes` through `sha256`, `hash_algorithm`, `hash_command`, commit SHAs, and
  package manifest hashes.
- `source ledger` through `source_ledgers`, retrieval metadata, external values,
  BSEBench row links, comparability, and caveats.
- `anti-leakage` through `anti_leakage_reviews`, split declarations, overlap
  checks, label access checks, future-sample checks, and public-output tuning
  checks.
- `metrics` through `metric_registry`, result-row metric values, units,
  aggregation, finite-value policy, missing-value policy, and ranking
  eligibility.
- `compute evidence` through `compute_evidence`, hardware, runtime, per-step
  runtime, memory, cost, coverage, logs, and environment artifacts.
- `residual-risk disclosure` through `residual_risks`, affected IDs, severity,
  blocking flag, mitigation, publish consequence, and public wording.

The intended final validation for this worker is:

```text
rg -n "provenance|sha256|source_ledgers|anti_leakage_reviews|metric_registry|compute_evidence|residual_risks|public_report_constraints" specs/universal/monthly-snapshot-artifact-schema-retry-20260507T205258Z.md
git diff --check
```

Worker W4-25 validation record for this retry artifact:

| Check | Result | Notes |
| --- | --- | --- |
| Inspect Wave 1/2 monthly snapshot, submission, release, and workflow logs | pass | Inspected Wave 1 dataset availability, submission template, monthly snapshot schema, public release checklist logs, plus Wave 2 monthly workflow log. |
| Inspect existing monthly snapshot artifacts | pass | Inspected Wave 1 monthly snapshot schema document, JSON Schema, fixtures, and prior W4-12 artifact schema. |
| Required field coverage scan | pass | The required scan finds provenance, `sha256`, `source_ledgers`, `anti_leakage_reviews`, `metric_registry`, `compute_evidence`, `residual_risks`, and `public_report_constraints`. |
| Guardrail keyword scan | pass | No protected-file or unsupported-claim keywords were found in this spec artifact. |
| `git diff --check` and `git diff --cached --check` | pass | No whitespace errors reported before or after staging the owned file. |

## Non-Claims

This schema is only a release artifact contract. A future monthly snapshot may
use it to publish benchmark data, but this document itself does not establish
method performance, public comparability, external ranking, or verified results.
