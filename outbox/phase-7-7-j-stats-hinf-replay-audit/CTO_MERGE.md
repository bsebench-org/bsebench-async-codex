# CTO Merge: phase-7-7-j-stats-hinf-replay-audit

Status: approved

Actor: codex-cto-FR

UTC: 2026-05-07T05:09:15Z

Target repo: `bsebench-stats`

Target commit: `7d09a20`

## Scope

Stats-owned replay audit for the strict Hinf residual evidence bundle.

Changed:

- `scripts/replay_hinf_residual_stats.py`
- `tests/test_hinf_residual_stats_replay.py`

Left untouched:

- untracked `uv.lock`
- thesis registry/prose
- async roadmap

## Result

The new replay command reads
`../bsebench-runner/outputs/hinf_residual_evidence_5x5.json`, recomputes:

- `residual_covariance_panel`
- `residual_variance_decomposition`

from the embedded `trace` using the existing `bsebench-stats` APIs, then
recursively compares the embedded and replayed sections with tight numeric
tolerances.

The command exits nonzero on mismatch.

## Validation

- `uv run scripts/replay_hinf_residual_stats.py`
  - `residual_covariance_panel: ok (584 values compared)`
  - `residual_variance_decomposition: ok (498 values compared)`
- Focused tests:
  - `3 passed`.
- Full non-slow stats tests:
  - `72 passed`.
- Ruff:
  - `ruff check .` pass.
  - `ruff format --check .` pass.
- Independent validator Wegener:
  - GO.

## Boundary

No thesis registry edit.

No thesis prose edit.

No roadmap edit.

No `claim_55` update.

No scientific verdict assigned.
