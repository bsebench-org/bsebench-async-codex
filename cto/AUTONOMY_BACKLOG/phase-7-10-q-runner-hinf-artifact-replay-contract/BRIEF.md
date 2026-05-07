---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-q-runner-hinf-artifact-replay-contract
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.q - runner Hinf artifact replay contract

You are a rigorous BSEBench runner reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Harden the strict Hinf evidence bundle by making its committed artifacts self-checking before any future interpretation work.

## Roadmap mapping

- Phase 7: Hinf evidence fragility and replayability, without a claim verdict.
- Validation infrastructure: manifest replay and CI gates that block false scientific claims.

## Required behavior

- Add or extend a runner-side replay/audit command that cross-checks the Hinf artifact manifest, evidence JSON, committed output hashes, stats dependency identity, and mechanical-only guardrail fields.
- The command must read committed artifacts and must not rerun filters unless explicitly requested by a separate future evidence task.
- It must distinguish missing artifact, hash mismatch, stats SHA mismatch, missing mechanical-only flag, missing protected-claim guard, and malformed finite numeric payload.
- Output must be JSON-safe, deterministic, and suitable for CI.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this replay-contract task.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements. Any future SOTA comparison requires a source ledger with stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any committed Hinf artifact cannot be matched to its manifest hash, stats dependency identity, finite payload audit, and explicit `claim_55` non-targeting guard, the replay contract must fail and block downstream claim work.

## Validation

Run and record:

- focused tests for missing artifact, hash mismatch, stale stats SHA, non-finite payload, and missing protected-claim guard;
- the real replay/audit command against the current committed Hinf artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
