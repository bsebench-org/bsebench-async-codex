# Phase 9 Internal Audit Report - 2026-05-09

## Verdict

Internal smoke checkpoint status:

- `GO_TOOLING`
- `GO_EMPIRICAL_SMOKE`
- `NO_GO_CLAIM`

The Phase 9 profile-axis machinery now has replayed real Tier2
evidence for the bounded CALCE A123/INR smoke slice. No full cross-profile
public comparison claim is supported by this evidence bundle.

## Evidence Bundle

Product worktree:

- `/mnt/c/doctorat/bsebench-org/.phase9-integration-20260509T024454+0200`

Product heads used in this audit:

- `bsebench-datasets`: `e128cb3`
- `bsebench-runner`: `c062da5`
- `bsebench-stats`: `3c3a6b5`
- `bsebench-specs`: `2964ed7`
- `bsebench-filters`: `bb72d59`
- `bsebench-async-codex` integration worktree: `a084508`
- `bsebench-async-codex` current reporting repo: `ec84ea3`

Dataset evidence:

- `bsebench-datasets/outputs/phase9_profile_axis_readiness_20260509_calce_a123_inr_ready.json`
- `configs_total=155`
- `configs_ready=36`
- `not_ready_configs=119`
- wrappers with cache evidence: `calce_a123_dyn=24`, `calce_inr_dyn=12`
- `claims_made=false`
- `downloads_performed=false`

Runner evidence:

- `bsebench-runner/outputs/phase9_calce_a123_inr_profile_axis_plan_20260509.json`
- `total_rows=26`
- `rows_with_dispatch_evidence=16`
- `blocked_rows=10`
- profile types with dispatch evidence: `DST`, `FUDS`, `US06`
- `diagnostic_only=true`
- `scientific_verdict=none`

Loader smoke evidence:

- `bsebench-runner/outputs/phase9_calce_inr_runner_loader_smoke_20260509.json`
- wrapper: `calce_inr_dyn`
- profile: `DST`
- temperature: `25 C`
- loaded samples: `12561`

Filter smoke evidence:

- `bsebench-runner/outputs/phase9_auditj_a123_inr_ekf_smoke_20260509.json`
- filter: `EKF`
- configs: `26`
- bounded samples per config: `200`
- Friedman result: fail-closed with `FRIEDMAN_REQUIRES_K_GE_2`
- SOC/SOH state metrics: unavailable for all `26/26` cells because ground-truth
  state metrics are absent or loaders are blocked.

## Audit Findings

The evidence supports a real Phase 9 infrastructure smoke:

- local Tier2 cache discovery and readiness are represented;
- runner predispatch/planning is represented;
- one real loader path replayed data;
- one bounded filter smoke executed over the planned matrix;
- blocked rows stay explicit instead of being silently dropped.

No public comparison claim is supported:

- only one filter is present in the executed smoke;
- Friedman statistics correctly fail closed for `k < 2`;
- SOC/SOH state metrics are not available in the smoke artifact;
- several wrappers still lack loader-facing cache roots;
- no public comparison language is claimed from this checkpoint.

## Verification Commands

Commands rerun during this audit:

```bash
python3 - <<'PY'
# strict JSON guardrails over readiness, plan, loader smoke, and EKF smoke
PY

bash scripts/check-phase9-11-acceptance-gate.sh <prior Phase 9/10/11 checklist>

PYTHONPATH=. UV_LINK_MODE=copy uv run --with pytest pytest -q tests/test_phase9_11_merge_matrix.py

UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_profile_axis_readiness.py -q

UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_profile_axis_planner.py tests/test_profile_dispatch_budget.py -q

UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_profile_axis_variance.py tests/test_phase9_11_no_claims_linter.py -q

UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_run_result.py tests/test_schema_export.py tests/test_dataset.py -q

UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_phase9_10_11_exports.py tests/test_profile_axis_smoke_contract.py tests/test_phase10_smoke_contract.py tests/test_residual_output_contract.py -q
```

Results:

- JSON guardrails: passed.
- Async acceptance gate: passed.
- Async merge-matrix test: `5 passed`.
- Datasets Phase 9 readiness tests: `12 passed`.
- Runner Phase 9 planner/dispatch tests: `18 passed`.
- Stats Phase 9 variance/no-claims tests: `32 passed`.
- Specs schema/run-result tests: `36 passed`.
- Filters Phase 9/10/11 contract tests: `61 passed`.

## Corrections

No product-code correction was needed in this audit pass. The required
correction is interpretive and procedural: the Phase 9 internal smoke checkpoint
has evidence, while scientific/public comparison claims remain blocked.

## Handoff To Phase 10

Next work item: continue Phase 10 from the already pushed NASA B0005 readiness,
predispatch, strict smoke, and bounded projection
diagnostics into a stronger aging/SOH validation path without relaxing the
SOC/SOH output contract and without promoting diagnostic projection into a
score.
