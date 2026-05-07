# BSEBench Community Monthly Benchmark Report Outline

Saved: 2026-05-07T22:59:00+02:00.
Worker: W4-23.
Branch: `phase-8-3-w-community-benchmark-report-outline-20260507T204627Z`.
Owned write set:
`docs/universal/community-benchmark-report-outline-20260507T204627Z.md`.

## Objective

Define a public monthly report outline for BSEBench community benchmark
snapshots that is useful to contributors without creating unsupported
scientific claims. The outline is designed for SOC/SOH methods across ECMs,
Kalman-family filters, observers, AI estimators, hybrid methods, baselines, and
future estimator families.

This is a report-shape and wording-control artifact. It does not publish
benchmark results, register claims, edit thesis/manuscript/registry files, or
change the scientific roadmap.

## Evidence Inspected

| Evidence | What was inspected | Finding used by this outline |
|---|---|---|
| `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md` | Universal benchmark objective and monthly snapshot goal. | Reports must support multi-axis benchmark interpretation with caveats, not a single simplistic ranking. |
| `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` | Research gate, source-ledger fields, and allowed pre-claim language. | Public comparison language requires source-ledger rows with stable source, exact metric, dataset, split, frozen BSEBench value, comparability, and caveat. |
| `origin/phase-8-0-t-universal-async-monthly-snapshot-schema` | Monthly snapshot schema document and JSON Schema. | Snapshot reports must expose identity, release caveats, evidence artifacts, source ledgers, registries, protocols, ranking groups, result rows, and row caveats. |
| `origin/phase-8-1-r-monthly-benchmark-workflow-design-20260507T193050Z` | Monthly workflow design. | The report should mirror states from submission intake through frozen snapshot and errata. |
| `origin/phase-8-1-q-anti-hallucination-source-ledger-audit-20260507T193050Z` | Source-ledger audit and claim-to-ledger acceptance matrix. | Every report line or table cell with comparison meaning needs a ledger binding and decision. |
| `origin/phase-8-0-s-universal-async-submission-template` | Contributor submission template and validation checklist. | Method rows must connect to submission metadata, training/tuning disclosure, and reproducibility commands. |
| `origin/phase-8-0-w-universal-async-public-release-checklist` | Public benchmark release checklist. | Release text must preserve anti-leakage, source-ledger, submission, adapter, report-quality, and sign-off gates. |
| `/home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-{0,1,2}-*.log` | Phase 8 worker log status. | Observed 48 prior Phase 8 logs: 24 Wave 1, 12 Wave 2, and 12 Wave 3. Of those, 45 were completion-like and 3 Wave 3 logs hit the usage limit. |

Usage-limit logs that must stay visible until retried or accounted for:

- `manual-phase-8-2-j-reproducibility-artifact-manifest-audit-20260507T193528Z.log`
- `manual-phase-8-2-k-merge-queue-runbook-20260507T193528Z.log`
- `manual-phase-8-2-l-worker-triage-and-relaunch-runbook-20260507T193528Z.log`

## Commands Run

```bash
git status -sb
git branch --show-current
find docs -maxdepth 4 -type f | sort | sed -n '1,220p'
sed -n '1,220p' docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md
sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md
git branch -r --list 'origin/phase-8-*' | sort | sed -n '1,140p'
git show origin/phase-8-0-t-universal-async-monthly-snapshot-schema:docs/BSEBENCH-MONTHLY-SNAPSHOT-SCHEMA-2026-05-07.md
git show origin/phase-8-0-t-universal-async-monthly-snapshot-schema:docs/schemas/bsebench-monthly-benchmark-snapshot-v1.schema.json
git show origin/phase-8-1-r-monthly-benchmark-workflow-design-20260507T193050Z:docs/universal/monthly-benchmark-workflow-20260507T193050Z.md
git show origin/phase-8-1-q-anti-hallucination-source-ledger-audit-20260507T193050Z:audits/universal/source-ledger-audit-20260507T193050Z.md
git show origin/phase-8-0-w-universal-async-public-release-checklist:docs/BSEBENCH-PUBLIC-BENCHMARK-RELEASE-CHECKLIST-2026-05-07.md
```

