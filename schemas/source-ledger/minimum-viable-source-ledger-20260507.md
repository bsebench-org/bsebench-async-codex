# Minimum Viable Source-Ledger Schema - 2026-05-07

## GLASSBOX Metadata

- Worker: W10-f
- Branch: `phase-8-10-f-source-ledger-minimum-viable-schema-20260507T215945Z`
- Owned write-set: `schemas/source-ledger/minimum-viable-source-ledger-20260507.md`
- Purpose: define the minimum committed schema required before public monthly
  benchmark reports include external comparison wording.
- Evidence posture: schema and blocker artifact only; no empirical evidence, no
  real external comparison, no claim registration, and no protected-file edit.

## Scope

This file is a release/integration blocker contract. It defines the smallest
source-ledger shape that a monthly report must satisfy before it can publish
external comparison wording.

The contract is fail-closed:

- Missing rows block external comparison wording.
- Synthetic rows validate schema shape only.
- Partial or not-comparable rows can support limitation or context wording only.
- Public text must bind to reviewed ledger rows and frozen BSEBench evidence.
- Protected thesis, manuscript, registry, roadmap, `claims/registry.yaml`, and
  `claim_55` lanes remain out of scope.

## Read-Only Evidence Inspected

| Wave or source | Artifact inspected | Finding used |
| --- | --- | --- |
| Phase 7 source-ledger schema | `cto/AUTONOMY_BACKLOG/phase-7-10-g-async-source-ledger-schema/BRIEF.md` | Required stable source identity, retrieval date, metric, dataset, split, method, reported value, and caveat. |
| Phase 7 source-ledger fixtures | `outbox/phase-7-10-p-async-source-ledger-comparability-fixtures/SUMMARY.md` | Prior checker/fixtures distinguish comparable, partial, not-comparable, and missing-required-field rows. |
| Wave 2 source-ledger audit | `audits/universal/source-ledger-audit-20260507T193050Z.md` on `phase-8-1-q-anti-hallucination-source-ledger-audit-20260507T193050Z` | Report text needs a claim-to-ledger matrix, not only source rows. |
| Wave 4 source-ledger schema | `specs/universal/source-ledger-schema-20260507T204627Z.md` on `phase-8-3-k-source-ledger-schema-spec-20260507T204627Z` | Canonical row classes are source rows, BSEBench frozen value rows, comparison bindings, and claim bindings. |
| W6 public-report checker spec | `specs/reports/no-claims-checker-20260507T213656Z.md` on `phase-8-5-k-public-report-no-claims-checker-spec-20260507T213656Z` | Public report scanning must bind risky spans to complete ledgers and fail closed on unresolved IDs or changed text hashes. |
| W7 source-ledger fixture pack | `fixtures/source-ledger/phase8-alpha-20260507/` and `validation/wave-7/source-ledger-fixture-pack-20260507.md` on `phase-8-6-c-source-ledger-fixture-pack-20260507T214305Z` | Fixture pack has synthetic complete, partial, and not-comparable bindings only; it cannot support real public comparison wording. |
| W8 W6 closure audit | `validation/wave-8/w6-remaining-closure-audit-20260507.md` on `phase-8-7-d-w6-remaining-closure-audit-20260507T214728Z` | W6 sidecars are closed as specs/audits; some downstream gates remain unresolved. |
| W8 source-ledger gap audit | `validation/wave-8/source-ledger-gap-audit-current-20260507.md` on `phase-8-7-g-source-ledger-gap-audit-current-20260507T214728Z` | Current state lacks real external-source rows, empirical frozen BSEBench rows, and completed public claim bindings. |

No runner, stats, datasets, thesis, manuscript, claim registry, roadmap,
`claims/registry.yaml`, or `claim_55` files were edited.

## Minimum Artifact Set

A public monthly report that contains external comparison wording must commit
these artifacts in the report branch or in immutable fetched dependencies:

