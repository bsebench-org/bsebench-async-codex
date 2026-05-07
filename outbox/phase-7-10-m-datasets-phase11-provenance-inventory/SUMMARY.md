# Phase phase-7-10-m-datasets-phase11-provenance-inventory summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 90 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-7-10-m-datasets-phase11-provenance-inventory
- Branch SHA : 2b97c256c86128bc057ec394a40610a086a7d665
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T20:33:49+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+    tmp_path: Path,
+) -> None:
+    split_path = _write_split(tmp_path / "split.yaml", [("calce_legacy", "DST", 25.0)])
+    calce_root = tmp_path / "calce"
+    calce_root.mkdir()
+    table = pa.table(
+        {
+            "time_s": pa.array([0.0], type=pa.float64()),
+            "voltage_V": pa.array([4.0], type=pa.float64()),
+            "temperature_C": pa.array([25.0], type=pa.float64()),
+        }
+    )
+    pq.write_table(table, str(calce_root / "calce_a123_DST_T25.parquet"))
+
+    payload = build_auditj_local_cache_manifest(
+        split_path,
+        cache_root_overrides={"calce_legacy": calce_root},
+        datasets_roots=(),
+        env={},
+    )
+
+    config = _status_by_label(payload)["calce_legacy:DST:T25"]
+    phase11 = _phase11_by_label(payload)["calce_legacy:DST:T25"]
+    assert config["status"] == STATUS_PRESENT_UNREADABLE
+    assert config["gap_kind"] == "loader_read_error"
+    assert phase11["phase11_status"] == "unreadable"
+    assert phase11["fields"]["voltage_unit"] == {  # type: ignore[index]
+        "status": "ready",
+        "value": "V",
+        "source": "local Parquet column voltage_V",
+    }
+    assert phase11["fields"]["current_unit"]["status"] == "unknown_metadata"  # type: ignore[index]
+    assert "value" not in phase11["fields"]["current_unit"]  # type: ignore[index]
+    assert phase11["fields"]["sampling_cadence"]["status"] == "unknown_metadata"  # type: ignore[index]
+    assert set(phase11["blocking_gap_fields"]) >= {  # type: ignore[arg-type]
+        "local_cache",
+        "current_unit",
+        "sampling_cadence",
+    }
+    json.dumps(payload, allow_nan=False)
+
+
 def test_manifest_marks_missing_cache_root_as_gap(tmp_path: Path) -> None:
     split_path = _write_split(tmp_path / "split.yaml", [("calce_legacy", "DST", 25.0)])
 
@@ -473,6 +541,16 @@
             "metadata_datasets"
         ]
     )
+    phase11_metadata = {
+        item["dataset"]: item
+        for item in payload["phase11_inventory"]["metadata_datasets"]  # type: ignore[index]
+        if "dataset" in item
+    }
+    assert phase11_metadata["lg_hg2_stroebl_2024"]["phase11_status"] == "not_applicable"
+    assert (
+        phase11_metadata["lg_hg2_stroebl_2024"]["local_cache_readiness"]["status"]
+        == "not_applicable"
+    )
 
 
 def test_manifest_redacts_token_like_path_fragments(tmp_path: Path) -> None:

tokens used
213,754
Implemented and committed Phase 11 provenance inventory as `2b97c25`.

Changed:
- [auditj_local_cache_manifest.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-10-m-datasets-phase11-provenance-inventory/src/bsebench_datasets/auditj_local_cache_manifest.py): adds `phase11_inventory` JSON with dataset id, chemistry/profile/temperature, local readiness, voltage/current units from local Parquet schema, cadence availability, `ready/missing/unreadable/unknown_metadata/not_applicable`, and explicit provenance gaps.
- [test_auditj_local_cache_manifest.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-10-m-datasets-phase11-provenance-inventory/tests/test_auditj_local_cache_manifest.py): adds focused coverage for ready, missing, unreadable, unknown metadata, not applicable, and unit/cadence gaps.

Validation passed:
- `uv run --locked --all-extras pytest tests/test_auditj_local_cache_manifest.py -q`
- local read-only inventory command wrote `/tmp/bsebench_phase11_provenance_inventory.json`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q` (`241 passed, 29 deselected`)
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`
- `git diff --check`

Local inventory result: no loader-facing Tier 2 cache roots were available, so Phase 11 marked 58 candidate configs `missing` and 13 metadata-only registry entries `not_applicable`. Worktree is clean and the phase branch is ahead by one commit.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-m-datasets-phase11-provenance-inventory in target_repo. Verify gates. Merge to main if green.