Prior Phase 8 log status was checked with:

```bash
for p in 0 1 2; do
  total=$(find /home/oakir/.local/state/bsebench-async-watchdog \
    -maxdepth 1 -type f -name "manual-phase-8-$p-*.log" | wc -l)
  completion=$(for f in /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-$p-*.log; do
    if rg -qi 'usage limit' "$f"; then
      :
    elif tail -n 100 "$f" | rg -q 'Implemented and pushed|Branch pushed|Pushed branch|Push status|Commit:|changed files|Final output'; then
      echo yes
    fi
  done | wc -l)
  usage=$(rg -l -i 'usage limit' /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-$p-*.log | wc -l)
  printf 'phase-8-%s total=%s completion_like=%s usage_limit=%s\n' "$p" "$total" "$completion" "$usage"
done
```

Observed result:

```text
phase-8-0 total=24 completion_like=24 usage_limit=0
phase-8-1 total=12 completion_like=12 usage_limit=0
phase-8-2 total=12 completion_like=9 usage_limit=3
```

## Report Front Matter

Every public monthly report should begin with these fields before any prose:

| Field | Required value |
|---|---|
| `report_id` | Stable report identifier, for example `bsebench-community-monthly-YYYY-MM`. |
| `snapshot_id` | Matching monthly snapshot JSON ID. |
| `snapshot_month` | Calendar month covered by the frozen snapshot. |
| `release_status` | `draft`, `frozen`, `withdrawn`, or `erratum`. |
| `report_commit` | Async/report repository commit that contains the report. |
| `snapshot_json` | Path and SHA-256 hash of the monthly snapshot JSON. |
| `release_dossier` | Path to sign-off record, release checklist, and freeze record. |
| `base_commits` | Runner, stats, datasets, and async/report commits. |
| `source_ledger_status` | `not_used`, `complete`, `partial`, or `blocked`. |
| `publish_decision` | `publish`, `publish_with_caveats`, or `blocked`. |

Allowed opening sentence:

```text
This report summarizes the frozen BSEBench community snapshot for <month>
under the protocols, datasets, metrics, and caveats listed below.
```

Required companion sentence:

```text
The report is scoped to this snapshot and does not make thesis, claim-registry,
novelty, SOTA, breakthrough, or verified-claim statements.
```

## Required Ledgers

The report is publishable only when each applicable ledger exists or has an
explicit blocking gap. Empty ledgers are allowed only when the report says the
corresponding evidence or comparison is not used.

| Ledger | Required before publication | Minimum fields |
|---|---|---|
| Snapshot identity ledger | Always. | `snapshot_id`, month, freeze candidate timestamp, frozen timestamp, release status, base commits, schema versions, release owner. |
| Submission ledger | For every included or excluded method. | Method ID, method family, adapter version, code identity, dependency lock or gap, training/calibration/tuning disclosure, requested protocols, reviewer decision. |
| Dataset availability ledger | For every reported or missing dataset axis. | Dataset ID, chemistry, profile, temperature, aging/SOH axis, split IDs, license/redistribution status, cache/provenance status, availability caveat. |
| Protocol and split ledger | For every result row. | Protocol ID, protocol version, task family, initialization policy, calibration/training/tuning/blind split IDs, leakage guard status, split caveat. |
| Internal evidence ledger | For every public BSEBench value. | Result row ID, command, config hash, output artifact path, output hash, run timestamp, environment identity, runner/stats/datasets/async commits. |
| Metric ledger | For every table or chart. | Metric ID, exact definition, unit, direction, aggregation level, finite-value policy, failed-run count, invalid/missing/excluded count, caveat. |
| Compute ledger | For any runtime, memory, operation-count, or deployability statement. | Hardware or environment identity, timing command, sample count, wall-time/per-step distinction, memory method, hardware caveat. |
| Source ledger | For every external comparison number or comparison phrase. | Source ID, title, stable URL or DOI, retrieval date, source location, method, exact metric and unit, dataset, split/run condition, reported value, frozen BSEBench value, comparability, caveat. |
| Claim-to-ledger matrix | For every line, table cell, caption, or summary with comparison meaning. | Report path, line/table reference, trigger terms, claim type, source ledger IDs, BSEBench evidence IDs, decision, reviewer note. |
| Exclusion and missingness ledger | For every method, dataset, protocol, or row not shown in comparable tables. | Entity ID, exclusion reason, status, responsible validator, caveat, whether it remains visible in appendix tables. |
| Freeze and sign-off ledger | Always. | Release checklist path, validator names or commands, pass/fail statuses, artifact hashes, known residual risks, publish decision. |

