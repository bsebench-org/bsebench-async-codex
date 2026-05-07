# Community Alpha Onboarding Map

Saved: 2026-05-07. Scope: operational map for a BSEBench community alpha
contributor flow, from dataset intake through estimator submission, blind run,
metrics, report, and appeal/review.

This document is a readiness map, not a scientific result. It does not assert
method quality or public rank. Unknown or unmerged implementation details are
marked as `unknown` or `blocked`.

## Local References Used

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`: universal
  benchmark objective, estimator contract direction, metric axes, anti-leakage
  guards, and community workflow.
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`: active universal
  benchmark work items across runner, stats, datasets, and async/public
  operations.
- `templates/freelance-dev-template.md`: contributor/worker brief discipline,
  acceptance criteria style, verification command listing, and GLASSBOX
  reporting expectations.
- `templates/merge-validate-template.md`: merge validation pattern and gate
  evidence style.
- `docs/PROTOCOL.md`: GLASSBOX commit metadata format and no Claude
  co-authoring rule.

Missing local artifacts:

- `specs/` directory: blocked. No local specs directory exists in this
  worktree.
- Final W5/W7/W8 integration artifacts: unknown. They were described as in
  progress or mostly validated, but are not merged into this worktree.
- Runner, stats, and datasets repository alpha schemas: unknown from this
  worktree. This map references expected interfaces from the charter and wave
  plan without claiming implementation status.

## Status Vocabulary

- `ready`: the gate can run with artifacts currently known to this worktree.
- `pending`: the gate is defined, but the implementation is expected from an
  integration branch or another repository.
- `blocked`: required artifact or policy is missing.
- `unknown`: not inspectable from this owned write-set.
- `not_applicable`: the submission does not need that step.

Every public alpha record should use these exact statuses instead of prose-only
exceptions.

## Alpha Actor Model

| Actor | Responsibility | Must not do |
|---|---|---|
| Dataset contributor | Provide dataset card inputs, provenance, license terms, raw or harmonized data access, ground-truth method notes, and contact route. | Choose evaluation splits, edit metric code, or see hidden evaluation outputs before report release. |
| Estimator contributor | Provide adapter package, method metadata, dependency lock, resource expectations, and allowed calibration/training inputs. | Edit dataset loaders, split logic, metric code, report code, or hidden evaluation data. |
| Intake maintainer | Check completeness, license constraints, provenance, schema fit, and missing fields. | Make scientific claims or change submitted evidence without an audit note. |
| Benchmark operator | Freeze manifests, run preflight, execute blind protocols, record logs, and generate mechanical reports. | Tune a contributor method during hidden evaluation or selectively suppress failed cases. |
| Reviewer | Check procedural correctness, reproducibility evidence, caveats, and appeal requests. | Reinterpret results as scientific proof without the separate research gate. |

## End-to-End Flow

### 1. Dataset Intake

Purpose: turn a contributed battery dataset into an auditable candidate for
BSEBench protocols without requiring estimator authors to write loaders.

Contributor package:

- `DATASET_CARD.md`: dataset title, contributor, contact, license, allowed
  public/private use, citation preference, equipment vendor, chemistry,
  nominal capacity, temperature coverage, profile names, aging/SOH coverage,
  cell identifiers, and known caveats.
- `PROVENANCE.json`: raw file inventory, file hashes when shareable,
  equipment/software export notes, acquisition date range if allowed, and
  transformation history.
- `GROUND_TRUTH.md`: SOC/SOH reference method, coulomb-counting notes, OCV rest
  recalibration notes when available, known reset points, and uncertainty notes.
- `ACCESS.md`: raw data location, access restrictions, redistribution terms,
  and whether blind public reports may include per-cell/profile identifiers.
- `HARMONIZED_SAMPLE.csv` or equivalent sample: demonstrates expected `V`,
  `I`, `T`, `dt`, SOC/SOH fields when redistribution allows.

Intake gates:

| Gate | Check | Output status |
|---|---|---|
| License gate | Confirms benchmark use, redistribution limits, and reporting permissions. | `ready`, `blocked`, or `unknown` |
| Provenance gate | Confirms raw inventory and hash/cache identity are present or explicitly unavailable. | `ready`, `blocked`, or `unknown` |
| Ground-truth gate | Records how SOC/SOH labels were produced and where uncertainty remains. | `ready`, `pending`, or `blocked` |
| Harmonization gate | Maps data to synchronized `V`, `I`, `T`, `dt`, and label fields. | `ready`, `pending`, or `blocked` |
| Split-separation gate | Records calibration/training/evaluation separation policy. | `ready`, `pending`, or `blocked` |

Dataset intake outputs:

- `dataset_id`: stable identifier assigned by maintainers.
- `dataset_card_status`: status vocabulary above.
- `cache_identity`: hash or manifest pointer; `unknown` if not inspectable.
- `allowed_protocols`: list of protocols that can use the dataset.
- `blocked_protocols`: list with reasons, such as missing temperature, missing
  SOC label, license restriction, or absent aging metadata.

Current readiness from this worktree:

- Dataset card schema: pending, because the wave plan names it but no merged
  schema is inspectable here.
- Equipment registry: pending, because the wave plan names it but no merged
  registry is inspectable here.
- Ground-truth audit schema: pending, because the wave plan names it but no
  merged schema is inspectable here.
- Dataset availability snapshot: pending, because the wave plan names it but no
  merged schema is inspectable here.

### 2. Estimator Submission

Purpose: let a contributor submit a method adapter without touching data
loading, split handling, metrics, or report generation.

Contributor package:

- `SUBMISSION.md`: method name, submitter, contact, license, allowed public
  report name, intended SOC/SOH outputs, and any required calibration/training
  stage.
- `adapter/`: package implementing the runner estimator interface. The charter
  gives the target minimal shape as `step(voltage, current, temperature, dt) ->
  estimated_soc`, with optional reset, metadata, initialization, and SOH hooks.
- `dependencies.lock` or container recipe: exact runtime dependencies.
- `METADATA.json`: deterministic seed policy, hardware assumptions, runtime
  expectations, memory expectations, supported chemistry/profile limits, and
  invalid-output behavior.
- `CALIBRATION_POLICY.md`: what inputs the method may use before hidden
  evaluation. This must distinguish parameter identification, training/tuning,
  and blind inference.
- `SMOKE_EXPECTED.md`: expected behavior on a toy public smoke dataset, without
  using hidden evaluation data.

Submission gates:

| Gate | Check | Output status |
|---|---|---|
| Adapter API gate | Confirms required functions and output shape. | `ready`, `pending`, or `blocked` |
| Isolation gate | Confirms submission does not edit loaders, split logic, metrics, or report code. | `ready` or `blocked` |
| Dependency gate | Confirms dependencies are pinned or containerized. | `ready`, `pending`, or `blocked` |
| Metadata gate | Confirms method identity, resource expectations, and invalid-output behavior are declared. | `ready`, `pending`, or `blocked` |
| Calibration gate | Confirms allowed pre-evaluation inputs are explicit. | `ready`, `pending`, or `blocked` |
| Smoke gate | Runs a public toy protocol and records logs. | `ready`, `pending`, or `blocked` |

Estimator submission outputs:

- `submission_id`: stable alpha submission identifier.
- `adapter_status`: status vocabulary above.
- `smoke_run_id`: public smoke execution record, if available.
- `calibration_scope`: declared allowed inputs for pre-evaluation setup.
- `blocked_axes`: protocol axes excluded before blind evaluation.

Current readiness from this worktree:

- Estimator plugin contract: pending, because the wave plan names the runner
  contract but no merged runner implementation is inspectable here.
- Submission template: pending, because the wave plan names an async submission
  template but no merged template is inspectable here.
- Toy external estimator smoke path: pending, because the wave plan names it
  but no merged runner path is inspectable here.

### 3. Preflight and Freeze

Purpose: freeze all inputs before hidden evaluation and catch mechanical
failures early.

Preflight inputs:

- `dataset_id` and dataset manifest.
- `submission_id` and adapter package.
- Protocol manifest: selected chemistry/profile/temperature/aging axes.
- Calibration policy and allowed training/tuning material.
- Runtime policy: timeout, memory limit, hardware tag, and logging policy.

Required freeze records:

- `manifest_frozen_at`: timestamp.
- `dataset_manifest_hash`: hash or `unknown`.
- `submission_manifest_hash`: hash or `unknown`.
- `protocol_manifest_hash`: hash or `unknown`.
- `operator`: benchmark operator identity.
- `preflight_gate_results`: machine-readable gate table.

Preflight gates:

| Gate | Check | Output status |
|---|---|---|
| Manifest freeze | Confirms dataset, submission, and protocol manifests are immutable for the run. | `ready`, `pending`, or `blocked` |
| Split-leakage check | Confirms hidden evaluation data is not exposed to calibration/training. | `ready`, `pending`, or `blocked` |
| Determinism check | Repeats smoke run if deterministic behavior is required. | `ready`, `not_applicable`, or `blocked` |
| Resource check | Confirms declared runtime/memory limits are executable on available hardware. | `ready`, `pending`, or `blocked` |
| Caveat register | Creates empty caveat list before execution; failures append to it. | `ready` or `blocked` |

Current readiness from this worktree:

- Split guard fixtures: pending, because the wave plan names runner and dataset
  split metadata work but no merged artifact is inspectable here.
- Protocol registry: pending, because the wave plan names it but no merged
  runner registry is inspectable here.
