# Phase phase-6-10-b-calce-legacy-csv-harmonize summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 30 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-6-10-b-calce-legacy-csv-harmonize
- Branch SHA : 6f19df9663d99c9e08305bd9a76f5f9790224891
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-06T18:10:26+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+    rows = [(float(idx), 0.0, 3.2, 25.0, (idx % 7) + 1) for idx in range(12)]
+    _write_legacy_csv(tmp_path, rows=rows)
+
+    written = CalceA123Adapter(local_root=tmp_path).harmonize(output_dir=tmp_path / "out")
+
+    assert written == {}
+
+
+def test_harmonize_sign_not_flipped(tmp_path: Path) -> None:
+    rows = [
+        (0.0, 0.0, 3.4, 25.0, 7),
+        (1.0, -1.0, 3.3, 25.0, 8),
+        (2.0, -0.5, 3.2, 25.0, 9),
+        (3.0, 0.25, 3.25, 25.0, 10),
+    ]
+    _write_legacy_csv(tmp_path, rows=rows)
+
+    written = CalceA123Adapter(local_root=tmp_path).harmonize(output_dir=tmp_path / "out")
+    table = _read_table(written["A123_T25"])
+
+    assert table.column("current_A").to_pylist() == pytest.approx([-1.0, -0.5, 0.25])
+
+
+def test_harmonize_zero_bases_time(tmp_path: Path) -> None:
+    rows = [
+        (100.0, 0.0, 3.4, 25.0, 1),
+        (101.0, 0.0, 3.4, 25.0, 2),
+        (102.0, 0.0, 3.4, 25.0, 3),
+        (103.0, 0.0, 3.4, 25.0, 4),
+        (104.0, 0.0, 3.4, 25.0, 7),
+        (200.0, -1.0, 3.3, 25.0, 8),
+        (200.5, -1.0, 3.29, 25.0, 8),
+        (201.5, -1.0, 3.28, 25.0, 9),
+    ]
+    _write_legacy_csv(tmp_path, rows=rows)
+
+    written = CalceA123Adapter(local_root=tmp_path).harmonize(output_dir=tmp_path / "out")
+    table = _read_table(written["A123_T25"])
+
+    assert table.column("time_s").to_pylist() == pytest.approx([0.0, 0.5, 1.5])
+
+
+def test_harmonize_writes_3_temps_when_all_csvs_present(tmp_path: Path) -> None:
+    rows = [
+        (0.0, 0.0, 3.4, 25.0, 7),
+        (1.0, -1.0, 3.3, 25.0, 8),
+        (2.0, -1.0, 3.2, 25.0, 9),
+    ]
+    for csv_name in LEGACY_T_TO_CSV.values():
+        _write_legacy_csv(tmp_path, csv_name, rows=rows)
+
+    written = CalceA123Adapter(local_root=tmp_path).harmonize(output_dir=tmp_path / "out")
+
+    assert written.keys() == {"A123_T0", "A123_T25", "A123_T40"}
+    assert {path.name for path in written.values()} == {
+        "calce_a123_DST_T0.parquet",
+        "calce_a123_DST_T25.parquet",
+        "calce_a123_DST_T40.parquet",
+    }

tokens used
169,484
Implemented and committed locally.

Changed:
- [calce_a123_2014.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-6-10-b-calce-legacy-csv-harmonize/src/bsebench_datasets/adapters/calce_a123_2014.py:45): removed `BaseAdapter` shim, added `LEGACY_T_TO_CSV`, implemented legacy CSV harmonize branch.
- [test_adapter_calce_a123_skeleton.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-6-10-b-calce-legacy-csv-harmonize/tests/test_adapter_calce_a123_skeleton.py:73): replaced skeleton NotImplemented test with legacy harmonize tests, kept original smoke coverage colocated.

Verification:
- `uv run pytest tests/test_adapter_calce_a123_*.py -v` -> 11 passed
- `uv run ruff format --check src/bsebench_datasets/adapters/calce_a123_2014.py tests/test_adapter_calce_a123_*.py` -> passed
- `uv run ruff check src/ tests/` -> passed
- `grep -n 'BaseAdapter\|ModuleNotFoundError' ...` -> no matches
- `git status --porcelain` -> clean after commit

Commit:
- `6f19df9 feat(calce): harmonize legacy A123 CSVs`
- Author/committer: `Oussama Akir <claude@cosmocomply.com>`
- No `Co-Authored-By` trailer
- No push performed.
```

## Next step for chef

git fetch origin && git checkout phase-6-10-b-calce-legacy-csv-harmonize in target_repo. Verify gates. Merge to main if green.
