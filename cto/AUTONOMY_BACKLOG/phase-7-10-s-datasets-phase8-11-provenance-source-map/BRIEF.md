---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-s-datasets-phase8-11-provenance-source-map
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.s - datasets Phase 8/11 provenance source map

You are a rigorous BSEBench datasets provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 8 cross-chemistry and Phase 11 residual-decomposition work with a read-only provenance source map for candidate datasets, loaders, cache roots, and split metadata.

## Active lane

Evidence generation. The handoff artifact is a dataset provenance map with explicit gaps. It is not a SOTA comparison and not claim registration.

## Required behavior

- Add or extend a read-only datasets command such as `scripts/phase8_11_provenance_source_map.py` that enumerates candidate Phase 8 and Phase 11 dataset/config families already represented in local metadata.
- For each candidate, record loader identifier, dataset family, chemistry or cell family when known, split/profile metadata, source identifier, DOI or stable source URL when available, local-cache readiness, and unavailable metadata gaps.
- The command must not download data, mutate caches, infer missing source fields from memory, or commit machine-local absolute paths as scientific evidence.
- Output JSON must be deterministic, finite, secret-safe, and clear about `ready`, `not_ready`, and `metadata_gap` statuses.
- Include strict Hinf datasets only as provenance context; do not update Hinf evidence or claim status.
- Do not edit thesis files, claim registry files, claims/registry.yaml, claim_55, docs/RESEARCH-ROADMAP-2026-05-06.md, or roadmap text.
- Do not target claim_55; claim_55 is protected and unrelated to this backlog task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a Phase 8 or Phase 11 candidate dataset cannot be mapped to a deterministic loader, source identity, split/profile metadata, and local provenance status, the map must mark it not ready and block downstream evidence scheduling for that config.

## Validation

Run and record:

- `uv run --locked --all-extras pytest tests/test_phase8_11_provenance_source_map.py -q`;
- `uv run --locked --all-extras python scripts/phase8_11_provenance_source_map.py --out /tmp/phase8_11_provenance_source_map.json`;
- focused fixtures for ready, missing-source, missing-split, cache-missing, and loader-unavailable cases;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
