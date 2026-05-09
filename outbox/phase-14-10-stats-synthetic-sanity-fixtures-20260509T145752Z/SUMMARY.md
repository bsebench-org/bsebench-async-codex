# phase-14-10-stats-synthetic-sanity-fixtures-20260509T145752Z direct-worker summary

- Direct pid: `3072478`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase14-10-stats-synthetic-sanity-fixtures-20260509T145752Z`
- Target branch: `glassbox-phase14-10-stats-synthetic-sanity-fixtures-20260509T145752Z`
- Branch SHA: `4bbacf983e9cbf6359215f96123014e10a50d50f`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T15:40:36.332326Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+    assert report["recursion_terms"] == {
+        "process_information": [[1.0]],
+        "measurement_information": [[1.0]],
+        **expected["recursion_terms"],
+    }
+    assert _numeric_leaf_values(report["information_sequence"]) == pytest.approx(
+        _numeric_leaf_values(expected["information_sequence"])
+    )
+    assert _numeric_leaf_values(report["covariance_lower_bound_sequence"]) == pytest.approx(
+        _numeric_leaf_values(expected["covariance_lower_bound_sequence"])
+    )
+    json.dumps(report, allow_nan=False)
+    _assert_json_finite(report)
+
+
+@pytest.mark.fast
+@pytest.mark.parametrize(
+    ("mutate", "error_type", "message"),
+    [
+        (lambda fixture: fixture.pop("Q"), Phase14LinearPcrlbError, r"requires supplied"),
+        (lambda fixture: fixture.update({"Q": [[math.inf]]}), Phase14LinearPcrlbError, r"finite"),
+        (
+            lambda fixture: fixture.update({"H": [[1.0, 0.0]]}),
+            Phase14LinearPcrlbError,
+            r"H column count",
+        ),
+        (
+            lambda fixture: fixture.update({"Q": [[0.0]]}),
+            Phase14MatrixCheckError,
+            r"positive definite",
+        ),
+        (
+            lambda fixture: fixture.update({"prior_information": [[0.0]]}),
+            Phase14MatrixCheckError,
+            r"positive definite",
+        ),
+        (
+            lambda fixture: fixture.update({"fixture_scope": "real_battery_evidence"}),
+            Phase14LinearPcrlbError,
+            r"synthetic",
+        ),
+        (
+            lambda fixture: fixture.update({"claims": ["leaderboard_status"]}),
+            Phase14LinearPcrlbError,
+            r"refuses",
+        ),
+    ],
+)
+def test_scalar_fixture_mutations_fail_closed(
+    mutate: Callable[[dict[str, object]], object],
+    error_type: type[Exception],
+    message: str,
+) -> None:
+    fixture = copy.deepcopy(_load_scalar_fixture())
+    mutate(fixture)
+
+    with pytest.raises(error_type, match=message) as exc_info:
+        build_linear_gaussian_pcrlb_report(fixture)
+
+    diagnostics = getattr(exc_info.value, "diagnostics", {})
+    if diagnostics:
+        json.dumps(diagnostics, allow_nan=False)

tokens used
107,335
Implemented and pushed commit `4bbacf9` to `glassbox-phase14-10-stats-synthetic-sanity-fixtures-20260509T145752Z`.

Changed:
- Added synthetic fixture docs: [README.md](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase14-10-stats-synthetic-sanity-fixtures-20260509T145752Z/tests/fixtures/phase14_linear_gaussian_bound/README.md)
- Added scalar claim-ineligible fixture: [scalar_fixture.json](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase14-10-stats-synthetic-sanity-fixtures-20260509T145752Z/tests/fixtures/phase14_linear_gaussian_bound/scalar_fixture.json)
- Added focused schema, finite, PCRLB, and fail-closed tests: [test_phase14_synthetic_sanity.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase14-10-stats-synthetic-sanity-fixtures-20260509T145752Z/tests/test_phase14_synthetic_sanity.py)

Validation:
- `uv run --locked --extra dev pytest tests/test_phase14_synthetic_sanity.py -q`: 9 passed
- `uv run --locked --extra dev pytest tests/test_phase14_synthetic_sanity.py tests/test_phase14_linear_pcrlb.py tests/test_phase14_matrix_checks.py -q`: 27 passed
- `uv run --locked --extra dev pytest -q`: 420 passed
- `uv run --locked --extra dev ruff check tests/test_phase14_synthetic_sanity.py`: passed
- `git diff --check`: passed

No validation skipped.
```
