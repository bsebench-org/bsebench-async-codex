# GLASSBOX Compute Evidence Tier Spec

Saved: 2026-05-07T20:46:27Z
Worker: W4-17
Wave: 4 validation, integration, and anti-hallucination hardening
Scope: CTO validation/spec artifact only
Owned path: `specs/universal/compute-evidence-tier-spec-20260507T204627Z.md`

## Objective

Define compute-cost evidence tiers for universal BSEBench reporting so benchmark
outputs cannot imply hardware-independent precision from hardware-scoped
measurements. The spec covers wall time, memory telemetry, FLOPs or operation
counts, and ROM/RAM footprint evidence for ECMs, Kalman filters, observers, AI
estimators, hybrid methods, and future estimator families.

This artifact is a reporting and validation standard. It does not implement
runner code, stats code, leaderboard logic, thesis content, manuscript content,
claim registry content, or scientific roadmap content.

## Evidence Inspected

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`: computational
  cost is part of the universal benchmark objective, alongside accuracy,
  reliability, and generalization. The charter names execution time, memory
  footprint, ROM/RAM metadata, and FLOPs or hardware-agnostic operation counts.
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`: Wave 1 split compute
  work into runner profiling hooks and stats compute-cost aggregation helpers.
- Watchdog inventory under `/home/oakir/.local/state/bsebench-async-watchdog`:
  72 `manual-phase-8-*.log` files were present at inspection time. The original
  Waves 1-3 inventory was verified as 48 logs, with 45 logs that started
  normally and 3 early usage-limit failures.
- Early usage-limit logs identified by checking the first 80 lines only:
  `manual-phase-8-2-j-reproducibility-artifact-manifest-audit-20260507T193528Z.log`,
  `manual-phase-8-2-k-merge-queue-runbook-20260507T193528Z.log`, and
  `manual-phase-8-2-l-worker-triage-and-relaunch-runbook-20260507T193528Z.log`.
  Broad grep for `usage limit` is noisy because Wave 4 logs quote earlier
  prompts and searches.
- Current `/mnt/c/doctorat/bsebench-org/bsebench-runner` main checkout: no
  merged `EstimatorStepProfiler`, `STEP_PROFILING_SCHEMA_VERSION`,
  `tracemalloc`, `perf_counter_ns`, `wall_time_ns`, or `memory_traced` hook was
  found under `src` or `tests` during this inspection.
- `/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-e-universal-runner-compute-profiling-hooks`
  at commit `2006dff`: adds `src/bsebench_runner/profiling.py` with
  `time.perf_counter_ns` wall-time timing and Python `tracemalloc` allocation
  metadata around estimator `step` calls. The module states that `tracemalloc`
  describes traced Python allocations, not process RSS.
- Current `/mnt/c/doctorat/bsebench-org/bsebench-stats` checkout: no merged
  `aggregate_compute_cost` or `COMPUTE_COST` helper was found under `src` or
  `tests` during this inspection.
- `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-j-universal-stats-compute-cost-aggregator`
  at commit `f11a151`: adds `aggregate_compute_costs`, accepting runtime,
  memory, cloud-cost, and FLOP aliases with coverage summaries. The inspected
  helper does not yet encode evidence tier, measurement scope, hardware profile,
  or backend compatibility as mandatory grouping keys.
- Prior audit artifact
  `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-2-d-compute-cost-reproducibility-audit-20260507T193528Z/audits/methodology/compute-cost-reproducibility-20260507T193528Z.md`:
  establishes the core principle that wall time, memory telemetry, operation
  counts, and ROM/RAM build evidence are different evidence classes and must not
  be collapsed into one opaque compute score.

## Commands

```bash
git status --short --branch
git remote -v
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-*.log' | wc -l
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-*.log' -printf '%f\n' | sort
for f in /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-{0,1,2}-*.log; do
  if sed -n '1,80p' "$f" | rg -q "You've hit your usage limit"; then
    printf 'usage %s\n' "$(basename "$f")"
  fi
done
sed -n '1,180p' docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md
sed -n '1,150p' docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md
rg -n "EstimatorStepProfiler|STEP_PROFILING_SCHEMA_VERSION|tracemalloc|perf_counter_ns|wall_time_ns|memory_traced" \
  /mnt/c/doctorat/bsebench-org/bsebench-runner/src \
  /mnt/c/doctorat/bsebench-org/bsebench-runner/tests
rg -n "aggregate_compute_cost|COMPUTE_COST|compute_cost|runtime_seconds|memory_peak_mb|flops|cost_usd" \
  /mnt/c/doctorat/bsebench-org/bsebench-stats/src \
  /mnt/c/doctorat/bsebench-org/bsebench-stats/tests
sed -n '1,240p' \
  /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-e-universal-runner-compute-profiling-hooks/src/bsebench_runner/profiling.py
sed -n '1,260p' \
  /mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-0-j-universal-stats-compute-cost-aggregator/src/bsebench_stats/compute_cost.py
sed -n '1,520p' \
  /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-2-d-compute-cost-reproducibility-audit-20260507T193528Z/audits/methodology/compute-cost-reproducibility-20260507T193528Z.md
git diff --check
```

