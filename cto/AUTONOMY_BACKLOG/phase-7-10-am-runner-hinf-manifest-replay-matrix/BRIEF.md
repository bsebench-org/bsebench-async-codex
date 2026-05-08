---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-am-runner-hinf-manifest-replay-matrix
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.am - runner Hinf manifest replay matrix

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a read-only replay matrix that shows which committed strict Hinf artifacts can be independently replayed, audited, or only hash-checked before any downstream claim work.

## Active lane

Evidence generation: validation infrastructure over frozen runner artifacts. The handoff artifact is a machine-readable replay matrix with artifact paths, hashes, replay command identity, comparison counts, mismatch counts, and blocking gaps.

## Required behavior

- Inspect `outputs/hinf_residual_artifact_manifest.json`, committed Hinf residual outputs, existing audit scripts, and stats replay commands.
- Add or extend a runner command that emits JSON rows for every strict Hinf artifact: artifact hash status, expected replay/audit command, dependency identity, values compared, mismatch count, tolerance fields, and `claim_55_targeted=false`.
- The matrix must distinguish `replayed`, `hash_only`, `blocked`, and `not_applicable` without regenerating filters or writing new empirical evidence outputs.
- Any unavailable replay metadata must be recorded as an explicit gap, not inferred from memory or local machine state.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf manifest replay matrix.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements. A SOTA claim requires a source ledger with stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any manifest artifact is missing, hash-drifted, lacks a replay/audit command, reports a non-zero mismatch count, or cannot state why it is `hash_only` or `blocked`, the task must fail and mark the artifact not claim-ready.

## Validation

Run and record:

- `uv run --locked --all-extras pytest tests/test_hinf_manifest_replay_matrix.py -q`;
- the real read-only replay matrix command against the current committed strict Hinf manifest;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
