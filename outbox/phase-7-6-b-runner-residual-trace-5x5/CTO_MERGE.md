# CTO merge: phase-7-6-b-runner-residual-trace-5x5

- Decision: approved / merged
- Decided at: 2026-05-07T01:54:00Z
- Decided by: chef-FR + codex-FR [role: codex-cto-FR]
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-runner`
- Main SHA after merge: `d32f0e4cf55fed460c5788c1796febe1a39694b2`

## Validation

- Worker summary: codex exit `0`, push OK.
- Chef verdict: approved and merged to main at `d32f0e4`.
- CTO local gates:
  - `uv run --locked --all-extras pytest tests/test_residual_trace_5x5.py -q --tb=short` -> `7 passed`
  - `uv run --locked --all-extras pytest -m "not slow" --tb=short` -> `73 passed, 5 deselected`
  - `uv run --locked --all-extras ruff format --check .` -> OK
  - `uv run --locked --all-extras ruff check .` -> OK
- Independent validator Mendel: GO.

## Scope

- Added runner-side 5x5 residual trace producer script and fast synthetic tests.
- Output schema is compatible with stats 7.6.a consumer:
  `schema_version`, `script`, `config_labels`, `filter_labels`, `configs`,
  `retained_samples`, and `filters[*].residual_mV`.
- Measured voltage is emitted once per config; residual arrays are emitted only
  for ok filters.
- Loader/filter failures are recorded without fabricated residual arrays.
- Fail-loud requirements run before output writes; JSON writes use
  `allow_nan=False`.
- No real-data output evidence committed.
- No README, roadmap, claim registry, thesis prose, or scientific verdict edits.
- No `Co-Authored-By: Claude` trailer.

## Residual Risk

- The producer was not run on real adapters/checkpoints in this phase by design.
  Compatibility is validated by synthetic tests and inspection; real evidence is
  deferred to the next evidence-run phase.
