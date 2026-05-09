# Phase phase-13-11-filters-time-varying-weights-20260509T134830Z direct-worker summary

- Direct pid: `3040257`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-filters`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase13-11-filters-time-varying-weights-20260509T134830Z`
- Target branch: `glassbox-phase13-11-filters-time-varying-weights-20260509T134830Z`
- Branch SHA: `f2c3f20913b8fa3b0d788eb4080d8725124d1bbd`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:06:19.015932Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+
+
+def test_constructor_fails_closed_for_missing_member_hash_evidence() -> None:
+    bad_member = member("ekf", 1.0)
+    bad_evidence = dict(bad_member.evidence)
+    bad_evidence.pop("split_manifest_sha256")
+    bad_member = TimeVaryingWeightMember(
+        member_id=bad_member.member_id,
+        estimator_name=bad_member.estimator_name,
+        implementation=bad_member.implementation,
+        split_id=bad_member.split_id,
+        provenance_id=bad_member.provenance_id,
+        initial_weight=bad_member.initial_weight,
+        evidence=bad_evidence,
+    )
+
+    with pytest.raises(
+        ValueError,
+        match=r"members\.ekf\.evidence\.split_manifest_sha256",
+    ):
+        Phase13TimeVaryingWeightAdapter([bad_member])
+
+
+def test_update_fails_closed_when_a_member_metric_is_missing() -> None:
+    adapter = Phase13TimeVaryingWeightAdapter(
+        [
+            member("ekf", 0.5, offset=0),
+            member("hinf", 0.5, offset=4),
+        ],
+    )
+
+    with pytest.raises(ValueError, match="missing members: hinf"):
+        adapter.update_weights(update({"ekf": {"validation_residual_mae": 0.2}}))
+
+    assert adapter.get_weights() == pytest.approx({"ekf": 0.5, "hinf": 0.5})
+    assert adapter.get_adaptation_evidence()["events"] == []
+
+
+def test_update_fails_closed_for_nonfinite_metrics_and_missing_update_hashes() -> None:
+    adapter = Phase13TimeVaryingWeightAdapter([member("ekf", 1.0)])
+
+    with pytest.raises(ValueError, match=r"validation_residual_mae.*must be finite"):
+        adapter.update_weights(update({"ekf": {"validation_residual_mae": float("nan")}}))
+
+    bad_update = TimeVaryingWeightUpdateInput(
+        update_id="phase13-update-bad-evidence",
+        step_index=0,
+        t=0.0,
+        split_id="phase13-validation-split",
+        provenance_id="phase13-update-provenance",
+        metrics_by_member={"ekf": {"validation_residual_mae": 0.2}},
+        evidence={"dataset_manifest_sha256": sha("1")},
+    )
+    with pytest.raises(ValueError, match=r"update\.evidence\.split_manifest_sha256"):
+        adapter.update_weights(bad_update)
+
+
+def test_adapter_skeleton_blocks_estimator_execution_and_soc_derivation() -> None:
+    adapter = Phase13TimeVaryingWeightAdapter([member("ekf", 1.0)])
+
+    with pytest.raises(Phase13ExecutionBlockedError, match="does not execute estimators"):
+        adapter.step(t=0.0, voltage_V=3.3, current_A=0.0, temperature_C=25.0)
+
+    with pytest.raises(Phase13ExecutionBlockedError, match="does not derive SOC/SOH"):
+        adapter.estimate(t=0.0, voltage_V=3.3, current_A=0.0, temperature_C=25.0)

tokens used
106,733
Implemented and pushed commit `f2c3f20` to `glassbox-phase13-11-filters-time-varying-weights-20260509T134830Z`.

Changed:
- [phase13_time_varying_weights.py](/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase13-11-filters-time-varying-weights-20260509T134830Z/src/bsebench_filters/phase13_time_varying_weights.py): non-executing Phase 13 time-varying weight adapter skeleton with bounded simplex projection, exact-member metric updates, hash/provenance/split evidence validation, and explicit execution/SOC-SOH derivation blockers.
- [test_phase13_time_varying_weights.py](/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase13-11-filters-time-varying-weights-20260509T134830Z/tests/test_phase13_time_varying_weights.py): focused coverage for deterministic bounded updates, missing evidence, missing members, non-finite metrics, and blocked execution.

Validation:
- `COVERAGE_FILE=.coverage.phase13_time_varying .venv/bin/python -m pytest tests/test_phase13_time_varying_weights.py` passed: 5 tests.
- `.venv/bin/ruff check src tests` passed.
- `git diff --cached --check` passed before commit.

Skipped: full pytest suite, because the requested validation was targeted and the cheap broader check was covered by full `ruff check src tests`.
```
