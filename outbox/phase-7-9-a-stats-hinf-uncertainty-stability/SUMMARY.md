# Phase phase-7-9-a-stats-hinf-uncertainty-stability summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 90 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-stats
- Target branch : phase-7-9-a-stats-hinf-uncertainty-stability
- Branch SHA : e96e2746d421ba45ed05154dba36c2db21dc3c06
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T10:52:44+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
     report = build_hinf_residual_sensitivity(
@@ -114,6 +161,10 @@
     assert report["scientific_verdict"] == "none"
     assert report["sample_counts"]["shortest_config_labels"] == ["NASA B0005 T24"]
     assert report["sample_counts"]["max_to_min_retained_sample_ratio"] == pytest.approx(25.0)
+    assert report["short_sample_config"]["config_label"] == "NASA B0005 T24"
+    assert report["correlation_uncertainty"]["short_sample_config"]["status"] == (
+        "reported_separately"
+    )
 
     decomposition = report["decomposition"]
     equal_hinf = decomposition["equal_config_aggregation"]["target_filter"]["mean_metric"]
@@ -128,6 +179,46 @@
     assert "sample_count_imbalance" in risk_ids
     assert "target_filter_weighted_mean_metric_delta" in risk_ids
     assert any(risk_id.startswith("short_config_loo_") for risk_id in risk_ids)
+    assert report["falsification_gate"]["strict_5x5_interpretation"] == (
+        "unstable_under_uncertainty_or_leave_one_config_out"
+    )
+    json.dumps(report, allow_nan=False)
+
+
+@pytest.mark.fast
+def test_hinf_correlation_jackknife_intervals_stable_synthetic_case() -> None:
+    report = build_hinf_residual_sensitivity(
+        _evidence_payload_from_trace(_correlation_trace_payload(unstable=False)),
+        share_delta_material_threshold=10.0,
+        effect_delta_material_threshold=10.0,
+    )
+
+    summary = report["correlation_uncertainty"]["summary"]
+    assert summary["n_per_config_strength_threshold_crossing_intervals"] == 0
+    assert summary["n_aggregate_strength_threshold_crossing_intervals"] == 0
+    assert report["decomposition"]["leave_one_config_out"]["share_delta_summary_vs_equal_config"]
+    assert report["falsification_gate"]["strict_5x5_interpretation"] == (
+        "no_material_instability_detected"
+    )
+    json.dumps(report, allow_nan=False)
+
+
+@pytest.mark.fast
+def test_hinf_correlation_jackknife_intervals_flag_unstable_synthetic_case() -> None:
+    report = build_hinf_residual_sensitivity(
+        _evidence_payload_from_trace(_correlation_trace_payload(unstable=True)),
+        share_delta_material_threshold=10.0,
+        effect_delta_material_threshold=10.0,
+    )
+
+    summary = report["correlation_uncertainty"]["summary"]
+    assert summary["n_per_config_strength_threshold_crossing_intervals"] == 3
+    risk_ids = {risk["id"] for risk in report["falsification_gate"]["risks"]}
+    assert "hinf_per_config_correlation_interval_strength_threshold_crossed" in risk_ids
+    assert report["falsification_gate"]["strict_5x5_interpretation"] == (
+        "unstable_under_uncertainty_or_leave_one_config_out"
+    )
+    assert "unstable" in report["falsification_gate"]["statement"]
     json.dumps(report, allow_nan=False)
 
 

tokens used
155,927
Implemented and committed as `e96e2746d421ba45ed05154dba36c2db21dc3c06`.

Changed:
- Added deterministic delete-1 jackknife Hinf correlation intervals in [hinf_sensitivity.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-9-a-stats-hinf-uncertainty-stability/src/bsebench_stats/runners/hinf_sensitivity.py).
- Extended the CLI in [hinf_residual_sensitivity.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-9-a-stats-hinf-uncertainty-stability/scripts/hinf_residual_sensitivity.py).
- Added all-config LOO decomposition share summaries and explicit NASA short-sample handling.
- Added stable/unstable synthetic tests in [test_hinf_residual_sensitivity.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-9-a-stats-hinf-uncertainty-stability/tests/test_hinf_residual_sensitivity.py).

Real strict evidence result: JSON-safe output at `/tmp/hinf_residual_sensitivity_phase_7_9_a.json`, gate `material_sensitivity_detected`, strict 5x5 interpretation `unstable_under_uncertainty_or_leave_one_config_out`, `risk_count=13`. NASA B0005 T24 is shortest at 97 samples with max/short ratio `29.896907216494846`; 4 per-config Hinf correlation intervals cross the 0.5 strength threshold.

Validation passed:
- `uv run --locked --all-extras pytest tests/test_hinf_residual_sensitivity.py -q`
- real command against `../bsebench-runner/outputs/hinf_residual_evidence_5x5.json`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`

Working tree is clean and ahead by one commit.
```

## Next step for chef

git fetch origin && git checkout phase-7-9-a-stats-hinf-uncertainty-stability in target_repo. Verify gates. Merge to main if green.
