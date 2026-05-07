# GLASSBOX Source Ledger Schema Spec - 2026-05-07T204627Z

Worker: W4-11
Local timestamp: 2026-05-07T22:50:11+02:00
UTC timestamp: 2026-05-07T20:50:11+00:00
Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report`
Target branch: `phase-8-3-k-source-ledger-schema-spec-20260507T204627Z`
Owned write set: `specs/universal/source-ledger-schema-20260507T204627Z.md`

## Objective

Define the concrete source-ledger schema required before any BSEBench benchmark
comparison, public report line, monthly snapshot comparison, leaderboard-like
table, or claim-registration task can use external numbers or comparative
language.

This is an anti-hallucination and fair-comparison specification. It does not
create evidence, compare real methods, register a claim, or authorize thesis,
manuscript, roadmap, `claims/registry.yaml`, or `claim_55` edits.

## Evidence Inspected

Commands run from
`/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-3-k-source-ledger-schema-spec-20260507T204627Z`:

| Command | Purpose | Result |
|---|---|---|
| `pwd` | Confirm active worktree. | Confirmed this Phase 8.3.k worktree. |
| `git status -sb` | Confirm starting branch and dirty state. | Branch was clean and based on `origin/main`. |
| `git branch --show-current` | Confirm target branch. | `phase-8-3-k-source-ledger-schema-spec-20260507T204627Z`. |
| `rg --files \| rg '(^\|/)(specs\|docs\|claims\|scripts\|tools\|ci\|\.github)/\|source-ledger\|ledger\|gate\|claim'` | Inventory existing docs, gates, and claim/ledger references. | Found research gate protocol, source-ledger fixture summaries, claim-language linter summaries, and async scripts. |
| `find specs -maxdepth 3 -type f \| sort` | Check for existing `specs/` tree. | `specs/` did not exist in this branch before this artifact. |
| `sed -n '1,220p' docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` | Inspect current G4 source-ledger requirements. | Minimum ledger fields and evidence/SOTA/claim lane separation already exist. |
| `sed -n '1,220p' outbox/phase-7-10-p-async-source-ledger-comparability-fixtures/SUMMARY.md` | Inspect prior source-ledger fixture work. | Existing fixtures cover comparable, partial, not-comparable, and missing-field cases. |
| `sed -n '1,220p' cto/AUTONOMY_BACKLOG/phase-7-10-g-async-source-ledger-schema/BRIEF.md` | Inspect original source-ledger schema brief. | Required stable source metadata, retrieval date, metric, dataset, split, method, reported value, and caveat. |
| `sed -n '1,240p' /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-7-10-p-async-source-ledger-comparability-fixtures/scripts/check-source-ledger.sh` | Inspect concrete TSV checker from prior branch. | Checker validates exact header, stable DOI/URL shape, ISO date, required fields, and comparability enum. |
| `sed -n '1,240p' /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-7-10-p-async-source-ledger-comparability-fixtures/scripts/test-source-ledger-fixtures.sh` | Inspect positive/negative probe coverage. | Tests require pass fixtures and expected failures for missing fields. |
| `sed -n '1,260p' /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-1-q-anti-hallucination-source-ledger-audit-20260507T193050Z/audits/universal/source-ledger-audit-20260507T193050Z.md` | Inspect Wave 2 anti-hallucination ledger audit. | Audit adds claim-to-ledger matrix, report-level rejection cases, and frozen artifact binding. |
| `sed -n '1,220p' outbox/phase-7-10-p-async-source-ledger-comparability-fixtures/PANEL_CHECK.md` and `ADVISOR_CHECK.md` | Inspect prior review concerns. | Panel notes syntactic field checks do not prove semantic comparability; advisor accepts this as follow-up hardening. |
| `find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f \( -name 'manual-phase-8-0-*.log' -o -name 'manual-phase-8-1-*.log' -o -name 'manual-phase-8-2-*.log' \) -printf '%f\n' \| sort \| wc -l` | Verify first-three-wave log count. | `48` logs. |
| `rg -n "usage limit" /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-2-*.log` | Identify actual prior usage-limit terminations. | `phase-8-2-j`, `phase-8-2-k`, and `phase-8-2-l` ended at usage limit. |
| `tail -n 60 /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-2-{j,k,l}-*.log` | Confirm failure mode for the three incomplete Wave 3 logs. | Each log shows the prompt followed by usage-limit errors, with no completed artifact. |
| `find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-3-*.log' -printf '%f\n' \| sort \| wc -l` | Check Wave 4 retry/validation inventory. | `24` Wave 4 logs existed at inspection time, including retry-scoped logs. |

