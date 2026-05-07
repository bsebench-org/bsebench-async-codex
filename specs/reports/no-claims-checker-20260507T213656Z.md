# No Unsupported Claims Checker Spec - 2026-05-07T213656Z

## GLASSBOX Metadata

- Worker: W6-11
- Branch: `phase-8-5-k-public-report-no-claims-checker-spec-20260507T213656Z`
- Owned write-set: `specs/reports/no-claims-checker-20260507T213656Z.md`
- Active lane: red-team and alpha-release hardening spec
- Evidence posture: checker design only; no empirical evidence, no external
  comparison, no public benchmark result, and no claim registration

## Objective

Design a conservative checker that prevents monthly public BSEBench reports,
release notes, README summaries, tables, captions, and snapshot prose from
publishing unsupported claims.

The checker is a release preflight. It does not decide scientific truth. It
detects claim-promoting language, comparison wording, ranking language, numeric
claims, and protected-lane drift, then requires each risky text span to bind to
completed source ledgers, frozen BSEBench evidence, and reviewer decisions.

## Evidence Inspected

Read-only source material inspected before drafting this spec:

| Evidence | Command or ref | Finding used |
|---|---|---|
| Current branch state | `git status -sb`; `git branch --show-current` | Branch started clean on the requested Phase 8.5 worker branch. |
| Research gate protocol | `sed -n '1,240p' docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` | Evidence generation, source-ledger comparison, and claim registration are separate lanes. |
| Existing BRIEF gate | `sed -n '1,260p' scripts/check-research-brief-gates.sh` | Current checker is BRIEF-focused and regex-based; report text needs stronger line/table bindings. |
| Claim-language linter brief and summary | `inbox/phase-7-10-j-async-claim-language-linter/BRIEF.md`; `outbox/phase-7-10-j-async-claim-language-linter/SUMMARY.md` | Prior work flags claim-promotion words and allows quarantined examples. |
| Source-ledger comparability fixtures | `inbox/phase-7-10-p-async-source-ledger-comparability-fixtures/BRIEF.md`; `outbox/phase-7-10-p-async-source-ledger-comparability-fixtures/SUMMARY.md` | Prior fixtures cover comparable, partial, not-comparable, and missing-field rows. |
| Source-ledger schema spec | `git show origin/phase-8-3-k-source-ledger-schema-spec-20260507T204627Z:specs/universal/source-ledger-schema-20260507T204627Z.md` | Canonical rows include source rows, frozen BSEBench value rows, comparison rows, and claim bindings. |
| Monthly snapshot artifact schema | `git show origin/phase-8-3-l-monthly-snapshot-artifact-schema-20260507T204627Z:specs/universal/monthly-snapshot-artifact-schema-20260507T204627Z.md` | Public values must resolve through submissions, datasets, protocols, metrics, evidence artifacts, source ledgers, gates, caveats, and freeze records. |
| Community monthly report outline | `git show origin/phase-8-3-w-community-benchmark-report-outline-20260507T204627Z:docs/universal/community-benchmark-report-outline-20260507T204627Z.md` | Reports require front matter, ledgers, visible caveats, scoped ranking groups, and anti-claim wording. |
| Public report comparability audit | `git show origin/phase-8-2-h-public-report-comparability-audit-20260507T193528Z:audits/methodology/public-report-comparability-20260507T193528Z.md` | Comparison sentences need metric, unit, dataset, split/protocol, method, source row, comparability, and caveat anchors. |
| Public claims redline gate | `git show origin/phase-8-4-l-public-claims-redline-gate-20260507T213125Z:gates/public-claims-redline-gate-20260507T213125Z.md` | Redline output should classify text spans as pass, needs caveat, block, pending worker, or out of scope. |
| Unsupported claim-language audit | `git show origin/phase-8-3-j-unsupported-claim-language-audit-20260507T204627Z:audits/guardrails/unsupported-claim-language-audit-20260507T204627Z.md` | Negative fixtures and guardrail sections can contain forbidden terms without making a public claim. |

## Checker Contract

Recommended command shape for a future implementation:

