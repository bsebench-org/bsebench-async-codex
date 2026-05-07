---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-s-datasets-strict-evidence-provenance-hash-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.s - datasets strict evidence provenance hash audit

You are a rigorous BSEBench dataset provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Roadmap mapping

- Phase 7: strict Hinf evidence provenance validation.
- Phase 8/11 preparation: reusable dataset identity checks before cross-dataset and residual-decomposition work.
- Active lane: Evidence generation only.

## Goal

Add a read-only provenance hash audit for strict evidence dataset cache entries so future runner manifests can distinguish known local inputs from inferred or unknown inputs.

## Required behavior

- Review existing local-cache root resolution, Audit J cache manifests, and loader provenance utilities in `bsebench-datasets`.
- Add a read-only audit command or helper that emits dataset/config identifier, local cache root status, selected file hashes when practical, loader identity, and explicit provenance gaps.
- The audit must never download data and must not commit local-machine absolute paths as scientific evidence.
- Unknown metadata must be represented as a gap, not inferred from filename memory.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this dataset provenance backlog task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a strict evidence dataset/config cannot be mapped to deterministic loader identity plus either file hashes or explicit provenance-gap fields, the audit must mark that config not ready and fail any strict-evidence readiness summary.

## Validation

Run and record:

- focused tests for ready, missing-cache, hash-unavailable, metadata-gap, and loader-unknown cases;
- a real read-only audit over the current strict evidence config list;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
