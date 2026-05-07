# BSEBench universal contributor submission template

> Copy this template into the submission package and replace every
> angle-bracket placeholder. Use `unknown` only when a field is genuinely not
> known, and explain the caveat in the relevant section. Do not include SOTA,
> novelty, leaderboard, breakthrough, or verified-claim statements unless a
> completed source ledger is attached.

## Submission metadata

| Field | Value |
|---|---|
| Submission ID | `<stable-slug>` |
| Submission type | `<estimator_adapter | ecm_definition | observer | ai_estimator | hybrid_method | report_only>` |
| Method family | `<ECM | Kalman filter | observer | AI estimator | hybrid | other>` |
| Maintainer | `<name, affiliation, contact>` |
| License | `<SPDX identifier or redistribution terms>` |
| Code URL or archive | `<stable URL, release tag, or package path>` |
| Submission commit or artifact hash | `<git SHA, release digest, or archive checksum>` |
| BSEBench version | `<commit SHA, tag, or frozen benchmark release>` |
| Expected entry point | `<module:function, class, executable, or adapter path>` |
| Runtime environment | `<language, package manager, OS assumptions, accelerator assumptions>` |
| Hardware used for timing claims | `<CPU/GPU/RAM, or n/a if no timing claim is made>` |

## Method scope

- Intended output: `<SOC | SOH | SOC+SOH | other state>`.
- Required inputs: `<voltage, current, temperature, dt, metadata, other>`.
- Optional inputs: `<cell metadata, ECM parameters, training artifacts, other>`.
- Unsupported regimes: `<chemistry, temperature, profile, aging state, or other known limits>`.
- Failure behavior: `<NaN, clipped output, exception, diagnostic flag, fallback mode>`.

## Adapter contract

Fill this section for executable estimator submissions.

- Initialization hook: `<how BSEBench creates or resets the estimator>`.
- Step hook: `<function signature or command contract>`.
- State reset behavior: `<per cell, per profile, per split, or stateless>`.
- Output schema: `<fields, units, bounds, invalid-output markers>`.
- Determinism policy: `<fixed seed, stochastic with seed, nondeterministic caveat>`.
- External services: `<none, or exact service plus offline fallback>`.

Minimum expected behavior:

- The adapter must not load evaluation targets, future samples, or hidden split
  metadata during inference.
- The adapter must keep calibration, training, tuning, and evaluation data
  separated.
- The adapter must emit invalid or missing estimates explicitly rather than
  silently reusing ground truth or prior benchmark outputs.

## Data and split declaration

| Use | Dataset/profile/cell scope | Purpose | Tuning allowed? | Evidence path |
|---|---|---|---|---|
| Calibration | `<dataset/profile/cell>` | `<ECM fit, OCV table, normalization, other>` | `<yes/no>` | `<file or URL>` |
| Training | `<dataset/profile/cell>` | `<model fit, feature learning, other>` | `<yes/no>` | `<file or URL>` |
| Validation | `<dataset/profile/cell>` | `<hyperparameter choice, early stopping, other>` | `<yes/no>` | `<file or URL>` |
| Evaluation | `<dataset/profile/cell>` | `<blind benchmark run>` | `no` | `<file or URL>` |

Leakage statement:

- Evaluation data used during development: `<no | yes with exact explanation>`.
- Any public benchmark labels used for tuning: `<no | yes with exact explanation>`.
- Any preprocessing fitted on evaluation data: `<no | yes with exact explanation>`.
- Any repeated submissions used to choose hyperparameters: `<no | yes with exact explanation>`.

## Provenance artifacts

Attach or reference these artifacts when applicable.

- Source code archive or immutable commit.
- Dependency lockfile or environment export.
- Training or calibration manifest.
- Dataset identifiers, cache hashes, and download provenance.
- ECM parameter source, fitting script, or paper source.
- Random seed manifest and number of repeated runs.
- Hardware and runtime measurement log.
- Generated report bundle and raw metric table, if results are included.

## Metrics requested

Select only metrics that the submission is prepared to report or let BSEBench
compute mechanically.

- [ ] SOC RMSE.
- [ ] SOC MAE.
- [ ] SOC maximum absolute error.
- [ ] SOH error metric: `<exact metric and units>`.
- [ ] Convergence or recovery metric under degraded initialization.
- [ ] Robustness metric under injected measurement noise.
- [ ] Runtime per step or per profile.
- [ ] Memory or deployment-cost metadata.
- [ ] Cross-domain transfer matrix entry.
- [ ] Other: `<metric, units, and why it is comparable>`.

## Comparison source ledger

Required for any comparison against prior work or public results. If no
comparison is being made, write `No comparison requested`.

| source_id | title | DOI or stable URL | retrieved_at | metric | dataset | split | reported_value | bsebench_value | comparability | caveat |
|---|---|---|---|---|---|---|---|---|---|---|
| `<id>` | `<title>` | `<doi_or_url>` | `<YYYY-MM-DD>` | `<metric+units>` | `<dataset/profile>` | `<split/protocol>` | `<value+location>` | `<frozen value>` | `<comparable | partial | not_comparable>` | `<required caveat>` |

Comparison rules:

- Do not infer missing values from memory.
- Mark the row `partial` or `not_comparable` when dataset, split, metric,
  preprocessing, or horizon differ.
- Keep comparison text descriptive until the source ledger is complete and
  reviewer-accepted.

## Reproduction commands

Provide commands that a reviewer can run without modifying benchmark internals.

```bash
# Install or restore environment
<command>

# Run the smallest submission smoke check
<command>

# Run the requested benchmark protocol or dry run
<command>

# Export the report bundle or metric table
<command>
```

## Contributor checklist

- [ ] All placeholders are resolved or explicitly marked with a caveat.
- [ ] The adapter can be invoked without editing dataset loaders, metric code,
  split logic, or report generation.
- [ ] Calibration, training, validation, and evaluation data are declared
  separately.
- [ ] Evaluation data is not used for tuning, preprocessing fit, or early
  stopping unless the submission is marked non-blind and non-comparable.
- [ ] Provenance artifacts identify code, dependencies, dataset cache identity,
  seeds, and generated outputs.
- [ ] Unsupported regimes and failure behavior are documented.
- [ ] Any comparison text has a complete source-ledger row with DOI or stable
  URL, retrieval date, exact metric, dataset, split, frozen BSEBench value, and
  comparability caveat.
- [ ] No unsupported SOTA, novelty, leaderboard, breakthrough, or verified
  claim language remains in the submission.
- [ ] The maintainer accepts that public benchmark reports may mark results as
  `invalid`, `partial`, or `not_comparable` when validation gates fail.
