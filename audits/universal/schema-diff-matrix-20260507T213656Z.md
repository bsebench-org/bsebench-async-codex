---
GLASSBOX:
  worker: W6-05
  role: universal-schema-diff-redteam
  artifact: schema-diff-matrix
  created_utc: 2026-05-07T21:36:56Z
  branch: phase-8-5-e-universal-schema-diff-matrix-20260507T213656Z
  owned_write_set: audits/universal/schema-diff-matrix-20260507T213656Z.md
  mode: read-only contract inspection plus one audit artifact
---

# Universal Schema Diff Matrix

This artifact maps runner, stats, and datasets contract fields that must agree
before the universal benchmark branches are merged or used for alpha-release
reporting. It exposes naming, unit, owner, validation-command, and semantic
mismatches only. It does not rank methods, validate results, publish benchmark
numbers, or make SOTA, novelty, leaderboard, breakthrough, or verified-claim
statements.

## Scope And Evidence

Target contract surfaces inspected read-only:

- Runner Wave 1 integrated worktree:
  `/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`
  at `e0664de`.
- Stats Wave 1 integrated worktree:
  `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z`
  at `08d7c2c`.
- Datasets Wave 1 integrated worktree:
  `/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z`
  at `6cbdc54`; this worktree had an unrelated local modification in
  `src/bsebench_datasets/__init__.py`, so schema conclusions use the inspected
  schema files and Wave 1 branch heads, not that dirty export file.
- Prior Phase 8 sidecar artifacts:
  `api-gap-audit-20260507T193050Z.md`,
  `estimator-interface-compatibility-matrix-20260507T204627Z.md`,
  `dataset-etl-acceptance-matrix-20260507T204627Z.md`,
  `metrics-acceptance-matrix-20260507T204627Z.md`, and the W5 cross-repo
  contract ledger.

Representative inspection commands run:

```bash
git status --short --branch
rg --files ... | rg '(runner|stats|dataset|schema|contract|universal|benchmark|validation|audit|glassbox)'
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner log -1 --oneline
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats log -1 --oneline
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets log -1 --oneline
nl -ba src/bsebench_runner/{estimator_contract.py,protocol_registry.py,profiling.py,split_guard.py,orchestrator.py,metrics.py}
nl -ba src/bsebench_stats/{metric_matrix.py,convergence.py,compute_cost.py,robustness_noise_schema.py,multi_axis_ranking.py,transfer_matrix.py}
nl -ba src/bsebench_datasets/{etl_contract.py,splits.py,dataset_card.py,manifest.py,availability.py,ground_truth_metadata_audit.py,equipment_registry.py}
nl -ba splits/audit_j_v1.yaml
nl -ba audits/universal/*matrix*.md
nl -ba ledgers/contracts/cross-repo-api-contract-ledger-20260507T213125Z.md
```

## Owner And Validation Map

| Owner | Branch / head | Contract surface | Validation command to preserve |
| --- | --- | --- | --- |
| Runner R1 | `phase-8-0-a` / `7f590c2` | `estimator_contract.py`; `bsebench.estimator.v1` | `pytest tests/test_estimator_contract.py -q` |
| Runner R2 | `phase-8-0-b` / `acf95fa` | `protocol_registry.py`; protocol registry models | `pytest tests/test_protocol_registry.py -q` |
| Runner R3 | `phase-8-0-c` / `944a152` | degraded initialization fixtures | `pytest tests/test_initialization_policy.py tests/test_orchestrator.py -m fast -q` |
| Runner R4 | `phase-8-0-d` / `5d8efab` | split leakage guard | `pytest tests/test_split_guard.py -q` |
| Runner R5 | `phase-8-0-e` / `2006dff` | step profiling; `bsebench.step_profiling.v1` | `pytest tests/test_profiling.py tests/test_orchestrator.py -m fast -q` |
| Runner R6 | `phase-8-0-f` / `ce792f3` | submission smoke fixture | `pytest tests/test_submission_smoke.py -q` |
| Stats S1 | `phase-8-0-g` / `646bf3c` | `metric_matrix_v1` | `pytest tests/test_metric_matrix.py -q` |
| Stats S2 | `phase-8-0-h` / `eddb345` | `convergence_recovery_metrics_v1` | `pytest tests/test_convergence.py -q` |
| Stats S3 | `phase-8-0-i` / `0d7e275` | `robustness_noise_report_v1` | `pytest tests/test_robustness_noise_schema.py -q` |
| Stats S4 | `phase-8-0-j` / `f11a151` | `compute_cost_aggregate_v1` | `pytest tests/test_compute_cost.py -q` |
| Stats S5 | `phase-8-0-k` / `f42e0a0` | `multi_axis_ranking_report_v1` | `pytest tests/test_multi_axis_ranking.py -q` |
| Stats S6 | `phase-8-0-l` / `59dfd52` | `transfer_matrix_v1`, `transfer_matrices_v1` | `pytest tests/test_transfer_matrix.py -q` |
| Datasets D1 | `phase-8-0-m` / `6b6bab2` | `bsebench-datasets-etl-field-contract/v1` | `pytest tests/test_etl_contract.py -q` |
| Datasets D2 | `phase-8-0-n` / `a52c81d` | `bsebench-ground-truth-metadata-audit/v1` | `pytest tests/test_ground_truth_metadata_audit.py -q` |
| Datasets D3 | `phase-8-0-o` / `2f0caba` | split schema `1.1` | `pytest tests/test_split_audit_j_v1.py -q` |
| Datasets D4 | `phase-8-0-p` / `e5f2305` | `bsebench-dataset-card/v1` | `pytest tests/test_dataset_card.py -q` |
| Datasets D5 | `phase-8-0-q` / `96566f9` | raw equipment registry | `pytest tests/test_equipment_registry.py -q` |
| Datasets D6 | `phase-8-0-r` / `c1af5d0` | `bsebench-dataset-availability-snapshot/v1` | `pytest tests/test_availability_snapshot.py -q` |

