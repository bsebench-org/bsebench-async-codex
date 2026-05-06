# Phase phase-6-10-g-calce-inr-20r-loader-tier2 summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 30 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-6-10-g-calce-inr-20r-loader-tier2
- Branch SHA : 7c294e392e58937d1e15956002f5942e30628e35
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-06T22:27:10+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+def test_loader_metadata_values(tmp_path: Path) -> None:
+    loader = _loader_for_parquet(tmp_path, temperature_c=45.0)
+    out = loader.load("DST", 25.0)
+    assert out["T_amb"] == 25.0
+    assert np.allclose(out["T_meas"], 45.0)
+    assert out["dataset"] == "calce_inr_20r"
+    assert out["chemistry"] == "NMC_CALCE_INR18650_20R"
+    assert out["source_url"] == "https://calce.umd.edu/battery-data"
+
+
+def test_loader_soc50_vs_soc80(tmp_path: Path) -> None:
+    _write_synthetic_parquet(tmp_path / _parquet_filename("US06", 25, 50), current_a=-1.0)
+    _write_synthetic_parquet(tmp_path / _parquet_filename("US06", 25, 80), current_a=-2.0)
+    loader = CalceInr20RLoader(local_cache_root=tmp_path)
+
+    out50 = loader.load("US06", 25.0, soc_start=50)
+    out80 = loader.load("US06", 25.0, soc_start=80)
+
+    assert out50["cell_id"] == "INR_US06_T25_soc50"
+    assert out80["cell_id"] == "INR_US06_T25_soc80"
+    assert np.allclose(out50["I"], 1.0)
+    assert np.allclose(out80["I"], 2.0)
+
+
+def test_loader_downloader_receives_expected_filename(tmp_path: Path) -> None:
+    parquet_path = tmp_path / _parquet_filename("FUDS", 45, 50)
+    _write_synthetic_parquet(parquet_path)
+    calls: list[str] = []
+
+    def downloader(filename: str) -> str:
+        calls.append(filename)
+        return str(parquet_path)
+
+    loader = CalceInr20RLoader(downloader=downloader)
+    out = loader.load("FUDS", 45.0, soc_start=50)
+    assert calls == ["calce_inr_20r_FUDS_T45_soc50.parquet"]
+    assert out["cell_id"] == "INR_FUDS_T45_soc50"
+
+
+@pytest.mark.slow
+def test_loader_calce_inr_20r_dst_t25_paper2b_compat(tmp_path: Path) -> None:
+    raw_root = CALCE_INR_LOCAL_RAW_ROOT
+    raw_zip = raw_root / T_TO_ZIP_PATTERN.format(T=25, profile="DST")
+    if not raw_zip.is_file():
+        pytest.skip(f"local CALCE INR-20R dynamic zip not found at {raw_zip}")
+
+    pytest.importorskip("pandas")
+    pytest.importorskip("openpyxl")
+
+    written = CalceInr20RAdapter(local_root=raw_zip).harmonize(output_dir=tmp_path)
+    assert {"INR_DST_T25_soc50", "INR_DST_T25_soc80"} <= written.keys()
+
+    loader = CalceInr20RLoader(local_cache_root=tmp_path)
+    out80 = loader.load("DST", 25.0)
+    out50 = loader.load("DST", 25.0, soc_start=50)
+
+    assert out80["cell_id"] == "INR_DST_T25_soc80"
+    assert out50["cell_id"] == "INR_DST_T25_soc50"
+    assert out80["chemistry"] == "NMC_CALCE_INR18650_20R"
+    assert out80["N"] > 1000
+    assert out80["t"][0] == 0.0

tokens used
189,370
Implémenté et committé.

Commit: `7c294e3 feat(loaders): add calce INR-20R loader`

Changements:
- Ajout de [calce_inr_20r_loader.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-6-10-g-calce-inr-20r-loader-tier2/src/bsebench_datasets/loaders/calce_inr_20r_loader.py:1) avec `CalceInr20RLoader`, `wrapper_name="calce_inr_dyn"`, HF repo, fallback local, SoC par défaut `80`, schema 10 clés, et flip `I = -current_A`.
- Export lazy ajouté dans [loaders/__init__.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-6-10-g-calce-inr-20r-loader-tier2/src/bsebench_datasets/loaders/__init__.py:134).
- Ajout de [test_loader_calce_inr_20r.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-6-10-g-calce-inr-20r-loader-tier2/tests/test_loader_calce_inr_20r.py:1) avec 19 fast tests + 1 slow test adapter réel.

Vérifications passées:
- `uv run --extra dev pytest -m 'not slow' tests/test_loader_calce_inr_20r.py -q`
- `uv run --extra dev --with openpyxl pytest -m slow tests/test_loader_calce_inr_20r.py -q`
- `uv run --extra dev ruff format --check ...`
- `uv run --extra dev ruff check src/ tests/`

`git status` est clean, scope = 3 fichiers, 1 commit GLASSBOX avec `[role: worker-codex-FR]`, sans `Co-Authored-By Claude`.
```

## Next step for chef

git fetch origin && git checkout phase-6-10-g-calce-inr-20r-loader-tier2 in target_repo. Verify gates. Merge to main if green.