| Artifact | Minimum file shape | Blocks if missing |
| --- | --- | --- |
| Source ledger | JSON or YAML with `schema_version: bsebench-source-ledger/v1`, a stable `ledger_id`, and `source_rows`. | Any external number, method, paper, repository, public report, or dataset-card comparison. |
| BSEBench value ledger | JSON or YAML with `bsebench_values` tied to committed artifacts. | Any internal value used in a comparison or public numeric table. |
| Comparison bindings | JSON or YAML with `comparisons` linking source rows to BSEBench value IDs and reviewed comparability decisions. | Any external comparison phrase or table cell. |
| Public text bindings | JSON or YAML with `claim_bindings` mapping exact report spans to comparison IDs and BSEBench value IDs. | Any public sentence, table, caption, heading, release note, or README excerpt with comparison wording. |
| Protected-lane diff record | Text or JSON path list proving protected files were not edited in the release lane. | Any report branch that touches protected files or references protected-lane changes. |

The four ledger classes may be stored in one file or split across files. If
split, every file must share the same `report_or_snapshot_id`.

## Required Header Fields

| Field | Requirement |
| --- | --- |
| `schema_version` | `bsebench-source-ledger/v1` for source/value/comparison rows; `bsebench-claim-bindings/v1` for public text bindings. |
| `ledger_id` | Stable ID unique to the report or monthly snapshot. |
| `ledger_status` | One of `draft`, `complete`, `blocked`, or `superseded`; public comparison wording requires `complete`. |
| `report_or_snapshot_id` | Stable report, monthly snapshot, PR, or release candidate ID. |
| `created_at` | ISO-8601 timestamp. |
| `updated_at` | ISO-8601 timestamp. |
| `owner` | Worker, reviewer, or release role responsible for the ledger. |
| `source_retrieval_cutoff` | ISO date for latest accepted source retrieval. |
| `bsebench_snapshot` | Frozen snapshot, branch, tag, or commit scope. |
| `validation_commands` | Commands used to validate rows, references, text bindings, and whitespace. |
| `residual_risks` | Specific remaining limitations. Empty or generic text is not acceptable. |

## Source Row

Each external number or external method comparison needs one source row.

| Field | Requirement |
| --- | --- |
| `source_id` | Stable row ID unique inside the ledger. |
| `source_type` | `paper`, `benchmark`, `repository`, `dataset_card`, `public_report`, `standard`, or `other`. |
| `title` | Source title sufficient to identify the source. |
| `doi_or_url` | DOI, arXiv URL, official repository URL, release URL, dataset DOI, or stable HTTPS URL. Legacy alias `stable_url_or_doi` may be accepted only with a migration note. |
| `retrieved_at` | ISO date when the source was inspected. Legacy alias `retrieval_date` may be accepted only with a migration note. |
| `source_location` | Table, figure, page, section, release tag, commit, or artifact path for the value. |
| `access_status` | `open`, `restricted`, `gated`, `unavailable`, or `unknown`. |
| `method_family` | `ecm`, `kalman_filter`, `observer`, `ai_estimator`, `hybrid`, `baseline`, `future_filter`, or `other`. |
| `method` | Exact external method, estimator, observer, filter, model, or baseline name. |
| `task` | Target task, such as `soc`, `soh`, `voltage`, `capacity`, `resistance`, or `diagnostic`. |
| `target_signal` | Exact target signal and scale. |
| `metric` | Exact metric name. |
| `metric_unit` | Unit, scale, or dimensionless marker. |
| `metric_direction` | `lower_is_better`, `higher_is_better`, `target_is_better`, or `context_only`. |
| `aggregation` | Sample, trace, cell, dataset, macro, micro, median, mean, horizon, or declared aggregation rule. |
| `dataset` | Dataset name and variant. |
| `dataset_version` | Version, release, commit, or `not_reported` with caveat. |
| `chemistry` | Chemistry/profile where relevant, or `not_applicable`. |
| `temperature_condition` | Temperature condition where relevant, or `not_reported` with caveat. |
| `split` | Train/test split, validation protocol, horizon, run condition, or public snapshot condition. |
| `preprocessing` | Source preprocessing and leakage-relevant transformations. |
| `calibration_policy` | Training, calibration, tuning, and test-access policy. |
| `reported_value` | Exact external value as reported, including precision and units when available. |
| `reported_uncertainty` | Error bar, interval, seed spread, or `not_reported`. |
| `value_note` | Rounding, conversion, transcription, or source-access note. |
| `caveat` | Concrete limitation, or `none` only when all relevant dimensions match. Legacy alias `comparability_caveat` may be accepted only with a migration note. |

