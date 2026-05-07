---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-b-runner-hinf-determinism-ci-summary
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.b - runner Hinf determinism CI summary

You are a rigorous BSEBench runner engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make strict Hinf output determinism auditable in CI without recomputing expensive filters.

## Required behavior

- Add a lightweight deterministic summary or checker for committed Hinf evidence, manifests, and audit outputs.
- The checker must fail loud on non-finite JSON values, missing manifest links, hash drift, or inconsistent status fields.
- Prefer a command that can run quickly in CI and locally.
- Do not regenerate the expensive Hinf evidence unless a local fast fixture is already available.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not make SOTA, novelty, or verified-claim statements without a source ledger and comparability table.

## Falsification gate

If two committed artifacts disagree on hashes, counts, strict config identity, or claim guardrail fields, the checker must fail and explain the mismatch.

## Validation

Run and record:

- focused tests for hash drift and missing-manifest negative cases;
- the real checker against committed Hinf artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
