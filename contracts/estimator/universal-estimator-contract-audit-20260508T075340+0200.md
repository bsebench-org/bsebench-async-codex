# Universal Estimator Contract Audit

Branch: `phase-8-11-g-estimator-contract-audit-20260508T075340+0200`
Owned file: `contracts/estimator/universal-estimator-contract-audit-20260508T075340+0200.md`

## Objective

Audit the desired universal estimator interface contract for BSEBench and
identify code/API requirements that let SOC/SOH filters, ECM-based methods, AI
observers, hybrid estimators, and safety checks run through the same
plug-and-play benchmark path.

This audit is limited to local documentation and repository state inspected in
this checkout. It does not claim implementation status in external runner,
datasets, filters, thesis, manuscript, or claim-registry repositories.

## Inputs Inspected

- `README.md`: confirms this repository is the async dispatch protocol, not the
  runner implementation repository.
- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`: defines the
  universal benchmark objective, plug-and-play estimator contract, decoupling
  needs, metric axes, leakage guards, degraded initialization, and public
  benchmark workflow.
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`: defines the parallel
  universal benchmark work plan, including estimator plugin contract, protocol
  registry, degraded initialization, leakage split guard, compute profiling,
  submission smoke path, ETL contract, and monthly snapshot requirements.
- Branch refs inspected locally: `phase-8-11-g-estimator-contract-audit-20260508T075340+0200`
  and `origin/main`.

## Contract Decision Summary

The universal estimator contract should be a streaming interface centered on a
single time-step call, with lifecycle hooks and structured metadata around it.
The minimal path should support simple SOC filters without forcing them to
implement SOH, training, ECM fitting, uncertainty, or AI-specific features.
Those richer capabilities should be optional and discoverable through declared
metadata.

The contract should separate five roles:

- dataset adapter: owns raw-to-harmonized `voltage`, `current`, `temperature`,
  `dt`, SOC reference, SOH reference when available, provenance, and split
  metadata;
- estimator adapter: owns stateful inference and exposes declared outputs;
- ECM definition or parameter provider: owns model identity and calibrated
  parameter provenance, but is not allowed to blur calibration data with blind
  evaluation data;
- protocol registry: owns initialization policy, noise policy, drift policy,
  calibration/evaluation split selection, and metrics requested for a run;
- runner: owns orchestration, validation, timing, memory hooks when available,
  invalid-output handling, and report materialization.

This separation is required for plug-and-play behavior: a contributor should be
able to submit an estimator adapter or ECM definition without editing dataset
loaders, split handling, metrics, or report code.

## Proposed API Requirements

### Core Types

Use structured inputs and outputs instead of positional scalars as the durable
contract. A positional `step(voltage, current, temperature, dt)` helper can
exist as a convenience wrapper, but the benchmark should call a structured API
to make extension safe.

Required input fields per step:

- `voltage_v`: measured terminal voltage in volts.
- `current_a`: measured current in amperes, with a documented sign convention
  supplied by the dataset adapter.
- `temperature_c`: measured or imputed cell temperature in Celsius.
- `dt_s`: elapsed time in seconds.
- `t_s`: optional absolute or run-relative timestamp when available.
- `sample_id`: optional stable row/sample identity for traceability.

Required output fields per step:

- `soc`: estimated SOC as a bounded numeric value on a declared scale,
  preferably `0.0` to `1.0`.
- `status`: one of a small controlled set such as `ok`, `warming_up`,
  `invalid_input`, `invalid_output`, `diverged`, or `unsupported`.

Optional output fields:

- `soh`: estimated SOH when the method supports it.
- `voltage_pred_v`: model-predicted terminal voltage for residual metrics.
- `residual_v`: voltage residual if computed by the estimator.
- `uncertainty`: structured covariance, interval, ensemble spread, or calibrated
  uncertainty metadata when available.
- `internal_state`: optional debug payload gated behind a report/debug flag so
  normal benchmark output does not depend on private method internals.
- `warnings`: machine-readable warning codes, not free-text-only diagnostics.

### Lifecycle Hooks

Required:

- `reset(initial_state, context)`: reset estimator state before a run. The
  `initial_state` must allow forced wrong initial SOC protocols.
- `step(input) -> output`: consume one harmonized sample and return one
  estimate.
- `metadata()`: return adapter identity, version, declared capabilities, output
  scales, required input fields, training/calibration needs, deterministic
  status, and declared dependencies.

Optional:

- `fit(calibration_split, context)`: calibrate hyperparameters or model
  parameters only on allowed calibration data.
- `load_artifacts(path_or_manifest)`: load frozen trained models, ECM
  parameters, or normalization statistics through explicit manifests.
- `export_state()`: return resumable state for long runs or debugging.
- `close()`: release resources for GPU/session-backed AI observers.

### Capability Metadata

Every adapter should declare capabilities before a run:

- estimates `soc`, `soh`, voltage prediction, uncertainty, or residuals;
- requires ECM parameters, open-circuit-voltage tables, learned artifacts, or
  online training;
- supports variable `dt`, missing temperature, batched stepping, deterministic
  replay, and reset to arbitrary SOC;
- compatible chemistry/profile/temperature limits if the method explicitly has
  such limits;
- compute expectations such as CPU-only, GPU optional, memory notes, and
  approximate per-step state size when known.

The runner should treat undeclared capabilities as unavailable. It should not
infer SOH support, uncertainty validity, or cross-domain support from class
names.

## Plug-and-Play Requirements by Method Family

### SOC/SOH Filters

Kalman, Hinf, particle, moving-horizon, and related filters need a common
stateful stepping path. The API must allow wrong initial SOC, parameterized
process/measurement noise, and convergence metrics without requiring each
filter to own metric code.

Requirements:

- resettable state, including explicit initial SOC and optional initial
  covariance;
- optional voltage prediction and residual outputs;
- explicit handling of divergence, non-finite state, and covariance failures;
- declared tuning/calibration inputs so split guards can enforce anti-leakage.

### ECM-Based Methods

ECM definitions must be separable from estimator adapters. A benchmark should
be able to evaluate the same estimator with different ECM identities where the
method supports that.

Requirements:

- stable ECM identity and parameter manifest fields;
- parameter provenance including dataset, cell, profile, temperature, and split
  role used for identification;
- no hidden fallback to repository-relative calibration files;
- explicit behavior when required ECM parameters are absent or incompatible
  with the protocol.

### AI Observers and Hybrid Estimators

AI observers need artifact and preprocessing contracts that are stricter than a
plain Python class name. The runner must know what was trained, loaded, and
frozen before blind evaluation.

Requirements:

- explicit model artifact manifest and checksum when available;
- normalization/preprocessing identity and input field order;
- training data and calibration split declaration;
- deterministic replay declaration, including random seeds and device notes
  when applicable;
- unsupported-domain reporting instead of silently extrapolating through an
  adapter that cannot declare its limits.

### Safety Constraints

Safety behavior should be part of the runner contract, not left to each method
to report inconsistently.

Requirements:

- hard rejection or flagged invalid output for non-finite SOC/SOH values;
- configurable bound policy for SOC and SOH, distinguishing clipped estimates
  from naturally bounded estimates;
- MAXE and per-sample worst-error trace support because maximum error is
  safety-relevant in the inspected charter;
- degraded-initialization recovery metrics for intentionally wrong initial SOC;
- measurement noise and ECM drift protocol hooks;
- invalid-output counts included in reports and comparability caveats;
- per-step timing hook and optional memory hook around estimator stepping.

## Runner/API Acceptance Checklist

- A toy SOC-only estimator can run by implementing `reset`, `step`, and
  `metadata`.
- A SOC/SOH estimator can expose SOH without changing metric or report code.
- An ECM-backed estimator can declare required ECM parameters and fail with a
  controlled `unsupported` status if they are missing.
- A learned observer can load frozen artifacts from an explicit manifest and
  declare training/calibration provenance.
- The runner can force an intentionally wrong initial SOC through `reset`.
- The runner can separate calibration, training/tuning, and blind evaluation
  splits without trusting estimator code to self-police leakage.
- The runner records invalid outputs, clipped outputs, warnings, timing, and
  declared capabilities in machine-readable results.
- Reports can state missing data and invalid comparability cases without making
  unsupported SOTA, novelty, breakthrough, or verified-claim statements.

## Validation Checklist for This Audit

- Only the owned report path was created or modified.
- Protected files were not edited.
- The audit cites only local files and branch refs inspected in this checkout.
- The audit does not claim implementation, benchmark results, SOTA, novelty,
  breakthrough status, or leaderboard status.
- The audit uses ASCII text only.
- `git diff --check` must pass before commit.

## Residual Risks

- This async repository does not contain the runner package, estimator classes,
  dataset adapters, or existing benchmark schemas, so this audit cannot verify
  whether current code already satisfies any requirement.
- The current audit does not define final Python type names, JSON schemas, or
  backward-compatibility migration steps; those should be finalized in the
  runner repository where the implementation lives.
- Current sign convention, SOC scale, SOH scale, and artifact-manifest details
  need alignment with dataset and runner code before they become normative.
- Compute profiling may require platform-specific handling; the contract should
  start with per-step timing and make memory/FLOP metadata optional until
  reproducible collection is available.

## Next Concrete Task

In the runner repository, create a minimal estimator plugin contract smoke path
with structured `StepInput`, `StepOutput`, lifecycle hooks, capability metadata,
and one toy SOC-only adapter fixture. The smoke test should verify degraded
initialization, invalid-output accounting, and split-role metadata without
requiring any real dataset download.
