---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-5-b-runner-residual-trace-export
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-filters
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 40
---

# Phase 7.5.b - runner residual trace export helper

## Mission

Add a reusable runner-side helper that returns voltage residual traces per
config and per filter. This is the execution-side prerequisite for Phase 7.6
residual covariance runs, while `phase-7-5-a` owns the statistics-only
covariance calculations in `bsebench-stats`.

This is tooling only. Do not verify or update claim_55 here.

## Source references

Read first:

- `src/bsebench_runner/orchestrator.py`
- `src/bsebench_runner/metrics.py`
- `scripts/chi2_smoke_yao_bcdc_t25.py` (`run_filter_trace`, loader truncation)
- `scripts/chi2_sweep_5x5.py` (5-config target list and fail-loud evidence
  policy)
- `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch/phase60_residual_cov.py`

## Deliverable

Add a small API, preferably `src/bsebench_runner/residuals.py`, that can:

- load/truncate one config through an adapter loader;
- run selected filter factories on that config;
- return measured voltage, predicted voltage, and residual trace in millivolts;
- apply a configurable warmup/burn-in and record the retained sample count;
- handle per-filter failures without fabricating residual evidence.

Suggested public shape:

```python
run_residual_traces(
    data: Mapping[str, Any],
    filter_factories: Mapping[str, Callable[[], Any]],
    *,
    t_c: float,
    warmup_samples: int = 100,
) -> dict
```

It may be lower-level than this if it fits the local code better. Keep it
small, testable, and JSON-serializable.

## Tests

Add fast synthetic tests, no real dataset dependency:

- two simple filters with known voltage bias produce expected residual mV
  arrays after warmup;
- mismatched `t`, `V`, `I`, `T_meas` lengths raise clear `ValueError`;
- empty filters or invalid warmup raise clear `ValueError`;
- a failing filter is reported as `error` without creating a residual array;
- output JSON serializes with `allow_nan=False`.

## Acceptance gates

- G1: focused tests pass.
- G2: `uv run --all-extras pytest -m "not slow" --tb=short` passes.
- G3: `uv run --all-extras ruff format --check .` passes.
- G4: `uv run --all-extras ruff check .` passes.
- G5: no real-data output committed.
- G6: no claim registry, roadmap, README, or thesis prose edits.
- G7: commit uses GLASSBOX with `[role: worker-codex-FR]`.
- G8: no `Co-Authored-By: Claude` trailer.

## Out of scope

- No covariance/correlation calculation; that belongs to `phase-7-5-a`.
- No plotting.
- No claim_55 verdict, no mechanism conclusion.
- No all-skipped or all-error JSON committed as evidence.

## If blocked

Write `outbox/phase-7-5-b-runner-residual-trace-export/BLOCKED.md` with the API
or filter-interface ambiguity and the smallest next step.
