# phase-14-04-stats-model-uncertainty-20260509T145752Z direct-worker summary

- Direct pid: `3067799`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase14-04-stats-model-uncertainty-20260509T145752Z`
- Target branch: `glassbox-phase14-04-stats-model-uncertainty-20260509T145752Z`
- Branch SHA: `16cd2b370937da243cc3e4d38b39e999dbf90040`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T15:32:01.217315Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+        (
+            lambda payload: payload["models"][0]["bound_artifact"].update(
+                {"state_dimension": 3}
+            ),
+            "dimension_mismatch:models[0].bound_artifact.state_dimension expected=2 actual=3",
+        ),
+        (
+            lambda payload: payload["models"][0]["bound_artifact"]["information_matrices"][0][
+                "values"
+            ][0].__setitem__(0, math.inf),
+            "invalid_information_matrix:models[0].bound_artifact.information_matrices[0]",
+        ),
+        (
+            lambda payload: payload["models"][1]["bound_artifact"]["bound_covariances"][1][
+                "values"
+            ][1].__setitem__(1, -0.01),
+            "invalid_bound_covariance:models[1].bound_artifact.bound_covariances[1]",
+        ),
+    ],
+)
+def test_missing_or_invalid_model_evidence_blocks_preflight(
+    mutate: Callable[[dict[str, Any]], object],
+    expected_gap: str,
+) -> None:
+    payload = _payload()
+    mutate(payload)
+
+    report = build_phase14_model_uncertainty_preflight(payload)
+
+    assert report["decision"]["preflight_status"] == "blocked"
+    assert expected_gap in report["blocking_gaps"]
+    assert report["decision"]["bound_computation_allowed"] is False
+    assert report["scientific_verdict"] == NO_GO_CLAIM
+    _assert_strict_json(report)
+
+
+@pytest.mark.fast
+def test_duplicate_model_ids_and_unsupported_claim_flags_fail_closed() -> None:
+    payload = _payload()
+    payload["models"][1]["model_id"] = "model-a"
+    payload["claims"]["sota"] = True
+
+    report = build_phase14_model_uncertainty_preflight(payload)
+
+    assert report["decision"]["preflight_status"] == "blocked"
+    assert "duplicate_model_id:model-a" in report["blocking_gaps"]
+    assert "unsupported_claim:sota" in report["blocking_gaps"]
+    assert report["scientific_verdict"] == NO_GO_CLAIM
+    _assert_strict_json(report)
+
+
+@pytest.mark.fast
+def test_builder_rejects_non_mapping_payload_and_invalid_options() -> None:
+    with pytest.raises(Phase14ModelUncertaintyError, match="payload must be a mapping"):
+        build_phase14_model_uncertainty_preflight(["not", "a", "mapping"])  # type: ignore[arg-type]
+
+    with pytest.raises(Phase14ModelUncertaintyError, match="generated_at"):
+        build_phase14_model_uncertainty_preflight(_payload(), generated_at=" ")
+
+    with pytest.raises(Phase14ModelUncertaintyError, match="weight_sum_atol"):
+        build_phase14_model_uncertainty_preflight(copy.deepcopy(_payload()), weight_sum_atol=-1.0)

tokens used
179,688
Implemented and pushed the Phase 14 model-uncertainty/oracle-mixture preflight.

Changed:
- [phase14_model_uncertainty.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase14-04-stats-model-uncertainty-20260509T145752Z/src/bsebench_stats/phase14_model_uncertainty.py)
- [test_phase14_model_uncertainty.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase14-04-stats-model-uncertainty-20260509T145752Z/tests/test_phase14_model_uncertainty.py)

Commit pushed:
`16cd2b3 GLASSBOX [role: phase14-stats-model-uncertainty] add oracle-mixture preflight`

Validation:
- Focused pytest: `23 passed`
- Full pytest after rebasing onto current `origin/main`: `411 passed`
- `ruff check`: passed
- `git diff --check`: passed

No validation skipped. Branch is pushed and tracking `origin/glassbox-phase14-04-stats-model-uncertainty-20260509T145752Z`.
```
