# Phase phase-6-10-c-calce-zip-bundle-harmonize summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 30 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-6-10-c-calce-zip-bundle-harmonize
- Branch SHA : d765fb24021b9cf31cb2d1f08bec30a0d5368b97
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-06T19:14:05+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
     assert CALCE_A123_DYN_TEMPS_C == (-10, 0, 10, 20, 25, 30, 40, 50)
@@ -54,6 +93,12 @@
     assert DATASET_TAG == "calce_a123_lfp"
 
 
+def test_dyn_constants() -> None:
+    assert len(DYN_T_TO_ZIP) == 8
+    assert tuple(DYN_T_TO_ZIP) == (-10, 0, 10, 20, 25, 30, 40, 50)
+    assert DYN_PROFILE_TO_STEP == {"DST": 8, "US06": 16, "FUDS": 24}
+
+
 def test_class_attributes() -> None:
     assert CalceA123Adapter.DATASET_NAME == DATASET_TAG
     assert CalceA123Adapter.CHEMISTRY == CHEMISTRY_TAG
@@ -172,3 +217,46 @@
         "calce_a123_DST_T25.parquet",
         "calce_a123_DST_T40.parquet",
     }
+
+
+def test_harmonize_dyn_skips_missing_zip(tmp_path: Path) -> None:
+    written = CalceA123Adapter(local_root=tmp_path).harmonize(output_dir=tmp_path / "out")
+
+    assert written == {}
+    assert list((tmp_path / "out").glob("calce_a123_dyn_*.parquet")) == []
+
+
+def test_harmonize_dyn_writes_parquet_for_one_profile_one_t_one_cell(tmp_path: Path) -> None:
+    written = _run_dyn_mock(tmp_path, _dyn_df({8: 200}))
+
+    expected_path = tmp_path / "out" / "calce_a123_dyn_DST_T25_cell0.parquet"
+    assert written == {"A123_DST_T25_cell0": expected_path}
+    assert expected_path.is_file()
+
+    table = _read_table(expected_path)
+    assert table.num_rows == 200
+    assert table.column_names == ["time_s", "voltage_V", "current_A", "temperature_C"]
+    assert table.column("time_s").to_pylist()[:3] == pytest.approx([0.0, 1.0, 2.0])
+    assert table.column("current_A").to_pylist()[0] == pytest.approx(-1.0)
+
+
+def test_harmonize_dyn_segments_three_profiles(tmp_path: Path) -> None:
+    written = _run_dyn_mock(tmp_path, _dyn_df({8: 120, 16: 140, 24: 160}))
+
+    assert set(written) == {
+        "A123_DST_T25_cell0",
+        "A123_US06_T25_cell0",
+        "A123_FUDS_T25_cell0",
+    }
+    assert _read_table(written["A123_DST_T25_cell0"]).num_rows == 120
+    assert _read_table(written["A123_US06_T25_cell0"]).num_rows == 140
+    assert _read_table(written["A123_FUDS_T25_cell0"]).num_rows == 160
+
+
+def test_harmonize_dyn_skips_short_segments(
+    tmp_path: Path, capsys: pytest.CaptureFixture[str]
+) -> None:
+    written = _run_dyn_mock(tmp_path, _dyn_df({8: 120, 16: 50, 24: 130}))
+
+    assert set(written) == {"A123_DST_T25_cell0", "A123_FUDS_T25_cell0"}
+    assert "US06 T=25 cell=0 Step_Index=16 has 50 rows; skipping" in capsys.readouterr().out

tokens used
210,955
Implemented and committed Phase 6.10.c.

Commit: `d765fb2 feat(calce): harmonize dynamic A123 zips`

Changed:
- [calce_a123_2014.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-6-10-c-calce-zip-bundle-harmonize/src/bsebench_datasets/adapters/calce_a123_2014.py)
- [test_adapter_calce_a123_skeleton.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-6-10-c-calce-zip-bundle-harmonize/tests/test_adapter_calce_a123_skeleton.py)

Verified:
- `uv run pytest tests/test_adapter_calce_a123_*.py -m "not slow" -v` -> `16 passed`
- `uv run ruff format --check src/bsebench_datasets/adapters/calce_a123_2014.py tests/test_adapter_calce_a123_*.py` -> passed
- `uv run ruff check src/ tests/` -> passed
- Real T25 smoke with ephemeral `openpyxl` -> `6` Parquets written for `3 profiles x 2 cells`
- Empirical sign check on T25 DST `Step_Index=8`: `Current(A) min=-3.84941 max=1.92527`, confirming raw current is BPX-aligned and not flipped

Worktree is clean. I did not push.
```

## Next step for chef

git fetch origin && git checkout phase-6-10-c-calce-zip-bundle-harmonize in target_repo. Verify gates. Merge to main if green.
