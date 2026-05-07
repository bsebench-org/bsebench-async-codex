# Phase phase-7-7-c-stats-residual-decomp-loo-stability summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 50 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-stats
- Target branch : phase-7-7-c-stats-residual-decomp-loo-stability
- Branch SHA : d7e86b72398e6785238797fabbb5c788d2294215
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T04:40:38+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
   615	        filter_labels=retained_filter_labels,
   616	        metric=metric_name,
   617	    )
   618	    payload["decomposition"] = _decompose_metric_table(
   619	        metric_table,
   620	        config_labels=retained_config_labels,
   621	        filter_labels=retained_filter_labels,
   622	    )
   623	    config_effects, filter_effects = _effect_summaries(
   624	        per_config_filter_metrics,
   625	        metric_table,
   626	        config_labels=retained_config_labels,
   627	        filter_labels=retained_filter_labels,
   628	    )
   629	    payload["config_effects"] = config_effects
   630	    payload["filter_effects"] = filter_effects
   631	    payload["loo_config_stability"] = _loo_config_stability(
   632	        per_config_filter_metrics,
   633	        filter_effects,
   634	        config_labels=retained_config_labels,
   635	        filter_labels=retained_filter_labels,
   636	        metric=metric_name,
   637	    )
   638	    json.dumps(payload, allow_nan=False)
   639	    return payload
   640	
   641	
   642	def run_residual_variance_decomposition(
   643	    input_path: str | Path,
   644	    output_path: str | Path,
   645	    *,
   646	    min_ok_filters: int = 2,
   647	    require_ok_configs: int = 1,
   648	    metric: str = "log_residual_var",
   649	    epsilon: float = DEFAULT_EPSILON,
   650	) -> dict[str, object]:
   651	    """Read a trace payload, build the decomposition report, then write JSON output."""
   652	    with Path(input_path).open(encoding="utf-8") as fh:
   653	        trace_payload = json.load(fh)
   654	
   655	    payload = build_residual_variance_decomposition(
   656	        trace_payload,
   657	        min_ok_filters=min_ok_filters,
   658	        require_ok_configs=require_ok_configs,
   659	        metric=metric,
   660	        epsilon=epsilon,

codex
Implemented and committed on `phase-7-7-c-stats-residual-decomp-loo-stability`.

Commit: `d7e86b7 GLASSBOX [role: worker-codex-FR] Add residual decomp LOO stability`

Changes:
- Added `loo_config_stability` to balanced residual decomposition output in [residual_decomp.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-7-c-stats-residual-decomp-loo-stability/src/bsebench_stats/runners/residual_decomp.py:397).
- Added synthetic coverage for 5x5 LOO runs, JSON-safe finite ranges, retained filter keys including `Hinf`, and the fewer-than-3-config explicit status in [test_residual_decomp_runner.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-7-c-stats-residual-decomp-loo-stability/tests/test_residual_decomp_runner.py:141).

Acceptance gates passed:
- `uv run --locked --all-extras pytest tests/test_residual_decomp_runner.py -m fast --tb=short`
- `uv run --locked --all-extras pytest -m "not slow" --tb=short`
- `uv run --locked --all-extras ruff format --check .`
- `uv run --locked --all-extras ruff check .`

Only source/test files were committed. `uv.lock` is untracked and not committed. No README, roadmap, claim registry, thesis prose, real outputs, or verdict text were touched.
tokens used
143,174
Implemented and committed on `phase-7-7-c-stats-residual-decomp-loo-stability`.

Commit: `d7e86b7 GLASSBOX [role: worker-codex-FR] Add residual decomp LOO stability`

Changes:
- Added `loo_config_stability` to balanced residual decomposition output in [residual_decomp.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-7-c-stats-residual-decomp-loo-stability/src/bsebench_stats/runners/residual_decomp.py:397).
- Added synthetic coverage for 5x5 LOO runs, JSON-safe finite ranges, retained filter keys including `Hinf`, and the fewer-than-3-config explicit status in [test_residual_decomp_runner.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-7-c-stats-residual-decomp-loo-stability/tests/test_residual_decomp_runner.py:141).

Acceptance gates passed:
- `uv run --locked --all-extras pytest tests/test_residual_decomp_runner.py -m fast --tb=short`
- `uv run --locked --all-extras pytest -m "not slow" --tb=short`
- `uv run --locked --all-extras ruff format --check .`
- `uv run --locked --all-extras ruff check .`

Only source/test files were committed. `uv.lock` is untracked and not committed. No README, roadmap, claim registry, thesis prose, real outputs, or verdict text were touched.
```

## Next step for chef

git fetch origin && git checkout phase-7-7-c-stats-residual-decomp-loo-stability in target_repo. Verify gates. Merge to main if green.
