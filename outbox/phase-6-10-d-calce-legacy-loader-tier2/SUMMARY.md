# Phase phase-6-10-d-calce-legacy-loader-tier2 summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 30 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-6-10-d-calce-legacy-loader-tier2
- Branch SHA : 8000b59eb55766f7d31a6abdcfcd32f035ef1ad2
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-06T20:57:50+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+    assert set(out) == {
+        "t",
+        "V",
+        "I",
+        "T_meas",
+        "N",
+        "T_amb",
+        "cell_id",
+        "dataset",
+        "chemistry",
+        "source_url",
+    }
+
+
+def test_loader_length_consistency(tmp_path: Path) -> None:
+    loader = _loader_for_parquet(tmp_path, n_samples=17)
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
+def test_loader_downloader_receives_expected_filename(tmp_path: Path) -> None:
+    parquet_path = tmp_path / _parquet_filename(25)
+    _write_synthetic_parquet(parquet_path)
+    calls: list[str] = []
+
+    def downloader(filename: str) -> str:
+        calls.append(filename)
+        return str(parquet_path)
+
+    loader = CalceLegacyLoader(downloader=downloader)
+    out = loader.load("DST", 25.0)
+    assert calls == ["calce_a123_DST_T25.parquet"]
+    assert out["cell_id"] == "A123_T25"
+
+
+@pytest.mark.slow
+def test_loader_calce_legacy_dst_t25_paper2b_compat(tmp_path: Path) -> None:
+    raw_root = CALCE_LOCAL_RAW_ROOT
+    raw_csv = raw_root / "A123_25C.csv"
+    if not raw_csv.is_file():
+        pytest.skip(f"local CALCE A123 CSV not found at {raw_csv}")
+
+    written = CalceA123Adapter(local_root=raw_root).harmonize(output_dir=tmp_path)
+    assert "A123_T25" in written
+
+    loader = CalceLegacyLoader(local_cache_root=tmp_path)
+    out = loader.load("DST", 25.0)
+    assert out["cell_id"] == "A123_T25"
+    assert out["chemistry"] == "LFP_A123_APR18650M1A"
+    assert out["N"] > 1000
+    assert out["t"][0] == 0.0

tokens used
94,566
Implemented and committed Phase 6.10.d.

Commit: `8000b59 feat(loaders): add calce legacy loader`

Changed scope is exactly 3 files:
- `src/bsebench_datasets/loaders/calce_a123_legacy_loader.py`
- `tests/test_loader_calce_legacy.py`
- `src/bsebench_datasets/loaders/__init__.py`

Gates run:
- `uv run pytest tests/test_loader_calce_legacy.py -m "not slow" -v` → 14 passed, 1 deselected
- `uv run ruff format --check src/bsebench_datasets/loaders/calce_a123_legacy_loader.py tests/test_loader_calce_legacy.py` → passed
- `uv run ruff check src/ tests/` → passed
- `git status --porcelain` → clean

Commit author is `Oussama Akir <claude@cosmocomply.com>`, GLASSBOX body is present, and there is no `Co-Authored-By: Claude` trailer. I did not push.
```

## Next step for chef

git fetch origin && git checkout phase-6-10-d-calce-legacy-loader-tier2 in target_repo. Verify gates. Merge to main if green.
