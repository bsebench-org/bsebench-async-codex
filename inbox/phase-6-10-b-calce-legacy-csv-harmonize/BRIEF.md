---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-6-10-b-calce-legacy-csv-harmonize
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/_datasets
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 30
---

# Phase 6.10.b — CalceA123Adapter.harmonize() for legacy CSVs

## Mission

Implement the **legacy CSV** branch of `CalceA123Adapter.harmonize()` (added as skeleton in 6.10.a, commit `f397ca9`). Parse the 3 paper2b legacy CSVs (`A123_0C.csv`, `A123_25C.csv`, `A123_40C.csv`), filter the DST segment (step_index >= 8), and write per-(profile, T) BPX 1.1 Parquet files.

**NOT in scope** (deferred) :
- zip-bundle handling (DST + US06 + FUDS × 8 T) → Phase 6.10.c
- Tier 2 loader (`CalceLegacyLoader` + `CalceA123DynLoader`) → Phase 6.10.d/e

## Workspace

Worker provides worktree at `<target_repo>-<target_branch>`. Operate there. Do NOT push — worker handles push.

## Pre-flight (ADR 0014 §"Pre-flight checklist")

1. **Drop the BaseAdapter shim** introduced in 6.10.a. The `try/except ModuleNotFoundError` block (lines 30-35 of `src/bsebench_datasets/adapters/calce_a123_2014.py`) is inconsistent with the other adapters in the repo. Match the Yao pattern : `class CalceA123Adapter:` with no parent class. Remove the import + try/except entirely.
2. **Reference implementation** : read `src/bsebench_datasets/adapters/yao_tu_berlin_2024.py` end-to-end (most recent CSV-based adapter). Mirror its structure for `harmonize()` : pyarrow / pandas CSV read, BPX-canonical column names, per-config Parquet output paths.
3. **Source-of-truth** : paper2b `load_calce` at `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch/prepare.py:25-67`. Quote :
   - CSV columns : `time_s, current_A, voltage_V, temperature_C, step_index`
   - Filter : `step_index >= 8` (the DST dynamic-discharge segment)
   - Sign : paper2b flips with `-I_all[mask]` to get discharge-positive ; raw CSV is **discharge-negative** (Arbin convention) which is **already BPX 1.1**. **Do NOT flip in the adapter.** Document this explicitly in the harmonize docstring.
   - Time : zero-base from start of DST segment (`t - t0` where `t0 = t_all[np.argmax(mask)]`).
4. **Wheel-safety** : harmonize takes explicit `local_root` (already set in __init__) and explicit `output_dir` (signature already there). No `Path(__file__).parents[N]`.
5. **No `Co-Authored-By: Claude` trailer.** Author = `Oussama Akir <claude@cosmocomply.com>`.
6. **Granularity** : multi-commit OK. Suggested commits :
   - commit 1 : drop BaseAdapter shim
   - commit 2 : implement harmonize legacy branch
   - commit 3 : tests
   - commit 4 : ruff format pass

## Source data (already on this PC)

```
/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/data/A123_0C.csv     (T=0)
/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/data/A123_25C.csv    (T=25)
/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/data/A123_40C.csv    (T=40)
```

Schema (verified empirically) :
```
time_s,current_A,voltage_V,temperature_C,step_index
3.054,0.000000,2.766393,26.8,1
8.061,-1.099373,2.501398,26.8,2
...
```

24 470 rows in A123_25C.csv. After step_index >= 8 filter, expect ~7000-8000 rows (the DST segment).

## Deliverable code

Modify `src/bsebench_datasets/adapters/calce_a123_2014.py` :

### 1. Drop the BaseAdapter shim

Delete lines 30-35 :
```python
try:
    from bsebench_datasets.adapters._base import BaseAdapter
except ModuleNotFoundError:

    class BaseAdapter:
        """Compatibility shim until the shared adapter base lands in this repo."""
```

Change `class CalceA123Adapter(BaseAdapter):` to `class CalceA123Adapter:` (line 60). The class metadata constants (`DATASET_NAME`, `CHEMISTRY`) stay.

### 2. Add a temperature → CSV mapping module-level

