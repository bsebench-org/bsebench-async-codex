---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-4-github-actions-ci
base_branch: main
hard_wallclock_min: 20
---

# Phase 7.4 — GitHub Actions CI

## Mission

Ajouter `.github/workflows/ci.yml` qui run `uv run pytest -m "not slow"` + `uv run ruff format --check` + `uv run ruff check` sur push/PR à main.

## Pre-flight

1. Check `.github/` exists. If not, create.
2. Reference : GitHub Actions Python testing standard. `uv` is the runtime (already in pyproject.toml).
3. NO Co-Authored-By Claude. GLASSBOX.

## Deliverable

### `.github/workflows/ci.yml`

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v3
        with:
          version: latest
      - run: uv sync --extra dev
      - run: uv run ruff format --check .
      - run: uv run ruff check .
      - run: uv run pytest -m "not slow" --tb=short
```

## Acceptance gates

- G1 : YAML syntax valid (Python `yaml.safe_load` parses)
- G2-G3 : not applicable to YAML
- G4 : git status clean, scope = 1 file
- G5-G6 : GLASSBOX, no Claude trailer

## Note

Once merged, GitHub auto-runs the workflow on next push. Watch `https://github.com/bsebench-org/bsebench-datasets/actions`.

## Cross-refs

- pyproject.toml uv sync
- ruff already configured per existing `.ruff.toml`
