# GLASSBOX Source Ledger Audit - 2026-05-07T193050Z

Worker: CLAIM-AUDIT
Local timestamp: 2026-05-07T21:34:54+02:00
UTC timestamp: 2026-05-07T19:34:54Z
Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report`
Target branch: `phase-8-1-q-anti-hallucination-source-ledger-audit-20260507T193050Z`
Owned write set: `audits/universal/source-ledger-audit-20260507T193050Z.md`

## Scope

This audit designs the claim and source-ledger gate that must run before BSEBench
benchmark claims, comparison language, monthly snapshots, or public reports are
published. It is a planning and validation artifact only. It does not register a
claim, update thesis or manuscript prose, edit a claim registry, update
`claims/registry.yaml`, target `claim_55`, or change the scientific roadmap.

The audit follows the universal benchmark objective: BSEBench should support
ECMs, Kalman filters, observers, AI estimators, and hybrid methods without
turning incomplete evidence into public comparison claims.

## Evidence Inspected

Commands run from
`/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-1-q-anti-hallucination-source-ledger-audit-20260507T193050Z`:

| Command | Purpose | Result |
|---|---|---|
| `pwd && git status --short --branch` | Confirm worktree and branch state. | Branch was `phase-8-1-q-anti-hallucination-source-ledger-audit-20260507T193050Z`, initially at `origin/main`. |
| `rg --files` | Inventory local report, gate, inbox, and outbox patterns. | Repo is mostly async coordination reports and docs. |
| `find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 3 -type f` | Locate Wave 1 and Wave 2 watchdog logs. | Found Wave 1 logs `manual-phase-8-0-a` through `manual-phase-8-0-x` and Wave 2 logs. |
| `sed -n '1,220p' docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` | Inspect current research gate. | Existing G4 source-ledger minimum fields are present. |
| `sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md` | Inspect universal benchmark charter. | Charter requires comparability, provenance, anti-leakage, and monthly benchmark readiness. |
| `sed -n '1,260p' scripts/check-research-brief-gates.sh` | Inspect executable gate coverage. | Current checker is BRIEF-focused and pattern-based. |
| `sed -n '1,220p' outbox/phase-7-10-p-async-source-ledger-comparability-fixtures/SUMMARY.md` | Inspect source-ledger fixture summary. | Fixture checker covers required row shape and comparable/partial/not-comparable cases. |
| `sed -n '1,220p' outbox/phase-7-10-j-async-claim-language-linter/SUMMARY.md` | Inspect claim-language linter summary. | Linter blocks forbidden promotion wording in async artifacts. |
| `rg -n "(commit\|Commit\|Branch SHA\|Push result\|push\|SOTA\|novel\|leaderboard\|breakthrough\|verified\|source ledger\|comparability\|claim_55)" /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-0-*.log` | Sample Wave 1 logs for guardrail and push evidence vocabulary. | Logs carry guardrails and some pushed commit evidence, but many matches are noisy because prompts and stdout are co-mingled. |
| `git remote -v` | Confirm push target. | Remote is `https://github.com/bsebench-org/bsebench-async-codex.git`. |
| `git fetch origin && git merge --ff-only origin/main` | Bring this branch onto current `origin/main` before committing. | Fast-forwarded from `96e5fe4` to `e7db221`. |

## Existing Controls

1. `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` already separates evidence
   generation, source-ledger comparison, and claim registration.
2. The same protocol defines required source-ledger fields: `source_id`,
   `title`, `doi_or_url`, `retrieved_at`, `metric`, `dataset`, `split`,
   `reported_value`, `bsebench_value`, `comparability`, and `caveat`.
3. `scripts/check-research-brief-gates.sh` checks Phase 7/8/11 BRIEFs for
   falsification wording, validation/replay wording, protected-file guardrails,
   `claim_55` protection, and unsupported comparison language.
4. The source-ledger comparability fixture work records pass cases for
   `comparable`, `partial`, and `not_comparable`, and fail cases for missing
   source metadata.
5. The claim-language linter work records fail fixtures for claim-promotion and
   unsupported comparison wording.

## Primary Gap

The existing controls are strong at BRIEF and fixture boundaries, but public
reports and recurring benchmark snapshots still need a line-level acceptance
matrix. A report can pass the current BRIEF gate while later adding comparison
phrases, ranking tables, or external numbers that are not bound to:

- a complete external source row;
- a frozen BSEBench value;
- the exact metric, dataset, split, and run condition;
- a comparability decision and caveat;
- the branch and commit that produced the BSEBench value.

Until that binding exists, public report text must stay neutral: mechanical
evidence, candidate result, replay status, source-ledger status, and explicit
limitations.

## Required Source-Ledger Row

