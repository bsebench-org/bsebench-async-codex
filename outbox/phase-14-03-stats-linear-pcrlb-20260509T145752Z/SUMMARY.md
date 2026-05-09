# phase-14-03-stats-linear-pcrlb-20260509T145752Z direct-worker summary

- Direct pid: `3067540`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase14-03-stats-linear-pcrlb-20260509T145752Z`
- Target branch: `glassbox-phase14-03-stats-linear-pcrlb-20260509T145752Z`
- Branch SHA: `a4569e0139f7023bb52ae46cbfa4a47e0c5a4f65`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T15:26:17.498562Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+            [[1.0]],
+            [[1.0, 0.0], [0.0, 1.0]],
+        )
+
+    with pytest.raises(Phase14LinearPcrlbError, match=r"finite"):
+        compute_linear_gaussian_pcrlb(
+            [[1.0]],
+            [[1.0]],
+            [[np.inf]],
+            [[1.0]],
+            [[1.0]],
+        )
+
+
+@pytest.mark.fast
+def test_linear_pcrlb_rejects_invalid_covariance_and_information_matrices() -> None:
+    with pytest.raises(Phase14MatrixCheckError, match=r"positive definite"):
+        compute_linear_gaussian_pcrlb(
+            [[1.0]],
+            [[1.0]],
+            [[0.0]],
+            [[1.0]],
+            [[1.0]],
+        )
+
+    with pytest.raises(Phase14MatrixCheckError, match=r"positive definite"):
+        compute_linear_gaussian_pcrlb(
+            [[1.0]],
+            [[1.0]],
+            [[1.0]],
+            [[1.0]],
+            [[0.0]],
+        )
+
+
+@pytest.mark.fast
+def test_linear_pcrlb_rejects_unsupported_claims_and_non_synthetic_scope() -> None:
+    with pytest.raises(Phase14LinearPcrlbError, match=r"refuses") as claim_error:
+        compute_linear_gaussian_pcrlb(
+            [[1.0]],
+            [[1.0]],
+            [[1.0]],
+            [[1.0]],
+            [[1.0]],
+            claims=["tight_bound"],
+        )
+    assert claim_error.value.diagnostics["requested_claims"] == ["tight_bound"]
+    _assert_strict_json(claim_error.value.diagnostics)
+
+    with pytest.raises(Phase14LinearPcrlbError, match=r"synthetic") as scope_error:
+        build_linear_gaussian_pcrlb_report(
+            {
+                "fixture_scope": "real_battery_evidence",
+                "F": [[1.0]],
+                "H": [[1.0]],
+                "Q": [[1.0]],
+                "R": [[1.0]],
+                "prior_information": [[1.0]],
+            }
+        )
+    assert scope_error.value.diagnostics["required_fixture_scope"] == SYNTHETIC_FIXTURE_SCOPE
+    _assert_strict_json(scope_error.value.diagnostics)

tokens used
85,617
Implemented and pushed `a4569e0` to `origin/glassbox-phase14-03-stats-linear-pcrlb-20260509T145752Z`.

Added [phase14_linear_pcrlb.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase14-03-stats-linear-pcrlb-20260509T145752Z/src/bsebench_stats/phase14_linear_pcrlb.py) with deterministic Tichavsky-style `D11/D12/D22` linear-Gaussian PCRLB recursion, strict synthetic-fixture gating, matrix-check reuse, JSON-safe reports, and fail-closed claim/input validation.

Added [test_phase14_linear_pcrlb.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase14-03-stats-linear-pcrlb-20260509T145752Z/tests/test_phase14_linear_pcrlb.py) covering scalar and matrix fixtures plus missing evidence, non-finite values, dimension mismatch, invalid covariance/information matrices, unsupported claims, and non-synthetic scope.

Validation passed:
- `uv run --extra dev pytest tests/test_phase14_linear_pcrlb.py`
- `uv run --extra dev pytest tests/test_phase14_matrix_checks.py tests/test_phase14_linear_pcrlb.py`
- `uv run --extra dev ruff check src tests`
- `git diff --check`
- `git diff --cached --check`
- `uv run --extra dev pytest` with `400 passed`

No validation skipped.
```
