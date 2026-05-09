# Phase 16 Claim-Family Review Matrix

Generated: 2026-05-09 21:30 CEST

Purpose: central adversarial review matrix for BSEBench near-claims.

This document is intentionally conservative. It does not upgrade any claim. It
defines what must be proven before any later claim can move beyond
`NO_GO_CLAIM`.

## Verdict States

Allowed final states:

- `CLAIM_READY`
- `MECHANICAL_ONLY`
- `EVIDENCE_GAP`
- `AUTH_OR_DATA_BLOCKED`
- `RETRACT_OR_SCOPE`

Default state:

```text
EVIDENCE_GAP
```

## Review Matrix

| Claim family | Current Phase 16 state | Main blocker | Required next evidence |
| --- | --- | --- | --- |
| Hinf outlier / claim_55 | `EVIDENCE_GAP` | current-head replay evidence not consolidated here | source ledger, exact replay, current artifacts, stats verdict |
| BMA/PCRLB ceiling / claim_59 | `EVIDENCE_GAP` | no current complete cross-dataset replay bundle | PCRLB/MAD artifacts, replay commands, hashes, claim wording gate |
| Profile-axis stress / claim_60 | `MECHANICAL_ONLY` | Phase 9 is bounded smoke, not full profile matrix | full profile-axis matrix, cache/provenance hashes, stats report |
| Aging/SOH behavior | `MECHANICAL_ONLY` | Phase 10 is narrow NASA B0005 diagnostic smoke | multi-cell/multi-SoH evidence, split integrity, stats gate |
| Residual decomposition | `MECHANICAL_ONLY` | Phase 11 residual evidence is mechanical | scientific decomposition protocol, uncertainty, sensitivity |
| Cross-chemistry transfer | `AUTH_OR_DATA_BLOCKED` | Phase 12 execution clearance blocked | SOC truth evidence, parameter freeze, transfer replay matrix |
| Ensemble methods | `MECHANICAL_ONLY` | Phase 13 added infrastructure only | empirical ensemble runs, compute profiles, comparison gate |
| Information bounds | `MECHANICAL_ONLY` | Phase 14 synthetic/theory preflight only | proof artifact or audited empirical-bound protocol |
| Adaptive learning | `MECHANICAL_ONLY` | Phase 15 preflight only | frozen adaptive protocol, real-trace run, held-out stats gate |
| Dataset registry/HF publication | `AUTH_OR_DATA_BLOCKED` | license/provenance/upload eligibility not consolidated | source-ledger completeness, redistribution decision, auth audit |

## Adversarial Reviewer Questions

Each claim family must answer:

1. What exact artifact proves the statement?
2. What command recreates the artifact from current `main` heads?
3. What dataset source, license, and cache hash support it?
4. What split prevents leakage or tuning contamination?
5. What parameter or protocol was frozen before evaluation?
6. What independent stats gate accepts the wording?
7. What would falsify the claim?
8. What narrower scoped statement is still true if the broad claim fails?

## Claim-Ready Checklist

A claim can become `CLAIM_READY` only when every item is present:

| Requirement | Required |
| --- | --- |
| Source ledger | yes |
| Dataset provenance | yes |
| License/access status | yes |
| Local cache or fetch path | yes |
| Split integrity | yes |
| Frozen protocol or parameters | yes |
| Runner artifact | yes |
| Stats artifact | yes |
| Report artifact | yes |
| Artifact hashes | yes |
| Exact replay command | yes |
| Independent claim wording gate | yes |

If any item is missing, the claim must remain `EVIDENCE_GAP`,
`MECHANICAL_ONLY`, `AUTH_OR_DATA_BLOCKED`, or `RETRACT_OR_SCOPE`.

## Current Phase 16 Decision

No claim is ready today.

The correct Phase 16 work is to build gates that make that statement
machine-checkable and hard to bypass.

