---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-r-runner-hinf-manifest-replay-receipt
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.r - runner Hinf manifest replay receipt

You are a rigorous BSEBench runner reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a machine-readable replay receipt that ties the committed strict Hinf evidence, manifest audit, output audit, determinism audit, candidate report, and CI summary to exact artifact hashes without recomputing filters.

## Active lane

Evidence generation. The receipt is an audit artifact only and must not become a scientific verdict.

## Required behavior

- Review the existing runner audit scripts for Hinf outputs, manifest drift, determinism, CI summary, sensitivity sidecar, and candidate report.
- Add or extend a deterministic command that emits a JSON receipt with command lines, artifact paths, SHA256 hashes, source commit fields, guardrail fields, audit status, and failure reasons.
- The command must fail loud when any referenced audit cannot be run, any artifact hash differs from the manifest, any guardrail stops saying mechanical evidence only, or any source commit identity is missing.
- Do not rerun filters or change committed evidence values.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf manifest replay receipt.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If the receipt can be produced while any audit command is missing, any artifact hash has drifted, any guardrail field permits claim language, or any source commit identity is unknown, the task must fail and mark the Hinf evidence bundle not replay-ready.

## Validation

Run and record:

- focused tests for complete receipt, missing audit command, hash drift, missing source SHA, and forbidden guardrail wording;
- the real receipt command against committed runner Hinf artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
