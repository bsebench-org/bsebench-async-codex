# Phase phase-13-13-filters-weight-freeze-20260509T134830Z direct-worker summary

- Direct pid: `3040944`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-filters`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase13-13-filters-weight-freeze-20260509T134830Z`
- Target branch: `glassbox-phase13-13-filters-weight-freeze-20260509T134830Z`
- Branch SHA: `8c58ecb9aa3d7b420288caeb64fbaf0d079588b6`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:06:21.557711Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+    assert manifest["weight_freeze"]["weight_vector_use_allowed"] is False
+    assert (
+        "missing_or_invalid_calibration_provenance_calibration_run_id"
+        in (manifest["blocking_gaps"])
+    )
+    assert "missing_or_invalid_calibration_provenance_runner_commit" in manifest["blocking_gaps"]
+    assert "non_finite_calibration_metric_voltage_rmse_v" in manifest["blocking_gaps"]
+    json.dumps(manifest, allow_nan=False)
+
+
+def test_phase13_weight_freeze_rejects_invalid_weight_vector() -> None:
+    seed_manifest = build_phase13_weight_freeze_manifest(weight_vector=[0.5, 0.5])
+    evidence = _valid_evidence(seed_manifest)
+
+    manifest = build_phase13_weight_freeze_manifest(
+        weight_vector=[0.5, float("inf"), -0.25],
+        calibration_evidence=evidence,
+    )
+
+    assert manifest["ensemble_weight_vector_sha256"] is None
+    assert manifest["weight_freeze"]["weight_vector_use_allowed"] is False
+    assert "non_finite_weight_vector" in manifest["blocking_gaps"]
+    assert "negative_weight_vector" in manifest["blocking_gaps"]
+    assert "weight_vector_sum_not_one" in manifest["blocking_gaps"]
+    assert "missing_weight_vector_hash" in manifest["blocking_gaps"]
+
+
+def test_phase13_weight_freeze_write_report(tmp_path: Path) -> None:
+    manifest = build_phase13_weight_freeze_manifest()
+    paths = write_phase13_weight_freeze_manifest(
+        manifest,
+        output_dir=tmp_path / "outputs",
+        docs_dir=tmp_path / "docs",
+    )
+
+    loaded = json.loads(paths["manifest"].read_text(encoding="utf-8"))
+    report = paths["report"].read_text(encoding="utf-8")
+    assert loaded["weight_freeze"]["transfer_execution_allowed"] is False
+    assert "NO_GO_CLAIM" in report
+    assert "Estimator execution allowed: `False`" in report
+
+
+def _valid_evidence(manifest: dict[str, object]) -> dict[str, object]:
+    return {
+        "calibration_split_manifest_sha256": "a" * 64,
+        "calibration_run_log_sha256": "b" * 64,
+        "member_config_sha256": manifest["member_config_sha256"],
+        "ensemble_weight_vector_sha256": manifest["ensemble_weight_vector_sha256"],
+        "calibration_provenance": {
+            "calibration_split_id": "calce-a123-lfp-dst-t25-calibration",
+            "calibration_run_id": "phase13-weight-freeze-calibration-001",
+            "runner_commit": "abc1234",
+        },
+        "calibration_metrics": {
+            "voltage_rmse_v": 0.012,
+            "validation_member_count": 3.0,
+        },
+    }

tokens used
81,090
Implemented and pushed commit `8c58ecb9aa3d7b420288caeb64fbaf0d079588b6` to `glassbox-phase13-13-filters-weight-freeze-20260509T134830Z`.

Changed only:
- `src/bsebench_filters/phase13_weight_freeze.py`
- `tests/test_phase13_weight_freeze.py`

What landed:
- Fail-closed Phase 13 ensemble weight-freeze manifest gate.
- Requires calibration split hash, calibration run hash, member config hash list, weight vector hash, provenance, and finite metrics.
- Keeps member parameter use, estimator execution, and transfer execution blocked by this gate.
- Focused tests for missing evidence, matching evidence, hash mismatches, missing provenance, non-finite metrics, invalid weights, and report writing.

Validation passed:
- `uv run --extra dev pytest tests/test_phase13_weight_freeze.py`
- `uv run --extra dev ruff check src/bsebench_filters/phase13_weight_freeze.py tests/test_phase13_weight_freeze.py`
- `uv run --extra dev ruff format --check src/bsebench_filters/phase13_weight_freeze.py tests/test_phase13_weight_freeze.py`
- `git diff --check`

Skipped: full project pytest suite; I ran the requested targeted test plus cheap lint/format checks.
```
