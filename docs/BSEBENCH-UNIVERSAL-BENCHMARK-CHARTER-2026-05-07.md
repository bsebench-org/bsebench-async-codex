# BSEBench Universal Benchmark Charter

Saved: 2026-05-07. Scope: product and scientific north star for BSEBench.

## Core Objective

BSEBench is not only a project to beat a specific filter or claim a single
leaderboard result. The long-term objective is to become the open, universal
evaluation standard for battery state estimation algorithms:

- equivalent in spirit to ImageNet or CodeBench, but for SOC/SOH estimation;
- usable by the scientific community to benchmark ECMs, Kalman filters,
  observers, AI estimators, hybrid methods, and future algorithms;
- capable of validating and ranking a new filter or ECM without requiring the
  contributor to rewrite dataset loaders, metrics, split logic, or evaluation
  code;
- suitable for recurring public benchmark reports, including monthly community
  snapshots when the infrastructure is mature.

## Universal Design Principle

Every architecture, API, runner, dataset adapter, metric, and report must pass
this question:

> Does this make BSEBench more universal, or does it introduce dependence on a
> specific paper, chemistry, dataset, filter, or one-off use case?

If the answer is "specific use case", the implementation must isolate that
specificity behind a general interface, a fixture, or a clearly marked adapter.

## Pillar 1: Exhaustive Evaluation Matrix

BSEBench must evaluate real BMS viability, not only mean accuracy.

### Accuracy

Required metrics should include, at minimum:

- RMSE;
- MAE;
- MAXE, because maximum absolute error is safety-relevant;
- per-profile and per-cell distributions, not only aggregate means.

### Reliability

The benchmark should measure whether an estimator recovers and remains stable:

- convergence speed after an intentionally wrong initial SOC;
- tolerance to Gaussian and non-Gaussian measurement noise;
- resilience to ECM parameter drift;
- failure modes and invalid-output handling.

### Computational Cost

The benchmark should expose deployability constraints:

- execution time per iteration;
- memory footprint when practical;
- ROM/RAM-relevant implementation metadata when available;
- FLOPs or hardware-agnostic operation counts when practical.

### Generalization

The benchmark must test whether a method generalizes beyond a narrow setting:

- chemistry axis, including LFP, NMC, NCA, and Si-C where supported;
- profile axis, including dynamic and low-excitation regimes;
- temperature axis;
- aging/SOH axis;
- cross-chemistry transfer when a method is tuned on one domain and evaluated
  on another.

## Pillar 2: Methodological Integrity Guards

BSEBench must make cheating, leakage, and accidental bias difficult.

### Ground Truth

SOC/SOH references must be auditable. Where possible, SOC ground truth should
be based on coulomb counting recalibrated by OCV rest points or an explicitly
documented equivalent.

### Anti Data Leakage

The framework must enforce separation between:

- identification/calibration of ECM parameters;
- training/tuning of algorithm hyperparameters;
- blind evaluation/inference.

Reports must state which data was used for each stage.

### ETL and Harmonization

Dataset ingestion must handle raw laboratory formats without forcing algorithm
authors to write loaders:

- Arbin, Maccor, and other equipment outputs where supported;
- synchronized `V`, `I`, `T`, and `dt` vectors;
- documented interpolation and resampling policy;
- explicit provenance and cache identity.

### Forced Degraded Initialization

Benchmark protocols should include a controlled wrong initial state, for
example SOC initialized at 50 percent when the true value is near 90 percent.
This tests recovery, not only steady-state tracking.

## Pillar 3: Plug-and-Play Algorithm Contract

The API must make new estimators easy to evaluate.

The target contributor experience:

1. Implement or wrap a minimal estimator interface, such as:

   ```python
   step(voltage, current, temperature, dt) -> estimated_soc
   ```

2. Optionally expose initialization, reset, metadata, and SOH outputs through
   standard hooks.
3. Run BSEBench protocols without touching dataset loading, split handling,
   metric computation, or report generation.

The runner should decouple:

- estimator implementation;
- dataset loading;
- ECM parameter identity;
- protocol selection;
- metric computation;
- report and leaderboard formatting.

## Pillar 4: Community Benchmark Workflow

BSEBench should support a recurring public workflow:

- contributors submit a method adapter or ECM definition;
- BSEBench runs standard protocols across available datasets;
- results are validated by provenance, split, and leakage checks;
- public releases pass the
  [benchmark release checklist](BSEBENCH-PUBLIC-BENCHMARK-RELEASE-CHECKLIST-2026-05-07.md);
- monthly benchmark snapshots can rank or group methods by multiple criteria;
- reports must include caveats, missing data, and invalid comparability cases.

The goal is not a single simplistic leaderboard. It is a multi-axis benchmark
that can answer: accurate for what chemistry, under what profile, at what
compute cost, with what robustness and what evidence quality?

## Relationship to the Research Roadmap

The existing Phase 7 to Phase 17 roadmap remains the scientific discovery
roadmap. This charter adds the product/scientific standard objective that
surrounds the roadmap:

- Phase 7 validates Hinf evidence rigor and anti-claim safeguards.
- Phase 8 to Phase 12 broaden BSEBench across chemistry, profile, aging,
  residual decomposition, and transfer axes.
- Phase 13 to Phase 15 add stronger method families and adaptation paths.
- Phase 16 to Phase 17 consolidate claims, limitations, and the public-facing
  benchmark standard.

Autonomous tasks must not change the scientific roadmap or claim registry just
because this charter exists. They should use it to choose better engineering
and validation tasks.

## Non-Negotiable Implementation Rule

Before adding a class, function, CLI, metric, adapter, or report field, ask:

1. Does this reduce the amount of code a future researcher must write?
2. Does this improve comparability across datasets, chemistries, profiles,
   aging states, or algorithm families?
3. Does this prevent leakage, overfitting, hidden assumptions, or false claims?
4. Does this keep algorithm code decoupled from evaluation machinery?
5. Does this make monthly community benchmarking easier and more auditable?

If none of these is true, the task is likely busy work or a one-off artifact.
