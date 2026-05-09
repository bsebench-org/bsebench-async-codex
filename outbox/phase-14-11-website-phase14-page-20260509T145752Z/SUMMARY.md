# phase-14-11-website-phase14-page-20260509T145752Z direct-worker summary

- Direct pid: `3060311`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-website`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-website-glassbox-phase14-11-website-phase14-page-20260509T145752Z`
- Target branch: `glassbox-phase14-11-website-phase14-page-20260509T145752Z`
- Branch SHA: `31591ba3df2f3a9fa0c5be459c24850ba8dedd64`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T15:07:28.997636Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+- Bound formulation, implementation identity, versioned source, numerical
+  tolerances, and unit conventions.
+- Covariance or information matrix dimensions, labels, units, finite values,
+  symmetry policy, and definiteness policy.
+- Comparison labels, MAD values, PCRLB values, and matching units when using
+  the current PCRLB/MAD floor preflight surface.
+- Content hashes for dataset, configuration, run, metric, preflight, and bound
+  artifacts wherever those artifacts participate in a claim path.
+- A scientific verdict that remains `NO_GO_CLAIM` until an empirical protocol
+  and independent audit explicitly authorize a stronger claim.
+
+## Failure policy
+
+The readiness chain is fail-closed:
+
+- Missing dataset, split, truth, model, parameter, or artifact provenance blocks
+  comparison.
+- Missing comparison labels, units, MAD values, or PCRLB values blocks the
+  current floor preflight.
+- Non-finite MAD or PCRLB values block the current floor preflight.
+- Negative MAD values or non-positive PCRLB values block the current floor
+  preflight.
+- Dimension mismatches between labels, MAD values, PCRLB values, covariance
+  matrices, information matrices, or state labels block comparison.
+- Invalid covariance or information matrices block comparison.
+- Unsupported claim wording, including theorem, tight-bound, estimator
+  superiority, SOC/SOH performance, transfer, leaderboard, or universal-validity
+  language, is rejected unless a later empirical gate explicitly authorizes it.
+
+## Phase 14 outputs
+
+The current Phase 14 implementation surface is limited to repository-level
+preflight plumbing:
+
+- `bsebench-stats`: a neutral PCRLB/MAD floor preflight that validates a small
+  synthetic-testable payload, computes finite arithmetic deltas and ratios, and
+  assigns no scientific verdict.
+- `bsebench-runner`: residual input contract checks that require PCRLB/MAD
+  floor metadata when a residual component declares that dependency.
+
+No Phase 14 website page, runner, or stats helper currently authorizes estimator
+execution, real-data evaluation, dataset upload, Hugging Face publication, or
+scientific promotion beyond **NO_GO_CLAIM**.
+
+## What remains
+
+Before BSEBench can publish information-bound conclusions, the project still
+needs:
+
+- Public schemas for bound inputs, covariance matrices, information matrices,
+  and comparison reports.
+- Synthetic fixtures that exercise missing evidence, non-finite values,
+  dimension mismatches, invalid matrices, and unsupported verdicts.
+- Real Tier 2 canonical Parquet datasets with verified licenses, checksums,
+  split manifests, and SOC/SOH truth provenance.
+- Frozen measurement models, process models, estimator parameters, and immutable
+  run manifests.
+- A preregistered empirical protocol for any information-bound comparison,
+  including numerical tolerances and uncertainty reporting.
+- Independent audit of model assumptions, leakage controls, provenance hashes,
+  matrix validation, and parameter-freezing.
+- Reproducible empirical runs with statistical summaries.
+
+Until those checks pass, public wording should say **theory preflight**,
+**tooling preflight**, or **blocked-by-default information-bound plumbing**, not
+benchmark superiority or SOC/SOH performance.

tokens used
140,445
Implemented and pushed `31591ba3df2f3a9fa0c5be459c24850ba8dedd64` to `glassbox-phase14-11-website-phase14-page-20260509T145752Z`.

Changed:
- Added [phase14-information-bounds.md](/mnt/c/doctorat/bsebench-org/bsebench-website-glassbox-phase14-11-website-phase14-page-20260509T145752Z/src/content/docs/phase14-information-bounds.md) with explicit `NO_GO_CLAIM`, theory/tooling-only scope, and fail-closed policy.
- Added the page to the Starlight sidebar in [astro.config.mjs](/mnt/c/doctorat/bsebench-org/bsebench-website-glassbox-phase14-11-website-phase14-page-20260509T145752Z/astro.config.mjs:50).

Validation:
- `npm ci`
- `npm run build` passed and generated `/phase14-information-bounds/`
- `git diff --check` passed
- No broader check script exists in `package.json`; no tests added because this is docs-only with no owned test path.
```
