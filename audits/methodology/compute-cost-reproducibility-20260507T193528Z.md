# GLASSBOX Compute-Cost Reproducibility Audit

Saved: 2026-05-07T19:35:28Z
Worker: M-COMPUTE
Scope: methodology audit/spec/runbook only
Owned path: `audits/methodology/compute-cost-reproducibility-20260507T193528Z.md`

## Objective

Define how BSEBench should measure and report compute cost without hardware bias,
false precision, or accidental comparability claims. The result is a concrete
audit/runbook for future runner, stats, and monthly-report work. It does not
implement runner or stats code.

The benchmark should expose deployability evidence while keeping accuracy,
robustness, and compute evidence separable. A method can be accurate but
computationally expensive, cheap but unstable, or missing compute evidence. The
reporting schema must make those cases explicit instead of collapsing them into
one opaque score.

## Evidence Inspected

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`: the charter lists
  execution time per iteration, memory footprint, ROM/RAM metadata, and FLOPs or
  hardware-agnostic operation counts as compute-cost evidence for the universal
  benchmark.
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`: Wave 1 already assigns
  runner compute profiling hooks and stats compute-cost aggregation to separate
  workers, so this audit should specify methodology rather than duplicate their
  code work.
- Current `bsebench-runner/main`: no merged `bsebench_runner.profiling` module
  was visible during this audit. This means current mainline runner evidence is
  not yet sufficient for compute reporting.
- `bsebench-runner-phase-8-0-e-universal-runner-compute-profiling-hooks`: an
  in-progress worktree adds `src/bsebench_runner/profiling.py`, wraps estimator
  `step` calls in `run_benchmark`, and records `wall_time_ns_*` plus
  `memory_traced_bytes_*` metadata per `(filter, config)` cell. The file itself
  states that memory values are Python `tracemalloc` allocations, not process
  RSS.
- Current `bsebench-stats` checkout: no merged compute-cost aggregation helper
  was visible during this audit.
- `bsebench-stats-phase-8-0-j-universal-stats-compute-cost-aggregator`: an
  in-progress worktree adds `aggregate_compute_costs`, accepting runtime aliases,
  memory aliases, `cost_usd`, and `flops`, with coverage metadata and JSON-safe
  summaries.
- Prior runner/stats outbox logs inspected briefly: Phase 7.10 runner Hinf
  determinism and manifest drift work focused on reproducibility of artifacts,
  hashes, and CI audits; Phase 6.11 stats panel work focused on statistical
  report aggregation. These are adjacent reproducibility precedents, not compute
  evidence standards.

## Compute Evidence Tiers

Use evidence tiers so a benchmark report cannot imply that wall-clock time,
Python allocation telemetry, FLOP estimates, and embedded ROM footprints are the
same kind of evidence.

| Tier | Evidence type | Required source | Comparable across hardware? | Reportable use |
| --- | --- | --- | --- | --- |
| 0 | Missing or declared-only compute metadata | None, README, or author claim only | No | Mark as `missing`; do not rank by compute. |
| 1 | Wall-time telemetry | Runner-measured elapsed time around estimator scope, with repeats and environment manifest | No | Regression checks and same-run comparisons only. |
| 2 | Memory telemetry | Explicit backend such as `tracemalloc`, process RSS, or device profiler | No unless backend and platform match | Memory coverage and platform-scoped diagnostics. |
| 3 | Operation-count or FLOP estimate | Static formula, model graph, instrumented counter, or auditable script | Partly, if scope and assumptions match | Hardware-agnostic complexity proxy with caveats. |
| 4 | ROM/RAM embedded build evidence | Binary/map file, compiler flags, target MCU, build script, and artifact hashes | Only within the same target/toolchain family | Deployment-footprint evidence, not Python runtime evidence. |

Tier numbers are evidence quality and portability classes, not performance ranks.
A Tier 3 FLOP estimate is more portable than Tier 1 wall time, but it is not a
runtime measurement. A Tier 4 embedded build can be the strongest deployability
evidence for one target and still be incomparable to Python traces on a laptop.

## Decisions And Recommendations

### 1. Separate measured scope from algorithm identity

Every compute record must state its measurement scope:

- `estimator_step`: only calls to the estimator `step` or equivalent inference
  primitive.
- `estimator_episode`: initialization plus all steps for one
  `(filter, config)` cell.
- `full_benchmark_run`: loader, ETL, orchestration, metrics, and reporting.
- `training_or_calibration`: any fitting, optimization, hyperparameter search,
  or ECM identification.

Default public compute tables should use `estimator_step` and
`estimator_episode`. `full_benchmark_run` is useful for operations but can bias
against datasets with slower loaders. `training_or_calibration` must never be
mixed with inference cost.

### 2. Wall time is Tier 1 and must be treated as hardware-scoped

Wall time should be collected because users need practical runtime diagnostics,
but it must not be presented as hardware-independent. Required fields:

- timer backend, preferably `time.perf_counter_ns`;
- `n_steps`, `n_warmup`, `n_repeats`, and repeat index;
- CPU/GPU/accelerator model when available;
- OS, Python version, package lock identity, and runner git SHA;
- thread controls where applicable, for example BLAS thread count;
- measurement scope and whether data loading is included.

Reporting rule: publish median, IQR, min, and max over repeats. Round to
reasonable significant figures. Avoid nanosecond-level prose claims; nanosecond
storage is allowed for reproducibility, but human reporting should not imply
that such precision is meaningful.

### 3. Memory evidence must name the backend

The Phase 8 runner hook uses `tracemalloc`, which is useful for Python allocation
diagnostics but does not measure total process RSS, native BLAS allocations, GPU
memory, or embedded RAM. BSEBench should preserve separate fields instead of
normalizing them into one `memory_peak_mb` without a backend tag:

- `python_tracemalloc_peak_bytes`: Python allocation peak;
- `process_peak_rss_bytes`: OS process resident set peak;
- `accelerator_peak_bytes`: GPU/accelerator memory, if measured;
- `embedded_static_ram_bytes`: compiled target evidence, if available;
- `memory_backend`: required enum naming the backend.

Stats aggregation may expose a convenience `memory_peak_mb`, but only after
retaining `memory_backend`, `memory_scope`, and `evidence_tier` in each record.

### 4. FLOPs and operation counts are Tier 3, not measured runtime

FLOPs should be accepted only when the counting method is auditable. Required
fields:

- `operation_count_kind`: `flops`, `macs`, `matrix_ops_formula`,
  `model_graph_ops`, or `custom_counter`;
- counting script or formula identifier plus git/file hash;
- input shape and sample length;
- whether branches, adaptive iteration counts, sparse operations, and failed
  steps are included;
- whether nonlinear function calls, lookup tables, or OCV interpolation are
  excluded.

For classical filters, a formula by state dimension and update path may be more
honest than a fake FLOP number. For AI estimators, graph MACs should be reported
with model hash and input shape. Do not convert FLOPs to runtime or cost without
a calibrated hardware model.

### 5. ROM/RAM is Tier 4 only with build artifacts

ROM/RAM fields are allowed only when backed by target-specific artifacts. A
Python object size, package wheel size, or author statement is not ROM evidence.
Minimum fields:

- target architecture and board or simulator;
- compiler/interpreter/toolchain version and flags;
- source commit and dependency lock;
- binary, map file, or compiled module hash;
- extraction command for text/data/bss/heap/stack estimates;
- whether lookup tables and model weights are included.

Monthly public reports should group Tier 4 evidence by target family rather than
mixing MCU, desktop, and accelerator footprints.

### 6. Aggregation must be stratified by evidence tier

Stats helpers should aggregate only records that share compatible scope and tier.
Recommended report shape:

```yaml
compute_cost_summary:
  schema_version: bsebench.compute_cost_summary.v1
  aggregation_policy: stratified_by_scope_tier_backend
  groups:
    - scope: estimator_step
      evidence_tier: 1
      backend: time.perf_counter_ns
      hardware_profile_id: cpu-linux-x86_64-...
      runtime_seconds:
        n_records: 25
        repeat_policy: median_of_repeats
        median: 0.00123
        iqr: [0.00118, 0.00131]
      comparability: same_hardware_only
    - scope: estimator_step
      evidence_tier: 3
      backend: static_formula
      operation_count_kind: matrix_ops_formula
      comparability: formula_scope_only
```

