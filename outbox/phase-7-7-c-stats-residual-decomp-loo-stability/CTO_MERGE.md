# CTO merge: phase-7-7-c-stats-residual-decomp-loo-stability

- Decision: approved / merged
- Decided at: 2026-05-07T02:44:26Z
- Decided by: chef-FR + codex-FR [role: codex-cto-FR]
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- Main SHA after chef merge: `d7e86b72398e6785238797fabbb5c788d2294215`

## Validation

- Worker summary: codex exit `0`, push OK.
- Chef verdict: approved and merged to main at `d7e86b7`.
- Chef gates:
  - full non-slow -> `69 passed`
  - `ruff format --check .` -> OK
  - `ruff check .` -> OK
- Panel check: PASS, average `92`.
- Independent validator Parfit: GO.

## Scope

- Added deterministic `loo_config_stability` to balanced residual variance
  decomposition output.
- Added synthetic tests for 5x5 LOO runs, finite JSON-safe ranges, retained
  filter keys including `Hinf`, and `<3` retained config explicit status.
- No `uv.lock` committed.
- No README, roadmap, claim registry, thesis prose, real output, or scientific
  verdict edits.
- No `Co-Authored-By: Claude` trailer.

## Residual Risk

- Tests are synthetic and structural; real numerical evidence still depends on
  a successful strict 5x5 residual bundle.