## Current Findings

1. The first three Phase 8 waves have 48 manual watchdog logs. Forty-five are
   completion-like. Three Wave 3 logs, `phase-8-2-j`, `phase-8-2-k`, and
   `phase-8-2-l`, hit usage-limit errors before producing their scoped
   artifacts.
2. Existing G4 language defines a minimum source-ledger row, but prior work uses
   several field-name variants. This spec pins canonical names and lists legacy
   aliases to avoid silent drift.
3. The prior TSV checker is useful for field completeness and shallow format
   validation. It is not sufficient to prove semantic comparability.
4. The Wave 2 source-ledger audit correctly extends the row-level ledger into a
   claim-to-ledger acceptance matrix. Public text needs that second binding,
   not just a table of external numbers.
5. Watchdog logs mix prompts, shell output, diffs, and final summaries. They are
   valid status evidence, but they are not a substitute for fetching committed
   branches and inspecting frozen artifacts.

Decision for this artifact: **PASS as a schema specification**, with the
recommendations below required before public comparison or claim use.

## Schema Overview

Every public comparison requires two committed artifacts:

1. A **source ledger**: machine-readable rows for external numbers and the
   frozen BSEBench values being compared.
2. A **claim binding ledger**: line/table/figure bindings from public text to
   source-ledger rows and frozen BSEBench evidence IDs.

No public comparison is complete unless both artifacts exist and agree.

Recommended canonical file names:

```text
source-ledgers/<snapshot-or-report-id>-source-ledger.json
source-ledgers/<snapshot-or-report-id>-claim-bindings.json
```

TSV is acceptable for review and checker compatibility when it is a lossless
projection of the JSON fields. JSON or YAML is preferred for nested artifact and
comparability metadata.

## Ledger Header

The top-level object must include:

| Field | Required value | Reject if |
|---|---|---|
| `schema_version` | `bsebench-source-ledger/v1`. | Missing or unsupported. |
| `ledger_id` | Stable ID, for example `snapshot-2026-05-source-ledger`. | Empty, duplicated, or changes without an audit note. |
| `ledger_status` | `draft`, `complete`, `blocked`, or `superseded`. | `complete` is used while any row is incomplete. |
| `report_or_snapshot_id` | Stable ID for the public report, monthly snapshot, PR, or claim-registration task. | Cannot map ledger to a concrete output. |
| `created_at` | ISO-8601 timestamp. | Missing or malformed. |
| `updated_at` | ISO-8601 timestamp or same as `created_at`. | Missing after any row update. |
| `owner` | Person, worker role, or review role responsible for the ledger. | Empty. |
| `source_retrieval_cutoff` | ISO date for the latest source retrieval allowed in this ledger. | Missing for public reports. |
| `bsebench_snapshot` | Snapshot ID, release candidate ID, or branch/commit scope. | Missing for any BSEBench value. |
| `validation_commands` | Commands used to validate ledger structure and claim bindings. | Empty for a public report or claim-registration task. |
| `residual_risks` | Known limitations after validation. | Empty or only generic caution text. |

## Source Ledger Row

Each external number or public-source value referenced by a comparison needs one
row. Unknown values are not inferred from memory or neighboring rows.

