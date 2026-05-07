---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-aa-runner-hinf-manifest-hash-replay
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.aa - runner Hinf manifest hash replay

You are a rigorous BSEBench runner reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a neutral replay check that verifies committed Hinf evidence files still match the artifact manifest hashes, dependency SHAs, and declared replay inputs before any downstream interpretation uses them.

## Roadmap mapping

- Active lane: evidence generation validation.
- Roadmap scope: Phase 7 Hinf candidate evidence fragility and manifest replay, with no scientific verdict.
- Handoff artifact: machine-readable replay/audit output that reports files checked, hash matches, dependency identity matches, missing inputs, and mismatch counts.

## Required behavior

- Review runner Hinf evidence outputs, artifact manifest audit code, and stats replay hooks before changing code.
- Add or extend a replay/audit command that reads committed artifacts only; it must not regenerate filters or rewrite evidence.
- The output must distinguish pass, missing artifact, hash mismatch, dependency SHA mismatch, malformed JSON, and unsupported manifest-version cases.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this manifest replay task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any required committed Hinf artifact is missing, has a hash mismatch, has a dependency SHA mismatch, or cannot be parsed as finite JSON where expected, the replay must fail and mark the evidence not ready for downstream claim work.

## Validation

Run and record:

- focused tests for pass, missing artifact, hash mismatch, dependency mismatch, malformed JSON, and unsupported manifest version;
- the real replay/audit command against committed Hinf artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
