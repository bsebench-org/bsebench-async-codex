---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-ak-runner-phase8-phase11-predispatch-budget
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ak - runner Phase 8/11 pre-dispatch budget

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prevent expensive Phase 8 and Phase 11 runs from being scheduled with empty, all-skipped, or provenance-incomplete matrices by adding a dry-run pre-dispatch budget report.

## Roadmap mapping

- Roadmap scope: Phase 8 cross-chemistry preparation, Phase 11 residual-decomposition preparation, and validation infrastructure.
- Active lane: Evidence generation, limited to dry-run scheduling and manifest validation.
- Handoff artifact: deterministic budget report with config count, filter count, expected run count, cache/provenance readiness, skip/error reasons, and output paths.

## Required behavior

- Reuse existing runner preflight, cache readiness, manifest, and stats dependency checks where practical.
- Add or extend a dry-run command that computes intended Phase 8/11 config/filter matrices, expected artifact paths, local-cache readiness, provenance status, and estimated worker budget without running filters.
- The command must fail or mark not-ready when the matrix is empty, all configs are skipped, a required loader is unavailable, stats dependency identity is unknown, or output paths collide.
- Output JSON must include explicit counts for `ready`, `skipped`, `missing_cache`, `missing_provenance`, `loader_error`, and `output_collision`.
- Do not generate empirical evidence, download data, or commit local-machine absolute paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8/11 pre-dispatch budget.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If an empty, all-skipped, output-colliding, cache-missing, provenance-missing, or stats-unknown Phase 8/11 matrix can be marked dispatch-ready, the task must fail and block downstream scheduling.

## Validation

Run and record:

- focused tests for ready matrix, empty matrix, all-skipped matrix, missing cache, missing provenance, stats-unknown, and output-collision cases;
- one real dry-run budget command over the current Phase 8/11 candidate matrix without running filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
