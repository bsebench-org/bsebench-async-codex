# Public Claims Redline Gate - 2026-05-07T213125Z

## GLASSBOX Metadata

- Worker: W5-12
- Branch: `phase-8-4-l-public-claims-redline-gate-20260507T213125Z`
- Owned write-set: `gates/public-claims-redline-gate-20260507T213125Z.md`
- Active lane: integration and release-hardening gate design
- Evidence posture: public-report wording and source-ledger gate only; no new
  empirical evidence, no external comparison, and no claim registration

## Objective

Define a redline gate that blocks public report claims, source-ledger drift, and
comparison wording before BSEBench community reports, monthly snapshots, release
notes, README summaries, or benchmark tables can publish unsupported claims.

The gate is intentionally conservative. A complete source ledger is necessary
but not sufficient: public prose must also bind each comparison sentence, table
row, figure caption, or summary line to reviewed source-ledger rows and frozen
BSEBench evidence. Missing metadata is a gap, not a license to infer.

This artifact does not assert SOTA, novelty, leaderboard status, breakthrough,
verified-claim status, or method superiority. It does not edit thesis files,
manuscript files, claim registry files, `claims/registry.yaml`, `claim_55`, or
the scientific roadmap.

## Evidence Inspected

Commands run from this worktree:

| Command | Purpose | Result |
|---|---|---|
| `git status -sb` | Confirm branch and dirty state. | Clean target branch before writing this file. |
| `git branch --show-current` | Confirm target branch. | `phase-8-4-l-public-claims-redline-gate-20260507T213125Z`. |
| `git remote -v` | Confirm remote. | `origin` points to `bsebench-org/bsebench-async-codex`. |
| `git fetch origin` | Refresh remote branch evidence. | Completed without output. |
| `git branch -r --list` | Inspect relevant remote Phase 8 branches. | Found source-ledger, public-report, unsupported-claim, and report-outline branches. |
| `sed -n '1,240p' docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` | Inspect current source-ledger and claim-lane protocol. | G4/G5 already require source ledgers and block claim language before validation. |
| `git show origin/phase-8-3-k-source-ledger-schema-spec-20260507T204627Z:specs/universal/source-ledger-schema-20260507T204627Z.md` | Inspect canonical source-ledger schema spec. | Requires source rows, frozen BSEBench value rows, comparison rows, and claim bindings. |
| `git show origin/phase-8-2-h-public-report-comparability-audit-20260507T193528Z:audits/methodology/public-report-comparability-20260507T193528Z.md` | Inspect public-report wording audit. | Defines allowed and disallowed comparison posture and report-review runbook. |
| `git show origin/phase-8-1-q-anti-hallucination-source-ledger-audit-20260507T193050Z:audits/universal/source-ledger-audit-20260507T193050Z.md` | Inspect claim-to-ledger audit. | Requires line-level acceptance matrix before public comparison wording. |
| `git show origin/phase-8-3-j-unsupported-claim-language-audit-20260507T204627Z:audits/guardrails/unsupported-claim-language-audit-20260507T204627Z.md` | Inspect unsupported-language audit. | Completed Wave 1-3 diffs did not add unsupported public claim language; no completed source ledger authorizes external comparison prose. |
| `git show origin/phase-8-3-w-community-benchmark-report-outline-20260507T204627Z:docs/universal/community-benchmark-report-outline-20260507T204627Z.md` | Inspect public monthly report outline. | Reports need source ledgers, claim-to-ledger matrices, frozen evidence ledgers, caveats, and scoped wording. |
| `sed -n '1,260p' scripts/check-research-brief-gates.sh` | Inspect existing machine-check style. | Existing checker is BRIEF-focused; this gate is report/text-focused. |

## Gate Inputs

The redline gate runs over a candidate public artifact plus its evidence bundle.

Required inputs:

| Input | Required content |
|---|---|
| Candidate public text | Markdown, release note, README snippet, report section, table, figure caption, or monthly snapshot prose. |
| Source ledger | Canonical JSON/YAML or lossless TSV projection with source rows, frozen BSEBench value rows, and comparison rows. |
| Claim binding ledger | Line/table/caption bindings from public text to comparison IDs and BSEBench value IDs. |
| Frozen evidence ledger | Repository, branch, full commit SHA, artifact path, replay or generation command, validation log, and hash or hash-gap note for every BSEBench value. |
| Report metadata | Report ID, snapshot ID, release status, source-ledger status, validation commands, and residual risks. |
| Protected-file diff | Path list proving no thesis, manuscript, registry, roadmap, `claims/registry.yaml`, or `claim_55` edits unless a separate claim-registration task authorized them. |

