---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report
target_branch: phase-9-parallelization-map-20260507
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 9 - parallelization map

You are a rigorous BSEBench async planning engineer. You are not alone in this
codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare the Phase 9 profile-axis implementation wave after Phase 8 integration
by maintaining a concrete runner/stats/datasets/async task map with disjoint
write-sets, validation gates, and explicit blockers.

## Required behavior

- Use the universal benchmark charter and current Phase 8 validation artifacts
  as planning inputs.
- Keep the plan implementation-ready even when Phase 8 integration is not yet
  merged: cite exact evidence when known and mark unmerged or unknown evidence
  as unknown or blocked.
- Split future work by repository and file ownership so runner, stats,
  datasets, and async workers can run concurrently without writing the same
  files.
- Preserve the plug-and-play estimator, profile-axis comparability,
  provenance, anti-leakage, degraded-initialization, and public benchmark
  readiness direction.
- Do not edit thesis files, manuscript files, claim registry files,
  `claims/registry.yaml`, `claim_55`, or the scientific roadmap.
- Do not edit runner, stats, or datasets repositories in this planning task;
  inspect them read-only if needed.
- Do not make external-performance, public ranking, publication-readiness, or
  claim-verdict statements.

## Handoff artifact

Maintain:

- `plans/phase9/parallelization-map-20260507.md`

The plan must contain:

- Phase 8 evidence and blockers carried forward.
- A dependency graph or wave order.
- At least four disjoint implementation lanes: runner, stats, datasets, async.
- Per-task target branch, owned write-set, dependencies, falsification gate,
  and validation commands.
- Merge and stop rules for stale evidence, source-ledger gaps, or protected
  path drift.

## Falsification gate

If any planned task has an overlapping write-set with another same-wave task,
requires protected-path edits, depends on unknown evidence without marking it
blocked, or can produce profile-axis conclusions without provenance and
comparability gates, the plan is not dispatchable.

## Validation

Run and record:

- `git diff --check`

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
