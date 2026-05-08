---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-z-autonomy-backlog-replenishment-20260508T132015Z
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.z - autonomy backlog replenishment

You are a rigorous BSEBench CTO planning engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Restore the curated autonomy reserve to at least six useful future tasks under `cto/AUTONOMY_BACKLOG/`, without changing the scientific roadmap.

## Required behavior

- Read `docs/CTO-48H-AUTONOMY-PLAN-2026-05-07.md`, `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`, `docs/RESEARCH-ROADMAP-2026-05-06.md`, and the latest `HISTORY.md` entries.
- Add at least six new `cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md` entries that are roadmap-mapped, falsifiable, and scoped to runner/stats/datasets/async validation work.
- Each BRIEF must include validation, a falsification gate, no thesis or claim registry edits, and no unsupported SOTA or novelty claims.
- Each BRIEF must explicitly forbid targeting `claim_55`.
- Prefer tasks that validate Hinf evidence fragility, manifest replay, dataset provenance, source-ledger comparability, CI gates, or Phase 8/11 preflight tooling.
- Do not edit thesis files, `claims/registry.yaml`, claim registry files, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; it is protected and unrelated to this backlog replenishment.
- Do not make SOTA claims without a source ledger, stable URL or DOI, retrieval date, and comparability table.

## Falsification gate

If the new backlog tasks cannot state a concrete failure condition or validation command, this task must fail and explain why in the outbox summary.

## Validation

Run and record:

- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh`;
- `git diff --check`;
- a reserve count command proving at least six unqueued backlog BRIEFs remain.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
