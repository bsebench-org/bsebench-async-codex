# phase-15-05-stats-adaptive-delta-gate-20260509T163452Z direct-worker summary

- Direct pid: `3081587`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase15-05-stats-adaptive-delta-gate-20260509T163452Z`
- Target branch: `glassbox-phase15-05-stats-adaptive-delta-gate-20260509T163452Z`
- Branch SHA: `90765639acc67b983934f5a3ec14ea65c6b04a0d`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T16:52:54.262342Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+
+
+@pytest.mark.fast
+def test_unsupported_claim_flags_fail_closed() -> None:
+    payload = _payload()
+    payload["claims"]["adaptive_gain"] = True
+
+    report = build_phase15_adaptive_delta_gate(payload)
+
+    assert report["gate_status"] == "blocked"
+    assert report["claim_flag_gate"]["matched_categories"] == ["adaptive_gain"]
+    assert "unauthorized_claim_flag" in _gap_ids(report)
+    assert "unsupported_claim_flag" in _gap_ids(report)
+    assert report["release_gate"]["claim_authorization"] == "refused_by_default"
+    _assert_strict_json(report)
+
+
+@pytest.mark.fast
+def test_forbidden_adaptive_gain_wording_fails_closed() -> None:
+    payload = _payload()
+    payload["documents"][0]["text"] = "This note asserts an adaptive gain over the baseline."
+
+    report = build_phase15_adaptive_delta_gate(payload)
+
+    assert report["gate_status"] == "blocked"
+    assert report["wording_gate"]["status"] == "blocked"
+    assert report["wording_gate"]["matched_categories"] == ["adaptive_gain"]
+    assert "forbidden_adaptive_gain_wording" in _gap_ids(report)
+    _assert_strict_json(report)
+
+
+@pytest.mark.fast
+def test_payload_is_not_mutated() -> None:
+    payload = _payload()
+    before = copy.deepcopy(payload)
+
+    build_phase15_adaptive_delta_gate(payload)
+
+    assert payload == before
+
+
+@pytest.mark.fast
+def test_file_runner_writes_finite_json_report(tmp_path: Path) -> None:
+    input_path = tmp_path / "phase15_delta_gate_input.json"
+    output_path = tmp_path / "phase15_delta_gate_report.json"
+    input_path.write_text(json.dumps(_payload(), allow_nan=False), encoding="utf-8")
+
+    report = run_phase15_adaptive_delta_gate(input_path, output_path)
+
+    assert output_path.exists()
+    loaded = json.loads(output_path.read_text(encoding="utf-8"))
+    assert loaded == report
+    assert loaded["source"] == {"input_path": str(input_path)}
+
+
+@pytest.mark.fast
+def test_unprocessable_top_level_payload_fails_loud() -> None:
+    with pytest.raises(Phase15AdaptiveDeltaGateError, match="gate_payload must be an object"):
+        build_phase15_adaptive_delta_gate(["not", "an", "object"])

tokens used
115,681
Implemented and pushed the Phase 15 adaptive-delta gate.

Changed:
- [phase15_adaptive_delta_gate.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase15-05-stats-adaptive-delta-gate-20260509T163452Z/src/bsebench_stats/phase15_adaptive_delta_gate.py)
- [test_phase15_adaptive_delta_gate.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase15-05-stats-adaptive-delta-gate-20260509T163452Z/tests/test_phase15_adaptive_delta_gate.py)

Validation:
- `uv run --extra dev pytest tests/test_phase15_adaptive_delta_gate.py -q` -> 15 passed
- `uv run --extra dev pytest -q` -> 452 passed
- `uv run --extra dev ruff check ...` -> passed
- `uv run --extra dev ruff format --check ...` -> passed
- `git diff --check` -> passed

Commit pushed:
- `9076563 GLASSBOX [role: phase15-stats-adaptive-delta-gate] add adaptive delta gate`
- Branch: `glassbox-phase15-05-stats-adaptive-delta-gate-20260509T163452Z`

Skipped validation: none.
```
