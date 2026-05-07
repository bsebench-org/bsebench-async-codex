---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-s-datasets-phase8-provenance-crosswalk
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.s - datasets Phase 8 provenance crosswalk

You are a rigorous BSEBench dataset-provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 8 cross-chemistry validation by mapping candidate dataset loaders to explicit provenance fields before expensive runs are scheduled.

## Roadmap mapping

- Phase 8: cross-chemistry extension depends on comparable dataset identity, split, chemistry, profile, and cache provenance.
- Validation infrastructure: dataset provenance that blocks false cross-dataset comparisons.

## Required behavior

- Add or extend a read-only provenance crosswalk for Phase 8 candidate loaders/configs.
- The crosswalk must include dataset identifier, chemistry or cell family when known, profile or split identifier, local-cache readiness status, source/citation field availability, and loader-readiness status.
- Unknown provenance must be marked as a gap, not inferred from filenames or memory.
- Do not download data, mutate local caches, or commit machine-local absolute paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8 provenance crosswalk.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements. Any future SOTA comparison requires a source ledger with stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a Phase 8 candidate loader lacks deterministic dataset identity, split/profile metadata, or provenance source fields, the crosswalk must mark that candidate not comparable and block downstream cross-chemistry scheduling.

## Validation

Run and record:

- focused tests for complete provenance, missing source field, missing split/profile metadata, unavailable cache, and loader-readiness failure;
- the read-only crosswalk command against the current candidate loader set;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
