# phase-15-07-runner-adaptive-plan-20260509T163452Z direct-worker summary

- Direct pid: `3081898`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-runner`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase15-07-runner-adaptive-plan-20260509T163452Z`
- Target branch: `glassbox-phase15-07-runner-adaptive-plan-20260509T163452Z`
- Branch SHA: `34faf44bdb456b127ee31c53b012beac1a0db928`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T16:58:18.143034Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+    payload["claims"]["filter_superiority"] = True
+    payload["notes"] = ["blocked dry-run note describing adaptive gain"]
+    payload["execution_request"] = {"estimator_execution": True}
+
+    plan = build_phase15_adaptive_plan(payload)
+
+    assert plan["decision"]["plan_status"] == "blocked"
+    assert plan["decision"]["estimator_execution_allowed"] is False
+    assert "unsupported_claim:rmse_gain" in plan["blocking_gaps"]
+    assert "unsupported_claim:filter_superiority" in plan["blocking_gaps"]
+    assert "forbidden_wording:inputs.notes[0]:adaptive_gain" in plan["blocking_gaps"]
+    assert "execution_refused:estimator_execution" in plan["blocking_gaps"]
+    assert plan["component_status"]["execution_request"]["refused_actions"] == [
+        "estimator_execution"
+    ]
+
+
+def test_phase15_adaptive_plan_blocks_unsupported_update_rule_and_residual_source() -> None:
+    payload = _inputs()
+    payload["evidence"]["update_rule"]["rule_family"] = "online_estimator_training"
+    payload["evidence"]["residual_source"]["source_type"] = "newly_computed_residuals"
+    payload["evidence"]["residual_source"]["split_id"] = "synthetic_evaluation"
+    payload["evidence"]["safety_gate"]["gate_inputs"]["leakage_check_passed"] = False
+
+    plan = build_phase15_adaptive_plan(payload)
+
+    assert plan["decision"]["plan_status"] == "blocked"
+    assert "unsupported_update_rule_family:online_estimator_training" in plan["blocking_gaps"]
+    assert "unsupported_residual_source_type:newly_computed_residuals" in plan["blocking_gaps"]
+    assert "residual_source_split_mismatch" in plan["blocking_gaps"]
+    assert "safety_gate_leakage_check_not_passed" in plan["blocking_gaps"]
+
+
+def test_phase15_adaptive_plan_rejects_invalid_input_collection() -> None:
+    with pytest.raises(Phase15AdaptivePlanError, match="inputs must be a mapping"):
+        build_phase15_adaptive_plan(["not", "a", "mapping"])  # type: ignore[arg-type]
+
+    with pytest.raises(Phase15AdaptivePlanError, match="generated_at must be a non-empty string"):
+        build_phase15_adaptive_plan(_inputs(), generated_at=" ")
+
+
+def test_phase15_adaptive_plan_load_write_and_hash_are_deterministic(tmp_path: Path) -> None:
+    inputs_path = tmp_path / "inputs.json"
+    inputs_path.write_text(json.dumps(_inputs(), indent=2, sort_keys=True) + "\n", encoding="utf-8")
+    inputs = load_phase15_adaptive_inputs_json(inputs_path)
+    plan = build_phase15_adaptive_plan(inputs)
+    output_path = write_phase15_adaptive_plan_json(plan, tmp_path / "plan.json")
+    loaded = json.loads(output_path.read_text(encoding="utf-8"))
+
+    assert loaded == plan
+    assert len(phase15_adaptive_plan_sha256(plan)) == 64
+    assert phase15_adaptive_plan_sha256(plan) == phase15_adaptive_plan_sha256(loaded)
+
+
+def test_phase15_adaptive_plan_loader_rejects_non_standard_json_constants(
+    tmp_path: Path,
+) -> None:
+    inputs_path = tmp_path / "bad-inputs.json"
+    payload = _inputs()
+    payload["evidence"]["baseline"]["metrics"]["residual_rmse"] = math.nan
+    inputs_path.write_text(json.dumps(payload, allow_nan=True), encoding="utf-8")
+
+    with pytest.raises(Phase15AdaptivePlanError, match="non-standard JSON constant"):
+        load_phase15_adaptive_inputs_json(inputs_path)

tokens used
127,198
Implemented and pushed commit `34faf44` to `glassbox-phase15-07-runner-adaptive-plan-20260509T163452Z`.

Added [phase15_adaptive_plan.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase15-07-runner-adaptive-plan-20260509T163452Z/src/bsebench_runner/phase15_adaptive_plan.py) and [test_phase15_adaptive_plan.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase15-07-runner-adaptive-plan-20260509T163452Z/tests/test_phase15_adaptive_plan.py). The plan records baseline, calibration/evaluation split, update rule, residual source, and safety gate evidence, while keeping estimator/filter/update/training execution refused. It fails closed for missing evidence, non-finite values, split leakage, invalid hashes, unsupported claims, forbidden wording, and explicit execution requests.

Validation:
- `uv run --extra dev pytest tests/test_phase15_adaptive_plan.py` passed: 9 tests.
- `uv run --extra dev ruff check ...` passed.
- `uv run --extra dev ruff format --check ...` passed.
- `uv run --extra dev mypy src/bsebench_runner/phase15_adaptive_plan.py` passed.
- `git diff --check` passed.
- Broader non-slow suite with sibling repos on `PYTHONPATH` passed: 475 passed, 5 deselected.

Full suite including slow tests was attempted; two legacy `tests/test_audit_j_smoke.py` slow smokes failed on existing Audit-J baseline/sentinel behavior, outside the Phase 15 files.
```
