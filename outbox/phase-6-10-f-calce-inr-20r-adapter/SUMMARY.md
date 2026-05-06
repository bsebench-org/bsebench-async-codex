# Phase phase-6-10-f-calce-inr-20r-adapter summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 30 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-6-10-f-calce-inr-20r-adapter
- Branch SHA : c05e611376a0a6dd935a943c4b0a1259e5c13073
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-06T21:29:18+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+    assert isinstance(adapter.local_root, Path)
+    assert adapter.local_root == tmp_path
+
+
+def test_harmonize_empty_local_root_returns_empty_dict(tmp_path: Path) -> None:
+    out_dir = tmp_path / "out"
+
+    written = CalceInr20RAdapter(local_root=tmp_path).harmonize(output_dir=out_dir)
+
+    assert written == {}
+    assert list(out_dir.glob("*.parquet")) == []
+
+
+def test_harmonize_synthetic_zip_writes_expected_cell_id(tmp_path: Path) -> None:
+    written = _run_synthetic_zip(tmp_path, _segment_df())
+
+    expected_path = tmp_path / "out" / "calce_inr_20r_DST_T25_soc80.parquet"
+    assert written == {"INR_DST_T25_soc80": expected_path}
+    assert expected_path.is_file()
+
+
+def test_cell_id_format_is_forensic_profile_temp_soc(tmp_path: Path) -> None:
+    written = _run_synthetic_zip(tmp_path, _segment_df())
+
+    assert list(written) == ["INR_DST_T25_soc80"]
+
+
+def test_harmonize_writes_bpx_columns_and_constant_temperature(tmp_path: Path) -> None:
+    written = _run_synthetic_zip(tmp_path, _segment_df())
+    table = pq.read_table(written["INR_DST_T25_soc80"])
+
+    assert table.column_names == ["time_s", "voltage_V", "current_A", "temperature_C"]
+    assert table.column("time_s").to_pylist()[:3] == pytest.approx([0.0, 10.0, 20.0])
+    assert table.column("temperature_C").to_pylist()[:3] == pytest.approx([25.0, 25.0, 25.0])
+
+
+def test_harmonize_preserves_raw_current_sign(tmp_path: Path) -> None:
+    written = _run_synthetic_zip(tmp_path, _segment_df(currents=[-1.25, 0.5, -2.0]))
+    table = pq.read_table(written["INR_DST_T25_soc80"])
+
+    assert table.column("current_A").to_pylist()[:6] == pytest.approx(
+        [-1.25, 0.5, -2.0, -1.25, 0.5, -2.0]
+    )
+
+
+def test_harmonize_skips_segment_shorter_than_100_rows(tmp_path: Path) -> None:
+    written = _run_synthetic_zip(tmp_path, _segment_df(rows=99))
+
+    assert written == {}
+    assert list((tmp_path / "out").glob("*.parquet")) == []
+
+
+@pytest.mark.slow
+@pytest.mark.skipif(not REAL_DST_ZIP.is_file(), reason="CALCE INR-20R DST zip is absent")
+def test_harmonize_real_dst_zip_writes_two_soc_parquets(tmp_path: Path) -> None:
+    pytest.importorskip("openpyxl")
+
+    written = CalceInr20RAdapter(local_root=REAL_DST_ZIP).harmonize(output_dir=tmp_path / "out")
+
+    assert written.keys() == {"INR_DST_T25_soc50", "INR_DST_T25_soc80"}
+    assert {path.name for path in written.values()} == {
+        "calce_inr_20r_DST_T25_soc50.parquet",
+        "calce_inr_20r_DST_T25_soc80.parquet",
+    }

tokens used
195,051
Implemented and committed `c05e611 feat(calce): add INR-20R Tier 1 adapter`.

Changed only:
- [calce_inr_20r_2014.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-6-10-f-calce-inr-20r-adapter/src/bsebench_datasets/adapters/calce_inr_20r_2014.py)
- [test_adapter_calce_inr_20r.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-6-10-f-calce-inr-20r-adapter/tests/test_adapter_calce_inr_20r.py)

Verification passed:
- `uv run --extra dev pytest -m 'not slow' tests/test_adapter_calce_inr_20r.py` -> 8 passed, 1 deselected
- `uv run --extra dev pytest -m slow tests/test_adapter_calce_inr_20r.py` -> 1 passed
- `uv run --extra dev ruff format --check src/bsebench_datasets/adapters/calce_inr_20r_2014.py tests/test_adapter_calce_inr_20r.py`
- `uv run --extra dev ruff check src/ tests/`

Final status: worktree clean, branch ahead by 1 commit, scope is 2 files, and the commit has no `Co-Authored-By: Claude` trailer.
```

## Next step for chef

git fetch origin && git checkout phase-6-10-f-calce-inr-20r-adapter in target_repo. Verify gates. Merge to main if green.
