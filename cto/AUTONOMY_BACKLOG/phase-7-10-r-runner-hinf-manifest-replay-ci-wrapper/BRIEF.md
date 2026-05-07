---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-r-runner-hinf-manifest-replay-ci-wrapper
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.r - runner Hinf manifest replay CI wrapper

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a CI-safe wrapper that audits the strict Hinf evidence manifest, output hashes, and stats replay identity without rerunning expensive filters.

## Roadmap mapping

- Phase 7: strict Hinf candidate evidence must remain replayable and self-auditing.
- Validation infrastructure: manifest replay and CI gates that block stale or corrupted evidence.
- Async reliability: workers and chef need one command that fails loudly on drift.

## Active lane

Evidence generation, validation infrastructure only. The handoff artifact is a replay/audit JSON or log that says exactly which manifest fields, hashes, commands, and dependency identities were checked.

## Required behavior

- Reuse existing manifest and Hinf output audit scripts where possible instead of duplicating artifact parsing.
- The wrapper must not run filters or regenerate evidence; it should read committed artifacts only.
- The wrapper must report manifest path, evidence path, stats replay command, values compared, mismatch count, and pass/fail status.
- Add a negative test that corrupts a temporary copy of at least one hash, dependency SHA, or compared value and proves the wrapper fails.
- No thesis or claim registry edits are permitted.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this manifest replay task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if the wrapper can pass after a manifest hash, stats dependency identity, evidence value, or output path is corrupted, or if the wrapper silently reruns filters instead of auditing frozen artifacts.

## Validation

Run and record:

- focused tests for clean manifest replay, corrupted hash, corrupted stats dependency identity, and corrupted compared value;
- the real CI-safe manifest replay wrapper over committed strict Hinf artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
