# Phase phase-6-11-c-stats-panel-runner summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 40 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-stats
- Target branch : phase-6-11-c-stats-panel-runner
- Branch SHA : 1eb7c428ea174da41e3b5538cb809bc0e37dc8d5
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T03:07:04+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+
+import numpy as np
+import pytest
+
+from bsebench_stats.runners import run_friedman_panel
+
+RMSE_5X4 = np.array(
+    [
+        [1.0, 2.0, 3.0, 4.0],
+        [1.0, 3.0, 2.0, 4.0],
+        [2.0, 1.0, 3.0, 4.0],
+        [1.0, 2.0, 4.0, 3.0],
+        [1.0, 2.0, 3.0, 4.0],
+    ]
+)
+FILTERS = ["A", "B", "C", "D"]
+
+
+@pytest.mark.fast
+def test_run_friedman_panel_5x4_shape_and_keys():
+    report = run_friedman_panel(RMSE_5X4, FILTERS)
+
+    assert report["n_configs"] == 5
+    assert report["n_filters"] == 4
+    assert report["filter_names"] == FILTERS
+    assert set(report) == {
+        "n_configs",
+        "n_filters",
+        "filter_names",
+        "average_ranks",
+        "friedman",
+        "nemenyi",
+        "spearman",
+        "verdict",
+    }
+    assert report["friedman"]["chi2"] == pytest.approx(11.64)
+    assert report["friedman"]["p_value"] == pytest.approx(0.008723836058328946)
+    assert report["nemenyi"]["critical_difference"] > 0.0
+    assert np.asarray(report["nemenyi"]["pairwise_significant"]).shape == (4, 4)
+    assert report["verdict"]["friedman_rejects_null"] is True
+
+
+@pytest.mark.fast
+def test_run_friedman_panel_spearman_matrix_shape_symmetry_and_diagonal():
+    report = run_friedman_panel(RMSE_5X4, FILTERS)
+
+    spearman = np.asarray(report["spearman"]["correlation_matrix"], dtype=float)
+    assert spearman.shape == (4, 4)
+    np.testing.assert_allclose(spearman, spearman.T)
+    np.testing.assert_allclose(np.diag(spearman), np.ones(4))
+
+
+@pytest.mark.fast
+def test_run_friedman_panel_invalid_filter_name_length_raises_clear_error():
+    with pytest.raises(ValueError, match=r"filter_names length"):
+        run_friedman_panel(RMSE_5X4, ["A", "B", "C"])
+
+
+@pytest.mark.fast
+def test_run_friedman_panel_output_is_json_serializable():
+    report = run_friedman_panel(RMSE_5X4, FILTERS)
+
+    json.dumps(report, allow_nan=False)

tokens used
83,454
Implemented and committed `1eb7c42`:

`GLASSBOX [role: worker-codex-FR] Add stats panel runner`

Added `run_friedman_panel` in [friedman.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-6-11-c-stats-panel-runner/src/bsebench_stats/runners/friedman.py), exposed it via package exports, and added focused tests in [test_friedman_panel_runner.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-6-11-c-stats-panel-runner/tests/test_friedman_panel_runner.py). The output includes dimensions, filter names, average ranks, Friedman stats, Nemenyi CD/significance matrix, Spearman matrix, and a neutral verdict dict.

Acceptance gates passed:

- `uv run --all-extras pytest tests/test_friedman_panel_runner.py -q`
- `uv run --all-extras pytest -m "not slow" --tb=short`
- `uv run --all-extras ruff format --check .`
- `uv run --all-extras ruff check .`

Scope is 197 insertions. No `Co-Authored-By: Claude` trailer is present. Working tree is clean and the branch is ahead by 1 commit.
```

## Next step for chef

git fetch origin && git checkout phase-6-11-c-stats-panel-runner in target_repo. Verify gates. Merge to main if green.
