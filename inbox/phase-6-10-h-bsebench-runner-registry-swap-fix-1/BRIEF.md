---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-6-10-h-bsebench-runner-registry-swap-fix-1
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 45
---

# Phase 6.10.h fix-1 — bsebench-runner registry swap

## Why this is fix-1

The original phase fossilized in `running`: no process, no outbox, no local or
remote branch, and no deliverable. The mission remains valid because the runner
still uses stub loaders for several dataset keys.

## Mission

Replace bsebench-runner default adapter stubs with the real Tier 2 loaders
available in `bsebench-datasets`.

## Scope

- IN scope: `src/bsebench_runner/default_adapters.py`, focused tests for default
  registry factories, minimal dependency metadata if required.
- OUT of scope: chi2 sweep execution, new dataset adapters, stats work,
  scientific claims.

## Acceptance criteria

- [ ] Panasonic, LG HG2, Yao TU Berlin, CALCE legacy, CALCE A123 dynamic, and
  CALCE INR-20R registry entries instantiate real loader classes, not
  `StubLoader`.
- [ ] Imports are lazy inside factories so module import remains lightweight.
- [ ] Existing NASA loader behavior remains unchanged.
- [ ] Fast tests cover at least five real-loader registry keys.
- [ ] Commit uses GLASSBOX with `[role: worker-codex-FR]` and no Claude trailer.

## Verification commands

```bash
uv run pytest tests/test_default_adapters.py tests/test_default_registries.py -v
uv run pytest -m "not slow" --tb=short
uv run ruff format --check .
uv run ruff check .
```

## If blocked

Write `outbox/phase-6-10-h-bsebench-runner-registry-swap-fix-1/BLOCKED.md`
with the missing loader/import and the exact traceback.
