# CTO merge override for phase-7-4-github-actions-ci-fix-1

- Decision: merged by CTO override
- Decided at: 2026-05-06T23:04:03Z
- Actor: codex-FR [role: cto-codex-FR]
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-datasets`
- Merged branch: `origin/phase-7-4-github-actions-ci-fix-1`
- Merged SHA: `a941b4a0538f53e4b9055d226af269f67f747a30`
- Merge method: fast-forward to `origin/main`

## Why override chef `needs_fix`

The chef gate failed before executing tests with:

```text
error: Failed to spawn: `pytest`
```

The worker branch workflow uses `uv run pytest`, not a bare `pytest`.
Independent validation reproduced the branch in a clean worktree and confirmed
that `uv sync --all-extras` installs `pytest`, `ruff`, `scipy`, and `h5py`.

## Validation evidence

- Worker verification: YAML parse, `uv sync --all-extras`, ruff format, ruff
  check, and `uv run pytest -m "not slow" --tb=short` with
  `222 passed, 29 deselected`.
- CTO clean worktree validation:
  - `UV_LINK_MODE=copy uv sync --all-extras`
  - `uv run python` confirmed `pytest` was available in `.venv/bin/pytest`.
  - `uv run ruff format --check .`
  - `uv run ruff check .`
  - `uv run pytest -m "not slow" --tb=short` with
    `222 passed, 29 deselected`.
- Independent validator Euclid: `GO`; found the chef failure was an
  environment/command mismatch, with residual risk limited to dropping Python
  3.11 from this focused workflow and not running GitHub-hosted Actions yet.

## Residual risk

This merge deliberately keeps the fix narrow to `.github/workflows/ci.yml`.
It does not change package metadata, source code, tests, or research claims.
