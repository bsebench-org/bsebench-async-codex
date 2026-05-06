# Panel check for phase-6-11-a-chi2-smoke-yao-bcdc-t25

[role: panel-FR]
Decision audited : approved
Generated at : 2026-05-06T22:04:07Z

## Panel composition
- Mme Rim Barrak (thesis director, mandatory)
- ML/Stats expert (reasoning : CODE/TESTS phase with chi2 statistic, degrees of freedom, p-value, and smoke-test coverage)
- Adversarial reviewer (reasoning : complementary red-team pass on assumptions, gate evidence, and approval risk)

## Confidence scores (0-100, where 100 = "ship it now, no concerns")
- mme_rim : 86 — Good SHA/gate/output traceability, but source-of-truth pinning is weakened by the non-comparable paper2b 157.636 reference.
- expert2 : 84 — Synthetic test covers the formula path, but real-data chi2 assumptions, sigma choice, df, and p-value interpretation lack an independent oracle.
- expert3 : 82 — Chef approval relies mostly on summary-level evidence, and the huge chi2/p=0 result leaves risk of a silent convention or scaling mismatch.
- **AVERAGE : 84**

## Key concerns (if any)
- Paper2b 157.636 is documented as not directly comparable to the implemented residual time-series chi2, so the source-of-truth expectation remains only partially discharged.
- The smoke path is reproducible, but the real Yao BCDC T25 statistic has no independent regression oracle or sensitivity check for sigma/window/df choices.

## Verdict
NEEDS_REVIEW (avg < 89, escalate to advisor)