## Findings

1. Current merged runner and stats checkouts did not expose the Phase 8 compute
   profiling or compute-cost aggregation work at inspection time. This spec must
   therefore be treated as an integration target, not proof of current mainline
   behavior.
2. The Phase 8 runner profiling hook is useful Tier 1 and Tier 2 evidence:
   wall time from `time.perf_counter_ns` and Python allocation telemetry from
   `tracemalloc`. It is not process RSS, GPU memory, embedded RAM, ROM, or a
   hardware-independent algorithm cost.
3. The Phase 8 stats aggregator can summarize runtime, memory, cloud cost, and
   FLOP fields, but the inspected version accepts heterogeneous records without
   mandatory tier, scope, backend, or hardware-profile stratification. That is a
   false-comparability risk for public reports.
4. The prior Wave 3 compute audit gives the right direction but needs a stricter
   publishable tier contract with fail-loud conditions and exact non-claim
   language.
5. Compute evidence must support multi-axis reporting, not a single simplistic
   leaderboard. Missing compute evidence is a report-quality gap, not evidence
   that a method is cheap or expensive.

## Evidence Tier Definitions

Tier numbers identify evidence portability and auditability. They are not speed
rankings, quality scores, or claims that one estimator is better than another.

| Tier | Name | Accepted evidence | Required report caveat | Public ranking use |
| --- | --- | --- | --- | --- |
| C0 | Missing or declarative | No measured data, README claim, author claim, or unverified metadata only | `compute_evidence=missing_or_declarative` | Must not sort, rank, or compare by compute. |
| C1 | Wall-time telemetry | Runner-measured elapsed time with timer backend, repeat policy, scope, environment, and hardware profile | `same_hardware_and_scope_only` | Same-run diagnostics and regression checks only. |
| C2 | Memory telemetry | Named backend such as Python `tracemalloc`, process RSS, accelerator memory profiler, or embedded static RAM extraction | `same_backend_scope_platform_only` unless embedded target is fixed | Backend-scoped diagnostics only. |
| C3 | Operation-count estimate | Auditable FLOP, MAC, graph-op, matrix formula, or custom counter with input shape and counting script or formula identity | `formula_scope_only` | Hardware-agnostic complexity proxy, not runtime. |
| C4 | Embedded ROM/RAM build evidence | Target build artifact, map file or equivalent, compiler/toolchain flags, target identity, source and dependency hashes | `same_target_toolchain_family_only` | Deployment-footprint evidence grouped by target family. |
| C5 | Calibrated hardware model | C1 telemetry plus C3 operation counts or C4 footprint, calibrated on a named platform with calibration data and error bounds | `calibrated_platform_only` | Platform-specific what-if estimates, never universal runtime. |

### Tier C0: Missing Or Declarative

Use C0 when a submission lacks compute evidence or provides only unsupported
statements such as "runs fast", "low memory", or "MCU-ready". C0 records must be
visible in reports so missing evidence is not silently converted into a zero,
null, or favorable value.

Minimum fields:

- `compute_evidence_tier: C0`
- `missing_reason`
- `report_action: omit_from_compute_sort`

Fail condition: any public report that sorts C0 beside measured tiers by
runtime, memory, FLOPs, cost, or deployment footprint.

### Tier C1: Wall-Time Telemetry

Use C1 for measured elapsed time. The default runner source should be
`time.perf_counter_ns` around a declared scope. Storage may use nanoseconds, but
human prose and tables must round to meaningful precision.

Required fields:

- `compute_evidence_tier: C1`
- `measurement_scope`: one of `estimator_step`, `estimator_episode`,
  `full_benchmark_run`, or `training_or_calibration`
- `timer_backend`
- `wall_time_ns_total` or `wall_time_seconds`
- `n_steps`, `n_warmup`, `n_repeats`, and `repeat_index` where applicable
- `hardware_profile_id`
- OS, Python/runtime version, runner commit, dependency lock hash, and thread
  controls where applicable

Report rule: publish median and spread over repeats. Do not state or imply that
C1 evidence transfers across CPUs, GPUs, operating systems, WSL environments,
thermal states, BLAS settings, or background load.

### Tier C2: Memory Telemetry

Use C2 for memory evidence only when the backend and scope are explicit. Python
`tracemalloc`, process RSS, accelerator memory, and embedded static RAM are not
interchangeable.

Required fields:

- `compute_evidence_tier: C2`
- `memory_backend`: for example `tracemalloc`, `process_rss`,
  `cuda_peak_memory`, `embedded_map_static_ram`, or another named backend
- `memory_scope`
- one or more backend-specific values, such as
  `python_tracemalloc_peak_bytes`, `process_peak_rss_bytes`,
  `accelerator_peak_bytes`, or `embedded_static_ram_bytes`
- `measurement_scope`
- `hardware_profile_id` or embedded target identity

Report rule: never aggregate memory records unless `memory_backend`,
`memory_scope`, `measurement_scope`, and platform class match. A convenience
field such as `memory_peak_mb` is allowed only after preserving backend and tier
metadata.

### Tier C3: Operation Counts, FLOPs, MACs, Or Formula Counts

Use C3 for hardware-agnostic complexity proxies when the counting method is
auditable. For classical filters, formula counts by state dimension and update
path may be more honest than fake FLOPs. For neural estimators, graph MACs or
operation counts must include model hash and input shape.

Required fields:

- `compute_evidence_tier: C3`
- `operation_count_kind`: `flops`, `macs`, `matrix_ops_formula`,
  `model_graph_ops`, or `custom_counter`
- `operation_count_total` and units
- counting script, formula id, or graph extraction command
- source file hash or commit
- input shape, sample length, state dimension, and branch policy
- explicit include/exclude list for nonlinear calls, lookup tables, adaptive
  iterations, failed steps, sparse operations, and interpolation

Report rule: C3 can compare formula-scope complexity across hardware, but it
must not be converted to seconds, dollars, or deployment readiness without a
separate calibrated model.

### Tier C4: Embedded ROM/RAM Build Evidence

Use C4 only when there is a target-specific build artifact. Python object size,
package size, source lines, or adapter metadata is not ROM/RAM evidence.

Required fields:

- `compute_evidence_tier: C4`
- target architecture, board or simulator, and target family
- compiler, interpreter, or toolchain version and flags
- source commit and dependency lock hash
- binary, map file, compiled module, or equivalent artifact hash
- extraction command for text, data, bss, heap, and stack estimates
- inclusion policy for lookup tables, ECM parameters, calibration state, and AI
  model weights

Report rule: group by target family and toolchain. Do not mix C4 embedded
footprints with laptop Python memory traces or C1 wall time.

### Tier C5: Calibrated Hardware Model

Use C5 only when a hardware model is explicitly calibrated and its error is
reported. This tier is optional and should be rare until BSEBench has stable
calibration protocols.

Required fields:

- `compute_evidence_tier: C5`
- calibration platform and `hardware_profile_id`
- calibration dataset, script, and source hashes
- input evidence tiers used, normally C1 plus C3 or C4
- calibration date and repeat policy
- error summary, confidence interval, or residual bound
- applicability limits

Report rule: C5 estimates are platform-scoped. They are not universal runtime
claims.

## Required Measurement Scopes

Every compute record must declare exactly one scope:

- `estimator_step`: only the estimator inference primitive, such as `step`.
- `estimator_episode`: initialization plus all estimator steps for one
  `(method, dataset_config, repeat)` cell.
- `full_benchmark_run`: loaders, ETL, orchestration, metrics, and reporting.
- `training_or_calibration`: fitting, hyperparameter search, ECM
  identification, model training, or adaptation before evaluation.

Public method tables should default to `estimator_step` and
`estimator_episode`. `full_benchmark_run` is operational evidence and can be
loader-biased. `training_or_calibration` must not be mixed with inference cost.

## Minimum Compute Record Contract

Future runner artifacts should emit one record per
`(method_id, dataset_config_id, repeat_index, measurement_scope, evidence_tier)`.

```yaml
schema_version: bsebench.compute_evidence_record.v1
method_id: example_method
dataset_config_id: example-cell-profile-temperature
measurement_scope: estimator_step
compute_evidence_tier: C1
repeat_index: 0
n_repeats: 7
n_warmup: 1
n_steps: 3000
status: ok
timer_backend: time.perf_counter_ns
wall_time_ns_total: 123456789
wall_time_ns_median_per_step: 41000
memory_backend: tracemalloc
memory_scope: owned_tracemalloc
python_tracemalloc_peak_bytes: 987654
process_peak_rss_bytes: null
operation_count_kind: null
operation_count_total: null
rom_ram_backend: null
hardware_profile_id: cpu-linux-x86_64-redacted-v1
environment:
  os: linux
  runtime: python-3.12
  runner_git_sha: required
  stats_git_sha: required_if_aggregated
  dependency_lock_sha256: required
  thread_controls:
    OMP_NUM_THREADS: recorded_or_null
    OPENBLAS_NUM_THREADS: recorded_or_null
comparability: same_hardware_and_scope_only
limitations:
  - tracemalloc excludes native allocations and device memory
```