No public comparison may pass with only prose and reviewer memory. The gate must
read committed ledgers or block.

## Redline Decisions

Each scanned sentence, table row, caption, title, and summary line receives one
decision:

| Decision | Meaning | Public action |
|---|---|---|
| `pass` | Text has no trigger, or every trigger binds to complete reviewed ledgers and frozen evidence. | Keep text. |
| `needs_caveat` | Text is useful but depends on `partial` rows or incomplete context that can be stated safely. | Rewrite to scoped or limitation wording. |
| `block` | Text makes comparison or claim-promotion wording without required ledgers, anchors, authorization, or comparability. | Remove or replace before release. |
| `pending_worker` | Dependency branch, source retrieval, frozen evidence, or replay validation is incomplete. | Do not publish comparison; wait for dependency or mark as not assessed. |
| `out_of_scope` | Operational or neutral status text has no benchmark comparison or claim-promotion meaning. | No ledger binding required. |

The gate output should be JSONL or Markdown with these fields per redline row:

```text
report_path
line_or_table_ref
claim_text_hash
trigger_terms
decision
required_source_ids
required_comparison_ids
required_bsebench_value_ids
missing_or_blocking_fields
redline_action
safe_wording
reviewer_note
```

## Source-Ledger Completion Rule

Use the canonical fields from the source-ledger schema spec for new artifacts.
Legacy aliases can be normalized during validation but must not be emitted by a
new public report.

Minimum source row fields:

- `source_id`
- `source_type`
- `title`
- `doi_or_url`
- `retrieved_at`
- `source_location`
- `method`
- `task`
- `target_signal`
- `metric`
- `metric_unit`
- `metric_direction`
- `aggregation`
- `dataset`
- `dataset_version`
- `split`
- `preprocessing`
- `calibration_policy`
- `reported_value`
- `reported_uncertainty`
- `value_note`

Minimum frozen BSEBench value fields:

- `bsebench_value_id`
- `bsebench_value`
- `bsebench_metric`
- `bsebench_dataset`
- `bsebench_split`
- `bsebench_method`
- `artifact_repo`
- `artifact_branch`
- `artifact_commit`
- `artifact_path`
- `artifact_hash`
- `generation_command`
- `replay_command`
- `validation_log`
- `environment`
- `evidence_status`

Minimum comparison fields:

- `comparison_id`
- `source_id`
- `bsebench_value_ids`
- `comparison_scope`
- `comparability`
- `metric_match`
- `dataset_match`
- `split_match`
- `method_basis_match`
- `preprocessing_match`
- `leakage_risk`
- `caveat`
- `review_status`
- `reviewer`

Minimum claim-binding fields:

- `claim_context_id`
- `report_path`
- `line_or_table_ref`
- `claim_text_hash`
- `claim_type`
- `trigger_terms`
- `comparison_ids`
- `bsebench_value_ids`
- `decision`
- `safe_wording`
- `reviewer_note`

Reject `ledger_status=complete` if any required row is missing, unresolved, or
only syntactically complete while semantic comparability remains unreviewed.

## Allowed Wording Bank

Allowed wording still requires the relevant anchors from the same line, table,
caption, paragraph, or immediately inherited context.

| Use case | Allowed wording pattern |
|---|---|
| Frozen scope | `within this frozen BSEBench snapshot` |
| Neutral evidence | `mechanical evidence`, `candidate result`, `replay passed`, `validator passed` |
| Missing evidence | `blocked by missing evidence`, `not assessed in this snapshot`, `pending ledger completion` |
| Comparable source row | `the source ledger marks <source_id> as comparable for this metric, dataset, and split` |
| Partial source row | `<source_id> is partial and shown as caveated context only` |
| Not-comparable source row | `<source_id> is not comparable because <caveat> and is excluded from ranking` |
| Internal snapshot ordering | `ordered within <ranking_group_id> under the documented aggregation policy` |
| Publication posture | `publishable with caveats`, `blocked pending ledger completion`, `withdrawn by erratum` |

Safe text must name or inherit:

- frozen artifact or snapshot ID;
- metric and unit;
- dataset, profile, chemistry, and split/protocol where relevant;
- method identity;
- source ID and comparison ID for external numbers;
- comparability status and caveat for `partial` or `not_comparable` rows.

## Disallowed Or Quarantined Wording

The following phrases are blocked in public report prose unless a separate
claim-registration task explicitly authorizes them and cites completed evidence,
completed source ledgers, and completed claim bindings. In most report contexts
they should appear only inside policy, audit, fixture, or redline-example
sections.

