# CTO merge validation for phase-6-11-d-friedman-nemenyi-stats-fix-1

- Decision: merged by CTO override
- Decided at: 2026-05-07T00:51:53Z
- Actor: codex-FR [role: cto-codex-FR]
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- Merged branch: `origin/phase-6-11-d-friedman-nemenyi-stats-fix-1`
- Merged SHA: `e32b72d3a42857a81e284b29bafb96804abb1998`
- Merge method: clean detached worktree, fast-forward push to `origin/main`

## Why override chef `needs_fix`

The chef verdict failed before running tests:

```text
error: Failed to spawn: `pytest`
```

This was traced to chef using `uv run pytest` without installing optional test
tools. The chef gate has since been patched in `57a35fd` to use
`uv run --all-extras`.

## Validation evidence

- Worker verification:
  - `uv run pytest tests/test_friedman_nemenyi.py -q --tb=short`: 6 passed.
  - `uv run pytest -m "not slow" --tb=short`: 18 passed.
  - `uv run ruff format --check .`: passed.
  - `uv run ruff check .`: passed.
- CTO clean worktree validation with `UV_LINK_MODE=copy uv run --all-extras`:
  - focused tests: 6 passed.
  - full non-slow tests: 18 passed.
  - ruff format/check passed.
- Independent validator Locke: GO.

## Residual risk

The validator noted a non-blocking boundary convention: `nemenyi_test` uses
`>= critical_difference`, while an older helper used `> critical_difference`.
This can be harmonized in a later stats polish phase if needed; it is not a
blocker for the current API and tests.