## BSEBench Frozen Value Row

Each BSEBench value used in public comparison wording needs one frozen value row.

| Field | Requirement |
| --- | --- |
| `bsebench_value_id` | Stable value ID unique inside the ledger. |
| `bsebench_value` | Exact value, unit, precision, and direction. Legacy alias `bsebench_frozen_value` may be accepted only with a migration note. |
| `bsebench_metric` | Exact metric name and unit. |
| `metric_direction` | Direction used for interpretation. |
| `bsebench_dataset` | Dataset, variant, chemistry/profile, and version. |
| `bsebench_split` | Exact split, horizon, run condition, and leakage boundary. |
| `bsebench_method` | Exact submitted method, estimator, observer, filter, model, or baseline. |
| `artifact_repo` | Repository containing the frozen artifact. |
| `artifact_branch` | Branch or tag containing the frozen artifact. |
| `artifact_commit` | Full commit SHA. |
| `artifact_path` | Committed path to metrics, manifest, report, or bundle. |
| `artifact_hash` | SHA256 or explicit hash-gap note. |
| `generation_command` | Command or workflow that generated the value. |
| `replay_command` | Command or workflow that replayed or independently checked the value. |
| `validation_log` | Path or log identity proving replay/check status. |
| `environment` | Lockfile, package command, OS/hardware facts, or declared not-applicable note. |
| `evidence_status` | `frozen`, `replayed`, `pending_worker`, `blocked`, or `superseded`; public comparison wording requires `frozen` or `replayed`. |
| `caveat` | Concrete limitation for the value or evidence artifact. |

## Comparison Binding Row

Each comparison binding links one source row to one or more BSEBench value rows.

| Field | Requirement |
| --- | --- |
| `comparison_id` | Stable binding ID unique inside the ledger. |
| `source_id` | Existing source row ID. |
| `bsebench_value_ids` | One or more existing frozen value IDs. |
| `comparison_scope` | `external_number`, `external_method`, `internal_baseline`, `monthly_snapshot`, `limitation`, or `context_only`. |
| `comparability` | `comparable`, `partial`, or `not_comparable`. |
| `metric_match` | `same`, `converted_with_note`, `different`, or `unknown`. |
| `dataset_match` | `same`, `subset`, `overlap`, `different`, or `unknown`. |
| `split_match` | `same`, `compatible`, `different`, or `unknown`. |
| `method_basis_match` | `same_class`, `different_class`, `not_applicable`, or `unknown`. |
| `preprocessing_match` | `same`, `compatible`, `different`, or `unknown`. |
| `leakage_risk` | `none_known`, `possible`, `known`, or `unknown`. |
| `caveat` | Concrete limitation, or `none` only when all relevant dimensions match. |
| `review_status` | `needs_review`, `reviewed`, `blocked`, or `superseded`; public comparison wording requires `reviewed`. |
| `reviewer` | Reviewer role or person. Required when `review_status` is `reviewed`. |

A row labeled `comparable` is still blocked if any match dimension is
`different`, `unknown`, or missing without a reviewer-approved caveat.

## Public Text Binding Row

Each public report sentence, table cell, caption, heading, release note, or
README excerpt containing external comparison wording needs one binding row.

| Field | Requirement |
| --- | --- |
| `claim_context_id` | Stable ID for the public text span. |
| `report_path` | Candidate public report, monthly snapshot, README, release note, or rendered source path. |
| `line_or_table_ref` | Line number, table row, figure caption, section ID, or generated-field path. |
| `claim_text_hash` | Hash of the exact reviewed public text span. |
| `claim_type` | `external_comparison`, `internal_ranking`, `monthly_snapshot`, `claim_registration`, `limitation`, `neutral_evidence`, or `operational_status`. |
| `trigger_terms` | Terms, numeric cells, rank columns, or comparison structures that caused review. |
| `comparison_ids` | All comparison IDs required by the text span. |
| `bsebench_value_ids` | All frozen value IDs used by the text span. |
| `decision` | `pass`, `needs_caveat`, `block`, `pending_worker`, or `out_of_scope`. |
| `safe_wording` | Approved neutral or caveated wording when the decision is not `pass`. |
| `reviewer_note` | Concrete reason and next action. |

