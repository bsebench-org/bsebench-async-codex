# Phase phase-6-11-b-chi2-multi-cfg-sweep-fix-1 summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 60 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-runner
- Target branch : phase-6-11-b-chi2-multi-cfg-sweep-fix-1
- Branch SHA : b776508a47a53ae0af14ce3b0e6facef7d56ab0e
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T01:20:09+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+        filter_factories=_mock_filter_factories(sweep_module),
+    )
+
+    assert rc == 0
+    assert output_path.is_file()
+    assert "chi2 sweep 5 configs x 5 filters" in capsys.readouterr().out
+
+    payload = json.loads(output_path.read_text(encoding="utf-8"))
+    assert payload["script"] == "scripts/chi2_sweep_5x5.py"
+    assert payload["summary"] == {"ok": 25, "skipped": 0, "error": 0}
+
+
+@pytest.mark.fast
+def test_mocked_data_run_produces_expected_5x5_matrix(sweep_module) -> None:
+    payload = sweep_module.run_sweep(
+        output_path=None,
+        adapter_factories=_mock_adapter_factories(sweep_module),
+        filter_factories=_mock_filter_factories(sweep_module),
+        n_max=12,
+        warmup_samples=2,
+        sigma_v=0.01,
+    )
+
+    assert payload["sweep"]["n_configs"] == 5
+    assert payload["sweep"]["n_filters"] == 5
+    assert len(payload["matrix"]) == 5
+    assert all(len(row) == 5 for row in payload["matrix"])
+    assert payload["status_matrix"] == [["ok"] * 5 for _ in range(5)]
+    assert len(payload["chi2_matrix"]) == 5
+    assert all(len(row) == 5 for row in payload["chi2_matrix"])
+
+    df = 12 - 2
+    expected_ekf_chi2 = df * (-0.002 / 0.01) ** 2
+    ekf_cell = payload["cells"]["Yao BCDC T25"]["EKF"]
+    assert ekf_cell["chi2"] == pytest.approx(expected_ekf_chi2)
+    assert ekf_cell["rmse_mV"] == pytest.approx(2.0)
+    assert ekf_cell["sensor_noise"]["method"] == "user_override_sigma_v"
+
+
+@pytest.mark.fast
+def test_unavailable_config_cells_are_explicit_and_deterministic(sweep_module) -> None:
+    payload = sweep_module.run_sweep(
+        output_path=None,
+        adapter_factories=_mock_adapter_factories(
+            sweep_module,
+            unavailable_wrapper="panasonic",
+        ),
+        filter_factories=_mock_filter_factories(sweep_module),
+        n_max=12,
+        warmup_samples=2,
+        sigma_v=0.01,
+    )
+
+    panasonic_row_index = payload["config_labels"].index("Panasonic US06 T25")
+    panasonic_row = payload["matrix"][panasonic_row_index]
+
+    assert payload["summary"] == {"ok": 20, "skipped": 5, "error": 0}
+    assert payload["status_matrix"][panasonic_row_index] == ["skipped"] * 5
+    assert {cell["reason"] for cell in panasonic_row} == {"config_load_failed"}
+    assert {cell["error"]["type"] for cell in panasonic_row} == {"FileNotFoundError"}
+    assert payload["chi2_matrix"][panasonic_row_index] == [None] * 5

tokens used
134,349
Implemented and committed `b776508`:

`feat(sweep): add GLASSBOX chi2 5x5 sweep [role: worker-codex-FR]`

Added:
- [scripts/chi2_sweep_5x5.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-6-11-b-chi2-multi-cfg-sweep-fix-1/scripts/chi2_sweep_5x5.py)
- [tests/test_chi2_sweep_5x5.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-6-11-b-chi2-multi-cfg-sweep-fix-1/tests/test_chi2_sweep_5x5.py)
- [outputs/chi2_sweep_5x5.json](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-6-11-b-chi2-multi-cfg-sweep-fix-1/outputs/chi2_sweep_5x5.json)

Verification passed:
- `uv run pytest tests/test_chi2_sweep_5x5.py -m fast --tb=short`: 3 passed
- `uv run pytest -m "not slow" --tb=short`: 58 passed, 5 deselected
- `uv run ruff format --check .`: passed
- `uv run ruff check .`: passed

The generated sweep JSON records all 25 cells as explicit `skipped` cells in this unauthenticated environment because Hugging Face dataset fetches returned 401/repository-not-found responses. Request IDs are redacted, and the script will populate `ok` chi2/p-value/RMSE cells when the Tier 2 data is available. No `Co-Authored-By: Claude` trailer was added.
```

## Next step for chef

git fetch origin && git checkout phase-6-11-b-chi2-multi-cfg-sweep-fix-1 in target_repo. Verify gates. Merge to main if green.
