# Anti-Hallucination Claim Promotion Gate

Status: checklist_only

Branch: phase-8-11-h-claims-gate-checklist-20260508T075340+0200

## Objective

Define a source-ledger-first checklist for BSEBench reports and thesis-safe
claim promotion. The gate is designed to keep BSEBench useful as a universal
open benchmark for SOC/SOH estimators, filters, ECMs, AI observers, and hybrid
methods while blocking unsupported SOTA, novelty, leaderboard, breakthrough, or
verified-claim language.

This file is not evidence that any report result or thesis claim has passed.
It is a promotion checklist for future evidence, comparison, and registration
work.

## Inputs Inspected

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`
- `cto/AUTONOMY_BACKLOG/README.md`
- `cto/AUTONOMY_BACKLOG/phase-7-10-g-async-source-ledger-schema/BRIEF.md`
- `inbox/phase-7-10-p-async-source-ledger-comparability-fixtures/BRIEF.md`
- `outbox/phase-7-10-j-async-claim-language-linter/SUMMARY.md`
- `outbox/phase-7-10-p-async-source-ledger-comparability-fixtures/SUMMARY.md`
- `outbox/claim-candidate-63-hinf-residual-cov-decomp/READINESS_CHECKLIST.md`
- current branch ref: `phase-8-11-h-claims-gate-checklist-20260508T075340+0200`

No thesis repository files, `claims/registry.yaml`, `claim_55`, manuscript
files, or roadmap files were inspected for this checklist.

## Decisions

1. Treat claim promotion as a three-lane process: evidence generation, SOTA or
   external comparison, then claim registration. A single task must not write
   across those lanes.
2. Treat BSEBench report wording as candidate language unless the report cites
   committed evidence, an independent replay result, and a source ledger with
   comparability decisions.
3. Treat every missing source-ledger field as a comparability gap, not as a
   value that can be inferred from memory or surrounding prose.
4. Allow benchmark ranking or grouping only inside the declared BSEBench
   evidence scope. Do not translate "best observed in this artifact" into
   SOTA, novelty, leaderboard, or thesis-ready wording.
5. Require source-ledger rows for every external value used in a comparison,
   including values that are later marked `partial` or `not_comparable`.
6. Require claim registration to cite frozen local artifacts and exact replay
   commands. A zero exit code alone is not enough.
7. Keep protected claim and thesis files out of checklist work. Claim
   registration requires a separate task that explicitly authorizes those
   edits.

## Gate Checklist

### G0 - Scope And Lane

- [ ] The active lane is named: `evidence_generation`, `sota_comparison`, or
  `claim_registration`.
- [ ] The allowed write paths match that lane.
- [ ] The task does not edit thesis prose, manuscript files, roadmap files,
  `claims/registry.yaml`, protected claim files, or `claim_55` unless it is an
  explicitly authorized claim-registration task.
- [ ] The report states whether it is mechanical evidence, comparison review,
  or claim-registration output.

### G1 - Evidence Identity

- [ ] The evidence bundle path is local and committed, or the unavailable
  artifact is explicitly listed as a blocker.
- [ ] The branch and commit SHA that produced the evidence are recorded.
- [ ] The exact command line used to produce or replay the evidence is recorded.
- [ ] Input datasets, configs, profiles, cells, chemistries, splits, and cache
  identifiers are recorded when applicable.
- [ ] Output artifact paths and hashes are recorded when practical.
- [ ] Missing provenance is described as a gap and does not support claim
  language.

### G2 - Independent Replay

- [ ] A replay command consumes frozen artifacts or deterministic local cache
  state rather than silently regenerating a different result.
- [ ] Replay output names the artifact read, values compared, tolerances,
  mismatch count, and pass/fail status.
- [ ] Any mismatch blocks claim promotion until explained and revalidated.
- [ ] A successful script exit without checked values is marked insufficient.

### G3 - Source Ledger

For every external value or prior-work comparison, the source ledger has:

- [ ] `source_id`
- [ ] `title`
- [ ] DOI, arXiv URL, official repository URL, or other stable URL
- [ ] retrieval date in ISO format
- [ ] method or estimator name
- [ ] exact metric name and units
- [ ] dataset, cell set, chemistry, and profile when applicable
- [ ] train/test split, validation protocol, horizon, or run condition
- [ ] reported value with table, figure, page, or artifact locator when
  available
- [ ] frozen BSEBench value being compared
- [ ] comparability value: `comparable`, `partial`, or `not_comparable`
- [ ] caveat explaining any missing or incompatible field

If any row lacks a required field, the row must be `partial` or
`not_comparable`. If the missing field affects the comparison conclusion, the
report must not promote the claim.

### G4 - Comparability

- [ ] Metrics compare the same quantity, unit, aggregation policy, and error
  basis.
- [ ] Dataset identity, chemistry, profile, temperature, aging state, and cell
  count are aligned or the mismatch is marked as a caveat.
- [ ] Splits and tuning boundaries are aligned. Calibration, training,
  hyperparameter tuning, and blind evaluation data are separated.
- [ ] Preprocessing, resampling, interpolation, filtering, and SOC/SOH ground
  truth policies are aligned or explicitly marked incompatible.
- [ ] Runtime or compute comparisons use the same hardware, implementation
  tier, precision, and measurement method, or they are scoped as partial.
- [ ] Cross-method comparisons use the same protocol and failure handling. A
  method with invalid outputs is not silently excluded.
- [ ] Aggregate summaries include the weighting policy and sample counts.
- [ ] A public-facing table can distinguish BSEBench-internal ranking from
  external-literature comparison.

### G5 - Language Gate

Allowed before claim registration:

- [ ] mechanical evidence
- [ ] candidate
- [ ] replay passed or replay failed
- [ ] source-ledger row is comparable, partial, or not comparable
- [ ] blocked by missing evidence, source, provenance, replay, or
  comparability

Blocked unless an authorized claim-registration task cites validated evidence
and a completed ledger:

- [ ] SOTA
- [ ] novel
- [ ] leaderboard winner
- [ ] breakthrough
- [ ] verified thesis claim
- [ ] proven mechanism
- [ ] claim accepted
- [ ] claim registry updated

### G6 - Promotion Decision

Use one of these outcomes:

- `block`: evidence identity, replay, source ledger, or protected-file scope is
  missing.
- `defer`: evidence exists but comparability is partial, not comparable, or
  insufficient for thesis-safe wording.
- `candidate`: evidence and replay support a scoped BSEBench-internal report
  statement, but external comparison or claim registration is incomplete.
- `ready_for_registration_task`: evidence, replay, source ledger, and
  comparability requirements pass, and a separate task may request claim
  registration.

Only `ready_for_registration_task` may feed a future claim-registration brief.
It still does not itself modify thesis or registry files.

## Validation Checklist For This Gate File

- [ ] Only `validation/claims/anti-hallucination-gate-20260508T075340+0200.md`
  is changed.
- [ ] The checklist includes objective, inputs inspected, decisions,
  validation checklist, residual risks, and next concrete task.
- [ ] The file uses ASCII text.
- [ ] No unsupported SOTA, novelty, leaderboard, breakthrough, or verified
  claim is made.
- [ ] No results are invented.
- [ ] `git diff --check` passes.
- [ ] Any lightweight relevant checks available in this repo are run when
  applicable.
- [ ] `git status --short` is clean after commit.

## Residual Risks

- This checklist is manual guidance. It does not enforce claim wording unless a
  separate linter or review process consumes it.
- The current repo snapshot may not contain the latest merged versions of
  source-ledger tooling from other branches.
- The checklist does not validate any external paper, DOI, benchmark value, or
  BSEBench result.
- Future claim-registration work can still overreach if reviewers ignore
  `partial` or `not_comparable` rows.
- Protected thesis and claim registry files were intentionally not inspected,
  so this checklist does not certify their current contents.

## Next Concrete Task

Add a lightweight gate consumer that reads a BSEBench report plus a source
ledger and emits `block`, `defer`, `candidate`, or
`ready_for_registration_task` with the failed checklist item names. The consumer
should use synthetic fixtures first and must not edit thesis, roadmap, or claim
registry files.
