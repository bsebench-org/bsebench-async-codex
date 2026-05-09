# Phase phase-13-03-stats-comparison-gate-20260509T134830Z direct-worker summary

- Direct pid: `3037734`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase13-03-stats-comparison-gate-20260509T134830Z`
- Target branch: `glassbox-phase13-03-stats-comparison-gate-20260509T134830Z`
- Branch SHA: `f70954e4d8526b6a33c8020dce48c293398b0625`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:06:13.310425Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+                "dataset_fingerprint"
+            ),
+            "dataset_fingerprint",
+        ),
+    ],
+)
+def test_phase13_comparison_gate_missing_evidence_fails_closed(mutation, message: str) -> None:
+    payload = deepcopy(_candidates())
+    mutation(payload)
+
+    with pytest.raises(Phase13ComparisonGateError, match=message):
+        validate_phase13_comparison_readiness(payload)
+
+
+@pytest.mark.fast
+@pytest.mark.parametrize(
+    ("mutation", "message"),
+    [
+        (
+            lambda payload: payload[0]["metrics"].update({"soc_rmse": float("inf")}),
+            r"metrics\.soc_rmse must be a finite number",
+        ),
+        (
+            lambda payload: payload[0]["metrics"].update({"soc_rmse": True}),
+            r"metrics\.soc_rmse must be a finite number",
+        ),
+        (
+            lambda payload: payload[0]["uncertainty"]["soc_rmse"].update({"lower": 0.4}),
+            "lower must be <= upper",
+        ),
+        (
+            lambda payload: payload[0]["uncertainty"]["soc_rmse"].update({"upper": 0.2}),
+            "interval must contain metric value",
+        ),
+        (
+            lambda payload: payload[0]["uncertainty"]["soc_rmse"].update({"standard_error": -0.01}),
+            "standard_error must be non-negative",
+        ),
+        (
+            lambda payload: payload[0]["uncertainty"]["soc_rmse"].update({"sample_count": 1}),
+            "sample_count must be at least 2",
+        ),
+    ],
+)
+def test_phase13_comparison_gate_invalid_values_fail_closed(
+    mutation,
+    message: str,
+) -> None:
+    payload = deepcopy(_candidates())
+    mutation(payload)
+
+    with pytest.raises(Phase13ComparisonGateError, match=message):
+        validate_phase13_comparison_readiness(payload)
+
+
+@pytest.mark.fast
+def test_phase13_gate_rejects_single_candidate_comparison() -> None:
+    with pytest.raises(Phase13ComparisonGateError, match="at least two candidates"):
+        validate_phase13_comparison_readiness([_candidate("ensemble_a")])

tokens used
100,658
Implemented and pushed commit `f70954e`:

`GLASSBOX [role: phase13-stats-comparison-gate] add comparison readiness gate`

Changed only:
- `src/bsebench_stats/phase13_comparison_gate.py`
- `tests/test_phase13_comparison_gate.py`

The gate now fail-closes on missing candidate provenance, evidence hashes, split IDs, finite metrics, uncertainty, ensemble contract evidence, duplicate IDs, mismatched metric keys, and mismatched split IDs.

Validation run:
- `.venv/bin/pytest tests/test_phase13_comparison_gate.py tests/test_ensemble_contract.py --no-cov` -> `41 passed`
- `.venv/bin/pytest -m fast --no-cov` -> `348 passed`
- `.venv/bin/ruff check ...` -> passed
- `.venv/bin/ruff format --check ...` -> passed
- `git diff --cached --check` -> passed

Note: coverage-enabled pytest hit a `.coverage` SQLite combine collision during overlapping runs, so I reran validation with `--no-cov`. The target branch was pushed to origin.
```
