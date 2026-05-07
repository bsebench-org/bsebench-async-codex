# Public Report Comparability Audit - 2026-05-07

## GLASSBOX Metadata

- Worker: M-REPORT
- Branch: `phase-8-2-h-public-report-comparability-audit-20260507T193528Z`
- Owned write-set: `audits/methodology/public-report-comparability-20260507T193528Z.md`
- Active lane: public-report wording audit and runbook
- Evidence posture: source-ledger safety guidance only; no new empirical evidence and no claim registration

## Objective

Define a public benchmark report wording gate so comparison claims remain
source-ledger backed, comparable, falsifiable, and reusable across ECMs, Kalman
filters, observers, AI estimators, hybrid methods, and future filters.

The audit converts the existing async research gates into a concrete report
review contract: public prose may compare values only when it names the frozen
BSEBench artifact, exact metric and unit, dataset and split/protocol, comparator
method, and source-ledger row with a `comparable`, `partial`, or
`not_comparable` decision.

## Evidence Inspected

- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`: separates evidence generation,
  SOTA comparison, and claim registration; requires source-ledger rows for
  external comparisons and treats missing metric/split/preprocessing details as
  comparability gaps.
- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`: defines the
  public benchmark objective as multi-axis and caveated, not a single simplistic
  leaderboard.
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`: repeats the global ban
  on unsupported SOTA, novelty, leaderboard, breakthrough, and verified-claim
  statements.
- `scripts/check-research-brief-gates.sh`: confirms the current async gate
  checks for falsification, validation/replay wording, protected file
  boundaries, `claim_55` avoidance, and unsupported SOTA wording.
- `outbox/phase-7-10-j-async-claim-language-linter/SUMMARY.md`: records earlier
  claim-language fixture work that blocks unsupported claim promotion phrasing.
- `outbox/phase-7-10-p-async-source-ledger-comparability-fixtures/SUMMARY.md`:
  records comparable, partial, not-comparable, and missing-required-field
  source-ledger fixture coverage.
- `outbox/phase-7-10-p-async-source-ledger-comparability-fixtures/PANEL_CHECK.md`
  and `ADVISOR_CHECK.md`: record the residual risk that a checker can verify
  required fields and accepted labels without independently proving a row marked
  `comparable` is semantically correct.
- `cto/AUTONOMY_BACKLOG/README.md`: records the reserve-brief rule that future
  work remains validation, evidence, provenance, SOTA-safety, or async
  reliability work, with no protected-file edits.

## Wording Decision Rules

### Rule 1 - Separate Comparison Classes

Public report text must classify each comparison before wording is drafted.

| Class | Minimum evidence | Allowed public posture |
|---|---|---|
| Internal same-snapshot comparison | Same frozen BSEBench artifact, same metric/unit, same dataset, same split/protocol, same preprocessing, replay status recorded | Within-snapshot comparison only |
| External comparable comparison | Internal evidence plus complete source-ledger row marked `comparable` | Ledger-backed comparable context |
| External partial comparison | Complete source-ledger row marked `partial` with caveat | Caveated context only; no rank or superiority phrasing |
| External not-comparable row | Source-ledger row marked `not_comparable` | Explain exclusion from comparison or ranking |
| Missing ledger or missing required field | No complete ledger row, missing frozen evidence hash, or missing metric/dataset/split/preprocessing detail | No comparison; describe as unavailable or not assessed |

### Rule 2 - Required Anchors Per Comparison Sentence

Any sentence that compares methods, papers, snapshots, or benchmark rows must
carry or immediately inherit these anchors:

- frozen BSEBench artifact path or identifier and commit SHA when available;
- metric name and unit;
- dataset, cell/profile/chemistry variant when applicable;
- split, horizon, protocol, or evaluation condition;
- method or adapter identity;
- source-ledger row ID for external numbers;
- comparability status and caveat for `partial` or `not_comparable` rows.

If a sentence cannot inherit all applicable anchors from the same paragraph,
table caption, or preceding sentence, rewrite it as a neutral availability or
scope statement.

### Rule 3 - Treat Missing Details as Gaps

Unknown split, preprocessing, temperature condition, profile, horizon, dataset
variant, metric unit, or method identity must be written as a comparability gap.
Do not infer these fields from memory, nearby text, filenames, paper titles, or
method names.

### Rule 4 - No Claim Promotion From Report Prose

A public report may summarize a validated snapshot, but it must not change
claim status, imply thesis acceptance, or present a benchmark row as a verified
scientific claim. Claim registration remains a separate lane requiring validated
evidence and a completed source ledger.

## Allowed Comparison Phrases

Use these only when the anchors in Rule 2 are present.

- "Within the frozen BSEBench snapshot `<artifact>`, `<method A>` has lower
  `<metric>` than `<method B>` on `<dataset>` under `<split/protocol>`."
- "The source ledger marks `<source_id>` as `comparable` for this metric,
  dataset, and split."
- "The source ledger marks `<source_id>` as `partial`; the row is shown as
  caveated context and is not used for ranking."
- "`<source_id>` is marked `not_comparable` because `<caveat>`; it is excluded
  from comparison tables."
- "No external comparison is made for this row because the source ledger is
  missing `<field>`."
- "This snapshot reports observed values under the listed protocol; broader
  method generality is outside the evidence recorded here."
- "The report groups methods by metric, dataset, protocol, and evidence quality
  rather than reducing the result to a single global winner."

## Disallowed Or Quarantined Phrases

These phrases are disallowed in public benchmark report prose unless a separate
claim-registration task explicitly authorizes them and cites validated evidence
plus a completed source ledger. In most report contexts they should remain
quoted examples in an audit section only.

- "SOTA", "state of the art", or "best in the literature"
- "novel", "breakthrough", or "first"
- "verified claim", "proven", or "thesis claim accepted"
- "beats prior work", "outperforms the literature", or "surpasses published
  results" without a completed comparable source-ledger row
- "leaderboard winner" or "overall winner" without a frozen public snapshot
  definition, complete same-protocol rows, and explicit exclusion rules
- "universally superior", "generalizes across batteries", or equivalent global
  method superiority language
- "comparable to `<source>`" when any metric, dataset, split, preprocessing,
  horizon, or method-basis field is missing
- "ranked against `<source>`" for rows marked `partial` or `not_comparable`

## Report Review Runbook

1. Freeze the public snapshot inputs before drafting prose.
   Record artifact path, commit SHA, dataset/profile identifiers, protocol,
   metric definitions, and replay status.
2. Build or cite the source ledger before any external comparison appears in
   text, tables, captions, abstracts, summaries, release notes, or README
   snippets.
3. Label every comparison row as `comparable`, `partial`, or `not_comparable`.
   Rows with unknown required fields must be `partial` or `not_comparable`.
4. Draft tables before prose. Table captions must state metric, unit, dataset,
   split/protocol, frozen artifact, and exclusion policy.
5. Scan prose for comparison verbs: compare, beat, outperform, improve,
   exceed, rank, lead, win, superior, best, lower, higher, stronger, robust,
   generalize. Each hit must satisfy Rule 2 or be rewritten.
6. Move `partial` rows to a caveated context section or mark them visually as
   context-only. Do not include them in primary rank ordering.
7. Move `not_comparable` rows to an exclusion or limitations section. Do not
   leave them adjacent to comparable rows in a way that implies ranking.
8. Scan for disallowed terms from the previous section. If retained as quoted
   examples, label them as forbidden wording and ensure they do not describe a
   BSEBench result.
9. Confirm the report does not edit or instruct edits to thesis files,
   manuscript files, claim registries, `claims/registry.yaml`, `claim_55`, or
   the scientific roadmap.
10. Record validation commands and residual risks in the report release bundle.

## Recommendations

- Add a dedicated "Comparability" column to every public table that includes
  external numbers. Valid values should be `comparable`, `partial`,
  `not_comparable`, and `not_assessed`.
- Use a separate "Context only" table for partial rows so readers do not infer a
  rank from incompatible splits or metrics.
- Require captions to carry the frozen artifact identifier. This prevents short
  public excerpts from becoming detached from their evidence.
- Treat a complete source ledger as necessary but not sufficient. A reviewer
  must still inspect whether the row's metric, dataset, split, preprocessing,
  and method basis actually match the prose claim.
- Keep public rankings scoped to one protocol at a time. Multi-axis benchmark
  summaries should group by accuracy, reliability, compute cost, and
  generalization evidence quality instead of declaring one global winner.

## Validation Commands

Commands to run for this audit and future public-report wording reviews:

```bash
sed -n '1,220p' docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md
sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md
sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md
sed -n '1,220p' scripts/check-research-brief-gates.sh
rg -n "public report|benchmark report|monthly|leaderboard|source ledger|SOTA|novel|verified|breakthrough|comparab" .
bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md
git diff --check
git diff --cached --check
```

Observed during this audit:

- Async research protocol, charter, wave guardrails, source-ledger summary,
  claim-language summary, panel/advisor source-ledger checks, and backlog README
  were inspected.
- `bash scripts/check-research-brief-gates.sh --dry-run
  cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md` passed with `16 checked, 0 skipped`.
- Disallowed comparison terms were intentionally present only in evidence,
  quarantine, falsification, validation-command, and explicit-non-claim
  sections of this audit.
- `git diff --check` passed, and `git diff --cached --check` passed after this
  file was staged.

## Falsification Conditions

This audit should be treated as insufficient if any future public report can:

- compare external numbers without a committed source-ledger row;
- rank rows marked `partial` or `not_comparable` in the primary ordering;
- omit metric, unit, dataset, split/protocol, preprocessing, or frozen artifact
  identity from a comparison sentence or table caption;
- call a result SOTA, novel, proven, breakthrough, or verified without a
  separate claim-registration authorization;
- silently infer missing source fields instead of marking a comparability gap;
- publish a leaderboard without stating exclusion rules and evidence-quality
  caveats.

## Residual Risks

- A metadata checker can confirm required fields and labels, but it cannot prove
  semantic comparability when source rows are mislabeled. Human review remains
  required for every `comparable` row.
- Public excerpts may detach a sentence from its table caption or caveat. Short
  report summaries should repeat the key anchors rather than relying on earlier
  sections.
- Future monthly snapshots may need a stricter machine-readable release schema
  for exclusion rules, context-only rows, and evidence-quality labels.
- Some legacy roadmap and solo-operation documents contain older claim language.
  Public reports should follow the newer research gate protocol and charter
  instead of copying older phrasing.

## Explicit Non-Claims

- This audit does not assert SOTA, novelty, leaderboard victory, breakthrough,
  claim verification, or method superiority.
- This audit does not compare BSEBench against external literature results.
- This audit does not validate any empirical SOC/SOH result.
- This audit does not register, modify, verify, retract, or target any thesis
  claim, including `claim_55`.
- This audit does not edit thesis files, manuscript files, claim registry files,
  `claims/registry.yaml`, or the scientific roadmap.