```bash
bsebench-report-no-claims-check \
  --report reports/monthly/<report-id>.md \
  --snapshot artifacts/<snapshot-id>.json \
  --source-ledger source-ledgers/<report-id>-source-ledger.json \
  --claim-bindings source-ledgers/<report-id>-claim-bindings.json \
  --frozen-evidence-ledger artifacts/<report-id>-evidence-ledger.json \
  --protected-diff artifacts/<report-id>-protected-diff.txt \
  --output redlines/<report-id>-no-unsupported-claims.jsonl
```

The checker must fail closed. Missing ledgers, missing hashes, unresolved IDs,
changed public text hashes, or unreviewed comparability rows are blockers for
claim-like wording.

## Inputs

| Input | Required content |
|---|---|
| Candidate public report | Markdown prose, tables, captions, headings, alt text, release notes, README snippets, and front matter. |
| Monthly snapshot artifact | Snapshot identity, immutable refs, registries, evidence artifacts, result rows, source-ledger status, validation gates, release caveats, and freeze record. |
| Source ledger | Canonical `bsebench-source-ledger/v1` source rows, frozen BSEBench value rows, and comparison rows. |
| Claim bindings | Exact public text hashes mapped to claim type, trigger terms, comparison IDs, BSEBench value IDs, decisions, safe wording, and reviewer notes. |
| Frozen evidence ledger | Repository, branch, full commit SHA, artifact path, artifact hash or hash-gap note, generation/replay command, validation log, and evidence status for each BSEBench value. |
| Protected diff | Path list proving no thesis, manuscript, roadmap, claim registry, `claims/registry.yaml`, or `claim_55` edits in the release lane. |

## Outputs

Emit JSONL plus a human-readable summary. Each redline row should include:

```text
report_path
span_ref
span_type
claim_text_hash
normalized_text
trigger_terms
claim_type
decision
required_source_ids
required_comparison_ids
required_bsebench_value_ids
missing_or_blocking_fields
redline_action
safe_wording
reviewer_note
```

Decision values:

| Decision | Meaning |
|---|---|
| `pass` | Trigger is absent or every trigger binds to complete reviewed ledgers and frozen evidence. |
| `needs_caveat` | Text may remain only after scoped limitation or context wording is inserted. |
| `block` | Text cannot be published as written. |
| `pending_worker` | Dependency branch, source retrieval, frozen evidence, replay validation, or reviewer decision is incomplete. |
| `out_of_scope` | Operational text or quarantined examples have no public claim meaning. |

## Text Surfaces To Scan

The checker must scan more than paragraphs:

- Markdown headings, front matter, prose, callouts, footnotes, and appendices.
- Tables, including cells, header labels, rank columns, and hidden Markdown
  references.
- Figure captions, image alt text, chart titles, and badge labels.
- Release notes, README excerpts, social-summary snippets, and changelog text
  generated from the report.
- Snapshot JSON fields intended for direct public rendering, including
  `release_caveats`, row caveats, method display names, ranking group labels,
  and publication decisions.

## Masking And Quarantine Rules

Forbidden terms are allowed only when the checker can classify them as policy,
fixture, validation, or explicit non-claim examples.

Mask before claim scanning:

- fenced code blocks;
- command blocks;
- JSON schema examples with synthetic placeholders;
- sections whose normalized heading matches `forbidden wording`,
  `disallowed wording`, `regex`, `negative fixture`, `validation`,
  `explicit non-claims`, or `residual risks`;
- block quotes explicitly introduced as historical context or forbidden
  examples.

Do not mask:

- executive summaries;
- abstract-like openings;
- result tables;
- captions;
- release decisions;
- README or release-note snippets;
- any line whose heading context is ambiguous.

If a line contains a trigger and masking status is uncertain, classify it as
`needs_caveat` or `block`, not `pass`.

## Regex Trigger Candidates

The regex layer is triage. It identifies spans that must be semantically
checked against ledgers and bindings.

### Claim-Promotion Terms

```regex
(?i)\b(SOTA|state[- ]of[- ]the[- ]art|best in the literature|novel|novelty|breakthrough|first(?:\s+to|\s+of|\s+benchmark)?|verified[- ]claim|verified claim|proven|thesis claim accepted|claim registry updated)\b
```

