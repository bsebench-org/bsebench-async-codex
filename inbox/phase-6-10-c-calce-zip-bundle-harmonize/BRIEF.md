---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-6-10-c-calce-zip-bundle-harmonize
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/_datasets
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 30
---

# Phase 6.10.c — CalceA123Adapter zip-bundle harmonize (DST + US06 + FUDS × 8 T)

## Mission

Extend `CalceA123Adapter.harmonize()` (legacy CSV branch shipped in 6.10.b, commit `6f19df9`) with the **dynamic zip-bundle** branch : 8 zips × 3 profiles × 2 cells = up to 48 configs from CALCE A123 dynamic-discharge bundles. Source data already on France PC at `/mnt/c/doctorat/bsebench-org/_datasets/calce_a123_lfp_dynamic/`.

**NOT in scope** (deferred) :
- Tier 2 loader (`CalceLegacyLoader` + `CalceA123DynLoader`) → Phase 6.10.d, 6.10.e
- CALCE INR-20R adapter (different chemistry) → out of CALCE A123 family
- Compute paper2b chi² parity → Phase 6.10.g+

## Workspace

Worker provides worktree at `<target_repo>-<target_branch>`. Operate there. Do NOT push — worker handles push.

## Pre-flight (ADR 0014, abridged)

1. **API + reference impl** : read the EXISTING `src/bsebench_datasets/adapters/calce_a123_2014.py` end-to-end (post-6.10.b). The legacy CSV branch is the structural pattern you will mirror. Add a SECOND branch for zip-bundle handling, do NOT rewrite the legacy branch.
2. **Source-of-truth** : paper2b `load_calce_a123_dynamic_wrapper` at `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch/benchmark_grid_multi.py:502-585`. Quote-relevant facts :
   - Format : zipped Arbin TEST REPORT XLSX. Each zip contains 2+ XLSX files (one per cell, A1-007 + A1-008 alphabetical order).
   - Sheet to read : first sheet starting with `Channel_*`.
   - Columns : `Test_Time(s)`, `Step_Index`, `Current(A)`, `Voltage(V)`, `Temperature (C)_1`. NOTE the leading space + `_1` suffix on the temp column — quote verbatim.
   - Profile segmentation by `Step_Index` : DST=8, US06=16, FUDS=24 (the same step indexes as the legacy CALCE CSVs).
   - Sign : raw `Current(A)` follows Arbin convention (negative=discharge, positive=charge). This IS BPX 1.1 already → NO sign flip in the adapter (mirror legacy branch decision in 6.10.b).
3. **Source data** : `/mnt/c/doctorat/bsebench-org/_datasets/calce_a123_lfp_dynamic/`. The 8 zip filenames :

   ```
   A123_DST-US06-FUDS-N10.zip      (T = -10 °C)
   A123_DST-US06-FUDS-0.zip        (T =   0 °C)
   A123_DST-US06-FUDS-10.zip       (T =  10 °C)
   A123_DST-US06-FUDS-20.zip       (T =  20 °C)
   A123_DST-US06-FUDS-25.zip       (T =  25 °C)
   A123_DST-US06-FUDS-30.zip       (T =  30 °C)
   A123_DST-US06-FUDS-40.zip       (T =  40 °C)
   A123_DST-US06-FUDS-50.zip       (T =  50 °C)
   ```

   Verify presence with `ls -la /mnt/c/doctorat/bsebench-org/_datasets/calce_a123_lfp_dynamic/` at session start.
4. **Granularity** : ≤ 200 LOC of new code. Multiple commits per logical step OK (per CHEF.md §10).
5. **No `Co-Authored-By: Claude` trailer.** Author = `Oussama Akir <claude@cosmocomply.com>`.
6. **GLASSBOX commit format** mandatory : every commit body has `[role: worker-codex-FR]` + `## Context` + `## Objective` + `## Problem` + `## Result`. See `docs/PROTOCOL.md` §"Commit format - GLASSBOX".

## Deliverable

Modify `src/bsebench_datasets/adapters/calce_a123_2014.py` :

### 1. Add a temperature → zip mapping module-level

```python
# Mapping T (°C) -> dynamic zip filename (paper2b benchmark_grid_multi.py:472-481)
DYN_T_TO_ZIP: dict[int, str] = {
    -10: "A123_DST-US06-FUDS-N10.zip",
    0:   "A123_DST-US06-FUDS-0.zip",
    10:  "A123_DST-US06-FUDS-10.zip",
    20:  "A123_DST-US06-FUDS-20.zip",
    25:  "A123_DST-US06-FUDS-25.zip",
    30:  "A123_DST-US06-FUDS-30.zip",
    40:  "A123_DST-US06-FUDS-40.zip",
    50:  "A123_DST-US06-FUDS-50.zip",
}

# Profile -> Step_Index in the Arbin XLSX (paper2b benchmark_grid_multi.py:495-499)
DYN_PROFILE_TO_STEP: dict[str, int] = {
    "DST":  8,
    "US06": 16,
    "FUDS": 24,
}
```

### 2. Extend `harmonize()` to handle the dynamic zips

After the existing legacy CSV loop, add a SECOND loop iterating `DYN_T_TO_ZIP`. For each zip that exists in `self.local_root` :