If a compute table must combine methods with different evidence tiers, it should
show coverage and caveats, not a sorted leaderboard. Missing compute evidence is
a report-quality gap, not proof that a method is cheap or expensive.

### 7. Billing or cloud cost is optional operations metadata

`cost_usd` can help operators estimate CI or public benchmark expenses, but it
is not a scientific algorithm property. It depends on provider, pricing date,
region, instance type, queue behavior, and caching. If included, it requires a
pricing source timestamp and must remain separate from algorithm compute-cost
evidence.

## Minimum Compute Record Contract

Future runner artifacts should emit one record per `(method, dataset config,
repeat, scope)`:

```yaml
schema_version: bsebench.compute_cost_record.v1
method_id: example_filter
config_id: yao-BCDC-T25
scope: estimator_step
evidence_tier: 1
repeat_index: 0
n_warmup: 1
n_steps: 3000
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
hardware_profile_id: cpu-linux-x86_64-redacted-host-v1
environment:
  os: linux
  python: "3.12"
  runner_git_sha: required
  stats_git_sha: required_if_aggregated
  dependency_lock_sha256: required
comparability: same_hardware_only
limitations:
  - tracemalloc excludes native allocations and device memory
```

Stats-side aggregation should fail loud if required fields for the chosen tier
are absent or if records with incompatible `scope`, `evidence_tier`, or
`memory_backend` are aggregated without an explicit stratification policy.

## Validation Commands

Commands executed or used for this audit:

```bash
git status --short --branch
sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md
sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md
rg -n "profil|runtime|wall|memory|rss|FLOP|compute|cost|resource" \
  /mnt/c/doctorat/bsebench-org/bsebench-runner/src \
  /mnt/c/doctorat/bsebench-org/bsebench-runner/tests \
  /mnt/c/doctorat/bsebench-org/bsebench-runner/scripts
rg -n "profil|runtime|wall|memory|rss|FLOP|compute|cost|resource" \
  /mnt/c/doctorat/bsebench-org/bsebench-stats/src \
  /mnt/c/doctorat/bsebench-org/bsebench-stats/tests \
  /mnt/c/doctorat/bsebench-org/bsebench-stats/scripts
rg -n "profil|runtime|wall|memory|rss|FLOP|op_count|compute|cost|metadata|resource" \
  src tests scripts
git diff --check
```

Observed validation status:

- Target branch: `phase-8-2-d-compute-cost-reproducibility-audit-20260507T193528Z`.
- Current runner main inspection: no merged profiling hook found.
- Phase 8 runner compute worktree inspection: profiling hook found, including
  wall-time and Python `tracemalloc` fields.
- Current stats checkout inspection: no merged compute-cost helper found.
- Phase 8 stats compute worktree inspection: compute aggregation helper found,
  including runtime, memory, cost, FLOP aliases, coverage, and summaries.
- `git diff --check` and `git diff --cached --check`: PASS for this doc-only
  branch.

## Residual Risks

- The Phase 8 runner and stats compute worktrees inspected here were not merged
  mainline at audit time, so this report should be rechecked after integration.
- `tracemalloc` may perturb timing and does not capture native allocations.
  BSEBench should allow memory profiling to be enabled separately from timing.
- Repeated wall-time measurements can still be noisy under WSL, laptops,
  thermal throttling, background load, and dynamic CPU frequency.
- FLOP estimates for adaptive filters and hybrid AI methods can hide dynamic
  branches unless the counting scope is explicit.
- Embedded ROM/RAM evidence can become stale when compiler flags, lookup tables,
  or model weights change.
- A future public report could still misuse compute metadata by sorting mixed
  tiers together. CI/report checks should enforce tier stratification.

## Explicit Non-Claims

- This audit does not claim any estimator is faster, cheaper, more deployable,
  or more accurate than another.
- This audit does not verify a hardware-independent compute metric.
- This audit does not validate any SOTA, novelty, leaderboard, breakthrough, or
  scientific claim.
- This audit does not update thesis, manuscript, roadmap, `claim_55`, or
  `claims/registry.yaml` content.
- This audit does not assert that the Phase 8 runner or stats worktrees are
  complete or merge-ready.
