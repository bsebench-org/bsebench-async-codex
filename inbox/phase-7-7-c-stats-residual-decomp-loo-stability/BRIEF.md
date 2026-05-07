---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-7-c-stats-residual-decomp-loo-stability
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 50
---

# Phase 7.7.c - residual decomposition leave-one-config-out stability

## Mission

Strengthen the stats-side residual variance decomposition primitive with a
deterministic leave-one-config-out stability summary for balanced retained
tables.

This is tooling only. Do not run real datasets and do not verify, retract, or
update any claim. Do not target thesis `claim_55`.

## Source references

Read first:

- `src/bsebench_stats/runners/residual_decomp.py`
- `tests/test_residual_decomp_runner.py`
- `src/bsebench_stats/runners/residual_cov.py`
- `/mnt/c/doctorat/bsebench-org/bsebench-runner/scripts/residual_trace_5x5.py`

## Deliverable

Add a small, JSON-safe leave-one-config-out stability section to the output of
`build_residual_variance_decomposition` when a balanced retained table exists.
Suggested key: `loo_config_stability`.

Expected contents:

- one entry per retained config omitted;
- omitted config label;
- recomputed decomposition shares for the remaining configs;
- filter effect deltas or a deterministic stability range for each filter;
- summary with min/max/range of `config_share`, `filter_share`, and
  `residual_or_interaction_share` across LOO runs.

If fewer than 3 retained configs are available, return an empty or clearly
documented stability section rather than overclaiming. Keep the existing
fail-loud behavior for requirements and divergent ok-filter sets.

## Constraints

- Do not change public defaults in a way that breaks existing callers.
- Do not add real-data outputs.
- Do not add random bootstrap unless deterministic and cheap; LOO is enough.
- Do not edit README, roadmap, claim registry, thesis prose, or scientific
  verdict text.
- Preserve JSON safety with `allow_nan=False`.

## Tests

Add focused synthetic tests:

- balanced 5 configs x 5 filters includes `loo_config_stability`;
- LOO summary has one omitted-config entry per retained config;
- decomposition share ranges are finite and JSON-safe;
- filter-effect stability remains keyed by the retained filter labels including
  synthetic `Hinf`;
- fewer than 3 retained configs handles stability explicitly without crashing;
- existing fail-loud tests still pass.

## Acceptance gates

- G1: focused residual decomposition tests pass.
- G2: `uv run --locked --all-extras pytest -m "not slow" --tb=short` passes.
- G3: `uv run --locked --all-extras ruff format --check .` passes.
- G4: `uv run --locked --all-extras ruff check .` passes.
- G5: no `uv.lock` committed.
- G6: no README, roadmap, claim registry, thesis prose, real output, or
  scientific verdict edits.
- G7: commit uses GLASSBOX with `[role: worker-codex-FR]`.
- G8: no `Co-Authored-By: Claude` trailer.

## Out of scope

- No real-data run.
- No plot.
- No Hinf claim verdict.
- No thesis/claim registry changes.

## If blocked

Write `outbox/phase-7-7-c-stats-residual-decomp-loo-stability/BLOCKED.md`
with the smallest ambiguity and a proposed narrower next step.
