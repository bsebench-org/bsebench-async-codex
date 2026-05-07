# GLASSBOX Metrics Acceptance Matrix

## GLASSBOX Metadata

- Worker: W4-16
- Wave: 4 validation, integration, and anti-hallucination hardening
- Timestamp: 2026-05-07T20:46:27Z task context
- Branch: `phase-8-3-p-metrics-acceptance-matrix-20260507T204627Z`
- Owned write-set: `audits/universal/metrics-acceptance-matrix-20260507T204627Z.md`
- Artifact type: validation audit and acceptance matrix
- Scope: accuracy, safety, convergence, robustness, compute, and generalization metrics

## Objective

Define a metrics acceptance matrix that BSEBench can use before integrating or
publishing universal SOC/SOH benchmark reports for ECMs, Kalman filters,
observers, AI estimators, hybrid methods, and future filters.

The matrix is intentionally mechanical. It defines units, aggregation,
invalid-case handling, and report caveats. It does not rank methods, validate
scientific performance, or assert that any Phase 8 branch is merged or public
benchmark ready.

## Evidence Inspected

Repository and log evidence:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
  - Requires accuracy, reliability, compute, and generalization axes, including
    RMSE, MAE, MAXE, convergence, noise tolerance, compute cost, and transfer
    over chemistry/profile/temperature/aging.
- Watchdog logs under `/home/oakir/.local/state/bsebench-async-watchdog`
  - Pre-Wave-4 Phase 8 baseline: 48 `manual-phase-8-[0-2]-*.log` files.
  - Completion-like by early-log inspection: 45.
  - Direct usage-limit stops: 3, namely `manual-phase-8-2-j-*`,
    `manual-phase-8-2-k-*`, and `manual-phase-8-2-l-*`.
  - Live directory at this sampling also had 24 Wave 4 `manual-phase-8-3-*`
    logs, so live total was 72 Phase 8 manual logs. The 48/45/3 baseline is
    therefore a pre-Wave-4 subset, not the whole live directory.
- Remote branch inventory:
  - Runner Wave 1 heads `phase-8-0-a` through `phase-8-0-f` found on
    `bsebench-runner`.
  - Stats Wave 1 heads `phase-8-0-g` through `phase-8-0-l` found on
    `bsebench-stats`.
  - Dataset Wave 1 heads `phase-8-0-m` through `phase-8-0-r` found on
    `bsebench-datasets`.
  - Async Wave 1 heads `phase-8-0-s` through `phase-8-0-x`, Wave 2 heads
    `phase-8-1-k` through `phase-8-1-v`, and Wave 3 heads through
    `phase-8-2-i` found on `bsebench-async-codex`. The original
    `phase-8-2-j/k/l` heads were not present remotely at this sampling because
    those original logs stopped on usage limits.

Stats and runner implementation evidence:

- `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-g-universal-stats-metric-matrix/src/bsebench_stats/metric_matrix.py`
  and `tests/test_metric_matrix.py`
  - Draft helper computes `rmse`, `mae`, and `maxe` over finite 1D error arrays,
    requires a complete cell/profile/filter grid, and aggregates by pooled raw
    sample sums.
- `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-h-universal-stats-convergence-metrics/src/bsebench_stats/convergence.py`
  and `tests/test_convergence.py`
  - Draft helper reports first held threshold window, convergence time,
    absolute-error area, excess area, recovery ratios, and post-convergence
    threshold exits.
- `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-i-universal-stats-robustness-noise-schema/src/bsebench_stats/robustness_noise_schema.py`
  and `tests/test_robustness_noise_schema.py`
  - Draft schema requires Gaussian and non-Gaussian noise families, split
    metadata, metric direction, source artifacts, complete estimator x condition
    cells, and explicit failed cells.
- `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-j-universal-stats-compute-cost-aggregator/src/bsebench_stats/compute_cost.py`
  and `tests/test_compute_cost.py`
  - Draft aggregator requires runtime and records optional memory, cost, and
    FLOP coverage with mean, median, min, max, and total summaries.
