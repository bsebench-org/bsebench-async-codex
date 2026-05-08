# Monthly Benchmark Snapshot Template

> TEMPLATE - copy this file for each public monthly community benchmark
> snapshot. Fill only fields backed by inspected evidence. Leave unknowns as
> `not inspected`, `not available`, or `not comparable`; do not infer missing
> results.

## Objective

Create a source-led monthly snapshot for BSEBench community benchmark results
across SOC/SOH estimators, filters, ECM variants, observers, AI estimators, and
hybrid methods.

The snapshot must help readers compare methods by evidence quality and use
case, not by unsupported SOTA, novelty, leaderboard, breakthrough, or universal
winner claims.

## Inputs Inspected

Use this section to list only artifacts actually inspected for this snapshot.

| Input type | Local path or branch ref | Commit/cache identity | Inspection status | Notes |
| --- | --- | --- | --- | --- |
| Benchmark runner | `<path>` | `<commit>` | `not inspected` | `<notes>` |
| Dataset manifest/card | `<path>` | `<commit or cache id>` | `not inspected` | `<notes>` |
| Method adapter | `<path>` | `<commit>` | `not inspected` | `<notes>` |
| Protocol definition | `<path>` | `<commit>` | `not inspected` | `<notes>` |
| Metrics output | `<path>` | `<commit or run id>` | `not inspected` | `<notes>` |
| Compute log | `<path>` | `<run id>` | `not inspected` | `<notes>` |
| Validation log | `<path>` | `<run id>` | `not inspected` | `<notes>` |

## Snapshot Scope

- Snapshot month: `<YYYY-MM>`
- Prepared at: `<ISO-8601 timestamp>`
- Prepared by: `<role or maintainer>`
- Repository branch/ref: `<branch or commit>`
- Included methods: `<method ids, or not available>`
- Included datasets: `<dataset ids, or not available>`
- Included chemistries: `<LFP/NMC/NCA/Si-C/other, or not available>`
- Included profiles: `<dynamic/rest/low-excitation/other, or not available>`
- Included temperature range: `<range, or not available>`
- Included aging/SOH range: `<range, or not available>`
- Excluded evidence: `<artifact ids and reason, or none inspected>`

## Decisions

Record snapshot-level choices before presenting results.

| Decision | Value | Rationale | Evidence |
| --- | --- | --- | --- |
| Public comparability level | `not assigned` | `<why comparable or not>` | `<path/ref>` |
| Primary grouping axis | `not assigned` | `<chemistry/profile/SOH/etc.>` | `<path/ref>` |
| Missing-data policy | `not assigned` | `<how unknowns are displayed>` | `<path/ref>` |
| Invalid-run policy | `not assigned` | `<how failed or invalid runs are shown>` | `<path/ref>` |
| Tie/ordering policy | `not assigned` | `<avoid unsupported winner claims>` | `<path/ref>` |

## Metrics Summary

Report accuracy only for runs with auditable ground truth and compatible split
metadata.

| Method | Dataset | Split/protocol | SOC RMSE | SOC MAE | SOC MAXE | SOH metric | Per-cell/profile coverage | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `<method>` | `<dataset>` | `<protocol>` | `not available` | `not available` | `not available` | `not available` | `not available` | `not evaluated` |

Required notes:

- State metric units and normalization.
- State whether aggregates are means, medians, quantiles, or worst cases.
- Include per-cell and per-profile distributions when available.
- Mark results as `not comparable` when split, target, or protocol differs.

## Robustness Summary

Use this section for stress behavior, not for broad reliability claims.

| Method | Degraded initialization recovery | Gaussian noise | Non-Gaussian noise | ECM parameter drift | Invalid output handling | Evidence status |
| --- | --- | --- | --- | --- | --- | --- |
| `<method>` | `not available` | `not available` | `not available` | `not available` | `not available` | `not evaluated` |

Required notes:

- State the wrong-initial-SOC policy if used.
- State convergence threshold and recovery-time definition.
- State noise distribution, magnitude, random seed policy, and repetitions.
- State drift model and whether parameters were estimated, fixed, or perturbed.
- Record NaN, out-of-range, divergence, timeout, and reset behavior.

## Compute Summary

Report deployability evidence without assuming hardware equivalence.

| Method | Runtime per step | Total runtime | Peak memory | Operation count/FLOPs | Hardware/runtime environment | Status |
| --- | --- | --- | --- | --- | --- | --- |
| `<method>` | `not available` | `not available` | `not available` | `not available` | `not available` | `not measured` |

Required notes:

- Include CPU/GPU/accelerator model when inspected.
- Include Python/package/container/runtime versions when inspected.
- Separate warm-up, data loading, model loading, calibration, and inference
  time where available.
