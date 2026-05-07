# Chef verdict for phase-7-8-g-stats-hinf-weighting-sensitivity

- Decision : needs_fix
- Decided at : 2026-05-07T08:59:11+02:00
- Decided by : chef-daemon (automated, France PC) [role: chef-FR]

## Re-verification on chef PC

chef-side gate failure

## Gate evidence

```
tests/test_residual_cov_panel_runner.py::test_failed_filter_is_excluded_without_fabricating_evidence PASSED [ 60%]
tests/test_residual_cov_panel_runner.py::test_retained_configs_with_different_ok_filter_sets_fail_loud PASSED [ 62%]
tests/test_residual_cov_panel_runner.py::test_config_with_fewer_than_two_ok_filters_is_skipped_and_can_fail_loud PASSED [ 63%]
tests/test_residual_cov_panel_runner.py::test_unequal_residual_lengths_raise_clear_error PASSED [ 64%]
tests/test_residual_cov_panel_runner.py::test_non_finite_residuals_raise_clear_error PASSED [ 66%]
tests/test_residual_cov_panel_runner.py::test_duplicate_filter_labels_raise_clear_error PASSED [ 67%]
tests/test_residual_cov_panel_runner.py::test_missing_required_keys_raise_clear_errors[<lambda>-trace_payload must include configs] PASSED [ 68%]
tests/test_residual_cov_panel_runner.py::test_missing_required_keys_raise_clear_errors[<lambda>-configs\['cfg_a'\] must include filters] PASSED [ 70%]
tests/test_residual_cov_panel_runner.py::test_missing_required_keys_raise_clear_errors[<lambda>-filters\['EKF'\] must include residual_mV] PASSED [ 71%]
tests/test_residual_cov_panel_runner.py::test_file_runner_writes_json_only_after_ok_config_requirement_passes PASSED [ 72%]
tests/test_residual_cov_panel_runner.py::test_top_level_export_matches_runner_export PASSED [ 74%]
tests/test_residual_cov_panel_runner.py::test_constant_filter_correlation_remains_json_safe PASSED [ 75%]
tests/test_residual_decomp_runner.py::test_balanced_5_configs_5_filters_produces_metrics_and_decomposition_shares PASSED [ 77%]
tests/test_residual_decomp_runner.py::test_balanced_5_configs_5_filters_includes_loo_config_stability PASSED [ 78%]
tests/test_residual_decomp_runner.py::test_config_dominant_synthetic_payload_yields_larger_config_share PASSED [ 79%]
tests/test_residual_decomp_runner.py::test_filter_dominant_synthetic_payload_yields_larger_filter_share PASSED [ 81%]
tests/test_residual_decomp_runner.py::test_supported_alternate_metrics_are_used_as_metric_value[residual_var_mV2] PASSED [ 82%]
tests/test_residual_decomp_runner.py::test_supported_alternate_metrics_are_used_as_metric_value[rmse_mV] PASSED [ 83%]
tests/test_residual_decomp_runner.py::test_loo_config_stability_requires_at_least_three_retained_configs PASSED [ 85%]
tests/test_residual_decomp_runner.py::test_hinf_like_distinct_variance_appears_in_mechanical_filter_effects PASSED [ 86%]
tests/test_residual_decomp_runner.py::test_failed_filters_are_excluded_without_fabricated_residual_arrays PASSED [ 87%]
tests/test_residual_decomp_runner.py::test_divergent_ok_filter_sets_across_retained_configs_fail_loud PASSED [ 89%]
tests/test_residual_decomp_runner.py::test_invalid_residual_arrays_raise_clear_errors[residuals0-4-finite] PASSED [ 90%]
tests/test_residual_decomp_runner.py::test_invalid_residual_arrays_raise_clear_errors[residuals1-2-one-dimensional] PASSED [ 91%]
tests/test_residual_decomp_runner.py::test_invalid_residual_arrays_raise_clear_errors[residuals2-2-at least 2 samples] PASSED [ 93%]
tests/test_residual_decomp_runner.py::test_invalid_residual_arrays_raise_clear_errors[residuals3-4-retained_samples must equal] PASSED [ 94%]
tests/test_residual_decomp_runner.py::test_duplicate_labels_raise_clear_error PASSED [ 95%]
tests/test_residual_decomp_runner.py::test_config_with_too_few_ok_filters_is_skipped_and_can_fail_loud PASSED [ 97%]
tests/test_residual_decomp_runner.py::test_file_runner_writes_json_only_after_requirements_pass PASSED [ 98%]
tests/test_residual_decomp_runner.py::test_top_level_export_matches_runner_export PASSED [100%]

================================ tests coverage ================================
_______________ coverage: platform linux, python 3.12.3-final-0 ________________

Name                                             Stmts   Miss Branch BrPart  Cover   Missing
--------------------------------------------------------------------------------------------
src/bsebench_stats/__init__.py                       6      0      0      0   100%
src/bsebench_stats/friedman.py                      61      2     28      2    96%   205, 208
src/bsebench_stats/friedman_nemenyi.py              63      9     22      3    86%   25-26, 77, 114-115, 117, 121, 127-128
src/bsebench_stats/residual_cov.py                 150     37     46     15    73%   16-17, 24, 32, 36, 58, 60, 75, 87-89, 158-159, 161, 163, 176-179, 182, 186, 192, 199-202, 204, 221, 225, 230-233, 245-248
src/bsebench_stats/runners/__init__.py               5      0      0      0   100%
src/bsebench_stats/runners/friedman.py              61      4     22      2    93%   17-18, 21, 55
src/bsebench_stats/runners/hinf_sensitivity.py     404     55    148     56    80%   36, 46, 53-56, 58, 65, 71, 78, 80, 86, 92, 95, 103, 112, 123-125, 150-153, 155, 159, 167, 169, 176, 188, 190, 192, 198, 207, 278, 288, 324, 428, 483, 513-514, 516, 518, 524, 532, 537, 541, 552, 580->575, 587->594, 619, 769, 778->783, 784, 898->912, 920, 929, 938->947, 948->947, 959->958, 971->981, 982->1026, 983->994, 1000->998, 1016->1014, 1057, 1059, 1076, 1303->1307
src/bsebench_stats/runners/residual_cov.py         167     21     56     16    83%   37, 50, 53-54, 56, 64, 67-68, 88, 90, 97-98, 120, 125, 157->159, 160, 174, 185, 192, 209, 241, 313
src/bsebench_stats/runners/residual_decomp.py      209     14     64     13    90%   50, 52, 54-55, 58, 85, 96, 137, 148, 154, 169, 256, 262, 580
--------------------------------------------------------------------------------------------
TOTAL                                             1126    142    386    107    84%
============================= 74 passed in 10.48s ==============================
Would reformat: src/bsebench_stats/runners/hinf_sensitivity.py
1 file would be reformatted, 20 files already formatted
```

## Changed files

```
A	scripts/hinf_residual_sensitivity.py
M	src/bsebench_stats/__init__.py
M	src/bsebench_stats/runners/__init__.py
A	src/bsebench_stats/runners/hinf_sensitivity.py
A	tests/test_hinf_residual_sensitivity.py
```

## Cross-references

- inbox/phase-7-8-g-stats-hinf-weighting-sensitivity/STATUS.json (worker artifact)
- outbox/phase-7-8-g-stats-hinf-weighting-sensitivity/SUMMARY.md (worker SUMMARY)
- outbox/phase-7-8-g-stats-hinf-weighting-sensitivity/run.log.tail (worker stdout tail, if non-empty)