- `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-k-universal-stats-multi-axis-ranking/src/bsebench_stats/multi_axis_ranking.py`
  and `tests/test_multi_axis_ranking.py`
  - Draft ranking helper is mechanical only, relative to supplied axes and
    weights, and includes source-ledger caveats.
- `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-l-universal-stats-transfer-matrix/src/bsebench_stats/transfer_matrix.py`
  and `tests/test_transfer_matrix.py`
  - Draft transfer helper builds source x target matrices with count, weight,
    same-axis, cross-axis, and oriented transfer-loss summaries.
- `/mnt/c/doctorat/bsebench-org/bsebench-runner/src/bsebench_runner/metrics.py`
  - Current runner mainline computes voltage RMSE/MAE in mV and uses a 10000 mV
    divergence sentinel for compatibility.
- `/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-e-universal-runner-compute-profiling-hooks/src/bsebench_runner/profiling.py`
  - Draft runner profiling records wall-clock nanoseconds and Python
    `tracemalloc` bytes per `(filter, config)` cell.
- `/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-c-universal-runner-degraded-initialization/src/bsebench_runner/initialization_policy.py`
  - Draft degraded-initialization fixture defines forced SOC starts at 0.10 and
    0.90.
- `audits/methodology/metric-definitions-20260507T193528Z.md` from the
  `phase-8-2-c-*` worktree.
  - Defines canonical metric units and warns that sample-pooled stats are not
    enough as the only public aggregate.
- `audits/methodology/compute-cost-reproducibility-20260507T193528Z.md` from the
  `phase-8-2-d-*` worktree.
  - Defines compute evidence tiers and stratification requirements.

## Commands Executed

```bash
git status -sb
git branch --show-current
git remote -v
rg --files
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-[0-2]-*.log' | wc -l
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-*.log' | wc -l
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-3-*.log' -printf '%f\n' | sort
for f in /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-{0,1,2}-*.log; do ...; done
git ls-remote --heads origin 'phase-8-*'
git ls-remote --heads origin 'phase-8-3-*'
sed -n '1,260p' src/bsebench_stats/metric_matrix.py
sed -n '1,260p' tests/test_metric_matrix.py
sed -n '1,260p' src/bsebench_stats/convergence.py
sed -n '1,260p' tests/test_convergence.py
sed -n '1,760p' src/bsebench_stats/robustness_noise_schema.py
sed -n '1,360p' tests/test_robustness_noise_schema.py
sed -n '1,360p' src/bsebench_stats/compute_cost.py
sed -n '1,360p' tests/test_compute_cost.py
sed -n '1,420p' src/bsebench_stats/multi_axis_ranking.py
sed -n '1,420p' tests/test_multi_axis_ranking.py
sed -n '1,420p' src/bsebench_stats/transfer_matrix.py
sed -n '1,420p' tests/test_transfer_matrix.py
sed -n '1,260p' src/bsebench_runner/metrics.py
sed -n '1,320p' src/bsebench_runner/profiling.py
sed -n '1,260p' src/bsebench_runner/initialization_policy.py
sed -n '1,260p' audits/methodology/metric-definitions-20260507T193528Z.md
sed -n '1,260p' audits/methodology/compute-cost-reproducibility-20260507T193528Z.md
git diff --check
```

Several `sed` commands were run from the relevant sibling worktrees named in
Evidence Inspected. The shell loop above classified the pre-Wave-4 logs by
early usage-limit text versus a normal `START` preamble.

## Summary Findings

| Finding | Status | Evidence |
| --- | --- | --- |
| Pre-Wave-4 Phase 8 log baseline is verified as 48 logs, with 45 completion-like and 3 usage-limit stops. | PASS | Local watchdog log classification. |
| The live watchdog directory is no longer the 48-log baseline because Wave 4 logs are present. | PASS with caveat | 72 live Phase 8 logs at sampling, including 24 Wave 4 logs. |
| Stats Wave 1 metric helpers cover the required metric families in draft form. | AMBER | Branch artifacts exist and focused tests are present, but they are not treated here as merged mainline APIs. |
| Accuracy helper supports RMSE/MAE/MAXE over finite arrays, but runner mainline still exposes only voltage RMSE/MAE with a sentinel. | AMBER | `metric_matrix.py`; `bsebench_runner/metrics.py`. |
| Robustness schema is anti-hallucination aligned because it requires mechanical evidence and `scientific_verdict: none`. | PASS for schema intent | `robustness_noise_schema.py` tests. |
| Compute aggregation records coverage, but public compute comparison still needs evidence-tier and environment stratification. | AMBER | `compute_cost.py`; compute reproducibility audit. |
| Transfer/generalization helper covers source x target matrices for key axes, but temperature, SOH/aging, dataset, and equipment axes need first-class monthly schema coverage. | AMBER | `transfer_matrix.py`; universal charter. |

