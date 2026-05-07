# Phase phase-7-5-a-residual-cov-stats summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 35 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-stats
- Target branch : phase-7-5-a-residual-cov-stats
- Branch SHA : ed27ef1797f07ec149c45227c3bd890fe66c3117
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T03:24:31+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+    with pytest.raises(ValueError, match=r"2D"):
+        compute_residual_covariance(np.array([1.0, 2.0, 3.0]), FILTERS)
+    with pytest.raises(ValueError, match=r"at least 2 samples"):
+        compute_residual_covariance(np.array([[1.0, 2.0, 3.0]]), FILTERS)
+
+
+@pytest.mark.fast
+@pytest.mark.parametrize("filter_names", [["A", "A", "C"], ["A", "", "C"]])
+def test_compute_residual_covariance_invalid_filter_names_raise_clear_error(filter_names):
+    with pytest.raises(ValueError, match=r"filter_names"):
+        compute_residual_covariance(RESIDUALS_4X3, filter_names)
+
+
+@pytest.mark.fast
+def test_compute_residual_covariance_non_finite_residuals_raise_clear_error():
+    residuals = RESIDUALS_4X3.copy()
+    residuals[0, 0] = np.nan
+
+    with pytest.raises(ValueError, match=r"finite"):
+        compute_residual_covariance(residuals, FILTERS)
+
+
+@pytest.mark.fast
+def test_aggregate_residual_covariances_two_configs_preserves_shape_and_count():
+    report_a = compute_residual_covariance(RESIDUALS_4X3, FILTERS)
+    report_b = compute_residual_covariance(RESIDUALS_4X3 * 2.0, FILTERS)
+
+    aggregate = aggregate_residual_covariances([report_a, report_b])
+
+    assert aggregate["n_configs"] == 2
+    assert aggregate["n_samples"] == 8
+    assert aggregate["n_samples_per_config"] == [4, 4]
+    assert aggregate["n_filters"] == 3
+    assert aggregate["filter_names"] == FILTERS
+    assert np.asarray(aggregate["covariance_matrix"], dtype=float).shape == (3, 3)
+    assert np.asarray(aggregate["correlation_matrix"], dtype=float).shape == (3, 3)
+    np.testing.assert_allclose(
+        np.asarray(aggregate["covariance_matrix"], dtype=float),
+        (
+            np.asarray(report_a["covariance_matrix"], dtype=float)
+            + np.asarray(report_b["covariance_matrix"], dtype=float)
+        )
+        / 2.0,
+    )
+    assert aggregate["off_diagonal_summary"]["n_pairs"] == 3
+    json.dumps(aggregate, allow_nan=False)
+
+
+@pytest.mark.fast
+def test_top_level_package_exports_residual_covariance_functions():
+    assert callable(compute_residual_covariance)
+    assert callable(aggregate_residual_covariances)

tokens used
62,346
Implemented and committed Phase 7.5.a tooling.

Commit: `ed27ef1 GLASSBOX [role: worker-codex-FR] Add residual covariance stats primitives`

Changes:
- Added [residual_cov.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-5-a-residual-cov-stats/src/bsebench_stats/residual_cov.py:1) with:
  - `compute_residual_covariance`
  - `aggregate_residual_covariances`
  - JSON-safe `None` for undefined correlations
  - covariance via `np.cov(..., rowvar=False)`
  - off-diagonal correlation summary
- Exported both functions from [__init__.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-5-a-residual-cov-stats/src/bsebench_stats/__init__.py:1)
- Added focused tests in [test_residual_cov.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-5-a-residual-cov-stats/tests/test_residual_cov.py:1)

Acceptance gates run:
- `uv run --all-extras pytest tests/test_residual_cov.py --tb=short` passed
- `uv run --all-extras pytest -m "not slow" --tb=short` passed: 38 passed
- `uv run --all-extras ruff format --check .` passed
- `uv run --all-extras ruff check .` passed

Final state:
- Worktree clean
- No `uv.lock` committed
- No claim registry, roadmap, README, or thesis prose edits
- No `Co-Authored-By: Claude` trailer
```

## Next step for chef

git fetch origin && git checkout phase-7-5-a-residual-cov-stats in target_repo. Verify gates. Merge to main if green.
