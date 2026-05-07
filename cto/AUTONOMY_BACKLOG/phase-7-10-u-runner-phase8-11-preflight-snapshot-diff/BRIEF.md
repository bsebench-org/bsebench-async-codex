---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-u-runner-phase8-11-preflight-snapshot-diff
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.u - runner Phase 8/11 preflight snapshot diff

You are a rigorous BSEBench runner preflight engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a deterministic snapshot-diff preflight for Phase 8 cross-chemistry and Phase 11 residual-decomposition candidate matrices before expensive filter runs are scheduled.

## Roadmap mapping

- Phase 8: cross-chemistry config coverage must be known before PCRLB/MAD or BMA-ceiling runs.
- Phase 11: residual-decomposition inputs need deterministic dataset/filter/config identity.
- Validation infrastructure: dry-run matrix changes should be visible before worker time is spent.

## Active lane

Evidence generation, validation infrastructure only. The handoff artifact is a dry-run snapshot and diff report for candidate dataset/config/filter matrices; it is not empirical filter evidence.

## Required behavior

- Build or extend a no-filter dry-run command that emits a deterministic JSON snapshot of candidate dataset/config/filter entries, cache readiness, stats dependency identity, and intended output artifact names.
- Add a diff mode that compares two snapshots and reports added, removed, changed, and unchanged entries.
- The command must fail loudly on all-skipped matrices, duplicate identifiers, unknown loaders, unknown filters, or missing stats dependency identity.
- Do not commit local-machine cache paths as scientific evidence; redact, normalize, or hash diagnostics when needed.
- No thesis or claim registry edits are permitted.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8/11 preflight.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if two identical dry runs produce different snapshots, if an all-skipped matrix exits successfully, if unknown loader/filter/stats identities are counted as ready, or if snapshot diff hides a changed candidate entry.

## Validation

Run and record:

- focused tests for deterministic snapshots, added/removed/changed diff rows, all-skipped failure, unknown loader, unknown filter, and stats-identity-missing failure;
- a real no-filter snapshot over the current Phase 8/11 candidate set;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
