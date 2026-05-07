---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-s-datasets-provenance-hash-replay-fixtures
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.s - datasets provenance hash replay fixtures

You are a rigorous BSEBench datasets provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make dataset provenance replay falsifiable by adding fixtures or checks that catch stale hashes, missing source metadata, and loader/provenance mismatches for strict Hinf and Phase 8/11 preparation datasets.

## Roadmap mapping

- Active lane: evidence generation validation.
- Supports Phase 7 strict evidence provenance and Phase 8/11 dataset readiness.
- Produces provenance tooling and synthetic fixtures only; it does not change the scientific roadmap.

## Required behavior

- Review Audit J split metadata, dataset manifests, local-cache manifest tooling, and Hinf loader provenance audit behavior.
- Add synthetic fixtures or tests for matching provenance, stale file hash, missing stable source URL/DOI, missing retrieval date, loader-id mismatch, cache-root missing, and unreadable local file.
- Output must distinguish unavailable metadata from inferred metadata and must not print token values or secrets.
- The real command, if run against local cache roots, must be read-only and must not download data.
- Do not commit machine-local absolute paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this dataset provenance replay validation.
- Do not make SOTA, novelty, leaderboard, breakthrough, verified-claim, or claim-promotion statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if a stale hash, missing stable source identity, missing retrieval date, loader mismatch, missing cache root, or unreadable local file is reported as provenance-ready.

## Validation

Run and record:

- focused tests for valid provenance and each negative fixture class;
- the read-only provenance replay or audit command against available local roots, with unavailable local metadata marked as a gap;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
