---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-q-runner-hinf-artifact-hash-replay
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.q - runner Hinf artifact hash replay

You are a rigorous BSEBench runner reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make the committed strict Hinf artifact manifest independently replayable at the hash and dependency-identity layer before any downstream interpretation task consumes it.

## Roadmap map

- Phase 7 evidence infrastructure: strict Hinf candidate artifacts must remain replayable and falsifiable.
- Phase 8/11 preflight support: manifest identity checks should be reusable before cross-dataset and residual-decomposition runs.

## Required behavior

- Add or extend a runner-side audit command that reads the committed Hinf artifact manifest and verifies referenced artifact hashes, dependency SHAs, manifest schema version, and output availability without recomputing filters.
- The command must report the artifact read, values compared, mismatch count, unavailable metadata, and pass/fail status in finite JSON.
- Include synthetic fixtures for a clean manifest, a tampered artifact hash, a missing artifact, and an unknown stats dependency identity.
- Treat unavailable metadata as a gap, not as inferred provenance.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf manifest replay work.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any referenced artifact hash differs from the manifest, any required artifact is missing, or the stats dependency identity cannot be resolved to the manifest value, the replay audit must fail and mark the Hinf evidence bundle not ready for downstream claim work.

## Validation

Run and record:

- focused tests for clean, hash-mismatch, missing-artifact, malformed-manifest, and unknown-dependency cases;
- a real read-only replay audit against the committed strict Hinf manifest without running filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
