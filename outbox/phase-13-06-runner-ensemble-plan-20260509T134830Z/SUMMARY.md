# Phase phase-13-06-runner-ensemble-plan-20260509T134830Z direct-worker summary

- Direct pid: `3038671`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-runner`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase13-06-runner-ensemble-plan-20260509T134830Z`
- Target branch: `glassbox-phase13-06-runner-ensemble-plan-20260509T134830Z`
- Branch SHA: `13f257482afd1d94bce5a14c59fad58a44fdb80d`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:07:15.571426Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+    assert "missing_parameter_config_sha256" in blocked["blocking_gaps"]
+    assert "missing_provenance_source_uri" in blocked["blocking_gaps"]
+    assert "missing_provenance_source_sha256" in blocked["blocking_gaps"]
+    assert "missing_finite_metrics" in blocked["blocking_gaps"]
+    assert "candidate_member_evidence_incomplete" in plan["blocking_gaps"]
+
+
+def test_phase13_ensemble_plan_blocks_non_finite_metrics_without_serializing_nan() -> None:
+    candidate = _candidate()
+    candidate["metrics"] = {
+        "soc_rmse": math.nan,
+        "soh_mae": 0.015,
+        "interval": [0.1, math.inf],
+    }
+
+    plan = build_phase13_ensemble_plan(candidates=[candidate, _candidate("member_b")])
+
+    assert plan["decision"]["ensemble_scheduling_allowed"] is False
+    assert "metric_non_finite:metrics.soc_rmse" in plan["members"][0]["blocking_gaps"]
+    assert "metric_non_finite:metrics.interval[1]" in plan["members"][0]["blocking_gaps"]
+    assert plan["members"][0]["metrics"]["values"]["soc_rmse"] is None
+    json.dumps(plan, allow_nan=False)
+
+
+def test_phase13_ensemble_plan_blocks_single_member_even_when_complete() -> None:
+    plan = build_phase13_ensemble_plan(candidates=[_candidate()])
+
+    assert plan["decision"]["schedule_status"] == "blocked"
+    assert plan["summary"]["ready_member_count"] == 1
+    assert "insufficient_ready_members" in plan["blocking_gaps"]
+
+
+def test_phase13_ensemble_plan_blocks_empty_candidate_set() -> None:
+    plan = build_phase13_ensemble_plan(candidates=[])
+
+    assert plan["decision"]["ensemble_scheduling_allowed"] is False
+    assert plan["summary"]["candidate_member_count"] == 0
+    assert "candidate_members_missing" in plan["blocking_gaps"]
+    assert "insufficient_ready_members" in plan["blocking_gaps"]
+
+
+def test_phase13_ensemble_plan_rejects_invalid_input_collection() -> None:
+    with pytest.raises(Phase13EnsemblePlanError, match="candidates must be a sequence"):
+        build_phase13_ensemble_plan(candidates="not-a-list")  # type: ignore[arg-type]
+
+    with pytest.raises(Phase13EnsemblePlanError, match="min_members must be at least 2"):
+        build_phase13_ensemble_plan(candidates=[_candidate()], min_members=1)
+
+
+def test_phase13_ensemble_plan_load_write_and_hash_are_deterministic(tmp_path: Path) -> None:
+    descriptor_path = tmp_path / "candidates.json"
+    descriptor_path.write_text(
+        json.dumps({"candidates": [_candidate("member_a"), _candidate("member_b")]}) + "\n",
+        encoding="utf-8",
+    )
+    candidates = load_candidate_descriptors_json(descriptor_path)
+    plan = build_phase13_ensemble_plan(candidates=candidates)
+    output_path = write_phase13_ensemble_plan_json(plan, tmp_path / "plan.json")
+    loaded = json.loads(output_path.read_text(encoding="utf-8"))
+
+    assert loaded == plan
+    assert len(phase13_ensemble_plan_sha256(plan)) == 64
+    assert phase13_ensemble_plan_sha256(plan) == phase13_ensemble_plan_sha256(loaded)

tokens used
111,408
Implemented and pushed commit `13f2574` to `glassbox-phase13-06-runner-ensemble-plan-20260509T134830Z`.

Changes:
- Added [phase13_ensemble_plan.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase13-06-runner-ensemble-plan-20260509T134830Z/src/bsebench_runner/phase13_ensemble_plan.py): dry-run ensemble plan builder, strict JSON writer/loader/hash helper, fail-closed member blockers for missing truth, split, parameter-freeze, provenance, hashes, and finite metrics.
- Added [test_phase13_ensemble_plan.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase13-06-runner-ensemble-plan-20260509T134830Z/tests/test_phase13_ensemble_plan.py): focused tests for ready scheduling, missing evidence, invalid hashes, non-finite metrics, insufficient members, and deterministic load/write/hash behavior.

Validation:
- `uv run --extra dev pytest tests/test_phase13_ensemble_plan.py` passed: 7 tests.
- `uv run --extra dev ruff check src tests` passed.
- `uv run --extra dev ruff format --check ...` passed.
- `uv run --extra dev mypy src/bsebench_runner/phase13_ensemble_plan.py` passed.
- `git diff --check` passed.

Skipped: full project pytest suite was not run; targeted pytest plus broader static checks were run.
```
