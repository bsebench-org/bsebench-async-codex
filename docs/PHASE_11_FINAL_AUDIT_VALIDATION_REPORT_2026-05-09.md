# Residual Diagnostics Internal Audit Report - 2026-05-09

## Verdict

Internal residual diagnostics checkpoint status:

- `GO_TOOLING`
- `GO_EMPIRICAL`
- `NO_GO_CLAIM`

This report accepts the residual diagnostics checkpoint as an internal
operational/mechanical milestone. It does not support any external-result,
ranking, or scientific sensor-noise/model-mismatch conclusion.

## Evidence Bundle

Product worktree:

- `/mnt/c/doctorat/bsebench-org/.phase9-integration-20260509T024454+0200`

Product heads used in this audit:

- `bsebench-datasets`: branch `glassbox-phase9-integration-20260509T024454+0200`, commit `e128cb3`
- `bsebench-runner`: branch `glassbox-phase9-integration-20260509T024454+0200`, commit `7891d96`
- `bsebench-filters`: branch `glassbox-phase9-integration-20260509T024454+0200`, commit `bb72d59`
- `bsebench-stats`: branch `glassbox-phase9-integration-20260509T024454+0200`, commit `ff68465`
- `bsebench-specs`: branch `glassbox-phase9-integration-20260509T024454+0200`, commit `2964ed7`
- `bsebench-async-codex`: branch `main`, base commit `2ac76e2`

Residual cache preflight evidence:

- `bsebench-runner/outputs/hinf_residual_cache_preflight.json`
- `schema_version=cache_preflight_v1`
- `required_configs=5`
- `ok_configs=5`
- `missing_configs=0`
- `hf_auth_present=false`
- configs checked: Yao BCDC T25, Yao US06 T25, Panasonic US06 T25,
  NASA B0005 T24, CALCE A123 DST T25
- `scientific_verdict=none`

Strict residual evidence:

- `bsebench-runner/outputs/hinf_residual_evidence_5x5.json`
- `mechanical_evidence_only=true`
- `expected_configs=5`
- `expected_filters=5`
- `ok_configs=5`
- `ok_filter_runs=25`
- `error_configs=0`
- `error_filter_runs=0`
- residual covariance traces checked: `25`
- residual decomposition traces checked: `25`
- `scientific_verdict=none`

Sensitivity sidecar evidence:

- `bsebench-runner/outputs/hinf_residual_sensitivity_5x5.json`
- `schema_version=hinf_residual_sensitivity_sidecar_v1`
- `mechanical_evidence_only=true`
- falsification gate status: `material_sensitivity_detected`
- `risk_count=9`
- main risks: sample-count imbalance, weighted decomposition-share changes,
  target-filter weighted mean metric delta, and short-config leave-one-out
  sensitivity
- `scientific_verdict=none`

Artifact manifest evidence:

- `bsebench-runner/outputs/hinf_residual_artifact_manifest.json`
- `schema_version=hinf_residual_artifact_manifest_v1`
- preflight hash: `e002d37837e8ee6c4ddfa43b5c4607a6278ce240f1839642ddc9fd85c01329d7`
- chi2 hash: `ab1c3d92e762aa00365b3b2b1b1bd98dc0d87fc78519cdfb211e242135158d20`
- evidence hash: `35c255c696fd9b63552c2206d08009aea834c17f3f09e2bd49b7ac5666917f78`
- lockfile hash: `7fa8262794883cac36a5b420d9460ea4aeb6c5bb3faf0606d868be34460d9ea8`
- strict summary: preflight `5/5`, evidence `5` configs and `25` filter
  runs, chi2 `25` checked rows

Stats readiness evidence:

- `bsebench-stats/outputs/phase11_residual_diagnostics_readiness_input_20260509.json`
- `bsebench-stats/outputs/phase11_residual_diagnostics_readiness_20260509.json`
- `schema_version=phase11_residual_diagnostics_readiness_v1`
- `preflight_status=preflight_ready`
- `interpretation_status=mechanical_validation_only`
- `mechanical_validation_only=true`
- residual type: `prediction`
- sample count: `2900`
- null control: present with matching sample support
- decomposition labels: `sensor_noise`, `model_mismatch`, `numerical_gap`
- blocking gaps: none for the mechanical preflight

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
- Tier2 evidence: Tier 2 cache evidence present for the bounded CALCE A123/INR
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
  and async report commit `2ac76e2`.
- Validation evidence: JSON guardrails, targeted pytest suites, specs schema
  tests, and stats preflight command returned the expected block status.
- Blocker status: no blockers for the internal operational diagnostic
  checkpoint; scientific stratified analysis remains blocked by insufficient
  SOH/aging groups.

