# Monthly Report Redaction Policy - 2026-05-07

## GLASSBOX Metadata

- Worker: W7-n
- Branch: `phase-8-6-n-monthly-report-redaction-policy-20260507T214305Z`
- Owned write-set: `specs/reports/monthly-report-redaction-policy-20260507.md`
- Active lane: public monthly report release-hardening policy
- Evidence posture: policy and audit contract only; no benchmark execution, no
  external comparison, no public result, and no claim registration

This policy defines how public monthly BSEBench reports must redact or downgrade
unknown-license rows, unsupported comparisons, small-N results, and missing
source-ledger entries. It is intentionally conservative: when the evidence is
unknown, the public report must show a blocker or caveat instead of inferring a
number, rank, license, comparison, or claim from context.

This artifact does not edit thesis files, manuscript files, claim registry
files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap.

## Evidence Inspected

Commands were run from:

```text
/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-6-n-monthly-report-redaction-policy-20260507T214305Z
```

| Evidence | Ref or command | Finding used |
|---|---|---|
| Worktree state | `git status --short --branch`; `git branch --show-current`; `git remote -v` | Confirmed the requested branch and remote before writing. |
| Local research gate protocol | `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` | Evidence generation, source-ledger comparison, and claim registration are separate lanes; missing source fields are gaps. |
| Local universal charter | `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md` | Monthly benchmark reports must include caveats, missing data, invalid comparability cases, and multi-axis scope. |
| Local wave guardrails | `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md` | Public artifacts must avoid unsupported claim-promotion language and protected-file edits. |
| Local source-ledger fixture summary | `outbox/phase-7-10-p-async-source-ledger-comparability-fixtures/SUMMARY.md` | Prior fixtures distinguish comparable, partial, not-comparable, and missing-field rows. |
| Source-ledger schema spec | `origin/phase-8-3-k-source-ledger-schema-spec-20260507T204627Z:specs/universal/source-ledger-schema-20260507T204627Z.md` | New public comparison rows require source rows, frozen BSEBench value rows, comparison rows, and claim bindings. |
| Monthly snapshot artifact schema | `origin/phase-8-3-l-monthly-snapshot-artifact-schema-20260507T204627Z:specs/universal/monthly-snapshot-artifact-schema-20260507T204627Z.md` | Public values must resolve through submissions, datasets, protocols, metrics, evidence artifacts, source ledgers, validation gates, caveats, and freeze records. |
| Public report comparability audit | `origin/phase-8-2-h-public-report-comparability-audit-20260507T193528Z:audits/methodology/public-report-comparability-20260507T193528Z.md` | Comparison text needs metric, unit, dataset, split/protocol, method, source row, comparability, and caveat anchors. |
| Data licensing availability audit | `origin/phase-8-2-i-data-licensing-availability-audit-20260507T193528Z:audits/methodology/data-licensing-availability-20260507T193528Z.md` | Unknown license, redistribution, access friction, missing checksums, and loader gaps must be blockers or caveats. |
| Public claims redline gate | `origin/phase-8-4-l-public-claims-redline-gate-20260507T213125Z:gates/public-claims-redline-gate-20260507T213125Z.md` | Redline decisions are `pass`, `needs_caveat`, `block`, `pending_worker`, or `out_of_scope`. |
| No unsupported claims checker spec | `origin/phase-8-5-k-public-report-no-claims-checker-spec-20260507T213656Z:specs/reports/no-claims-checker-20260507T213656Z.md` | Missing ledgers, changed text hashes, unresolved IDs, and unreviewed comparability rows must fail closed. |
| Monthly benchmark dry-run checklist | `origin/phase-8-4-n-monthly-benchmark-dry-run-checklist-20260507T213125Z:runbooks/monthly-benchmark-dry-run-20260507T213125Z.md` | Dry runs must record artifact refs, source-ledger status, publish decision, blockers, and caveats. |

Remote-branch artifacts above were inspected after fetching their refs. They are
not assumed merged into this branch.

