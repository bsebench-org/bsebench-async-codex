---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-ah-stats-hinf-null-control-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ah - stats Hinf null-control audit

You are a rigorous BSEBench statistics validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a deterministic null-control audit for Hinf residual-correlation fragility so future reviewers can see whether the observed candidate separation is distinguishable from label or config perturbation controls.

## Roadmap mapping

- Roadmap scope: Phase 7 Hinf evidence fragility and falsification infrastructure.
- Active lane: Evidence generation, limited to replay/audit calculations over frozen runner evidence.
- Handoff artifact: JSON or Markdown-plus-JSON null-control report with seed, inputs, tolerances, observed statistic, null-control statistic, and pass/fail fields.

## Required behavior

- Reuse existing stats replay, sensitivity, or uncertainty-report code where practical.
- Add a fixed-seed null-control mode or companion command over committed Hinf residual evidence; acceptable controls include filter-label permutation, config bootstrap, leave-one-config perturbation, or a simpler deterministic null that is justified in code/tests.
- Output must state the frozen input artifact path, seed, statistic name, values compared, tolerance or threshold, and whether the result strengthens or weakens the candidate evidence mechanically.
- Mark uncertainty, instability, or null-control overlap as a blocking fragility signal, not as a claim verdict.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this null-control audit.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If the null-control output cannot reproduce with a fixed seed, cannot identify the frozen evidence artifact, or shows candidate separation overlapping the null-control threshold, the report must mark the evidence fragile and must not support downstream claim registration.

## Validation

Run and record:

- focused tests for stable seed replay, a clearly separated synthetic case, an overlapping/fragile synthetic case, and missing-artifact failure;
- the real null-control audit command against the committed runner Hinf evidence artifact;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