## Acceptance Matrix

### Accuracy

| Acceptance item | Required standard |
| --- | --- |
| Primary metrics | `rmse`, `mae`, and `maxe` for every reported error family. |
| SOC unit | Percentage point, computed as `(soc_hat - soc_ref) * 100` when internal arrays are fractions. |
| SOH unit | Percentage point, computed as `(soh_hat - soh_ref) * 100` when internal arrays are fractions. |
| Voltage residual unit | mV, computed from voltage error in V multiplied by 1000. Voltage residuals are diagnostics, not substitutes for SOC/SOH accuracy. |
| Comparison unit | One declared `(dataset_id, cell_id, profile_id, temperature_bin, aging_or_soh_bin, split_id)` row, with omitted axes explicitly marked unavailable or not applicable. |
| Per-unit aggregation | Compute metrics directly from retained finite samples after declared warmup and validity masks. |
| Public aggregate | Macro aggregate over comparison units is required. Sample-pooled aggregate is allowed only as a secondary diagnostic. |
| Invalid cases | Missing declared cell, empty error vector, non-1D error vector, non-finite error, unknown unit, duplicate labels, or missing filter row must fail validation or produce an explicit failed result row. |
| Sentinel policy | Legacy voltage sentinel may be preserved only for legacy voltage diagnostics. SOC/SOH metrics must not use fabricated sentinel values. |
| Report caveats | State whether values are SOC, SOH, or voltage; state unit conversion; state warmup mask; state missing cells; state macro and sample-pooled weighting separately. |

Acceptance decision: AMBER. Draft stats code is consistent with finite-array
accuracy computation, but public acceptance requires state-unit metadata and
macro aggregates beyond the current sample-pooled helper.

### Safety MAXE

| Acceptance item | Required standard |
| --- | --- |
| Metric | `maxe` must accompany every published RMSE/MAE accuracy family. |
| Unit | Same unit as the corresponding error family: percentage point for SOC/SOH, mV for voltage residuals. |
| Thresholds | Protocol-declared safety thresholds with units are required before safety language is used. |
| Exceedance fields | Count and fraction of retained samples above each threshold. |
| Aggregation | Per-unit MAXE is required; public summary must include macro distribution such as median, IQR, and worst retained unit. |
| Invalid cases | Missing threshold units, missing retained-sample count, non-finite max, hidden failed cells, or using an RMSE-only table for safety assessment fails acceptance. |
| Report caveats | MAXE is sample-grid dependent; reports must state sampling cadence, retained-sample policy, and whether interpolation/resampling changed the peak. |

Acceptance decision: AMBER. The draft metric matrix computes MAXE, but safety
acceptance needs explicit thresholds and exceedance reporting at report time.

### Convergence

| Acceptance item | Required standard |
| --- | --- |
| Protocol | Forced degraded initialization case ID is required. Low and high wrong-start cases must remain separate before aggregation. |
| Error trace | Signed SOC or SOH error trace before absolute value. |
| Unit | Percentage point for public SOC/SOH convergence reports, with `sample_period_s` in seconds. |
| Threshold | Positive finite `error_threshold`, with `hold_samples` or an equivalent declared hold time. |
| Required fields | `converged`, `convergence_index`, `convergence_time_s`, `initial_abs_error`, `final_abs_error`, `peak_abs_error`, `area_abs_error`, `excess_error_area`, post-convergence out-of-band counts, and threshold exits. |
| Aggregation | Per case and per comparison unit first; macro aggregate over cases/units second. Non-converged rows must remain visible. |
| Invalid cases | Empty trace, non-1D trace, non-finite values, non-positive threshold, non-positive sample period, invalid hold, missing case ID, or collapsed low/high cases fail acceptance. |
| Report caveats | State initial SOC fixture, threshold and hold policy, sample period, and whether convergence is stable after first entry into threshold. |