| Field | Required value | Reject if |
|---|---|---|
| `source_id` | Stable row ID unique inside the ledger. | Empty or duplicated. |
| `source_type` | `paper`, `benchmark`, `repository`, `dataset_card`, `public_report`, `standard`, or `other`. | Empty or ambiguous. |
| `title` | Source title sufficient to identify the paper, benchmark, repository, or report. | Empty or generic. |
| `doi_or_url` | DOI, arXiv URL, official repository URL, release URL, dataset DOI, or other stable HTTPS URL. | Missing, non-stable, private-only, or not retrievable without a caveat. |
| `retrieved_at` | ISO date when the source was inspected. | Missing, malformed, later than publication date, or stale without a caveat. |
| `source_location` | Table, figure, page, section, release tag, commit, or artifact path for the value. | Numeric value cannot be located in the source. |
| `access_status` | `open`, `restricted`, `gated`, `unavailable`, or `unknown`. | Source accessibility is relevant but unstated. |
| `method_family` | `ecm`, `kalman_filter`, `observer`, `ai_estimator`, `hybrid`, `baseline`, `future_filter`, or `other`. | Method class is unclear for a method comparison. |
| `method` | Exact external method, estimator, model, observer, filter, or baseline name. | Empty, mixed, or inconsistent with the source. |
| `task` | `soc`, `soh`, `voltage`, `capacity`, `resistance`, `diagnostic`, or another declared task. | Task differs from BSEBench target and row is marked fully comparable. |
| `target_signal` | Exact signal or target, for example `SOC_percent` or `SOH_percent`. | Missing for SOC/SOH comparisons. |
| `metric` | Exact metric name. | Metric differs from BSEBench metric and row is marked fully comparable. |
| `metric_unit` | Unit, scale, or dimensionless marker. | Missing or incompatible with `reported_value`. |
| `metric_direction` | `lower_is_better`, `higher_is_better`, `target_is_better`, or `context_only`. | Missing for ranked values. |
| `aggregation` | Sample, trace, cell, dataset, macro, micro, median, mean, horizon, or other aggregation rule. | Missing for any summarized value. |
| `dataset` | Dataset name and variant. | Missing or not the same dataset/protocol for a fully comparable row. |
| `dataset_version` | Version, release, commit, or `not_reported`. | Missing without caveat. |
| `chemistry` | Chemistry/profile where relevant, or `not_applicable`. | Mixed or unknown chemistry used as fully comparable. |
| `temperature_condition` | Temperature setpoint/measured condition, or `not_reported`. | Temperature matters and is unreported without caveat. |
| `split` | Train/test split, validation protocol, horizon, run condition, or public snapshot condition. | Unknown split used for positive comparison wording. |
| `preprocessing` | Source preprocessing and leakage-relevant transformations. | Unknown preprocessing used as fully comparable. |
| `calibration_policy` | Training/calibration/tuning availability relevant to the benchmark. | Unknown policy used as fully comparable. |
| `reported_value` | Exact external value as reported, including precision and units when possible. | Missing, transformed silently, or unitless. |
| `reported_uncertainty` | Error bar, CI, std, seed spread, or `not_reported`. | Omitted when source reports uncertainty. |
| `value_note` | Any rounding, conversion, or transcription note. | Transformation occurred without a note. |
| `source_quote_hash` | Optional hash of the short excerpt or table cell used during review. | Required by local policy when direct quotation is restricted. |

## BSEBench Frozen Value Row

Every internal value used in a comparison must be frozen and replayable.

| Field | Required value | Reject if |
|---|---|---|
| `bsebench_value_id` | Stable internal value ID referenced by comparison and claim bindings. | Empty or duplicated. |
| `bsebench_value` | Exact value, unit, precision, and direction. | Value is generated ad hoc or unitless. |
| `bsebench_metric` | Exact metric name and unit. | Differs from source metric without comparability downgrade. |
| `bsebench_dataset` | Dataset, variant, chemistry/profile, and version. | Dataset cannot be traced. |
| `bsebench_split` | Exact split, horizon, run condition, and leakage boundary. | Split is missing or only described informally. |
| `bsebench_method` | Exact submitted method, baseline, estimator, observer, filter, or model. | Method identity is ambiguous. |
| `artifact_repo` | Repository containing the frozen artifact. | Missing. |
| `artifact_branch` | Branch or tag containing the frozen artifact. | Missing for unmerged work. |
| `artifact_commit` | Full commit SHA. | Missing, abbreviated only, or not fetched. |
| `artifact_path` | Path to manifest, metrics file, report, or bundle. | Missing or outside committed/frozen cache scope. |
| `artifact_hash` | SHA256 or documented hash gap. | Missing without a hash-gap note. |
| `generation_command` | Command/workflow that produced the value, when applicable. | Missing for evidence generation. |
| `replay_command` | Command/workflow that independently replayed or verified the value. | Missing for claim-supporting values. |
| `validation_log` | Path or log identity proving replay result. | Missing for public comparison. |
| `environment` | Lockfile, package command, OS/hardware facts relevant to replay. | Missing when compute or reproducibility is part of the claim. |
| `evidence_status` | `frozen`, `replayed`, `pending_worker`, `blocked`, or `superseded`. | Positive comparison uses anything except `frozen` or `replayed`. |

