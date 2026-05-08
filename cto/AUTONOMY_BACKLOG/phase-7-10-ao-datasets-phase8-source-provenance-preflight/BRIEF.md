---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-ao-datasets-phase8-source-provenance-preflight
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ao - datasets Phase 8 source provenance preflight

You are a rigorous BSEBench dataset provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a Phase 8 preflight that verifies cross-chemistry dataset source identity before PCRLB/MAD or BMA-ceiling evidence is scheduled.

## Active lane

Evidence generation: dataset provenance preflight only. The handoff artifact is a JSON provenance report that names dataset source identity, local cache status, split/profile labels, source URL or DOI fields when available, and explicit comparability gaps.

## Required behavior

- Inspect existing dataset catalog, Audit J local cache manifest, Hinf loader provenance audit, and Phase 8 candidate dataset references.
- Add or extend a read-only command that reports source identity for candidate Phase 8 datasets, including dataset variant, chemistry, profile/split, source URL or DOI if known, retrieval or cache observation date when available, local cache readiness, and hash availability.
- The output must distinguish `ready`, `missing_source_identity`, `missing_cache`, `partial_metadata`, and `not_comparable_yet` per dataset/config.
- Treat missing source details as gaps; do not infer DOI, split, preprocessing, or comparability from memory.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8 source provenance preflight.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements. A SOTA claim requires a source ledger with stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any Phase 8 candidate dataset lacks source identity, split/profile metadata, chemistry label, local cache readiness, or a stable URL/DOI field needed for later comparison, the preflight must fail or mark that dataset `not_comparable_yet`.

## Validation

Run and record:

- `uv run --locked --all-extras pytest tests/test_phase8_source_provenance_preflight.py -q`;
- the real read-only Phase 8 source provenance preflight over the current candidate dataset list;
- `uv run --locked --all-extras pytest tests/ -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