```python
# Mapping T (°C) -> legacy CSV filename (paper2b prepare.load_calce convention)
LEGACY_T_TO_CSV: dict[int, str] = {
    0: "A123_0C.csv",
    25: "A123_25C.csv",
    40: "A123_40C.csv",
}
```

### 3. Implement harmonize() legacy branch

Replace the NotImplementedError body with :

```python
def harmonize(self, output_dir: Path | str) -> dict[str, Path]:
    """Harmonize CALCE A123 raw to BPX 1.1 Parquet.

    Phase 6.10.b status : legacy CSV branch implemented (DST profile, 3 T).
    Dynamic zip-bundle branch (DST/US06/FUDS × 8 T) lands in 6.10.c.

    For each (profile=DST, T) tuple where the legacy CSV exists in
    self.local_root, this method :
      1. reads the CSV (columns : time_s, current_A, voltage_V,
         temperature_C, step_index).
      2. filters step_index >= 8 (the DST dynamic-discharge segment ;
         see paper2b prepare.py:52).
      3. zero-bases the time axis from start of DST.
      4. writes a BPX 1.1 Parquet file at
         output_dir / "calce_a123_DST_T{T}.parquet" with columns
         time_s, voltage_V, current_A, temperature_C.

    Sign convention :
        Raw CSV uses Arbin convention : current_A < 0 = discharge,
        > 0 = charge. This IS BPX 1.1 already (charge-positive,
        discharge-negative). NO sign flip in this adapter. The Tier 2
        loader will flip to paper2b convention (discharge-positive)
        per the established pattern (mirror NASA-2007 / Yao Tier 2).

    Returns :
        dict mapping cell_id (e.g. "A123_T25") -> Path of the written
        Parquet file. Cell IDs that are missing from local_root are
        skipped silently.

    Args :
        output_dir : directory where Parquet files will be written.
                     Created if missing. Caller-supplied (no
                     Path(__file__).parents discovery).
    """
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    written: dict[str, Path] = {}

    for T_int, csv_name in LEGACY_T_TO_CSV.items():
        csv_path = self.local_root / csv_name
        if not csv_path.is_file():
            continue

        # Stream-read CSV via stdlib csv (no pandas dependency in adapter).
        time_s: list[float] = []
        current_A: list[float] = []
        voltage_V: list[float] = []
        temperature_C: list[float] = []
        step_index: list[int] = []
        with open(csv_path, "r") as f:
            import csv as _csv
            reader = _csv.DictReader(f)
            for row in reader:
                time_s.append(float(row["time_s"]))
                current_A.append(float(row["current_A"]))
                voltage_V.append(float(row["voltage_V"]))
                temperature_C.append(float(row["temperature_C"]))
                step_index.append(int(row["step_index"]))

        if not time_s:
            continue

        # Filter step_index >= 8 (DST dynamic-discharge segment).
        # paper2b prepare.py:52 uses the same predicate.
        import numpy as np
        t_arr = np.asarray(time_s, dtype=np.float64)
        i_arr = np.asarray(current_A, dtype=np.float64)
        v_arr = np.asarray(voltage_V, dtype=np.float64)
        tc_arr = np.asarray(temperature_C, dtype=np.float64)
        s_arr = np.asarray(step_index, dtype=np.int64)
        mask = s_arr >= 8
        if not np.any(mask):
            continue
        t0 = t_arr[np.argmax(mask)]
        t_dst = t_arr[mask] - t0
        i_dst = i_arr[mask]  # NO sign flip — raw CSV is already BPX 1.1
        v_dst = v_arr[mask]
        tc_dst = tc_arr[mask]

        # Write Parquet via pyarrow (mirror Yao adapter style).
        import pyarrow as pa
        import pyarrow.parquet as pq
        table = pa.table({
            "time_s": t_dst,
            "voltage_V": v_dst,
            "current_A": i_dst,
            "temperature_C": tc_dst,
        })
        cell_id = f"A123_T{T_int}"
        out_path = output_dir / f"calce_a123_DST_T{T_int}.parquet"
        pq.write_table(table, out_path)
        written[cell_id] = out_path

    return written
```

