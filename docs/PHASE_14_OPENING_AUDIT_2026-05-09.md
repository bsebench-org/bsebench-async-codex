# Phase 14 Opening Audit - 2026-05-09

## Verdict

Phase 14 may open, but only as theory/tooling infrastructure:

- `GO_PLANNING`
- `GO_SAFE_PARALLELIZATION`
- `NO_GO_EMPIRICAL_CLAIM`
- `NO_GO_THEORETICAL_CLAIM`

The target is information-theoretic SOC/SOH state-estimation bounds: a
Tichavsky/Muravchik/Nehorai-style posterior Cramer-Rao bound (PCRLB) path with
explicit model uncertainty. The current opening does not claim a new theorem,
does not claim a tight bound, and does not claim superiority over empirical
filters.

## Source Anchor

Phase 14 is anchored to the published PCRLB recursion literature:

- P. Tichavsky, C. H. Muravchik, A. Nehorai, "Posterior Cramer-Rao Bounds for
  Discrete-Time Nonlinear Filtering", IEEE Transactions on Signal Processing,
  46(5), 1386-1396, 1998. DOI: `10.1109/78.668800`.

Working interpretation for engineering tasks:

- implement finite, testable matrix recursions and preflights first;
- treat model uncertainty as an explicit input contract, not as an inferred
  scientific truth;
- distinguish conditional/oracle model-weighted bounds from a true Bayesian
  model-uncertainty PCRLB;
- use synthetic linear-Gaussian fixtures before any battery/ECM claim;
- require later mathematical review before saying "derived", "tight", or
  "novel".

Critical scientific boundary:

- A per-model Tichavsky recursion can produce conditional information matrices
  when all assumptions and matrix blocks are supplied.
- A weighted sum of per-model inverse information matrices is an oracle
  model-conditional covariance summary, not a complete Bayesian
  model-uncertainty PCRLB.
- A true Bayesian model-uncertainty bound may only be emitted if validated
  mixture/marginal information blocks are supplied by the input artifact. If
  they are missing, the report must say `preflight_blocked`.

## Current Local Baseline

Existing useful foundation:

- `bsebench-stats/src/bsebench_stats/runners/pcrlb_mad_floor_preflight.py`
  provides a neutral PCRLB/MAD floor preflight.
- The existing preflight is not a Phase 14 Bayesian PCRLB implementation. It
  checks dimensional consistency and finite arithmetic only.
- Phase 13 added no-claim infrastructure and ensemble evidence gates that can
  be reused for Phase 14 report wording.

Known blockers inherited from Phases 12-13:

- local SOC/SOH truth evidence remains blocked for real transfer runs;
- estimator parameter-freeze evidence remains blocked for transfer execution;
- Phase 13 ensemble artifacts are mechanical and claim-ineligible;
- HF uploads remain stopped.

## Phase 14 Guardrails

Forbidden until a later audited theorem/evidence gate:

- "new lower bound" as a claimed theorem;
- "proven lower bound";
- "tight bound" on battery data;
- "near-tight";
- "validated bound";
- "PCRLB-tight";
- "SOTA", "frontier", "best", "superior", or "beats";
- "novel", "first", or "breakthrough";
- "universal SOC/SOH bound";
- "empirical bound validation";
- "matches empirical observations";
- "information-theoretically optimal";
- any leaderboard or benchmark-ranking statement.

Allowed now:

- matrix contract validators;
- deterministic PCRLB recursion for supplied finite matrices;
- synthetic linear-Gaussian sanity fixtures;
- model-mixture input manifests;
- fail-closed preflights;
- no-claim report skeletons.

## Dependency DAG

Phase 14 should not launch empirical battery runs first. The correct dependency
order is:

1. Matrix and bound schema contracts.
2. Finite symmetric positive-definite / positive-semidefinite validators.
3. Linear-Gaussian PCRLB recursion with synthetic fixtures.
4. Model-uncertainty mixture contract over already supplied model weights and
   per-model information matrices.
5. Runner dry-run manifest that refuses execution without truth, split,
   parameter, and noise-evidence inputs.
6. Dataset noise-evidence gate.
7. Report and website wording that remains claim-blocked.

## Ready Parallel Work

The ready tasks are independent because they create new Phase 14 files and only
touch exports or navigation minimally:

- specs bound schema;
- stats matrix validators;
- stats linear PCRLB recursion;
- stats model-mixture preflight;
- stats bound/no-claim gate;
- runner bound plan;
- runner dry-run CLI;
- datasets noise-evidence gate;
- filters ECM linearization descriptor;
- website Phase 14 status page.

Do not merge Phase 14 work as a scientific result until every branch passes
focused tests, `ruff`, diff checks, anti-secret scan, and anti-claim scan.

## Release Gate

Phase 14 release state uses four explicit gates:

- `GO_TOOLING`: schemas, scripts, and tests pass for derivation artifacts.
- `GO_DERIVATION_REVIEW`: assumptions, notation, recursion, and counterexamples
  are independently reviewed.
- `GO_COMPARISON_PREFLIGHT`: source-ledger and comparability rows are complete
  if any empirical or prior-work comparison is mentioned.
- `NO_GO_CLAIM`: default claim state until a separate claim-registration task
  passes.

The current opening grants only `GO_PLANNING` and `GO_SAFE_PARALLELIZATION`.

## Current Status

Opened after Phase 13 closure report `a79ccf7` was committed and pushed.
No Phase 14 product branch has been merged yet.
