# CTO merge: phase-7-5-a-residual-cov-stats

- Decision: approved / merged
- Decided at: 2026-05-07T01:26:00Z
- Decided by: chef-FR + codex-FR [role: codex-cto-FR]
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- Main SHA after merge: `ed27ef1797f07ec149c45227c3bd890fe66c3117`

## Validation

- Worker summary: codex exit `0`, push OK.
- Chef verdict: approved and merged to main.
- CTO local gates:
  - `uv run --all-extras pytest tests/test_residual_cov.py -q --tb=short` -> `8 passed`
  - `uv run --all-extras pytest -m "not slow" --tb=short` -> `38 passed`
  - `uv run --all-extras ruff format --check .` -> OK
  - `uv run --all-extras ruff check .` -> OK
- Independent validator Ptolemy: GO.

## Scope

- Added residual covariance/correlation primitives and tests.
- No `uv.lock` in commit.
- No README, roadmap, claim registry, thesis prose, or scientific verdict edits.
- No `Co-Authored-By: Claude` trailer.

## Note

Undefined correlations caused by constant residual columns are serialized as
`None`, not NaN. Aggregation currently propagates undefined pairs as `None`;
this is JSON-safe and should be documented/decided before using the aggregate
as final scientific evidence.
