---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-6-10-d-calce-legacy-loader-tier2
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/_datasets
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 30
---

# Phase 6.10.d — CalceLegacyLoader Tier 2 (paper2b-compat)

## Mission

First Tier 2 loader for the CALCE A123 family. Mirror Phase 6.7-6.9 pattern (`PanasonicKollmeyerLoader`, `LgHg2Stroebl2024Loader`, `YaoTuBerlin2024Loader`) for the paper2b legacy `load_calce_wrapper` (DST-only, 3 T : 0/25/40 °C).

**NOT in scope** (deferred) :
- CalceA123DynLoader (the dynamic 3-profile × 8-T variant) → Phase 6.10.e
- CalceInrDynLoader (different chemistry NMC) → Phase 6.10.f
- bsebench-runner registry update → Phase 6.10.g

## Workspace

Worker provides worktree at `<target_repo>-<target_branch>`. Operate there. Do NOT push — worker handles push.

## Pre-flight (ADR 0014, abridged)

1. **Reference implementation** : read `src/bsebench_datasets/loaders/yao_tu_berlin_2024_loader.py` end-to-end (~250 LOC, most recent Tier 2 loader). Mirror its structure : class extending `Tier2Loader`, `wrapper_name`, `available_configs`, `load(profile, T_C)` → dict. Same HF Hub `_downloader` injectability + `local_cache_root` constructor for slow-test fallback.
2. **Source-of-truth** : paper2b `load_calce_wrapper` at `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch/benchmark_grid_multi.py:97-111`. Quote relevant facts :
   - profile : `"DST"` only (raises FileNotFoundError on others).
   - T_C : 0 / 25 / 40 only (mapped to A123_0C.csv / A123_25C.csv / A123_40C.csv).
   - Calls `load_calce(csv_name, T_amb)` from `prepare.py:25-67` (filter step_index >= 8, flip sign with `-I_all[mask]` for paper2b discharge-positive convention).
   - cell_id : `f"A123_T{int(T_C)}"`.
   - chemistry : `"LFP_A123_APR18650M1A"`.
   - dataset : `"calce_a123"` (NOTE : paper2b uses `"calce_a123"`, but Phase 6.10.b adapter writes `dataset="calce_a123_lfp"` per its DATASET_TAG. Use `"calce_a123_lfp"` for consistency with the adapter).
3. **Tier 1 dependency** : the adapter shipped in 6.10.b writes Parquet at `output_dir / "calce_a123_DST_T{T_int}.parquet"` (BPX 1.1 = current_A in BPX = positive=charge). The Tier 2 loader reads this Parquet AND flips the current to paper2b convention (`i = -current_a`).
4. **Wheel-safety** : `_downloader` injection identical to `nasa_pcoe_loader.py` / `panasonic_kollmeyer_loader.py`. No `Path(__file__).parents[N]`.
5. **GLASSBOX commit format** mandatory : every commit body has `[role: worker-codex-FR]` + `## Context` + `## Objective` + `## Problem` + `## Result`. See `docs/PROTOCOL.md` §"Commit format - GLASSBOX" for examples.
6. **No `Co-Authored-By: Claude` trailer.** Author = `Oussama Akir <claude@cosmocomply.com>`.

## Source data (already on disk)

```
/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/data/A123_0C.csv     (T=0)
/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/data/A123_25C.csv    (T=25)
/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/data/A123_40C.csv    (T=40)
```

Ships through Phase 6.10.b `harmonize()` first → Parquet at output_dir → Tier 2 loader reads.

## Deliverable

### 1. New file : `src/bsebench_datasets/loaders/calce_a123_legacy_loader.py`

- Class : `CalceLegacyLoader(Tier2Loader)` (mirror `YaoTuBerlin2024Loader`).
- `wrapper_name = "calce_legacy"`.
- `available_configs() -> list[tuple[str, float]]` returns `[("DST", 0.0), ("DST", 25.0), ("DST", 40.0)]`.
- `load(profile, T_C) -> dict[str, np.ndarray | float | int | str]` returns :
  ```python
  {
      "t": t,                                        # zero-based, seconds, float64
      "V": voltage_v,                                # float64
      "I": -current_a,                               # FLIP : BPX -> paper2b discharge-positive
      "T_meas": temperature_c,                       # float64
      "N": int(t.size),
      "T_amb": float(T_C),
      "cell_id": f"A123_T{int(T_C)}",                # paper2b canonical format
      "dataset": "calce_a123_lfp",                   # adapter's DATASET_TAG
      "chemistry": "LFP_A123_APR18650M1A",           # adapter's CHEMISTRY_TAG
      "source_url": "https://calce.umd.edu/battery-data",
  }
  ```
  - profile validation : `profile == "DST"` else raise `AdapterNotAvailableError` with paper2b-equivalent message.
  - T_C validation : `int(T_C) in {0, 25, 40}` else raise.
