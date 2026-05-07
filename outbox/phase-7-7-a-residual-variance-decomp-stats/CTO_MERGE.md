# CTO merge: phase-7-7-a-residual-variance-decomp-stats

- Decision: approved / merged
- Decided at: 2026-05-07T02:14:32Z
- Decided by: chef-FR + codex-FR [role: codex-cto-FR]
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- Main SHA after chef merge: `58eacbcd38fa6e60b1431e0dd2933b1ab7237db2`

## Validation

- Worker summary: codex exit `0`, push OK.
- Chef verdict: approved and merged to main at `58eacbc`.
- Chef gates:
  - `uv run --locked --all-extras pytest tests/test_residual_decomp_runner.py -q --tb=short` -> `16 passed`
  - `uv run --locked --all-extras pytest -m "not slow" --tb=short` -> `67 passed`
  - `uv run --locked --all-extras ruff format --check .` -> OK
  - `uv run --locked --all-extras ruff check .` -> OK
- Panel check: PASS, average `94`.
- Independent validator Volta: GO.

## Scope

- Added stats-side residual variance decomposition runner for 7.6 trace payloads.
- Added synthetic tests for balanced 5x5 decomposition, dominance cases, alternate
  metrics, invalid residual arrays, duplicate labels, divergent ok-filter sets,
  fail-loud write ordering, JSON safety, and top-level exports.
- Failed filters are excluded without fabricated residual arrays.
- Decomposition is withheld when retained-config requirements fail.
- No `uv.lock` in commit.
- No README, roadmap, claim registry, thesis prose, or scientific verdict edits.
- No real-data output evidence committed.
- No `Co-Authored-By: Claude` trailer.

## Residual Risk

- This is a tooling primitive only. It does not prove or update any Hinf claim.
- Future Hinf evidence must not target thesis `claim_55` because read-only
  preflight found that `claim_55` is already the verified EnsembleMeta/MAD floor
  claim in the thesis registry.
- The next evidence phase must require multiple real ok configs explicitly and
  fail before writing if the trace payload is all-error, all-skipped, unbalanced,
  or contains non-finite residuals.
