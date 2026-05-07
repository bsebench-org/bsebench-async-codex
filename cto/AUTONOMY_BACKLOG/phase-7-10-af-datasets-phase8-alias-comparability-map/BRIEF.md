---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-af-datasets-phase8-alias-comparability-map
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.af - datasets Phase 8 alias comparability map

You are a rigorous BSEBench datasets comparability engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 8 cross-chemistry work with a dataset/config alias map that links internal loader identifiers to source-ledger comparison keys without asserting any external benchmark result.

## Roadmap mapping

- Active lane: validation infrastructure.
- Roadmap scope: Phase 8 cross-chemistry preparation, source-ledger comparability, and dataset provenance hygiene.
- Handoff artifact: finite JSON or Markdown-plus-JSON alias map with dataset, chemistry, cell/profile, split/protocol fields, and comparability caveats.

## Required behavior

- Review datasets metadata, runner config identifiers, and the research gate protocol before changing code.
- Add or extend a read-only alias/comparability map for Phase 8 candidate datasets; use existing metadata only and mark missing fields as gaps.
- Required map fields must include internal dataset id, loader id, chemistry when known, cell/profile or protocol, split or run condition when known, source-ledger key, and comparability caveat.
- Do not invent external literature numbers or source identities; this task prepares keys and caveats only.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8 comparability map task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a Phase 8 candidate dataset lacks chemistry, profile/protocol, split/run condition, or a clear comparability caveat, the map must mark that row partial or not comparable rather than comparable.

## Validation

Run and record:

- focused tests for comparable, partial, not-comparable, missing-chemistry, missing-split, and alias-collision rows;
- the read-only real map command over current Phase 8 candidate metadata;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
