# Phase phase-7-8-g-stats-hinf-weighting-sensitivity summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 90 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-stats
- Target branch : phase-7-8-g-stats-hinf-weighting-sensitivity
- Branch SHA : 525ddb8240fb0733c7dc0f6bfc6d523d8eef8fbf
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T08:54:39+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+        "residual_covariance_panel": build_residual_covariance_panel(
+            trace,
+            require_ok_configs=3,
+            min_ok_filters=3,
+        ),
+        "residual_variance_decomposition": build_residual_variance_decomposition(
+            trace,
+            require_ok_configs=3,
+            min_ok_filters=3,
+        ),
+    }
+
+
+@pytest.mark.fast
+def test_hinf_sensitivity_surfaces_unequal_sample_weighting_risk() -> None:
+    report = build_hinf_residual_sensitivity(
+        _evidence_payload(),
+        share_delta_material_threshold=0.01,
+        effect_delta_material_threshold=0.10,
+    )
+
+    assert report["schema_version"] == "hinf_residual_sensitivity_v1"
+    assert report["mechanical_evidence_only"] is True
+    assert report["scientific_verdict"] == "none"
+    assert report["sample_counts"]["shortest_config_labels"] == ["NASA B0005 T24"]
+    assert report["sample_counts"]["max_to_min_retained_sample_ratio"] == pytest.approx(25.0)
+
+    decomposition = report["decomposition"]
+    equal_hinf = decomposition["equal_config_aggregation"]["target_filter"]["mean_metric"]
+    weighted_hinf = decomposition["sample_count_weighted_aggregation"]["target_filter"][
+        "mean_metric"
+    ]
+    assert weighted_hinf < equal_hinf
+
+    gate = report["falsification_gate"]
+    assert gate["status"] == "material_sensitivity_detected"
+    risk_ids = {risk["id"] for risk in gate["risks"]}
+    assert "sample_count_imbalance" in risk_ids
+    assert "target_filter_weighted_mean_metric_delta" in risk_ids
+    assert any(risk_id.startswith("short_config_loo_") for risk_id in risk_ids)
+    json.dumps(report, allow_nan=False)
+
+
+@pytest.mark.fast
+def test_hinf_sensitivity_runner_writes_json_without_claim_language(tmp_path) -> None:
+    evidence_path = tmp_path / "hinf_residual_evidence_5x5.json"
+    output_path = tmp_path / "hinf_residual_sensitivity.json"
+    evidence_path.write_text(json.dumps(_evidence_payload(), allow_nan=False), encoding="utf-8")
+
+    report = run_hinf_residual_sensitivity(
+        evidence_path,
+        output_path,
+        share_delta_material_threshold=0.01,
+        effect_delta_material_threshold=0.10,
+    )
+
+    loaded = json.loads(output_path.read_text(encoding="utf-8"))
+    assert loaded == report
+    text = json.dumps(loaded, sort_keys=True).lower()
+    for forbidden in ("verified", "novel", "sota", "thesis"):
+        assert forbidden not in text
+    json.dumps(loaded, allow_nan=False)

tokens used
199,298
Implemented and committed as `525ddb8`:

- Added [scripts/hinf_residual_sensitivity.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-8-g-stats-hinf-weighting-sensitivity/scripts/hinf_residual_sensitivity.py) and [hinf_sensitivity.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-8-g-stats-hinf-weighting-sensitivity/src/bsebench_stats/runners/hinf_sensitivity.py).
- Added unequal-sample synthetic coverage in [test_hinf_residual_sensitivity.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-8-g-stats-hinf-weighting-sensitivity/tests/test_hinf_residual_sensitivity.py).
- Exported the new helper through `bsebench_stats.runners` and top-level `bsebench_stats`.

Real command against `../bsebench-runner/outputs/hinf_residual_evidence_5x5.json` emitted `material_sensitivity_detected`: NASA has 97 samples vs 2900 for the others, max/min ratio `29.896907216494846`, and both sample weighting and NASA leave-one-out move dominant decomposition share from `config_share` to `filter_share`.

Validation passed:

- `uv run python scripts/hinf_residual_sensitivity.py --output /tmp/hinf_residual_sensitivity.json`
- `uv run pytest tests/ -m "not slow" -q` -> 74 passed
- `uv run ruff check .` -> passed

Worktree is clean; branch is ahead by 1 commit.
```

## Next step for chef

git fetch origin && git checkout phase-7-8-g-stats-hinf-weighting-sensitivity in target_repo. Verify gates. Merge to main if green.
