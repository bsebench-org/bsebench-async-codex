# Chef verdict for phase-7-6-a-residual-cov-trace-panel

- Decision : approved
- Decided at : 2026-05-07T03:49:10+02:00
- Decided by : chef-daemon (automated, France PC) [role: chef-FR]

## Re-verification on chef PC

merged phase-7-6-a-residual-cov-trace-panel -> main at 2da10f86b6366a01036d11fd9479b0a8aab54eb7

## Gate evidence

```
tests/test_friedman_panel_runner.py::test_run_friedman_panel_5x4_shape_and_keys PASSED [ 38%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_spearman_matrix_shape_symmetry_and_diagonal PASSED [ 40%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_invalid_filter_name_length_raises_clear_error PASSED [ 42%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_output_is_json_serializable PASSED [ 44%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_top_level_export_matches_runner_export PASSED [ 46%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_invalid_filter_names_raise_clear_error[ABCD-filter_names must be a sequence] PASSED [ 48%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_invalid_filter_names_raise_clear_error[filter_names1-filter_names must be unique] PASSED [ 50%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_invalid_filter_names_raise_clear_error[filter_names2-filter_names must contain non-empty strings] PASSED [ 52%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_invalid_filter_names_raise_clear_error[filter_names3-filter_names must contain non-empty strings] PASSED [ 54%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_rejects_non_finite_rmse PASSED [ 56%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_rejects_invalid_alpha PASSED [ 58%]
tests/test_friedman_panel_runner.py::test_run_friedman_panel_spearman_constant_column_is_json_safe PASSED [ 60%]
tests/test_residual_cov.py::test_compute_residual_covariance_3_filter_shape_symmetry_and_diagonal PASSED [ 62%]
tests/test_residual_cov.py::test_compute_residual_covariance_constant_column_is_json_safe PASSED [ 64%]
tests/test_residual_cov.py::test_compute_residual_covariance_invalid_shape_raises_clear_error PASSED [ 66%]
tests/test_residual_cov.py::test_compute_residual_covariance_invalid_filter_names_raise_clear_error[filter_names0] PASSED [ 68%]
tests/test_residual_cov.py::test_compute_residual_covariance_invalid_filter_names_raise_clear_error[filter_names1] PASSED [ 70%]
tests/test_residual_cov.py::test_compute_residual_covariance_non_finite_residuals_raise_clear_error PASSED [ 72%]
tests/test_residual_cov.py::test_aggregate_residual_covariances_two_configs_preserves_shape_and_count PASSED [ 74%]
tests/test_residual_cov.py::test_top_level_package_exports_residual_covariance_functions PASSED [ 76%]
tests/test_residual_cov_panel_runner.py::test_build_residual_covariance_panel_two_configs_three_filters PASSED [ 78%]
tests/test_residual_cov_panel_runner.py::test_failed_filter_is_excluded_without_fabricating_evidence PASSED [ 80%]
tests/test_residual_cov_panel_runner.py::test_config_with_fewer_than_two_ok_filters_is_skipped_and_can_fail_loud PASSED [ 82%]
tests/test_residual_cov_panel_runner.py::test_unequal_residual_lengths_raise_clear_error PASSED [ 84%]
tests/test_residual_cov_panel_runner.py::test_non_finite_residuals_raise_clear_error PASSED [ 86%]
tests/test_residual_cov_panel_runner.py::test_duplicate_filter_labels_raise_clear_error PASSED [ 88%]
tests/test_residual_cov_panel_runner.py::test_missing_required_keys_raise_clear_errors[<lambda>-trace_payload must include configs] PASSED [ 90%]
tests/test_residual_cov_panel_runner.py::test_missing_required_keys_raise_clear_errors[<lambda>-configs\['cfg_a'\] must include filters] PASSED [ 92%]
tests/test_residual_cov_panel_runner.py::test_missing_required_keys_raise_clear_errors[<lambda>-filters\['EKF'\] must include residual_mV] PASSED [ 94%]
tests/test_residual_cov_panel_runner.py::test_file_runner_writes_json_only_after_ok_config_requirement_passes PASSED [ 96%]
tests/test_residual_cov_panel_runner.py::test_top_level_export_matches_runner_export PASSED [ 98%]
tests/test_residual_cov_panel_runner.py::test_constant_filter_correlation_remains_json_safe PASSED [100%]

================================ tests coverage ================================
_______________ coverage: platform linux, python 3.12.3-final-0 ________________

Name                                         Stmts   Miss Branch BrPart  Cover   Missing
----------------------------------------------------------------------------------------
src/bsebench_stats/__init__.py                   6      0      0      0   100%
src/bsebench_stats/friedman.py                  61      2     28      2    96%   205, 208
src/bsebench_stats/friedman_nemenyi.py          63      9     22      3    86%   25-26, 77, 114-115, 117, 121, 127-128
src/bsebench_stats/residual_cov.py             150     38     46     16    72%   16-17, 24, 32, 36, 58, 60, 75, 87-89, 158-159, 161, 163, 176-179, 182, 186, 192, 199-202, 204, 221, 225, 230-233, 245-248, 253
src/bsebench_stats/runners/__init__.py           3      0      0      0   100%
src/bsebench_stats/runners/friedman.py          61      4     22      2    93%   17-18, 21, 55
src/bsebench_stats/runners/residual_cov.py     167     25     56     18    81%   37, 50, 53-54, 56, 64, 67-68, 88, 90, 97-98, 100, 102, 120, 125, 157->159, 160, 174, 185, 192, 209, 241, 313, 339-340
----------------------------------------------------------------------------------------
TOTAL                                          511     78    174     41    83%
============================== 50 passed in 9.94s ==============================
14 files already formatted
All checks passed!
```

## Cross-references

- inbox/phase-7-6-a-residual-cov-trace-panel/STATUS.json (worker artifact)
- outbox/phase-7-6-a-residual-cov-trace-panel/SUMMARY.md (worker SUMMARY)
- outbox/phase-7-6-a-residual-cov-trace-panel/run.log.tail (worker stdout tail, if non-empty)
