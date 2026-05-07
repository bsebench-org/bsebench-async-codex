---
GLASSBOX:
  worker: W5-15
  role: integration-contract-ledger
  artifact: cross-repo-api-contract-ledger
  created_utc: 2026-05-07T21:31:25Z
  branch: phase-8-4-o-cross-repo-api-contract-ledger-20260507T213125Z
  owned_write_set: ledgers/contracts/cross-repo-api-contract-ledger-20260507T213125Z.md
  mode: read-only inspection plus ledger creation
---

# Cross-Repo API Contract Ledger

This ledger maps the runner, stats, and datasets contract surfaces that must
agree before the universal SOC/SOH benchmark branches enter an integration
queue. It records branch heads, owners, schema names, validation commands, and
known mismatches. It does not merge code branches, publish benchmark results,
rank methods, or make any scientific, novelty, SOTA, leaderboard, or verified
claim.

## Scope

Target repos inspected:

- `bsebench-runner`
- `bsebench-stats`
- `bsebench-datasets`
- this CTO report repo for Wave 2 to Wave 5 validation, audit, and schema
  artifacts

Write scope: this ledger only.

Integration validator heads for Wave 5 were checked after `git fetch origin
--prune` and repeated `git ls-remote --heads origin 'phase-8-4-*'` polling. The
runner, stats, and datasets Wave 5 validator refs became available during this
ledger task, so this ledger records both the Wave 1 source branch heads and the
available Wave 5 integration heads. Runner integration had focused remote
validation evidence. Stats and datasets integration branches were pushed after
their validator artifacts initially recorded pending states; this ledger
therefore records their pushed heads and `git diff --check` inspection, but not
an independent focused test pass.

## Branch Head Evidence

### Runner

Source repo: `/mnt/c/doctorat/bsebench-org/bsebench-runner`

| ID | Branch | Local head | Remote head | Integration status |
| --- | --- | ---: | ---: | --- |
| R1 | `phase-8-0-a-universal-runner-estimator-plugin-contract` | `7f590c2` | `7f590c2` | Candidate, validated |
| R2 | `phase-8-0-b-universal-runner-protocol-registry` | `acf95fa` | `acf95fa` | Candidate, validated |
| R3 | `phase-8-0-c-universal-runner-degraded-initialization` | `944a152` | `944a152` | Candidate, validated |
| R4 | `phase-8-0-d-universal-runner-leakage-split-guard` | `5d8efab` | `5d8efab` | Candidate, validated |
| R5 | `phase-8-0-e-universal-runner-compute-profiling-hooks` | `2006dff` | `2006dff` | Candidate, validated |
| R6 | `phase-8-0-f-universal-runner-submission-smoke` | `ce792f3` | `ce792f3` | Candidate, validated |

Wave 4 validation artifact:
`validation/wave-4/runner-wave1-deep-validation-20260507T204627Z.md` on
`phase-8-3-d-runner-wave1-deep-validation-20260507T204627Z` at `d41a3f6`.
It reported clean local/remote heads and a temporary R1-R6 integration replay:
`43 passed in 3.58s`.

### Stats

Source repo: `/mnt/c/doctorat/bsebench-org/bsebench-stats`

| ID | Branch | Local head | Remote head | Integration status |
| --- | --- | ---: | ---: | --- |
| S1 | `phase-8-0-g-universal-stats-metric-matrix` | `646bf3c` | `646bf3c` | Candidate, validated |
| S2 | `phase-8-0-h-universal-stats-convergence-metrics` | `eddb345` | `eddb345` | Candidate, validated |
| S3 | `phase-8-0-i-universal-stats-robustness-noise-schema` | `0d7e275` | `0d7e275` | Candidate, validated |
| S4 | `phase-8-0-j-universal-stats-compute-cost-aggregator` | `f11a151` | `f11a151` | Candidate, validated |
| S5 | `phase-8-0-k-universal-stats-multi-axis-ranking` | `f42e0a0` | `f42e0a0` | Candidate, validated, local upstream caveat |
| S6 | `phase-8-0-l-universal-stats-transfer-matrix` | `59dfd52` | `59dfd52` | Candidate, validated |

Wave 4 validation artifact:
`validation/wave-4/stats-wave1-deep-validation-20260507T204627Z.md` on
`phase-8-3-e-stats-wave1-deep-validation-20260507T204627Z` at `dbe9e57`.
It reported focused replay pass for S1-S6, with isolated `uv` replay required
for S2 and S5 due stale local virtual environments.