Records for C2, C3, C4, or C5 must fill the tier-specific fields above and may
leave unrelated fields null. Nulls are acceptable only when the tier does not
require the field.

## Aggregation And Report Gates

Stats aggregation must fail loud unless all records in an aggregate group share
compatible values for:

- `measurement_scope`
- `compute_evidence_tier`
- tier-specific backend, such as `memory_backend` or `operation_count_kind`
- `hardware_profile_id` for C1, C2, and C5
- embedded target family and toolchain for C4
- input shape or state dimension for C3 when the count depends on it

If a report needs to show heterogeneous evidence, it must use separate groups
and a coverage table instead of one sorted list. Recommended summary shape:

```yaml
compute_evidence_summary:
  schema_version: bsebench.compute_evidence_summary.v1
  aggregation_policy: stratified_by_scope_tier_backend_platform
  coverage:
    C0_missing: 2
    C1_wall_time: 8
    C2_memory: 5
    C3_operation_count: 4
    C4_embedded_build: 1
    C5_calibrated_model: 0
  groups:
    - measurement_scope: estimator_step
      compute_evidence_tier: C1
      timer_backend: time.perf_counter_ns
      hardware_profile_id: cpu-linux-x86_64-redacted-v1
      runtime_seconds:
        repeat_policy: median_iqr_over_repeats
        n_records: 25
        median: 0.00123
        iqr: [0.00118, 0.00131]
      comparability: same_hardware_and_scope_only
    - measurement_scope: estimator_step
      compute_evidence_tier: C3
      operation_count_kind: matrix_ops_formula
      input_shape_policy: fixed_state_dimension
      comparability: formula_scope_only
```

## Public Wording Rules

Allowed language:

- "C1 wall-time telemetry on this hardware profile was lower/higher in this
  run."
- "C2 `tracemalloc` coverage is present for these records; native allocations
  are not measured."
- "C3 operation-count evidence is available under the stated formula and input
  shape."
- "C4 ROM/RAM evidence is available for this target and toolchain."
- "Compute evidence is missing for this method/configuration."

Forbidden language without stronger evidence:

- "hardware-independent runtime"
- "fastest method"
- "cheapest method"
- "MCU-ready"
- "deployment-proven"
- "state of the art"
- "leaderboard winner"
- "verified compute claim"
- any precise cross-hardware percentage or dollar claim without a completed
  source ledger and tier-compatible evidence

## Pass/Fail Recommendations

Pass for this branch:

- A single GLASSBOX spec artifact was created under the owned path.
- The spec defines tiers from wall time to FLOPs/RAM/ROM with caveats.
- The spec records the evidence inspected, commands, findings,
  recommendations, residual risks, and explicit non-claims.

Fail or block future integration if:

- runner compute records omit `measurement_scope` or `compute_evidence_tier`;
- stats aggregation combines different tiers, scopes, backends, or hardware
  profiles without stratification;
- public reports sort C0 missing evidence beside measured evidence;
- C1 wall time is presented as hardware-independent;
- C2 `tracemalloc` data is presented as total process RSS, GPU memory, or
  embedded RAM;
- C3 FLOP/MAC/formula counts are converted to runtime or cloud cost without a
  C5 calibrated model;
- C4 ROM/RAM fields are populated without target build artifacts and hashes.

## Residual Risks

- The runner and stats compute branches inspected here were not observed in the
  current main checkouts, so this spec should be rechecked after integration.
- `tracemalloc` can perturb timing and excludes native allocations, device
  memory, and process RSS.
- WSL, laptop thermal throttling, CPU frequency scaling, background processes,
  and BLAS thread settings can materially change C1 wall time.
- Operation-count formulas can hide adaptive branches, failed-step paths,
  nonlinear functions, lookup tables, sparse operations, or interpolation unless
  the counting contract is enforced.
- ROM/RAM evidence can drift when compiler flags, lookup tables, model weights,
  ECM parameters, or calibration state change.
- A future public report could still misuse correct metadata through unclear
  wording. Report templates and CI checks should enforce this spec.

## Explicit Non-Claims

- This spec does not claim that any estimator is faster, cheaper, more
  deployable, more accurate, or more robust than another.
- This spec does not verify a hardware-independent runtime metric.
- This spec does not validate any SOTA, novelty, leaderboard, breakthrough, or
  scientific claim.
- This spec does not update thesis, manuscript, roadmap, `claim_55`, or
  `claims/registry.yaml` content.
- This spec does not assert that the Phase 8 runner or stats worktrees are
  complete, correct, merged, or merge-ready.
- This spec does not create a public benchmark result or a source ledger.

## Validation Status

- `git diff --check`: PASS before staging.
- `git diff --cached --check`: PASS after staging.
