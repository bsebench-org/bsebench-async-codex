# phase-14-09-filters-ecm-linearization-20260509T145752Z direct-worker summary

- Direct pid: `3059996`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-filters`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase14-09-filters-ecm-linearization-20260509T145752Z`
- Target branch: `glassbox-phase14-09-filters-ecm-linearization-20260509T145752Z`
- Branch SHA: `4c1d1d4fe1202b5c5b03db8a5c7f47dc5238737a`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T15:07:37.718261Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+                {"observation_jacobian": [[1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0]]}
+            ),
+            r"observation_jacobian shape must be \(1, 4\); got \(2, 4\)",
+        ),
+        (
+            lambda payload: payload["state_transition_jacobian"][1].__setitem__(2, float("nan")),
+            "state_transition_jacobian values must be finite",
+        ),
+        (
+            lambda payload: payload["observation_jacobian"][0].__setitem__(0, float("inf")),
+            "observation_jacobian values must be finite",
+        ),
+    ],
+)
+def test_ecm_linearization_validation_fails_closed_for_dimensions_and_finiteness(
+    mutation,
+    message: str,
+) -> None:
+    descriptor = _valid_descriptor()
+    mutation(descriptor)
+
+    with pytest.raises(ECMLinearizationValidationError, match=message):
+        validate_phase14_ecm_linearization_descriptor(descriptor)
+    assert ecm_linearization_blocking_gaps(descriptor)
+
+
+@pytest.mark.parametrize(
+    ("mutation", "message"),
+    [
+        (
+            lambda payload: payload.update({"claim_status": "TIGHT_BENCHMARK_BOUND"}),
+            "claim_status must remain NO_GO_CLAIM",
+        ),
+        (
+            lambda payload: payload["execution_policy"].update(
+                {"estimator_execution_allowed": True}
+            ),
+            r"execution_policy\.estimator_execution_allowed must remain false",
+        ),
+        (
+            lambda payload: payload["execution_policy"].update(
+                {"empirical_advantage_claim_allowed": True}
+            ),
+            r"execution_policy\.empirical_advantage_claim_allowed must remain false",
+        ),
+        (
+            lambda payload: payload["validation_policy"].update({"alters_filter_math": True}),
+            r"validation_policy\.alters_filter_math must be false",
+        ),
+    ],
+)
+def test_ecm_linearization_descriptor_blocks_execution_and_claims(
+    mutation,
+    message: str,
+) -> None:
+    descriptor = deepcopy(_valid_descriptor())
+    mutation(descriptor)
+
+    with pytest.raises(ECMLinearizationValidationError, match=message):
+        validate_phase14_ecm_linearization_descriptor(descriptor)

tokens used
90,933
Implemented and pushed the Phase 14 ECM/filter linearization descriptor contract.

Changed:
- [phase14_ecm_linearization.py](/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase14-09-filters-ecm-linearization-20260509T145752Z/src/bsebench_filters/phase14_ecm_linearization.py)
- [test_phase14_ecm_linearization.py](/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase14-09-filters-ecm-linearization-20260509T145752Z/tests/test_phase14_ecm_linearization.py)

Commit pushed:
`4c1d1d4 GLASSBOX [role: phase14-filters-ecm-linearization] add ECM linearization descriptor`

Validation:
- `pytest tests/test_phase14_ecm_linearization.py`: 12 passed
- full `pytest`: 198 passed
- `ruff check` on touched files: passed
- `mypy` on new module: passed
- `git diff --check HEAD~1 HEAD`: passed

No validation skipped.
```