## Comparison Binding Row

Each comparison row links one external source row to one or more frozen BSEBench
values. This is where comparability is decided.

| Field | Required value | Reject if |
|---|---|---|
| `comparison_id` | Stable ID unique inside the ledger. | Empty or duplicated. |
| `source_id` | Existing source ledger row ID. | Missing or unresolved. |
| `bsebench_value_ids` | One or more existing frozen BSEBench value IDs. | Missing or unresolved. |
| `comparison_scope` | `external_number`, `external_method`, `internal_baseline`, `monthly_snapshot`, `limitation`, or `context_only`. | Empty or ambiguous. |
| `comparability` | `comparable`, `partial`, or `not_comparable`. | Free-form or missing. |
| `metric_match` | `same`, `converted_with_note`, `different`, or `unknown`. | `unknown` or `different` with `comparable`. |
| `dataset_match` | `same`, `subset`, `overlap`, `different`, or `unknown`. | `different` or `unknown` with `comparable`. |
| `split_match` | `same`, `compatible`, `different`, or `unknown`. | `different` or `unknown` with `comparable`. |
| `method_basis_match` | `same_class`, `different_class`, `not_applicable`, or `unknown`. | Unknown basis used in method superiority wording. |
| `preprocessing_match` | `same`, `compatible`, `different`, or `unknown`. | Unknown preprocessing with fully comparable status. |
| `leakage_risk` | `none_known`, `possible`, `known`, or `unknown`. | `known` leakage risk used for positive comparison. |
| `caveat` | Concrete limitation, or `none` only when all relevant dimensions match. | Empty, generic, or `none` when any match field is partial/unknown/different. |
| `review_status` | `needs_review`, `reviewed`, `blocked`, or `superseded`. | Public report uses row before review. |
| `reviewer` | Human or validation role that reviewed comparability. | Empty for `reviewed`. |

Rule: a row marked `partial` or `not_comparable` can support gap, limitation, or
context wording only. It cannot support positive comparison wording.

## Claim Binding Ledger

Every public sentence, table, figure, README paragraph, release note, or claim
registry proposal that contains comparison or claim-promotion triggers must bind
to the source ledger.

| Field | Required value | Reject if |
|---|---|---|
| `claim_context_id` | Stable ID for the report line, table row, figure caption, paragraph, or claim proposal. | Empty or duplicated. |
| `report_path` | Candidate public report, monthly snapshot, README, release note, or claim-registration path. | Missing. |
| `line_or_table_ref` | Line number, table row, figure caption, or section ID. | Cannot locate text after report edits. |
| `claim_text_hash` | Hash of the exact reviewed text. | Text changed after review without revalidation. |
| `claim_type` | `external_comparison`, `internal_ranking`, `monthly_snapshot`, `claim_registration`, `limitation`, `neutral_evidence`, or `operational_status`. | Missing or inconsistent with text. |
| `trigger_terms` | Terms or structures that caused ledger review. | Empty when comparison wording exists. |
| `comparison_ids` | All comparison rows required by the text. | Missing for comparison or ranking text. |
| `bsebench_value_ids` | All frozen internal values used by the text. | Missing for internal ranking or monthly snapshot text. |
| `decision` | `pass`, `needs_caveat`, `block`, `pending_worker`, or `out_of_scope`. | Missing or inconsistent with dependencies. |
| `safe_wording` | Approved neutral or caveated wording, when `needs_caveat` or `block`. | Missing when text must be rewritten. |
| `reviewer_note` | Concrete reason and next action. | Empty for non-pass decisions. |

Decision meanings:

- `pass`: every source row is complete, every BSEBench value is frozen or
  replayed, every positive comparison uses `comparability=comparable`, and the
  public wording is scoped to those rows.
- `needs_caveat`: the text may remain only after downgrading to limitation,
  context, or scoped wording.
- `block`: required source metadata, frozen evidence, exact metric/dataset/split,
  comparability, or protected-lane authorization is missing.
- `pending_worker`: a dependency branch or retry task has no completed artifact.
- `out_of_scope`: neutral operational text with no benchmark comparison or claim
  promotion.

## Canonical Names And Legacy Aliases

Use the canonical names in this spec for new JSON/YAML ledgers.