Every external number used in a benchmark claim or public report comparison must
have one row with these fields. Missing values are not inferred from memory.

| Field | Required value | Reject if |
|---|---|---|
| `source_id` | Stable local identifier, unique within the ledger. | Empty, duplicated, or changes between report revisions without an audit note. |
| `title` | Paper, benchmark, repository, public report, or dataset-card title. | Empty or generic title that cannot identify the source. |
| `stable_url_or_doi` | DOI, arXiv URL, official repository URL, dataset DOI, or other stable URL. | Missing, non-stable, private-only, or not retrievable at audit time unless explicitly marked unavailable. |
| `retrieval_date` | ISO date when the source was retrieved. | Missing, malformed, after the report publication date, or stale without a stale-source caveat. |
| `source_location` | Table, figure, page, section, commit, release tag, or artifact path for the external value. | Exact source location is absent for a numeric comparison. |
| `method` | External method, estimator, observer, model, or baseline name. | Method identity is ambiguous or mixed across rows. |
| `metric` | Exact metric name and units. | Metric differs from the BSEBench metric and row is marked `comparable`. |
| `dataset` | Dataset name plus variant, chemistry/profile when relevant, and version if available. | Dataset identity is missing, mixed, or incompatible with the report claim. |
| `split` | Train/test split, validation protocol, horizon, run condition, or public snapshot condition. | Split or run condition is unknown for a positive comparison. |
| `reported_value` | Exact external value as reported, including units and directionality. | Value is rounded beyond source precision, transformed without a note, or copied without units. |
| `bsebench_frozen_value` | Exact BSEBench value being compared, with units. | Value is generated ad hoc, not committed, or not tied to a frozen evidence artifact. |
| `bsebench_artifact` | Path, repository, branch, commit SHA, and artifact hash when practical. | The BSEBench value cannot be replayed or traced to a committed artifact. |
| `bsebench_command` | Command or workflow that produced or replayed the BSEBench value. | Command is missing for claim-supporting values. |
| `comparability` | One of `comparable`, `partial`, or `not_comparable`. | Empty, free-form, or stricter comparison language is used with `partial` or `not_comparable`. |
| `comparability_caveat` | Concrete limitation or "none" only when all fields match. | Empty caveat for a `partial` or `not_comparable` row. |
| `leakage_preprocessing_note` | Training/calibration/evaluation/preprocessing compatibility note. | External setup is unknown but the row is treated as fully comparable. |

## Claim-to-Ledger Acceptance Matrix

Every public report line or table cell that compares BSEBench to external work
must be mapped into this matrix before publication.

| Field | Required value |
|---|---|
| `claim_context_id` | Stable ID for the report line, table, figure, or paragraph. |
| `report_path` | Path to the candidate public report or snapshot. |
| `line_or_table_ref` | Line number, table row, figure caption, or section ID. |
| `claim_text_hash` | Hash or quoted excerpt short enough for review. |
| `claim_type` | `external_comparison`, `internal_ranking`, `monthly_snapshot`, `claim_registration`, `limitation`, or `neutral_evidence`. |
| `trigger_terms` | Terms or structure that caused ledger review, including comparative adjectives or ranking columns. |
| `source_ledger_ids` | All ledger row IDs required by this claim. |
| `bsebench_evidence_ids` | Frozen BSEBench artifact IDs used by the claim. |
| `decision` | `pass`, `needs_caveat`, `block`, `pending_worker`, or `out_of_scope`. |
| `reviewer_note` | Concrete reason and next action. |

Decision rules:

- `pass`: all required source rows are complete, all BSEBench values are frozen,
  and every row used for a positive comparison is `comparable`.
- `needs_caveat`: the statement is factual and useful, but a row is `partial`;
  wording must be downgraded to a limitation or scoped comparison.
- `block`: required source metadata, BSEBench frozen evidence, exact metric,
  dataset, split, or comparability caveat is missing.
- `pending_worker`: a dependency branch is still running or has no pushed commit
  in the watchdog log; validators must wait and re-check.
- `out_of_scope`: the text is neutral evidence or operational status with no
  external comparison or claim-promotion meaning.

## Rejection Cases

Reject the report, snapshot, or claim registration task when any of these are
true:

1. A comparison phrase, ranking table, or external numeric result has no
   source-ledger row.
2. A source row lacks stable URL/DOI, retrieval date, exact metric, dataset,
   split, BSEBench frozen value, or comparability caveat.
3. A row marked `partial` or `not_comparable` is used to support positive
   comparison wording.
4. A BSEBench value is not tied to repository, branch, commit SHA, artifact path,
   and replay or generation command.
5. The report mixes SOC and SOH metrics, chemistries, temperature conditions,
   horizons, or train/test protocols without separate rows and caveats.