### Datasets

Source repo: `/mnt/c/doctorat/bsebench-org/bsebench-datasets`

| ID | Branch | Local head | Remote head | Integration status |
| --- | --- | ---: | ---: | --- |
| D1 | `phase-8-0-m-universal-datasets-etl-contract` | `6b6bab2` | `6b6bab2` | Candidate, validated |
| D2 | `phase-8-0-n-universal-datasets-ground-truth-audit` | `a52c81d` | `a52c81d` | Candidate, validated |
| D3 | `phase-8-0-o-universal-datasets-split-metadata` | `2f0caba` | `2f0caba` | Candidate, validated |
| D4 | `phase-8-0-p-universal-datasets-card-schema` | `e5f2305` | `e5f2305` | Candidate, validated |
| D5 | `phase-8-0-q-universal-datasets-equipment-registry` | `96566f9` | `96566f9` | Candidate, validated |
| D6 | `phase-8-0-r-universal-datasets-monthly-availability` | `c1af5d0` | `c1af5d0` | Candidate, validated |

Wave 4 validation artifact:
`validation/wave-4/datasets-wave1-deep-validation-20260507T204627Z.md` on
`phase-8-3-f-datasets-wave1-deep-validation-20260507T204627Z` at `ab2a3f2`.
It reported D1-D6 as `PASS WITH CAUTIONS`, including the D3 isolated-UV replay
caveat.

### Wave 5 Integration Heads

| Repo | Integration branch | Pushed head | Validator artifact | Validator status |
| --- | --- | ---: | --- | --- |
| Runner | `phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z` | `e0664de` | `origin/phase-8-4-e-runner-integration-validator-20260507T213125Z` at `f839fd8` | `PASS_FOCUSED_REMOTE_VALIDATION`; `43 passed` focused gate reported by W5-05 |
| Stats | `phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` | `08d7c2c` | `origin/phase-8-4-f-stats-integration-validator-20260507T213125Z` at `1d905c0` | W5-06 recorded pending before this branch appeared on origin; this ledger observed pushed head and `git diff --check` pass only |
| Datasets | `phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z` | `6cbdc54` | `origin/phase-8-4-g-datasets-integration-validator-20260507T213125Z` at `082f4a2` | W5-07 recorded pending before this branch appeared on origin; this ledger observed pushed head and `git diff --check` pass only |

First-parent integration sequences observed:

- Runner: R1 through R6 are merged as explicit GLASSBOX merge commits ending at
  `e0664de`.
- Stats: S1 through S6 are merged, with a final GLASSBOX hardening commit
  `08d7c2c`.
- Datasets: D1 through D6 are merged, with a final GLASSBOX export hardening
  commit `6cbdc54`.

## Contract Ledger

### C01 Dataset Trace Contract

| Field | Value |
| --- | --- |
| Owner | Datasets D1, `bsebench-datasets` |
| Branch | `phase-8-0-m-universal-datasets-etl-contract` at `6b6bab2` |
| Primary file | `src/bsebench_datasets/etl_contract.py` |
| Schema name | `bsebench-datasets-etl-field-contract/v1` |
| Producer | Dataset ETL and loaders |
| Consumers | Runner sample loop, stats metric ingestion, monthly snapshot result rows |
| Validation | `.venv/bin/python -m pytest tests/test_etl_contract.py -q` -> `8 passed`; `git diff --check` -> pass |

Schema surface:

- Tier 2 required fields: `time_s`, `voltage_V`, `current_A`,
  `temperature_C`.
- Tier 2 optional target-only truth fields: `soc_truth`, `soh_truth`.
- Loader required fields: `t`, `V`, `I`, `T_meas`.
- Loader derived field: `dt_s`.
- Current convention bridge: Tier 2 `current_A` is charge-positive and
  discharge-negative; runner loader `I = -current_A` is discharge-positive.
- Truth fields carry `leakage_policy="target_only"` and must not be estimator
  inputs.

Integration rule: this contract must be merged before runner protocol
integration is called SOC/SOH-ready. Runner artifacts must preserve normalized
trace inputs, target-only truth separation, units, and source identity.

### C02 Estimator Step And Adapter Contract

