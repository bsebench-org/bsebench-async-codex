---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-9-e-async-submission-validation-template
base_branch: main
hard_wallclock_min: 45
---

# Phase 9.e - async submission validation template

You are a rigorous public-benchmark operations engineer. You are not alone in
this codebase; do not revert or overwrite unrelated edits.

## Objective

Add a contributor submission template and validation checklist for universal
SOC/SOH benchmark methods so future estimators, filters, ECM observers, and AI
observers can declare interfaces, training inputs, calibration data, and caveats
before evaluation.

## Inputs Inspected

This queue-pack author inspected:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`
- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`
- `cto/AUTONOMY_BACKLOG/README.md`
- `scripts/check-research-brief-gates.sh`

Before editing, inspect the target repository and record the actual files read.

## Decisions

- Active lane: evidence generation. Produce operational template and validation
  checklist only.
- Owned write scope in the target repo: async submission template, checklist,
  and any focused template validation fixture under async docs/templates only.
- Do not edit runner code, dataset code, stats code, thesis files, manuscript
  files, roadmap files, claim registry files, `claims/registry.yaml`, or
  `claim_55`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim
  statements without a completed source ledger, stable URL or DOI, retrieval
  date, metric, dataset, split, BSEBench frozen value, and comparability caveat.

## Required Behavior

- Add a submission template that asks for method family, estimator interface,
  training data, calibration data, evaluation exclusions, required hardware or
  runtime metadata, SOC/SOH outputs, and known invalid regimes.
- Add a validation checklist that distinguishes required fields from optional
  fields and blocks missing leakage declarations.
- Include explicit wording that submitted values are candidates until evaluated
  by committed benchmark protocols and source-ledger checks where comparisons
  are made.
- Keep public release language caveated and free of ranking, SOTA, novelty, or
  verified-claim wording.

## Falsification Gate

The task must fail if a submission can be marked ready while omitting training
data, calibration data, evaluation exclusions, estimator interface, output
state, leakage declaration, or caveat fields.

## Validation Checklist

- Run any existing markdown or shell checks that cover the changed async files.
- If no focused checker exists, run a lightweight grep or script-based check
  proving required template fields are present.
- Run `bash scripts/check-research-brief-gates.sh --dry-run` if the changed
  files include any BRIEF paths.
- Run `git diff --check`.
- Record changed files and exact validation command results in the worker
  summary.

## Residual Risks

- A template alone does not enforce runner behavior. Later tasks should connect
  accepted submissions to estimator-contract and leakage-gate tests.
- The template may need revision after the first external method adapter is
  trialed.

## Next Concrete Task

After this merges, queue a template linter or intake smoke test that rejects a
submission missing leakage declarations or estimator interface fields.
