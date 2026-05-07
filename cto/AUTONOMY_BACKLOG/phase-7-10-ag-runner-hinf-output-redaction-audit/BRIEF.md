---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-ag-runner-hinf-output-redaction-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 75
---

# Phase 7.10.ag - runner Hinf output redaction audit

You are a rigorous BSEBench runner evidence-audit engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make committed strict Hinf evidence artifacts safer to replay and share by adding a read-only audit for local path leaks, token-like values, missing manifest links, and non-deterministic metadata.

## Roadmap mapping

- Roadmap scope: Phase 7 Hinf evidence fragility and validation infrastructure.
- Active lane: Evidence generation, limited to audit tooling over already committed artifacts.
- Handoff artifact: deterministic audit output that names inspected runner files and machine-readable failure counts.

## Required behavior

- Inspect existing runner Hinf outputs, including the residual evidence, cache preflight, candidate report, sensitivity sidecar, and artifact manifest when present.
- Add or extend a read-only audit command that fails on unredacted absolute local paths, token-like values, missing artifact-manifest links, non-finite JSON values, or ambiguous provenance fields.
- The audit must report inspected artifact paths, exact rule IDs, failure counts, and pass/fail status without recomputing expensive filters.
- Do not generate new empirical evidence or rewrite existing Hinf output values to make the audit pass.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf output-redaction audit.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any committed Hinf artifact contains an unredacted local absolute path, token-like value, missing manifest pointer, non-finite value, or unknown provenance field that the audit marks as passing, the task must fail and block downstream claim work.

## Validation

Run and record:

- focused tests for clean artifacts, local path leaks, token-like values, missing manifest links, and non-finite JSON;
- the real read-only audit command over the committed runner Hinf artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
