# Phase phase-7-10-ah-stats-hinf-null-control-audit summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 90 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-stats
- Target branch : phase-7-10-ah-stats-hinf-null-control-audit
- Branch SHA : 6918416aa998da6f68e12c372cb894cb536f6243
- Push result : ok
- Merge readiness : stale-base
- Merge readiness detail : origin/main is not an ancestor of HEAD; rebase before chef merge
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-08T10:06:54+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+    assert report["falsification_gate"] == {
+        "blocking_fragility": False,
+        "candidate_status": "not_flagged_fragile",
+        "mechanical_evidence_effect": "strengthens",
+        "null_control_overlap": False,
+        "observed_margin_overlaps_tolerance": False,
+        "pass": True,
+        "policy": (
+            "blocking fragility prevents downstream claim registration support; "
+            "this audit provides no scientific verdict"
+        ),
+        "risk_count": 0,
+        "risk_ids": [],
+        "status": "null_control_separated",
+    }
+    encoded = json.dumps(report, sort_keys=True).lower()
+    for forbidden in ("verified", "novel", "sota", "thesis"):
+        assert forbidden not in encoded
+    json.dumps(report, allow_nan=False)
+
+
+@pytest.mark.fast
+def test_hinf_null_control_blocks_overlapping_fragile_synthetic_case() -> None:
+    report = build_hinf_null_control_audit(
+        _evidence_payload(["EKF", "EKF", "EKF", "EKF", "UKFDef", "UKFDef"]),
+        seed=99,
+        bootstrap_resamples=256,
+        margin_tolerance=0.05,
+    )
+
+    values = report["mechanical_evidence"]["values_compared"]
+    assert values["observed_statistic"] > 0.05
+    assert values["null_control_statistic"] <= 0.05
+    assert report["mechanical_evidence"]["mechanical_effect"] == "weakens"
+    gate = report["falsification_gate"]
+    assert gate["status"] == "blocking_fragility"
+    assert gate["pass"] is False
+    assert gate["blocking_fragility"] is True
+    assert gate["null_control_overlap"] is True
+    assert gate["candidate_status"] == "fragile"
+    assert gate["risk_ids"] == ["config_bootstrap_null_control_overlap"]
+    json.dumps(report, allow_nan=False)
+
+
+@pytest.mark.fast
+def test_hinf_null_control_missing_artifact_failure(tmp_path: Path) -> None:
+    with pytest.raises(HinfNullControlAuditError, match="failed to read"):
+        run_hinf_null_control_audit(tmp_path / "missing_hinf_residual_evidence.json")

tokens used
167,275
Implemented and committed the Hinf null-control audit.

Commit: `6918416`  
`GLASSBOX [role: codex-stats-engineer] Add Hinf null-control audit`

Changed:
- Added config-bootstrap null-control runner: [hinf_null_control.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-10-ah-stats-hinf-null-control-audit/src/bsebench_stats/runners/hinf_null_control.py)
- Added CLI: [hinf_null_control_audit.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-10-ah-stats-hinf-null-control-audit/scripts/hinf_null_control_audit.py)
- Exported runner APIs in [__init__.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-10-ah-stats-hinf-null-control-audit/src/bsebench_stats/runners/__init__.py)
- Added focused tests: [test_hinf_null_control.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-10-ah-stats-hinf-null-control-audit/tests/test_hinf_null_control.py)

Real audit run against frozen runner artifact wrote `/tmp/hinf_null_control_audit_5x5.json`:
- Evidence: `/mnt/c/doctorat/bsebench-org/bsebench-runner/outputs/hinf_residual_evidence_5x5.json`
- Seed: `710010`
- Statistic: `target_top_margin_abs_correlation`
- Observed: `0.6217968840408938`
- Null-control lower-tail statistic: `0.4537286599598518`
- Tolerance: `0.05`
- Gate: `null_control_separated`
- Mechanical effect: `strengthens`, with no scientific claim verdict.

Validation passed:
- `uv run --locked --all-extras pytest tests/test_hinf_null_control.py -q` → `4 passed`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q` → `174 passed`
- `uv run --locked --all-extras ruff check .` → passed
- `uv run --locked --all-extras ruff format --check .` → passed
- `git diff --check` → passed

Stats worktree has no uncommitted changes; branch is ahead 1 and behind 1 relative to `origin/main`.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-ah-stats-hinf-null-control-audit in target_repo. Verify gates. Merge to main if green.