- Mark compute values as `not comparable` when hardware or measurement policy
  differs.

## Generalization Matrix

Use this matrix to show coverage across operating domains. Do not infer
generalization from a single narrow result.

| Method | Train/calibration domain | Evaluation domain | Chemistry transfer | Profile transfer | Temperature transfer | Aging/SOH transfer | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `<method>` | `not available` | `not available` | `not available` | `not available` | `not available` | `not available` | `not evaluated` |

Required notes:

- Distinguish calibration, tuning, training, validation, and blind evaluation
  data.
- State whether any target-domain information was used before evaluation.
- Mark leakage risk explicitly when split evidence is incomplete.

## Provenance Ledger

Every public number should trace back to a local artifact, branch ref, commit,
or cache identity.

| Artifact | Path/ref | Identity | Producer | Date | Verification |
| --- | --- | --- | --- | --- | --- |
| `<artifact>` | `<path/ref>` | `<commit/cache/run id>` | `<role/tool>` | `<date>` | `not verified` |

Required notes:

- Include dataset raw-source identity when available.
- Include harmonization/cache identity for processed data.
- Include estimator adapter commit and protocol commit.
- Include metric script version and validation command output path.
- Include any manual exclusions with reason and reviewer.

## Caveats And Non-Claims

This snapshot must include caveats even when all visible checks pass.

- No SOTA, novelty, breakthrough, or universal-winner claim is made by this
  snapshot.
- A result is comparable only within the explicitly stated dataset, split,
  protocol, metric, and compute environment.
- Missing robustness, compute, generalization, or provenance fields mean the
  evidence was absent or not inspected, not that the method failed.
- Public tables may group methods by available evidence, but unsupported rank
  claims must be removed before release.
- Any leakage, missing ground-truth audit, or incompatible split metadata must
  be surfaced near the affected result.

## Validation Checklist

Complete before release.

- [ ] All filled values cite inspected local artifacts or branch refs.
- [ ] Dataset provenance and cache identities are recorded where results appear.
- [ ] Calibration, tuning, validation, and evaluation splits are separated or
      marked incomplete.
- [ ] RMSE, MAE, MAXE, and any SOH metrics have units and aggregation policy.
- [ ] Robustness settings include degraded initialization, noise, drift, and
      invalid-output policy where reported.
- [ ] Compute measurements include hardware/runtime context or are marked not
      comparable.
- [ ] Generalization claims are limited to observed transfer axes.
- [ ] Caveats are present beside incomplete or non-comparable evidence.
- [ ] No unsupported SOTA, novelty, leaderboard, breakthrough, or universal
      winner language remains.
- [ ] `git diff --check` passes for the snapshot commit.

## Residual Risks

Record risks that remain after validation.

| Risk | Affected result/section | Severity | Mitigation or next check |
| --- | --- | --- | --- |
| `<risk>` | `<section>` | `not assigned` | `<next check>` |

Suggested residual-risk categories:

- incomplete ground-truth audit;
- incomplete split/leakage evidence;
- missing per-cell or per-profile distributions;
- incompatible compute environments;
- missing robustness repetitions or seed policy;
- narrow chemistry/profile/temperature/SOH coverage;
- manual exclusion not independently reviewed.

## Next Concrete Task

Name exactly one next action that would make the next monthly snapshot more
auditable or more useful.

- Task: `<one concrete task>`
- Owner: `<role or person>`
- Target artifact: `<path/ref>`
- Acceptance check: `<command, review, or artifact expected>`

## Template Authoring Record

- Objective: provide a monthly community benchmark snapshot template covering
  metrics, robustness, compute, generalization, provenance, caveats, validation,
  residual risks, and a next task.
- Inputs inspected:
  - `templates/merge-validate-template.md`
  - `templates/freelance-dev-template.md`
  - `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
  - `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`
  - `README.md`
  - branch ref `phase-8-11-f-monthly-snapshot-template-20260508T075340+0200`
- Decisions:
  - Create a new file under the owned `templates/monthly-snapshot/` scope.
  - Use placeholders instead of example numbers to avoid invented results.
  - Use evidence-status and caveat fields throughout the template.
  - Avoid unsupported SOTA, novelty, leaderboard, breakthrough, and
    universal-winner language.
- Validation checklist:
  - [x] ASCII-only content checked.
  - [x] Markdown link/path references are local and inspected.
  - [x] `git diff --check` passes.
- Residual risks:
  - This template does not validate actual benchmark data.
  - Future snapshots still need project-specific schema checks when those
    become available.
- Next concrete task:
  - Add a lightweight schema or lint check for completed monthly snapshots once
    the first real snapshot artifact exists.
