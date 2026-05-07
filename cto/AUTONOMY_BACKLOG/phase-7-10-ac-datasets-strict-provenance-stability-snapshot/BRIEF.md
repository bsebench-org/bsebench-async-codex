---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-ac-datasets-strict-provenance-stability-snapshot
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ac - datasets strict provenance stability snapshot

You are a rigorous BSEBench datasets provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make strict Hinf and near-future Phase 8/11 dataset provenance snapshots stable enough that workers can tell cache identity drift from real loader-readiness changes.

## Active lane

Evidence generation and validation infrastructure only. The handoff artifact is a deterministic provenance stability snapshot and focused tests; it is not a scientific comparison.

## Required behavior

- Read the Hinf loader provenance audit, Audit J local-cache manifest, split metadata, and current dataset loader identifiers.
- Add or extend a read-only snapshot command that records dataset identifier, split/profile, loader name, required files, cache-root availability class, metadata gaps, and stable hashes when practical.
- The snapshot must distinguish local path availability from source identity; unavailable metadata must be reported as a gap, not inferred.
- Do not download data, mutate local caches, print secrets, or commit machine-local absolute paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to dataset provenance snapshot validation.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If two runs over the same frozen metadata produce different dataset identities, hide missing source metadata, or treat local cache presence as proof of provenance, the task must fail and mark the snapshot not claim-supporting.

## Validation

Run and record:

- focused tests for stable metadata, missing source identity, unreadable cache root, and local-path redaction;
- the real read-only provenance snapshot over strict Hinf and candidate Phase 8/11 datasets;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