## Report Outline

### 1. Snapshot Scope

Purpose: state what month, commits, method families, datasets, protocols, and
metric axes are included.

Allowed wording:

```text
This snapshot includes rows that passed the listed adapter, split, provenance,
metric, and release checks. Rows that are invalid, missing, excluded, partial,
or not comparable remain visible in the caveat tables.
```

Required tables:

- Snapshot identity table.
- Included method-family coverage table.
- Dataset and protocol coverage table.
- Release caveat table.

Do not include numeric performance values in this section.

### 2. Method Submissions

Purpose: show what methods were submitted, accepted for smoke, accepted for
benchmarking, excluded, or blocked.

Required columns:

| Column | Rule |
|---|---|
| `method_id` | Must resolve to submission ledger. |
| `method_family` | Must use controlled family names: ECM, Kalman-family filter, observer, AI estimator, hybrid, baseline, or other declared family. |
| `adapter_status` | `smoke_passed`, `smoke_failed`, `accepted_as_partial`, `blocked`, or `excluded`. |
| `training_tuning_disclosure` | Short reference to submission ledger; no inferred training history. |
| `known_unsupported_regimes` | Visible caveat or `none recorded by submission review`. |
| `report_visibility` | `comparable_table`, `partial_table`, `excluded_table`, or `blocked_appendix`. |

Allowed wording:

```text
Method visibility is determined by adapter, provenance, leakage, and metric
validators for this snapshot.
```

### 3. Dataset And Protocol Coverage

Purpose: show which chemistry, profile, temperature, aging/SOH, and split axes
were available and evaluated.

Required columns:

- `dataset_id`
- `chemistry`
- `profile_axis`
- `temperature_axis`
- `aging_or_soh_axis`
- `split_id`
- `protocol_id`
- `initialization_policy`
- `leakage_guard_status`
- `availability_caveat`

Allowed wording:

```text
Dataset coverage describes availability and provenance for this release
candidate. It is not a statement about all possible battery datasets.
```

### 4. Metric Axes

Purpose: define each metric before presenting values.

Required metric groups:

- Accuracy: RMSE, MAE, maximum absolute error, and any per-cell/profile
  distribution fields used by the snapshot.
- Reliability: degraded-initialization recovery, convergence, robustness, and
  invalid-output handling when present.
- Compute: runtime, memory, operation counts, or hardware-dependent metadata
  with caveats when present.
- Generalization: chemistry, profile, temperature, aging/SOH, and transfer axes
  when present.

Allowed wording:

```text
Metric axes are reported separately. Aggregated views are shown only when the
aggregation policy, eligible rows, invalid rows, and caveats are visible.
```

### 5. Result Tables

Purpose: show frozen BSEBench rows without hiding caveats.

Every value cell must bind to:

- `result_row_id`
- `metric_id`
- `protocol_id`
- `method_id`
- `dataset_id`
- `split_id`
- `evidence_artifact_id`
- result status
- comparability status
- caveat reference

Allowed table labels:

- `Comparable rows for <metric_id> under <protocol_id>`
- `Partial rows requiring caveats`
- `Not-comparable rows archived for transparency`
- `Invalid, missing, excluded, or timeout rows`

