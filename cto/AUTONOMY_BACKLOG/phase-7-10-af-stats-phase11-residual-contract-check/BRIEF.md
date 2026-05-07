---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-af-stats-phase11-residual-contract-check
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.af - stats Phase 11 residual contract check

You are a rigorous BSEBench statistics validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Define and test the machine-readable contract that Phase 11 residual decomposition inputs must satisfy before stats tooling computes sensor-noise versus model-mismatch summaries.

## Active lane

Evidence generation and validation infrastructure only. The handoff artifact is an input/output contract checker for residual-decomposition payloads; it is not a Phase 11 scientific result.

## Required behavior

- Read the existing residual covariance, residual decomposition, Hinf stats replay, and PCRLB/MAD preflight tooling.
- Add or extend a contract checker that validates required fields, dataset/config identity, filter identity, residual vector finiteness, sample counts, units, split/profile metadata, and provenance references.
- The checker must emit explicit pass/fail fields, mismatch counts, and gap reasons that downstream workers can consume.
- Do not compute or claim a sensor-noise/model-mismatch fraction from real data unless the task only validates a committed fixture and labels it mechanical.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to Phase 11 residual contract validation.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If malformed residual payloads with missing provenance, inconsistent sample counts, non-finite residuals, unknown units, or missing split metadata can pass the contract checker, the task must fail and block Phase 11 decomposition scheduling.

## Validation

Run and record:

- focused tests for valid payload, missing provenance, inconsistent sample counts, non-finite residuals, unknown units, missing split metadata, and empty residual vectors;
- a contract check against any committed Hinf residual fixture or a clearly synthetic fixture;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
