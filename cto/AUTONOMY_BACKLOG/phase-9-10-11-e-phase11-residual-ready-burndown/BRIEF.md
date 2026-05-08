---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-9-10-11-e-phase11-residual-ready-burndown
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 9/10/11.e - Phase 11 residual ready burndown

You are a rigorous BSEBench runner residual-readiness engineer. You are not alone
in this codebase; do not revert or overwrite unrelated edits.

## Goal

Turn the Phase 11 `ready=0/5` residual blocker into a deterministic burndown
report that lists the exact missing fields and dependency artifacts for each
candidate config before residual trace generation can be scheduled.

## Local evidence to consume

- Merged runner Phase 11 residual input contract and dry-run manifest utilities.
- Datasets Phase 11 provenance inventory and unit/cadence contract summaries.
- Current stats residual decomposition contract if locally available.
- Async completion audit and final synthesis.

## Required behavior

- Add or extend a runner-side burndown command that reads Phase 11 residual
  dry-run/input-contract outputs and optional datasets/stats readiness artifacts.
- For each config, report units, cadence/timebase, residual component fields,
  sample counts, PCRLB/MAD floor inputs when applicable, stats dependency
  identity, cache/provenance status, source identity, and blocker codes.
- Output `trace_generation_ready=false` unless all required fields and dependency
  artifacts are present.
- Preserve the existing fail-closed behavior; do not weaken `not_ready` statuses
  into readiness.
- Do not generate residual traces, upload artifacts, download data, run
  Hugging Face upload or download commands, browse, or mutate caches.
- Do not edit thesis files, roadmap files, claim registry files,
  `claims/registry.yaml`, or `claim_55`.
- Do not make comparison, leaderboard, novelty, breakthrough, or
  verified-claim statements.

## Dependencies

This task can run immediately against current local residual dry-run outputs or
candidate definitions. Missing datasets/stats artifacts become explicit blocker
rows.

## Falsification gate

If a config missing units, cadence/timebase, residual fields, sample counts,
PCRLB/MAD floor inputs, cache/provenance readiness, source identity, or stats
dependency identity can be marked trace-generation-ready, the task must fail.

## Acceptance checks

- The burndown report reproduces or explains the current no-ready-candidate state
  using concrete blocker codes.
- It separates fixable metadata gaps from missing local cache/provenance gaps.
- It names the exact dependency artifact required to clear each row when known.
- It keeps all local paths and private cache roots out of committed artifacts.

## Validation

Run and record:

- focused tests for ready config, missing units, missing cadence/timebase,
  missing residual fields, missing sample counts, missing PCRLB/MAD floor inputs,
  missing stats identity, missing cache, missing provenance, and local-path
  redaction;
- one real burndown over current Phase 11 candidate configs without running
  filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with a subject starting `GLASSBOX`. Do not add co-author trailers.
