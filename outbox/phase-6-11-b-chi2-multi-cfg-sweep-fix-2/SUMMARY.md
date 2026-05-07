# Phase phase-6-11-b-chi2-multi-cfg-sweep-fix-2 summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 45 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-runner
- Target branch : phase-6-11-b-chi2-multi-cfg-sweep-fix-2
- Branch SHA : d25828847b3e2ee1ddc7e2f3c68f5845cda4b61c
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T03:05:00+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+            "--sigma-v",
+            "0.01",
+        ],
+        adapter_factories=_mock_adapter_factories(
+            sweep_module,
+            unavailable_wrapper=all_wrappers,
+        ),
+        filter_factories=_mock_filter_factories(sweep_module),
+    )
+
+    captured = capsys.readouterr()
+    assert rc == 2
+    assert not output_path.exists()
+    assert "summary: ok=0, skipped=25, error=0" in captured.out
+    assert "below required minimum 1" in captured.err
+
+
+@pytest.mark.fast
+def test_require_ok_cells_failure_is_loud_and_does_not_write(
+    sweep_module,
+    tmp_path: Path,
+    capsys,
+) -> None:
+    output_path = tmp_path / "chi2_sweep.json"
+
+    rc = sweep_module.main(
+        [
+            "--output",
+            str(output_path),
+            "--n-max",
+            "12",
+            "--warmup-samples",
+            "2",
+            "--sigma-v",
+            "0.01",
+            "--require-ok-cells",
+            "21",
+        ],
+        adapter_factories=_mock_adapter_factories(
+            sweep_module,
+            unavailable_wrapper="panasonic",
+        ),
+        filter_factories=_mock_filter_factories(sweep_module),
+    )
+
+    captured = capsys.readouterr()
+    assert rc == 2
+    assert not output_path.exists()
+    assert "summary: ok=20, skipped=5, error=0" in captured.out
+    assert "below required minimum 21" in captured.err
+
+
+@pytest.mark.fast
 def test_mocked_data_run_produces_expected_5x5_matrix(sweep_module) -> None:
     payload = sweep_module.run_sweep(
         output_path=None,

tokens used
188,214
Implemented and committed `d258288`.

What changed:
- Deleted `outputs/chi2_sweep_5x5.json`; no versioned 0-ok sweep JSON remains.
- Added `--require-ok-cells`, defaulting to `1`, so all-skipped runs fail before writing output. Use `--require-ok-cells 25` for publishable 5x5 evidence, or `0` only for intentional diagnostics.
- Added tests for:
  - 25/25 mocked pass case
  - default all-skipped rejection
  - explicit threshold failure without writing output

Real-data probe result: no HF auth env was present, no exact local Tier 2 Parquet files were found, and all five config loads raised `RepositoryNotFoundError`, so I used the tooling-only path.

Acceptance gates:
- `uv run --all-extras pytest tests/test_chi2_sweep_5x5.py -q` -> 5 passed
- `uv run --all-extras pytest -m "not slow" --tb=short` -> 60 passed
- `uv run --all-extras ruff format --check .` -> passed
- `uv run --all-extras ruff check .` -> passed
- Default real-data probe now exits `2` and writes no temp output
- Commit subject includes `GLASSBOX` and `[role: worker-codex-FR]`
- No `Co-Authored-By: Claude` trailer
- No claim registry, thesis prose, or roadmap edits.
```

## Next step for chef

git fetch origin && git checkout phase-6-11-b-chi2-multi-cfg-sweep-fix-2 in target_repo. Verify gates. Merge to main if green.
