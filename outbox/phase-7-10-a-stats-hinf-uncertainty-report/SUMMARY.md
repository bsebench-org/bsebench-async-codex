# Phase phase-7-10-a-stats-hinf-uncertainty-report summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 90 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-stats
- Target branch : phase-7-10-a-stats-hinf-uncertainty-report
- Branch SHA : d046231e159452a34a892d9dc0659a1591131ae2
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T16:14:59+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+        "mechanical_evidence_only": True,
+        "claim_55_targeted": False,
+        "requirements": {
+            "stats_require_ok_configs": 3,
+            "stats_min_ok_filters": 3,
+        },
+        "trace": trace,
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
 def _assert_no_nulls(value: object) -> None:
     if value is None:
         raise AssertionError("compact report must not contain JSON null")
@@ -30,7 +116,7 @@
 @pytest.mark.fast
 def test_hinf_uncertainty_report_stable_synthetic_case() -> None:
     report = build_hinf_uncertainty_report(
-        _evidence_payload_from_trace(_correlation_trace_payload(unstable=False)),
+        _stable_evidence_payload(),
         share_delta_material_threshold=10.0,
         effect_delta_material_threshold=10.0,
     )
@@ -94,9 +180,12 @@
     }
     assert mechanical["sensitivity_material"]["is_material"] is True
     assert mechanical["apparent_hinf_ordering"]["material_ordering_change"] is True
-    assert mechanical["apparent_hinf_ordering"]["sample_count_weighted"][
-        "target_rank_changed_vs_equal_config"
-    ] is True
+    assert (
+        mechanical["apparent_hinf_ordering"]["sample_count_weighted"][
+            "target_rank_changed_vs_equal_config"
+        ]
+        is True
+    )
     assert report["falsification_gate"]["candidate_status"] == "unstable"
     assert report["falsification_gate"]["candidate_unstable"] is True
     assert report["falsification_gate"]["ordering_materially_changed"] is True

tokens used
222,480
Implemented and committed:

`d046231 GLASSBOX [role: codex-stats-engineer] Add Hinf uncertainty fragility report`

What changed:
- Added deterministic `scripts/hinf_uncertainty_report.py`.
- Added `bsebench_stats.runners.hinf_uncertainty_report`.
- Extended Hinf sensitivity with correlation uncertainty, NASA short-sample reporting, and stricter instability risks.
- Added focused stable/unstable synthetic tests.
- Did not edit thesis files, claim registry files, `claim_55`, or roadmap files.

Real artifact result:
- Report command completed against committed runner artifacts.
- `candidate_status`: `unstable`
- NASA short sample: `97` retained samples vs `2900` max, ratio `29.8969`
- `material_sensitivity_detected`: `true`
- `ordering_materially_changed`: `true`
- `uncertainty_material`: `true`
- risk count: `13`

Validation passed:
- `uv run --locked --all-extras pytest tests/test_hinf_residual_sensitivity.py tests/test_hinf_uncertainty_report.py -q`
- `uv run --locked --all-extras python scripts/hinf_uncertainty_report.py --output /tmp/hinf_uncertainty_report_5x5.json`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q` (`81 passed`)
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`
- `git diff --check`

Worktree is clean and the branch is ahead of `origin/main` by 1 commit.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-a-stats-hinf-uncertainty-report in target_repo. Verify gates. Merge to main if green.
