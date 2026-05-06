---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-4-github-actions-ci-fix-1
base_branch: main
hard_wallclock_min: 20
---

# Phase 7.4 fix-1 — GitHub Actions CI dependency coverage

## Why this is fix-1

The original `phase-7-4-github-actions-ci` branch exists, but validation blocked
it because `uv sync --extra dev` omits `scipy` and `h5py`. Pytest collects tests
before marker filtering, so non-slow CI can fail during import collection.

## Mission

Ship a minimal CI workflow for `bsebench-datasets` that runs ruff and non-slow
pytest with dependency coverage sufficient for test collection.

## Scope

- IN scope: `.github/workflows/ci.yml` only.
- OUT of scope: package metadata, tests, source code, release metadata.

## Acceptance criteria

- [ ] Workflow installs dependencies with `uv sync --all-extras` or an
  equivalent command that includes `adapters-mat`.
- [ ] Workflow runs `uv run ruff format --check .`,
  `uv run ruff check .`, and `uv run pytest -m "not slow" --tb=short`.
- [ ] YAML parses successfully.
- [ ] Scope is exactly `.github/workflows/ci.yml`.
- [ ] Commit uses GLASSBOX with `[role: worker-codex-FR]` and no Claude trailer.

## Verification commands

```bash
python - <<'PY'
import yaml
yaml.safe_load(open('.github/workflows/ci.yml', encoding='utf-8'))
PY
uv run ruff format --check .
uv run ruff check .
uv run pytest -m "not slow" --tb=short
```

## If blocked

Write `outbox/phase-7-4-github-actions-ci-fix-1/BLOCKED.md` with the exact
dependency or YAML parser error.