## Public Report Surfaces

This policy applies to every field that can be rendered or copied into a public
monthly report:

- Markdown front matter, headings, prose, appendices, footnotes, and callouts.
- Result tables, availability tables, source-ledger tables, rank columns,
  exclusion columns, and caveat columns.
- Figure captions, chart titles, image alt text, badge labels, and table notes.
- Release notes, README snippets, changelog entries, and short public summaries
  generated from the report.
- Snapshot JSON fields intended for public rendering, including row labels,
  release caveats, ranking group names, method display names, and publication
  decisions.

The same redaction decision must be applied to the source field and to every
derived excerpt. A safe table is not enough if a release-note sentence reuses
the redacted value or comparison.

## Redaction Tokens

Use these exact public replacement tokens in generated tables and redline
outputs until a future implementation defines machine-readable enums:

| Token | Meaning | Public replacement |
|---|---|---|
| `REDACTED_LICENSE_REVIEW` | License, redistribution, source access, or mirroring terms are unknown or unresolved. | `license review pending` |
| `REDACTED_UNSUPPORTED_COMPARISON` | Comparison is missing required anchors or uses `partial`/`not_comparable` rows for positive comparison wording. | `comparison not assessed` |
| `REDACTED_SMALL_N` | Effective independent sample count is below this policy's public-report threshold. | `small-N; not ranked` |
| `REDACTED_MISSING_SOURCE_LEDGER` | External source row, comparison row, claim binding, frozen BSEBench value row, or artifact hash is missing or unresolved. | `source ledger incomplete` |
| `REDACTED_PENDING_WORKER` | Dependency branch, replay validation, reviewer decision, or freeze record is incomplete. | `pending validation` |
| `REDACTED_PROTECTED_LANE` | Text would imply thesis, manuscript, claim registry, roadmap, or `claim_55` action without authorization. | `protected lane not touched` |

Do not leave an empty cell when a value is redacted. Empty cells are ambiguous;
use the token and a caveat.

## Redline Output Row

Every redaction decision must be recorded in a release redline artifact with at
least these fields:

```text
report_id
snapshot_id
report_path
span_or_cell_ref
public_surface
original_text_hash
redaction_token
decision
blocking_fields
required_source_ids
required_comparison_ids
required_bsebench_value_ids
effective_n
license_status
comparability
safe_public_text
reviewer
reviewed_at_utc
residual_risk
```

Allowed `decision` values are `pass`, `needs_caveat`, `block`,
`pending_worker`, and `out_of_scope`.

## Policy 1 - Unknown Licenses

Unknown license status is a publication blocker for public runnable rows,
mirrors, public replay promises, and ranking eligibility. It is not a blocker
for a clearly separated discovery or blocker table.

### Required Evidence

Every public monthly report row that names a dataset, source, method submission,
adapter, or external result must resolve these fields or be downgraded:

| Field | Applies to | Public blocker if missing |
|---|---|---|
| `license_id` or exact redistribution terms | datasets, method submissions, external sources | yes |
| `license_url_or_record_location` | datasets, method submissions, external sources | yes |
| `license_retrieved_at` or source retrieval date | datasets, method submissions, external sources | yes |
| `redistribution_status` | datasets and mirrored artifacts | yes |
| `access_friction` | datasets and external sources | caveat or blocker |
| `source_url` or DOI/stable URL | datasets and external values | yes |
| `file_inventory` with hashes for mirrored files | mirrored datasets and public replay rows | yes |
| `rights_reviewer` and decision date | public runnable and mirror rows | yes |

### Redaction Rules

