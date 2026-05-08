---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-as-runner-hinf-manifest-replay-negative-control
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.as - runner Hinf manifest replay negative control

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a negative-control replay path for the strict Hinf artifact manifest so manifest drift cannot be hidden by a zero-exit audit.

## Active lane

Evidence generation: validation infrastructure only. The handoff artifact is a manifest replay audit that proves known-bad manifest mutations fail before any downstream Hinf candidate interpretation.

## Required behavior

- Review the committed Hinf artifact manifest, replay/audit scripts, and strict evidence output contracts.
- Add or extend a testable runner command or test fixture that mutates one manifest field at a time, such as artifact hash, stats dependency identity, evidence path, or command line, and confirms the replay audit reports a concrete mismatch.
- The output must distinguish checked artifact, compared field, expected value, observed value, mismatch count, tolerance when numeric, and pass/fail status.
- Keep wording neutral: mechanical evidence only, no claim verdict and no Hinf scientific conclusion.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this manifest replay negative control.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any deliberately corrupted manifest row can pass replay with zero mismatches, or if the audit omits the compared field and mismatch count, this task must fail and block downstream evidence-card promotion.

## Validation

Run and record:

- focused tests for hash mismatch, stats dependency mismatch, evidence path mismatch, and command-line mismatch cases;
- the real manifest replay audit against the committed strict Hinf manifest without regenerating filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
