# phase-15-10-stats-synthetic-ema-fixtures-20260509T163452Z direct-worker summary

- Direct pid: `3088551`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase15-10-stats-synthetic-ema-fixtures-20260509T163452Z`
- Target branch: `glassbox-phase15-10-stats-synthetic-ema-fixtures-20260509T163452Z`
- Branch SHA: `afe53749ca5b1a6b529e63d15ac1da671f7809f9`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T17:08:37.164609Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+    fixture = copy.deepcopy(_load_fixture())
+    mutate(fixture)
+
+    with pytest.raises((AssertionError, ValueError), match=message):
+        _validate_ema_report(fixture["ema_bias_correction_report"])
+
+
+@pytest.mark.fast
+@pytest.mark.parametrize(
+    ("mutate", "expected_gap"),
+    [
+        (
+            lambda fixture: fixture["adaptive_delta_gate_input"]["adaptive_artifact"].update(
+                {"artifact_sha256": "not-a-sha256"}
+            ),
+            "invalid_adaptive_hash",
+        ),
+        (
+            lambda fixture: fixture["adaptive_delta_gate_input"]["adaptive_artifact"][
+                "metric_rows"
+            ][1].update({"pair_id": "synthetic-scalar-extra"}),
+            "missing_baseline_row",
+        ),
+        (
+            lambda fixture: fixture["adaptive_delta_gate_input"]["adaptive_artifact"][
+                "metric_rows"
+            ][0]["metrics"].update({"absolute_residual": math.inf}),
+            "non_finite_metric",
+        ),
+        (
+            lambda fixture: fixture["adaptive_delta_gate_input"]["adaptive_artifact"][
+                "metric_rows"
+            ][0].update({"split_role": "training"}),
+            "split_leakage",
+        ),
+        (
+            lambda fixture: fixture["adaptive_delta_gate_input"]["claims"].update(
+                {"adaptive_gain": True}
+            ),
+            "unauthorized_claim_flag",
+        ),
+        (
+            lambda fixture: fixture["adaptive_delta_gate_input"]["documents"][0].update(
+                {"text": "This synthetic note contains adaptive gain wording."}
+            ),
+            "forbidden_adaptive_gain_wording",
+        ),
+    ],
+)
+def test_paired_delta_gate_mutations_fail_closed(
+    mutate: Callable[[dict[str, Any]], object],
+    expected_gap: str,
+) -> None:
+    fixture = copy.deepcopy(_load_fixture())
+    mutate(fixture)
+
+    report = _build_delta_gate_report(fixture["adaptive_delta_gate_input"])
+
+    assert report["gate_status"] == "blocked"
+    assert expected_gap in _gap_ids(report)
+    assert report["release_gate"]["pass"] is False
+    json.dumps(report, allow_nan=False)

tokens used
183,380
Implemented and pushed commit `afe5374` to `origin/glassbox-phase15-10-stats-synthetic-ema-fixtures-20260509T163452Z`.

Added:
- [README.md](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase15-10-stats-synthetic-ema-fixtures-20260509T163452Z/tests/fixtures/phase15_ema_adaptation/README.md)
- [scalar_bias_fixture.json](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase15-10-stats-synthetic-ema-fixtures-20260509T163452Z/tests/fixtures/phase15_ema_adaptation/scalar_bias_fixture.json)
- [test_phase15_synthetic_ema.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase15-10-stats-synthetic-ema-fixtures-20260509T163452Z/tests/test_phase15_synthetic_ema.py)

Validation run:
- `uv run --locked --extra dev pytest tests/test_phase15_synthetic_ema.py -q` passed: 13 tests
- `uv run --locked --extra dev ruff check tests/test_phase15_synthetic_ema.py` passed
- `git diff --check` passed
- `uv run --locked --extra dev pytest tests/test_phase14_synthetic_sanity.py tests/test_phase15_synthetic_ema.py -q` passed: 22 tests
- `uv run --locked --extra dev pytest -m "not slow" -q` passed: 450 tests

No validation skipped.
```
