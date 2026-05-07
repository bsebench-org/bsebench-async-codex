---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-ae-runner-phase11-residual-manifest-preflight
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ae - runner Phase 11 residual manifest preflight

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 11 residual-decomposition runs with a dry-run manifest preflight that verifies dataset/config identity, filter availability, residual output contract, stats dependency identity, and intended artifact paths without running filters.

## Roadmap mapping

- Active lane: evidence generation validation.
- Roadmap scope: Phase 11 sensor-noise versus model-mismatch preparation and Phase 7 residual tooling reuse, with no scientific verdict.
- Handoff artifact: deterministic JSON preflight report for scheduler or worker review before expensive residual runs.

## Required behavior

- Review runner residual trace export, strict Hinf manifest code, and stats residual-decomposition input contracts before changing code.
- Add or extend a dry-run command that resolves candidate Phase 11 configs and output contracts without generating empirical evidence.
- The preflight must distinguish loader unavailable, cache missing, filter unavailable, residual schema unknown, stats dependency unknown, and output path collision.
- Output JSON must be finite, deterministic, and suitable for CI review.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 11 preflight task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any candidate Phase 11 config cannot be mapped to deterministic loader/cache provenance, filter availability, residual schema, and stats dependency identity, the preflight must mark it not ready and block downstream scheduling.

## Validation

Run and record:

- focused tests for ready, loader missing, cache missing, filter missing, residual schema unknown, stats dependency unknown, and output collision cases;
- a real dry-run preflight over the current Phase 11 candidate set without running filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
