# Phase phase-7-10-i-datasets-phase8-cache-probe summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 90 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-7-10-i-datasets-phase8-cache-probe
- Branch SHA : 91b14f456ac572318ce4b1c26933f5883f21c9e8
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T19:07:44+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
     calce_files = configs["calce_legacy:DST:T25"]["required_files"]
     assert calce_files[0]["size_bytes"] == valid_path.stat().st_size  # type: ignore[index]
     assert calce_files[0]["sha256"] == hashlib.sha256(valid_path.read_bytes()).hexdigest()  # type: ignore[index]
     assert payload["evidence_ready"] is False
     assert payload["summary"] == {  # type: ignore[index]
-        "configs_total": 3,
+        "configs_total": 4,
         "present_and_loader_readable": 1,
         "present_but_unreadable": 1,
         "missing": 1,
-        "gap_configs": 2,
+        "unknown_metadata": 1,
+        "gap_configs": 3,
+        "gap_metadata_datasets": 0,
     }
+    assert payload["availability_summary"]["configs"] == {  # type: ignore[index]
+        "ready": 1,
+        "missing": 1,
+        "unreadable": 1,
+        "unknown_metadata": 1,
+    }
+    assert payload["availability"]["ready"]["config_labels"] == [  # type: ignore[index]
+        "calce_legacy:DST:T25"
+    ]
+    assert payload["availability"]["missing"]["config_labels"] == ["yao:BCDC:T35"]  # type: ignore[index]
+    assert payload["availability"]["unreadable"]["config_labels"] == [  # type: ignore[index]
+        "panasonic:US06:T25"
+    ]
+    assert payload["availability"]["unknown_metadata"]["config_labels"] == [  # type: ignore[index]
+        "nasa:CC-discharge:T24"
+    ]
     json.dumps(payload, allow_nan=False)
 
 
@@ -189,6 +220,7 @@
 
     config = payload["configs"][0]
     assert config["status"] == STATUS_LOADER_READABLE
+    assert config["availability_status"] == "ready"
     assert config["selection"] == {
         "cell_id": "B0005",
         "test_id": 1,
@@ -428,8 +460,19 @@
     assert payload["coverage_summary"]["scope_counts"]["phase8_lg_hg2_manifest_grid"] == 27  # type: ignore[index]
     metadata = {item["dataset"]: item for item in payload["metadata_datasets"] if "dataset" in item}
     assert metadata["lg_hg2_stroebl_2024"]["manifest_backed_config_count"] == 27
+    assert metadata["lg_hg2_stroebl_2024"]["availability_status"] == "unknown_metadata"
     assert payload["near_future_prep"]["phase8"]["manifest_backed_config_count"] == 27  # type: ignore[index]
     assert payload["near_future_prep"]["phase11"]["manifest_backed_config_count"] == 0  # type: ignore[index]
+    assert (
+        payload["near_future_prep"]["phase11"]["loader_readiness"]["status"]  # type: ignore[index]
+        == STATUS_UNKNOWN_METADATA
+    )
+    assert (
+        "lg_hg2_stroebl_2024"
+        in payload["availability"]["unknown_metadata"][  # type: ignore[index]
+            "metadata_datasets"
+        ]
+    )
 
 
 def test_manifest_redacts_token_like_path_fragments(tmp_path: Path) -> None:

tokens used
171,724
Implemented and committed `91b14f4` (`probe(cache): separate availability buckets`).

Changed:
- [auditj_local_cache_manifest.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-10-i-datasets-phase8-cache-probe/src/bsebench_datasets/auditj_local_cache_manifest.py): adds `unknown_metadata`, `availability_status`, top-level `availability`, and `availability_summary`.
- [test_auditj_local_cache_manifest.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-10-i-datasets-phase8-cache-probe/tests/test_auditj_local_cache_manifest.py): pins ready, missing, unreadable, and unknown-metadata behavior.

Validation run:
- Focused probe tests: `13 passed`
- Read-only local probe: wrote diagnostic JSON to `/tmp/bsebench_phase8_cache_probe.json`; not committed
- Full non-slow tests: `240 passed, 29 deselected`
- `ruff check .`: passed
- `ruff format --check .`: passed
- `git diff --check`: passed

Worktree is clean and the branch is ahead by 1 commit. No protected files were edited, and the commit has GLASSBOX metadata with no `Co-Authored-By Claude` trailer.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-i-datasets-phase8-cache-probe in target_repo. Verify gates. Merge to main if green.
