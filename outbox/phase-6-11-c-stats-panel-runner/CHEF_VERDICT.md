# Chef verdict for phase-6-11-c-stats-panel-runner

- Decision : approved
- Decided at : 2026-05-07T03:09:07+02:00
- Decided by : chef-daemon (automated, France PC) [role: chef-FR]

## Re-verification on chef PC

merged phase-6-11-c-stats-panel-runner -> main at 1eb7c428ea174da41e3b5538cb809bc0e37dc8d5

## Gate evidence

```
         If the cache and target directories are on different filesystems, hardlinking may not be supported.
         If this is intentional, set `export UV_LINK_MODE=copy` or use `--link-mode=copy` to suppress this warning.
Installed 24 packages in 20.89s
============================= test session starts ==============================
platform linux -- Python 3.12.3, pytest-9.0.3, pluggy-1.6.0 -- /mnt/c/doctorat/bsebench-org/bsebench-stats/.venv/bin/python
cachedir: .pytest_cache
rootdir: /mnt/c/doctorat/bsebench-org/bsebench-stats
configfile: pyproject.toml
testpaths: tests
plugins: cov-7.1.0
collecting ... collected 22 items

tests/test_friedman.py::test_friedman_chi2_reproduces_audit_j PASSED     [  4%]
tests/test_friedman.py::test_nemenyi_cd_reproduces_audit_j PASSED        [  9%]
tests/test_friedman.py::test_nemenyi_cd_formula_explicit PASSED          [ 13%]
tests/test_friedman.py::test_pairwise_significant_pairs_reproduces_audit_j_count PASSED [ 18%]
tests/test_friedman.py::test_pairwise_known_significant_pair PASSED      [ 22%]
tests/test_friedman.py::test_pairwise_known_non_significant_pair PASSED  [ 27%]
tests/test_friedman.py::test_friedman_chi2_input_validation PASSED       [ 31%]
tests/test_friedman.py::test_nemenyi_cd_input_validation PASSED          [ 36%]
tests/test_friedman.py::test_pairwise_input_validation PASSED            [ 40%]
tests/test_friedman.py::test_synthetic_degenerate_winner PASSED          [ 45%]
tests/test_friedman.py::test_friedman_from_rmse_matrix_handles_failure_sentinel PASSED [ 50%]
tests/test_friedman.py::test_friedman_from_rmse_matrix_no_complete PASSED [ 54%]
tests/test_friedman_nemenyi.py::test_friedman_test_3x3_synthetic_sanity PASSED [ 59%]
tests/test_friedman_nemenyi.py::test_friedman_test_5x4_synthetic_sanity PASSED [ 63%]
tests/test_friedman_nemenyi.py::test_friedman_test_all_equal_is_non_significant PASSED [ 68%]
tests/test_friedman_nemenyi.py::test_friedman_test_clearly_separated_filters_small_p_value PASSED [ 72%]
tests/test_friedman_nemenyi.py::test_nemenyi_pairwise_matrix_shape_symmetry_and_diagonal PASSED [ 77%]
tests/test_friedman_nemenyi.py::test_invalid_shape_or_insufficient_data_raises_clear_error PASSED [ 81%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_5x4_shape_and_keys PASSED [ 86%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_spearman_matrix_shape_symmetry_and_diagonal PASSED [ 90%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_invalid_filter_name_length_raises_clear_error PASSED [ 95%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_output_is_json_serializable PASSED [100%]

================================ tests coverage ================================
_______________ coverage: platform linux, python 3.12.3-final-0 ________________

Name                                     Stmts   Miss Branch BrPart  Cover   Missing
------------------------------------------------------------------------------------
src/bsebench_stats/__init__.py               5      0      0      0   100%
src/bsebench_stats/friedman.py              61      2     28      2    96%   205, 208
src/bsebench_stats/friedman_nemenyi.py      63      9     22      3    86%   25-26, 77, 114-115, 117, 121, 127-128
src/bsebench_stats/runners/__init__.py       2      0      0      0   100%
src/bsebench_stats/runners/friedman.py      61      9     22      7    81%   17-18, 21, 23, 29, 35, 37, 45, 55
------------------------------------------------------------------------------------
TOTAL                                      192     20     72     12    88%
============================== 22 passed in 9.42s ==============================
10 files already formatted
All checks passed!
```

## Cross-references

- inbox/phase-6-11-c-stats-panel-runner/STATUS.json (worker artifact)
- outbox/phase-6-11-c-stats-panel-runner/SUMMARY.md (worker SUMMARY)
- outbox/phase-6-11-c-stats-panel-runner/run.log.tail (worker stdout tail, if non-empty)