| Field | Value |
| --- | --- |
| Owner | Runner R1, `bsebench-runner` |
| Branch | `phase-8-0-a-universal-runner-estimator-plugin-contract` at `7f590c2` |
| Primary file | `src/bsebench_runner/estimator_contract.py` |
| Schema name | `bsebench.estimator.v1` |
| Producer | External estimator adapter or internal filter wrapper |
| Consumers | Runner registry, protocol registry, submission smoke, stats through runner artifacts |
| Validation | `pytest tests/test_estimator_contract.py -q` -> `9 passed`; integrated runner replay included R1 |

Schema surface:

- `EstimatorStepInput`: `t`, `voltage_V`, `current_A`, `temperature_C`.
- `EstimatorProtocol.step(t, voltage_V, current_A, temperature_C)`.
- `EstimatorAdapter`: `name`, `factory`, `version`, `contract_version`,
  `metadata`.
- Required output key: `voltage_predicted`.
- Extra outputs, including `soc_estimated` and `soh_estimated`, are accepted
  only as finite numeric scalar fields.
- `validate_estimator_step_output` rejects missing, nonnumeric, boolean,
  nested, or non-finite values.

Integration rule: keep this as the minimal plug-in API, but do not treat it as
complete SOC/SOH scoring support until the `dt_s` mismatch and target-signal
metric binding below are resolved.

### C03 Benchmark Protocol Registry Contract

| Field | Value |
| --- | --- |
| Owner | Runner R2, `bsebench-runner` |
| Branch | `phase-8-0-b-universal-runner-protocol-registry` at `acf95fa` |
| Primary file | `src/bsebench_runner/protocol_registry.py` |
| Schema names | Pydantic models with `schema_version="1.0"` |
| Producer | Protocol author or monthly release owner |
| Consumers | Runner execution, stats ingestion, monthly snapshot artifact |
| Validation | `pytest tests/test_protocol_registry.py -q` -> `6 passed`; integrated runner replay included R2 |

Schema surface:

- `DatasetSpec`: `dataset_id`, `split_id`, `wrapper_names`,
  `leakage_scope`, `provenance`.
- `EstimatorAdapterSpec`: `adapter_id`, `estimator_family`, `entrypoint`,
  `output_signals`, `supports_training`, `training_data_policy`, `provenance`.
- `InitializationPolicySpec`: `policy_id`, `state_sources`,
  `allow_cross_config_state`, `allow_future_samples`, `seed`, `provenance`.
- `MetricSpec`: `metric_id`, `name`, `target_signal`, `units`,
  `higher_is_better`, optional `callable_path`, optional `sentinel_value`.
- `BenchmarkProtocolSpec`: `protocol_id`, `schema_version`, component IDs,
  initialization policy, metric IDs, optional `primary_metric_id`.
- `ProtocolRegistrySnapshot` and `ProtocolBundle` are the serializable and
  resolved forms.

Integration rule: runner outputs must include a resolved protocol snapshot or
equivalent immutable IDs. Direct low-level `run_benchmark` calls that omit
protocol identity should be treated as internal or non-public evidence.

### C04 Initialization Stress Contract

| Field | Value |
| --- | --- |
| Owner | Runner R3, `bsebench-runner` |
| Branch | `phase-8-0-c-universal-runner-degraded-initialization` at `944a152` |
| Primary file | `src/bsebench_runner/initialization_policy.py` |
| Schema names | `InitializationProtocolFixture`, `InitialSocCase`, protocol id `forced_wrong_initial_soc_v1` |
| Producer | Runner protocol assignment |
| Consumers | Runner orchestrator fixtures, stats convergence metrics, monthly report caveats |
| Validation | `pytest tests/test_initialization_policy.py tests/test_orchestrator.py -m fast -q` -> `17 passed` |

Schema surface:

- Hyperparameter key: `soc_init`.
- Cases: `wrong_soc_0p10` and `wrong_soc_0p90`.
- Each case records `soc_init`, `expected_initial_bias`, and description.

Integration rule: stats convergence rows must carry `protocol_id` and `case_id`.
Low and high wrong-start cases must not be collapsed before validation.

### C05 Split Metadata And Leakage Guard Contract

| Field | Value |
| --- | --- |
| Owners | Datasets D3 and Runner R4 |
| Branches | D3 `2f0caba`; R4 `5d8efab` |
| Primary files | `src/bsebench_datasets/splits.py`; `src/bsebench_runner/split_guard.py` |
| Schema names | Datasets split `1.1`; runner `SplitGuardReport` |
| Producers | Dataset split manifests and protocol assignment |
| Consumers | Runner leakage guard, stats comparability rows, monthly snapshot gates |
| Validation | D3 `uv run --extra dev pytest tests/test_split_audit_j_v1.py -q` -> `21 passed`; R4 `pytest tests/test_split_guard.py -q` -> `6 passed` |

