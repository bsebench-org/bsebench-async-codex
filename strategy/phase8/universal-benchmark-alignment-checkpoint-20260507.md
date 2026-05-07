# Universal Benchmark Alignment Checkpoint

Saved: 2026-05-07T22:00+02:00. Role: Codex CTO orchestration.

## Decision

The current Phase 8 push remains aligned with the BSEBench north star: an open,
universal SOC/SOH benchmark standard, not a one-off result chase.

The correct immediate path is:

1. Merge only validated integration branches that preserve the plug-and-play
   estimator, metric, dataset, split, provenance, and reporting boundaries.
2. Keep public or monthly benchmark language blocked until source-ledger,
   license/access, split/provenance, and no-unsupported-claims gates are closed.
3. Turn every current blocker into a narrow backlog item with an owner,
   validation command, and fail-closed acceptance criterion.
4. Prepare Phase 9 parallelization, but do not start code that depends on
   unmerged Phase 8 APIs until the corresponding integration branch is accepted.

## Evidence Used

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`
- W5 read-only audit: runner, stats, datasets, and async integration branches
  are pushed and clean; async and datasets required current validation replays.
- W6 read-only audit: red-team artifacts exist for compute reproducibility,
  anti-leakage, submission adversarial tests, CI triage, schema diffs, claims,
  release, and dataset license/access.
- W8 launched current validation tasks to supersede stale W5 validation
  artifacts.
- W9 launched pre-merge and alpha-readiness artifacts that prepare PRs,
  governance, risk, release notes, and next-phase parallelization without
  editing protected scientific material.

## What Counts As Useful Progress

Useful work must satisfy at least one of these properties:

- reduces the code a future researcher must write to submit a new estimator,
  ECM, filter, observer, or hybrid method;
- improves comparability across datasets, chemistries, profiles, aging states,
  temperatures, or method families;
- prevents leakage, overfitting, hidden assumptions, or unsupported claims;
- decouples algorithm code from evaluation machinery;
- makes recurring monthly community benchmarking more auditable.

Tasks that do not satisfy one of these properties are not acceptable capacity
fillers.

## Current Merge Gates

| Gate | Current decision | Required evidence |
|---|---|---|
| Runner integration | Candidate | Current PR preflight and validation evidence must remain clean. |
| Stats integration | Candidate | Current PR preflight and metric/backcompat audit must remain clean. |
| Datasets integration | Candidate with licensing caveat | Current validation, license/access backlog, and provenance gaps must be explicit. |
| Async docs integration | Candidate after replay | W8 async docs replay must supersede stale block evidence. |
| Public benchmark report | Blocked | Requires source-ledger, no-claims checker, license/access, frozen hash manifest, and governance sign-off. |
| Monthly snapshot | Blocked | Requires frozen inputs, snapshot CLI contract, source ledger, split manifest, and redaction policy. |
| Alpha release notes | Draft only | Must avoid any performance, SOTA, novelty, or superiority claim. |

## Strategic Risks

| Risk | Why it matters | Control |
|---|---|---|
| False capacity accounting | Creates idle periods while operators believe work is active. | Count unique real `codex exec -C` workdirs; status rows are diagnostics only. |
| Over-integration before current validation | Can merge stale evidence or obsolete blockers. | W8 replay tasks must close stale W5 signals before GO. |
| Dataset license ambiguity | Public benchmark cannot redistribute or report some artifacts safely. | Fail closed; collect evidence in a dedicated license/access backlog task. |
| Source-ledger gaps | External comparison language becomes unsupported. | Block public claims until every comparison row is bound to source and frozen BSEBench value rows. |
| One-off benchmark drift | Work could optimize a single claim instead of the universal standard. | Apply the universal design rule to every task and merge decision. |

## Next Orchestration Actions

1. Wait for W8 current-validation outputs and classify integration branches as
   candidate, blocked, or relaunch.
2. Wait for W9 PR preflight and risk/governance outputs.
3. If active capacity drops below 8 useful workers, launch a new disjoint wave
   from unresolved blockers only.
4. Do not merge or publish from any branch with non-GLASSBOX head, dirty
   worktree, stale validation, unsupported claim language, or protected-file
   edits.
5. Prepare Phase 9 implementation only after Phase 8 interfaces are either
   merged or explicitly frozen as candidates.

## Non-Claims

This checkpoint does not claim BSEBench is public-ready, SOTA, novel,
leaderboard-leading, superior to any existing benchmark, or externally
validated. It is an operational alignment decision for continuing work toward
the universal SOC/SOH benchmark standard.
