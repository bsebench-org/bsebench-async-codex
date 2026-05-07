# Phase phase-7-6-a-residual-cov-trace-panel summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 45 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-stats
- Target branch : phase-7-6-a-residual-cov-trace-panel
- Branch SHA : 2da10f86b6366a01036d11fd9479b0a8aab54eb7
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T03:48:05+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+@pytest.mark.parametrize(
+    ("mutate", "message"),
+    [
+        (lambda payload: payload.pop("configs"), "trace_payload must include configs"),
+        (
+            lambda payload: payload["configs"]["cfg_a"].pop("filters"),
+            r"configs\['cfg_a'\] must include filters",
+        ),
+        (
+            lambda payload: payload["configs"]["cfg_a"]["filters"]["EKF"].pop("residual_mV"),
+            r"filters\['EKF'\] must include residual_mV",
+        ),
+    ],
+)
+def test_missing_required_keys_raise_clear_errors(mutate, message: str):
+    payload = _payload()
+    mutate(payload)
+
+    with pytest.raises(ValueError, match=message):
+        build_residual_covariance_panel(payload)
+
+
+@pytest.mark.fast
+def test_file_runner_writes_json_only_after_ok_config_requirement_passes(tmp_path):
+    payload = _payload()
+    payload["config_labels"] = ["cfg_a"]
+    input_path = tmp_path / "trace.json"
+    output_path = tmp_path / "panel.json"
+    input_path.write_text(json.dumps(payload), encoding="utf-8")
+
+    with pytest.raises(ResidualCovariancePanelRequirementError):
+        run_residual_covariance_panel(input_path, output_path, require_ok_configs=2)
+    assert not output_path.exists()
+
+    report = run_residual_covariance_panel(input_path, output_path, require_ok_configs=1)
+
+    assert output_path.exists()
+    loaded = json.loads(output_path.read_text(encoding="utf-8"))
+    assert loaded == report
+    json.dumps(loaded, allow_nan=False)
+
+
+@pytest.mark.fast
+def test_top_level_export_matches_runner_export():
+    assert build_residual_covariance_panel_top_level is build_residual_covariance_panel
+
+
+@pytest.mark.fast
+def test_constant_filter_correlation_remains_json_safe():
+    payload = copy.deepcopy(_payload())
+    configs = payload["configs"]
+    assert isinstance(configs, dict)
+    configs["cfg_a"]["filters"]["Hinf"] = _ok_filter([1.0, 1.0, 1.0, 1.0])
+    configs["cfg_b"]["filters"]["Hinf"] = _ok_filter([1.0, 1.0, 1.0, 1.0])
+
+    report = build_residual_covariance_panel(payload, require_ok_configs=2)
+
+    assert report["per_config_reports"]["cfg_a"]["correlation_matrix"][0][2] is None
+    json.dumps(report, allow_nan=False)
+    assert np.asarray(report["aggregate_report"]["covariance_matrix"], dtype=float).shape == (3, 3)

tokens used
153,344
Implemented and committed the Phase 7.6.a stats-side trace-panel consumer.

Commit: `2da10f86b6366a01036d11fd9479b0a8aab54eb7`  
Subject: `GLASSBOX [role: worker-codex-FR] Add residual covariance trace panel`

Changes:
- Added [residual_cov.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-6-a-residual-cov-trace-panel/src/bsebench_stats/runners/residual_cov.py:273) with `build_residual_covariance_panel` and `run_residual_covariance_panel`.
- Exported the new API from runner and top-level packages.
- Added focused synthetic tests in [test_residual_cov_panel_runner.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-6-a-residual-cov-trace-panel/tests/test_residual_cov_panel_runner.py:69).
- Removed generated `uv.lock`; none is present or committed.

Acceptance gates passed:
- `uv run --all-extras pytest -m "not slow" --tb=short`
- `uv run --all-extras ruff format --check .`
- `uv run --all-extras ruff check .`

Worktree is clean and the branch is ahead by 1 commit.
```

## Next step for chef

git fetch origin && git checkout phase-7-6-a-residual-cov-trace-panel in target_repo. Verify gates. Merge to main if green.