Schema surface:

- Datasets split roles: `train`, `calibration`, `validation`,
  `heldout_evaluation`, `external_evaluation`, `smoke`.
- Datasets leakage boundaries: `config_tuple`, `cell_id`, `cycle_id`,
  `source_file`, `dataset`.
- Datasets calibration policy: `forbidden`, `allowed_on_this_split`,
  `allowed_on_named_splits`.
- Datasets evaluation metadata: task, target signals, primary metric, unit,
  direction, aggregation policy.
- Runner guard currently checks overlapping `(wrapper, profile, T_C)` keys and
  emits `SplitGuardReport`.

Integration rule: until the runner guard consumes D3's richer boundary fields,
`cell_id`, `cycle_id`, `source_file`, and dataset-level leakage protection are
not fully enforced by runner execution.

### C06 Dataset Provenance, Ground Truth, Equipment, And Availability Contracts

| Field | Value |
| --- | --- |
| Owners | Datasets D2, D4, D5, D6 |
| Branches | D2 `a52c81d`; D4 `e5f2305`; D5 `96566f9`; D6 `c1af5d0` |
| Primary files | `ground_truth_metadata_audit.py`, `dataset_card.py`, `equipment_registry.py`, `availability.py` |
| Schema names | `bsebench-ground-truth-metadata-audit/v1`; `bsebench-dataset-card/v1`; equipment Pydantic models; `bsebench-dataset-availability-snapshot/v1` |
| Producers | Dataset maintainers and monthly availability build |
| Consumers | Protocol assignment, split validation, stats report caveats, source ledgers |
| Validation | D2 `pytest tests/test_ground_truth_metadata_audit.py -q` -> `5 passed`; D4 `pytest tests/test_dataset_card.py -q` -> `14 passed`; D5 `pytest tests/test_equipment_registry.py -q` -> `9 passed`; D6 `pytest tests/test_availability_snapshot.py -q` -> `3 passed` |

Schema surface:

- Ground truth audit statuses: `ready`, `gap`, `not_applicable`.
- Supported ground-truth methods: `coulomb_counting`, `ocv_recalibration`.
- Common evidence requires source pointer, retrieval date, split-scope leakage
  guard, and `uses_future_test_labels=false`.
- Dataset card records chemistry, profile, temperature, aging/SOH coverage,
  source ledger status, content digests, license, and transformations.
- Equipment registry supports vendors `arbin`, `maccor`, and `unknown`.
  Neware is intentionally not accepted yet.
- Availability rows report `tier2_available`, `tier1_available`,
  `manifest_registered`, or `prospect_tracked`; they do not verify remote
  uptime or loader readability.

Integration rule: SOC/SOH scoring is blocked for a dataset/split unless
ground-truth evidence is `ready`, truth fields are target-only, and dataset card,
equipment, split, and availability records resolve to immutable IDs.

### C07 Runner Profiling And Compute Record Contract

| Field | Value |
| --- | --- |
| Owner | Runner R5, `bsebench-runner` |
| Branch | `phase-8-0-e-universal-runner-compute-profiling-hooks` at `2006dff` |
| Primary file | `src/bsebench_runner/profiling.py` |
| Schema name | `bsebench.step_profiling.v1` |
| Producer | Runner step profiler |
| Consumers | Stats compute-cost aggregation, monthly compute evidence rows |
| Validation | `pytest tests/test_profiling.py tests/test_orchestrator.py -m fast -q` -> `12 passed`; integrated runner replay included R5 |

Schema surface:

- `BenchmarkProfilingMetadata`: `enabled`, `clock`, `memory_backend`,
  `memory_scope`, profiled cell/step counts, `cell_profiles`.
- `EstimatorStepProfile`: `filter_name`, `config_label`, `status`,
  `error_type`, `n_steps`, wall-time totals/min/max/mean, and traced-memory
  deltas/peak.
- Clock default: `time.perf_counter_ns`.
- Memory backend: `tracemalloc`; this is Python allocation telemetry, not
  process RSS, GPU memory, or embedded RAM.

