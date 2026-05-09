# phase-15-09-datasets-calibration-evidence-20260509T163452Z direct-worker summary

- Direct pid: `3082190`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-datasets`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-datasets-glassbox-phase15-09-datasets-calibration-evidence-20260509T163452Z`
- Target branch: `glassbox-phase15-09-datasets-calibration-evidence-20260509T163452Z`
- Branch SHA: `2ebaffb6e5b7952a272ac84b16cc10c5ef5eb43c`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T16:52:55.601860Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+    gate = build_phase15_calibration_evidence_gate(
+        manifest_id="phase15_calibration_fixture",
+        generated_at="2026-05-09T16:34:52Z",
+        bundles=[
+            _bundle(
+                tmp_path,
+                evaluation_windows=[
+                    _window(
+                        tmp_path,
+                        split_id="evaluation_v1",
+                        window_id="eval_001",
+                        start=10.0,
+                        end=20.0,
+                        axis="time_s",
+                        unit="s",
+                    )
+                ],
+            )
+        ],
+    )
+
+    bundle = gate["bundles"][0]
+    assert gate["status"] == "blocked"
+    assert "evaluation_window_axis_unit_mismatch" in bundle["blocking_gaps"]
+    assert (
+        "incomparable_evaluation_window_axis_unit"
+        in bundle["calibration_windows"][0]["blocking_gaps"]
+    )
+
+
+def test_gate_blocks_residual_scope_leakage_and_forbidden_adaptive_claim(
+    tmp_path: Path,
+) -> None:
+    gate = build_phase15_calibration_evidence_gate(
+        manifest_id="phase15_calibration_fixture",
+        generated_at="2026-05-09T16:34:52Z",
+        bundles=[
+            _bundle(
+                tmp_path,
+                residual_scope=_residual_scope(
+                    tmp_path,
+                    covered_split_ids=["calibration_v1", "evaluation_v1"],
+                    covered_window_ids=["cal_001", "eval_001"],
+                ),
+                adaptive_performance_claim="20% RMSE improvement for adaptive SOC/SOH filters",
+            )
+        ],
+    )
+
+    bundle = gate["bundles"][0]
+    residual_scope = bundle["residual_scope"]
+    assert gate["status"] == "blocked"
+    assert "unsupported_adaptive_performance_claim" in bundle["blocking_gaps"]
+    assert "forbidden_adaptive_gain_wording" in bundle["blocking_gaps"]
+    assert "residual_scope.residual_scope_includes_evaluation_split_id" in bundle["blocking_gaps"]
+    assert "residual_scope.residual_scope_includes_evaluation_window_id" in bundle["blocking_gaps"]
+    assert residual_scope["leaked_evaluation_split_ids"] == ["evaluation_v1"]
+    assert residual_scope["leaked_evaluation_window_ids"] == ["eval_001"]

tokens used
139,185
Implemented and pushed the Phase 15 calibration evidence gate.

Changes:
- Added [phase15_calibration_evidence.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-glassbox-phase15-09-datasets-calibration-evidence-20260509T163452Z/src/bsebench_datasets/phase15_calibration_evidence.py) with fail-closed checks for source hashes, split IDs, evaluation-window non-overlap, residual scope, provenance, non-finite values, and adaptive-claim wording.
- Added [test_phase15_calibration_evidence.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-glassbox-phase15-09-datasets-calibration-evidence-20260509T163452Z/tests/test_phase15_calibration_evidence.py) with synthetic fixtures covering ready evidence and blocked leakage/provenance/hash/claim cases.

Validation:
- `uv run --extra dev pytest tests/test_phase15_calibration_evidence.py` passed, 6 tests.
- `git diff --check` passed.
- `git diff --cached --check` passed before commit.
- `uv run --extra dev ruff check src tests` passed.
- `uv run --extra dev mypy src/bsebench_datasets/phase15_calibration_evidence.py tests/test_phase15_calibration_evidence.py` passed.

Commit pushed:
- Branch: `glassbox-phase15-09-datasets-calibration-evidence-20260509T163452Z`
- Commit: `2ebaffb6e5b7952a272ac84b16cc10c5ef5eb43c`
- Subject: `GLASSBOX [role: phase15-datasets-calibration-evidence] add calibration evidence gate`

Skipped: full project pytest was not run; I ran the requested focused pytest plus whole-repo Ruff.
```
