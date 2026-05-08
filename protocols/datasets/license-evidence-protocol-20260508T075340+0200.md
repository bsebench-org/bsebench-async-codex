# Dataset License Evidence Protocol

Branch: `phase-8-11-e-license-evidence-protocol-20260508T075340+0200`

## Objective

Define a fail-closed license and provenance evidence protocol for monthly
BSEBench dataset admission. The protocol is intended to support a universal
open benchmark for SOC/SOH estimators, filters, ECM variants, observers, and AI
estimators without relying on unsupported SOTA, novelty, leaderboard,
breakthrough, or comparability claims.

The protocol decides whether a dataset may be used in a monthly public
benchmark snapshot, whether it may be retained only as an internal/local
adapter target, or whether it must be blocked until missing evidence is
resolved.

## Inputs Inspected

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`: universal
  benchmark objective, recurring monthly benchmark workflow, provenance,
  leakage, split, and claim-integrity expectations.
- `outbox/phase-7-10-m-datasets-phase11-provenance-inventory/SUMMARY.md`:
  prior Phase 11 provenance inventory summary, including ready, missing,
  unreadable, unknown metadata, and not applicable status categories.
- `outbox/phase-7-8-c-datasets-hinf-loader-provenance-audit/SUMMARY.md`:
  prior strict Hinf loader provenance audit summary, including explicit
  machine-readable provenance gaps and non-fabrication behavior.
- `cto/AUTONOMY_BACKLOG/phase-7-10-m-datasets-phase11-provenance-inventory/BRIEF.md`:
  local-cache and metadata falsification requirements for provenance work.
- Git branch state inspected locally: work started on
  `phase-8-11-e-license-evidence-protocol-20260508T075340+0200`, tracking
  `origin/main`.
- Owned target inspected locally:
  `protocols/datasets/license-evidence-protocol-20260508T075340+0200.md` did
  not exist before this change.

## Monthly Admission Inputs

Every dataset proposed for a monthly benchmark snapshot must submit a dataset
evidence bundle. The bundle may be maintained in whatever repository structure
the dataset tooling later standardizes, but it must expose the following
fields in machine-readable form before monthly admission:

- Dataset identifier used by BSEBench.
- Dataset display name.
- Upstream source name.
- Upstream source URL, DOI, repository ref, or archived artifact ref.
- Retrieval date or local acquisition date.
- Upstream license name exactly as published by the source.
- License evidence artifact path or stable URL.
- Permission scope: download, cache, redistribute raw data, redistribute
  derived data, publish metrics, publish traces, publish plots, and cite.
- Provenance evidence artifact path or stable URL.
- Raw artifact identity: filename, byte size when available, and checksum when
  available.
- Transformation lineage from raw artifact to benchmark-ready cache, including
  loader version or commit ref when available.
- Split policy evidence, including train/tune/evaluation separation where the
  dataset is used for algorithm comparison.
- Sensor channel and unit evidence for voltage, current, temperature, time,
  SOC, SOH, and any auxiliary channels required by the benchmark protocol.
- Chemistry, cell, profile, temperature, and aging/SOH metadata evidence when
  those axes are used for filtering or reporting.
- Known restrictions, embargoes, citation requests, attribution language, and
  non-commercial or no-redistribution clauses.
- Human reviewer, review date, and review decision.

Missing values are allowed in the evidence bundle only when represented as
explicit gaps. The bundle must not infer license terms, units, chemistry,
profile, temperature, aging state, split policy, or redistribution rights from
filenames, common knowledge, or unpublished local assumptions.

## Evidence Status Vocabulary

Admission tooling should use these statuses exactly or map local statuses to
them without weakening their meaning:

- `ready`: the field has direct evidence, the evidence is reachable to the
  reviewer, and the recorded value is sufficient for the requested monthly use.
- `missing`: no evidence was provided.
- `unreachable`: an evidence ref was provided but could not be accessed during
  review.
- `unreadable`: an evidence artifact exists but could not be parsed or reviewed.
- `ambiguous`: evidence exists but does not clearly support the recorded value.
- `restricted`: evidence exists and shows a license or provenance restriction
  that limits the requested monthly use.
- `unknown_metadata`: evidence exists for the dataset but not for this required
  metadata field.
- `not_applicable`: the field is not required for the declared monthly use, and
  the reason is recorded.
- `superseded`: the field was previously reviewed but the upstream source,
  license, artifact, or transformation identity changed and requires a new
  review.

Only `ready` and justified `not_applicable` fields can pass admission.

## Decisions

### Admission States

Monthly review must assign exactly one admission state per dataset-version:

- `admitted_public_snapshot`: allowed in the monthly public benchmark snapshot.
- `admitted_metadata_only`: listed as available or planned, but no benchmark
  metrics, traces, plots, or derived artifacts are published.
- `internal_local_only`: adapter work may continue locally, but the dataset is
  excluded from public snapshots because redistribution, publication, or source
  evidence is incomplete or restricted.
- `blocked_missing_evidence`: excluded from monthly workflows because required
  evidence is missing, unreachable, unreadable, ambiguous, or superseded.
- `blocked_license_restriction`: excluded from the requested use because
  license evidence shows the use is not allowed.
- `retired_or_replaced`: excluded because a newer reviewed dataset-version or
  source artifact replaces it.

### Minimum Evidence for Public Snapshot Admission

The monthly review may assign `admitted_public_snapshot` only when all of the
following are true:

- License name and license evidence are `ready`.
- Permission to publish benchmark metrics is `ready`.
- Permission to publish required plots and aggregate reports is `ready`, or the
  monthly snapshot disables those outputs for this dataset and records why.
- Raw artifact identity is `ready` for the artifact actually used.
- Transformation lineage from raw artifact to benchmark cache is `ready`.
- Split policy evidence is `ready` for any comparison involving tuning,
  training, calibration, or blind evaluation.
- Required unit and sampling metadata are `ready` for every metric or protocol
  that depends on them.
- Restrictions and attribution requirements are `ready` and reflected in the
  monthly report metadata.
- Reviewer identity, review date, and decision are `ready`.

### Fail-Closed Missing Evidence Behavior

Monthly admission fails closed. If a required field is `missing`,
`unreachable`, `unreadable`, `ambiguous`, `unknown_metadata`, or `superseded`,
the dataset must not enter `admitted_public_snapshot`.

Required fail-closed outcomes:

- Missing license evidence blocks public admission as
  `blocked_missing_evidence`.
- Ambiguous or conflicting license evidence blocks public admission as
  `blocked_missing_evidence` until resolved by a human reviewer.
- Explicit license restrictions that prohibit the requested use block public
  admission as `blocked_license_restriction`.
- Missing redistribution rights prevent publishing raw or derived data
  artifacts, even if aggregate metric publication is allowed.
- Missing metric-publication rights prevent monthly public benchmark metrics
  for that dataset.
- Missing source URL, DOI, archived artifact ref, or acquisition evidence
  blocks public admission unless a reviewer records a justified local-only
  decision.
- Missing raw artifact identity blocks public admission because results cannot
  be tied to a reproducible source.
- Missing transformation lineage blocks public admission because results cannot
  be tied to a reproducible cache.
- Missing split policy blocks comparative algorithm reporting for that dataset.
- Missing units or cadence block any protocol that depends on those values.
- Missing chemistry, profile, temperature, or aging metadata blocks use of that
  axis in reports and filters.
- A changed upstream artifact, changed license page, changed loader
  transformation, or changed split definition marks previous evidence
  `superseded` and requires re-review before the next monthly snapshot.

No dataset may be treated as open, redistributable, comparable, or benchmark
ready by default. Absence of evidence means exclusion from the affected public
use, not reviewer discretion to infer permission.

### Allowed Local-Only Work

Datasets with incomplete public evidence may still support local adapter,
loader, and cache-readiness work when the local use is lawful and no restricted
artifact is committed. Such datasets must be marked `internal_local_only` or
`blocked_missing_evidence` for public snapshots until the evidence bundle is
complete.

Local-only work must not be used to claim public benchmark coverage, public
comparability, dataset availability, or community leaderboard readiness.

### Evidence Refresh

Evidence must be refreshed before each monthly snapshot when any of these
conditions apply:

- The dataset source artifact changed.
- The upstream license text or hosting location changed.
- The local cache checksum changed.
- The loader, harmonizer, resampler, split policy, or unit mapping changed.
- A reviewer previously marked any required field `superseded`, `ambiguous`,
  `unreachable`, or `unreadable`.
- The monthly report adds a new output type, such as traces, plots, derived
  data, or downloadable cache summaries.

Unchanged evidence may be carried forward only when the dataset-version,
artifact identity, license evidence ref, transformation lineage, and monthly
output scope are unchanged.

## Validation Checklist

Before a dataset is admitted to a monthly public snapshot, the reviewer or
admission job must validate:

- Evidence bundle exists for the dataset-version under review.
- All required fields are present with status values from the evidence status
  vocabulary.
- License evidence is direct, reachable, and sufficient for the monthly output
  scope.
- Provenance evidence identifies the raw artifact actually used.
- Checksums or equivalent artifact identities match the local cache inputs when
  available.
- Transformation lineage identifies the loader or conversion implementation
  used for the benchmark cache.
- Split policy evidence separates training, tuning, calibration, and evaluation
  roles where applicable.
- Unit, cadence, chemistry, profile, temperature, and aging metadata are not
  inferred from filenames alone.
- Restrictions and attribution language are represented in report metadata.
- Any missing, ambiguous, unreadable, unreachable, unknown, restricted, or
  superseded field maps to a blocked or local-only admission state.
- The monthly report does not make SOTA, novelty, leaderboard, breakthrough, or
  universal comparability claims from datasets that are not admitted for that
  exact use.
- The review leaves an audit record with reviewer, date, dataset-version, input
  refs, decision, and residual risks.

## Residual Risks

- License terms can change after review, so monthly snapshots need immutable
  evidence refs or archived copies where allowed.
- Some upstream datasets may allow metric publication but not raw or derived
  artifact redistribution, which requires output-specific gating.
- Some legacy datasets may lack complete unit, cadence, split, or acquisition
  evidence; those can support adapter development but cannot be treated as fully
  comparable public benchmark inputs.
- Human review remains necessary for ambiguous license language and conflicting
  source pages.
- This protocol defines admission behavior only; it does not implement the
  machine-readable evidence schema, CI gate, or monthly report integration.

## Next Concrete Task

Implement a read-only dataset admission preflight that consumes a
machine-readable evidence bundle, emits the admission states above, and fails
CI for any monthly public snapshot candidate whose required evidence is not
`ready` or justified `not_applicable`.
