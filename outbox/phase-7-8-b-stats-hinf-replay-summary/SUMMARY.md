# Phase phase-7-8-b-stats-hinf-replay-summary summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 60 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-stats
- Target branch : phase-7-8-b-stats-hinf-replay-summary
- Branch SHA : 44a0ce37258e5f68707f18dfc4af3f18046f5921
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T08:22:57+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+
+@pytest.mark.fast
 def test_replay_accepts_float_drift_inside_tolerance(
     replay_module: ModuleType,
     tmp_path: Path,
@@ -178,3 +226,53 @@
     assert "hinf residual stats replay failed" in captured.err
     assert "residual_covariance_panel.aggregate_report.covariance_matrix[0][0]" in captured.err
     assert captured.out == ""
+
+
+@pytest.mark.fast
+def test_replay_writes_json_summary_on_stats_mismatch(
+    replay_module: ModuleType,
+    tmp_path: Path,
+    capsys: pytest.CaptureFixture[str],
+) -> None:
+    payload = _evidence_payload()
+    covariance = payload["residual_covariance_panel"]
+    assert isinstance(covariance, dict)
+    embedded = copy.deepcopy(covariance)
+    assert isinstance(embedded, dict)
+    embedded["aggregate_report"]["covariance_matrix"][0][0] += 0.25
+    payload["residual_covariance_panel"] = embedded
+    evidence_path = _write_evidence(tmp_path, payload)
+    summary_path = tmp_path / "replay-mismatch-summary.json"
+
+    rc = replay_module.main(
+        [
+            "--evidence",
+            str(evidence_path),
+            "--max-mismatches",
+            "3",
+            "--json-summary",
+            str(summary_path),
+        ]
+    )
+
+    captured = capsys.readouterr()
+    assert rc == 2
+    assert "hinf residual stats replay failed" in captured.err
+    assert captured.out == ""
+
+    loaded = json.loads(summary_path.read_text(encoding="utf-8"))
+    json.dumps(loaded, allow_nan=False)
+    assert loaded["status"] == "mismatch"
+    assert loaded["replay_status"] == "mismatch"
+    assert loaded["tolerances"] == {"atol": 1.0e-12, "rtol": 1.0e-12}
+    assert loaded["mismatch_count"] > 0
+    assert loaded["decomposition_shares"]["config_share"] == payload[
+        "residual_variance_decomposition"
+    ]["decomposition"]["config_share"]
+    assert loaded["loo_stability_summary"] == payload["residual_variance_decomposition"][
+        "loo_config_stability"
+    ]["summary"]
+    assert loaded["sections"]["residual_covariance_panel"]["status"] == "mismatch"
+    assert loaded["sections"]["residual_covariance_panel"]["mismatch_count"] > 0
+    assert loaded["sections"]["residual_variance_decomposition"]["status"] == "ok"
+    assert loaded["sections"]["residual_variance_decomposition"]["mismatch_count"] == 0

tokens used
175,897
Implemented and committed.

Commit: `44a0ce3`  
`GLASSBOX [role: codex-cto-FR] Add Hinf replay JSON summary`

Changed:
- [scripts/replay_hinf_residual_stats.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-8-b-stats-hinf-replay-summary/scripts/replay_hinf_residual_stats.py)
- [tests/test_hinf_residual_stats_replay.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-8-b-stats-hinf-replay-summary/tests/test_hinf_residual_stats_replay.py)

Validation:
- `uv run scripts/replay_hinf_residual_stats.py --evidence ../bsebench-runner/outputs/hinf_residual_evidence_5x5.json --json-summary /tmp/hinf_replay_summary.json` passed
  - `residual_covariance_panel`: ok, 584 values compared, 0 mismatches
  - `residual_variance_decomposition`: ok, 498 values compared, 0 mismatches
- `uv run pytest tests/test_hinf_residual_stats_replay.py -q`: 5 passed
- `uv run pytest tests/ -m "not slow" -q`: 74 passed
- `uv run ruff check .`: all checks passed

`uv.lock` is not modified or staged.
```

## Next step for chef

git fetch origin && git checkout phase-7-8-b-stats-hinf-replay-summary in target_repo. Verify gates. Merge to main if green.