## Schema Diff Matrix

Severity legend: `BLOCKER` can corrupt benchmark semantics or public reporting;
`HIGH` can make integration silently wrong; `MEDIUM` requires explicit adapter
logic or caveats before alpha release.

| ID | Seam | Producer field / unit | Consumer field / unit | Owner(s) | Severity | Mismatch | Merge hardening |
| --- | --- | --- | --- | --- | --- | --- | --- |
| SDM-01 | Time and cadence | Datasets Tier 2 `time_s` in `s`; loader `t` in `s`; optional `dt_s` in `s` | Runner `EstimatorStepInput.t`; estimator `step(t, ...)`; stats convergence `sample_period_s` | D1, R1, S2 | BLOCKER | Universal trace inputs include `dt_s`, but the estimator contract only passes absolute/rebased `t`. Irregular sampling and causal cadence are implicit. | Add `dt_s` to the runner sample contract or freeze an adapter rule that computes and records `dt_s` while legacy estimators receive `t`. Require stats convergence rows to state `sample_period_s` source. |
| SDM-02 | Current sign convention | Tier 2 `current_A`: charge-positive, discharge-negative; loader `I = -current_A`: discharge-positive | Runner passes loader `I` into argument named `current_A` | D1, R1 | BLOCKER | The same name `current_A` means opposite signs depending on layer. A downstream estimator can misread runner `current_A` as BPX current. | Rename or annotate runner input as discharge-positive current, or include a required `current_sign_convention` field in runner artifacts and protocol snapshots. |
| SDM-03 | Voltage target and residual unit | Datasets `voltage_V`; loader `V`; split target `voltage_V`; protocol `target_signal` plus `units` | Runner output `voltage_predicted`; runner `rmse_matrix` in `mV`; stats metric matrix generic `rmse` without per-report unit field | D1, D3, R1, R2, S1 | HIGH | Voltage is represented as volts for signals and millivolts for errors. Stats can validate finite arrays but not the target-unit conversion without an external unit field. | Add report-level `target_signal`, `signal_unit`, `error_unit`, and conversion provenance to runner-to-stats artifacts. |
| SDM-04 | Temperature identity | Dataset Tier 2 `temperature_C`; loader `T_meas`; split config `T_C` ambient/config value | Runner `temperature_C` uses `T_meas` or fallback `cfg.T_C`; stats transfer wants temperature/generalization axes | D1, D3, R1, S6 | HIGH | Measured temperature and ambient/config temperature can collapse into the same runner argument. Transfer or profile bins may then mix chamber/config and measured-cell semantics. | Preserve both `config_temperature_C` and `measured_temperature_C` where available; stats axes must declare which temperature basis they use. |
| SDM-05 | Matrix orientation | Runner `rmse_matrix` is `(n_filters, n_configs)` with `filter_names` and `config_labels` | Stats `metric_matrices[metric]` is `(n_cell_profiles, n_filters)` with `comparison_units` rows | R1, S1 | HIGH | A direct handoff can transpose or relabel rows silently. Runner config labels are not stats comparison units. | Require an adapter that names source and target shapes, converts to stats row order, and records `source_matrix_orientation`. |
| SDM-06 | Method identifier vocabulary | Runner uses `filter_names`; protocol uses `estimator_adapter_ids`; stats uses `filter_names`, `methods`, and `estimators` across modules | Monthly/public reports need stable method ids | R2, S1, S3, S5 | HIGH | "Filter", "estimator", "method", and "adapter" refer to overlapping but different identities. | Freeze `method_id` and `adapter_id` as distinct fields. Stats may display filter labels but should join on stable method ids. |
| SDM-07 | Dataset/config identity | Datasets split `wrapper`, `profile`, `T_C`; protocol `dataset_id`, `split_id`, `wrapper_names`; stats `cell_label`, `profile_label`, `unit_id` | Monthly row target: dataset/cell/profile/temperature/aging/split | D3, R2, R4, S1, S6 | BLOCKER | Current runner split guard only enforces `(wrapper, profile, T_C)`, while stats and public reports need cell, dataset, split, and possibly aging axes. | Add canonical `comparison_unit_id` with dataset, split, wrapper, profile, temperature, and optional cell/cycle/source identifiers. |
| SDM-08 | Split role names | Datasets split role includes `heldout_evaluation` and `external_evaluation`; protocol leakage scope includes `heldout`; robustness report split role allows `heldout` | Stats robustness `dataset_split.split_role` | D3, R2, S3 | MEDIUM | Held-out evaluation is spelled differently across contracts. A literal validator can reject valid dataset split roles or downgrade them. | Add a split-role normalization table and preserve original role plus normalized stats role. |
| SDM-09 | Target truth and leakage | Datasets truth fields `soc_truth`, `soh_truth` with `target_only`; ground-truth audit statuses `ready`, `gap`, `not_applicable` | Runner step output extras `soc_estimated`, `soh_estimated`; stats metrics need target/reference arrays | D1, D2, R1, R2, S1, S2 | BLOCKER | Estimator output names exist, but runner artifacts do not yet bind them to evidence-ready truth fields, target signals, and split leakage guards. | Block SOC/SOH scoring unless ground-truth audit is `ready`, target fields are target-only, and runner artifacts record target-signal binding. |
| SDM-10 | Error-family units | Metrics acceptance requires SOC/SOH percentage points and voltage `mV`; stats metric matrix computes generic numeric errors; convergence accepts optional `error_unit` | Runner only computes voltage `mV` RMSE/MAE | R1, S1, S2 | HIGH | Generic stats helpers can consume arrays without proving whether values are fraction, percentage point, volts, or millivolts. | Require `metric_family`, `target_signal`, `error_unit`, and conversion policy on every stats report and source runner artifact. |
| SDM-11 | Failure semantics | Runner uses `DIVERGENCE_SENTINEL_MV = 10000`; residual paths use structured `status`; stats metric matrix requires `status == ok`; robustness report has explicit failed cells | Runner-to-stats ingestion | R1, S1, S3 | BLOCKER | Sentinel values, rejected non-ok cells, and explicit failed cells can conflict. Hidden loader/schema failures can become large numeric errors or vanish. | Prefer structured statuses: `ok`, `loader_error`, `estimator_error`, `schema_error`, `leakage_guard_error`, `resource_limit_error`. Limit sentinel to legacy voltage diagnostics. |
| SDM-12 | Sample counts | Loader legacy `N`; runner `n_max_samples`, `n_configs`; profiling `n_steps`, `n_profiled_steps`; stats `n_samples`, `n_trials`, `n_observations` | Aggregation and caveats | D1, R1, R5, S1, S3, S6 | MEDIUM | Counts refer to raw rows, retained samples, estimator calls, trials, and transfer observations without a shared vocabulary. | Add `raw_n_samples`, `retained_n_samples`, `estimator_step_count`, `trial_count`, and `observation_count` as distinct fields. |
| SDM-13 | Compute runtime units | Runner profiling `wall_time_ns_total/min/max/mean` | Stats compute accepts `runtime_seconds`, `runtime_s`, `wall_time_seconds`, `wall_time_s`, etc. | R5, S4 | HIGH | Runner emits nanoseconds while stats aggregates seconds aliases. A naive adapter can aggregate ns as seconds. | Add an explicit adapter conversion from `wall_time_ns_*` to seconds and record `runtime_source_field` plus `runtime_unit`. |
| SDM-14 | Compute memory units | Runner profiling `memory_traced_bytes_*` and backend/scope | Stats compute accepts `memory_peak_mb`, `peak_rss_mb`, `max_rss_mb`, etc. | R5, S4 | HIGH | Runner memory is traced Python allocation bytes, not process RSS MB. Stats alias names can imply RSS or full process memory. | Convert bytes to MB only with `memory_backend=tracemalloc` and `memory_scope`; do not map it to RSS aliases. |
| SDM-15 | Compute comparability | Runner profiling lacks hardware/environment/evidence tier; stats compute aggregates runtime, memory, cost, flops coverage | Public compute rows need evidence tier and stratification | R5, S4, async compute-tier spec | BLOCKER for public compute comparisons | Wall-time and memory values can be sorted without hardware, backend, tier, repeat, or environment identity. | Add `compute_evidence_tier`, hardware profile, OS/Python/package lock, backend, scope, repeats, and caveat before any compute comparison. |
| SDM-16 | Initialization case binding | Runner initialization fixture uses `protocol_id=forced_wrong_initial_soc_v1`, cases `wrong_soc_0p10` and `wrong_soc_0p90`, hyperparameter `soc_init` | Stats convergence returns metrics but no required protocol/case envelope | R3, S2 | HIGH | Low and high wrong-start cases can be collapsed or detached from convergence rows. | Stats convergence rows must carry `initialization_protocol_id`, `case_id`, `soc_init`, threshold, hold policy, and unit. |
| SDM-17 | Robustness perturbation identity | Stats robustness requires `noise_conditions[].condition_id`, family, distribution, target, parameters, seed | Runner has no observed perturbation generator schema in inspected integration surface | R2, S3 | MEDIUM | Robustness reports can validate already-computed cells, but runner artifacts do not yet identify perturbation source/generator. | Freeze runner perturbation condition schema before monthly robustness reports. |
| SDM-18 | Source artifact hashes | Dataset manifest files use `path`, `sha256`, `size_bytes`; robustness source artifacts use `artifact_type`, `path`, `sha256`, `schema_version`; runner artifact manifest uses its own output-manifest shape | Cross-report provenance joins | D4, S3, runner manifest audits | MEDIUM | `sha256` is common, but artifact type, schema version, size, and source role are not normalized. | Add a shared `SourceArtifactRef` envelope with optional role-specific extensions. |
| SDM-19 | Availability versus readiness | Datasets availability statuses: `tier2_available`, `tier1_available`, `manifest_registered`, `prospect_tracked` | Monthly snapshot and runner loader execution may read this as data readiness | D6, runner loaders, monthly snapshot | HIGH | Availability is metadata-only and does not prove remote uptime, cache readability, loader execution, or source-ledger completion. | Monthly rows must link availability to loader-readability probes and immutable cache/source artifacts. |
| SDM-20 | Ranking direction and metric direction | Protocol `higher_is_better`; dataset split `metric_direction`; stats ranking axes use `direction`; transfer uses `lower_is_better` | Multi-axis ranking and transfer | D3, R2, S5, S6 | MEDIUM | Direction is encoded as both positive and negative booleans/strings. Inversion bugs can reverse ranks. | Normalize to one enum at report ingress and record original field plus normalized direction. |