Decision rule: `block` unless the span is quarantined or the branch is an
authorized claim-registration task with completed evidence, source ledger, and
claim binding rows.

### Superiority And Leaderboard Terms

```regex
(?i)\b(leaderboard winner|overall winner|overall best|best universal benchmark|best[- ]in[- ]class|universally superior|global winner|dominates?|wins?|leads?|top[- ]ranked|rank(?:ed|ing)?\s+#?1)\b
```

Decision rule: require a frozen `ranking_group_id`, complete eligible row set,
metric direction, exclusion policy, visible caveats, and release-owner approval.
External superiority also requires comparable source rows.

### Positive Comparison Verbs

```regex
(?i)\b(beats?|outperform(?:s|ed|ing)?|surpass(?:es|ed|ing)?|exceed(?:s|ed|ing)?|improves? on|better than|superior to|lower than|higher than|rank(?:ed|ing)? against|competitive with|matches published)\b
```

Decision rule: require same-line or inherited metric, unit, dataset,
split/protocol, method IDs, BSEBench value IDs, and, for external comparison,
source IDs plus comparison IDs.

### External Comparison Without Ledger Marker

```regex
(?i)^(?=.*\b(paper|literature|published|prior work|external|arxiv|doi|source|repository|public report)\b)(?=.*\b(beats?|outperform(?:s|ed|ing)?|surpass(?:es|ed|ing)?|better|lower|higher|rank(?:ed|ing)?|competitive|matches)\b)(?!.*\b(source[_ -]?id|comparison[_ -]?id|source ledger|ledger row|comparability)\b).*$
```

Decision rule: `block`; bind to source and comparison rows or rewrite as not
assessed.

### Partial Or Not-Comparable Used Positively

```regex
(?i)\b(partial|not[_ -]?comparable|not comparable)\b.{0,220}\b(beats?|outperform(?:s|ed|ing)?|rank(?:ed|ing)?|leader|best|superior|better|winner)\b
```

Decision rule: `block`; partial and not-comparable rows can support limitation
or context wording only.

### Naked Numeric Claim

```regex
(?i)(?:^|[^A-Za-z0-9_])(\d+(?:\.\d+)?\s*(?:%|percent|RMSE|MAE|MAXE|s|ms|MB|GB|Wh|Ah|cycles?)|\d+(?:\.\d+)?x)\b
```

Decision rule: require a resolved result row, metric ID, unit, aggregation
policy, evidence artifact, status, and caveat. Numbers in dates, versions,
commit hashes, issue IDs, and command examples should be masked by context.

### Hidden Improvement Or Regression

```regex
(?i)\b(improvement|reduction|increase|decrease|gain|drop|regression|delta|relative|absolute)\b.{0,160}\b(\d+(?:\.\d+)?\s*(?:%|percent|x|points?|units?))\b
```

Decision rule: require both baseline and candidate value IDs, metric direction,
same protocol, same split, and a comparison binding. Otherwise block or rewrite
as an unquantified gap.

### Protected Lane Violation

```regex
(?i)\b(thesis|manuscript|claim registry|claims/registry\.yaml|claim_55|scientific roadmap)\b.{0,220}\b(edit|update|verify|accept|register|merge|change|target|support)\b
```

Decision rule: `block` unless a separate claim-registration task explicitly
authorizes the protected-lane action and cites completed gates.

### Source-Ledger Gap Language

```regex
(?i)\b(unknown|not reported|missing|TBD|to be filled|from memory|assumed|inferred|unavailable|private)\b.{0,180}\b(metric|dataset|split|preprocessing|retrieved_at|retrieval date|doi|url|reported_value|bsebench_value|caveat|comparability|source location)\b
```

Decision rule: `needs_caveat` or `block`. Unknown required fields cannot support
positive comparison wording.

### Generalization And Robustness Claims

```regex
(?i)\b(generalizes?|robust|reliable|stable|production[- ]ready|universal|across batteries|across chemistries|across datasets|real[- ]world)\b
```

Decision rule: require explicit coverage axes, protocol IDs, metric IDs,
failure/missing-row accounting, and caveats. Otherwise rewrite as scoped
coverage or not assessed.

## Semantic Checks

