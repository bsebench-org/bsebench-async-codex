# Claim 63 Readiness Checklist

Status: mechanical_review_ready

Actor: codex-cto-FR

UTC: 2026-05-07T05:12:00Z

## Decision

The safest candidate scope is a joint residual-covariance and
residual-variance signature, not covariance-only and not decomposition-only.

Reason:

- covariance-only wording is easy to overstate because Hinf is highly
  correlated with EKF on the aggregate panel;
- decomposition-only wording loses the important correlation structure;
- a joint scoped statement can explicitly preserve both the low correlations
  to EnsembleMeta/JUKFV6B and the high correlation to EKF.

Initial registry status, if this is later added to the thesis registry:
`proposed`.

## Completed Gates

- Strict runner evidence bundle committed at `d21e059`.
- Runner output audit committed at `5885b3f`.
- Runner provenance lock and manifest audit committed at `cf99b71`.
- Stats replay audit committed at `7d09a20`.
- Async candidate draft committed at `6e988ae`.
- Async runner provenance log committed at `504fb72`.
- Async stats replay log committed at `1ddc79a`.
- Runner manifest audit rerun:
  - pass.
- Stats replay rerun:
  - `residual_covariance_panel: ok (584 values compared)`.
  - `residual_variance_decomposition: ok (498 values compared)`.
- Independent validators:
  - Maxwell: GO on candidate draft.
  - Pascal: GO on provenance lock.
  - Wegener: GO on stats replay.

## Allowed Wording

Use language like:

> On the strict five-config residual panel, Hinf exhibits a scoped residual
> covariance and variance-decomposition signature: it is low-correlated with
> EnsembleMeta and JUKFV6B, high-correlated with EKF, and participates in a
> panel where config effects dominate log residual variance while filter
> effects remain substantial.

This wording is still candidate/proposed wording, not a thesis-ready verified
claim.

## Banned Wording

Do not write:

- `claim_55 update`
- `verified Hinf claim`
- `Hinf is uncorrelated with all L2 filters`
- `Hinf is a structural outlier`
- `mechanism proved`
- `closed-form mechanism proof`
- `registry verified`

## Still Required Before Thesis Registry

1. Decide final wording with explicit candidate scope.
2. Patch only `claim_63`, never `claim_55`.
3. Run thesis claim registry validation.
4. Keep initial status `proposed` unless a separate verification task is
   explicitly assigned.
5. Add `MASTER_DISCOVERIES_MAP.md` only after the registry patch is accepted.

## Files To Avoid

- `/mnt/c/doctorat/these_lfp_2026/claims/registry.yaml`
- `/mnt/c/doctorat/these_lfp_2026/MASTER_DISCOVERIES_MAP.md`
- thesis manuscript/prose files citing `claim_55`
- async roadmap files
