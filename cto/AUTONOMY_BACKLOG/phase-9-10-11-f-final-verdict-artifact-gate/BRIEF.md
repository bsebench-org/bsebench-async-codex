---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-9-10-11-f-final-verdict-artifact-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 75
---

# Phase 9/10/11.f - final verdict artifact gate

You are a rigorous BSEBench async verdict-gate engineer. You are not alone in
this codebase; do not revert or overwrite unrelated edits.

## Goal

Prevent empty or no-diff final-verdict branches from being treated as Phase 9,
Phase 10, or Phase 11 closure evidence.

## Local evidence to consume

- Local branch refs for Phase 9, Phase 10, and Phase 11 final verdict attempts.
- Phase 9/10/11 completion audit and final synthesis.
- Current DAG wait states.
- Local outputs from any Phase 9/10/11 blocker-board tasks if present.

## Required behavior

- Add an async-side verdict-artifact gate or report that inspects local git refs
  and local files only.
- For each phase, report final verdict branch name, head SHA, changed files
  against current `origin/main`, verdict artifact path if present, dependency
  artifact IDs, and phase-level status.
- Allowed statuses are `ready_for_verdict`, `no_go_missing_inputs`,
  `no_go_empty_branch`, `no_go_source_ledger`, `no_go_empirical_artifact`,
  `no_go_dataset_provenance`, and `no_go_claim_gate`.
- A branch with no unique verdict artifact must be `no_go_empty_branch`.
- A phase missing empirical evidence, source-ledger rows, provenance/cache
  readiness, replay command, or acceptance checks must remain NO-GO.
- Do not create scientific verdict text beyond neutral gate status.
- Do not upload artifacts, download data, run Hugging Face upload or download commands,
  browse, or contact external services.
- Do not edit thesis files, roadmap files, claim registry files,
  `claims/registry.yaml`, or `claim_55`.
- Do not make comparison, leaderboard, novelty, breakthrough, or
  verified-claim statements.

## Dependencies

This task can run immediately. If phase-specific readiness tasks have not
produced artifacts, record their absence as `no_go_missing_inputs`.

## Falsification gate

If an empty final-verdict branch, missing verdict artifact, missing empirical
artifact, missing source-ledger row, missing provenance/cache readiness, or
missing replay command can be marked phase-closed, the task must fail.

## Acceptance checks

- The report has one row each for Phase 9, Phase 10, and Phase 11.
- Every row names the local evidence refs inspected and the exact missing inputs.
- No phase can be marked `ready_for_verdict` without explicit artifact paths,
  branch/commit identity, replay commands, and source/provenance status.
- The report leaves downstream claim registration blocked unless a separate,
  explicitly authorized claim-registration task exists.

## Validation

Run and record:

- focused tests or fixtures for empty branch, missing artifact, missing
  empirical evidence, missing source-ledger, missing provenance, missing replay,
  and ready gate cases;
- one real local verdict-gate report over current Phase 9/10/11 refs;
- a protected-path scan showing no thesis, roadmap, claim registry,
  `claims/registry.yaml`, or `claim_55` edits;
- a text scan for unsupported comparison or claim-promotion wording;
- `git diff --check`.

Commit with a subject starting `GLASSBOX`. Do not add co-author trailers.