6. A worker branch is still running according to watchdog logs and the report
   treats the absence of a pushed commit as a failed result instead of
   `pending_worker`.
7. A validator reads only stdout text but does not fetch the branch or inspect a
   read-only worktree after a commit appears.
8. Any claim-registration text edits thesis files, manuscript files, claim
   registry files, `claims/registry.yaml`, `claim_55`, or roadmap files without
   an explicit claim-registration BRIEF and completed evidence/source gates.
9. A public report uses claim-promotion vocabulary without a completed source
   ledger and a separate claim-registration decision.
10. A source is inaccessible at retrieval time and the comparison still treats
    the external value as fully comparable.

## Wave 1 Validator Rule

For Wave 1 branches `phase-8-0-a` through `phase-8-0-x`, validators must use the
watchdog logs as a status signal, not as the final evidence artifact.

Required validator sequence:

1. Inspect the assigned watchdog log under
   `/home/oakir/.local/state/bsebench-async-watchdog`.
2. If the log shows the worker is still running or lacks a pushed commit, mark
   the branch `pending_worker` and re-check later.
3. If a commit SHA or successful push appears, fetch the remote branch in the
   target repository.
4. Validate from the fetched branch or a read-only worktree.
5. Record the commit SHA, changed files, validation commands, and residual
   risks.

Do not declare failure solely because an active worker has not yet pushed.

## Public Report Gate

Before any monthly benchmark snapshot or public report is released, require:

1. Claim inventory:
   - Run a line-level scan for comparison, ranking, and claim-promotion wording.
   - Include tables, captions, figure text, README conclusions, report summaries,
     and release notes.
2. Ledger completeness:
   - Each external number has a complete source-ledger row.
   - Each row includes stable source identity, retrieval date, exact metric,
     dataset, split, reported value, BSEBench frozen value, and caveat.
3. Frozen BSEBench evidence:
   - Each internal value has repository, branch, commit, artifact path, command,
     metric, dataset, split, and hash when practical.
4. Comparability decision:
   - Positive comparison wording is allowed only for `comparable` rows.
   - `partial` rows can support scoped caveats or limitation language only.
   - `not_comparable` rows can support gap statements only.
5. Protected-file gate:
   - No thesis, manuscript, claim registry, roadmap, `claims/registry.yaml`, or
     `claim_55` edits unless a separate claim-registration task explicitly
     authorizes them.
6. Reviewer output:
   - Publish the claim-to-ledger matrix with decisions and residual risks.
   - Include exact validation commands and commit SHAs.

## Recommended Next Actions

1. Add a report-level claim scanner that accepts public report paths and emits a
   claim-to-ledger matrix skeleton.
2. Extend source-ledger validation beyond fixture rows by checking line-level
   bindings from report claims to ledger IDs and frozen BSEBench artifact IDs.
3. Add a monthly snapshot preflight that rejects positive comparison wording
   unless all rows are `comparable`.
4. Add a validator helper that converts watchdog log status into
   `pending_worker`, `ready_to_fetch`, or `validated` states.
5. Require public report PRs to include a GLASSBOX section listing source-ledger
   file path, BSEBench frozen artifact path, branch SHA, retrieval date, and
   residual comparability risks.

## Residual Risks

- The current repo has a BRIEF checker, but this audit did not implement a new
  report scanner because the owned write set is limited to this Markdown file.
- Watchdog logs combine prompts, shell output, and final summaries; automated
  parsing can produce false matches unless it keys on structured outbox
  summaries or exact commit lines near final output.
- Existing source-ledger fixtures demonstrate schema shape but do not prove that
  every future public report line is mapped to a ledger row.
- External source retrieval can change over time; report review should archive
  source metadata, retrieval date, and exact source location.
- Some Wave 1 workers were active while this audit was written. Their absence
  from a pushed branch at this timestamp is not evidence of failure.

## Validation

Validation performed for this audit artifact:

| Check | Result |
|---|---|
| Existing docs and gates inspected. | Passed. Evidence commands are listed above. |
| Required source-ledger fields defined. | Passed. See "Required Source-Ledger Row". |
| Concrete rejection cases defined. | Passed. See "Rejection Cases". |
| Protected write set respected. | Passed. Only this audit path was created. |
| No positive benchmark comparison or claim-promotion statement made. | Passed. This report defines guardrails and rejection cases only. |
| `git diff --cached --check` and `git diff --check` | Passed after staging this audit file. |

Final acceptance condition for this branch: `git diff --check` passes, commit
contains GLASSBOX metadata, and push to
`origin/phase-8-1-q-anti-hallucination-source-ledger-audit-20260507T193050Z`
succeeds.
