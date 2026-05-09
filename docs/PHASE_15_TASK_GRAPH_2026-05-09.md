# Phase 15 Task Graph - 2026-05-09

## Phase Objective

Build mechanical readiness for adaptive filter learning without making an
adaptive-performance claim.

The first implementation wave focuses on EMA bias correction, residual-predictor
contracts, leakage guards, dry-run plans, paired-delta gates, and synthetic
fixtures. It must not execute estimators on real traces or train neural models.

## Launch Policy

Ready tasks may run in parallel only when owned paths are disjoint. Merge order
must remain dependency-aware:

1. Specs and filter contracts.
2. Safety/leakage and dataset calibration gates.
3. Runner dry-run plan/CLI.
4. Stats paired-delta and claim gates.
5. Synthetic fixtures and website.
6. Cross-repo audit.

## Tasks

| ID | Repo | Task | Owned paths | Depends on | Ready |
| --- | --- | --- | --- | --- | --- |
| P15-01 | `bsebench-specs` | Adaptive method contract | `schemas/phase15_adaptive_filter.schema.json`, `src/bsebench_specs/phase15_adaptive_filter.py`, `tests/test_phase15_adaptive_filter.py` | none | yes |
| P15-02 | `bsebench-filters` | EMA bias-correction helper | `src/bsebench_filters/phase15_ema_bias_correction.py`, `tests/test_phase15_ema_bias_correction.py` | none | yes |
| P15-03 | `bsebench-filters` | Residual-predictor contract | `src/bsebench_filters/phase15_residual_predictor_contract.py`, `tests/test_phase15_residual_predictor_contract.py` | none | yes |
| P15-04 | `bsebench-filters` | Adaptation safety/leakage gate | `src/bsebench_filters/phase15_adaptation_safety.py`, `tests/test_phase15_adaptation_safety.py` | P15-02, P15-03 | queued after filter contracts |
| P15-05 | `bsebench-stats` | Paired adaptive-delta gate | `src/bsebench_stats/phase15_adaptive_delta_gate.py`, `tests/test_phase15_adaptive_delta_gate.py` | none | yes |
| P15-06 | `bsebench-stats` | Adaptive report/no-claim gate | `src/bsebench_stats/phase15_adaptive_report_gate.py`, `tests/test_phase15_adaptive_report_gate.py` | P15-05 | queued after stats delta gate |
| P15-07 | `bsebench-runner` | Adaptive dry-run plan | `src/bsebench_runner/phase15_adaptive_plan.py`, `tests/test_phase15_adaptive_plan.py` | P15-01 concept only | yes |
| P15-08 | `bsebench-runner` | Adaptive dry-run CLI | `src/bsebench_runner/phase15_adaptive_dry_run_cli.py`, `tests/test_phase15_adaptive_dry_run_cli.py` | P15-07 | queued after runner plan |
| P15-09 | `bsebench-datasets` | Calibration split evidence gate | `src/bsebench_datasets/phase15_calibration_evidence.py`, `tests/test_phase15_calibration_evidence.py` | none | yes |
| P15-10 | `bsebench-stats` | Synthetic EMA sanity fixtures | `tests/fixtures/phase15_ema_adaptation/README.md`, `tests/fixtures/phase15_ema_adaptation/scalar_bias_fixture.json`, `tests/test_phase15_synthetic_ema.py` | P15-02, P15-05 | queued after EMA and delta gates |
| P15-11 | `bsebench-website` | Phase 15 status page | `src/content/docs/phase15-adaptive-learning.md`, `astro.config.mjs` | opening audit | yes |
| P15-12 | `bsebench-async-codex` | Phase 15 integration audit | `docs/PHASE_15_FINAL_CLOSURE_REPORT_2026-05-09.md`, `docs/PHASE_15_CLOSURE_LEDGER_2026-05-09.json`, `docs/MOBILE_CTO_CHAT.md` | all product branches | no |

## Acceptance Gates

A Phase 15 branch is not mergeable unless:

- it is finite JSON-safe where it emits machine-readable output;
- it rejects non-finite metrics, residuals, learning rates, and hashes;
- it keeps calibration and evaluation windows separate;
- it refuses future-label or future-residual access;
- it reports claim-ineligible status by default;
- tests include at least one fail-closed path;
- it does not download/upload datasets;
- it does not execute estimators on real battery traces;
- it does not claim RMSE improvement, SOTA, leaderboard status, superiority, or
  chemistry-specific adaptation success.

## Cross-Phase Constraints

Phase 15 may use Phase 12/13/14 gates, but must not weaken them. Adaptive
parameters remain blocked for transfer-readiness until a later frozen artifact
proves the update rule, split separation, and replay path.

## Four-Eyes Checks

Before any claim stronger than mechanical preflight:

- leakage reviewer checks online update access, split separation, and reset
  policy;
- statistics reviewer checks paired deltas, uncertainty, and multiplicity;
- battery reviewer checks whether the residual source is physically meaningful;
- claim-safety reviewer confirms `NO_GO_CLAIM` or signs a separate
  claim-registration record.
