---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-9-10-11-d-phase10-aging-soh-stats-handshake
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 9/10/11.d - Phase 10 aging/SOH stats handshake

You are a rigorous BSEBench stats validation engineer. You are not alone in this
codebase; do not revert or overwrite unrelated edits.

## Goal

Turn the Phase 10 missing-verdict-input blocker into a stats handoff preflight
that accepts only frozen, provenance-backed aging/SOH evidence rows.

## Local evidence to consume

- Current stats aging invariance contract and aging/SOH preflight utilities.
- Current runner aging/SOH predispatch budget output if locally available.
- Current datasets aging/SOH readiness output if locally available.
- Async Phase 9/10/11 DAG, completion audit, and final synthesis.

## Required behavior

- Add or extend a stats-side preflight that validates Phase 10 verdict inputs
  without calculating a scientific verdict.
- Require stable schema version, dataset/config identity, split/protocol,
  target signal, metric/unit/direction, runner artifact identity, commit SHA,
  replay/generation command, provenance/cache status, and source-ledger status.
- Output `ready_for_stats=false` unless every required field is present and
  finite where numeric.
- Distinguish `missing_runner_artifact`, `missing_dataset_readiness`,
  `missing_source_identity`, `missing_source_ledger`, `schema_mismatch`,
  `split_unknown`, `metric_unknown`, and `non_finite_value`.
- Do not generate new empirical results, upload artifacts, download data, run
  Hugging Face upload or download commands, or browse for external sources.
- Do not edit thesis files, roadmap files, claim registry files,
  `claims/registry.yaml`, or `claim_55`.
- Do not make comparison, leaderboard, novelty, breakthrough, or
  verified-claim statements.

## Dependencies

This task can run immediately as a handoff validator. Missing runner, datasets,
or source-ledger artifacts must be represented as blocking statuses, not inferred
inputs.

## Falsification gate

If a Phase 10 stats handoff with missing artifact identity, source/provenance,
split, metric, schema, replay command, or non-finite value can be marked ready,
the task must fail.

## Acceptance checks

- The handoff report has one row per candidate evidence artifact or an explicit
  `no_candidate_artifacts` row.
- No row with missing source-ledger or provenance status is accepted for verdict
  work.
- The report can be consumed later by a separate verdict task without re-running
  empirical jobs.

## Validation

Run and record:

- focused tests for complete handoff, missing runner artifact, missing dataset
  readiness, missing source identity, missing source ledger, schema mismatch,
  unknown split, unknown metric, and non-finite values;
- one real local preflight over current Phase 10 candidate artifacts or an
  explicit no-candidate state;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with a subject starting `GLASSBOX`. Do not add co-author trailers.