- Charter gate for new BRIEFs: pending, because the wave plan names it but no
  merged async gate is inspectable here.

### 4. Blind Run

Purpose: execute the frozen estimator against hidden evaluation protocols and
record enough information to audit the procedure without exposing hidden data
early.

Blind run rules:

- Evaluation splits are selected only from frozen manifests.
- Calibration/training inputs must match `CALIBRATION_POLICY.md`.
- The operator may restart a failed infrastructure run, but must preserve the
  failed attempt log and reason.
- The operator must not tune estimator code, change hyperparameters, or add
  dataset-specific workarounds during hidden evaluation.
- Invalid outputs, timeouts, and crashes are recorded as outcomes, not silently
  removed.

Run record fields:

- `run_id`
- `dataset_id`
- `submission_id`
- `protocol_id`
- `manifest_hashes`
- `hardware_tag`
- `started_at` and `finished_at`
- `exit_status`
- `attempt_count`
- `prediction_artifact_hash`
- `operator_log_hash`
- `caveats`

Blind run gates:

| Gate | Check | Output status |
|---|---|---|
| Hidden split integrity | Confirms hidden labels were not exposed to estimator code. | `ready`, `pending`, or `blocked` |
| Runtime capture | Records timing and memory metadata when hooks exist. | `ready`, `pending`, `not_applicable`, or `blocked` |
| Invalid-output capture | Records NaN, out-of-range SOC/SOH, crash, and timeout behavior. | `ready`, `pending`, or `blocked` |
| Attempt log | Preserves every attempt and restart reason. | `ready` or `blocked` |

Current readiness from this worktree:

- Compute profiling hooks: pending, because the wave plan names them but no
  merged runner implementation is inspectable here.
- Blind-run runner entrypoint: unknown, because runner repository state is
  outside this owned write-set.

### 5. Metrics

Purpose: compute mechanical outputs over frozen predictions, labels, masks, and
run metadata.

Required metric families from the universal charter:

- Accuracy: RMSE, MAE, MAXE, and per-cell/profile distributions.
- Reliability: convergence speed after wrong initial SOC, robustness under
  Gaussian and non-Gaussian measurement noise, ECM drift behavior, invalid
  output handling, and stability flags where implemented.
- Computational cost: execution time per iteration, memory footprint when
  practical, and hardware-independent cost metadata when practical.
- Generalization: chemistry, profile, temperature, aging/SOH, and transfer-axis
  summaries when the dataset and protocol support them.

Metrics gates:

| Gate | Check | Output status |
|---|---|---|
| Prediction-label alignment | Confirms predictions align to label timestamps and masks. | `ready`, `pending`, or `blocked` |
| Metric schema | Confirms metric names, units, aggregation levels, and invalid cases are machine-readable. | `ready`, `pending`, or `blocked` |
| Caveat propagation | Confirms missing axes, invalid cases, and non-comparable cases are carried forward. | `ready`, `pending`, or `blocked` |
| Recompute check | Recomputes a deterministic subset or marks why recompute is unavailable. | `ready`, `not_applicable`, or `blocked` |

Metrics outputs:

- `metrics.json`: structured metrics, caveats, masks, and status fields.
- `metrics_summary.md`: human-readable summary with no unsupported scientific
  claims.
- `non_comparable_cases.json`: cases excluded from comparison with reasons.
- `cost_metadata.json`: runtime and memory fields when available.

Current readiness from this worktree:

- Metric matrix schema: pending, because the wave plan names it but no merged
  stats schema is inspectable here.
- Convergence metrics: pending.
- Robustness noise schema: pending.
- Compute cost aggregator: pending.
- Cross-domain transfer matrix: pending.
- Multi-axis report schema: pending.

### 6. Report

Purpose: publish an alpha record that is useful to contributors and reviewers
without overstating evidence.

Report sections:

- Submission identity: contributor-approved display name, version, license, and
  adapter hash.
- Dataset and protocol identity: dataset IDs, protocol IDs, manifest hashes,
  and allowed-public fields.
- Gate table: all gates with `ready`, `pending`, `blocked`, `unknown`, or
  `not_applicable`.
- Metrics table: mechanical metric values, units, aggregation level, and
  caveats.
- Invalid and missing cases: crashes, timeouts, missing labels, license
  restrictions, unsupported axes, and non-comparable cases.
- Run evidence: run IDs, timestamps, hardware tag, operator log hash, and
  artifact hashes.
- Review window: deadline, appeal route, and allowed appeal categories.

Report restrictions:

- Do not describe a method with public-ranking or method-quality superlatives.
- Do not imply a scientific claim has been established by alpha execution.
- Do not hide failed cases from the report table.
- Do not merge report wording into thesis, manuscript, roadmap, or claim
  registry files as part of alpha operations.

Current readiness from this worktree:

- Monthly public snapshot schema: pending, because the wave plan names it but
  no merged async schema is inspectable here.
- Public release checklist: pending, because the wave plan names it but no
  merged checklist is inspectable here.

### 7. Appeal and Review

Purpose: give contributors a bounded way to challenge procedural errors while
protecting hidden data and auditability.

Appeal categories:

- `procedural_error`: wrong manifest, wrong protocol, wrong version, or
  documented operator mistake.
- `infrastructure_failure`: runner crash, environment issue, timeout policy
  error, or artifact corruption outside the estimator.
- `metadata_correction`: display name, citation, license, or caveat correction.
- `scope_dispute`: contributor believes the report included an unsupported
  dataset axis or omitted a supported axis.
- `not_accepted`: requests to tune after blind execution, remove valid failed
  cases, or reinterpret the result as a scientific claim.

Appeal package:

- `APPEAL.md`: run ID, submission ID, category, requested correction, and
  evidence.
- `ARTIFACTS.md`: relevant logs or hashes supplied by contributor.
- `CONTACT.md`: contributor contact and preferred public/private handling.

Review outcomes:

- `accepted_rerun`: rerun is allowed because procedure or infrastructure was
  faulty.
- `accepted_metadata_only`: report metadata changes, but metrics remain
  unchanged.
- `accepted_caveat_update`: report caveat changes, but metrics remain
  unchanged.
- `rejected`: no procedural error found, with reason.
- `blocked`: review cannot proceed because an artifact is missing or access is
  unavailable.

Review gates:

| Gate | Check | Output status |
|---|---|---|
| Artifact availability | Confirms run logs, manifest hashes, and report artifacts are available. | `ready`, `blocked`, or `unknown` |
| Category fit | Confirms appeal category is allowed. | `ready` or `blocked` |
| Independence | Reviewer was not the sole operator of the appealed run when possible. | `ready`, `pending`, or `unknown` |
| Decision record | Writes a review outcome with reasons and artifact references. | `ready` or `blocked` |

## Minimal Alpha Packet

For an initial community alpha, the smallest useful packet is:

- `DATASET_CARD.md`
- `PROVENANCE.json`
- `GROUND_TRUTH.md`
- `ACCESS.md`
- `SUBMISSION.md`
- `METADATA.json`
- `CALIBRATION_POLICY.md`
- Adapter package implementing the runner contract when available.
- Dependency lock or container recipe.
- Preflight gate table.
- Blind run record.
- `metrics.json`
- Human-readable report.
- Appeal/review record template.

If any item is unavailable, the packet remains usable only if the item is
explicitly marked `blocked`, `unknown`, or `not_applicable` with a reason.

## Alpha Readiness Checklist

- [ ] Dataset contributor can submit required metadata without editing runner,
  stats, or dataset code.
- [ ] Estimator contributor can submit an adapter without editing dataset
  loading, split handling, metrics, or report code.
- [ ] Maintainer can freeze dataset, submission, and protocol manifests before
  hidden evaluation.
- [ ] Blind run can execute with hidden split integrity and attempt logging.
- [ ] Metrics can be computed from frozen prediction artifacts with caveats.
- [ ] Report can publish gate statuses, metrics, caveats, and artifact hashes
  without unsupported scientific wording.
- [ ] Appeal/review can distinguish procedural correction from post-run tuning.

Current checklist state from this worktree: pending or unknown for most items
because named W5/W7/W8 and runner/stats/datasets artifacts are not merged or
inspectable here.

## Open Blockers

| Blocker | Impact | Current status |
|---|---|---|
| No local `specs/` directory | Cannot cite formal alpha packet schema from this worktree. | blocked |
| W5 integration not merged here | Current runner/stats/datasets contracts may differ from this map. | unknown |
| W7 alpha readiness artifacts not merged here | Submission template, release checklist, and review templates may already exist elsewhere. | unknown |
| W8 validation reports not merged here | Cannot cite current validation results for integration branches. | unknown |
| Runner repository not in owned write-set | Cannot confirm blind-run entrypoint, adapter contract, or telemetry hooks. | unknown |
| Stats repository not in owned write-set | Cannot confirm metrics schema or aggregation outputs. | unknown |
| Datasets repository not in owned write-set | Cannot confirm dataset card, provenance, split, or equipment schemas. | unknown |

## Suggested Next Artifacts

These are operational artifacts, not scientific claims:

- Alpha `DATASET_CARD.md` template aligned to the dataset intake table.
- Alpha `SUBMISSION.md` template aligned to the estimator submission table.
- Machine-readable gate table schema using the status vocabulary in this file.
- Blind-run record schema with manifest hashes and attempt logging.
- Metrics/report caveat schema that carries missing and non-comparable cases.
- Appeal/review template with the allowed categories and outcomes above.