Rank fields are allowed only inside a named `ranking_group_id` from the monthly
snapshot schema. If the ranking policy, eligible row set, or caveats are
missing, the rank cell must be blank or `not released`.

Allowed wording:

```text
The ordering shown here is limited to <ranking_group_id> and uses the documented
aggregation policy for this snapshot.
```

Blocked wording category: unqualified overall superiority statements. This
category must not appear in a public report unless a separate, completed ledger
and review process explicitly authorizes a scoped statement.

### 6. External Comparison Section

Purpose: include external literature, repository, or public report comparisons
only when the source ledger is complete.

If no complete source ledger exists, use this section title:

```text
External Comparison Ledger: Not Used In This Snapshot
```

Allowed wording when rows are incomplete:

```text
External comparison rows are marked partial or not comparable where source,
metric, dataset, split, preprocessing, or horizon details are missing.
```

Required columns for any external row:

- `source_id`
- `title`
- `stable_url_or_doi`
- `retrieved_at`
- `source_location`
- `external_method`
- `external_metric`
- `external_dataset`
- `external_split_or_condition`
- `external_reported_value`
- `bsebench_frozen_value`
- `bsebench_artifact_id`
- `comparability`
- `comparability_caveat`

Rows marked `partial` or `not_comparable` may support gap statements only. They
must not support positive comparison prose.

### 7. Caveats And Exclusions

Purpose: make missingness, invalid rows, and blockers visible.

Required subsections:

- Invalid output rows.
- Missing dataset/profile/cell rows.
- Timeout or resource-limit rows.
- Excluded methods and reasons.
- Partial or not-comparable rows.
- Source-ledger gaps.
- Dataset license or redistribution gaps.
- Compute metadata gaps.

Allowed wording:

```text
The caveat tables are part of the result, not an appendix to ignore. They define
which conclusions the snapshot can and cannot support.
```

### 8. Reproducibility And Anti-Leakage

Purpose: connect the report to frozen artifacts and leakage checks.

Required items:

- Frozen base commits for runner, stats, datasets, and async/report repos.
- Snapshot JSON path and hash.
- Release checklist path.
- Split/leakage validator command and pass/fail status.
- Evidence generation or replay commands.
- Artifact paths and hashes.
- Environment/dependency capture or explicit gap.
- Any unretried usage-limit or stale-worker gaps affecting this release.

Allowed wording:

```text
Public values in this report are traceable to the listed commands, artifacts,
hashes, and commits. Missing provenance is reported as a gap.
```

### 9. Publication Decision

Purpose: give the reader a compact release decision without overclaiming.

Allowed decisions:

- `publish`: all required ledgers and validators passed for the report scope.
- `publish_with_caveats`: release is useful, but visible caveats constrain
  interpretation.
- `blocked`: one or more required ledgers, validators, hashes, or source rows
  are missing.
- `withdrawn`: the frozen snapshot should not be cited except through errata.

Required wording for `publish_with_caveats`:

```text
This report is publishable only with the caveats listed in the release dossier.
The caveats are part of the report scope.
```

### 10. Errata And Next Cycle

Purpose: preserve immutability and explain how corrections are handled.

Allowed wording:

```text
Corrections to a frozen report are append-only errata or replacement snapshots.
The frozen artifact is not silently rewritten.
```

Required fields for an erratum:

- affected `report_id`
- affected `snapshot_id`
- affected row IDs
- issue discovered
- validator or reviewer
- corrective action
- replacement artifact, if any
- publication timestamp

## Allowed Language Bank

These phrases are safe before claim registration when backed by the relevant
ledger:

| Use case | Allowed wording |
|---|---|
| Frozen scope | `within this frozen snapshot` |
| Evidence status | `mechanical evidence`, `replay passed`, `validator passed`, `blocked by missing evidence` |
| Comparability | `comparable according to the source ledger`, `partial`, `not comparable`, `requires caveat` |
| Ranking group | `ordered within <ranking_group_id> under the documented aggregation policy` |
| Missing data | `not available in this snapshot`, `excluded with visible reason`, `missing provenance` |
| Publication | `publishable with caveats`, `blocked pending ledger completion`, `withdrawn by erratum` |

