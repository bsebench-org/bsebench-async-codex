# Phase phase-13-17-website-phase13-page-20260509T134830Z direct-worker summary

- Direct pid: `3042320`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-website`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-website-glassbox-phase13-17-website-phase13-page-20260509T134830Z`
- Target branch: `glassbox-phase13-17-website-phase13-page-20260509T134830Z`
- Branch SHA: `8595a07ba448eed38c418e6cb3a658cfbcd67963`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:06:24.197991Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+  and any member weights.
+- Dataset identity, split identity, leakage controls, and truth provenance from
+  the existing Phase 12 gates.
+- Frozen parameter and weight evidence whenever parameters or weights affect the
+  reported output.
+- Content hashes for dataset, configuration, run, metric, preflight, and
+  scheduling artifacts wherever those artifacts participate in a claim path.
+- Finite metric values and finite uncertainty metadata for every compared
+  metric.
+- A scientific verdict that remains `NO_GO_CLAIM` until an empirical protocol
+  explicitly authorizes a stronger claim.
+
+## Failure policy
+
+The readiness chain is fail-closed:
+
+- Missing member evidence blocks comparison.
+- Missing aggregation metadata blocks comparison.
+- Missing split, leakage, or truth provenance blocks comparison.
+- Missing frozen parameter or weight evidence blocks comparison.
+- Missing artifact hashes blocks promotion beyond mechanical readiness.
+- Missing, non-finite, or interval-inconsistent metrics block comparison.
+- Any wording that ranks methods, claims frontier performance, or promotes SOC,
+  SOH, transfer, robustness, or compute performance is rejected unless a later
+  empirical gate explicitly authorizes it.
+
+## Phase 13 outputs
+
+The current Phase 13 implementation surface is limited to repository-level
+mechanical plumbing:
+
+- `bsebench-stats`: an ensemble comparison contract that validates method
+  identity, member provenance, aggregation metadata, finite metrics, and
+  uncertainty metadata before returning metric values.
+- `bsebench-runner`: compute-profile payload helpers for per-step runtime and
+  Python allocation evidence. These profiles are process-level instrumentation,
+  not hardware peak-memory or efficiency claims.
+- `bsebench-filters`: an `EnsembleMeta` adapter surface for the existing filter
+  wrapper stack.
+- `bsebench-datasets`: Phase 12 dataset, split, truth, provenance, and upload
+  gates that still block ensemble comparisons when required evidence is absent.
+
+## What remains
+
+Before BSEBench can publish ensemble-method conclusions, the project still
+needs:
+
+- Public schemas for method cards and ensemble-run manifests, with exported
+  JSON Schema artifacts.
+- Real Tier 2 canonical Parquet datasets with verified licenses, checksums,
+  split manifests, and SOC/SOH truth provenance.
+- Frozen estimator parameters, frozen ensemble weights, and immutable run
+  manifests.
+- A preregistered empirical protocol for ensemble comparisons, including
+  acceptance thresholds and uncertainty reporting.
+- Independent audit of leakage, split integrity, provenance hashes, and
+  parameter-freezing.
+- Reproducible empirical runs with statistical summaries.
+
+Until those checks pass, public wording should say **mechanical readiness**,
+**comparison contract**, or **blocked-by-default ensemble plumbing**, not
+benchmark superiority.

tokens used
89,515
Implemented and pushed commit `8595a07`:

`GLASSBOX [role: phase13-website-status] add phase 13 ensemble status page`

Changes:
- Added [phase13-ensemble-methods.md](/mnt/c/doctorat/bsebench-org/bsebench-website-glassbox-phase13-17-website-phase13-page-20260509T134830Z/src/content/docs/phase13-ensemble-methods.md:1) with explicit `NO_GO_CLAIM`, fail-closed evidence rules, Phase 12 blocker preservation, and mechanical-only ensemble readiness wording.
- Linked it from the Reference sidebar in [astro.config.mjs](/mnt/c/doctorat/bsebench-org/bsebench-website-glassbox-phase13-17-website-phase13-page-20260509T134830Z/astro.config.mjs:49).

Validation:
- `npm ci` passed.
- `npm run build` passed and generated `/phase13-ensemble-methods/`.
- `git diff --check` passed.
- No dedicated test script/path exists in this website scope, so no additional focused tests were run.

Pushed to `origin/glassbox-phase13-17-website-phase13-page-20260509T134830Z`.
```