Acceptance decision: AMBER. Draft convergence helper covers the core mechanics,
but runner/stats integration must link `forced_wrong_initial_soc_v1` case IDs to
the convergence report schema.

### Robustness

| Acceptance item | Required standard |
| --- | --- |
| Perturbation coverage | At least one Gaussian and one non-Gaussian family for a robustness report using the current draft schema. |
| Split metadata | `dataset_id`, `split_id`, `split_role`, and leakage policy are required. Training split is not an evaluation split role. |
| Metric metadata | Name, unit, and direction are required. |
| Result grid | Exactly one result cell per estimator x noise condition pair. |
| Successful cell fields | `n_trials`, `n_samples`, metric value, baseline value, delta, and ratio. |
| Failed cell fields | Failure code and message; metric values omitted. |
| Aggregation | Preserve condition-family groups. Any pooled robustness score is secondary and must retain per-condition rows. |
| Invalid cases | Missing required noise family, duplicate condition, missing estimator-condition cell, non-finite metric, undeclared estimator, undeclared condition, missing source artifact hash, or claim-like extra fields fail acceptance. |
| Report caveats | State random seeds, injection target, perturbation parameters, baseline definition, split role, and source-artifact hashes. |

Acceptance decision: PASS for mechanical schema intent, AMBER for benchmark
readiness. The schema is strict, but runner perturbation generators and monthly
report integration still need validation.

### Compute

| Acceptance item | Required standard |
| --- | --- |
| Required runtime field | Positive finite `runtime_seconds` or a supported runtime alias. |
| Runtime unit | Seconds for aggregation; nanoseconds may be stored for raw step profiling. |
| Memory unit | Bytes in raw runner profile, MB in aggregate reports, with backend named. |
| Cost unit | USD only as optional operations metadata, never as a scientific method property. |
| FLOP/op unit | Explicit floating-point operations, MACs, formula count, or custom operation count with counting method. |
| Evidence tier | Compute records must declare comparable evidence class: missing, wall time, memory telemetry, operation-count estimate, or ROM/RAM build evidence. |
| Aggregation | Stratify by scope, tier, backend, hardware profile, and software environment before sorting or comparing. Median/IQR over repeats is preferred for wall-time reporting. |
| Invalid cases | Missing runtime for a runtime aggregate, non-positive runtime, negative memory/cost/FLOPs, mixed incompatible backends without stratification, missing hardware/software identity for wall-time comparison, or missing ROM/RAM build artifacts for embedded claims fails acceptance. |
| Report caveats | State hardware, OS, Python/package lock, runner/stats commit, profiling backend, measurement scope, repeats, warmup, and coverage fraction for optional fields. |

Acceptance decision: AMBER. Draft stats aggregator records useful coverage, but
public acceptance requires evidence-tier stratification and environment identity
from the runner/report layer.

### Generalization

| Acceptance item | Required standard |
| --- | --- |
| Matrix form | Source x target transfer matrix for each declared generalization axis. |
| Minimum axes | Chemistry, profile, temperature, aging/SOH bin, dataset, and domain/equipment family, where the dataset supports the axis. |
| Source metadata | Training, calibration, or tuning source domain and split identity. |
| Target metadata | Blind evaluation target domain and split identity. |
| Metric metadata | Metric name, unit, direction, and lower/higher-is-better orientation. |
| Matrix fields | Mean metric matrix, standard deviation matrix, count matrix, weight matrix, same-axis summary, cross-axis summary, and oriented transfer loss. |
| Aggregation | Per-axis transfer reports first; any multi-axis summary must preserve axis-specific rows and weights. |
| Invalid cases | Missing source/target axis labels, non-finite metric, zero or negative weight, duplicate axes, source-target split leakage, unknown target split role, or a hidden missing cell fails acceptance. |
| Report caveats | State target blind-evaluation status, missing transfer cells, weight policy, sample imbalance, and whether source and target labels are from the same dataset or cross-dataset. |