Integration rule: C07 is useful raw telemetry, but public compute comparison
requires C10 evidence-tier metadata and hardware/environment stratification.

### C08 Stats Metric And Report Contracts

| Field | Value |
| --- | --- |
| Owners | Stats S1-S6, `bsebench-stats` |
| Branches | S1 `646bf3c`; S2 `eddb345`; S3 `0d7e275`; S4 `f11a151`; S5 `f42e0a0`; S6 `59dfd52` |
| Primary files | `metric_matrix.py`, `convergence.py`, `robustness_noise_schema.py`, `compute_cost.py`, `multi_axis_ranking.py`, `transfer_matrix.py` |
| Schema names | `metric_matrix_v1`; `convergence_recovery_metrics_v1`; `robustness_noise_report_v1`; `compute_cost_aggregate_v1`; `multi_axis_ranking_report_v1`; `transfer_matrix_v1` and `transfer_matrices_v1` |
| Producer | Stats package from runner artifacts |
| Consumers | Monthly snapshot artifact, public report, release gates |
| Validation | Focused S1-S6 replay commands passed; see Wave 4 stats validation for exact environments |

Schema surface:

- Accuracy matrix supports `rmse`, `mae`, and `maxe` over finite 1D error
  arrays.
- Convergence/recovery reports first held threshold window, convergence time,
  error areas, recovery ratios, and post-convergence exits.
- Robustness schema requires Gaussian and non-Gaussian families, split metadata,
  metric direction, source artifacts, complete estimator-condition cells, and
  explicit failed cells.
- Compute aggregation accepts runtime, memory, cloud-cost, and FLOP aliases
  with coverage summaries.
- Ranking is mechanical only, over supplied axes and weights with caveats.
- Transfer matrix builds source x target reports over axes and oriented
  transfer loss summaries.

Integration rule: stats must ingest a stable runner artifact schema, not ad hoc
arrays. SOC/SOH metrics must carry target signal, unit, warmup/mask policy,
comparison unit, split role, failed-cell status, and aggregation policy.

### C09 Submission Smoke And Lifecycle Contract

| Field | Value |
| --- | --- |
| Owners | Runner R6 plus async W4-13 |
| Branches | R6 `ce792f3`; `phase-8-3-m-submission-lifecycle-state-machine-20260507T204627Z` at `16748da` |
| Primary files | R6 submission smoke tests and `specs/universal/submission-lifecycle-state-machine-20260507T204627Z.md` |
| Schema names | Submission lifecycle states; reviewer decisions `accepted_for_smoke`, `accepted_for_benchmark`, `accepted_as_partial`, `non_comparable`, `blocked`, `rejected`, `withdrawn` |
| Producer | Contributor intake and runner smoke |
| Consumers | Monthly snapshot submission registry and release gates |
| Validation | R6 `pytest tests/test_submission_smoke.py -q` -> `1 passed`; lifecycle spec `git diff --check` -> pass |

Integration rule: same-process toy smoke is an internal fixture only. Public
contributor code requires dependency restore, sandboxed smoke, deterministic
replay, leakage review, artifact manifesting, metric validation, comparability
review, and freeze evidence before monthly publication.

### C10 Compute Evidence Tier Contract

| Field | Value |
| --- | --- |
| Owner | Async W4-17 |
| Branch | `phase-8-3-q-compute-evidence-tier-spec-20260507T204627Z` at `21f532d` |
| Primary file | `specs/universal/compute-evidence-tier-spec-20260507T204627Z.md` |
| Schema names | Compute tiers C0 through C5 |
| Producers | Runner profiling, operation counters, embedded build scripts, monthly release artifact |
| Consumers | Stats compute aggregation, public report caveats |
| Validation | `git diff --check` -> pass |

Schema surface:

- C0: missing or declarative evidence.
- C1: wall-time telemetry.
- C2: memory telemetry.
- C3: operation-count estimate.
- C4: embedded ROM/RAM build evidence.
- C5: calibrated hardware model.
- Required scopes include `estimator_step`, `estimator_episode`,
  `full_benchmark_run`, and `training_or_calibration`.

Integration rule: C07 runner profiles and S4 stats aggregates must add or
preserve `compute_evidence_tier`, measurement scope, hardware profile, backend,
environment identity, repeat policy, and caveat before compute rows can be
sorted or compared publicly.

### C11 Source Ledger And Monthly Snapshot Contract