If public text changes after review, the hash must change and the binding must
be reviewed again.

## Minimum Gate Rules

| Rule | Decision |
| --- | --- |
| External comparison wording has no public text binding. | `block` |
| External comparison wording has no source row or unresolved `source_id`. | `block` |
| Source row lacks DOI/stable URL, retrieval date, source location, metric, dataset, split, method, reported value, or caveat. | `block` |
| BSEBench value lacks full repository/branch/commit/path/hash-or-gap, command, validation log, metric, dataset, split, or method. | `block` |
| BSEBench value has `evidence_status` other than `frozen` or `replayed`. | `pending_worker` or `block` |
| Binding is `partial`. | `needs_caveat`; only limitation or context wording may proceed. |
| Binding is `not_comparable`. | `block` for positive comparison wording; limitation/context wording may proceed only with visible caveat. |
| Binding is labeled `comparable` but match dimensions are unknown, different, missing, or unreviewed. | `block` |
| Public text hash changed after review. | `block` |
| Required rows are synthetic fixtures only. | `block` for real public comparison wording. |
| Protected files are edited in this release lane without separate authorization. | `block` |

## Minimum JSON Skeleton

This skeleton is intentionally synthetic and cannot support real public
comparison wording.

```json
{
  "schema_version": "bsebench-source-ledger/v1",
  "ledger_id": "example-monthly-report-source-ledger",
  "ledger_status": "draft",
  "report_or_snapshot_id": "example-monthly-report",
  "created_at": "2026-05-07T00:00:00Z",
  "updated_at": "2026-05-07T00:00:00Z",
  "owner": "release-review-role",
  "source_retrieval_cutoff": "2026-05-07",
  "bsebench_snapshot": "example-snapshot-id",
  "source_rows": [],
  "bsebench_values": [],
  "comparisons": [],
  "validation_commands": [
    "jq empty source-ledger.json claim-bindings.json",
    "git diff --check"
  ],
  "residual_risks": [
    "No real rows are present; external comparison wording is blocked."
  ]
}
```

```json
{
  "schema_version": "bsebench-claim-bindings/v1",
  "report_or_snapshot_id": "example-monthly-report",
  "claim_bindings": []
}
```

## Current Blockers From Inspected W6/W7/W8 Artifacts

| Missing or incomplete row class | Blocker |
| --- | --- |
| Real external-source rows | W7 fixture rows are synthetic only; W8 gap audit found no committed real retrieved external-source ledger rows with retrieval dates and source locations. |
| Empirical frozen BSEBench value rows | W7 values are synthetic fixtures; W8 gap audit found no committed empirical frozen alpha evidence artifact in the inspected source-ledger pack. |
| Reviewed real comparison bindings | W7 bindings cover comparable, partial, and not-comparable fixture behavior only; they cannot authorize real external comparison wording. |
| Public text claim bindings | No completed report-line/table/caption binding matrix was found in the inspected W6/W7/W8 artifacts. |
| Executable report-level checker | W6 provides a checker specification, not an implemented release preflight. |
| Semantic comparability enforcement | Prior checker evidence validates field/format basics, but inspected reviews note that mislabeled comparability still requires reviewer or stronger semantic checks. |
| Side-branch integration | W8 gap audit records source-ledger schema and fixture artifacts as side-branch-only at its sample time. Release branches must fetch and bind immutable commits before use. |

Until these blockers are closed, public monthly reports may describe ledger
status and limitations, but must not publish external comparison wording.

## Validation Required For This File

This branch must run and record:

```bash
git diff --check
```

No shell scripts, runner files, stats files, datasets files, protected files, or
claim registry files are changed by this artifact.