| Condition | Decision | Public report action |
|---|---|---|
| Dataset license or redistribution is `unknown`, missing, contradictory, or under review. | `block` | Replace runnable status, numeric result, rank, and replay promise with `REDACTED_LICENSE_REVIEW`; show only in a license-review table. |
| Dataset is gated, registration-required, request-form, revocable, restricted, or local-only. | `needs_caveat` or `block` | Disclose access friction; do not promise public replay unless a rights-cleared mirror with hashes exists. |
| Method submission or adapter license is missing or incompatible with publication. | `block` | Redact method display from ranked/result tables unless the release owner approves a non-runnable, non-ranked placeholder. |
| External source access or reuse terms are unknown. | `block` | Do not quote or compare the external number; cite only that the source row is pending review if useful. |
| Mixed-source aggregate has unresolved rights for any source component. | `block` | Split by rights-reviewed source component or redact the aggregate. |

### Safe Public Text

Allowed patterns:

- `Dataset <dataset_id> is listed as license review pending and is excluded from runnable benchmark rows.`
- `This row is inventory-only because public replay rights are not yet resolved.`
- `Access requires <gated/manual step>; replay status is not claimed by this monthly snapshot.`

Disallowed patterns:

- Any statement that treats an unknown-license row as benchmark-ready.
- Any public mirror, replay, or ranking promise based only on a prospect catalog
  row, local cache, private copy, or assumed upstream permission.

## Policy 2 - Unsupported Comparisons

A comparison is unsupported when it lacks required anchors, lacks reviewed
comparability, uses incomplete source-ledger fields, or uses `partial` or
`not_comparable` rows as evidence for positive comparison wording.

### Required Anchors

Every comparison sentence, table row, caption, or public summary must carry or
immediately inherit:

- frozen BSEBench artifact path or snapshot ID;
- full async/report, runner, stats, and datasets commits when the value depends
  on all four repos;
- metric ID, metric display name, unit, direction, and aggregation policy;
- dataset ID, chemistry/profile/temperature/aging axes when relevant;
- split, horizon, protocol, and leakage boundary;
- method or adapter identity;
- source ID and comparison ID for external values;
- comparability label and caveat;
- result-row ID and evidence-artifact ID for every internal value.

### Redaction Rules

| Condition | Decision | Public report action |
|---|---|---|
| External comparison has no source ledger or no comparison row. | `block` | Replace value, rank, and comparison prose with `REDACTED_MISSING_SOURCE_LEDGER`. |
| Source row is missing metric, unit, dataset, split, preprocessing, method basis, source location, reported value, retrieval date, or stable URL. | `block` | Remove positive comparison wording; use `REDACTED_MISSING_SOURCE_LEDGER` or `REDACTED_UNSUPPORTED_COMPARISON`. |
| Row is `partial`. | `needs_caveat` | Move to context-only table; do not rank; do not use positive comparison wording. |
| Row is `not_comparable`. | `block` for comparison, `pass` for exclusion note | Move to exclusion/limitations table; show caveat only. |
| Internal same-snapshot comparison lacks same metric, dataset, split, protocol, preprocessing, or frozen evidence. | `block` | Redact comparison wording and ranking; keep neutral availability if useful. |
| Public text contains claim-promotion or superiority wording before completed claim-registration authorization. | `block` | Rewrite as neutral snapshot or blocker text. |

### Safe Public Text

Allowed patterns:

- `Within snapshot <snapshot_id>, row <result_row_id> reports <metric_id> under <protocol_id>; no external comparison is made.`
- `<source_id> is partial and shown as caveated context only: <caveat>.`
- `<source_id> is not comparable because <caveat>; it is excluded from comparison tables.`
- `External comparison is not assessed because <missing field list>.`

## Policy 3 - Small-N Results

Small-N handling is a public-report caution gate, not a statistical theorem.
Until metric-specific thresholds are approved in a stats-owned acceptance
matrix, use this conservative default policy.

### Effective N Definition

`effective_n` is the count of independent evaluation units available for the
specific result row after exclusions. It must be counted at the highest
independent axis available for that protocol, such as cells, source files,
profiles, dataset-split units, or independent submissions. Do not count
timesteps, windows, bootstrap resamples, overlapping traces, repeated metrics,
or multiple rows derived from the same physical cell as independent N.

Each public result row must report:

```text
effective_n
n_unit
n_total_candidate
n_excluded
exclusion_reason
small_n_policy_version
```