- `SOTA`, `state of the art`, `best in the literature`
- `novel`, `breakthrough`, `first`
- `verified claim`, `proven`, `thesis claim accepted`
- `beats prior work`, `outperforms the literature`, `surpasses published results`
- `leaderboard winner`, `overall winner`, `best universal benchmark`
- `universally superior`, `generalizes across batteries`
- `comparable to <source>` when metric, dataset, split, preprocessing, horizon,
  or method basis is missing
- `ranked against <source>` for rows marked `partial` or `not_comparable`
- any wording that changes claim status or implies claim registry acceptance

## Regex Candidates

These are machine-checkable candidates, not a complete parser. They should run
on public-facing Markdown with code fences, explicit policy examples, and
quoted redline sections masked or separately classified.

### Claim-Promotion Terms

```regex
(?i)\b(SOTA|state[- ]of[- ]the[- ]art|best in the literature|novel|breakthrough|verified[- ]claim|verified claim|proven|thesis claim accepted|claim registry updated)\b
```

Decision rule: `block` unless the line is inside an explicit policy/example
quarantine or the candidate artifact is a separately authorized
claim-registration task with completed ledgers.

### Global Superiority Or Leaderboard Terms

```regex
(?i)\b(leaderboard winner|overall winner|best universal benchmark|best[- ]in[- ]class|overall best|universally superior|generalizes across batteries|first(?:\s+of|\s+to|\s+benchmark)?)\b
```

Decision rule: `block` unless the text names a frozen ranking group, complete
eligible row set, exclusion policy, caveat ledger, and explicit release owner
approval. External superiority still requires complete comparable source rows.

### Positive Comparison Verbs

```regex
(?i)\b(beats?|outperform(?:s|ed|ing)?|surpass(?:es|ed|ing)?|exceed(?:s|ed|ing)?|better than prior work|superior to|improves? on|rank(?:ed|ing)? against|lower than|higher than|leads?)\b
```

Decision rule: require same-line or inherited `metric`, `dataset`, `split` or
`protocol`, `bsebench_value_id`, and, for external comparison, `source_id` plus
`comparison_id`.

### External Comparison Without Ledger Marker

```regex
(?i)^(?=.*\b(paper|literature|published|prior work|external|arxiv|doi|source)\b)(?=.*\b(beats?|outperform(?:s|ed|ing)?|surpass(?:es|ed|ing)?|better|lower|higher|rank(?:ed|ing)?)\b)(?!.*\b(source[_ -]?id|comparison[_ -]?id|source ledger|ledger row|comparability)\b).*$
```

Decision rule: `block`; add source and comparison bindings or rewrite as not
assessed.

### Partial Or Not-Comparable Row Used As Positive Evidence

```regex
(?i)\b(partial|not[_ -]?comparable|not comparable)\b.{0,200}\b(beats?|outperform(?:s|ed|ing)?|rank(?:ed|ing)?|leader|best|superior|better)\b
```

Decision rule: `block`; partial and not-comparable rows can support limitation
or context wording only.

### Missing Required Anchor Terms

```regex
(?i)\b(RMSE|MAE|MAXE|accuracy|error|runtime|memory|rank|score|metric|result)\b.{0,200}\b(best|better|lower|higher|leader|winner|outperform|beat|surpass)\b
```

Decision rule: flag for anchor check. The line must inherit metric unit,
dataset, split/protocol, method identity, artifact ID, and evidence status.

### Protected File Or Lane Violation

```regex
(?i)\b(thesis|manuscript|claim registry|claims/registry\.yaml|claim_55|scientific roadmap)\b.{0,200}\b(edit|update|verify|accept|register|merge|change|target)\b
```

Decision rule: `block` unless the active branch is an explicitly authorized
claim-registration task and cites completed source and evidence gates.

### Source-Ledger Field Gaps

```regex
(?i)\b(unknown|not reported|missing|TBD|to be filled|from memory|assumed|inferred)\b.{0,160}\b(metric|dataset|split|preprocessing|retrieved_at|doi|url|reported_value|bsebench_value|caveat|comparability)\b
```

Decision rule: downgrade to `needs_caveat` or `block`. A row with unknown
metric, dataset, split, preprocessing, leakage risk, source identity, or frozen
value cannot support positive comparison wording.

## Redline Algorithm

1. Freeze the candidate public artifact and compute line/table/caption hashes.
2. Mask code fences and sections explicitly labeled as policy examples,
   forbidden wording examples, validation commands, or explicit non-claims.
3. Scan visible public text with the trigger regexes above.
4. For each trigger, require a claim-binding row keyed by exact text hash.
5. Resolve every `comparison_id`, `source_id`, and `bsebench_value_id`.
6. Validate source rows, frozen BSEBench value rows, comparison rows, and
   reviewer status against the required fields in this gate.
