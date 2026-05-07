---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-aa-runner-hinf-replay-provenance-negative-controls
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.aa - runner Hinf replay provenance negative controls

You are a rigorous BSEBench runner reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Strengthen strict Hinf manifest replay by adding negative controls that prove provenance, hashes, and guardrail fields are actually checked.

## Roadmap mapping

- Phase 7 evidence lane: strict Hinf candidate evidence fragility and replayability.
- Phase 8/11 preparation: reusable manifest replay checks before cross-dataset or residual-decomposition evidence is scheduled.
- Active lane: evidence generation and validation infrastructure only.

## Required behavior

- Review the committed strict Hinf evidence bundle, artifact manifest, output audit, CI summary, and replay-sidecar scripts.
- Add or extend a lightweight replay/provenance checker that can be exercised with synthetic corrupted fixtures without recomputing expensive filters.
- Negative controls must cover at least hash drift, missing artifact, mismatched source commit, changed strict config identity, and guardrail fields that no longer say mechanical evidence only.
- Output must be deterministic JSON or a deterministic text summary with explicit checked values, mismatch count, tolerances when relevant, and pass/fail status.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf candidate evidence lane.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a corrupted Hinf manifest, stale hash, wrong source SHA, altered strict config list, or claim-promoting guardrail field can pass replay validation, the task must fail and record the mismatch instead of weakening the check.

## Validation

Run and record:

- focused tests for hash drift, missing artifact, source-SHA mismatch, strict-config mismatch, and forbidden guardrail wording;
- the real replay/provenance checker against committed strict Hinf artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
