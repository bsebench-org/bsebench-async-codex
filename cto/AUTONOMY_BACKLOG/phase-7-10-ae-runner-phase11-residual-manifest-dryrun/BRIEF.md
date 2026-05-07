---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-ae-runner-phase11-residual-manifest-dryrun
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ae - runner Phase 11 residual manifest dry-run

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 11 sensor-noise versus model-mismatch decomposition with a dry-run residual manifest contract before expensive residual traces are scheduled.

## Roadmap mapping

- Phase 11 preparation: residual decomposition requires deterministic dataset, model, filter, sensor channel, and stats dependency identity.
- Validation infrastructure lane: fail before expensive evidence generation when provenance or dimensions are incomplete.
- Active lane: preflight validation only.

## Required behavior

- Add or extend a dry-run command that resolves candidate Phase 11 configs into intended residual-trace manifest rows without running filters.
- Each row must report dataset/config identifier, loader availability, local-cache readiness, voltage/current channel identity, sample cadence availability, filter set, stats dependency identity, intended output path, and provenance gaps.
- Output JSON must be finite, deterministic, and explicit about `ready`, `cache_missing`, `loader_missing`, `metadata_incomplete`, `dimension_unknown`, and `stats_unknown`.
- Do not generate empirical evidence, download data, mutate caches, or commit machine-local absolute paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 11 residual manifest preflight.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a Phase 11 candidate row cannot prove deterministic loader identity, cache/provenance source, channel dimensions, filter set, and stats dependency identity, the dry-run must mark it not ready and block downstream residual-trace scheduling.

## Validation

Run and record:

- focused tests for ready, cache-missing, loader-missing, metadata-incomplete, dimension-unknown, and stats-unknown cases;
- one real dry-run manifest command over the current candidate config set without running filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
