# CTO merge validation for phase-6-10-h-bsebench-runner-registry-swap-fix-1

- Decision: merged by CTO override
- Decided at: 2026-05-06T23:04:03Z
- Actor: codex-FR [role: cto-codex-FR]
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-runner`
- Merged branch: `origin/phase-6-10-h-bsebench-runner-registry-swap-fix-1`
- Merged SHA: `34acb8b9d8ca2fbce8ea99cd31984e43403b4f88`
- Merge method: clean detached worktree, fast-forward push to `origin/main`

## Validation evidence

- Worker verification:
  - `uv run pytest tests/test_default_adapters.py tests/test_default_registries.py -v`
    with `26 passed, 2 skipped`.
  - `uv run pytest -m "not slow" --tb=short` with `55 passed, 5 deselected`.
  - `uv run ruff format --check .`.
  - `uv run ruff check .`.
- CTO clean worktree validation repeated the same gates after
  `UV_LINK_MODE=copy uv sync --all-extras`:
  - `26 passed, 2 skipped`.
  - `55 passed, 5 deselected`.
  - ruff format/check passed.
- Independent validator Newton: `GO`; scope matched phase 6.10.h, no roadmap or
  scientific metric changes, dependency pin was coherent, commit was GLASSBOX
  and had no Claude trailer.

## Residual risk

Default adapter factories now instantiate real Tier 2 loaders. Actual `load()`
calls can reach Hugging Face Hub if data is not cached; this is expected for the
registry swap and is not a merge blocker.
