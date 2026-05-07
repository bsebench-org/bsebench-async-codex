# GLASSBOX Metric Definitions Audit

## GLASSBOX Metadata

- Worker: M-METRICS
- Timestamp: 2026-05-07T19:35:28Z wave context
- Branch: phase-8-2-c-metric-definitions-audit-20260507T193528Z
- Owned write-set: `audits/methodology/metric-definitions-20260507T193528Z.md`
- Artifact type: audit, specification, and runbook
- Scope: metric definitions for accuracy, safety MAXE, convergence, robustness,
  compute, and generalization

## Objective

Define a leakage-safe, falsifiable metric vocabulary for BSEBench so ECMs,
Kalman filters, observers, AI estimators, hybrid methods, and future filters can
be compared without rewriting metric logic or hiding assumptions in one-off
reports.

This audit does not change benchmark code. It identifies canonical metric
units, aggregation policy, required caveats, and implementation gaps that should
be handled by future runner and stats tasks.

## Evidence Inspected

Repository evidence inspected in this worktree:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
  - Requires RMSE, MAE, MAXE, convergence, robustness, compute cost, and
    generalization axes.
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`
  - Confirms Wave 1 stats tasks already targeted metric matrix,
    convergence, robustness, compute, ranking, and transfer helpers.
- `outbox/phase-7-6-b-runner-residual-trace-5x5/SUMMARY.md`
  - Residual trace producer emits measured voltage once per config and only
    emits residual arrays for successful filters.
- `outbox/phase-7-7-a-residual-variance-decomp-stats/SUMMARY.md`
  - Residual decomposition excludes failed filters without fabricated arrays and
    fails loud when retained evidence is insufficient.
- `outbox/phase-7-8-g-stats-hinf-weighting-sensitivity/SUMMARY.md`
  - Prior stats work found material sensitivity to unequal sample counts,
    supporting explicit aggregation caveats.
- `outbox/phase-7-10-k-runner-hinf-manifest-drift-audit/SUMMARY.md`
  - Manifest drift audit rejects non-finite JSON and forbidden claim language.

Sibling code and tests inspected:

- `/mnt/c/doctorat/bsebench-org/bsebench-runner/src/bsebench_runner/metrics.py`
  and `tests/test_metrics.py`
  - Current runner computes voltage RMSE and MAE in mV from voltage traces in V,
    with `DIVERGENCE_SENTINEL_MV = 1e4` for non-finite or divergent values.
- `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-g-universal-stats-metric-matrix/src/bsebench_stats/metric_matrix.py`
  and `tests/test_metric_matrix.py`
  - Draft metric matrix computes RMSE, MAE, MAXE over finite 1D error vectors,
    requires a complete cell/profile/filter grid, and aggregates by pooled raw
    sample sums.
- `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-h-universal-stats-convergence-metrics/src/bsebench_stats/convergence.py`
  and `tests/test_convergence.py`
  - Draft convergence helper reports first held threshold window, time in
    seconds, area error, excess area, final recovery, and post-convergence
    threshold exits.
- `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-i-universal-stats-robustness-noise-schema/src/bsebench_stats/robustness_noise_schema.py`
  and `tests/test_robustness_noise_schema.py`
  - Draft schema requires Gaussian and non-Gaussian noise families, declared
    split role, metric direction, source artifacts, and explicit failed cells.
- `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-j-universal-stats-compute-cost-aggregator/src/bsebench_stats/compute_cost.py`
  and `tests/test_compute_cost.py`
  - Draft aggregator requires runtime, records optional memory, cost, and FLOPs
    coverage, and reports mean, median, min, max, and total.
- `/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-e-universal-runner-compute-profiling-hooks/src/bsebench_runner/profiling.py`
  and `tests/test_profiling.py`
  - Draft profiling hook records wall-clock nanoseconds and Python
    `tracemalloc` bytes per `(filter, config)` cell.
- `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-k-universal-stats-multi-axis-ranking/src/bsebench_stats/multi_axis_ranking.py`
  and `tests/test_multi_axis_ranking.py`
  - Draft ranking helper is mechanical only, relative to supplied axes, methods,
    and weights, with source-ledger caveats.
- `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-l-universal-stats-transfer-matrix/src/bsebench_stats/transfer_matrix.py`
  and `tests/test_transfer_matrix.py`
  - Draft transfer helper builds source x target matrices for chemistry,
    profile, and domain axes, with oriented transfer loss.
- `/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-c-universal-runner-degraded-initialization/src/bsebench_runner/initialization_policy.py`
  and `tests/test_initialization_policy.py`
  - Draft degraded-initialization fixture injects deterministic `soc_init`
    values 0.10 and 0.90 into filter configs.

## Canonical Metric Families

### Accuracy

Canonical state-estimation accuracy metrics:

- `soc_rmse_pct_point`: `sqrt(mean((soc_hat - soc_ref)^2)) * 100`
- `soc_mae_pct_point`: `mean(abs(soc_hat - soc_ref)) * 100`
- `soc_maxe_pct_point`: `max(abs(soc_hat - soc_ref)) * 100`
- `soh_rmse_pct_point`: `sqrt(mean((soh_hat - soh_ref)^2)) * 100`
- `soh_mae_pct_point`: `mean(abs(soh_hat - soh_ref)) * 100`
- `soh_maxe_pct_point`: `max(abs(soh_hat - soh_ref)) * 100`

Canonical voltage residual diagnostics:

- `voltage_rmse_mV`: `sqrt(mean((v_pred - v_meas)^2)) * 1000`
- `voltage_mae_mV`: `mean(abs(v_pred - v_meas)) * 1000`
- `voltage_maxe_mV`: `max(abs(v_pred - v_meas)) * 1000`

Decision: SOC and SOH reports should use percentage points as the default
public unit, even if internal runner arrays use fractions in `[0, 1]`. Voltage
residuals remain in mV and should be labeled as voltage/model-fit diagnostics,
not substituted silently for SOC/SOH accuracy.

Current support:

- Runner mainline supports voltage RMSE and MAE in mV with a 10000 mV divergence
  sentinel.
- Draft stats metric matrix supports RMSE, MAE, and MAXE for any finite 1D
  error vector but does not itself enforce SOC/SOH units.

Gap:

- Runner accuracy exports should add `maxe` and explicit `error_unit` fields for
  SOC, SOH, and voltage families.
- State metrics should not use the voltage sentinel. Non-finite state estimates
  should mark the result cell `failed` or `diverged`, with no fabricated metric.

### Safety MAXE

`MAXE` is the maximum absolute error over retained post-warmup samples in one
comparison unit. It is safety-relevant because short excursions can be hidden by
RMSE or MAE.

Required fields for any MAXE report:

- `metric_name`: one of `soc_maxe_pct_point`, `soh_maxe_pct_point`,
  `voltage_maxe_mV`, or a protocol-declared equivalent.
- `unit`: `pct_point` for SOC/SOH, `mV` for voltage residuals.
- `n_retained_samples`
- `max_abs_error`
- `thresholds`: protocol-declared thresholds with units.
- `threshold_exceedance_counts`: count and fraction of retained samples above
  each threshold.
- `post_warmup_policy`: exact sample exclusion rule.

Decision: Public benchmark tables should never publish RMSE without the matching
MAXE and threshold exceedance context for the same comparison units.

Gap:

- Existing runner metrics do not expose MAXE. Draft stats metric matrix can
  compute it once the runner supplies finite error vectors.

### Convergence

Canonical convergence metrics apply to degraded-initialization traces, usually
wrong initial SOC.

Required fields:

- `error_metric`: signed SOC or SOH error series before absolute value.
- `error_unit`: `pct_point` by default for SOC/SOH public reports.
- `sample_period_s`
- `error_threshold`
- `hold_samples` or an equivalent `hold_time_s`
- `converged`
- `convergence_time_s`
- `initial_abs_error`
- `final_abs_error`
- `peak_abs_error`
- `area_abs_error`: `sum(abs(error)) * sample_period_s`
- `excess_error_area`: `sum(max(abs(error) - threshold, 0)) * sample_period_s`
- `n_post_convergence_threshold_exits`
- `remained_within_threshold_after_convergence`

Decision: Convergence must be reported separately for each forced-initial-SOC
case and then aggregated only after preserving per-case rows. The low-start and
high-start cases can fail differently.

Current support:

- Draft runner fixture defines deterministic `soc_init` cases 0.10 and 0.90.
- Draft stats helper implements first held threshold window and recovery fields.

Gap:

- The runner and stats outputs need a shared schema linking initialization case
  IDs to convergence reports.

### Robustness

Canonical robustness reports compare clean baseline performance with injected
noise or perturbation conditions.

Required fields:

- `dataset_split`: includes `dataset_id`, `split_id`, `split_role`, and
  `leakage_policy`.
- `metric`: includes metric name, unit, and direction.
- `noise_conditions`: includes family, distribution, injection target,
  parameters, and seed where random.
- `result_cells`: one row per estimator x condition.
- For successful cells: baseline value, perturbed value, delta, ratio, trial
  count, and sample count.
- For failed cells: failure code and message, with metric values omitted.
- `source_artifacts`: paths, schema versions, and hashes.

Decision: Robustness aggregation must preserve condition-family groupings. A
single pooled robustness number is acceptable only as a secondary convenience
field after Gaussian and non-Gaussian results are separately visible.

Current support:

- Draft robustness schema requires both Gaussian and non-Gaussian families,
  complete estimator x condition grid, finite metrics, and explicit failures.

Gap:

- The runner still needs standard perturbation generators and a policy for
  voltage, current, temperature, parameter drift, and missing-sample injection.

### Compute

Canonical compute fields:

- `runtime_seconds`: required for run-level aggregation.
- `wall_time_ns_total`, `wall_time_ns_mean`, `wall_time_ns_min`,
  `wall_time_ns_max`: per estimator/config step profiling.
- `samples_per_second`: derived when `n_samples` is known.
- `memory_peak_mb`: optional, but coverage must be reported.
- `memory_backend`: for example `tracemalloc` or process RSS.
- `flops`: optional measured or estimated operation count.
- `cost_usd`: optional cloud-cost estimate, never a scientific metric.
- `hardware`: CPU/GPU model, core count, RAM, accelerator, and OS when
  comparing across machines.
- `software`: Python version, package lock identity, and benchmark commit.

Decision: Compute values are comparable across methods only when hardware,
software, batch size, sample count, and profiling backend are held fixed or
reported as caveats.

Current support:

- Draft runner profiling records per-step wall-clock nanoseconds and
  `tracemalloc` memory deltas.
- Draft stats compute aggregator normalizes runtime, optional memory, optional
  cost, and optional FLOPs, with coverage fields.

Gap:

- `tracemalloc` is not process RSS and does not capture all native allocations.
  Reports must say so when using it.

### Generalization

Canonical generalization reports should use transfer matrices over source and
target domains. Required axes:

- `chemistry`
- `profile`
- `temperature`
- `aging_or_soh_bin`
- `dataset`
- `domain` or `equipment_family`

Required fields:

- source domain metadata used for calibration, training, or tuning.
- target domain metadata used for blind evaluation.
- split identities proving no target leakage.
- metric name, unit, and lower/higher-is-better direction.
- source x target matrix with count and weight matrices.
- same-axis summary, cross-axis summary, and oriented transfer loss.

Decision: Generalization is not a single leaderboard axis. It is a family of
transfer reports, because a method can generalize across profile while failing
across chemistry or aging.

Current support:

- Draft transfer helper covers chemistry, profile, and domain axes with source x
  target matrices and oriented transfer loss.

Gap:

- Temperature, SOH/aging, dataset, and equipment axes should be first-class
  schema fields, not hidden in free-form domain strings.

## Aggregation Policy

Canonical comparison unit:

- Default unit: one `(dataset_id, cell_id, profile_id, temperature_bin,
  aging_or_soh_bin, split_id)` row.
- A report may omit an axis only when the protocol declares it unavailable or
  not applicable.

Per-unit metric computation:

- Compute RMSE, MAE, MAXE, convergence, and robustness values within each
  comparison unit after the protocol-specific warmup and validity masks.
- Retain `n_samples`, `dt` or `sample_period_s`, and dropped-sample counts.

Default public aggregation:

- Use equal-weight macro aggregation over retained comparison units for public
  method summaries, unless a protocol explicitly declares another weighting.
- Publish sample-pooled aggregates as secondary fields because they are useful
  diagnostics, but they must not silently replace macro summaries.

Required aggregate fields:

- `macro_mean`
- `macro_median`
- `macro_iqr`
- `sample_pooled`
- `n_units`
- `n_samples_total`
- `unit_weighting_policy`
- `sample_weighting_policy`
- `missing_cell_policy`

Decision: The draft metric matrix's pooled raw-sum aggregation is valid as a
sample-pooled diagnostic, but it is not sufficient as the only public aggregate
because long traces can dominate short cells or profiles.

Fail-loud policy:

- Missing declared cells must not be imputed.
- Non-finite errors must fail validation before aggregation.
- Failed estimator cells must be explicit rows, not zeros, sentinels, or dropped
  rows unless the protocol separately reports failure rates.
- Legacy voltage divergence sentinels must be labeled as voltage compatibility
  sentinels and excluded from state-metric definitions.

## Runbook For Future Implementers

1. Normalize estimator outputs into metric-family-specific error arrays:
   `soc_error_fraction`, `soh_error_fraction`, or `voltage_error_v`.
2. Convert public SOC/SOH error arrays to percentage points before report
   emission.
3. Emit one result row per comparison unit and estimator before any aggregate.
4. Include RMSE, MAE, and MAXE for every accuracy family being reported.
5. Include thresholds and exceedance counts for every MAXE safety report.
6. Emit convergence rows per degraded-initialization case before aggregating.
7. Emit robustness cells per estimator x perturbation condition and keep failed
   cells explicit.
8. Emit compute metadata with profiling backend and environment identity.
9. Emit transfer matrices per generalization axis, with source and target split
   provenance.
10. Attach caveats for missing axes, incomplete grids, sample imbalance, and
    any external comparability requirement.

## Validation Commands

Commands used for this audit:

- `rg --files`
- `rg -n "MAXE|RMSE|MAE|SOH|SOC|accuracy|convergence|robust|compute|runtime|generalization|aggregation|metric|uncertainty|Friedman|Nemenyi|chi2|residual" README.md docs outbox inbox cto -g '*.md' -g '*.json'`
- `sed -n '1,220p' /mnt/c/doctorat/bsebench-org/bsebench-runner/src/bsebench_runner/metrics.py`
- `sed -n '1,220p' /mnt/c/doctorat/bsebench-org/bsebench-runner/tests/test_metrics.py`
- `sed -n '1,520p' /mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-g-universal-stats-metric-matrix/src/bsebench_stats/metric_matrix.py`
- `sed -n '1,280p' /mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-h-universal-stats-convergence-metrics/src/bsebench_stats/convergence.py`
- `sed -n '1,300p' /mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-i-universal-stats-robustness-noise-schema/src/bsebench_stats/robustness_noise_schema.py`
- `sed -n '1,320p' /mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-j-universal-stats-compute-cost-aggregator/src/bsebench_stats/compute_cost.py`
- `sed -n '1,340p' /mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-k-universal-stats-multi-axis-ranking/src/bsebench_stats/multi_axis_ranking.py`
- `sed -n '1,520p' /mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-l-universal-stats-transfer-matrix/src/bsebench_stats/transfer_matrix.py`
- `sed -n '1,320p' /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-e-universal-runner-compute-profiling-hooks/src/bsebench_runner/profiling.py`
- `sed -n '1,260p' /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-c-universal-runner-degraded-initialization/src/bsebench_runner/initialization_policy.py`
- `git diff --check`

Recorded result:

- Stats and runner code/tests inspection: pass; evidence summarized above.
- Canonical units, aggregation, and caveats: pass; defined in this artifact.
- `git diff --check`: pass.

## Residual Risks

- Several inspected Wave 8 modules are draft branch artifacts and may not yet be
  merged into main. This audit treats them as implementation evidence, not as
  stable public API guarantees.
- Existing runner voltage metrics use a sentinel for compatibility. That policy
  can contaminate universal state metrics if reused without explicit failure
  rows.
- Sample-count imbalance is a known risk. Public summaries need macro-unit
  aggregation as well as sample-pooled diagnostics.
- Robustness metrics are only as meaningful as the perturbation generator,
  random seed policy, and split provenance.
- Compute comparisons are weak without hardware and software environment
  metadata.
- Transfer matrices can still leak if source/target split roles are not linked
  to calibration, tuning, and blind evaluation metadata.

## Explicit Non-Claims

- This artifact does not claim BSEBench is a finished universal standard.
- This artifact does not claim any estimator is better, safer, more robust, or
  state of the art.
- This artifact does not make novelty, leaderboard, breakthrough, or verified
  scientific claims.
- This artifact does not validate real-data SOC/SOH accuracy, robustness,
  compute cost, or cross-domain generalization results.
- This artifact does not modify thesis files, manuscript files, claim registry
  files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap.
