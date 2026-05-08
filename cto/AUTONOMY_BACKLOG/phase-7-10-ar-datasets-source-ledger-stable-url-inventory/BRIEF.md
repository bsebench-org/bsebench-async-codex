---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-ar-datasets-source-ledger-stable-url-inventory
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ar - datasets source-ledger stable URL inventory

You are a rigorous BSEBench datasets source-ledger engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Create a datasets-side source inventory that records stable URLs or DOIs, retrieval dates, dataset variants, splits, and comparability caveats for loaders used by Phase 7/8/11 validation work, without making SOTA claims.

## Roadmap mapping

- Phase 7: Hinf evidence cannot support claims if dataset source identity is unknown.
- Phase 8/11: cross-chemistry and residual-decomposition comparisons need source-ledger completeness before external comparison.
- Validation infrastructure: source-ledger comparability and provenance readiness.

## Active lane

Evidence generation: source/provenance inventory only. The handoff artifact is a machine-readable inventory with explicit comparability gaps; it does not interpret external performance numbers.

## Required behavior

- Add or extend a datasets-side inventory command for Phase 7/8/11 loader sources.
- Record source identifier, title/name, stable URL or DOI, retrieval date, dataset variant, split/protocol, chemistry/profile labels when available, license/access caveat when known, and comparability caveat.
- Mark missing URLs, missing retrieval dates, missing split/protocol, or private/cache-only sources as gaps.
- Do not add external performance values or compare BSEBench to literature in this task.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this datasets source-ledger inventory.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any Phase 7/8/11 loader source is marked comparable or ready while stable URL/DOI, retrieval date, dataset variant, split/protocol, or comparability caveat is missing, the inventory must fail and report a source-ledger gap.

## Validation

Run and record:

- focused tests for complete source rows, missing stable URL/DOI, missing retrieval date, missing split/protocol, private/cache-only source, and no-performance-comparison enforcement;
- a real read-only source inventory over current Phase 7/8/11 loader sources;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