- HF Hub repo (vendor target, not run in this dispatch) : `bsebench-org/calce-a123-2014`. Use the same `_downloader` injectability pattern. Tests use `local_cache_root` fallback.

### 2. New test file : `tests/test_loader_calce_legacy.py`

Mirror `tests/test_loader_yao_tu_berlin_2024.py`. Required ≥ 10 fast tests :

1. constructor + wrapper_name attribute
2. `available_configs()` returns the 3 expected tuples
3. `load("FUDS", 25.0)` (invalid profile) raises `AdapterNotAvailableError`
4. `load("DST", 50.0)` (invalid T) raises with documented message
5. cell_id format : `load(DST, 25.0)` returns `cell_id == "A123_T25"`
6. cell_id with T=0 : `cell_id == "A123_T0"`
7. cell_id with T=40 : `cell_id == "A123_T40"`
8. sign flip : synthetic Parquet with all-negative current_A returns all-positive I
9. time rebasing : Parquet with `time_s[0] = 100.0` returns `t[0] == 0.0`
10. schema : returned dict has all 10 keys (t, V, I, T_meas, N, T_amb, cell_id, dataset, chemistry, source_url)
11. length consistency : `len(t) == len(V) == len(I) == len(T_meas) == N`

Plus 1 OPTIONAL slow test :
12. `@pytest.mark.slow def test_loader_calce_legacy_dst_t25_paper2b_compat(tmp_path)` : run the Phase 6.10.b adapter `harmonize()` on `local_root=these_lfp_2026/ecm_fidelity_lfp/data/`, then load with the loader. Assert cell_id == "A123_T25", chemistry == "LFP_A123_APR18650M1A", N > 1000, t[0] == 0.0. Skip if data not present.

### 3. Registry update

If `src/bsebench_datasets/loaders/__init__.py` lazy-exports the loaders, add `CalceLegacyLoader` mirroring the existing pattern.

## Acceptance gates

- **G1** : `uv run pytest tests/test_loader_calce_legacy.py -m "not slow" -v` → ≥ 10 tests passing.
- **G2** : `uv run ruff format --check src/bsebench_datasets/loaders/calce_a123_legacy_loader.py tests/test_loader_calce_legacy.py` → exit 0.
- **G3** : `uv run ruff check src/ tests/` → exit 0.
- **G4** : `git status --porcelain` clean, scope ≤ 3 files (1 loader, 1 test, 1 registry edit).
- **G5** : 1-3 commits with conventional + GLASSBOX format. Each body has `[role: worker-codex-FR]` + 4 sections.
- **G6** : NO `Co-Authored-By: Claude` trailer. Author = `Oussama Akir <claude@cosmocomply.com>`.

## DO NOT

- Implement CalceA123DynLoader or CalceInrDynLoader (deferred to 6.10.e/f).
- Modify the Tier 1 adapter (6.10.b/c already shipped).
- Touch bsebench-runner.
- Push.
- Add `Co-Authored-By: Claude` trailer.

## Cross-references

- 6.10.b commit `6f19df9` (legacy CSV adapter — Tier 1 dependency).
- 6.10.c commit `d765fb2` (dynamic zip adapter — sibling Tier 1, not used here).
- paper2b source : `benchmark_grid_multi.py:97-111` + `prepare.py:25-67`.
- Reference impl : `yao_tu_berlin_2024_loader.py` (most recent loader pattern).
- ADR 0014 §"Pre-flight checklist" + GLASSBOX format spec.

## What happens after this lands

Worker (V2) → status=done. Chef-daemon (V2) → verify_and_merge → KAIZEN.md → PANEL_CHECK.md → (advisor if avg < 89) → unified email to akir.oussama@gmail.com. **First end-to-end exercise of the full V2 cascade.** If the email arrives, the autonomy loop is empirically validated.
