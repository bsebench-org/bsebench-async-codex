# phase-15-04-filters-adaptation-safety-20260509T163452Z direct-worker summary

- Direct pid: `3087999`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-filters`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase15-04-filters-adaptation-safety-20260509T163452Z`
- Target branch: `glassbox-phase15-04-filters-adaptation-safety-20260509T163452Z`
- Branch SHA: `4e3347f98756b3322aec69e83dce96788a270562`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T17:08:33.336802Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+                {"learning_rate": float("nan")}
+            ),
+            r"trace\.updates\[0\]\.learning_rate must be finite",
+        ),
+        (
+            lambda payload: payload["trace"]["samples"][0]["features"].update(
+                {"voltage_V": float("inf")}
+            ),
+            r"trace\.samples\[0\]\.features\.voltage_V must be finite",
+        ),
+        (
+            lambda payload: payload["trace"]["samples"][0]["features"].update(
+                {"future_label": 1.0}
+            ),
+            r"trace\.samples\[0\]\.features\.future_label is a leakage-prone feature",
+        ),
+    ],
+)
+def test_bounded_online_update_and_nonfinite_inputs_fail_closed(
+    mutation: Callable[[MutableMapping[str, object]], object],
+    message: str,
+) -> None:
+    manifest = _valid_manifest()
+    mutation(manifest)
+
+    with pytest.raises(Phase15AdaptationSafetyValidationError, match=message):
+        validate_phase15_adaptation_safety_manifest(manifest)
+
+
+@pytest.mark.parametrize(
+    ("mutation", "message"),
+    [
+        (
+            lambda payload: payload.update({"claim_status": "GO_CLAIM"}),
+            "claim_status must remain NO_GO_CLAIM",
+        ),
+        (
+            lambda payload: payload.update({"notes": "declares adaptive gain readiness"}),
+            "forbidden adaptive-gain wording",
+        ),
+        (
+            lambda payload: payload.update({"claims": ["metadata-only readiness claim"]}),
+            "claims must remain empty",
+        ),
+        (
+            lambda payload: payload["execution_policy"].update(
+                {"online_update_execution_allowed": True}
+            ),
+            r"execution_policy\.online_update_execution_allowed must remain false",
+        ),
+    ],
+)
+def test_claim_and_execution_policy_mutations_fail_closed(
+    mutation: Callable[[MutableMapping[str, object]], object],
+    message: str,
+) -> None:
+    manifest = deepcopy(_valid_manifest())
+    mutation(manifest)
+
+    with pytest.raises(Phase15AdaptationSafetyValidationError, match=message):
+        validate_phase15_adaptation_safety_manifest(manifest)

tokens used
139,850
Implemented and pushed the Phase 15 adaptation safety/leakage gate.

Changed:
- [phase15_adaptation_safety.py](/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase15-04-filters-adaptation-safety-20260509T163452Z/src/bsebench_filters/phase15_adaptation_safety.py)
- [test_phase15_adaptation_safety.py](/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase15-04-filters-adaptation-safety-20260509T163452Z/tests/test_phase15_adaptation_safety.py)

Commit pushed:
`4e3347f GLASSBOX [role: phase15-filters-adaptation-safety] add adaptation safety leakage gate`

Validation:
- `uv run --extra dev pytest tests/test_phase15_adaptation_safety.py -q` passed, 16 tests.
- `git diff --check` passed.
- `uv run --extra dev ruff check src/bsebench_filters/phase15_adaptation_safety.py tests/test_phase15_adaptation_safety.py` passed.
- `uv run --extra dev pytest -q` passed, 214 tests.

No validation was skipped.
```
