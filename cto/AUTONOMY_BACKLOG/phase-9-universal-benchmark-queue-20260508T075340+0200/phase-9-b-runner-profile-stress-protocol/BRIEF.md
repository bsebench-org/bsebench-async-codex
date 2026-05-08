---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-9-b-runner-profile-stress-protocol
base_branch: main
hard_wallclock_min: 60
---

# Phase 9.b - runner profile-stress protocol

You are a rigorous benchmark-protocol engineer. You are not alone in this
codebase; do not revert or overwrite unrelated edits.

## Objective

Add a runner protocol skeleton for profile-axis stress evaluation that can test
SOC/SOH estimators across dynamic, low-excitation, rest-heavy, and transition
profiles without changing estimator code.

## Inputs Inspected

This queue-pack author inspected:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`
- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`
- `cto/AUTONOMY_BACKLOG/README.md`

Before editing, inspect the target repository and record the actual files read.

## Decisions

- Active lane: evidence generation. Produce protocol plumbing and fixture
  evidence only.
- Owned write scope in the target repo: profile-stress protocol registry,
  profile-stress fixtures, and profile-stress tests only.
- Keep this independent from estimator-contract files, dataset manifest files,
  stats metric-envelope files, async submission templates, thesis files,
  manuscript files, roadmap files, claim registry files, `claims/registry.yaml`,
  and `claim_55`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim
  statements without a completed source ledger, stable URL or DOI, retrieval
  date, metric, dataset, split, BSEBench frozen value, and comparability caveat.

## Required Behavior

- Add a declarative profile-stress protocol entry or equivalent local pattern
  that names profile families without binding to one dataset.
- Support at least four profile labels: dynamic, low-excitation, rest-heavy,
  and transition.
- Include fixture data or synthetic metadata only when needed to test protocol
  selection. Mark synthetic fixtures clearly.
- Ensure protocol selection is separate from estimator implementation and
  metric aggregation.
- Include a failure path for unknown or missing profile labels.

## Falsification Gate

The task must fail if a profile-stress run can silently treat an unknown profile
label as valid, if protocol selection imports a concrete estimator, or if tests
cannot distinguish dynamic from low-excitation fixture metadata.

## Validation Checklist

- Run focused profile-stress protocol tests with valid and invalid profile
  labels.
- Run any target-repo lightweight formatting or lint command that is already
  documented or obvious from the inspected files.
- Run `git diff --check`.
- Record changed files and exact validation command results in the worker
  summary.

## Residual Risks

- Real dataset labels may not yet cover all profile families. Missing real
  coverage should be reported as a gap, not inferred.
- Profile taxonomy may need later expansion; this task only creates the
  falsifiable skeleton.

## Next Concrete Task

After this merges, queue `phase-9-c-datasets-profile-axis-manifest` so dataset
adapters can expose profile labels using a shared metadata contract.
