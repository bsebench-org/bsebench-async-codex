# Phase phase-7-10-u-runner-phase11-residual-input-contract summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 90 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-runner
- Target branch : phase-7-10-u-runner-phase11-residual-input-contract
- Branch SHA : cf65627e7091fe77d17f5833055f712dd5969138
- Push result : ok
- Merge readiness : ok
- Merge readiness detail : origin/main is an ancestor of HEAD
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-08T16:34:47+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
@@ -203,7 +220,7 @@
     payload = _single_config_payload(config)
     config_payload = _only_config(payload)
 
-    assert config_payload["status"] == INSUFFICIENT_METADATA
+    assert config_payload["status"] == NOT_READY
     assert "missing_pcrlb_mad_floor" in _reason_codes(config_payload)
 
 
@@ -234,13 +251,13 @@
     assert payload["matrix_reasons"][0]["code"] == "empty_config_matrix"
 
 
-def test_all_insufficient_matrix_is_non_ready_at_matrix_level() -> None:
+def test_all_blocked_matrix_is_not_ready_at_matrix_level() -> None:
     config = _complete_config()
     config.pop("sample_count")
 
     payload = _single_config_payload(config)
 
-    assert payload["status"] == INSUFFICIENT_METADATA
+    assert payload["status"] == NOT_READY
     assert payload["ready"] is False
     assert payload["matrix_reasons"][0]["code"] == "all_configs_non_ready"
 
@@ -272,6 +289,34 @@
     assert payload["config_labels"] == ["Config A"]
 
 
+def test_output_metadata_describes_inputs_without_local_paths() -> None:
+    config = _complete_config()
+    config["provenance"]["source"] = "/mnt/private/source-manifest.yaml"
+    payload = _single_config_payload(
+        config,
+        stats_identity={
+            "package": "bsebench-stats",
+            "version": "0.1.test",
+            "path": "/tmp/local-stats-src",
+        },
+    )
+    config_payload = _only_config(payload)
+
+    assert config_payload["metadata"]["identifiers"]["dataset"] == "yao"
+    assert config_payload["metadata"]["units"] == {
+        "voltage": "V",
+        "current": "A",
+        "time": "s",
+    }
+    assert config_payload["metadata"]["source_cache"]["cache_root_present"] is True
+    assert config_payload["metadata"]["provenance"]["source_present"] is True
+    assert payload["stats_dependency_identity"]["path_present"] is True
+    serialized = json.dumps(payload, allow_nan=False)
+    assert "/tmp/local-stats-src" not in serialized
+    assert "/tmp/sanitized-cache" not in serialized
+    assert "/mnt/private/source-manifest.yaml" not in serialized
+
+
 def test_monotonic_time_vector_satisfies_timebase() -> None:
     config = _complete_config()
     config.pop("cadence_s")

tokens used
193,393
Implemented and committed `cf65627` (`GLASSBOX [role: worker-codex-FR] harden P11`).

Changed:
- Hardened Phase 11 residual input contract to fail closed as `not_ready` for missing required units, timebase, sample counts, residual components, PCRLB/MAD inputs, stats identity, provenance, or cache readiness.
- Added sanitized per-config metadata summaries for identifiers, units, timebase, residual components, PCRLB/MAD floor inputs, source/cache readiness, provenance, and stats dependency identity.
- Removed local path emission from the script output; dry-run JSON uses presence/readiness fields and stats commit identity instead.
- Expanded focused tests for fail-closed behavior, `insufficient_metadata`, and local-path redaction.

Validation passed:
- `uv run --locked --all-extras pytest tests/test_phase11_residual_input_contract.py -q` → 18 passed
- Real dry-run over current Phase 11 candidates → `status=not_ready`, `ready=0/5`, `not_ready=5`, no local paths in JSON
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q` → 368 passed, 5 deselected
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`
- `git diff --check`

Only touched the three Phase 11 runner contract files; no protected files were edited.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-u-runner-phase11-residual-input-contract in target_repo. Verify gates. Merge to main if green.
