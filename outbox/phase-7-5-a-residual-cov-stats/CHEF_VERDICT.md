# Chef verdict for phase-7-5-a-residual-cov-stats

- Decision : approved
- Decided at : 2026-05-07T03:25:53+02:00
- Decided by : chef-daemon (automated, France PC) [role: chef-FR]

## Re-verification on chef PC

merged phase-7-5-a-residual-cov-stats -> main at ed27ef1797f07ec149c45227c3bd890fe66c3117

## Gate evidence

```
tests/test_friedman.py::test_pairwise_known_non_significant_pair PASSED  [ 15%]
tests/test_friedman.py::test_friedman_chi2_input_validation PASSED       [ 18%]
tests/test_friedman.py::test_nemenyi_cd_input_validation PASSED          [ 21%]
tests/test_friedman.py::test_pairwise_input_validation PASSED            [ 23%]
tests/test_friedman.py::test_synthetic_degenerate_winner PASSED          [ 26%]
tests/test_friedman.py::test_friedman_from_rmse_matrix_handles_failure_sentinel PASSED [ 28%]
tests/test_friedman.py::test_friedman_from_rmse_matrix_no_complete PASSED [ 31%]
tests/test_friedman_nemenyi.py::test_friedman_test_3x3_synthetic_sanity PASSED [ 34%]
tests/test_friedman_nemenyi.py::test_friedman_test_5x4_synthetic_sanity PASSED [ 36%]
tests/test_friedman_nemenyi.py::test_friedman_test_all_equal_is_non_significant PASSED [ 39%]
tests/test_friedman_nemenyi.py::test_friedman_test_clearly_separated_filters_small_p_value PASSED [ 42%]
tests/test_friedman_nemenyi.py::test_nemenyi_pairwise_matrix_shape_symmetry_and_diagonal PASSED [ 44%]
tests/test_friedman_nemenyi.py::test_invalid_shape_or_insufficient_data_raises_clear_error PASSED [ 47%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_5x4_shape_and_keys PASSED [ 50%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_spearman_matrix_shape_symmetry_and_diagonal PASSED [ 52%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_invalid_filter_name_length_raises_clear_error PASSED [ 55%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_output_is_json_serializable PASSED [ 57%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_top_level_export_matches_runner_export PASSED [ 60%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_invalid_filter_names_raise_clear_error[ABCD-filter_names must be a sequence] PASSED [ 63%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_invalid_filter_names_raise_clear_error[filter_names1-filter_names must be unique] PASSED [ 65%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_invalid_filter_names_raise_clear_error[filter_names2-filter_names must contain non-empty strings] PASSED [ 68%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_invalid_filter_names_raise_clear_error[filter_names3-filter_names must contain non-empty strings] PASSED [ 71%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_rejects_non_finite_rmse PASSED [ 73%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_rejects_invalid_alpha PASSED [ 76%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_spearman_constant_column_is_json_safe PASSED [ 78%]
tests/test_residual_cov.py::test_compute_residual_covariance_3_filter_shape_symmetry_and_diagonal PASSED [ 81%]
tests/test_residual_cov.py::test_compute_residual_covariance_constant_column_is_json_safe PASSED [ 84%]
tests/test_residual_cov.py::test_compute_residual_covariance_invalid_shape_raises_clear_error PASSED [ 86%]
tests/test_residual_cov.py::test_compute_residual_covariance_invalid_filter_names_raise_clear_error[filter_names0] PASSED [ 89%]
tests/test_residual_cov.py::test_compute_residual_covariance_invalid_filter_names_raise_clear_error[filter_names1] PASSED [ 92%]
tests/test_residual_cov.py::test_compute_residual_covariance_non_finite_residuals_raise_clear_error PASSED [ 94%]
tests/test_residual_cov.py::test_aggregate_residual_covariances_two_configs_preserves_shape_and_count PASSED [ 97%]
tests/test_residual_cov.py::test_top_level_package_exports_residual_covariance_functions PASSED [100%]

================================ tests coverage ================================
_______________ coverage: platform linux, python 3.12.3-final-0 ________________

Name                                     Stmts   Miss Branch BrPart  Cover   Missing
------------------------------------------------------------------------------------
src/bsebench_stats/__init__.py               6      0      0      0   100%
src/bsebench_stats/friedman.py              61      2     28      2    96%   205, 208
src/bsebench_stats/friedman_nemenyi.py      63      9     22      3    86%   25-26, 77, 114-115, 117, 121, 127-128
src/bsebench_stats/residual_cov.py         150     38     46     16    72%   16-17, 24, 32, 36, 58, 60, 75, 87-89, 158-159, 161, 163, 176-179, 182, 186, 192, 199-202, 204, 221, 225, 230-233, 245-248, 253
src/bsebench_stats/runners/__init__.py       2      0      0      0   100%
src/bsebench_stats/runners/friedman.py      61      4     22      2    93%   17-18, 21, 55
------------------------------------------------------------------------------------
TOTAL                                      343     53    118     23    84%
============================= 38 passed in 10.12s ==============================
12 files already formatted
All checks passed!
```

## Cross-references

- inbox/phase-7-5-a-residual-cov-stats/STATUS.json (worker artifact)
- outbox/phase-7-5-a-residual-cov-stats/SUMMARY.md (worker SUMMARY)
- outbox/phase-7-5-a-residual-cov-stats/run.log.tail (worker stdout tail, if non-empty)
