# BSEBench Universal Contributor Validation Checklist

Saved: 2026-05-07. Scope: reviewer checklist for external BSEBench method,
ECM, observer, AI estimator, and hybrid submissions.

## Purpose

This checklist turns a contributor package into a repeatable benchmark intake.
It is intentionally mechanical: it checks interface fit, leakage risk,
provenance, comparability, and monthly-snapshot readiness before any public
claim language is allowed.

Use with `templates/universal-contributor-submission-template.md`.

## Intake Gate

- [ ] Submission metadata is complete: ID, type, method family, maintainer,
  license, code source, artifact hash or commit, BSEBench version, entry point,
  environment, and hardware assumptions.
- [ ] The submission type is one of the accepted universal lanes: estimator
  adapter, ECM definition, observer, AI estimator, hybrid method, or report-only
  artifact.
- [ ] The package can be reviewed without editing thesis files, manuscript
  files, claim registry files, `claims/registry.yaml`, `claim_55`, or the
  scientific roadmap.
- [ ] The submission contains no unsupported SOTA, novelty, leaderboard,
  breakthrough, or verified-claim statements.
- [ ] If comparison text exists, a source ledger is present before the text is
  reviewed.

## Plug-And-Play Gate

- [ ] The estimator or method entry point is documented and callable by a
  benchmark runner or adapter wrapper.
- [ ] Initialization, reset, step, output schema, invalid-output behavior, and
  determinism policy are declared.
- [ ] The adapter does not require custom dataset loading, custom split logic,
  custom metric computation, or hand-written report code.
- [ ] Unsupported inputs, chemistries, temperature ranges, profiles, aging
  states, and deployment assumptions are documented.
- [ ] External services are absent or have an explicit offline fallback and
  reproducibility caveat.

## Leakage Gate

- [ ] Calibration, training, validation, and evaluation data are listed in
  separate rows.
- [ ] Evaluation labels, future samples, hidden split metadata, and generated
  benchmark outputs are not loaded during inference.
- [ ] Preprocessing fitted on calibration or training data is distinguishable
  from preprocessing fitted on evaluation data.
- [ ] Repeated public submissions were not used to tune hyperparameters, or the
  result is marked non-blind and non-comparable.
- [ ] Any leakage exception is explicit enough for reviewers to mark the result
  `invalid`, `partial`, or `not_comparable`.

## Provenance Gate

- [ ] Code is pinned by immutable commit, release tag, archive digest, or stable
  package hash.
- [ ] Dependencies are pinned by lockfile, environment export, container digest,
  or equivalent reproduction record.
- [ ] Dataset identifiers, cache hashes, raw-source provenance, and split IDs
  are recorded.
- [ ] Training, calibration, ECM-parameter, seed, and generated-output manifests
  are present when applicable.
- [ ] Hardware and runtime logs exist for any compute-cost statement.
- [ ] Missing provenance is listed as a caveat rather than filled from memory.

## Metric Gate

- [ ] Requested metrics have exact names, units, aggregation axes, and output
  fields.
- [ ] Accuracy metrics distinguish RMSE, MAE, and maximum absolute error.
- [ ] Reliability metrics state the degraded-initialization or noise protocol.
- [ ] Compute metrics state whether they are wall time, per-step time, memory,
  operation count, or hardware-specific metadata.
- [ ] Cross-domain metrics identify source domain, target domain, chemistry,
  profile, temperature, aging state, and split.
- [ ] Missing or invalid estimates are preserved in metric outputs and not
  silently dropped unless the metric contract explicitly says so.

## Comparison Ledger Gate

Every row used for comparison must include:

- [ ] Stable `source_id`.
- [ ] Paper, benchmark, repository, or report title.
- [ ] DOI, arXiv URL, official repository URL, or other stable URL.
- [ ] Retrieval date in ISO format.
- [ ] Exact metric name and units.
- [ ] Dataset and variant or profile.
- [ ] Split, validation protocol, horizon, or run condition.
- [ ] Reported value with table, figure, page, or artifact location when
  available.
- [ ] Frozen BSEBench value being compared.
- [ ] Comparability flag: `comparable`, `partial`, or `not_comparable`.
- [ ] Caveat explaining every limitation or missing field.

Block public comparison language when any required ledger field is missing.

## Reproduction Gate

- [ ] Reviewer can run the install or environment-restore command.
- [ ] Reviewer can run the smallest submission smoke check.
- [ ] Reviewer can run the selected protocol as a dry run or fixture run before
  expensive benchmark execution.
- [ ] Reviewer can export or inspect the raw metric table and report bundle.
- [ ] Command output records the BSEBench commit, submission artifact identity,
  dataset split identity, and runtime environment.

## Monthly Snapshot Readiness Gate

- [ ] The result can be categorized by method family, chemistry, profile,
  temperature, aging state, metric, and comparability status.
- [ ] The report can explain `invalid`, `partial`, `not_comparable`, and
  missing-data cases without changing the metric table.
- [ ] The submission includes enough provenance for a future reviewer to rerun
  or reject the same snapshot entry.
- [ ] No ranking, SOTA, novelty, or verified-claim wording is emitted unless the
  source ledger and benchmark validation gates both pass.

## Reviewer Decision

Record one decision:

- [ ] `accepted_for_smoke`: interface and provenance are sufficient for a cheap
  smoke run.
- [ ] `accepted_for_benchmark`: smoke passed and leakage/provenance gates are
  sufficient for the requested benchmark protocol.
- [ ] `accepted_as_partial`: runnable, but source, split, metric, or provenance
  caveats prevent full comparability.
- [ ] `blocked`: missing interface, leakage, provenance, source ledger, or
  reproduction requirements.
- [ ] `rejected`: cannot be evaluated without violating benchmark integrity
  rules.

Reviewer notes:

```text
<decision rationale, commands run, artifact hashes, and remaining caveats>
```
