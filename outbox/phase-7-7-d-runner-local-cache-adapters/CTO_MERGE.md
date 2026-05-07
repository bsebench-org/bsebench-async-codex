# CTO Merge: phase-7-7-d-runner-local-cache-adapters

Status: approved and pushed

Actor: codex-cto-FR

UTC: 2026-05-07T03:41:25Z

## Context

The strict Phase 7.7.b Hinf residual evidence run is blocked before output
creation by missing Hugging Face authentication and incomplete local Tier 2
caches. The previous diagnostic showed:

- no `HF_TOKEN`, no `HUGGINGFACE_HUB_TOKEN`, and no local HF token file;
- `/tmp/bsebench_yao_tier2_cache` contains only `Yao-BCDC-T25.parquet`;
- Panasonic, NASA, and CALCE legacy local Tier 2 caches are missing;
- strict Hinf evidence must remain `5 configs / 25 filter runs` and must not
  produce JSON evidence when those requirements are unmet.

## Change

Repository: `bsebench-runner`

Commit: `46e9ccc` (`GLASSBOX [role: codex-cto-FR] Add local cache roots to runner adapters`)

Pushed to: `origin/main`

Changed files:

- `src/bsebench_runner/default_adapters.py`
- `tests/test_default_adapters.py`

The commit adds local Tier 2 cache root support to the canonical Audit J v1
default adapter registry:

- explicit `build_default_adapter_registry(local_cache_roots=...)`;
- env-var fallback via `LOCAL_CACHE_ENV_VARS` for all seven wrappers;
- NASA PCoE support through downloader injection, because the current dataset
  loader accepts `downloader`, not `local_cache_root`;
- override behavior preserved for caller-supplied `loader_factories`.

## Validation

Local CTO gates:

- `uv run --locked --all-extras pytest tests/test_default_adapters.py -q --tb=short`
  - `24 passed, 1 skipped`
- `uv run --locked --all-extras ruff format --check src tests`
  - pass
- `uv run --locked --all-extras ruff check src tests`
  - pass
- `uv run --locked --all-extras pytest -m 'not slow' -q --tb=short`
  - `91 passed, 5 deselected`
- `git diff --check`
  - pass

Independent validator `Euler`: GO.

Euler evidence:

- targeted default adapter tests without coverage: `24 passed, 1 skipped`;
- ruff check/format on changed files: pass;
- `git show --check --no-renames 46e9ccc`: pass;
- confirmed no scientific result, roadmap change, claim update, or thesis prose.

## Scope Boundary

This is tooling/cache plumbing only. It is not Hinf residual evidence approval.
No benchmark output was committed. No scientific claim was created, verified, or
updated.

## Next Step

Do not rerun strict evidence as success until all five target configs are
available through HF auth or explicit local cache roots. The next useful work is
an exact cache/data preflight and, where raw material exists locally, cache
harmonization without changing the strict 5x5 evidence target.
