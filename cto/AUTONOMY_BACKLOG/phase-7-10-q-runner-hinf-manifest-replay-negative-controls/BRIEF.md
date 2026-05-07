---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-q-runner-hinf-manifest-replay-negative-controls
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.q - runner Hinf manifest replay negative controls

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Roadmap mapping

- Phase 7: strict Hinf candidate evidence, mechanical validation only.
- Research-gate lane: manifest replay and provenance validation that blocks false scientific claims.
- Active lane: Evidence generation only.

## Goal

Add negative-control coverage for Hinf artifact manifest replay so stale, mismatched, or incomplete committed evidence cannot be treated as replayable.

## Required behavior

- Review the current Hinf output audit, artifact manifest audit, and committed strict Hinf evidence paths in `bsebench-runner`.
- Add focused tests or fixtures that mutate copied manifest/evidence inputs to simulate at least: stale stats dependency identity, missing output hash, changed evidence hash, missing replay command, and mismatched artifact path.
- The audit command must report explicit mismatch fields and fail non-zero for each negative control.
- Do not recompute filters or generate a new scientific result; fixture mutations must be synthetic or temporary test data.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf validation backlog task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any synthetic stale, missing, or mismatched manifest/evidence fixture exits zero or lacks a machine-readable mismatch reason, the task must fail and block downstream use of the manifest as claim-supporting evidence.

## Validation

Run and record:

- focused tests for each manifest/evidence negative control;
- the real manifest audit command against the committed strict Hinf evidence bundle;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
