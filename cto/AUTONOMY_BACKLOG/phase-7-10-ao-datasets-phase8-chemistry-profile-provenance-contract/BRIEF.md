---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-ao-datasets-phase8-chemistry-profile-provenance-contract
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ao - datasets Phase 8 chemistry/profile provenance contract

You are a rigorous BSEBench datasets provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 8 cross-chemistry and Phase 11 residual-decomposition runs by making dataset chemistry, profile, cell, split, local-cache, and source identity explicit before runner jobs consume those configs.

## Roadmap mapping

- Phase 8: cross-chemistry extension requires chemistry/profile/source identity before comparison.
- Phase 11: residual decomposition requires provenance for every dataset contributing residual evidence.
- Validation infrastructure: dataset provenance and preflight gates, no scientific verdict.

## Active lane

Evidence generation: provenance contract tooling only. The handoff artifact is a deterministic provenance inventory or validator output with explicit gaps for missing metadata.

## Required behavior

- Add or extend a datasets-side provenance contract for candidate Phase 8/11 loaders/configs.
- Record chemistry family, cell or unit identifier, profile or drive-cycle identifier, temperature or condition when available, split/run identity, source URL or DOI when known, retrieval date when known, local-cache root policy, and source comparability caveat.
- Mark unknown source identity, missing profile metadata, ambiguous split, or local-cache-only provenance as gaps rather than inferred facts.
- Include negative fixtures for missing chemistry, missing profile, missing source URL/DOI, missing retrieval date, and ambiguous split.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8/11 provenance task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any Phase 8 or Phase 11 candidate dataset can be marked ready while chemistry, profile, split, source identity, retrieval date, or cache provenance is unknown, the contract must fail and block downstream scheduling.

## Validation

Run and record:

- focused tests for complete provenance, missing chemistry, missing profile, missing source URL/DOI, missing retrieval date, ambiguous split, and local-cache-only gap handling;
- a real read-only inventory over the current candidate Phase 8/11 dataset/config set;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
