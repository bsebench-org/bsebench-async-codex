# Phase 22 Stable Panel Candidate Report

Date: 2026-05-10

## Objective

Build a stable benchmark panel candidate from Phase 20 sentinel diagnostics and
Phase 21 trace coverage, without selecting configs post-hoc.

The phase answers one question: can the current full filter/config panel be used
as a strict benchmark panel?

## Definition Of Done

- Consume the Phase 20 sentinel diagnostics artifact.
- Consume the Phase 21 sentinel trace manifest.
- Mark configs eligible only if they have zero sentinel cells, zero missing
  filter cells, and zero unresolved sentinel traces.
- Emit a strict JSON gate with included/excluded configs.
- Keep `NO_CLAIM` if the panel is incomplete.

## Implementation

`bsebench-stats` changed:

- `src/bsebench_stats/phase22_stable_panel_candidate.py`
  - new strict panel inventory/gate;
  - consumes Phase 20 `complete_panel_blockers`;
  - consumes Phase 21 `sentinel_trace_cells`;
  - blocks current ranking when any unresolved sentinel trace remains.
- `scripts/phase22_stable_panel_candidate.py`
  - CLI wrapper.
- `tests/test_phase22_stable_panel_candidate.py`
  - synthetic pass/block tests plus real artifact validation.
- `src/bsebench_stats/__init__.py`
  - exports Phase 22 builder/runner.

## Artifact

`bsebench-stats/outputs/phase22_stable_panel_candidate_20260510.json`

SHA-256:

`2757c546bcfa2304d5af62cf03dc8c79bbd189ea947b7fae718ddf2d61a03705`

Summary:

- schema: `phase22_stable_panel_candidate_v1`;
- phase: `22`;
- task: `P22-01`;
- diagnostic only: `true`;
- claim status: `NO_CLAIM`;
- config count: `16`;
- eligible config count: `0`;
- excluded config count: `16`;
- sentinel cell count: `48`;
- unresolved trace count: `48`;
- minimum complete configs required: `3`;
- gate: `blocked_no_stable_panel`.

Blocking gaps:

- `insufficient_strict_complete_configs`;
- `unresolved_sentinel_traces`;
- `sentinel_cells_in_candidate_source`.

## Validation

Commands:

```bash
./.venv/bin/ruff format src/bsebench_stats/phase22_stable_panel_candidate.py scripts/phase22_stable_panel_candidate.py tests/test_phase22_stable_panel_candidate.py src/bsebench_stats/__init__.py
./.venv/bin/ruff check src/bsebench_stats/phase22_stable_panel_candidate.py scripts/phase22_stable_panel_candidate.py tests/test_phase22_stable_panel_candidate.py src/bsebench_stats/__init__.py
./.venv/bin/pytest tests/test_phase22_stable_panel_candidate.py -q
./.venv/bin/python scripts/phase22_stable_panel_candidate.py --phase20 ../bsebench-runner/outputs/phase20_sentinel_diagnostics_20260509.json --phase21 ../bsebench-runner/outputs/phase21_sentinel_trace_manifest_20260510.json --output outputs/phase22_stable_panel_candidate_20260510.json
./.venv/bin/ruff format --check src/bsebench_stats/phase22_stable_panel_candidate.py scripts/phase22_stable_panel_candidate.py tests/test_phase22_stable_panel_candidate.py src/bsebench_stats/__init__.py
git diff --check
```

Results:

- targeted tests: `3 passed`;
- ruff check: passed;
- format check: passed;
- diff check: passed;
- CLI exit code: `2`, expected because the current strict panel is blocked.

## Scientific Verdict

The current full 10-filter, 16-config panel is not stable enough for benchmark
ranking:

- no config is complete under the strict zero-sentinel policy;
- all 48 sentinels are unresolved historical cells;
- no BSE-Score or ranking may be computed from this panel.

This closes Phase 22 as a negative but useful gate: the panel candidate is
audited, and the current panel is formally blocked.

## Next Phase

Phase 23 may freeze the three method families and their contracts, but it must
not claim that the current panel is executable. The method freeze should define
what will be rerun and how unresolved cells are handled before any final score.
