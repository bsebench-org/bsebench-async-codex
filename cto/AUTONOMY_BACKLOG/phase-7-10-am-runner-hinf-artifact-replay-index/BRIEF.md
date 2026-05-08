---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-am-runner-hinf-artifact-replay-index
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.am - runner Hinf artifact replay index

You are a rigorous BSEBench runner reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make every committed strict Hinf artifact point to an explicit replay or audit path before downstream claim work can consume it.

## Roadmap mapping

- Roadmap scope: Phase 7 Hinf evidence fragility and validation infrastructure.
- Active lane: Evidence generation, limited to read-only replay-index tooling over frozen artifacts.
- Handoff artifact: deterministic JSON/Markdown replay index with artifact hashes, producer command identity, replay/audit command identity, dependency SHAs, tolerance fields, and explicit gaps.

## Required behavior

- Inspect the committed runner Hinf evidence, candidate report, sensitivity sidecar, cache preflight, and artifact manifest when present.
- Add or extend a read-only command that indexes each artifact, expected hash, producer command, replay or audit command, stats dependency identity, source manifest pointer, and tolerance contract.
- The index must distinguish `replay_ready`, `audit_only`, `missing_replay`, `hash_mismatch`, `unknown_dependency`, and `insufficient_metadata`.
- Do not regenerate filters, mutate evidence values, download data, or convert the index into a scientific Hinf verdict.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf artifact replay-index task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any committed Hinf artifact lacks a stable hash, source manifest pointer, dependency identity, replay/audit command, or tolerance contract but is marked `replay_ready`, the task must fail and mark the artifact not claim-ready.

## Validation

Run and record:

- focused tests for replay-ready artifacts, audit-only artifacts, missing replay commands, hash mismatches, unknown dependencies, and missing tolerance fields;
- the real read-only replay-index command against the current committed runner Hinf artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
