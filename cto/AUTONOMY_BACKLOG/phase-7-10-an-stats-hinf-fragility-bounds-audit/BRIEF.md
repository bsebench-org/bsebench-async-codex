---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-an-stats-hinf-fragility-bounds-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.an - stats Hinf fragility bounds audit

You are a rigorous BSEBench statistics validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make the Hinf fragility threshold calibration auditable as bounds, not as a scientific conclusion, so future workers can see when the candidate evidence is brittle.

## Active lane

Evidence generation: read-only statistics validation over frozen runner evidence and existing Hinf sensitivity outputs. The handoff artifact is a JSON audit with threshold names, bound values, observed deltas, materiality flags, and blocking reasons.

## Required behavior

- Inspect the existing Hinf threshold calibration, null-control audit, sensitivity, and stats replay scripts.
- Add or extend a stats command that audits fragility bounds against frozen Hinf residual evidence and sensitivity sidecars without recomputing filters.
- The output must include exact threshold identifiers, configured tolerances, observed maximum absolute/relative deltas, leave-source or leave-config labels when available, mismatch counts, and `claim_55_targeted=false`.
- The command must describe fragile evidence as `mechanical evidence only` and must not assert that a Hinf mechanism is verified, rejected, novel, or SOTA.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf fragility bounds audit.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements. A SOTA claim requires a source ledger with stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any fragility threshold is missing, non-finite, undocumented, looser than the calibration contract, or if the audit changes an interpretation under leave-source/leave-config removal, the task must fail and mark downstream claim work blocked.

## Validation

Run and record:

- `uv run --locked --all-extras pytest tests/test_hinf_fragility_bounds_audit.py -q`;
- the real read-only fragility bounds audit against current frozen Hinf evidence and sidecars;
- `uv run --locked --all-extras pytest tests/ -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
