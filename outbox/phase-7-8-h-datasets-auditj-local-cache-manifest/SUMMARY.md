# Phase phase-7-8-h-datasets-auditj-local-cache-manifest summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 90 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-7-8-h-datasets-auditj-local-cache-manifest
- Branch SHA : 6dc874c5bc001d42694797560b9ba15f3347d0bc
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T08:57:47+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+        cache_root_overrides={"nasa": nasa_root},
+        env={},
+    )
+
+    config = payload["configs"][0]
+    assert config["status"] == STATUS_LOADER_READABLE
+    assert config["selection"] == {
+        "cell_id": "B0005",
+        "test_id": 1,
+        "selection_policy": "paper2b_preferred_fresh_cell",
+    }
+    assert [item["filename"] for item in config["required_files"]] == [  # type: ignore[index]
+        "metadata.csv",
+        "B0005_test1.parquet",
+    ]
+    assert config["load_probe"]["runtime_identity"] == {  # type: ignore[index]
+        "cell_id": "B0005",
+        "test_id": 1,
+        "T_amb": 24.0,
+    }
+    assert payload["evidence_ready"] is True
+
+
+def test_manifest_marks_missing_cache_root_as_gap(tmp_path: Path) -> None:
+    split_path = _write_split(tmp_path / "split.yaml", [("calce_legacy", "DST", 25.0)])
+
+    payload = build_auditj_local_cache_manifest(split_path, env={})
+
+    config = payload["configs"][0]
+    assert config["status"] == STATUS_MISSING
+    assert config["gap_kind"] == "missing_cache_root"
+    assert payload["evidence_ready"] is False
+    assert payload["gap_config_labels"] == ["calce_legacy:DST:T25"]
+
+
+def test_hash_size_limit_keeps_size_and_skips_digest(tmp_path: Path) -> None:
+    split_path = _write_split(tmp_path / "split.yaml", [("calce_legacy", "DST", 25.0)])
+    calce_root = tmp_path / "calce"
+    calce_root.mkdir()
+    parquet_path = calce_root / "calce_a123_DST_T25.parquet"
+    _write_loader_parquet(parquet_path)
+
+    payload = build_auditj_local_cache_manifest(
+        split_path,
+        cache_root_overrides={"calce_legacy": calce_root},
+        hash_max_bytes=1,
+        env={},
+    )
+
+    file_payload = payload["configs"][0]["required_files"][0]
+    assert file_payload["size_bytes"] == parquet_path.stat().st_size
+    assert file_payload["sha256"] is None
+    assert file_payload["hash_status"] == "skipped_size_limit"
+    assert payload["configs"][0]["status"] == STATUS_LOADER_READABLE
+
+
+def test_cache_root_override_parser_rejects_unknown_wrapper() -> None:
+    with pytest.raises(AuditJLocalCacheManifestError, match="unknown wrapper"):
+        parse_cache_root_overrides(["unknown=/tmp/cache"])

tokens used
295,337
Implemented and committed `6dc874c5bc001d42694797560b9ba15f3347d0bc` on `phase-7-8-h-datasets-auditj-local-cache-manifest`.

Changed:
- [auditj_local_cache_manifest.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-8-h-datasets-auditj-local-cache-manifest/src/bsebench_datasets/auditj_local_cache_manifest.py): local-only Audit J cache manifest/probe with file size, SHA256 where practical, explicit `missing`, `present_but_unreadable`, and `present_and_loader_readable` states.
- [auditj_local_cache_manifest.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-8-h-datasets-auditj-local-cache-manifest/scripts/auditj_local_cache_manifest.py): CLI with `--cache-root`, env-var roots, `--allow-gaps`, and default non-ready failure behavior.
- [test_auditj_local_cache_manifest.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-8-h-datasets-auditj-local-cache-manifest/tests/test_auditj_local_cache_manifest.py): synthetic fixtures for missing, corrupt/unreadable, loader-readable, NASA metadata-derived selection, and hash-limit cases.

Validation run:
- `uv run python scripts/auditj_local_cache_manifest.py --output /tmp/auditj_local_cache_manifest.json --allow-gaps`
  - `ready=False`, `loader_readable=0`, `missing=26`, `gaps=26`
- `uv run pytest tests/test_auditj_local_cache_manifest.py -q`
  - `5 passed`
- `uv run pytest tests/ -m "not slow" -q`
  - `227 passed, 29 deselected`
- `uv run ruff check .`
  - passed

No thesis files, claim registry, or roadmap files were edited. The GLASSBOX commit has no `Co-Authored-By Claude` trailer.
```

## Next step for chef

git fetch origin && git checkout phase-7-8-h-datasets-auditj-local-cache-manifest in target_repo. Verify gates. Merge to main if green.
