# Phase phase-6-11-d-friedman-nemenyi-stats-fix-1 summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 30 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-stats
- Target branch : phase-6-11-d-friedman-nemenyi-stats-fix-1
- Branch SHA : e32b72d3a42857a81e284b29bafb96804abb1998
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T01:21:50+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+    )
+
+    result = friedman_test(rmse)
+
+    np.testing.assert_allclose(result["average_ranks"], np.array([1.2, 2.0, 3.0, 3.8]))
+    assert result["chi2"] == pytest.approx(11.64)
+    assert result["p_value"] == pytest.approx(0.008723836058328946)
+
+
+@pytest.mark.fast
+def test_friedman_test_all_equal_is_non_significant():
+    result = friedman_test(np.ones((4, 3)))
+
+    assert result["chi2"] == 0.0
+    assert result["p_value"] == 1.0
+    np.testing.assert_allclose(result["ranks"], np.full((4, 3), 2.0))
+    np.testing.assert_allclose(result["average_ranks"], np.full(3, 2.0))
+
+
+@pytest.mark.fast
+def test_friedman_test_clearly_separated_filters_small_p_value():
+    rmse = np.tile(np.array([1.0, 2.0, 3.0, 4.0]), (12, 1))
+
+    result = friedman_test(rmse)
+
+    assert result["chi2"] == pytest.approx(36.0)
+    assert result["p_value"] < 1e-6
+    np.testing.assert_allclose(result["average_ranks"], np.array([1.0, 2.0, 3.0, 4.0]))
+
+
+@pytest.mark.fast
+def test_nemenyi_pairwise_matrix_shape_symmetry_and_diagonal():
+    ranks = np.tile(np.array([1.0, 2.0, 3.0, 4.0]), (20, 1))
+
+    result = nemenyi_test(ranks, n_configs=20)
+    significant = result["pairwise_significant"]
+
+    assert result["critical_difference"] == pytest.approx(1.0488028292894491)
+    assert significant.shape == (4, 4)
+    assert significant.dtype == bool
+    np.testing.assert_array_equal(significant, significant.T)
+    assert not np.any(np.diag(significant))
+    assert not significant[0, 1]
+    assert significant[0, 2]
+    assert significant[0, 3]
+
+
+@pytest.mark.fast
+def test_invalid_shape_or_insufficient_data_raises_clear_error():
+    with pytest.raises(ValueError, match="2D"):
+        friedman_test(np.array([1.0, 2.0, 3.0]))
+    with pytest.raises(ValueError, match="at least 2 configs"):
+        friedman_test(np.ones((1, 3)))
+    with pytest.raises(ValueError, match="at least 3 filters"):
+        friedman_test(np.ones((3, 2)))
+    with pytest.raises(ValueError, match="finite"):
+        friedman_test(np.array([[1.0, 2.0, np.nan], [1.0, 2.0, 3.0]]))
+    with pytest.raises(ValueError, match=r"match ranks\.shape"):
+        nemenyi_test(np.ones((3, 3)), n_configs=4)
+    with pytest.raises(ValueError, match="at least 2 filters"):
+        nemenyi_test(np.ones((3, 1)), n_configs=3)
+    with pytest.raises(ValueError, match="alpha"):
+        nemenyi_test(np.ones((3, 3)), n_configs=3, alpha=1.0)

tokens used
116,187
Implemented and committed `e32b72d` (`GLASSBOX: add Friedman Nemenyi stats API`) with `[role: worker-codex-FR]` and no Claude trailer.

Changed:
- [friedman_nemenyi.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-6-11-d-friedman-nemenyi-stats-fix-1/src/bsebench_stats/friedman_nemenyi.py:1): added `friedman_test` and `nemenyi_test`.
- [__init__.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-6-11-d-friedman-nemenyi-stats-fix-1/src/bsebench_stats/__init__.py:1): exported the new public functions.
- [test_friedman_nemenyi.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-6-11-d-friedman-nemenyi-stats-fix-1/tests/test_friedman_nemenyi.py:1): added 6 focused fast tests.

Acceptance gates passed:
- `uv run pytest tests/test_friedman_nemenyi.py -q --tb=short`: 6 passed
- `uv run pytest -m "not slow" --tb=short`: 18 passed
- `uv run ruff format --check .`: passed
- `uv run ruff check .`: passed

Worktree is clean and the branch is ahead by 1 commit. I used Demšar 2006 from JMLR for the Friedman/Nemenyi formulas: https://www.jmlr.org/papers/volume7/demsar06a/demsar06a.pdf
```

## Next step for chef

git fetch origin && git checkout phase-6-11-d-friedman-nemenyi-stats-fix-1 in target_repo. Verify gates. Merge to main if green.
