# BSEBench Public Benchmark Release Checklist

Saved: 2026-05-07. Scope: public SOC/SOH benchmark snapshots and release
candidates.

This checklist is the public-release gate for BSEBench benchmark reports,
monthly snapshots, submission rounds, and any public comparison table. It is
deliberately stricter than an internal evidence checklist: every released
number must be replayable, leakage-safe, source-ledger-backed when compared to
external work, and clear about comparability limits.

## Release Candidate Identity

- [ ] Release candidate has a frozen git commit SHA, tag or release branch, and
      protocol version.
- [ ] Benchmark configuration files, estimator adapter versions, dataset card
      versions, split manifests, and metric schema versions are named in the
      release dossier.
- [ ] Every public table or artifact points to the frozen BSEBench value it
      reports, not to an uncommitted local run.
- [ ] The release dossier records the command used to regenerate each public
      table, plus output paths and hashes where practical.
- [ ] Any missing hash, metadata field, dataset card, or replay output is listed
      as a release gap, not inferred from memory.

## Anti-Leakage Gate

Release is blocked unless each applicable item is checked.

- [ ] Dataset split manifests declare calibration, training, validation,
      tuning, and blind-evaluation partitions separately.
- [ ] Partitions are disjoint at the leakage-relevant grouping level: cell,
      cycle, profile, temperature, aging state, chemistry, or source lab as
      applicable.
- [ ] ECM identification data is separated from estimator hyperparameter tuning
      data and from blind evaluation data.
- [ ] Any learned preprocessing, normalization, feature selection, early
      stopping, or model-selection step is fit only on the allowed training or
      tuning partition.
- [ ] Cross-chemistry, cross-profile, cross-temperature, and aging/SOH transfer
      reports state which domains were visible during calibration or tuning.
- [ ] Repeated measurements, resampled windows, overlapping time windows, and
      derived traces do not place near-duplicates on both sides of a reported
      split.
- [ ] Ground-truth SOC/SOH construction is auditable from dataset cards,
      including coulomb-counting, OCV recalibration, or equivalent references
      when available.
- [ ] The release includes a machine-checkable split/provenance manifest, or a
      documented blocker explaining why the snapshot cannot be public yet.

## Source-Ledger Gate

No public SOTA, novelty, leaderboard, breakthrough, "better than prior work",
or verified-claim statement is allowed unless every external comparison row has
a completed source ledger.

Minimum source-ledger fields for each external comparison:

| Field | Required content |
|---|---|
| `source_id` | Stable local identifier. |
| `title` | Paper, benchmark, repository, or report title. |
| `doi_or_url` | DOI, arXiv URL, official repository URL, or other stable URL. |
| `retrieved_at` | Retrieval date in ISO format. |
| `metric` | Exact metric name and units. |
| `dataset` | Dataset, cell/profile subset, chemistry, temperature, and variant. |
| `split` | Train/test split, validation protocol, horizon, or run condition. |
| `reported_value` | Exact external value and table, figure, page, or commit if known. |
| `bsebench_value` | Frozen BSEBench value, artifact path, and commit SHA. |
| `comparability` | `comparable`, `partial`, or `not_comparable`. |
| `caveat` | Missing field, mismatch, preprocessing difference, or scope limit. |

Ledger gates:

- [ ] Every number copied from external work has a ledger row with stable source
      identity and retrieval date.
- [ ] Rows with missing dataset, split, metric, preprocessing, horizon, or
      unit details are marked `partial` or `not_comparable`.
- [ ] Public report text uses the comparability label from the ledger and does
      not upgrade `partial` or `not_comparable` rows in prose.
- [ ] BSEBench values used for comparison are frozen, replayable, and tied to
      the same metric definition stated in the report.
- [ ] External claims and BSEBench claims are separated: "best in this release"
      is not written as SOTA unless the source-ledger review explicitly permits
      that wording.

## Submission And Adapter Gate

- [ ] Submitted methods run through the public estimator adapter contract
      without custom dataset loaders, custom metrics, or split overrides.
- [ ] Method metadata declares estimator family, external dependencies,
      training data, calibration data, and any pretrained weights.
- [ ] The release records whether the method is an ECM, Kalman-family filter,
      observer, AI estimator, hybrid method, or other declared family.
- [ ] Degraded-initialization and invalid-output behavior are included in the
      release dossier when the protocol requires them.
- [ ] Runtime or compute-cost metadata is reported with hardware caveats when
      available; missing compute metadata is visible, not silently dropped.

## Report Quality Gate

- [ ] Public tables expose metric axes separately: accuracy, maximum error,
      robustness, convergence/recovery, compute cost, and transfer axes where
      applicable.
- [ ] Missing, skipped, failed, non-finite, timeout, and unsupported runs are
      counted and visible in the report.
- [ ] Rankings are multi-axis or caveated. A single overall rank is not
      released without a documented aggregation policy.
- [ ] Report text avoids thesis-ready or claim-registry wording unless the
      separate claim-registration lane has already approved it.
- [ ] Dataset license, redistribution status, public/private cache status, and
      citation requirements are stated before publication.

## Publish Stop Conditions

Stop the release and open a fix task if any condition is true.

- [ ] A public number cannot be traced to a frozen artifact and commit.
- [ ] A split cannot prove separation between calibration, tuning, and blind
      evaluation.
- [ ] A source-ledger row is missing for external comparison language.
- [ ] A public comparison depends on an unknown metric, split, unit, dataset
      variant, or preprocessing step.
- [ ] A report hides failed or invalid runs that affect interpretation.
- [ ] A release would require editing thesis files, manuscript files, claim
      registries, `claims/registry.yaml`, `claim_55`, or the scientific
      roadmap.

## Release Sign-Off Record

Each public release should include a short sign-off record with these fields:

| Field | Required content |
|---|---|
| `release_id` | Snapshot, tag, branch, or candidate identifier. |
| `bsebench_commit` | Frozen commit SHA. |
| `protocol_version` | Benchmark protocol or schema version. |
| `split_manifest` | Path and hash or explicit gap. |
| `dataset_cards` | Paths and versions or explicit gaps. |
| `source_ledger` | Path, review status, and retrieval-date coverage. |
| `anti_leakage_review` | Reviewer or command, timestamp, and pass/fail status. |
| `replay_command` | Exact command or release-blocking gap. |
| `known_caveats` | Comparability, licensing, missingness, or compute caveats. |
| `publish_decision` | `release`, `release_with_caveats`, or `blocked`. |
