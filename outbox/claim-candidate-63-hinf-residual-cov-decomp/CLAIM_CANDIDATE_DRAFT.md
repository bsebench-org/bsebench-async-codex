# Claim Candidate Draft: claim_63_hinf_residual_cov_decomp

Status: draft_async_only

Actor: codex-cto-FR

UTC: 2026-05-07T04:50:00Z

## Identity Guardrail

- `candidate_id`: `claim_63`
- `candidate_name`: `hinf_residual_cov_decomp`
- `must_not_target`: `claim_55`
- `registry_edit_allowed`: false
- `thesis_prose_edit_allowed`: false
- `scientific_verdict`: none
- `mechanical_evidence_only`: true

This is not a thesis claim registration. It is an async-only staging artifact for
future CTO/human review.

Reason: the canonical thesis registry already defines `claim_55` as the
verified EnsembleMeta/MAD sensor-noise floor claim:

- `/mnt/c/doctorat/these_lfp_2026/claims/registry.yaml:307`
- `/mnt/c/doctorat/these_lfp_2026/claims/registry.yaml:308`
- `/mnt/c/doctorat/these_lfp_2026/claims/registry.yaml:309`

The latest registered claim id found by read-only scan is `claim_62`, status
`proposed`, at `/mnt/c/doctorat/these_lfp_2026/claims/registry.yaml:1783`.
Per registry rules, new claims default to `proposed`
(`/mnt/c/doctorat/these_lfp_2026/claims/registry.yaml:58-64`).

## Candidate Question

Does Hinf residual behavior form a reproducible residual-covariance /
variance-decomposition pattern distinct enough to deserve a new scoped claim,
separate from the historical sensor-noise ceiling claim?

This draft intentionally avoids stronger wording such as "verified",
"structural", "mechanism proved", or "claim_55 update".

## Evidence Anchors

Runner evidence:

- `bsebench-runner` commit:
  `d21e059a1eb3e1128959c6cc3ca7cd01b0f0b12a`
- Evidence artifact:
  `outputs/hinf_residual_evidence_5x5.json`
- Preflight artifact:
  `outputs/hinf_residual_cache_preflight.json`
- Chi2 artifact:
  `outputs/chi2_sweep_5x5.json`

Runner audit:

- `bsebench-runner` commit:
  `5885b3f6c9bebef8aa9756445b53673dbbe6c8bc`
- Audit script:
  `scripts/audit_hinf_residual_outputs.py`
- Audit result:
  preflight 5/5, chi2 25/25, evidence 25/25, finite numeric Hinf residuals,
  no-claim guardrails enforced.

Async evidence logs:

- `outbox/phase-7-7-g-runner-strict-hinf-evidence/CTO_MERGE.md`
- `outbox/phase-7-7-h-runner-hinf-output-audit/CTO_MERGE.md`
- `outbox/preflight-claim-identity-hinf/CTO_BLOCK.md`

## Mechanical Observations

From the committed evidence bundle at `d21e059`:

- strict config labels:
  - `Yao BCDC T25`
  - `Yao US06 T25`
  - `Panasonic US06 T25`
  - `NASA B0005 T24`
  - `CALCE A123 DST T25`
- strict filter labels:
  - `EnsembleMeta`
  - `EKF`
  - `UKFDef`
  - `JUKFV6B`
  - `Hinf`
- trace summary:
  - `ok_configs=5`
  - `error_configs=0`
  - `ok_filter_runs=25`
  - `error_filter_runs=0`
- covariance summary:
  - `ok_configs=5`
  - `ok_filter_traces=25`
  - `skipped_configs=0`
  - `error_configs=0`
- variance-decomposition summary:
  - `ok_configs=5`
  - `ok_filter_traces=25`
  - `skipped_configs=0`
  - `error_configs=0`

Aggregate covariance panel:

- filter order:
  `["EnsembleMeta", "EKF", "UKFDef", "JUKFV6B", "Hinf"]`
