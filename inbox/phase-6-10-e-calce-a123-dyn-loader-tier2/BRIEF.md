---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-6-10-e-calce-a123-dyn-loader-tier2
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/_datasets
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 30
---

# Phase 6.10.e — CalceA123DynLoader Tier 2 (paper2b-compat dynamic)

## Mission

Second Tier 2 loader for the CALCE A123 family : the **dynamic** branch (DST + US06 + FUDS × 8 T × 2 cells = up to 48 configs). Mirror Phase 6.10.d (`CalceLegacyLoader`) but reading the dynamic Parquet output of the 6.10.c adapter.

## Pre-flight

1. Read `src/bsebench_datasets/loaders/calce_a123_legacy_loader.py` (just shipped in 6.10.d) for sister-loader pattern.
2. Source-of-truth : paper2b `load_calce_a123_dynamic_wrapper` at `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch/benchmark_grid_multi.py:502-585`.
3. Tier 1 dependency : Phase 6.10.c adapter writes Parquet at `output_dir / "calce_a123_dyn_{profile}_T{T_int}_cell{cell_idx}.parquet"` (BPX 1.1 = positive=charge).
4. NO `Co-Authored-By: Claude` trailer. GLASSBOX commit format mandatory.

## Deliverable

### `src/bsebench_datasets/loaders/calce_a123_dyn_loader.py`

- Class : `CalceA123DynLoader(Tier2Loader)`
- `wrapper_name = "calce_a123_dyn"`
- `available_configs() -> list[tuple[str, float]]` returns 24 tuples : `[(profile, T) for profile in ("DST","US06","FUDS") for T in (-10,0,10,20,25,30,40,50)]`
- `load(profile, T_C, cell_idx=0) -> dict` returns the same 10-key schema as 6.10.d, with :
  - `cell_id = f"A123_{profile}_T{int(T_C)}_cell{cell_idx}"`
  - `dataset = "calce_a123_lfp"`
  - `chemistry = "LFP_A123_APR18650M1A"`
  - `source_url = "https://calce.umd.edu/battery-data"`
  - Sign : flip `i = -current_a` (BPX → paper2b discharge-positive)
  - Profile + T validation (raise `AdapterNotAvailableError`)
  - cell_idx ∈ {0, 1} validation
- HF Hub repo target : `bsebench-org/calce-a123-2014-dynamic`. Use `_downloader` injectability + `local_cache_root` fallback.

### `tests/test_loader_calce_a123_dyn.py`

≥ 10 fast tests + 1 slow integration test (skip if data absent). Mirror `test_loader_calce_legacy.py` structure. Cover : constructor, available_configs (24 tuples), invalid profile/T raises, cell_id format for all 3 profiles + extreme T (-10, 50), sign flip, time rebasing, schema, length consistency, cell_idx 0 vs 1.

### Registry update if needed

Mirror Phase 6.10.d pattern in `loaders/__init__.py`.

## Acceptance gates

- G1 : `pytest tests/test_loader_calce_a123_dyn.py -m "not slow" -v` → ≥ 10 passing
- G2 : ruff format check → exit 0
- G3 : ruff check src/ tests/ → exit 0
- G4 : git status clean, scope ≤ 3 files
- G5 : 1-3 commits with GLASSBOX format
- G6 : NO `Co-Authored-By: Claude` trailer

## Cross-references

- 6.10.c commit `d765fb2` (Tier 1 dependency, dynamic zip-bundle harmonize)
- 6.10.d commit (TBD — sister Tier 2 loader, just shipped)
- paper2b `benchmark_grid_multi.py:502-585`
