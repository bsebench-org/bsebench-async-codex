# phase-15-06-stats-adaptive-report-gate-20260509T163452Z direct-worker summary

- Direct pid: `3088258`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase15-06-stats-adaptive-report-gate-20260509T163452Z`
- Target branch: `glassbox-phase15-06-stats-adaptive-report-gate-20260509T163452Z`
- Branch SHA: `49914d6a14d4e6e0ab48407f2fdc1fef25e21a94`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T17:08:35.781547Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+    assert "unauthorized_claim_wording" in _gap_ids(report)
+
+
+@pytest.mark.fast
+def test_unsupported_claims_fail_closed() -> None:
+    payload = _payload()
+    payload["requested_claims"] = ["winner"]
+    payload["claims"]["winner"] = True
+
+    report = build_phase15_adaptive_report_gate(payload)
+
+    assert report["gate_status"] == "blocked"
+    assert "unsupported_requested_claim" in _gap_ids(report)
+    assert "unsupported_claim_flag" in _gap_ids(report)
+    assert _gate(report, "release_gate")["pass"] is False
+    _assert_strict_json(report)
+
+
+@pytest.mark.fast
+def test_payload_is_not_mutated() -> None:
+    payload = _payload_with_audit("The audited report uses leaderboard wording.")
+    before = copy.deepcopy(payload)
+
+    build_phase15_adaptive_report_gate(payload)
+
+    assert payload == before
+
+
+@pytest.mark.fast
+def test_file_runner_writes_finite_json_report(tmp_path: Path) -> None:
+    input_path = tmp_path / "phase15_adaptive_report_gate_input.json"
+    output_path = tmp_path / "phase15_adaptive_report_gate_report.json"
+    input_path.write_text(json.dumps(_payload(), allow_nan=False), encoding="utf-8")
+
+    report = run_phase15_adaptive_report_gate(input_path, output_path)
+
+    assert output_path.exists()
+    loaded = json.loads(output_path.read_text(encoding="utf-8"))
+    assert loaded == report
+    assert loaded["source"] == {"input_path": str(input_path)}
+
+
+@pytest.mark.fast
+def test_unprocessable_top_level_payload_fails_loud() -> None:
+    with pytest.raises(Phase15AdaptiveReportGateError, match="gate_payload must be an object"):
+        build_phase15_adaptive_report_gate(["not", "an", "object"])
+
+
+@pytest.mark.fast
+def test_invalid_delta_hash_style_provenance_fails_closed() -> None:
+    payload = _payload_with_audit("The candidate appears on the leaderboard.")
+    payload["audited_verdict_artifact"]["audit"]["audit_artifact_sha256"] = "bad"
+    payload["audited_verdict_artifact"]["provenance"]["source_sha256"] = SHA256_D
+
+    report = build_phase15_adaptive_report_gate(payload)
+
+    assert report["gate_status"] == "blocked"
+    assert "invalid_audit_provenance" in _gap_ids(report)
+    assert "unauthorized_claim_wording" in _gap_ids(report)

tokens used
178,925
Implemented and pushed the Phase 15 adaptive report gate.

Changed:
- [phase15_adaptive_report_gate.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase15-06-stats-adaptive-report-gate-20260509T163452Z/src/bsebench_stats/phase15_adaptive_report_gate.py)
- [test_phase15_adaptive_report_gate.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase15-06-stats-adaptive-report-gate-20260509T163452Z/tests/test_phase15_adaptive_report_gate.py)

Validation:
- `uv run --extra dev pytest -q tests/test_phase15_adaptive_report_gate.py` -> 23 passed
- `uv run --extra dev pytest -q` -> 460 passed
- `uv run --extra dev ruff check ...` -> passed
- `uv run --extra dev ruff format --check ...` -> passed
- `git diff --check` -> passed

Commit pushed:
`49914d6a14d4e6e0ab48407f2fdc1fef25e21a94`
`GLASSBOX [role: phase15-stats-adaptive-report-gate] add adaptive report gate`

No validation skipped.
```