Acceptance decision: AMBER. Draft transfer matrix mechanics are suitable for
chemistry/profile/domain, but a universal monthly schema must add temperature,
aging/SOH, dataset, and equipment axes explicitly.

## Public Report Caveat Requirements

Every metric table in a public or monthly report should carry these caveats or
structured equivalents:

- Metric family and unit are explicit; SOC/SOH percentage-point values are not
  mixed with voltage mV diagnostics.
- Split role and leakage policy are explicit for every reported row.
- Failed, diverged, missing, and non-finite cases are explicit rows or explicit
  invalid statuses, not zeros, sentinels, or silent drops.
- Macro-unit and sample-pooled aggregates are labeled separately.
- Optional compute fields publish coverage; missing compute evidence is not
  interpreted as cheap or expensive.
- Robustness tables preserve perturbation condition and random-seed metadata.
- Transfer/generalization summaries retain source and target metadata.
- External comparability to papers or third-party values requires a completed
  source ledger with stable URL or DOI, retrieval date, exact metric, dataset,
  split, frozen BSEBench value, and comparability caveat.
- Any mechanical ranking is relative only to supplied methods, axes, weights,
  and benchmark slice.

## Integration Recommendations

1. Add a report-level `metric_family` and `unit` field to every metric payload
   before merging universal reports.
2. Treat the draft metric matrix's sample-pooled aggregate as a diagnostic and
   add macro-unit aggregation for public summaries.
3. For state metrics, replace sentinel-style invalid values with explicit
   failed/diverged result rows.
4. Link runner degraded-initialization fixtures to convergence metric rows by
   `protocol_id` and `case_id`.
5. Require robustness source-artifact hashes and failed-cell semantics in CI
   fixtures before monthly report generation.
6. Stratify compute reports by evidence tier, scope, backend, hardware, and
   software identity before any public comparison.
7. Extend transfer matrix report schemas to include temperature, aging/SOH,
   dataset, and equipment-family axes.
8. Block public report language that implies external comparability until the
   source ledger is complete.

## Pass/Fail Decision

Artifact status: PASS. This file defines a concrete acceptance matrix and
records the inspected evidence.

Metrics integration status: AMBER. The inspected Phase 8 stats outputs are
useful draft evidence, but acceptance for a universal benchmark requires merged
runner/stats/report schemas, macro aggregation, explicit invalid-case rows, and
source-ledger-gated public language.

## Residual Risks

- The inspected Wave 1 stats modules are branch artifacts and may change during
  integration.
- The watchdog log directory is live; counts after this audit may differ.
- Some Wave 4 retry and validation logs were still local execution evidence at
  sampling time and were not assumed to be pushed or complete unless remote
  heads showed them.
- Macro aggregation policy still needs implementation in stats/report code.
- Public users can still misuse a mechanical ranking unless report templates
  force caveats into the visible output.
- Compute evidence remains platform-sensitive even when collected correctly.
- Robustness and transfer metrics are only meaningful when dataset split and
  perturbation provenance are enforced.

## Explicit Non-Claims

- This artifact does not claim BSEBench is a finished universal standard.
- This artifact does not claim any estimator, observer, ECM, Kalman filter, AI
  estimator, hybrid method, or future filter is better than another.
- This artifact does not make SOTA, novelty, leaderboard, breakthrough, or
  verified scientific claims.
- This artifact does not validate real SOC/SOH accuracy, safety, convergence,
  robustness, compute, or generalization results.
- This artifact does not edit thesis files, manuscript files, claim registry
  files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap.

## Validation

| Command | Status | Notes |
| --- | --- | --- |
| Inspect stats metric outputs | PASS | Reviewed Wave 1 stats source/tests for metric matrix, convergence, robustness, compute, ranking, and transfer. |
| Define units, aggregation, invalid cases, and report caveats | PASS | Defined per metric family in the acceptance matrix above. |
| `git diff --check` | PASS | No whitespace errors after artifact creation. |
