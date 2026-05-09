# Phase 15 Opening Audit - 2026-05-09

## Verdict

Phase 15 may open, but only as adaptive-filter tooling and evidence-preflight:

- `GO_PLANNING`
- `GO_SAFE_PARALLELIZATION`
- `NO_GO_EMPIRICAL_CLAIM`
- `NO_GO_GAIN_CLAIM`
- `NO_GO_NEURAL_TRAINING`

The roadmap question is whether a filter can learn online to compensate for
chemistry-specific model bias. The immediate implementation path is not a
performance claim. Phase 15 opens with contracts, synthetic fixtures, leakage
guards, dry-run plans, and paired-delta reporting gates.

## Source Anchor

Phase 15 follows the roadmap item:

- Question: can a filter learn online to compensate for chemistry-specific
  model bias?
- Method: EMA bias correction first, then residual-prediction extensions only
  behind explicit evidence gates.
- Output: later RMSE-gain measurement per adaptation, not now.

Working interpretation for engineering tasks:

- EMA adaptation may be implemented as deterministic, bounded, stateful tooling.
- Residual prediction may be represented as a contract or manifest first; no
  neural training is authorized in this opening wave.
- Any improvement metric must be paired against a frozen baseline on frozen
  splits with calibration/test separation.
- Test labels, future residuals, and evaluation windows must be inaccessible to
  the online update path.
- All generated reports remain `NO_GO_CLAIM` unless a later audited artifact
  explicitly authorizes wording.

## Current Local Baseline

Useful existing foundation:

- Phase 12 transfer-readiness and execution-clearance gates already reject
  adaptive parameters as transfer-ready evidence.
- Phase 13 no-claim and comparison gates can be reused for claim blocking.
- Phase 14 report-gate patterns can be reused for forbidden wording and
  audited-verdict authorization.
- Existing estimator submission schema records online-step capability.

Missing before any real adaptive experiment:

- adaptive method-card/schema contract;
- online-update trace contract;
- calibration/test split evidence for adaptation;
- leakage gate for residual access and future labels;
- paired baseline/adaptive metric gate;
- dry-run CLI that refuses estimator execution by default;
- synthetic EMA sanity fixture.

## Phase 15 Guardrails

Forbidden until later audited evidence:

- "RMSE gain" as a scientific result;
- ">20% improvement";
- "adaptive filter is better";
- "learns chemistry-specific bias" as a validated empirical claim;
- SOTA, best, superior, leaderboard, or benchmark-ranking wording;
- neural residual-prediction training on real traces;
- adapting on evaluation labels or future residuals;
- reusing test splits as calibration evidence;
- Hugging Face upload, dataset download, or estimator execution on real traces.

Allowed now:

- adaptive method-card and run contracts;
- EMA residual-bias correction helper for supplied synthetic residuals;
- residual-predictor manifest contract with no training;
- adaptation safety/leakage gate;
- paired-delta report gate that remains claim-ineligible;
- dry-run plan and CLI;
- dataset calibration-evidence gate;
- synthetic fixture and website status page.

## Dependency DAG

The correct dependency order is:

1. Specs adaptive contract.
2. Filter EMA and residual-predictor contracts.
3. Adaptation safety/leakage gate.
4. Runner dry-run plan and CLI.
5. Dataset calibration-evidence gate.
6. Stats paired-delta and report wording gates.
7. Synthetic sanity fixtures.
8. Website/communication and integration audit.

## Release Gate

Phase 15 release state uses four explicit gates:

- `GO_TOOLING`: contracts, helpers, dry-run CLI, and tests pass.
- `GO_LEAKAGE_REVIEW`: calibration/evaluation separation and online update
  trace are independently reviewed.
- `GO_EMPIRICAL_PREFLIGHT`: frozen splits, frozen baselines, finite metrics,
  uncertainty, and paired comparison gates are present.
- `NO_GO_CLAIM`: default claim state until a separate claim-registration task
  passes.

The current opening grants only `GO_PLANNING` and
`GO_SAFE_PARALLELIZATION`.

## Current Status

Opened after Phase 14 closure report and ledger were committed and pushed.
All product repos are clean on `main...origin/main` before Phase 15 queuing.