### Default Thresholds

| Effective N | Decision | Public report action |
|---:|---|---|
| `0` | `block` | Show `not run` or `not available`; publish no metric value or rank. |
| `1-2` | `block` | Replace metric value, aggregate, rank, and comparison with `REDACTED_SMALL_N`; show only availability and blocker reason. |
| `3-4` | `needs_caveat` | Show value only in a non-ranked pilot/context table with visible `small-N; not ranked` caveat; no comparison, winner, or improvement language. |
| `>=5` | `pass` only if all other gates pass | Eligible for scoped reporting under the metric, split, license, leakage, and source-ledger gates. |

If the stats-owned metric definition sets a stricter threshold, use the stricter
threshold. If the metric definition sets a looser threshold, this policy still
requires release-owner sign-off before relaxing public redaction.

### Redaction Rules

| Condition | Decision | Public report action |
|---|---|---|
| `effective_n` is missing, ambiguous, or counted from non-independent windows. | `block` | Use `REDACTED_SMALL_N`; do not publish a numeric cell. |
| `n_excluded` is hidden or not linked to exclusion reasons. | `block` | Redact rank and aggregate until excluded rows are visible. |
| Small-N row is combined into a multi-method or multi-dataset aggregate. | `block` | Redact aggregate or split the aggregate with caveats. |
| Small-N row appears in a ranking group. | `block` | Remove from ranking group and show in context-only table. |

### Safe Public Text

Allowed patterns:

- `This row is small-N and is not ranked in this monthly snapshot.`
- `The value is shown as pilot context only because effective_n=<n> <n_unit>.`
- `No comparison is made for this row until additional independent units are available.`

## Policy 4 - Missing Source Ledger Entries

Missing source-ledger entries are blockers for external comparisons, public
claim-like wording, and any report text that asks readers to compare BSEBench
values with outside sources. Missing entries cannot be filled from memory,
model output, filenames, paper titles, or adjacent text.

### Required Ledger Closure

For every external comparison, the release dossier must include:

- source ledger header with `schema_version=bsebench-source-ledger/v1`;
- source row for each external value;
- frozen BSEBench value row for each internal value;
- comparison row linking source rows to BSEBench value rows;
- claim-binding row for every public sentence, table cell, caption, and summary
  that uses the comparison;
- reviewer decision and reviewed text hash;
- artifact hashes or explicit hash-gap blockers;
- validation commands and residual risks.

### Redaction Rules

| Condition | Decision | Public report action |
|---|---|---|
| No source ledger is used and public text has no external comparison. | `pass` | Set `source_ledger_status=not_used`; do not include external comparison text. |
| No source ledger is used but public text compares to outside work. | `block` | Replace comparison with `REDACTED_MISSING_SOURCE_LEDGER`. |
| Source ledger exists but status is `draft`, `partial`, `blocked`, or unreviewed. | `pending_worker` or `block` | Use `REDACTED_PENDING_WORKER` or `REDACTED_MISSING_SOURCE_LEDGER`; no comparison. |
| Claim-binding text hash does not match current public text. | `block` | Redact span and rerun review. |
| Frozen BSEBench value row lacks full commit, artifact path, hash or hash-gap note, generation command, replay command, validation log, or evidence status. | `block` | Redact numeric comparison and ranking. |
| Comparison row says `comparable` while any match field is unknown, different, unreviewed, or missing. | `block` | Downgrade to context/exclusion or redact. |

### Safe Public Text

Allowed patterns:

- `External comparison is not assessed in this snapshot because the source ledger is incomplete.`
- `The report records internal candidate values only; comparison rows are pending reviewer closure.`
- `This source row is blocked by missing <field list>.`

## Table Layout Requirements

Public monthly reports must keep these tables separate:

