---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-6-10-h-bsebench-runner-registry-swap
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 30
---

# Phase 6.10.h — bsebench-runner registry swap (stubs → real loaders)

## Mission

Dans `bsebench-runner/src/bsebench_runner/default_adapters.py`, remplacer les `StubLoader("xxx")` par les vrais Tier 2 loaders (CalceLegacyLoader, CalceA123DynLoader, CalceInr20RLoader, PanasonicKollmeyerLoader, LgHg2Stroebl2024Loader, YaoTuBerlin2024Loader). NASA-2007 déjà swap-é (Phase 6.5).

## Pre-flight

1. Read `src/bsebench_runner/default_adapters.py` end-to-end (probably ~100 LOC). Find StubLoader instances.
2. Reference : `bsebench-datasets/src/bsebench_datasets/loaders/__init__.py` lazy-exports the loaders. Import them via that.
3. Check `pyproject.toml` for bsebench-datasets dependency. May need version bump.
4. NO Co-Authored-By Claude. GLASSBOX.

## Deliverable

### `src/bsebench_runner/default_adapters.py` updates

For each wrapper key (panasonic, lg_hg2, yao, calce_legacy, calce_a123_dyn, calce_inr_dyn) :
- Replace `lambda: StubLoader("xxx")` with `<RealLoader>` factory
- Each factory should be lazy (import at call time, not module top) to avoid heavy imports for unused loaders
- Keep NasaPcoeLoader as it was (already real)
- Keep StubLoader for any wrapper still without implementation (maybe severson-related ones)

### `tests/test_default_adapters_real_loaders.py`

≥ 5 fast tests : assert each wrapper key returns a real Tier2Loader subclass (not StubLoader). Mock the actual data loading.

## Acceptance gates

- G1 : ≥ 5 fast tests pass + existing tests still pass
- G2-G3 : ruff format + check
- G4 : git status clean, scope ≤ 3 files
- G5 : 1-2 commits GLASSBOX
- G6 : NO Co-Authored-By Claude

## Cross-refs

- bsebench-datasets@1dd4624 (all 6 real loaders shipped)
- 6.5 default_adapters NASA swap (precedent)
