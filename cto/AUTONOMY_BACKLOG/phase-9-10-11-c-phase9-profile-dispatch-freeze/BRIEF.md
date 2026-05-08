---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-9-10-11-c-phase9-profile-dispatch-freeze
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 9/10/11.c - Phase 9 profile dispatch freeze

You are a rigorous BSEBench runner dispatch engineer. You are not alone in this
codebase; do not revert or overwrite unrelated edits.

## Goal

Turn the Phase 9 missing-empirical-artifact blocker into a dry-run dispatch
freeze that states exactly which profile-axis runs could be scheduled, which are
blocked, and why.

## Local evidence to consume

- Current runner Phase 9 profile-axis inventory, planner, dispatch budget, and
  run-manifest utilities.
- Current stats profile comparability contract if locally available.
- Current datasets provenance/cache closure output if locally available.
- Async Phase 9/10/11 DAG and completion audit.

## Required behavior

- Add or extend a dry-run command that freezes the intended Phase 9 profile-axis
  empirical matrix without running filters.
- Include dataset/config/profile/temperature/chemistry/split identity, stats
  contract identity, cache/provenance status, expected artifact paths, and
  blocking reasons.
- Output phase-level `dispatch_ready=false` unless profile inventory, stats
  comparability, source/provenance/cache readiness, output path uniqueness, and
  validation command identity are all present.
- Do not generate empirical outputs, upload artifacts, download data, run
  Hugging Face upload or download commands, or mutate caches.
- Do not edit thesis files, roadmap files, claim registry files,
  `claims/registry.yaml`, or `claim_55`.
- Do not make comparison, leaderboard, novelty, breakthrough, or
  verified-claim statements.

## Dependencies

This task can run immediately as a freeze. It must not require dependency
success to produce a useful artifact; missing dependencies become explicit
`blocked_missing_*` reasons.

## Falsification gate

If an empty, all-skipped, source-incomplete, cache-incomplete,
stats-unknown, output-colliding, or provenance-incomplete Phase 9 matrix can be
marked dispatch-ready, the task must fail.

## Acceptance checks

- The freeze report includes summary counts for ready, skipped, missing cache,
  missing provenance, missing source identity, stats contract missing, and output
  collision.
- Every candidate has a deterministic intended output path or an explicit
  blocker.
- No empirical run command is executed by this task.
- Phase 9 remains NO-GO unless the report has `dispatch_ready=true` and names
  the exact artifacts that support it.

## Validation

Run and record:

- focused tests for ready matrix, empty matrix, all-skipped matrix, missing
  cache, missing provenance, missing source identity, missing stats contract, and
  output collision;
- one real dry-run freeze over the current Phase 9 profile candidate matrix;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with a subject starting `GLASSBOX`. Do not add co-author trailers.
