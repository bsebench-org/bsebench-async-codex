# phase-15-02-filters-ema-bias-correction-20260509T163452Z direct-worker summary

- Direct pid: `3081053`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-filters`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase15-02-filters-ema-bias-correction-20260509T163452Z`
- Target branch: `glassbox-phase15-02-filters-ema-bias-correction-20260509T163452Z`
- Branch SHA: `ab18b9a136a2c7f5cec877d34d228481522d88bd`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T16:52:51.776951Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+            lambda evidence: evidence.pop("split_manifest_sha256"),
+            r"evidence\.split_manifest_sha256 must be a sha256 hex digest",
+        ),
+        (
+            lambda evidence: evidence.update({"provenance_sha256": "not-a-sha"}),
+            r"evidence\.provenance_sha256 must be a sha256 hex digest",
+        ),
+    ],
+)
+def test_missing_or_invalid_synthetic_evidence_fails_closed(mutation, message: str) -> None:
+    evidence = _evidence()
+    mutation(evidence)
+
+    with pytest.raises(Phase15EMABiasCorrectionValidationError, match=message):
+        _valid_report(evidence=evidence)
+
+
+def test_split_reuse_is_rejected_as_leakage() -> None:
+    with pytest.raises(
+        Phase15EMABiasCorrectionValidationError,
+        match="calibration_split_id and correction_split_id must be distinct",
+    ):
+        _valid_report(
+            calibration_split_id="synthetic_same_split",
+            correction_split_id="synthetic_same_split",
+        )
+
+
+@pytest.mark.parametrize(
+    ("overrides", "message"),
+    [
+        ({"claim_status": "RMSE_GAIN"}, "claim_status must remain NO_GO_CLAIM"),
+        (
+            {"notes": "synthetic adaptive gain calibration"},
+            "forbidden adaptive-gain wording",
+        ),
+        (
+            {"stream_id": "phase15_sota_residual_helper"},
+            "unsupported claim wording: sota",
+        ),
+    ],
+)
+def test_unsupported_claim_and_adaptive_gain_wording_fails_closed(
+    overrides: dict[str, object],
+    message: str,
+) -> None:
+    with pytest.raises(Phase15EMABiasCorrectionValidationError, match=message):
+        _valid_report(**overrides)
+
+
+def test_report_validator_recomputes_steps_and_returns_blocking_gaps() -> None:
+    report = deepcopy(_valid_report())
+    report["steps"][1]["bias_after"] = 1.0
+
+    with pytest.raises(
+        Phase15EMABiasCorrectionValidationError,
+        match=r"steps\[1\]\.bias_after does not match EMA update",
+    ):
+        validate_phase15_ema_bias_correction_report(report)
+    assert ema_bias_correction_blocking_gaps(report) == (
+        "steps[1].bias_after does not match EMA update",
+    )

tokens used
116,636
Implemented and pushed commit `ab18b9a136a2c7f5cec877d34d228481522d88bd` to `glassbox-phase15-02-filters-ema-bias-correction-20260509T163452Z`.

Added:
- [phase15_ema_bias_correction.py](/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase15-02-filters-ema-bias-correction-20260509T163452Z/src/bsebench_filters/phase15_ema_bias_correction.py): deterministic EMA residual-bias corrector, report builder/validator, finite/alpha/reset/evidence/split/claim gates.
- [test_phase15_ema_bias_correction.py](/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase15-02-filters-ema-bias-correction-20260509T163452Z/tests/test_phase15_ema_bias_correction.py): focused coverage for update math, reset behavior, non-finite rejection, invalid evidence, split reuse, and claim-ineligible output.

Validation passed:
- `uv run --locked --extra dev pytest tests/test_phase15_ema_bias_correction.py -q` (`16 passed`)
- `uv run --locked --extra dev ruff check src/bsebench_filters/phase15_ema_bias_correction.py tests/test_phase15_ema_bias_correction.py`
- `uv run --locked --extra dev ruff format --check ...`
- `uv run --locked --extra dev ruff check .`
- `uv run --locked --extra dev pytest -q` (`214 passed`)
- `git diff --cached --check`

No validation was skipped.
```
