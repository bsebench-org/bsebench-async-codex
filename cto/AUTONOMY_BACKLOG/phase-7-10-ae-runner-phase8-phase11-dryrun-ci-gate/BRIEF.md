---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-ae-runner-phase8-phase11-dryrun-ci-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ae - runner Phase 8/11 dry-run CI gate

You are a rigorous BSEBench runner CI validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Turn Phase 8 cross-chemistry and Phase 11 residual-decomposition dry-run manifest checks into a CI-suitable gate before expensive filter jobs are queued.

## Active lane

Evidence generation and validation infrastructure only. The handoff artifact is a dry-run readiness report and CI check, not empirical Phase 8 or Phase 11 evidence.

## Required behavior

- Read current runner Hinf manifests, dry-run/preflight commands, dataset cache readiness metadata, stats dependency identity handling, and CI workflow conventions.
- Add or extend a dry-run command or CI step that checks candidate config IDs, loader availability, cache/provenance readiness, filter availability, stats dependency identity, and intended output paths without running filters.
- The report must distinguish loader unavailable, cache missing, provenance incomplete, filter unavailable, stats dependency unknown, and output path collision.
- Do not generate new empirical evidence, run expensive filters as part of the gate, or commit local-machine paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to Phase 8/11 dry-run CI validation.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If the dry-run gate cannot block a candidate config with missing loader, missing cache/provenance, unknown stats dependency, missing filter, or output collision, the task must fail and leave expensive scheduling blocked.

## Validation

Run and record:

- focused tests for ready, loader-missing, cache-missing, provenance-incomplete, filter-missing, stats-unknown, and output-collision cases;
- the real dry-run gate over the current Phase 8/11 candidate config set without running filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