7. Apply redline decisions:
   - `block` for claim-promotion terms without claim-registration authorization.
   - `block` for external comparison without source and comparison rows.
   - `block` for positive comparison using `partial` or `not_comparable` rows.
   - `needs_caveat` for useful text that must be rewritten to limitation or
     context wording.
   - `pending_worker` for missing pushed branch, missing replay, missing source
     retrieval, or unresolved artifact commit.
8. Emit redline rows with safe replacement wording.
9. Require a second pass after edits; changed text hashes invalidate prior
   claim-binding decisions.

## Public Report Release Stop Conditions

Block release when any condition is true:

1. A comparison phrase, ranking table, external number, abstract claim, or
   summary claim lacks a claim-binding row.
2. A source row lacks stable URL or DOI, retrieval date, source location,
   method, exact metric, dataset, split, reported value, or caveat.
3. A BSEBench value lacks repository, branch, full commit SHA, artifact path,
   replay or generation command, validation log, and hash or hash-gap note.
4. Positive comparison wording uses a row not marked
   `comparability=comparable`.
5. A row is marked `comparable` while metric, unit, dataset, split,
   preprocessing, chemistry, temperature condition, calibration policy, or
   leakage risk is unknown or different.
6. Public prose uses claim-promotion vocabulary without separate
   claim-registration authorization.
7. A report hides invalid, missing, timeout, excluded, partial, or not-assessed
   rows that affect the interpretation of a table.
8. Watchdog logs or local worktrees show usage-limit, retry, no pushed commit,
   or unresolved worker status, and the report treats the branch as validated.
9. Public text changes after redline review without re-running the hash-bound
   claim-binding gate.
10. Protected thesis, manuscript, roadmap, claim registry, `claims/registry.yaml`,
    or `claim_55` files are touched outside an authorized claim-registration
    lane.

## Expected Gate Output

A passing public report release bundle should contain:

- candidate report path and commit SHA;
- source-ledger path, schema version, ledger status, and validation command;
- claim-binding path and count of `pass`, `needs_caveat`, `block`,
  `pending_worker`, and `out_of_scope` rows;
- frozen evidence ledger path and artifact hash or hash-gap notes;
- redline diff or summary showing removed or rewritten public claims;
- residual risks, including semantic comparability review gaps;
- explicit statement that no unsupported SOTA, novelty, leaderboard,
  breakthrough, verified-claim, thesis, registry, roadmap, or `claim_55` edit is
  authorized by the release bundle.

## Falsification Conditions

This gate is insufficient if a future public report can:

- publish positive external comparison wording without a complete source row,
  frozen BSEBench value, comparison row, and claim binding;
- rank `partial` or `not_comparable` rows in primary ordering;
- use claim-promotion words outside policy examples or authorized
  claim-registration work;
- pass after a public text hash changes without revalidation;
- treat a syntactically complete source row as semantically comparable without
  reviewer status and caveat review;
- hide known missingness, invalid rows, usage-limit branches, or source-access
  gaps that would change report interpretation.

## Residual Risks

- Regex scans are conservative triage. They catch high-risk wording, but they
  cannot prove semantic comparability or validate numeric correctness.
- The report scanner and source-ledger validator are not implemented in this
  scoped Markdown branch.
- Existing legacy artifacts use mixed source-ledger field names. Future tooling
  must normalize aliases before applying strict validation.
- Policy documents necessarily contain forbidden terms as examples. Automation
  must distinguish quarantined examples from public report claims.
- Public excerpts can detach from table captions. Short summaries should repeat
  source, metric, dataset, split, artifact, and caveat anchors.

## Explicit Non-Claims

- This gate does not compare BSEBench to any external literature result.
- This gate does not validate any SOC, SOH, voltage, compute, robustness, or
  transfer result.
- This gate does not rank any ECM, Kalman-family filter, observer, AI
  estimator, hybrid method, baseline, dataset, or future method.
- This gate does not state that BSEBench is SOTA, novel, a breakthrough, a
  leaderboard winner, proven, or claim-verified.
- This gate does not register, update, verify, retract, scope, or target any
  thesis or claim-registry claim, including `claim_55`.
- This gate does not edit thesis files, manuscript files, claim registry files,
  `claims/registry.yaml`, or the scientific roadmap.

## Validation To Record

Required validation for this branch:

```bash
git diff --check
```

Recommended validation for future implementation branches:

```bash
python -m bsebench_report_claim_gate <report.md> <source-ledger.json> <claim-bindings.json>
rg -n --pcre2 '<regex candidates above>' <candidate-public-report.md>
git diff --check
```

The Python command is a proposed future gate name. It is not implemented by this
Markdown-only branch.
