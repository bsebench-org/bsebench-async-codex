# GLASSBOX Compute Reproducibility PR Gate

Saved: 2026-05-07T21:36:56Z
Worker: W6-07
Wave: 6 red-team, merge hardening, and alpha-release preparation
Scope: PR gate artifact only
Owned path: `gates/compute/compute-reproducibility-pr-gate-20260507T213656Z.md`

## Objective

Define the PR gate that must be applied before publishing, merging, or citing
BSEBench timing, RAM, FLOP, cost, or deployment-footprint claims. The gate keeps
compute-cost evidence comparable by requiring explicit evidence tiers,
measurement scopes, hardware or backend identities, and fail-loud aggregation.

This is a control artifact. It does not implement runner code, stats code,
leaderboard logic, thesis prose, manuscript prose, claim registry content,
`claim_55`, or the scientific roadmap.

## Evidence Inspected

- `specs/universal/compute-evidence-tier-spec-20260507T204627Z.md` from async
  compute-tier branch `21f532d0afba3b659b664761f455309989e3d948`.
  Relevant contract: C0 missing/declarative, C1 wall-time telemetry, C2 memory
  telemetry, C3 operation counts, C4 embedded ROM/RAM build evidence, and C5
  calibrated hardware models are distinct evidence classes and must not be
  collapsed into one compute score.
- `audits/methodology/compute-cost-reproducibility-20260507T193528Z.md` from
  async integration branch `phase-8-4-d-async-universal-docs-integration-20260507T213125Z`.
  Relevant finding: wall time, memory telemetry, operation counts, and ROM/RAM
  build artifacts require different source evidence and report caveats.
- Runner integration branch
  `/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`
  at `e0664de6e02dd45832068de427666dbcc2bd3d10`.
  Inspected hook: `src/bsebench_runner/profiling.py` exposes
  `STEP_PROFILING_SCHEMA_VERSION = "bsebench.step_profiling.v1"`,
  `EstimatorStepProfiler`, `time.perf_counter_ns` timing, and Python
  `tracemalloc` fields such as `memory_traced_bytes_peak_max`.
- Runner tests on the same integration branch:
  `tests/test_profiling.py` and `tests/test_orchestrator.py` verify profiling
  metadata, failed-step marking, traced-memory metadata, and default
  orchestrator emission. These tests establish hook presence, not public
  comparability by themselves.
- Stats integration branch
  `/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z`
  at `08d7c2cef00a1830ac908310535e2320c41d2276`.
  Inspected helper: `src/bsebench_stats/compute_cost.py` exposes
  `aggregate_compute_costs` and `aggregate_compute_cost_metadata`, with runtime,
  memory, cost, and FLOP aliases plus coverage summaries.
- Stats tests on the same integration branch:
  `tests/test_compute_cost.py` verifies required positive runtime, optional
  memory/cost/FLOP coverage, nested compute-profile aliases, and rejection of
  invalid numeric values.

## Commands Run

```bash
pwd && git status --short --branch
rg --files -g '*compute*' -g '*evidence*' -g '*tier*' -g '*runner*' -g '*stats*'
find . -maxdepth 3 -type d \( -name gates -o -name runner -o -name runners -o -name stats -o -name benchmarks -o -name claims -o -name docs \) | sort
find /mnt/c/doctorat/bsebench-org -maxdepth 1 -type d -printf '%f\n' | sort
rg -n "compute|FLOP|flop|RAM|memory|runtime|timing|duration|evidence tier|tier|source ledger|runner|stats" docs cto inbox/phase-7-10* inbox/phase-7-8* inbox/phase-7-9* README.md HISTORY.md
sed -n '1,620p' specs/universal/compute-evidence-tier-spec-20260507T204627Z.md
sed -n '1,540p' audits/methodology/compute-cost-reproducibility-20260507T193528Z.md
sed -n '1,260p' src/bsebench_runner/profiling.py
sed -n '1,260p' tests/test_profiling.py
rg -n "profil|compute|runtime_seconds|wall_time|tracemalloc|compute_cost|FLOP|flops|memory_peak" src tests scripts pyproject.toml README.md
sed -n '1,280p' src/bsebench_stats/compute_cost.py
sed -n '1,220p' tests/test_compute_cost.py
rg -n "compute|compute_cost|runtime_seconds|memory_peak|flops|wall_time|tier|evidence" src tests scripts pyproject.toml README.md
git diff --check
```

## Gate Rule

A PR may expose compute numbers in public reports only when every displayed
number can be traced to a compute evidence record with:

- `schema_version`
- method or estimator identity
- dataset/config identity
- `measurement_scope`
- `compute_evidence_tier`
- repeat policy, including `repeat_index`, `n_repeats`, and `n_warmup` where
  repeats are claimed
