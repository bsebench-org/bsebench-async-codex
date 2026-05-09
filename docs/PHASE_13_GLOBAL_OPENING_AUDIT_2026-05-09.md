# Phase 13 Global Opening Audit

Generated: 2026-05-09 15:45 CEST

Status: `PHASE_13_ALLOWED_AS_MECHANICAL_METHOD_INFRA`

Scientific claim status: `NO_GO_CLAIM`.

## Executive Decision

Phase 13 may start now, but only as a method-infrastructure phase. It must not
publish or imply empirical SOC/SOH performance, leaderboard status, or method
dominance while the Phase 12 execution-clearance gate remains blocked.

The correct Phase 13 scope is:

- ensemble-method contracts;
- fail-closed comparison inputs;
- uncertainty and provenance checks;
- runner dry-run planning;
- filter-side ensemble adapters;
- dataset evidence compatibility;
- public documentation that labels the status as mechanical.

The incorrect scope is:

- forcing an empirical comparison on inadmissible SOC truth;
- reusing unfrozen Hinf parameters as if calibrated;
- uploading datasets without source, license, checksum, and provenance checks;
- editing thesis claims or the scientific roadmap from autonomous work.

## Workspace And Branch Snapshot

Verified before opening Phase 13:

- Real `codex exec` processes: `0` at the opening snapshot.
- BSEBench product repositories are on `main` and clean.
- Local merged branch cleanup found no extra merged non-main branches.
- `bsebench-async-codex-worker-2` was clean but behind by 89 commits; it was
  fast-forwarded to current `origin/main`.
- `/mnt/c/doctorat/these_lfp_2026` is massively dirty from pre-existing
  modifications. It is intentionally out of scope for cleanup and Phase 13
  workers must not touch it.

Current product heads:

| Repo | Head | Status |
|---|---:|---|
| `bsebench-specs` | `ce3aacf` | clean |
| `bsebench-datasets` | `9de818d` | clean |
| `bsebench-stats` | `95ddd11` | clean |
| `bsebench-filters` | `a1c9a01` | clean |
| `bsebench-runner` | `72d0c61` | clean |
| `bsebench-website` | `dde7d40` | clean |
| `bsebench-async-codex` | `c537d1d` | clean before this audit |

## Phase Coherence Check

| Phase | Current interpretation | Claim status |
|---|---|---|
| 1-5 | Historical thesis-side material, useful for context only. No current-head evidence bundle was verified. | `NO_GO_CLAIM` |
| 6 | Infrastructure foundation: loaders, stats primitives, runner plumbing. | `GO_TOOLING`, `NO_GO_CLAIM` |
| 7 | Hinf/outlier and residual tooling; claim identity still unsafe. | `GO_TOOLING`, `NO_GO_CLAIM` |
| 8 | Universal benchmark charter, estimator/metric/leakage/truth contracts. | `GO_INFRA_DIRECTION`, `NO_GO_CLAIM` |
| 9 | Profile-axis mechanical smoke on real Tier 2 evidence, not full science. | `GO_EMPIRICAL_SMOKE`, `NO_GO_CLAIM` |
| 10 | Aging/SOH mechanical smoke, one narrow ready case. | `GO_EMPIRICAL_SMOKE`, `NO_GO_CLAIM` |
| 11 | Residual diagnostics mechanics with sensitivity and imbalance blockers. | `GO_EMPIRICAL_SMOKE`, `NO_GO_CLAIM` |
| 12 | Transfer readiness closed mechanically; final execution gate blocks real execution. | `CLOSED_MECHANICAL_NO_GO` |
| 13 | Open now for ensemble-method infrastructure only. | `NO_GO_CLAIM` |

## Phase 12 Blockers Preserved

Phase 13 workers must preserve these blockers until proven otherwise:

- `transfer_execution_allowed=false`
- `estimator_execution_allowed=false`
- `soc_derivation_allowed=false`
- `parameter_use_allowed=false`
- `needs_ground_truth_metadata:240`
- `needs_capacity_evidence:72`
- missing calibration dataset manifest hash
- missing calibration split manifest hash
- missing calibration run-log hash
- missing estimator config hash

## Phase 13 Acceptance Gate

A Phase 13 task is acceptable if it does at least one of the following:

- adds executable product code with focused tests;
- creates a machine-readable contract or validation gate;
- blocks unsupported ensemble comparisons by default;
- makes member provenance, uncertainty, compute cost, split integrity, or
  artifact hashes harder to omit;
- documents public status without stronger claims than the current evidence
  supports.

A Phase 13 task is not acceptable if it only increases worker count, produces a
report with no operational use, or weakens a Phase 12 blocker.

## Launch Policy

The opening wave contains 17 tasks with disjoint owned paths across six product
repositories and async documentation. The target is high parallelism without
write collisions:

- `bsebench-specs`: 2 tasks
- `bsebench-stats`: 3 tasks
- `bsebench-runner`: 4 tasks
- `bsebench-filters`: 4 tasks
- `bsebench-datasets`: 3 tasks
- `bsebench-website`: 1 task

Each worker brief requires:

- commit subject starting with `GLASSBOX`;
- no `Co-Authored-By Claude`;
- no thesis, claim-registry, roadmap, HF upload, or dataset download work;
- focused tests and diff checks;
- fail-closed behavior on missing evidence;
- final branch push for independent review.

