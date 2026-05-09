# phase-14-02-stats-matrix-checks-20260509T145752Z direct-worker summary

- Direct pid: `3059240`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase14-02-stats-matrix-checks-20260509T145752Z`
- Target branch: `glassbox-phase14-02-stats-matrix-checks-20260509T145752Z`
- Branch SHA: `ca784756ce480f0a690b17ee66eedecaa6aa3efa`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T15:11:02.534047Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+        reference_vector_name="state",
+        reference_matrix_name="information",
+    )
+
+    assert report["matrix_role"] == "dimension_compatibility"
+    assert report["dimension"] == 3
+    assert report["dimension_checks"] == [
+        {"name": "expected_dim", "dimension": 3, "status": "pass"},
+        {"name": "state", "dimension": 3, "status": "pass"},
+        {"name": "information", "dimension": 3, "status": "pass"},
+    ]
+    _assert_strict_json(report)
+
+    with pytest.raises(Phase14MatrixCheckError, match=r"reference_vector length") as exc_info:
+        validate_dimension_compatibility(np.eye(3), reference_vector=[0.0, 1.0], name="cov")
+    assert exc_info.value.diagnostics["dimension_checks"][0] == {
+        "name": "reference_vector",
+        "dimension": 2,
+        "status": "fail",
+    }
+    _assert_strict_json(exc_info.value.diagnostics)
+
+
+@pytest.mark.fast
+def test_validate_inversion_ready_matrix_refuses_regularization_and_bad_conditioning() -> None:
+    with pytest.raises(Phase14MatrixCheckError, match=r"regularization is unsupported") as exc_info:
+        validate_inversion_ready_matrix(np.eye(2), regularization=1e-6)
+
+    assert exc_info.value.diagnostics["regularization"]["requested"] is True
+    assert exc_info.value.diagnostics["regularization"]["applied"] is False
+    _assert_strict_json(exc_info.value.diagnostics)
+
+    with pytest.raises(Phase14MatrixCheckError, match=r"condition number") as conditioned:
+        validate_inversion_ready_matrix(
+            [[1.0, 0.0], [0.0, 1e-8]],
+            max_condition_number=1e6,
+        )
+    assert conditioned.value.diagnostics["conditioning"]["inversion_safe"] is False
+    _assert_strict_json(conditioned.value.diagnostics)
+
+
+@pytest.mark.fast
+def test_covariance_and_information_matrix_roles_fail_closed() -> None:
+    covariance = validate_covariance_matrix([[1.0, 0.0], [0.0, 0.0]], expected_dim=2)
+    information = validate_information_matrix([[2.0, 0.0], [0.0, 1.0]], expected_dim=2)
+
+    assert covariance["matrix_role"] == "covariance"
+    assert covariance["spectrum"]["psd"] is True
+    assert covariance["spectrum"]["spd"] is False
+    assert information["matrix_role"] == "information"
+    assert information["spectrum"]["spd"] is True
+    assert information["conditioning"]["inversion_safe"] is True
+    _assert_strict_json(covariance)
+    _assert_strict_json(information)
+
+    with pytest.raises(Phase14MatrixCheckError, match=r"positive definite"):
+        validate_information_matrix([[1.0, 1.0], [1.0, 1.0]])
+    with pytest.raises(Phase14MatrixCheckError, match=r"regularization is unsupported"):
+        validate_covariance_matrix(np.eye(2), regularization=1e-9)

tokens used
123,283
Implemented and pushed the Phase 14 matrix checks.

Changes:
- Added finite matrix validators in [phase14_matrix_checks.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase14-02-stats-matrix-checks-20260509T145752Z/src/bsebench_stats/phase14_matrix_checks.py:1)
- Added focused tests in [test_phase14_matrix_checks.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase14-02-stats-matrix-checks-20260509T145752Z/tests/test_phase14_matrix_checks.py:1)
- Covered square shape, symmetry, PSD/SPD, dimension compatibility, covariance/information roles, inversion readiness, regularization refusal, and strict JSON-safe diagnostics.

Validation run:
- `uv run --extra dev ruff check src/bsebench_stats/phase14_matrix_checks.py tests/test_phase14_matrix_checks.py`
- `uv run --extra dev pytest tests/test_phase14_matrix_checks.py`
- `uv run --extra dev pytest` -> `394 passed`
- `git diff --check`
- `git diff --cached --check`

Commit pushed:
- `ca784756ce480f0a690b17ee66eedecaa6aa3efa`
- `GLASSBOX [role: phase14-stats-matrix-checks] add finite matrix validators`
- Branch: `glassbox-phase14-02-stats-matrix-checks-20260509T145752Z`
```