| Field | Value |
| --- | --- |
| Owners | Async W4-11 and W4-12 |
| Branches | Source ledger spec `808d046`; monthly snapshot schema `0f3b4bb` |
| Primary files | `specs/universal/source-ledger-schema-20260507T204627Z.md`; `specs/universal/monthly-snapshot-artifact-schema-20260507T204627Z.md` |
| Schema names | `bsebench-source-ledger/v1`; `bsebench.monthly_snapshot_artifact.v1` |
| Producers | Release owner, source-ledger reviewer, benchmark artifact builder |
| Consumers | Public reports, monthly snapshots, claim binding review |
| Validation | `git diff --check` -> pass in both spec branches |

Schema surface:

- Source ledger rows bind external numbers to stable DOI/URL, retrieval date,
  source location, exact metric, units, dataset, split, method, reported value,
  comparability, caveat, and frozen BSEBench evidence.
- Claim binding ledger binds public prose, tables, figures, and report text to
  source-ledger rows and frozen BSEBench values.
- Monthly snapshot artifact requires snapshot identity, immutable refs,
  submission registry, method registry, dataset registry, metric registry,
  protocol registry, evidence artifacts, result rows, source ledgers,
  validation gates, release caveats, and freeze record.

Integration rule: no positive external comparison or claim-promotion language
can pass without complete C11 ledgers and frozen C01-C10 evidence.

## Cross-Repo Mismatch Register

| ID | Mismatch | Affected contracts | Integration consequence | Required resolution |
| --- | --- | --- | --- | --- |
| M01 | Runner estimator input uses `t`; dataset trace contract exposes `dt_s` as the explicit derived cadence for universal trace inputs. | C01, C02 | Irregular sampling and causal step timing remain implicit in runner adapter calls. | Decide whether C02 v1 gains `dt_s`, or runner artifacts must expose deterministic `dt_s` while legacy adapters receive `t`. |
| M02 | C02 requires `voltage_predicted`; SOC/SOH outputs are optional extras. | C02, C03, C06, C08 | SOH-only or SOC/SOH-only methods cannot be public-scored unless they also emit voltage or the protocol admits target-metric-only execution. | Add protocol-level target-signal mode and stats ingestion for `soc_estimated`/`soh_estimated`, with ground-truth evidence gates. |
| M03 | R2 protocol registry is candidate code and not observed merged into current runner `main`; it is present in the W5 runner integration branch at `e0664de`. | C03, C08, C11 | Stats and monthly snapshots cannot rely on current mainline runner artifacts until the integration branch is promoted or otherwise pinned. | Final integrated runner must emit resolved `BenchmarkProtocolSpec` or `ProtocolBundle` IDs and hashes, and downstream artifacts must pin the runner integration SHA. |
| M04 | Runner split guard checks only `(wrapper, profile, T_C)`, while D3 can declare `cell_id`, `cycle_id`, `source_file`, and `dataset` leakage boundaries. | C05, C06 | Current guard can miss leakage classes that D3 is able to describe. | Extend runner guard to consume D3 `leakage_boundary` and source identity fields before heldout/public runs. |
| M05 | Stats metric matrix draft is sample-pooled; public acceptance requires macro comparison units and explicit failed/invalid rows. | C08, C11 | Public summaries could overweight long traces or hide failures if used directly. | Add macro-unit aggregation and explicit invalid/missing/diverged statuses to the runner-to-stats artifact. |
| M06 | Legacy voltage divergence sentinel exists in runner metrics; metrics acceptance forbids fabricated sentinel values for SOC/SOH metrics. | C02, C08 | SOC/SOH reports risk conflating divergence with large numeric errors if sentinel policy is copied. | Preserve structured status rows for SOC/SOH; limit sentinels to legacy voltage diagnostics. |
| M07 | Runner profiling and stats compute aggregation do not yet require compute evidence tiers, hardware profile, or backend stratification. | C07, C08, C10 | Wall time, memory, FLOPs, and embedded footprint can be falsely compared. | Add C10 fields before any compute sorting or public comparison. |
| M08 | Equipment registry accepts Arbin, Maccor, and unknown; Neware is rejected and Maccor lacks inspected production parser evidence. | C01, C06 | Dataset ETL readiness cannot be inferred from registry presence. | Add source-family parser fixtures and metadata before claiming Maccor or Neware ETL readiness. |
| M09 | D6 availability snapshot is metadata-only and does not prove remote uptime, cache readability, or loader execution. | C06, C11 | Availability rows cannot substitute for data validation or source-ledger completion. | Link availability rows to loader-readability probes, cache hashes, and source-ledger records. |
| M10 | R6 submission smoke imports code in-process; lifecycle spec requires sandboxed public execution. | C09, C11 | Toy smoke is not a public contributor security boundary. | Keep R6 as developer fixture; add sandbox/dependency/replay lifecycle gates before public intake. |