- status and error handling policy
- backend identity for the measured field
- hardware profile, target profile, or formula identity required by the tier
- source commit and dependency lock identity for the artifact producer
- explicit comparability caveat

If any required field is absent, the PR must either remove the compute claim or
label the entry as C0 missing/declarative and omit it from compute sorting.

## Required PR Checklist

Every PR that adds or changes compute evidence, compute aggregation, benchmark
reports, monthly snapshots, public tables, or claim-adjacent wording must answer
these checks in the PR description.

| Check | Required answer | Reject if |
| --- | --- | --- |
| Evidence tier | List the tier for each compute field: C0, C1, C2, C3, C4, or C5. | A timing, RAM, FLOP, cost, or deployment-footprint number has no tier. |
| Measurement scope | Name exactly one scope per record: `estimator_step`, `estimator_episode`, `full_benchmark_run`, or `training_or_calibration`. | Inference, loader, full run, and training costs are mixed or unnamed. |
| Backend identity | Name `timer_backend`, `memory_backend`, `operation_count_kind`, embedded target/toolchain, or calibration model as applicable. | A generic `memory_peak_mb`, `runtime`, or `flops` value is shown without its backend or counting method. |
| Platform identity | Provide `hardware_profile_id` for C1, C2, and C5; target/toolchain identity for C4; formula/input-shape identity for C3. | Cross-platform comparison is implied from one hardware profile, target, or formula. |
| Repeat policy | Provide repeat count, warmup count, aggregation statistic, and handling for failed repeats. | A single noisy run is reported as a stable result without caveat. |
| Stratification | Show grouping keys used by stats aggregation. | Aggregation combines incompatible tiers, scopes, memory backends, hardware profiles, target families, or input shapes. |
| Missing evidence | Count C0 records and state their report treatment. | Missing evidence is hidden, treated as zero, or sorted beside measured evidence. |
| Source ledger | Provide source ledger rows for any external compute numbers, cloud prices, literature comparisons, or cross-system claims. | External or cross-system compute claims appear without stable source, retrieval date, metric, dataset/split, and comparability label. |
| Public wording | Use tier-scoped wording only. | The PR says or implies "fastest", "cheapest", "MCU-ready", "deployment-proven", "hardware-independent runtime", "leaderboard winner", or "verified compute claim" without the stronger evidence required below. |

## Tier-Specific Acceptance Cases

### C0 Missing Or Declarative

Accept when:

- the record is explicitly labeled `compute_evidence_tier: C0`;
- `missing_reason` is present;
- reports show it as missing/declarative evidence;
- the value is omitted from compute sorting and ranking.

Reject when:

- missing evidence is omitted from coverage tables;
- missing evidence is represented as zero runtime, zero memory, zero cost, or
  zero operations;
- author README claims such as "fast" or "low memory" are treated as measured
  evidence.

### C1 Wall-Time Telemetry

Accept when:

- timing comes from a declared timer backend, preferably
  `time.perf_counter_ns`;
- the record declares `measurement_scope`;
- `n_steps`, repeat policy, warmup policy, environment, runner commit, and lock
  identity are recorded;
- `hardware_profile_id` is present;
- public wording states same-hardware and same-scope comparability only.

Reject when:

- wall time is described as hardware-independent;
- WSL, operating system, CPU/GPU, BLAS thread count, thermal state, or
  dependency-lock changes are ignored while comparing C1 evidence;
- loader or full-run time is mixed with estimator-step time;
- nanosecond storage is turned into false-precision prose.

Runner-hook note: the inspected runner hook is C1 evidence for estimator-step
timing only when its emitted metadata is bound to a hardware profile, environment
manifest, repeat policy, and report caveat.

### C2 Memory Telemetry

Accept when:

- `memory_backend` and `memory_scope` are explicit;
- backend-specific fields are preserved, for example
  `python_tracemalloc_peak_bytes`, `process_peak_rss_bytes`,
  `accelerator_peak_bytes`, or `embedded_static_ram_bytes`;
- aggregation groups by backend, scope, platform class, and measurement scope;
- limitations of the backend are visible in the report.

Reject when:

- Python `tracemalloc` data is presented as total process RSS, GPU memory, or
  embedded RAM;
- a convenience field such as `memory_peak_mb` replaces backend-specific
  provenance;
- memory values from different backends or platforms are averaged together.

Runner-hook note: the inspected runner hook records Python `tracemalloc`
allocation telemetry. It is useful C2 evidence for Python allocation behavior,
not process RSS, native allocation, accelerator memory, or embedded RAM.

### C3 Operation Counts, FLOPs, MACs, Or Formula Counts

Accept when:

- the record declares `operation_count_kind`;
- `operation_count_total` has units;
- a counting script, graph extraction command, formula id, source hash, input
  shape, state dimension, and branch policy are recorded;