These phrases require a completed source ledger and, where applicable, a
separate claim-registration lane. Without that evidence they are blocked:

| Blocked phrase type | Required before use |
|---|---|
| SOTA or equivalent superiority wording | Completed source ledger, comparable rows, frozen BSEBench evidence, and explicit reviewer approval. |
| Novelty or breakthrough wording | Completed source ledger and separate claim-registration authorization. |
| Verified claim wording | Completed evidence, source-ledger, and claim-registration task. |
| Unqualified leaderboard wording | Frozen ranking policy, complete eligible row set, visible caveats, and release owner approval. |
| Overall best wording | Documented multi-axis aggregation policy and complete caveat review; otherwise blocked. |

## Findings And Recommendations

Pass/fail assessment for this outline:

| Check | Result |
|---|---|
| Aligns with source-ledger gates. | Pass. The outline requires source rows and claim-to-ledger bindings before external comparison language. |
| Aligns with monthly snapshot schema. | Pass. The outline uses snapshot identity, evidence artifacts, source ledgers, registries, protocols, ranking groups, result rows, and caveat fields from the v1 schema. |
| Avoids fake numbers. | Pass. No example metric values, percentages, or performance claims are included. |
| Avoids unsupported ranks. | Pass. Ranking cells are allowed only within named ranking groups with documented policy and eligible rows. |
| Keeps invalid and missing rows visible. | Pass. Caveat and exclusion ledgers are required report sections. |
| Handles incomplete Wave 3 logs. | Pass. The three usage-limit logs are listed as gaps that must be retried or accounted for. |

Recommendations:

1. Add a machine-checkable report preflight that verifies every numeric cell has
   a `result_row_id`, every ranking cell has a `ranking_group_id`, and every
   external comparison cell has a `source_id`.
2. Add a line-level wording scanner that emits the claim-to-ledger matrix before
   public report review.
3. Add a report template generated directly from the monthly snapshot JSON to
   avoid hand-copied values.
4. Add negative fixtures for missing caveats, missing source-ledger rows,
   unsupported ranks, hidden invalid rows, and mutable freeze records.

## Residual Risks

- This artifact is a Markdown outline only; it does not implement a report
  generator, source-ledger validator, or wording scanner.
- The Wave 4 source-ledger schema worker had not produced a fetched artifact in
  this checkout when this outline was written, so alignment uses the current
  research gate, Wave 2 source-ledger audit, source-ledger fixture work, and
  public release checklist.
- Watchdog logs mix prompts, command output, and final summaries. The log-status
  count is sufficient for this GLASSBOX audit, but release automation should
  prefer structured outbox summaries or fetched branch commits.
- The three usage-limit Wave 3 tasks remain release risks until retried or
  explicitly excluded from the monthly report dependency set.
- A future public report can still overclaim if prose is edited after ledger
  validation. Freeze and errata controls must cover prose, tables, captions,
  and release notes.

## Explicit Non-Claims

- This outline does not state that BSEBench has published a monthly benchmark
  result.
- This outline does not rank any method, dataset, model, ECM, observer, filter,
  AI estimator, or hybrid method.
- This outline does not state that any method is SOTA, novel, a breakthrough,
  or verified.
- This outline does not register, update, verify, reject, or scope any thesis or
  claim-registry claim.
- This outline does not edit thesis files, manuscript files, roadmap files,
  `claims/registry.yaml`, claim registry files, or `claim_55`.

## Validation To Record

Required final validation for this branch:

```bash
git diff --check
rg -n "SOTA|novel|breakthrough|verified|leaderboard|overall best|rank" \
  docs/universal/community-benchmark-report-outline-20260507T204627Z.md
```

Expected interpretation of the wording scan: matches are allowed only in
guardrail, blocked-wording, validation, or explicit non-claim contexts. No
result claim, external comparison, fake numeric value, or unsupported rank is
made by this artifact.