1. Open the zip with `zipfile.ZipFile`, extract to a `tempfile.TemporaryDirectory`.
2. `glob.glob(os.path.join(tmp, "**", "*.xlsx"), recursive=True)` — sort alphabetical, take both cells (A1-007 = idx 0, A1-008 = idx 1).
3. For each cell xlsx + each profile in `DYN_PROFILE_TO_STEP` :
   a. Read first `Channel_*` sheet via `pyarrow.csv` is NOT applicable — must use `pandas.read_excel` (xlsx). Add `pandas` to the optional dep set if not already present (check `pyproject.toml`).
   b. Filter rows where `Step_Index == DYN_PROFILE_TO_STEP[profile]`. If `len(df) < 100`, skip with a warning (segmentation off for this T).
   c. Zero-base `Test_Time(s)`.
   d. Extract columns : `time_s = Test_Time(s) - t0`, `voltage_V = Voltage(V)`, `current_A = Current(A)` (NO flip — already BPX), `temperature_C = Temperature (C)_1`.
   e. Cell ID format : `f"A123_{profile}_T{T_int}_cell{cell_idx}"` (e.g. `A123_DST_T25_cell0`).
   f. Output Parquet path : `output_dir / f"calce_a123_dyn_{profile}_T{T_int}_cell{cell_idx}.parquet"`.
   g. Append to the same `written` dict the legacy branch returns.

### 3. Update module docstring to reflect both branches are now implemented

Drop "Phase 6.10.a status : SKELETON ONLY" — replace with "Phase 6.10.b + 6.10.c status : legacy + dynamic-zip branches implemented. Tier 2 loader lands in 6.10.d/e."

## Test deliverable

Add to `tests/test_adapter_calce_a123_skeleton.py` (or new file `tests/test_adapter_calce_a123_dynamic.py` — your call) :

Required tests (≥ 5 new, all FAST — synthetic in-memory mocks, NO real zip extraction in fast tests). Mock with `unittest.mock.patch` of `zipfile.ZipFile` + `pandas.read_excel`, OR build a tiny synthetic xlsx-in-zip in tmp_path :

1. `test_dyn_constants` : assert `DYN_T_TO_ZIP` has 8 entries, keys = (-10, 0, 10, 20, 25, 30, 40, 50). Assert `DYN_PROFILE_TO_STEP == {"DST": 8, "US06": 16, "FUDS": 24}`.
2. `test_harmonize_dyn_skips_missing_zip(tmp_path)` : empty local_root. Dynamic branch produces zero entries.
3. `test_harmonize_dyn_writes_parquet_for_one_profile_one_T_one_cell(tmp_path)` : create a fake zip with a small xlsx (use `openpyxl` to build a synthetic Arbin-shaped sheet with 200 rows at Step_Index=8). Run harmonize → assert 1 Parquet written at expected path with cell_id `A123_DST_T25_cell0`.
4. `test_harmonize_dyn_segments_three_profiles(tmp_path)` : same zip but with rows at Step_Index 8, 16, 24. Verify 3 Parquets emitted (one per profile) with correct row counts.
5. `test_harmonize_dyn_skips_short_segments(tmp_path)` : a profile's Step_Index has only 50 rows (< 100). Assert harmonize SKIPS that (config) silently and does not error on the others. Add an `_warning_logger` or just log via `print` — keep it simple.

Plus 1 OPTIONAL slow test :
6. `@pytest.mark.slow def test_dyn_real_zip_T25(tmp_path)` : if the real zip `A123_DST-US06-FUDS-25.zip` is at `/mnt/c/doctorat/bsebench-org/_datasets/calce_a123_lfp_dynamic/` (skip if missing), run harmonize on it. Assert 6 Parquets written (3 profiles × 2 cells). Verify one Parquet's content matches paper2b's `load_calce_a123_dynamic_wrapper(profile="DST", T_C=25, cell_idx=0)` output : same time array (within float tolerance), same I, V, T arrays.

## Acceptance gates

- **G1** : `uv run pytest tests/test_adapter_calce_a123_*.py -m "not slow" -v` → ≥ 14 fast tests passing (9 from 6.10.a/b + 5 new). Total ≥ 14.
- **G2** : `uv run ruff format --check src/bsebench_datasets/adapters/calce_a123_2014.py tests/test_adapter_calce_a123_*.py` → exit 0.
- **G3** : `uv run ruff check src/ tests/` → exit 0.
- **G4** : `git status --porcelain` clean, scope ≤ 3 files (1 adapter, 1-2 tests).
- **G5** : 1-4 commits on `phase-6-10-c-calce-zip-bundle-harmonize` branch with conventional + GLASSBOX format. Each commit body has `[role: worker-codex-FR]` + 4 sections.
- **G6** : NO `Co-Authored-By: Claude` trailer ; author = `Oussama Akir <claude@cosmocomply.com>`.

## DO NOT

- Implement Tier 2 loaders (defer to 6.10.d/e).
- Touch `bsebench-runner` or any other repo.
- Run the slow real-zip test in CI ; it's mark slow for a reason.
- Add `Co-Authored-By: Claude` trailer.
- Skip the empirical-sign verification step in your commit body — confirm raw current is BPX-aligned with a smoking-gun command on at least one zip.

## Cross-references

- 6.10.a commit `f397ca9` (skeleton + BaseAdapter shim — already dropped in 6.10.b).
- 6.10.b commit `6f19df9` (legacy CSV branch — the SISTER branch you are extending alongside).
- paper2b source : `benchmark_grid_multi.py:472-585` (DYN_T_TO_ZIP, DYN_PROFILE_TO_STEP, load_calce_a123_dynamic_wrapper).
- ADR 0014 §"Pre-flight checklist" + GLASSBOX format spec.
