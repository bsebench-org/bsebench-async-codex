# phase-14-06-runner-bound-plan-20260509T145752Z direct-worker summary

- Direct pid: `3059503`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-runner`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase14-06-runner-bound-plan-20260509T145752Z`
- Target branch: `glassbox-phase14-06-runner-bound-plan-20260509T145752Z`
- Branch SHA: `f4c6c40222e176251d079faccc02dbfbbaae26df`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T15:10:24.993555Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+        in plan["blocking_gaps"]
+    )
+    assert plan["component_status"]["parameters"]["values"] == [2.8, None]
+    json.dumps(plan, allow_nan=False)
+
+
+def test_phase14_bound_plan_blocks_invalid_covariance_and_information_matrices() -> None:
+    payload = _inputs()
+    payload["evidence"]["noise"]["process_covariance"] = [[0.01, 0.02], [0.0, 0.02]]
+    payload["evidence"]["noise"]["measurement_covariance"] = [[-0.03]]
+    payload["evidence"]["noise"]["prior_information"] = [[1.0, 0.0], [0.0, 0.0]]
+
+    plan = build_phase14_bound_plan(payload)
+
+    assert plan["decision"]["plan_status"] == "blocked"
+    assert "matrix_not_symmetric:noise.process_covariance" in plan["blocking_gaps"]
+    assert "matrix_not_positive_definite:noise.measurement_covariance" in plan["blocking_gaps"]
+    assert "matrix_not_positive_definite:noise.prior_information" in plan["blocking_gaps"]
+    assert plan["decision"]["bound_computation_allowed"] is False
+
+
+def test_phase14_bound_plan_blocks_unsupported_claims() -> None:
+    payload = _inputs()
+    payload["requested_claims"] = ["information_bound_preflight_plan", "sota"]
+    payload["claims"]["filter_superiority"] = True
+
+    plan = build_phase14_bound_plan(payload)
+
+    assert plan["decision"]["plan_status"] == "blocked"
+    assert "unsupported_claim:sota" in plan["blocking_gaps"]
+    assert "unsupported_claim:filter_superiority" in plan["blocking_gaps"]
+    assert plan["scientific_verdict"] == NO_GO_CLAIM
+
+
+def test_phase14_bound_plan_rejects_invalid_input_collection() -> None:
+    with pytest.raises(Phase14BoundPlanError, match="inputs must be a mapping"):
+        build_phase14_bound_plan(["not", "a", "mapping"])  # type: ignore[arg-type]
+
+    with pytest.raises(Phase14BoundPlanError, match="generated_at must be a non-empty string"):
+        build_phase14_bound_plan(_inputs(), generated_at=" ")
+
+
+def test_phase14_bound_plan_load_write_and_hash_are_deterministic(tmp_path: Path) -> None:
+    inputs_path = tmp_path / "inputs.json"
+    inputs_path.write_text(json.dumps(_inputs(), indent=2, sort_keys=True) + "\n", encoding="utf-8")
+    inputs = load_phase14_bound_inputs_json(inputs_path)
+    plan = build_phase14_bound_plan(inputs)
+    output_path = write_phase14_bound_plan_json(plan, tmp_path / "plan.json")
+    loaded = json.loads(output_path.read_text(encoding="utf-8"))
+
+    assert loaded == plan
+    assert len(phase14_bound_plan_sha256(plan)) == 64
+    assert phase14_bound_plan_sha256(plan) == phase14_bound_plan_sha256(loaded)
+
+
+def test_phase14_bound_plan_loader_rejects_non_standard_json_constants(tmp_path: Path) -> None:
+    inputs_path = tmp_path / "bad-inputs.json"
+    payload = _inputs()
+    payload["evidence"]["parameters"]["values"][0] = math.nan
+    inputs_path.write_text(json.dumps(payload, allow_nan=True), encoding="utf-8")
+
+    with pytest.raises(Phase14BoundPlanError, match="non-standard JSON constant"):
+        load_phase14_bound_inputs_json(inputs_path)

tokens used
101,133
Implemented and pushed `glassbox-phase14-06-runner-bound-plan-20260509T145752Z`.

Added [phase14_bound_plan.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase14-06-runner-bound-plan-20260509T145752Z/src/bsebench_runner/phase14_bound_plan.py) with a dry-run-only information-bound plan builder, strict JSON load/write/hash helpers, fail-closed evidence validation, finite/dimension checks, SPD covariance/information checks, unsupported-claim blockers, and hard refusal of estimator/filter/bound execution.

Added [test_phase14_bound_plan.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase14-06-runner-bound-plan-20260509T145752Z/tests/test_phase14_bound_plan.py) covering ready synthetic metadata, missing evidence, non-finite values, dimension mismatches, invalid matrices, unsupported claims, strict JSON loading, deterministic writing, and hashing.

Validation run:
- `uv run --extra dev pytest tests/test_phase14_bound_plan.py` passed, 8 tests.
- `git diff --check` passed.
- `git diff --cached --check` passed.
- `uv run --extra dev ruff check src tests` passed.
- `uv run --extra dev mypy src/bsebench_runner/phase14_bound_plan.py tests/test_phase14_bound_plan.py` passed.

Skipped full-project pytest because it was not a cheap scoped check. Commit pushed: `f4c6c40222e176251d079faccc02dbfbbaae26df`.
```