## Highest-Risk Merge Checks

Before alpha release, the merge queue should add explicit checks for these
cross-repo invariants:

1. The runner-to-stats artifact must declare `target_signal`, `signal_unit`,
   `error_unit`, `comparison_unit_id`, `method_id`, `adapter_id`, split role, and
   matrix orientation.
2. Current sign convention must be machine-visible at the Tier 2, loader, runner
   sample, and protocol layers.
3. SOC/SOH metrics must fail closed without evidence-ready `soc_truth` or
   `soh_truth`, and must not inherit the legacy voltage sentinel.
4. Runner profiling must be converted to stats compute records with explicit
   units and backend metadata.
5. Public report generation must reject hidden failed cells, missing source
   ledgers, missing compute evidence tiers, and availability-only dataset claims.

## Validation Record

| Validation item | Status | Evidence |
| --- | --- | --- |
| Inspect available contract docs/logs | PASS | Read runner, stats, datasets Wave 1 integration files; prior Phase 8 matrices; and the W5 cross-repo contract ledger. |
| Map field names, units, owners, and validation commands | PASS | Owner/validation map and SDM-01 through SDM-20 above. |
| Guardrails | PASS | No thesis, manuscript, roadmap, claim registry, `claims/registry.yaml`, or `claim_55` files edited. No unsupported claim language added. |
| `git diff --check` | PASS | No whitespace errors after artifact creation. |

## Non-Claims

- This artifact does not claim BSEBench is complete, alpha-ready, public-ready,
  SOTA, novel, leaderboard-leading, breakthrough, or scientifically verified.
- This artifact does not claim any estimator, filter, observer, AI estimator,
  hybrid method, dataset, metric, or protocol is better than another.
- This artifact does not validate real SOC/SOH/voltage accuracy, convergence,
  robustness, transfer, compute cost, or dataset availability results.
- This artifact is a merge-hardening schema diff only.
