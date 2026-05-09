# Phase 14 Task Graph - 2026-05-09

## Phase Objective

Build the mechanical foundation for information-theoretic SOC/SOH estimation
bounds under model uncertainty.

This phase is only a tooling/theory-preflight phase until reviewed. It must not
claim a new theorem, a tight empirical bound, or filter superiority.

## Launch Policy

Ready tasks may run in parallel only when their owned paths are disjoint. Merge
order remains dependency-aware:

1. Specs contracts.
2. Stats core validators and recursions.
3. Dataset/runner/filter preflights.
4. Website/communication.
5. Cross-repo audit.

## Tasks

| ID | Repo | Task | Owned paths | Depends on | Ready |
| --- | --- | --- | --- | --- | --- |
| P14-01 | `bsebench-specs` | Bound contract schema | `schemas/phase14_information_bound.schema.json`, `src/bsebench_specs/phase14_information_bound.py`, `tests/test_phase14_information_bound.py` | none | yes |
| P14-02 | `bsebench-stats` | Matrix PSD/SPD validators | `src/bsebench_stats/phase14_matrix_checks.py`, `tests/test_phase14_matrix_checks.py` | none | yes |
| P14-03 | `bsebench-stats` | Linear-Gaussian PCRLB recursion | `src/bsebench_stats/phase14_linear_pcrlb.py`, `tests/test_phase14_linear_pcrlb.py` | P14-02 | yes, can import local validator or duplicate minimal private checks until merge |
| P14-04 | `bsebench-stats` | Model-uncertainty/oracle mixture preflight | `src/bsebench_stats/phase14_model_uncertainty.py`, `tests/test_phase14_model_uncertainty.py` | P14-02 | yes |
| P14-05 | `bsebench-stats` | Bound report/no-claim gate | `src/bsebench_stats/phase14_bound_report_gate.py`, `tests/test_phase14_bound_report_gate.py` | P14-03, P14-04 | queued after stats core |
| P14-06 | `bsebench-runner` | Bound dry-run plan | `src/bsebench_runner/phase14_bound_plan.py`, `tests/test_phase14_bound_plan.py` | P14-01 concept only | yes |
| P14-07 | `bsebench-runner` | Bound dry-run CLI | `src/bsebench_runner/phase14_bound_dry_run_cli.py`, `tests/test_phase14_bound_dry_run_cli.py` | P14-06 | queued after runner plan |
| P14-08 | `bsebench-datasets` | Noise-evidence gate | `src/bsebench_datasets/phase14_noise_evidence.py`, `tests/test_phase14_noise_evidence.py` | none | yes |
| P14-09 | `bsebench-filters` | ECM linearization descriptor | `src/bsebench_filters/phase14_ecm_linearization.py`, `tests/test_phase14_ecm_linearization.py` | none | yes |
| P14-10 | `bsebench-stats` | Synthetic sanity fixtures | `tests/fixtures/phase14_linear_gaussian_bound/*.json`, `tests/test_phase14_synthetic_sanity.py` | P14-02, P14-03 | queued after stats recursion |
| P14-11 | `bsebench-website` | Phase 14 status page | `src/content/docs/phase14-information-bounds.md`, `astro.config.mjs` | opening audit | yes |
| P14-12 | `bsebench-async-codex` | Phase 14 integration audit | `docs/PHASE_14_INTEGRATION_AUDIT_2026-05-09.md`, `docs/MOBILE_CTO_CHAT.md` | all merged branches | no |

## Acceptance Gates

A Phase 14 branch is not mergeable unless:

- it is finite JSON-safe where it emits machine-readable output;
- it rejects non-finite matrices, non-square matrices, asymmetric covariance,
  negative variances, missing provenance, and dimension mismatches;
- it explicitly reports `NO_GO_CLAIM` or equivalent no-claim status;
- it does not label weighted conditional per-model PCRLBs as a true Bayesian
  model-uncertainty PCRLB unless validated mixture information blocks are
  supplied;
- its tests include at least one fail-closed path;
- it does not download or upload datasets;
- it does not execute estimators on real battery traces;
- it does not introduce theorem or performance claims.

## Cross-Phase Constraints

Phase 14 may depend on Phase 13 no-claim policy, but must not weaken it. Phase
12 execution blockers remain authoritative: no SOC derivation, transfer
execution, or parameter use is allowed from Phase 14 code unless the existing
gates later pass.

## Four-Eyes Checks

Before any claim stronger than mechanical/theory preflight:

- math/proof reviewer checks recursion, assumptions, regularity conditions, and
  counterexamples;
- evidence/comparability reviewer checks provenance, replay, source ledger,
  datasets, splits, units, and metric comparability;
- product/docs reviewer scans docs, generated reports, and website pages for
  forbidden wording;
- claim-safety reviewer confirms the final state remains `NO_GO_CLAIM` or signs
  a separate claim-registration record.