| Table | May include | Must exclude |
|---|---|---|
| Runnable benchmark results | license-cleared, benchmark-ready, evidence-closed rows with sufficient N | unknown-license, missing-ledger, small-N-blocked, partial, not-comparable, or pending rows |
| Pilot/context results | small-N `3-4`, internal-only rows, caveated diagnostics | ranks, improvement language, external comparison claims |
| Source-ledger context | reviewed external rows with `comparable`, `partial`, or `not_comparable` labels | values with missing required source fields unless shown as blockers |
| License review | unknown or unresolved rights rows | numeric benchmark values, public replay promises, ranks |
| Exclusions and blockers | blocked, missing, invalid, timeout, not-comparable, source-ledger incomplete, license-review rows | language implying the row was silently dropped or ranked |

Every numeric cell in a public result table must include or resolve to:

```text
result_row_id
metric_id
unit
effective_n
n_unit
evidence_artifact_id
status
comparability
caveat
redaction_token when applicable
```

## Publication Decision Matrix

Use the most restrictive decision from all applicable policies.

| Inputs | Public decision |
|---|---|
| All required evidence complete, license cleared, comparison supported, and `effective_n>=5`. | `publish_scoped` |
| Evidence complete and license cleared, but `effective_n=3-4`. | `publish_context_only` |
| Internal value complete but external source ledger missing or blocked. | `publish_internal_only` |
| License, source access, replay evidence, or protected-lane status unresolved. | `block_public_value` |
| Candidate depends on unmerged worker branch or missing validator output. | `pending_worker` |
| Report text contains claim-promotion language without authorized claim-registration closure. | `block_public_text` |

`publish_scoped` is not a scientific claim. It means only that the row can be
shown under the documented monthly report scope and caveats.

## Reviewer Checklist

Before publication, the report reviewer must answer each item with an artifact
path, command output, or blocker:

1. Does every public value resolve to a result row, evidence artifact, frozen
   commit, command, validation log, and caveat?
2. Does every external comparison resolve to source, frozen value, comparison,
   and claim-binding ledger rows?
3. Are unknown-license and rights-review rows absent from runnable/ranked tables?
4. Are `partial`, `not_comparable`, missing-ledger, and pending-worker rows
   absent from positive comparison wording?
5. Is `effective_n` recorded for every result row and counted from independent
   units?
6. Are small-N rows separated from ranking and aggregate tables?
7. Are invalid, missing, timeout, blocked, excluded, and caveated rows visible?
8. Does the report avoid protected-file actions and claim-registration wording?
9. Do release notes and README snippets repeat the same redactions as the full
   report?
10. Does the final release dossier record residual risks and errata policy?

## Validation Commands For This Artifact

Required before merging this policy branch:

```bash
git status --short --branch
git diff -- specs/reports/monthly-report-redaction-policy-20260507.md
rg -n "SOTA|state of the art|novel|leaderboard|breakthrough|superior|universal-proven|verified scientific|verified claim" specs/reports/monthly-report-redaction-policy-20260507.md
git diff --check
```

The `rg` command above is expected to find only policy, quarantine, validation,
or explicit non-claim contexts. Any hit in a result statement or monthly-report
claim must block release.

## Blockers And Integration Notes

- The source-ledger schema, monthly snapshot artifact schema, public claims
  redline gate, no-claims checker spec, public report comparability audit, data
  licensing audit, and monthly dry-run checklist are not present as merged local
  files in this branch. They were inspected by fetched remote refs and remain
  integration dependencies.
- This policy does not implement a parser, table scanner, source-ledger
  validator, or JSONL redline writer.
- This policy sets default small-N public thresholds only. A future stats-owned
  metric acceptance artifact may tighten them by metric family.
- This policy does not provide legal advice. It treats unresolved license and
  redistribution evidence as public-report blockers.

## Explicit Non-Claims

- This policy does not publish a BSEBench monthly benchmark report.
- This policy does not compare BSEBench results with external literature.
- This policy does not assert method superiority, public ranking victory, claim
  verification, novelty, or broad generalization.
- This policy does not validate any SOC/SOH metric value.
- This policy does not register, modify, verify, retract, or target any thesis
  claim, including `claim_55`.
