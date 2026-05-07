# Phase phase-7-6-b-runner-residual-trace-5x5 summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 50 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-runner
- Target branch : phase-7-6-b-runner-residual-trace-5x5
- Branch SHA : d32f0e4cf55fed460c5788c1796febe1a39694b2
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T03:52:18+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+    )
+
+    captured = capsys.readouterr()
+    assert rc == 2
+    assert not output_path.exists()
+    assert "summary: ok_configs=0, error_configs=1" in captured.out
+    assert "ok_configs=0/1" in captured.err
+
+
+@pytest.mark.fast
+def test_require_ok_filter_runs_prevents_output_writing(
+    trace_module,
+    tmp_path: Path,
+    capsys,
+) -> None:
+    config = trace_module.SweepConfig("Config A", "wrapper_a", "P1", 25.0)
+    filters = (trace_module.SweepFilter("failing", "failing"),)
+    output_path = tmp_path / "should_not_exist.json"
+
+    rc = trace_module.main(
+        [
+            "--output",
+            str(output_path),
+            "--n-max",
+            "5",
+            "--warmup-samples",
+            "1",
+            "--require-ok-configs",
+            "1",
+            "--require-ok-filter-runs",
+            "1",
+        ],
+        adapter_factories={
+            "wrapper_a": lambda: lambda profile, t_c: _synthetic_data(profile, t_c, n_samples=5)
+        },
+        filter_factories={"failing": _FailingFilter},
+        config_targets=(config,),
+        filter_targets=filters,
+    )
+
+    captured = capsys.readouterr()
+    assert rc == 2
+    assert not output_path.exists()
+    assert "ok_filter_runs=0/1" in captured.err
+
+
+@pytest.mark.fast
+def test_output_json_serializes_with_allow_nan_false(trace_module, tmp_path: Path) -> None:
+    configs, filters = _targets(trace_module)
+    payload = trace_module.run_residual_trace_5x5(
+        output_path=None,
+        adapter_factories=_adapter_factories(configs),
+        filter_factories=_filter_factories(),
+        config_targets=configs,
+        filter_targets=filters,
+        n_max=5,
+        warmup_samples=2,
+        require_ok_configs=2,
+        require_ok_filter_runs=4,
+    )
+
+    assert '"residual_mV"' in json.dumps(payload, allow_nan=False)
+    with pytest.raises(ValueError, match="Out of range float values"):
+        trace_module.write_result_json({"bad": float("nan")}, tmp_path / "bad.json")

tokens used
164,911
Implemented and committed on `phase-7-6-b-runner-residual-trace-5x5`:

`d32f0e4 GLASSBOX [role: worker-codex-FR] add residual trace 5x5 producer`

Added [scripts/residual_trace_5x5.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-7-6-b-runner-residual-trace-5x5/scripts/residual_trace_5x5.py:1) and fast synthetic coverage in [tests/test_residual_trace_5x5.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-7-6-b-runner-residual-trace-5x5/tests/test_residual_trace_5x5.py:1). The script reuses the 5x5 sweep targets/factory builders, writes measured voltage once per config, emits residual arrays only for ok filters, records config/filter errors without fake arrays, and fails loud without writing when requirements are not met.

Acceptance gates run on the target worktree:

- `uv run --locked --all-extras pytest -m "not slow" --tb=short`: 73 passed, 5 deselected
- `uv run --locked --all-extras ruff format --check .`: passed
- `uv run --locked --all-extras ruff check .`: passed

No `outputs/residual_trace_5x5.json` real-data artifact was created, and the commit has no `Co-Authored-By: Claude` trailer.
```

## Next step for chef

git fetch origin && git checkout phase-7-6-b-runner-residual-trace-5x5 in target_repo. Verify gates. Merge to main if green.
