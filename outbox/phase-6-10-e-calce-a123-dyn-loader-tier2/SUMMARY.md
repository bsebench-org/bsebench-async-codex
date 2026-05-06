# Phase phase-6-10-e-calce-a123-dyn-loader-tier2 summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 30 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-6-10-e-calce-a123-dyn-loader-tier2
- Branch SHA : e38ef298338b5338bccf0aaf95985eff4c33fb74
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-06T21:06:27+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+    out = loader.load("DST", 25.0)
+    n = out["N"]
+    assert len(out["t"]) == len(out["V"]) == len(out["I"]) == len(out["T_meas"]) == n
+
+
+def test_loader_metadata_values(tmp_path: Path) -> None:
+    loader = _loader_for_parquet(tmp_path)
+    out = loader.load("DST", 25.0)
+    assert out["T_amb"] == 25.0
+    assert out["dataset"] == "calce_a123_lfp"
+    assert out["chemistry"] == "LFP_A123_APR18650M1A"
+    assert out["source_url"] == "https://calce.umd.edu/battery-data"
+
+
+def test_loader_cell_idx_zero_vs_one(tmp_path: Path) -> None:
+    _write_synthetic_parquet(tmp_path / _parquet_filename("US06", 20, 0), current_a=-1.0)
+    _write_synthetic_parquet(tmp_path / _parquet_filename("US06", 20, 1), current_a=-2.0)
+    loader = CalceA123DynLoader(local_cache_root=tmp_path)
+
+    out0 = loader.load("US06", 20.0, cell_idx=0)
+    out1 = loader.load("US06", 20.0, cell_idx=1)
+
+    assert out0["cell_id"] == "A123_US06_T20_cell0"
+    assert out1["cell_id"] == "A123_US06_T20_cell1"
+    assert np.allclose(out0["I"], 1.0)
+    assert np.allclose(out1["I"], 2.0)
+
+
+def test_loader_downloader_receives_expected_filename(tmp_path: Path) -> None:
+    parquet_path = tmp_path / _parquet_filename("FUDS", 50, 1)
+    _write_synthetic_parquet(parquet_path)
+    calls: list[str] = []
+
+    def downloader(filename: str) -> str:
+        calls.append(filename)
+        return str(parquet_path)
+
+    loader = CalceA123DynLoader(downloader=downloader)
+    out = loader.load("FUDS", 50.0, cell_idx=1)
+    assert calls == ["calce_a123_dyn_FUDS_T50_cell1.parquet"]
+    assert out["cell_id"] == "A123_FUDS_T50_cell1"
+
+
+@pytest.mark.slow
+def test_loader_calce_a123_dyn_dst_t25_cell0_paper2b_compat(tmp_path: Path) -> None:
+    raw_root = CALCE_LOCAL_DYN_RAW_ROOT
+    raw_zip = raw_root / DYN_T_TO_ZIP[25]
+    if not raw_zip.is_file():
+        pytest.skip(f"local CALCE A123 dynamic zip not found at {raw_zip}")
+
+    pytest.importorskip("pandas")
+    pytest.importorskip("openpyxl")
+
+    written = CalceA123Adapter(local_root=raw_root).harmonize(output_dir=tmp_path)
+    assert "A123_DST_T25_cell0" in written
+
+    loader = CalceA123DynLoader(local_cache_root=tmp_path)
+    out = loader.load("DST", 25.0, cell_idx=0)
+    assert out["cell_id"] == "A123_DST_T25_cell0"
+    assert out["chemistry"] == "LFP_A123_APR18650M1A"
+    assert out["N"] > 1000
+    assert out["t"][0] == 0.0

tokens used
166,770
Implemented and committed `e38ef29` (`feat(loaders): add calce A123 dynamic loader`).

Changed scope is exactly 3 files:
- [calce_a123_dyn_loader.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-6-10-e-calce-a123-dyn-loader-tier2/src/bsebench_datasets/loaders/calce_a123_dyn_loader.py)
- [test_loader_calce_a123_dyn.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-6-10-e-calce-a123-dyn-loader-tier2/tests/test_loader_calce_a123_dyn.py)
- [loaders/__init__.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-6-10-e-calce-a123-dyn-loader-tier2/src/bsebench_datasets/loaders/__init__.py)

Verified:
- `uv run --extra dev pytest tests/test_loader_calce_a123_dyn.py -m "not slow" -v` -> `18 passed, 1 deselected`
- `uv run --extra dev ruff format --check src/ tests/` -> passed
- `uv run --extra dev ruff check src/ tests/` -> passed
- `git status --short --branch` -> clean, branch ahead by 1 commit
- Commit body has GLASSBOX sections and no `Co-Authored-By: Claude` trailer

The slow local integration test is included and skips when the CALCE dynamic raw zip is absent; I did not run the slow test.
```

## Next step for chef

git fetch origin && git checkout phase-6-10-e-calce-a123-dyn-loader-tier2 in target_repo. Verify gates. Merge to main if green.
