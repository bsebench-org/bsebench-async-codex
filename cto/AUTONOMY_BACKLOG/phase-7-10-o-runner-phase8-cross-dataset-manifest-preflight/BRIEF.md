---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-o-runner-phase8-cross-dataset-manifest-preflight
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.o - runner Phase 8 cross-dataset manifest preflight

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 8 cross-chemistry and Phase 11 residual-decomposition runs with a dry-run manifest preflight before expensive filters are scheduled.

## Required behavior

- Add or extend a dry-run command that resolves candidate dataset/config/filter identifiers, local-cache readiness, stats dependency identity, and intended output paths without running filters.
- The preflight must distinguish loader unavailable, cache missing, metadata incomplete, filter unavailable, and stats dependency unknown.
- Output JSON must be finite, deterministic, and suitable for CI or worker pre-dispatch review.
- Do not generate new empirical evidence or commit local-machine paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8/11 preflight.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a Phase 8 or Phase 11 candidate config cannot be mapped to a deterministic loader, cache/provenance source, filter set, and stats dependency identity, the preflight must mark it not ready and block downstream expensive scheduling.

## Validation

Run and record:

- focused tests for ready, loader-missing, cache-missing, metadata-incomplete, filter-missing, and stats-unknown cases;
- a real dry-run preflight over the current candidate config set without running filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
