# Chef verdict for phase-7-9-b-runner-hinf-determinism-audit

- Decision : approved
- Decided at : 2026-05-07T10:59:33+02:00
- Decided by : chef-daemon (automated, France PC) [role: chef-FR]

## Re-verification on chef PC

merged phase-7-9-b-runner-hinf-determinism-audit -> main at 0d1fed2644a41205294f8de18ccc0a16a843dfab

## Gate evidence

```
tests/test_metrics.py::test_rmse_known_pattern PASSED                    [ 74%]
tests/test_metrics.py::test_rmse_caps_at_divergence_sentinel PASSED      [ 75%]
tests/test_metrics.py::test_rmse_caps_on_nan PASSED                      [ 76%]
tests/test_metrics.py::test_rmse_caps_on_inf PASSED                      [ 77%]
tests/test_metrics.py::test_rmse_validates_shape PASSED                  [ 78%]
tests/test_metrics.py::test_rmse_validates_nonempty PASSED               [ 78%]
tests/test_metrics.py::test_rmse_accepts_lists PASSED                    [ 79%]
tests/test_metrics.py::test_compute_mae_mv_basic PASSED                  [ 80%]
tests/test_metrics.py::test_compute_mae_mv_zero_on_perfect_match PASSED  [ 81%]
tests/test_metrics.py::test_compute_mae_mv_returns_sentinel_on_divergence PASSED [ 82%]
tests/test_orchestrator.py::test_run_benchmark_returns_run_result PASSED [ 83%]
tests/test_orchestrator.py::test_run_benchmark_friedman_verdict_keys PASSED [ 84%]
tests/test_orchestrator.py::test_run_benchmark_diverging_filter_falls_back_to_sentinel PASSED [ 84%]
tests/test_orchestrator.py::test_run_benchmark_filter_subset PASSED      [ 85%]
tests/test_orchestrator.py::test_run_benchmark_rejects_empty_registry PASSED [ 86%]
tests/test_orchestrator.py::test_run_benchmark_unknown_filter_subset PASSED [ 87%]
tests/test_orchestrator.py::test_run_benchmark_n_max_validates PASSED    [ 88%]
tests/test_orchestrator.py::test_run_benchmark_missing_adapter_yields_sentinel_column PASSED [ 89%]
tests/test_residual_trace_5x5.py::test_script_import_is_side_effect_free PASSED [ 89%]
tests/test_residual_trace_5x5.py::test_synthetic_two_config_two_filter_run_writes_schema_and_residuals PASSED [ 90%]
tests/test_residual_trace_5x5.py::test_failing_loader_marks_config_error_without_residual_arrays PASSED [ 91%]
tests/test_residual_trace_5x5.py::test_failing_filter_is_reported_without_blocking_other_filters PASSED [ 92%]
tests/test_residual_trace_5x5.py::test_require_ok_configs_prevents_output_writing PASSED [ 93%]
tests/test_residual_trace_5x5.py::test_require_ok_filter_runs_prevents_output_writing PASSED [ 94%]
tests/test_residual_trace_5x5.py::test_output_json_serializes_with_allow_nan_false PASSED [ 94%]
tests/test_residuals.py::test_known_bias_filters_produce_expected_post_warmup_residuals PASSED [ 95%]
tests/test_residuals.py::test_load_truncate_and_run_one_adapter_config PASSED [ 96%]
tests/test_residuals.py::test_mismatched_trace_lengths_raise_clear_value_error PASSED [ 97%]
tests/test_residuals.py::test_empty_filters_and_invalid_warmup_raise_clear_value_error PASSED [ 98%]
tests/test_residuals.py::test_failing_filter_reports_error_without_residual_evidence PASSED [ 99%]
tests/test_residuals.py::test_residual_trace_output_json_serializes_without_nan PASSED [100%]

================================ tests coverage ================================
_______________ coverage: platform linux, python 3.12.3-final-0 ________________

Name                                        Stmts   Miss Branch BrPart  Cover   Missing
---------------------------------------------------------------------------------------
src/bsebench_runner/__init__.py                 8      0      0      0   100%
src/bsebench_runner/cli.py                     42      4      6      3    85%   99, 118-119, 123
src/bsebench_runner/default_adapters.py        85      6     22      4    91%   99, 228, 245-247, 249-251
src/bsebench_runner/default_registries.py      66      3     22      2    94%   86, 132, 138
src/bsebench_runner/metrics.py                 32      3     14      3    87%   67, 72, 78
src/bsebench_runner/orchestrator.py            86      5     26      2    90%   75-78, 142
src/bsebench_runner/registry.py                46      5     12      5    83%   37, 39, 44, 66, 68
src/bsebench_runner/residuals.py              110     11     36     10    86%   26-27, 33, 39, 42, 57, 69, 71, 95, 109, 115->114, 151
---------------------------------------------------------------------------------------
TOTAL                                         475     37    138     29    89%
====================== 119 passed, 5 deselected in 19.28s ======================
35 files already formatted
All checks passed!
```

## Changed files

```
A	scripts/audit_hinf_residual_determinism.py
A	tests/test_audit_hinf_residual_determinism.py
```

## Cross-references

- inbox/phase-7-9-b-runner-hinf-determinism-audit/STATUS.json (worker artifact)
- outbox/phase-7-9-b-runner-hinf-determinism-audit/SUMMARY.md (worker SUMMARY)
- outbox/phase-7-9-b-runner-hinf-determinism-audit/run.log.tail (worker stdout tail, if non-empty)
