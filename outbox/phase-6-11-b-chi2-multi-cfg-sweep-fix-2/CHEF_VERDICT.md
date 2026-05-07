# Chef verdict for phase-6-11-b-chi2-multi-cfg-sweep-fix-2

- Decision : approved
- Decided at : 2026-05-07T03:06:23+02:00
- Decided by : chef-daemon (automated, France PC) [role: chef-FR]

## Re-verification on chef PC

merged phase-6-11-b-chi2-multi-cfg-sweep-fix-2 -> main at d25828847b3e2ee1ddc7e2f3c68f5845cda4b61c

## Gate evidence

```
tests/test_default_adapters.py::test_caller_can_register_a_non_canonical_wrapper PASSED [ 48%]
tests/test_default_registries.py::test_registry_has_exactly_10_filters PASSED [ 50%]
tests/test_default_registries.py::test_registry_filter_names_match_audit_j_verdict PASSED [ 51%]
tests/test_default_registries.py::test_all_8_retuned_json_checkpoints_exist PASSED [ 53%]
tests/test_default_registries.py::test_each_retuned_json_has_kwargs_field PASSED [ 55%]
tests/test_default_registries.py::test_hinf_kwargs_match_audit_j_verdict_constants PASSED [ 56%]
tests/test_default_registries.py::test_filter_config_translation_produces_valid_pydantic PASSED [ 58%]
tests/test_default_registries.py::test_filter_config_scalar_sigma2_broadcasts_to_state_dim PASSED [ 60%]
tests/test_default_registries.py::test_jukf_v6b_constants_match_paper2b_section_5_4 PASSED [ 61%]
tests/test_default_registries.py::test_ensemble_meta_constants_match_paper2b_section_5_4 PASSED [ 63%]
tests/test_default_registries.py::test_build_raises_on_missing_checkpoints_dir PASSED [ 65%]
tests/test_default_registries.py::test_load_retuned_kwargs_raises_on_missing_filter PASSED [ 66%]
tests/test_metrics.py::test_rmse_zero_when_pred_equals_meas PASSED       [ 68%]
tests/test_metrics.py::test_rmse_constant_offset_in_mv PASSED            [ 70%]
tests/test_metrics.py::test_rmse_known_pattern PASSED                    [ 71%]
tests/test_metrics.py::test_rmse_caps_at_divergence_sentinel PASSED      [ 73%]
tests/test_metrics.py::test_rmse_caps_on_nan PASSED                      [ 75%]
tests/test_metrics.py::test_rmse_caps_on_inf PASSED                      [ 76%]
tests/test_metrics.py::test_rmse_validates_shape PASSED                  [ 78%]
tests/test_metrics.py::test_rmse_validates_nonempty PASSED               [ 80%]
tests/test_metrics.py::test_rmse_accepts_lists PASSED                    [ 81%]
tests/test_metrics.py::test_compute_mae_mv_basic PASSED                  [ 83%]
tests/test_metrics.py::test_compute_mae_mv_zero_on_perfect_match PASSED  [ 85%]
tests/test_metrics.py::test_compute_mae_mv_returns_sentinel_on_divergence PASSED [ 86%]
tests/test_orchestrator.py::test_run_benchmark_returns_run_result PASSED [ 88%]
tests/test_orchestrator.py::test_run_benchmark_friedman_verdict_keys PASSED [ 90%]
tests/test_orchestrator.py::test_run_benchmark_diverging_filter_falls_back_to_sentinel PASSED [ 91%]
tests/test_orchestrator.py::test_run_benchmark_filter_subset PASSED      [ 93%]
tests/test_orchestrator.py::test_run_benchmark_rejects_empty_registry PASSED [ 95%]
tests/test_orchestrator.py::test_run_benchmark_unknown_filter_subset PASSED [ 96%]
tests/test_orchestrator.py::test_run_benchmark_n_max_validates PASSED    [ 98%]
tests/test_orchestrator.py::test_run_benchmark_missing_adapter_yields_sentinel_column PASSED [100%]

================================ tests coverage ================================
_______________ coverage: platform linux, python 3.12.3-final-0 ________________

Name                                        Stmts   Miss Branch BrPart  Cover   Missing
---------------------------------------------------------------------------------------
src/bsebench_runner/__init__.py                 7      0      0      0   100%
src/bsebench_runner/cli.py                     42      4      6      3    85%   99, 118-119, 123
src/bsebench_runner/default_adapters.py        58      5     14      3    89%   160, 177-179, 181-183
src/bsebench_runner/default_registries.py      66      3     22      2    94%   86, 132, 138
src/bsebench_runner/metrics.py                 32      3     14      3    87%   67, 72, 78
src/bsebench_runner/orchestrator.py            86      5     26      2    90%   75-78, 142
src/bsebench_runner/registry.py                46      5     12      5    83%   37, 39, 44, 66, 68
---------------------------------------------------------------------------------------
TOTAL                                         337     25     94     18    89%
====================== 60 passed, 5 deselected in 14.44s =======================
19 files already formatted
All checks passed!
```

## Cross-references

- inbox/phase-6-11-b-chi2-multi-cfg-sweep-fix-2/STATUS.json (worker artifact)
- outbox/phase-6-11-b-chi2-multi-cfg-sweep-fix-2/SUMMARY.md (worker SUMMARY)
- outbox/phase-6-11-b-chi2-multi-cfg-sweep-fix-2/run.log.tail (worker stdout tail, if non-empty)