- off-diagonal finite pairs: `10/10`
- median absolute correlation: `0.1528167598682994`
- max absolute correlation: `0.8870889996288478`
- fraction below `|corr| < 0.5`: `0.9`
- Hinf correlations by filter:
  - EnsembleMeta: `0.012880056269532505`
  - EKF: `0.8870889996288478`
  - UKFDef: `0.26529211558795396`
  - JUKFV6B: `0.13619668042454816`

Variance decomposition on `log_residual_var`:

- config share: `0.6229435697547356`
- filter share: `0.315492687747909`
- residual/interaction share: `0.06156374249735543`
- Hinf mean metric: `4.368827589325181`
- Hinf mean residual variance: `2947.706896307917 mV^2`
- Hinf mean RMSE: `30.181969585103314 mV`
- EKF mean metric: `4.377963691675102`
- EKF mean residual variance: `2939.8950607914676 mV^2`
- EKF mean RMSE: `30.726541335502525 mV`
- EnsembleMeta mean metric: `-0.6766888803921187`
- EnsembleMeta mean residual variance: `1.6141835444705257 mV^2`
- EnsembleMeta mean RMSE: `0.9790026220593786 mV`

Leave-one-config-out stability:

- status: `ok`
- runs: `5`
- filter-share range: `0.2732223138562325`
- config-share range: `0.2876838486549615`
- residual/interaction-share range: `0.01728750672545007`
- Hinf effect-vs-grand-mean delta range: `0.4832024725855457`
- Hinf mean-metric delta range: `2.5805355199480213`

## Current Interpretation Boundary

The mechanical evidence does not yet justify a verified claim by itself.

Reasons:

- The Hinf residuals are low-correlation with EnsembleMeta and JUKFV6B in the
  aggregate panel, but Hinf is highly correlated with EKF (`0.887...`), so a
  blanket "Hinf is uncorrelated with L2 filters" statement is too broad.
- The five-config bundle is strict and fully successful, but it is still a
  small evidence surface designed for candidate evaluation, not final thesis
  prose.
- NASA contributes only `97` post-warmup retained samples after the strict
  truncation/warmup rules because the B0005 first discharge segment has
  `N=197`.
- The current bundle identifies covariance and variance patterns; it does not
  prove a closed-form Hinf mechanism.

## Safe Candidate Wording

Possible future claim statement, if CTO/human review decides to register it:

> On the strict five-config residual evidence panel, Hinf exhibits a distinct
> residual-covariance and residual-variance signature relative to EnsembleMeta
> and several L2-family filters, with low aggregate correlation to EnsembleMeta
> and JUKFV6B but high aggregate correlation to EKF; this supports a scoped
> Hinf residual-behavior candidate rather than a blanket uncorrelated-outlier
> claim.

Initial registry status, if added later: `proposed`.

Do not use status `verified` without an explicit registry edit task, independent
review, and thesis consistency check.

## Required Next Gates

Before any `claims/registry.yaml` edit:

1. Run `uv run --locked --all-extras python scripts/audit_hinf_residual_outputs.py`
   in `bsebench-runner` at or after commit `5885b3f`.
2. Recompute or re-verify the stats-side covariance/decomposition summaries
   from the committed bundle.
3. Decide whether the candidate is:
   - residual-covariance only,
   - variance-decomposition only,
   - or a joint covariance/decomposition scoped claim.
4. Write a minimal registry patch for `claim_63` only; do not edit `claim_55`.
5. Run thesis `tests/test_claims.py` or the current claim-registry validation
   command before committing any thesis registry edit.
6. Add a MASTER_DISCOVERIES entry only after the registry patch is accepted.

## Files To Avoid Editing In This Draft Phase

- `/mnt/c/doctorat/these_lfp_2026/claims/registry.yaml`
- `/mnt/c/doctorat/these_lfp_2026/MASTER_DISCOVERIES_MAP.md`
- `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report/docs/RESEARCH-ROADMAP-2026-05-06.md`
- `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report/docs/SOLO_OPERATION_BRIEF_2026-05-06.md`
- thesis manuscript/prose files that cite `claim_55`