- include/exclude rules cover nonlinear calls, lookup tables, adaptive
  iterations, failed steps, sparse operations, and interpolation where relevant.

Reject when:

- a FLOP or MAC number is unaudited;
- classical filters receive fake precision without a formula and state
  dimension;
- neural graph counts omit model hash or input shape;
- operation counts are converted to seconds, dollars, or deployment readiness
  without C5 calibration.

### C4 Embedded ROM/RAM Build Evidence

Accept when:

- the PR includes target architecture, board or simulator, target family,
  toolchain version, flags, source commit, dependency lock hash, and binary or
  map-file hash;
- extraction commands for text, data, bss, heap, stack, and model-weight or
  lookup-table inclusion policy are recorded;
- report grouping is by target family and toolchain.

Reject when:

- Python object size, wheel size, source line count, or README metadata is used
  as ROM/RAM evidence;
- build artifacts or map-file hashes are absent;
- MCU, desktop, WSL, and accelerator footprints are mixed in one table.

### C5 Calibrated Hardware Model

Accept when:

- C1 telemetry plus C3 operation counts or C4 footprint evidence are tied to a
  named calibration platform;
- calibration data, script, source hashes, repeat policy, calibration date, and
  error bounds are reported;
- applicability limits are explicit.

Reject when:

- calibrated estimates are shown without residual/error bounds;
- the calibration platform differs from the reported platform without a new
  calibration;
- the estimate is described as universal runtime.

## Stats Aggregation Gate

Stats aggregation must fail loud before writing a public compute summary unless
all records in each aggregate group share compatible:

- `measurement_scope`;
- `compute_evidence_tier`;
- `timer_backend` for C1 timing groups;
- `memory_backend` and `memory_scope` for C2 memory groups;
- `operation_count_kind`, formula id, input shape, and state dimension for C3
  groups;
- target family, toolchain, flags, and artifact type for C4 groups;
- calibration platform and model id for C5 groups;
- `hardware_profile_id` for C1, C2, and C5;
- source commit and dependency lock identity, or a documented compatibility
  waiver.

The inspected stats helper currently summarizes runtime, memory, cost, and FLOP
aliases with coverage. For public reports, the PR gate requires a wrapper,
schema, or caller policy that stratifies by the keys above before using those
summaries.

## Report Acceptance Cases

Accept these report patterns:

- "C1 estimator-step wall-time telemetry on hardware profile X: median and IQR
  over N repeats."
- "C2 Python `tracemalloc` allocation telemetry is present; native allocations,
  process RSS, device memory, and embedded RAM are not measured."
- "C3 matrix-operation formula counts are available under formula id X, state
  dimension Y, and branch policy Z."
- "C4 ROM/RAM build evidence is available for target family X and toolchain Y."
- "Compute evidence is missing for method/configuration X and is excluded from
  compute sorting."

Reject these report patterns unless the PR includes stronger tier-compatible
evidence and source-ledger support:

- "hardware-independent runtime";
- "fastest method";
- "cheapest method";
- "MCU-ready";
- "deployment-proven";
- "leaderboard winner";
- "verified compute claim";
- precise cross-hardware percentages or dollar comparisons;
- mixed C1/C2/C3/C4/C5 sorted leaderboards;
- C0 entries sorted with measured entries.

## Merge Decision

Use this gate as follows:

- `approve`: all compute values have tier, scope, backend/platform identity,
  stratified aggregation, coverage for missing evidence, and tier-scoped public
  wording.
- `needs_fix`: evidence exists but fields, grouping keys, caveats, or PR
  checklist answers are incomplete.
- `block`: public wording makes unsupported compute, SOTA, novelty,
  leaderboard, breakthrough, or verified-claim statements; aggregation mixes
  incompatible evidence; or C0 evidence is sorted as measured evidence.

No compute PR should be used as scientific claim support until the evidence
bundle, source ledger, report wording, and claim registry process are complete.

## Validation Status

- Inspected compute evidence tier spec: PASS.
- Inspected compute-cost reproducibility audit: PASS.
- Inspected runner profiling hooks and tests: PASS.
- Inspected stats compute-cost aggregator and tests: PASS.
- Defined acceptance and rejection cases: PASS.
- `git diff --check`: PASS.

## Explicit Non-Claims

- This gate does not claim that any estimator is faster, cheaper, more
  deployable, more accurate, or more robust than another.
- This gate does not verify hardware-independent timing, RAM, FLOPs, ROM/RAM,
  or cost.
- This gate does not validate any SOTA, novelty, leaderboard, breakthrough, or
  scientific claim.
- This gate does not update thesis, manuscript, roadmap, `claim_55`, or
  `claims/registry.yaml` content.
- This gate does not assert that Wave 5 integration branches are complete,
  correct, merged, or release-ready.
