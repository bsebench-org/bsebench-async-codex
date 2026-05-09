# Aging/SOH Internal Audit Report - 2026-05-09

## Verdict

Internal aging/SOH diagnostic checkpoint status:

- `GO_TOOLING`
- `GO_EMPIRICAL_SMOKE`
- `NO_GO_CLAIM`

Phase 10 is accepted as an internal operational checkpoint for NASA B0005
aging/SOH readiness, predispatch, strict filter smoke, explicit diagnostic
projection, and stats preflight blocking. It is not an external-result,
performance, or scientific aging-invariance claim.

## Evidence Bundle

Product worktree:

- `/mnt/c/doctorat/bsebench-org/.phase9-integration-20260509T024454+0200`

Product heads used in this audit:

- `bsebench-datasets`: branch `glassbox-phase9-integration-20260509T024454+0200`, commit `e128cb3`
- `bsebench-runner`: branch `glassbox-phase9-integration-20260509T024454+0200`, commit `c062da5`
- `bsebench-filters`: branch `glassbox-phase9-integration-20260509T024454+0200`, commit `bb72d59`
- `bsebench-stats`: branch `glassbox-phase9-integration-20260509T024454+0200`, commit `99d3e60`
- `bsebench-specs`: branch `glassbox-phase9-integration-20260509T024454+0200`, commit `2964ed7`
- `bsebench-async-codex`: branch `main`, current base commit `5495444`

Dataset readiness evidence:

- `bsebench-datasets/outputs/phase10_aging_soh_readiness_20260509_nasa_b0005_ready.json`
- `schema_version=bsebench-aging-soh-readiness-inventory/v1`
- `configs_total=155`
- `ready_configs=1`
- `not_ready_configs=154`
- ready config: `nasa:CC-discharge:T24`
- Tier 2 cache evidence: ready, selected trace `B0005_test2.parquet`
- provenance evidence: ready, NASA archive and B0005 MAT SHA256 hashes recorded
- explicit aging/SOH metadata: ready under `bsebench.aging_soh_metadata`
- SOH range in selected trace: `1.0` to `1.0`
- row count: `197`
- `downloads_performed=false`
- `scientific_result=false`

Runner predispatch evidence:

- `bsebench-runner/outputs/phase10_nasa_b0005_aging_soh_predispatch_20260509.json`
- `schema_version=aging_soh_predispatch_gate_v1`
- `total_rows=1`
- `ready_rows=1`
- `blocked_rows=0`
- `diagnostic_only=true`
- `scientific_verdict=none`
- degraded initial SOC protocol: enabled at `0.5`

Strict empirical smoke evidence:

- `bsebench-runner/outputs/phase10_nasa_b0005_aging_soh_smoke_20260509.json`
- filter: `Hinf`
- ready rows consumed: `1`
- loaded dataset: NASA B0005, `test_id=2`, `N=197`
- checked steps before contract stop: `5`
- status: `failed`
- failure: `soc_estimated must be bounded in [0, 1]`
- `performance_claim=false`
- external-result claim flag: `false`
- `scientific_verdict=none`

- `bsebench-runner/outputs/phase10_nasa_b0005_aging_soh_smoke_ekf_20260509.json`
- filter: `EKF`
- ready rows consumed: `1`
- loaded dataset: NASA B0005, `test_id=2`, `N=197`
- checked steps before contract stop: `4`
- status: `failed`
- failure: `soc_estimated must be bounded in [0, 1]`
- `performance_claim=false`
- external-result claim flag: `false`
- `scientific_verdict=none`

Diagnostic projection evidence:

- `bsebench-runner/outputs/phase10_nasa_b0005_aging_soh_smoke_hinf_bounded_projection_20260509.json`
- output adaptation: `bounded-projection`
- status: `diagnostic_projected`
- checked steps: `20`
- adapted steps: `20`
- `passed_jobs=0`
- `claim_eligible_jobs=0`
- `claim_eligible=false`
- `claim_status=claim_ineligible_bounded_projection_diagnostic`
- `performance_claim=false`
- external-result claim flag: `false`
- `scientific_verdict=none`

Stats verdict-input evidence:

- `bsebench-stats/outputs/phase10_nasa_b0005_aging_soh_stratified_preflight_input_20260509.json`
- `bsebench-stats/outputs/phase10_nasa_b0005_aging_soh_stratified_preflight_20260509.json`
- `schema_version=aging_soh_stratified_preflight_v1`
- valid rows: `2`
- filters represented: `Hinf`, `EKF`
- stratified group: `chemistry=LCO|temperature_c=24`
- SOH axis groups: `1`
- `preflight_status=preflight_blocked`
- blocker: `insufficient_axis_groups`
- stratified analysis readiness flag: `false`
- `scientific_verdict=none`
- `performance_verdict=none`

## Phase 9

Tooling status: `GO_TOOLING`

- Branch evidence: `main` plus product branches listed in the Phase 9 final
  audit report.