## Merge Readiness Dependencies

Minimum controlled merge order for contract consistency:

1. D1 dataset ETL contract, then D3 split metadata.
2. D2 ground-truth metadata audit, D4 dataset cards, D5 equipment registry, D6
   availability snapshot.
3. R1 estimator adapter, R2 protocol registry, R3 initialization fixture, R4
   split guard, R5 profiling, R6 submission smoke.
4. S1-S6 stats contracts after a runner artifact schema is frozen enough for
   stats adapters.
5. C10 compute tier and C11 source/monthly snapshot contracts before public
   report generation or external comparison wording.

Blockers for public monthly output:

- No complete source ledger for external comparison language.
- No frozen runner/stats/datasets commit IDs in the monthly artifact.
- No target-signal and unit binding for SOC/SOH metric rows.
- No split/leakage guard that covers the declared dataset boundary.
- No structured status for failed, missing, invalid, timeout, or excluded cells.
- No compute evidence tier for compute comparisons.

## Validation Commands Recorded

Commands inspected from Wave 4 validation and schema artifacts:

```bash
git fetch origin --prune
git ls-remote --heads origin 'phase-8-4-*'
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner for-each-ref \
  --format='%(refname:short) %(objectname:short)' refs/heads refs/remotes/origin
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats for-each-ref \
  --format='%(refname:short) %(objectname:short)' refs/heads refs/remotes/origin
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets for-each-ref \
  --format='%(refname:short) %(objectname:short)' refs/heads refs/remotes/origin
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner ls-remote --heads origin \
  phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats ls-remote --heads origin \
  phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets ls-remote --heads origin \
  phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner diff --check \
  origin/main...origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats diff --check \
  origin/main...origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets diff --check \
  origin/main...origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z
```

Focused branch gates recorded in the Wave 4 validation artifacts:

```bash
# Runner
pytest tests/test_estimator_contract.py -q
pytest tests/test_protocol_registry.py -q
pytest tests/test_initialization_policy.py tests/test_orchestrator.py -m fast -q
pytest tests/test_split_guard.py -q
pytest tests/test_profiling.py tests/test_orchestrator.py -m fast -q
pytest tests/test_submission_smoke.py -q

# Stats
pytest tests/test_metric_matrix.py -q
pytest tests/test_convergence.py -q
pytest tests/test_robustness_noise_schema.py -q
pytest tests/test_compute_cost.py -q
pytest tests/test_multi_axis_ranking.py -q
pytest tests/test_transfer_matrix.py -q

# Datasets
pytest tests/test_etl_contract.py -q
pytest tests/test_ground_truth_metadata_audit.py -q
pytest tests/test_split_audit_j_v1.py -q
pytest tests/test_dataset_card.py -q
pytest tests/test_equipment_registry.py -q
pytest tests/test_availability_snapshot.py -q

# This ledger branch
git diff --check
```

## Ledger Decision

Status: PASS as an integration ledger.

Runner, stats, and datasets Wave 1 branches have matching local and remote
heads and Wave 4 focused validation evidence. Wave 5 integration heads are now
visible for runner, stats, and datasets; runner has focused remote validation,
while stats and datasets still need independent focused validation against
their pushed heads. These are integration candidates, not merged public
evidence. The mismatches in this ledger must be resolved or explicitly caveated
before a universal SOC/SOH monthly benchmark artifact can be treated as
release-ready.

## Non-Claims

- This ledger does not claim BSEBench is SOTA, novel, leaderboard-leading,
  breakthrough, complete, publication-ready, or scientifically verified.
- This ledger does not claim any estimator, ECM, filter, observer, AI method,
  hybrid method, or future method is better than another.
- This ledger does not claim any SOC/SOH accuracy, convergence, robustness,
  compute, transfer, or public benchmark result.
- This ledger does not certify source ledgers, dataset licensing, remote
  availability, or external comparability as complete.
- This ledger does not edit thesis files, manuscript files, claim registry
  files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap.