| Canonical field | Legacy alias accepted only with migration note |
|---|---|
| `doi_or_url` | `stable_url_or_doi` |
| `retrieved_at` | `retrieval_date` |
| `bsebench_value` | `bsebench_frozen_value` |
| `caveat` | `comparability_caveat` |
| `schema_version: bsebench-source-ledger/v1` | `source-ledger-comparability/v1` fixtures only |

Report gates should normalize aliases before validation and then emit canonical
field names in any new artifact.

## Minimal JSON Skeleton

This skeleton uses synthetic placeholder IDs and no real literature numbers.

```json
{
  "schema_version": "bsebench-source-ledger/v1",
  "ledger_id": "synthetic-report-source-ledger",
  "ledger_status": "draft",
  "report_or_snapshot_id": "synthetic-report",
  "created_at": "2026-05-07T20:50:11Z",
  "updated_at": "2026-05-07T20:50:11Z",
  "owner": "review-role",
  "source_retrieval_cutoff": "2026-05-07",
  "bsebench_snapshot": "synthetic-snapshot",
  "source_rows": [
    {
      "source_id": "synthetic-source-001",
      "source_type": "public_report",
      "title": "Synthetic Source Row For Schema Fixture",
      "doi_or_url": "https://example.org/bsebench/source-ledger/schema-fixture",
      "retrieved_at": "2026-05-07",
      "source_location": "fixture table 1",
      "access_status": "open",
      "method_family": "baseline",
      "method": "SyntheticBaseline",
      "task": "soc",
      "target_signal": "SOC_percent",
      "metric": "synthetic MAE",
      "metric_unit": "percent",
      "metric_direction": "lower_is_better",
      "aggregation": "macro_cell_mean",
      "dataset": "SyntheticCellSet",
      "dataset_version": "fixture-v1",
      "chemistry": "synthetic",
      "temperature_condition": "synthetic-25C",
      "split": "fixture-test-split",
      "preprocessing": "synthetic fixture preprocessing",
      "calibration_policy": "fixture calibration policy",
      "reported_value": "1.23 percent",
      "reported_uncertainty": "not_reported",
      "value_note": "Synthetic fixture only; not literature evidence."
    }
  ],
  "bsebench_values": [
    {
      "bsebench_value_id": "synthetic-bsebench-value-001",
      "bsebench_value": "1.20 percent",
      "bsebench_metric": "synthetic MAE percent",
      "bsebench_dataset": "SyntheticCellSet fixture-v1",
      "bsebench_split": "fixture-test-split",
      "bsebench_method": "SyntheticBaseline",
      "artifact_repo": "bsebench-example",
      "artifact_branch": "synthetic-fixture",
      "artifact_commit": "0000000000000000000000000000000000000000",
      "artifact_path": "synthetic/artifact.json",
      "artifact_hash": "hash-gap: synthetic fixture",
      "generation_command": "not_applicable: synthetic schema fixture",
      "replay_command": "not_applicable: synthetic schema fixture",
      "validation_log": "not_applicable: synthetic schema fixture",
      "environment": "not_applicable: synthetic schema fixture",
      "evidence_status": "frozen"
    }
  ],
  "comparisons": [
    {
      "comparison_id": "synthetic-comparison-001",
      "source_id": "synthetic-source-001",
      "bsebench_value_ids": ["synthetic-bsebench-value-001"],
      "comparison_scope": "context_only",
      "comparability": "partial",
      "metric_match": "same",
      "dataset_match": "same",
      "split_match": "same",
      "method_basis_match": "same_class",
      "preprocessing_match": "unknown",
      "leakage_risk": "unknown",
      "caveat": "Synthetic fixture row; preprocessing and leakage conditions are not real evidence.",
      "review_status": "needs_review",
      "reviewer": ""
    }
  ],
  "validation_commands": [
    "bash scripts/check-source-ledger.sh <ledger.tsv>",
    "git diff --check"
  ],
  "residual_risks": [
    "Synthetic rows validate schema shape only, not semantic comparability."
  ]
}
```

## Safe Claim Binding Example

This example is intentionally neutral. It does not compare real methods or make
public claim-promotion statements.