- Commit/SHA evidence: async report commit `5495444`; product commits include
  `e128cb3`, `c062da5`, `3c3a6b5`, `2964ed7`, and `bb72d59`.
- Validation evidence: JSON guardrails, acceptance gate, merge-matrix test, and
  targeted datasets/runner/stats/specs/filters tests passed.
- Blocker status: no blockers for the internal Phase 9 operational smoke
  checkpoint.

Empirical status: `GO_EMPIRICAL`

- Cache evidence: CALCE A123/INR Tier 2 cache evidence present and checked.
- Provenance evidence: provenance present for the internal smoke artifacts.
- Tier2 evidence: Tier 2 readiness present for the bounded CALCE A123/INR
  smoke slice.
- Empirical-run artifact evidence: Phase 9 loader and EKF smoke artifacts are
  present and checked in the final Phase 9 report.

Scientific status: `NO_GO_CLAIM`

- No external superiority or scientific result claim is supported by Phase 9.

## Phase 10

Tooling status: `GO_TOOLING`

- Branch evidence: `bsebench-datasets`, `bsebench-runner`, `bsebench-filters`,
  `bsebench-stats`, and `bsebench-specs` on
  `glassbox-phase9-integration-20260509T024454+0200`; async report on `main`.
- Commit/SHA evidence: `e128cb3`, `c062da5`, `bb72d59`, `99d3e60`, `2964ed7`,
  and base async commit `5495444`.
- Validation evidence: JSON guardrails, targeted pytest suites, specs schema
  tests, and stats preflight command returned the expected block status.
- Blocker status: no blockers for the internal operational diagnostic checkpoint;
  scientific stratified analysis remains blocked by insufficient SOH/aging groups.

Empirical status: `GO_EMPIRICAL`

- Cache evidence: NASA B0005 Tier 2 cache ready for
  `nasa:CC-discharge:T24`.
- Provenance evidence: NASA source archive hash, B0005 MAT hash, source URI,
  DOI, license, and selected trace provenance are present.
- Tier2 evidence: selected Parquet trace `B0005_test2.parquet` is readable,
  has `197` rows, and carries explicit `bsebench.aging_soh_metadata`.
- Empirical-run artifact evidence: strict Hinf/EKF smoke artifacts and the
  Hinf bounded-projection diagnostic artifact are present and checked.

Scientific status: `NO_GO_CLAIM`

- No Phase 10 performance, external-result, robustness, or aging-invariance
  claim is supported. The stats preflight intentionally blocks stratified
  analysis because there is only one SOH group.

## Phase 11

Tooling status: `NO_GO_TOOLING`

- Phase 11 was not advanced in this audit pass.

Empirical status: `NO_GO_EMPIRICAL`

- No new Phase 11 empirical artifact is claimed in this report.

Scientific status: `NO_GO_CLAIM`

- No Phase 11 scientific claim is made in this report.

## Verification Commands

Commands rerun during this audit:

```bash
UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_aging_soh_readiness.py tests/test_aging_soh_fixture_audit.py -q

UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_phase10_aging_soh_plan_from_readiness.py tests/test_aging_soh_predispatch.py tests/test_aging_predispatch_budget.py tests/test_phase10_aging_soh_smoke.py -q

UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_phase10_smoke_contract.py tests/test_phase10_bounded_projection_adapter.py tests/test_phase9_10_11_exports.py -q

PYTHONPATH=. UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest -q tests/test_phase9_11_no_claims_linter.py

UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest -q tests/test_aging_soh_stratified_preflight.py

UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest -q tests/test_aging_soh_readiness_schema.py

UV_LINK_MODE=copy uv run python scripts/aging_soh_stratified_preflight.py outputs/phase10_nasa_b0005_aging_soh_stratified_preflight_input_20260509.json --output outputs/phase10_nasa_b0005_aging_soh_stratified_preflight_20260509.json
```

Results:

- Datasets Phase 10 readiness/fixture audit tests: `19 passed`.
- Runner Phase 10 plan/predispatch/budget/smoke tests: `33 passed`.
- Filters Phase 10 contract/projection/export tests: `27 passed`.
- Stats no-claims linter tests: `18 passed`.
- Stats aging/SOH stratified preflight tests: `8 passed`.
- Specs aging/SOH schema tests: `9 passed`.
- JSON guardrails: passed.
- Stats preflight: intentionally `preflight_blocked` with
  `insufficient_axis_groups`.

## Corrections

One audit finding was corrected before this report:

- A missing Phase 10 stats/verdict-input artifact was added in `bsebench-stats`
  commit `99d3e60`. It confirms that strict Hinf/EKF smoke rows are valid as
  mechanical evidence but not sufficient for stratified aging/SOH analysis.

## Handoff To Phase 11

Phase 10 checkpoint is accepted for internal operational diagnostic purposes.
The next work item is Phase 11 residual diagnostics audit/report, while
Phase 10 scientific stratified analysis stays blocked until at least two
SOH or aging groups exist with full filter coverage and repeat evidence.
