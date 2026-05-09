# phase-15-03-filters-residual-predictor-contract-20260509T163452Z direct-worker summary

- Direct pid: `3081318`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-filters`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase15-03-filters-residual-predictor-contract-20260509T163452Z`
- Target branch: `glassbox-phase15-03-filters-residual-predictor-contract-20260509T163452Z`
- Branch SHA: `b3253be6789f48de2fd61ceb2cdc20b6aa1c551f`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T16:52:52.952114Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+    mutation: Callable[[MutableMapping[str, object]], object],
+    message: str,
+) -> None:
+    manifest = deepcopy(_valid_manifest())
+    mutation(manifest)
+
+    with pytest.raises(ResidualPredictorManifestValidationError, match=message):
+        validate_phase15_residual_predictor_manifest(manifest)
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
+            lambda payload: payload["claims"].append("metadata-only readiness claim"),
+            "claims must remain empty",
+        ),
+        (
+            lambda payload: payload["predictor"].update(
+                {"description": "declares adaptive-gain readiness"}
+            ),
+            "unsupported claim wording",
+        ),
+        (
+            lambda payload: payload["predictor"].update(
+                {"description": "claims 20% improvement in residual error"}
+            ),
+            "unsupported percent-gain wording",
+        ),
+        (
+            lambda payload: payload["predictor"]["numeric_metadata"].update({"rmse": 0.1}),
+            "forbidden claim or metric metadata",
+        ),
+    ],
+)
+def test_residual_predictor_manifest_blocks_unsupported_claims_and_metrics(
+    mutation: Callable[[MutableMapping[str, object]], object],
+    message: str,
+) -> None:
+    manifest = deepcopy(_valid_manifest())
+    mutation(manifest)
+
+    with pytest.raises(ResidualPredictorManifestValidationError, match=message):
+        validate_phase15_residual_predictor_manifest(manifest)
+
+
+def test_residual_predictor_diagnostics_are_json_safe_after_validation_failure() -> None:
+    manifest = deepcopy(_valid_manifest())
+    manifest["predictor"]["numeric_metadata"]["scale"] = float("inf")
+
+    diagnostics = residual_predictor_contract_diagnostics(manifest)
+
+    assert diagnostics["schema_version"] == PHASE15_RESIDUAL_PREDICTOR_SCHEMA_VERSION
+    assert diagnostics["contract"] == PHASE15_RESIDUAL_PREDICTOR_CONTRACT
+    assert diagnostics["passed"] is False
+    assert diagnostics["blocking_gaps"]
+    assert "must be finite" in diagnostics["blocking_gaps"][0]
+    json.dumps(diagnostics, allow_nan=False)

tokens used
103,975
Implemented and pushed the Phase 15 residual-predictor manifest contract.

Changed:
- [phase15_residual_predictor_contract.py](/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase15-03-filters-residual-predictor-contract-20260509T163452Z/src/bsebench_filters/phase15_residual_predictor_contract.py)
- [test_phase15_residual_predictor_contract.py](/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase15-03-filters-residual-predictor-contract-20260509T163452Z/tests/test_phase15_residual_predictor_contract.py)

Validation passed:
- `uv run --extra dev pytest tests/test_phase15_residual_predictor_contract.py`
- `uv run --extra dev ruff check src/bsebench_filters/phase15_residual_predictor_contract.py tests/test_phase15_residual_predictor_contract.py`
- `git diff --check`
- `uv run --extra dev pytest` (`220 passed`)

Committed and pushed:
- `b3253be` `GLASSBOX [role: phase15-filters-residual-predictor-contract] Add residual predictor manifest contract`
- Branch: `glassbox-phase15-03-filters-residual-predictor-contract-20260509T163452Z`
```
