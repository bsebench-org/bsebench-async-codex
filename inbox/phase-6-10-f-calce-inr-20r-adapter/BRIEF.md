---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-6-10-f-calce-inr-20r-adapter
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/_datasets
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 30
---

# Phase 6.10.f — CalceInr20RAdapter Tier 1 (NMC chemistry, separate from A123)

## Mission

CALCE INR-20R Tier 1 adapter. **Different chemistry from A123** (NMC vs LFP), separate cell, distinct file. Parallelizable with 6.10.e (different files). Source-of-truth : paper2b `load_calce_inr_dynamic_wrapper` at `benchmark_grid_multi.py:633-720`.

## Pre-flight

1. Read `src/bsebench_datasets/adapters/calce_a123_2014.py` (just shipped 6.10.b/c) for the structural pattern. **Do NOT extend it** — INR-20R is a separate chemistry. Create a NEW file `calce_inr_20r_2014.py`.
2. Source-of-truth : paper2b `load_calce_inr_dynamic_wrapper` :
   - Cell : CALCE INR-20R Samsung, NMC chemistry, ~2.0 Ah nominal, 18650.
   - Profiles : DST, FUDS, US06, BJDST (4 profiles, different from A123).
   - Temperatures : 0, 25, 45 °C.
   - SoC starts : 50, 80 (2 starting SoC values per (profile, T)).
   - Format : zipped Arbin XLS (extension `.xls` misleading — actual content is XLSX). 17-column variant — NO Temperature column → T_meas filled with constant T_amb.
3. Source data : `/mnt/c/doctorat/bsebench-org/_datasets/calce_inr18650_20R_dynamic/SP2_{T}C_{profile}.zip` (12 zips total : 3 T × 4 profiles).
4. NO `Co-Authored-By: Claude` trailer. GLASSBOX commit format mandatory.
5. **Multi-worker note** : worker may be running 6.10.e in parallel. Different files, different chemistries, ZERO correlation. No shared state.

## Deliverable

### `src/bsebench_datasets/adapters/calce_inr_20r_2014.py`

- Class : `CalceInr20RAdapter` (no parent class, mirror Yao pattern).
- Constants module-level :
  ```python
  CHEMISTRY_TAG = "NMC_CALCE_INR18650_20R"
  DATASET_TAG = "calce_inr_20r"
  NOMINAL_CAPACITY_AH = 2.0
  PROFILES = ("DST", "FUDS", "US06", "BJDST")
  TEMPS_C = (0, 25, 45)
  SOC_STARTS = (50, 80)
  T_TO_ZIP_PATTERN = "SP2_{T}C_{profile}.zip"
  ```
- `__init__(self, local_root: Path | str)`.
- `harmonize(output_dir) -> dict[str, Path]` :
  - For each (profile, T, soc_start) combination, locate the zip + extract.
  - Read first `Channel_*` sheet via `pandas.read_excel(engine="openpyxl")`.
  - Filter by SoC pattern in filename (`*_50SOC.xls` or `*_80SOC.xls`).
  - Extract columns : `Test_Time(s)`, `Step_Index`, `Current(A)`, `Voltage(V)`. NO Temperature column → `temperature_C = T_amb` constant.
  - Sign : raw `Current(A)` is Arbin convention (negative=discharge) = BPX-aligned → NO flip in adapter (mirror 6.10.b decision).
  - Time : zero-base from start of segment.
  - Cell ID : `f"INR_{profile}_T{T_int}_soc{soc_start}"` (e.g., `INR_DST_T25_soc80`).
  - Output Parquet : `output_dir / f"calce_inr_20r_{profile}_T{T_int}_soc{soc_start}.parquet"` with BPX 1.1 columns (`time_s`, `voltage_V`, `current_A`, `temperature_C`).
  - Skip silently if zip missing OR segment too short (< 100 rows).
- Document the empirical sign verification with smoking-gun command in module docstring.

### `tests/test_adapter_calce_inr_20r.py`

≥ 5 fast tests (no network, synthetic Parquet/zip mocks) + 1 optional slow test on real zip data.

Required tests :
1. constants check (PROFILES, TEMPS_C, SOC_STARTS, CHEMISTRY_TAG, DATASET_TAG)
2. constructor stores local_root as Path
3. harmonize on empty local_root returns empty dict (no error)
4. harmonize on synthetic zip with 1 (profile, T, soc) → 1 Parquet written with expected cell_id format
5. cell_id format : `INR_DST_T25_soc80`
6. sign no-flip verification (synthetic raw current preserved as-is in Parquet)

Slow test (skipped if data absent) :
7. harmonize on `/mnt/c/doctorat/bsebench-org/_datasets/calce_inr18650_20R_dynamic/SP2_25C_DST.zip` → 2 Parquets (soc=50 + soc=80).

## Acceptance gates

- G1 : ≥ 5 fast tests passing
- G2 : ruff format check
- G3 : ruff check src/ tests/
- G4 : git status clean, scope ≤ 2 files
- G5 : 1-3 commits with GLASSBOX format
- G6 : NO Co-Authored-By Claude trailer

## DO NOT

- Implement Tier 2 loader for INR-20R (deferred to 6.10.g).
- Modify `calce_a123_2014.py` (separate chemistry, separate file).
- Touch bsebench-runner.

## Cross-references

- paper2b `benchmark_grid_multi.py:633-720` (load_calce_inr_dynamic_wrapper).
- 6.10.b/c shipped (sister A123 adapter, structural reference).
- 6.10.e queued in parallel (worker may run both simultaneously with multi-worker setup).