Empirical status: `GO_EMPIRICAL`

- Cache evidence: NASA B0005 Tier 2 cache present for
  `nasa:CC-discharge:T24`.
- Provenance evidence: NASA source archive hash, B0005 MAT hash, source URI,
  DOI, license, and selected trace provenance are present.
- Tier2 evidence: selected Parquet trace `B0005_test2.parquet` is readable,
  has `197` rows, and carries explicit `bsebench.aging_soh_metadata`.
- Empirical-run artifact evidence: strict Hinf/EKF smoke artifacts and the
  Hinf bounded-projection diagnostic artifact are present and checked.

Scientific status: `NO_GO_CLAIM`

- No Phase 10 external-result, robustness, or aging-invariance claim is
  supported. The stats preflight intentionally blocks stratified analysis
  because there is only one SOH group.

## Phase 11

Tooling status: `GO_TOOLING`

- Branch evidence: `bsebench-runner`, `bsebench-stats`, `bsebench-filters`, and
  `bsebench-specs` on `glassbox-phase9-integration-20260509T024454+0200`;
  async report on `main`.
- Commit/SHA evidence: runner `7891d96`, stats `ff68465`, filters `bb72d59`,
  specs `2964ed7`, datasets `e128cb3`, async base `2ac76e2`.
- Validation evidence: targeted pytest suites across runner, stats, filters,
  and specs; runner manifest drift audit; JSON artifact checks; async
  acceptance gate.
- Blocker status: no blockers for the internal mechanical residual diagnostics
  checkpoint. Scientific interpretation remains blocked by sensitivity and
  sample-support risks.

Empirical status: `GO_EMPIRICAL`

- Cache evidence: residual cache preflight present with `5/5` required configs
  checked.
- Provenance evidence: artifact manifest present with strict hashes for
  preflight, chi2, evidence, and lockfile.
- Tier2 evidence: all five residual configs loaded from Tier 2 cache inputs:
  Yao BCDC T25, Yao US06 T25, Panasonic US06 T25, NASA B0005 T24, and CALCE
  A123 DST T25.
- Empirical-run artifact evidence: strict residual evidence artifact present
  with `5` configs and `25` filter runs checked; sensitivity sidecar present
  with risk flags.

Scientific status: `NO_GO_CLAIM`

- No Phase 11 scientific sensor-noise/model-mismatch conclusion is supported.
  The evidence is mechanical only, and the sensitivity sidecar reports material
  sensitivity plus sample-count imbalance.

## Verification Commands

Commands rerun during this audit:

```bash
UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_hinf_residual_cache_preflight.py tests/test_hinf_residual_evidence_5x5.py tests/test_audit_hinf_residual_outputs.py tests/test_audit_hinf_residual_manifest.py tests/test_audit_hinf_residual_manifest_drift.py tests/test_audit_hinf_residual_sensitivity_sidecar.py tests/test_phase11_residual_input_contract.py tests/test_phase11_residual_dryrun_manifest.py tests/test_residual_trace_5x5.py tests/test_residuals.py -q

UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_residual_diagnostics_readiness.py tests/test_residual_cov_panel_runner.py tests/test_residual_decomp_runner.py tests/test_hinf_residual_sensitivity.py -q

UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_residual_output_contract.py tests/test_phase9_10_11_exports.py -q

UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_residual_decomposition_schema.py -q

UV_LINK_MODE=copy uv run python scripts/residual_diagnostics_readiness.py outputs/phase11_residual_diagnostics_readiness_input_20260509.json --output outputs/phase11_residual_diagnostics_readiness_20260509.json
```

Results:

- Runner residual cache/evidence/manifest/sensitivity/input/dry-run tests:
  `81 passed`.
- Stats residual readiness/covariance/decomposition/sensitivity tests:
  `47 passed`.
- Filters residual contract/export tests: `21 passed`.
- Specs residual decomposition schema tests: `21 passed`.
- Stats readiness command: `preflight_ready` with
  `interpretation_status=mechanical_validation_only`.

## Corrections

Two audit findings were corrected before this report:

- The runner residual artifact manifest pinned a stale `uv.lock` hash after the
  lockfile moved. Commit `7891d96` refreshes the manifest and regenerated
  candidate report pointers.
- The stats repository lacked a durable Phase 11 residual diagnostics readiness
  artifact. Commit `ff68465` adds the input and output JSON files.

## Handoff

Phase 11 is accepted as an internal mechanical residual diagnostics checkpoint.
The immediate next step is a cross-phase audit of Phases 9, 10, and 11 to
confirm that no evidence bundle or claim guardrail regressed.