```json
{
  "schema_version": "bsebench-claim-bindings/v1",
  "report_or_snapshot_id": "synthetic-report",
  "bindings": [
    {
      "claim_context_id": "synthetic-report-line-001",
      "report_path": "reports/synthetic-report.md",
      "line_or_table_ref": "line 10",
      "claim_text_hash": "sha256:synthetic-placeholder",
      "claim_type": "neutral_evidence",
      "trigger_terms": [],
      "comparison_ids": [],
      "bsebench_value_ids": ["synthetic-bsebench-value-001"],
      "decision": "out_of_scope",
      "safe_wording": "The synthetic fixture records one frozen candidate value for schema validation.",
      "reviewer_note": "No external comparison or claim-promotion language is present."
    }
  ]
}
```

## Required Rejection Cases

A report, monthly snapshot, benchmark comparison, or claim-registration task must
be rejected when any of these are true:

1. Comparison wording or an external numeric value appears without a
   source-ledger row.
2. A source row lacks `doi_or_url`, `retrieved_at`, `source_location`, `metric`,
   `dataset`, `split`, `method`, `reported_value`, or `caveat`.
3. A BSEBench value lacks repository, branch, full commit SHA, artifact path,
   replay command or validation log, and hash or hash-gap note.
4. A row marked `partial` or `not_comparable` is used for positive comparison
   wording.
5. Metric, unit, aggregation, dataset, split, horizon, preprocessing, chemistry,
   temperature condition, or calibration policy differs while
   `comparability=comparable`.
6. Missing external metadata is filled from memory, model output, or analogy
   instead of being marked as a gap.
7. A source is inaccessible at retrieval time and the row is still used as fully
   comparable.
8. Watchdog logs show `pending_worker`, retry, usage-limit, or no pushed commit,
   and the report treats that branch as validated.
9. The claim text hash changes after review without re-running the claim binding
   gate.
10. Thesis, manuscript, roadmap, `claims/registry.yaml`, claim registry, or
    `claim_55` content is edited without a separate claim-registration brief and
    completed evidence/source gates.
11. Public text uses claim-promotion terms without a completed ledger and
    explicit claim-registration authorization.
12. The ledger contains only syntactic field checks when the claim requires
    semantic comparability review.

## Pass/Fail Recommendations

| Case | Decision | Required action |
|---|---|---|
| All source rows complete, all BSEBench values frozen or replayed, every positive comparison uses `comparability=comparable`, and claim bindings pass. | `pass` | Public wording may proceed only within reviewed scope. |
| Source row is complete but some dimensions are `partial` or `unknown`. | `needs_caveat` | Use limitation or context wording only. |
| Source identity, retrieval date, exact metric, dataset, split, or BSEBench frozen value is missing. | `block` | Do not publish comparison; repair ledger or remove comparison. |
| Worker dependency has only usage-limit or retry logs. | `pending_worker` | Wait for retry artifact and fetch branch before comparison. |
| Text is operational or neutral evidence with no comparison trigger. | `out_of_scope` | Record as non-claim or omit from claim binding matrix. |

## Residual Risks

- This branch creates a specification only. It does not implement a report
  scanner or modify existing checkers.
- Syntax checks cannot prove that a row marked `comparable` is semantically
  correct. Human or stronger domain review is required for `reviewed` status.
- Existing artifacts use mixed field names. Migration must normalize aliases
  before strict validation.
- External source access and reported values can change. Monthly reports need
  fresh retrieval dates and source-location review.
- The three prior Wave 3 usage-limit tasks must remain `pending_worker` until
  their retry artifacts are completed and pushed.
- Watchdog logs are noisy. Validators should treat them as status signals, then
  fetch committed branches and inspect frozen artifacts.

## Explicit Non-Claims

- This spec does not claim BSEBench is a finished universal benchmark standard.
- This spec does not claim any estimator, ECM, Kalman filter, observer, AI
  model, hybrid method, or future filter is better than another.
- This spec does not make SOTA, novelty, leaderboard, breakthrough, or verified
  scientific statements.
- This spec does not validate any SOC, SOH, voltage, compute, robustness, or
  transfer result.
- This spec does not register, modify, verify, reject, or target any thesis
  claim, including `claim_55`.
- This spec does not edit thesis files, manuscript files, claim registry files,
  `claims/registry.yaml`, or the scientific roadmap.

## Validation To Record

Required branch validation for this artifact:

```bash
git diff --check
```

Recommended future implementation validation:

```bash
bash scripts/check-source-ledger.sh <ledger.tsv>
python -m bsebench_report_claim_gate <report.md> <source-ledger.json> <claim-bindings.json>
git diff --check
```

The second command is a recommended future gate name, not an implemented command
in this branch.
