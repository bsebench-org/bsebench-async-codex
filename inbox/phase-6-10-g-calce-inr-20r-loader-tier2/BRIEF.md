---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-6-10-g-calce-inr-20r-loader-tier2
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/_datasets
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 30
---

# Phase 6.10.g — CalceInr20RLoader Tier 2 (NMC)

## Mission

Tier 2 loader pour CalceInr20RAdapter (shipped 6.10.f). Mirror le pattern de 6.10.d (CalceLegacyLoader) avec adaptation NMC : 4 profiles (DST/FUDS/US06/BJDST), 3 T (0/25/45), 2 SoC starts (50/80) = 24 configs.

## Pre-flight

1. Reference impl : `src/bsebench_datasets/loaders/calce_a123_legacy_loader.py` (6.10.d shipped sur main).
2. Source-of-truth : paper2b `load_calce_inr_dynamic_wrapper` à `benchmark_grid_multi.py:633-720`.
3. Tier 1 dépendance : 6.10.f `CalceInr20RAdapter` shipped à `ce15172` — écrit Parquet `output_dir / f"calce_inr_20r_{profile}_T{T_int}_soc{soc_start}.parquet"`.
4. Sign : flip `i = -current_a` (BPX → paper2b discharge-positive). Mirror Yao/LG pattern.
5. NO Co-Authored-By Claude. GLASSBOX format.

## Deliverable

### `src/bsebench_datasets/loaders/calce_inr_20r_loader.py`

- Class : `CalceInr20RLoader(Tier2Loader)`
- `wrapper_name = "calce_inr_dyn"` (paper2b convention)
- `available_configs() -> list[tuple[str, float]]` returns 12 (profile, T) tuples (skipping SoC dimension — defaults to soc_start=80 like paper2b)
- `load(profile, T_C, soc_start=80) -> dict` with 10-key schema :
  - `cell_id = f"INR_{profile}_T{int(T_C)}_soc{soc_start}"`
  - `dataset = "calce_inr_20r"`
  - `chemistry = "NMC_CALCE_INR18650_20R"`
  - `source_url = "https://calce.umd.edu/battery-data"`
  - Sign : `i = -current_a`
- HF Hub repo : `bsebench-org/calce-inr-20r-2014`. `_downloader` injectability + `local_cache_root` fallback.

### `tests/test_loader_calce_inr_20r.py`

≥ 8 fast tests (synthetic Parquet) + 1 optional slow test on real adapter output.

## Acceptance gates

- G1 : ≥ 8 fast tests pass
- G2-G3 : ruff format + check
- G4 : git status clean, scope ≤ 3 files
- G5 : 1-3 commits GLASSBOX + role tag
- G6 : NO Co-Authored-By Claude

## Cross-refs

- 6.10.f (`ce15172`) Tier 1 adapter
- 6.10.d sister Tier 2 pattern