## Test deliverable

Modify `tests/test_adapter_calce_a123_skeleton.py` (or add a NEW file `tests/test_adapter_calce_a123_legacy_harmonize.py` if you prefer a clean separation — your choice, document the choice in the commit body).

Required tests (≥ 5 new, all fast — no network) :

1. `test_harmonize_writes_parquet_for_existing_csv(tmp_path)` : create a tiny synthetic CSV in tmp_path with the 5 columns + 20 rows split between step_index 1-7 and 8-12. Run harmonize(output_dir=tmp_path/"out"). Assert : 1 Parquet file written at expected path (calce_a123_DST_T25.parquet), table has the post-filter row count, time starts at 0.

2. `test_harmonize_skips_missing_csv(tmp_path)` : empty local_root. harmonize() returns empty dict. No exception.

3. `test_harmonize_no_dst_segment(tmp_path)` : CSV with all step_index < 8. harmonize() returns empty dict (the cell_id is not in the result).

4. `test_harmonize_sign_not_flipped(tmp_path)` : CSV with discharge rows (current_A = -1.0 e.g.) at step_index >= 8. After harmonize, the Parquet's current_A column equals the raw CSV column (no sign flip). Assert via reading back the Parquet.

5. `test_harmonize_zero_bases_time(tmp_path)` : CSV with time_s starting at 100.0, step_index >= 8 starts at row index 5 with time_s=200.0. After harmonize, Parquet's first time_s is 0.0, and second time_s = (200.5 + N) - 200.0 etc. Assert.

6. `test_harmonize_writes_3_temps_when_all_csvs_present(tmp_path)` (optional / nice-to-have) : populate tmp_path with all 3 CSVs (small synthetic). harmonize() returns 3 entries with correct cell_ids "A123_T0", "A123_T25", "A123_T40".

Update or remove the original `test_harmonize_raises_not_implemented_in_skeleton` since it no longer applies. Replace with `test_harmonize_returns_dict_for_empty_local_root` (delegates to test #2).

## Acceptance gates

- **G1** : `uv run pytest tests/test_adapter_calce_a123_*.py -v` → ≥ 5 new tests passing, plus the surviving 4 original tests from 6.10.a (constants, class attrs, constructor x2). Total ≥ 9 fast tests.
- **G2** : `uv run ruff format --check src/bsebench_datasets/adapters/calce_a123_2014.py tests/test_adapter_calce_a123_*.py` → exit 0.
- **G3** : `uv run ruff check src/ tests/` → exit 0.
- **G4** : `git status --porcelain` shows ONLY the modified adapter + the test file(s).
- **G5** : 1-4 commits on `phase-6-10-b-calce-legacy-csv-harmonize` branch with conventional format. Author = `Oussama Akir <claude@cosmocomply.com>`. NO `Co-Authored-By: Claude` trailer.
- **G6** : NO BaseAdapter shim remains in calce_a123_2014.py (verify via `grep -n 'BaseAdapter\|ModuleNotFoundError' src/bsebench_datasets/adapters/calce_a123_2014.py` returns empty).

## DO NOT

- Implement zip-bundle parsing (Phase 6.10.c).
- Add a Tier 2 loader (Phase 6.10.d).
- Touch other adapters or other repos.
- Push (worker handles).
- Add `Co-Authored-By: Claude` trailer.
- Use pandas (overkill for 5-column CSV ; stdlib `csv` + pyarrow is enough).

## Cross-references

- BRIEF history : `inbox/phase-6-10-a-calce-a123-adapter-skeleton-fix-1/BRIEF.md` (the predecessor).
- Verdict on 6.10.a : `outbox/phase-6-10-a-calce-a123-adapter-skeleton-fix-1/CHEF_VERDICT.md` (notes the BaseAdapter shim cleanup is a 6.10.b task).
- Source-of-truth : paper2b `prepare.py:25-67` `load_calce` function.
- Reference impl : `src/bsebench_datasets/adapters/yao_tu_berlin_2024.py` (CSV-based adapter pattern).
- Granularity rule : `docs/CHEF.md` §10.
