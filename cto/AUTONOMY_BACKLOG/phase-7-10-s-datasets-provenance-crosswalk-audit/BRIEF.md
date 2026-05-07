---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-s-datasets-provenance-crosswalk-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.s - datasets provenance crosswalk audit

You are a rigorous BSEBench dataset provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Create a read-only provenance crosswalk that maps strict Hinf, Phase 8, and Phase 11 candidate dataset identifiers to loader metadata, local-cache readiness, and source identity gaps.

## Roadmap map

- Phase 7 evidence validation: strict Hinf evidence must cite deterministic dataset provenance.
- Phase 8/11 preparation: cross-chemistry and residual-decomposition runs need comparable provenance before expensive scheduling.

## Required behavior

- Add or extend a datasets-side report that maps each candidate config to loader family, dataset variant, local-cache root status, required-file presence, source identity fields, and loader-readiness status.
- The report must be read-only, finite JSON, and must not print secrets, tokens, or machine-local absolute paths as scientific evidence.
- Distinguish cache missing, source identity missing, loader unavailable, metadata incomplete, and loader probe failure.
- Include synthetic tests for complete provenance and each gap class.
- Do not download data, mutate local caches, or infer missing provenance from filenames alone.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this provenance crosswalk audit.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a candidate config cannot be mapped to deterministic loader metadata and source identity, or if a loader probe fails despite apparent file coverage, the crosswalk must mark that config not ready and block downstream evidence scheduling.

## Validation

Run and record:

- focused tests for complete, cache-missing, source-missing, loader-missing, metadata-incomplete, and probe-failure cases;
- a real read-only crosswalk over currently known strict Hinf and Phase 8/11 candidate configs;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
