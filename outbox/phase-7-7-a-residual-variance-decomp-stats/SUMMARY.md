# Phase phase-7-7-a-residual-variance-decomp-stats summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 50 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-stats
- Target branch : phase-7-7-a-residual-variance-decomp-stats
- Branch SHA : 58eacbcd38fa6e60b1431e0dd2933b1ab7237db2
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T04:12:52+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+        build_residual_variance_decomposition(payload)
+
+
+@pytest.mark.fast
+def test_duplicate_labels_raise_clear_error():
+    payload = _small_payload()
+    payload["filter_labels"] = ["EKF", "UKF", "UKF"]
+
+    with pytest.raises(ValueError, match=r"filter_labels.*unique"):
+        build_residual_variance_decomposition(payload)
+
+
+@pytest.mark.fast
+def test_config_with_too_few_ok_filters_is_skipped_and_can_fail_loud():
+    payload = _small_payload()
+    payload["config_labels"] = ["cfg_a"]
+    configs = payload["configs"]
+    assert isinstance(configs, dict)
+    configs["cfg_a"]["filters"]["UKF"] = _error_filter()
+    configs["cfg_a"]["filters"]["Hinf"] = _error_filter()
+
+    with pytest.raises(
+        ResidualVarianceDecompositionRequirementError,
+        match="below required minimum",
+    ) as exc:
+        build_residual_variance_decomposition(payload, require_ok_configs=1)
+
+    partial = exc.value.payload
+    assert partial["summary"]["ok_configs"] == 0
+    assert partial["summary"]["skipped_configs"] == 1
+    assert partial["skipped_configs"][0]["reason"] == "fewer_than_min_ok_filters"
+    assert partial["decomposition"] is None
+
+
+@pytest.mark.fast
+def test_file_runner_writes_json_only_after_requirements_pass(tmp_path):
+    payload = _small_payload()
+    input_path = tmp_path / "trace.json"
+    output_path = tmp_path / "decomp.json"
+    input_path.write_text(json.dumps(payload), encoding="utf-8")
+
+    with pytest.raises(ResidualVarianceDecompositionRequirementError):
+        run_residual_variance_decomposition(input_path, output_path, require_ok_configs=3)
+    assert not output_path.exists()
+
+    report = run_residual_variance_decomposition(
+        input_path,
+        output_path,
+        require_ok_configs=2,
+    )
+
+    assert output_path.exists()
+    loaded = json.loads(output_path.read_text(encoding="utf-8"))
+    assert loaded == report
+    json.dumps(loaded, allow_nan=False)
+
+
+@pytest.mark.fast
+def test_top_level_export_matches_runner_export():
+    assert build_residual_variance_decomposition_top_level is build_residual_variance_decomposition

tokens used
99,206
Implemented and committed Phase 7.7.a.

Commit: `58eacbcd38fa6e60b1431e0dd2933b1ab7237db2`  
Message includes `GLASSBOX: [role: worker-codex-FR]`; no `Co-Authored-By: Claude` trailer.

Changes:
- Added [residual_decomp.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-7-a-residual-variance-decomp-stats/src/bsebench_stats/runners/residual_decomp.py)
- Exported runner/top-level APIs from package `__init__` files
- Added focused synthetic tests in [test_residual_decomp_runner.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-7-a-residual-variance-decomp-stats/tests/test_residual_decomp_runner.py)

Validation passed:
- `uv run --locked --all-extras pytest tests/test_residual_decomp_runner.py -q --tb=short` → 16 passed
- `uv run --locked --all-extras pytest -m "not slow" --tb=short` → 67 passed
- `uv run --locked --all-extras ruff format --check .` → passed
- `uv run --locked --all-extras ruff check .` → passed

No `uv.lock` was committed. No README, roadmap, claim registry, thesis prose, scientific verdict, plots, or real-data outputs were edited or generated. Note: `docs/RESEARCH-ROADMAP-2026-05-06.md` was not present in this worktree, so I proceeded from the available residual covariance and trace-producer references.
```

## Next step for chef

git fetch origin && git checkout phase-7-7-a-residual-variance-decomp-stats in target_repo. Verify gates. Merge to main if green.
