# Phase 13 Task Graph

Generated: 2026-05-09 15:45 CEST

Phase objective: implement the infrastructure needed to evaluate ensemble
methods beyond the current BMA path without claiming empirical performance
before evidence gates pass.

Scientific claim status: `NO_GO_CLAIM`.

## Wave 1 Ready Tasks

All tasks below are ready immediately and use disjoint write scopes.

| ID | Repo | Scope | Owned paths | Dependency |
|---|---|---|---|---|
| P13-01 | `bsebench-specs` | Ensemble method-card schema | `schemas/phase13_ensemble_method_card.schema.json`, `src/bsebench_specs/phase13_ensemble_method_card.py`, `tests/test_phase13_ensemble_method_card.py` | none |
| P13-02 | `bsebench-specs` | Ensemble run/evidence schema | `schemas/phase13_ensemble_run.schema.json`, `src/bsebench_specs/phase13_ensemble_run.py`, `tests/test_phase13_ensemble_run_schema.py` | none |
| P13-03 | `bsebench-stats` | Comparison readiness gate | `src/bsebench_stats/phase13_comparison_gate.py`, `tests/test_phase13_comparison_gate.py` | none |
| P13-04 | `bsebench-stats` | Bootstrap uncertainty utilities | `src/bsebench_stats/phase13_bootstrap_uncertainty.py`, `tests/test_phase13_bootstrap_uncertainty.py` | none |
| P13-05 | `bsebench-stats` | Ensemble no-claim linter | `src/bsebench_stats/phase13_no_claims.py`, `tests/test_phase13_no_claims.py` | none |
| P13-06 | `bsebench-runner` | Ensemble dry-run plan model | `src/bsebench_runner/phase13_ensemble_plan.py`, `tests/test_phase13_ensemble_plan.py` | none |
| P13-07 | `bsebench-runner` | Member artifact collector | `src/bsebench_runner/phase13_member_artifacts.py`, `tests/test_phase13_member_artifacts.py` | none |
| P13-08 | `bsebench-runner` | Ensemble dry-run CLI entry | `src/bsebench_runner/phase13_dry_run_cli.py`, `tests/test_phase13_dry_run_cli.py` | P13-06 optional |
| P13-09 | `bsebench-runner` | Ensemble compute-profile manifest | `src/bsebench_runner/phase13_compute_profile.py`, `tests/test_phase13_compute_profile.py` | none |
| P13-10 | `bsebench-filters` | Static weighted ensemble adapter | `src/bsebench_filters/phase13_static_weighted_ensemble.py`, `tests/test_phase13_static_weighted_ensemble.py` | none |
| P13-11 | `bsebench-filters` | Time-varying weight adapter | `src/bsebench_filters/phase13_time_varying_weights.py`, `tests/test_phase13_time_varying_weights.py` | none |
| P13-12 | `bsebench-filters` | Hierarchical prior metadata | `src/bsebench_filters/phase13_hierarchical_priors.py`, `tests/test_phase13_hierarchical_priors.py` | none |
| P13-13 | `bsebench-filters` | Ensemble weight-freeze gate | `src/bsebench_filters/phase13_weight_freeze.py`, `tests/test_phase13_weight_freeze.py` | none |
| P13-14 | `bsebench-datasets` | Ensemble evidence manifest | `src/bsebench_datasets/phase13_ensemble_evidence.py`, `tests/test_phase13_ensemble_evidence.py` | none |
| P13-15 | `bsebench-datasets` | Split compatibility gate | `src/bsebench_datasets/phase13_split_compatibility.py`, `tests/test_phase13_split_compatibility.py` | none |
| P13-16 | `bsebench-datasets` | Dataset evidence opening queue | `src/bsebench_datasets/phase13_opening_queue.py`, `tests/test_phase13_opening_queue.py`, `outputs/phase13_dataset_evidence_open_queue_20260509.json` | none |
| P13-17 | `bsebench-website` | Public Phase 13 status page | `src/content/docs/phase13-ensemble-methods.md`, `astro.config.mjs` | none |

## Deferred Until Wave 1 Returns

- Merge and validate product branches.
- Produce Phase 13 transverse audit.
- Connect specs and runner APIs after both sides land.
- Run any empirical ensemble comparison only after SOC/SOH truth, split,
  parameter-freeze, and artifact-hash gates pass.

## Explicit Non-Goals

- No public method leaderboard.
- No SOC/SOH transfer-performance claim.
- No dataset uploads.
- No thesis or claim-registry edits.
- No roadmap changes.