Regex hits become blocking unless these semantic checks pass.

### Binding Closure

For every trigger span:

1. Compute a stable hash of the exact public text span.
2. Find exactly one claim-binding row with the same hash.
3. Verify `report_path` and `line_or_table_ref` locate the current span.
4. Reject if the public text changed after review.
5. Reject if `decision` in the binding is less strict than the checker would
   assign from current ledger state.

### Source Row Completeness

For every external comparison:

- `source_id`, `source_type`, `title`, `doi_or_url`, `retrieved_at`,
  `source_location`, `method`, `task`, `target_signal`, `metric`,
  `metric_unit`, `metric_direction`, `aggregation`, `dataset`,
  `dataset_version`, `split`, `preprocessing`, `calibration_policy`,
  `reported_value`, and `value_note` must be non-empty or explicitly caveated.
- `doi_or_url` must be a DOI, arXiv URL, official repository URL, release URL,
  dataset DOI, or other stable URL.
- `retrieved_at` must be an ISO date.
- Missing metric, unit, dataset, split, source location, or reported value is a
  blocker for positive comparison.

### Frozen BSEBench Value Closure

For every BSEBench value referenced by public text:

- `bsebench_value_id`, value, metric, dataset, split, method, artifact repo,
  artifact branch, full commit SHA, artifact path, artifact hash or hash-gap
  note, generation command, replay command, validation log, environment, and
  evidence status must resolve.
- Positive comparison may use only values with `evidence_status=frozen` or
  `evidence_status=replayed`.
- Abbreviated SHAs, local-only paths without commit identity, missing replay
  logs, and pending workers force `pending_worker` or `block`.

### Comparability Review

A comparison row marked `comparable` must also have:

- `metric_match=same` or a documented conversion note;
- `dataset_match=same` or a reviewer-approved subset/overlap caveat;
- `split_match=same` or `compatible`;
- `preprocessing_match=same` or `compatible`;
- `leakage_risk=none_known`;
- concrete caveat text;
- `review_status=reviewed`;
- non-empty `reviewer`.

If any required match field is `different`, `unknown`, or missing, the checker
must downgrade or block the public wording even when the row label says
`comparable`.

### Internal Ranking Review

Internal rankings can pass only when:

- the text names or inherits a `ranking_group_id`;
- every ranked row is `status=valid`;
- every ranked row is `comparability=comparable`;
- the metric is `ranking_eligible=true`;
- metric direction and aggregation policy are visible;
- invalid, missing, timeout, excluded, partial, and not-comparable rows remain
  visible in caveat or exclusion tables;
- the wording is scoped to the frozen snapshot and ranking group.

Unqualified global winner language remains blocked.

### Numeric Cell Review

Every numeric cell in a public result table must bind to:

- `result_row_id`;
- `metric_id`;
- `protocol_id`;
- `method_id`;
- `dataset_id`;
- `split_id`;
- `evidence_artifact_id`;
- result status;
- comparability status;
- caveat reference.

If a table contains numbers but lacks stable row IDs, the checker must block
publication of that table.

## Manual Review Triggers

The checker should always request manual review for:

- any row marked `comparable`;
- unit conversions, rounding, normalized scores, or transformed metrics;
- source rows with restricted, gated, unavailable, or private access;
- claims about robustness, reliability, generalization, compute cost, memory,
  runtime, or deployability;
- "best in this release" or similar scoped ranking language;
- external comparisons where dataset names are similar but split, horizon,
  preprocessing, chemistry, or temperature conditions differ;
- charts where visual ordering implies a rank but table metadata is incomplete;
- captions or README snippets that detach from detailed caveats;
- public text generated after the claim-binding matrix was reviewed;
- any use of policy examples in a public-facing report section;
- protected-file references in release prose.

Manual review outcome must be recorded in `review_status`, `reviewer`, and
`reviewer_note`. A manual reviewer may strengthen a decision, but cannot waive
missing source identity, missing frozen evidence, or changed text hashes.

## Stop Conditions

Block publication when any condition is true:

1. A trigger span lacks a claim-binding row.
2. A claim-binding text hash no longer matches the report.
3. An external comparison lacks a complete source row.
4. A BSEBench value lacks frozen or replayed evidence identity.
5. A positive comparison uses `partial` or `not_comparable` rows.
6. A `comparable` row has unknown, different, or unreviewed match dimensions.
7. A ranking table hides invalid, missing, timeout, excluded, partial, or
   not-comparable rows.
8. A numeric result table lacks stable result row IDs and caveat references.
9. Claim-promotion wording appears outside quarantined examples or authorized
   claim-registration work.
10. Public text mentions thesis, manuscript, roadmap, claim registry,
    `claims/registry.yaml`, or `claim_55` changes from this release lane.
11. Dependency branches are usage-limited, unpushed, retry-only, or otherwise
    unresolved while the report treats them as validated.
12. Source-ledger fields are inferred from memory, model output, adjacent text,
    or assumptions instead of recorded source locations.

## Safe Rewrite Patterns

When the checker can propose a replacement, prefer scoped wording:

| Unsafe intent | Safer wording |
|---|---|
| External superiority without complete ledger | `External comparison is not assessed in this snapshot because <missing fields>.` |
| Partial source row used as evidence | `<source_id> is marked partial and is shown only as caveated context: <caveat>.` |
| Internal rank without global claim | `Within <ranking_group_id>, rows are ordered by <metric_id> under the documented aggregation policy.` |
| Missing evidence | `This row is blocked pending frozen evidence and replay validation.` |
| Generalization | `Coverage in this snapshot is limited to <datasets/protocols>; broader generality is not assessed.` |
| Numeric improvement without closure | `The report records candidate values only; no improvement statement is published until baseline and candidate evidence IDs are bound.` |

## Required Fixtures For Implementation

Future implementation branches should include at least these fixtures:

| Fixture | Expected decision |
|---|---|
| Neutral report with no numeric result or comparison trigger. | `pass` or `out_of_scope`. |
| Internal ranking with ranking group, eligible rows, visible exclusions, and evidence IDs. | `pass`. |
| External comparison with complete source row, frozen BSEBench value, reviewed comparable row, and claim binding. | `pass` after manual review. |
| Public sentence using claim-promotion terms in the executive summary. | `block`. |
| External comparison phrase with no source ID or comparison ID. | `block`. |
| Source row missing DOI or stable URL. | `block`. |
| Source row missing exact metric, dataset, split, or reported value. | `block`. |
| Row marked `partial` but used in a rank or superiority sentence. | `block`. |
| Row marked `comparable` while split or preprocessing is `unknown`. | `block`. |
| Numeric table with no result row IDs. | `block`. |
| Report text changed after claim-binding hash review. | `block`. |
| Forbidden words inside a `Forbidden Wording Examples` section. | `out_of_scope` if the section is quarantined. |

## Validation Summary For This Artifact

This branch must record:

```bash
git diff --check
```

Recommended validation for future checker implementation branches:

```bash
bsebench-report-no-claims-check --fixtures tests/fixtures/no-unsupported-claims
rg -n --pcre2 '<regex triggers above>' reports/monthly/*.md
git diff --check
```

## Residual Risks

- Regex triggers cannot prove semantic comparability; they only identify spans
  requiring ledger and reviewer checks.
- A syntactically complete source row can still be scientifically misleading if
  reviewers mark it comparable incorrectly.
- Public excerpts can detach from table captions and caveats, so short release
  snippets must be scanned as independent public artifacts.
- The checker spec does not implement parsing, ledger validation, or JSONL
  output.
- Legacy artifacts use mixed source-ledger field names; implementation should
  normalize aliases before strict validation and emit canonical names.

## Explicit Non-Claims

- This spec does not publish a BSEBench monthly benchmark report.
- This spec does not compare BSEBench against any paper, repository, public
  report, method, estimator, ECM, observer, filter, AI model, hybrid method, or
  baseline.
- This spec does not rank any method or dataset.
- This spec does not make SOTA, novelty, leaderboard, breakthrough, superior,
  proven, or verified-claim statements.
- This spec does not register, update, verify, reject, retract, support, or
  target any thesis or claim-registry claim, including `claim_55`.
- This spec does not edit thesis files, manuscript files, claim registry files,
  `claims/registry.yaml`, or the scientific roadmap.
