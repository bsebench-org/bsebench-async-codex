# Phase 21 Sentinel Trace Instrumentation Report

Date: 2026-05-10

## Objective

Make sentinel failures mechanically traceable before any attempt to stabilize a
benchmark panel or rank methods.

Phase 21 does not try to infer hidden causes from old Phase 19/20 artifacts.
It adds instrumentation for future runs and creates a manifest proving whether
each historical sentinel has a mechanical trace.

## Definition Of Done

- The runner emits `phase21_failure_trace_v1` records for loader failures,
  invalid loader data, filter-step exceptions, and metric-level divergence
  sentinels.
- The trace includes config, filter, stage, reason, step index, last valid step,
  exception payload, and metric diagnostics when available.
- A Phase 21 manifest can match sentinel cells to failure traces by
  `(config_label, filter)`.
- Historical sentinel cells without traces are marked unresolved instead of
  guessed.
- Tests validate synthetic failure traces and the real Phase 19 artifact.

## Implementation

`bsebench-runner` changed:

- `src/bsebench_runner/orchestrator.py`
  - added `failure_traces` to `OrchestratorRunResult`;
  - records per-cell traces for loader failures;
  - records per-cell traces for invalid loader data;
  - records per-cell traces for filter-step exceptions;
  - records metric-level divergence traces when RMSE reaches the sentinel.
- `src/bsebench_runner/phase21_sentinel_trace_manifest.py`
  - new manifest builder and strict JSON writer;
  - consumes Phase 19 runner evidence and optional Phase 20 diagnostics;
  - matches sentinel cells to available `phase21_failure_trace_v1` entries.
- `scripts/phase21_sentinel_trace_manifest.py`
  - CLI wrapper.
- `tests/test_orchestrator.py`
  - validates emitted failure traces in synthetic diverging and loader-failure
    cases.
- `tests/test_phase21_sentinel_trace_manifest.py`
  - validates missing historical trace classification, trace matching, strict
    JSON writing, and the real Phase 19 count.

## Artifact

`bsebench-runner/outputs/phase21_sentinel_trace_manifest_20260510.json`

SHA-256:

`abb3ec84e60486466e706c5538d60cdadfb6d7980e94d03c461ab8b6ff6ca968`

Summary:

- schema: `phase21_sentinel_trace_manifest_v1`;
- phase: `21`;
- task: `P21-01`;
- diagnostic only: `true`;
- claim status: `NO_CLAIM`;
- sentinel cells: `48`;
- trace available: `0`;
- trace missing: `48`;
- unresolved causes: `48`;
- gate: `blocked_missing_historical_trace`.

## Validation

Commands:

```bash
uv run ruff format src/bsebench_runner/orchestrator.py src/bsebench_runner/phase21_sentinel_trace_manifest.py tests/test_orchestrator.py tests/test_phase21_sentinel_trace_manifest.py scripts/phase21_sentinel_trace_manifest.py src/bsebench_runner/__init__.py
uv run ruff check src/bsebench_runner/orchestrator.py src/bsebench_runner/phase21_sentinel_trace_manifest.py tests/test_orchestrator.py tests/test_phase21_sentinel_trace_manifest.py scripts/phase21_sentinel_trace_manifest.py src/bsebench_runner/__init__.py
uv run pytest tests/test_orchestrator.py tests/test_phase21_sentinel_trace_manifest.py -q
uv run python scripts/phase21_sentinel_trace_manifest.py --phase19 outputs/phase19_profile_axis_runner_evidence_20260509.json --phase20 outputs/phase20_sentinel_diagnostics_20260509.json --output outputs/phase21_sentinel_trace_manifest_20260510.json
uv run ruff format --check src/bsebench_runner/orchestrator.py src/bsebench_runner/phase21_sentinel_trace_manifest.py tests/test_orchestrator.py tests/test_phase21_sentinel_trace_manifest.py scripts/phase21_sentinel_trace_manifest.py src/bsebench_runner/__init__.py
git diff --check
```

Results:

- targeted tests: `15 passed`;
- ruff check: passed;
- format check: passed;
- diff check: passed;
- manifest CLI exit code: `2`, expected because historical traces are missing.

## Scientific Verdict

Phase 21 closes the instrumentation gap for future runs, but it does not resolve
the historical Phase 19 sentinel causes. The correct interpretation is:

- instrumentation readiness: passed;
- historical causal coverage: blocked;
- benchmark/ranking claim: still blocked;
- claim status: `NO_CLAIM`.

## Next Phase

Phase 22 should build a stable benchmark panel candidate. It must use the Phase
21 manifest as an input and must not include opaque sentinel cells in a ranking
panel. The clean options are:

1. rerun the 48 sentinel cells with Phase 21 instrumentation first; or
2. define a pre-registered panel that excludes unresolved cells with explicit
   reasons and keeps ranking disabled until the exclusions are accepted.
