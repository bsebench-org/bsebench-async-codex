# BSEBench Async No-Idle Capacity Policy

Saved: 2026-05-07. Scope: operator policy for universal benchmark worker waves.

## Purpose

This policy defines when the CTO may add, keep, pause, or redirect async
workers during BSEBench universal benchmark execution. The objective is useful
parallelism: no worker should sit idle when there is a ready, disjoint task that
improves the universal benchmark standard, and no worker should be launched into
duplicate or conflicting work just to keep capacity busy.

This is an operations policy only. It does not authorize thesis, manuscript,
claim registry, `claims/registry.yaml`, `claim_55`, scientific roadmap, or
scientific claim-status edits.

## Dispatch Rule

Scale worker count only when every additional worker has all of these fields:

| Field | Required content |
|---|---|
| `phase_id` | Unique task identifier and target branch. |
| `universal_value` | How the work improves plug-and-play benchmarking, comparable metrics, leakage safety, provenance, or monthly benchmark readiness. |
| `target_repo` | One repository or explicitly read-only cross-repo context. |
| `write_set` | Exact owned files, directories, or schema/check responsibility. |
| `conflict_check` | Active-worker matrix reviewed before queueing. |
| `falsification_gate` | Concrete condition that blocks success. |
| `validation_gate` | Focused command, dry-run, fixture, or doc sanity check that can be recorded by the worker. |
| `claim_guardrail` | Explicit no unsupported claim language and source-ledger requirement for comparisons. |
| `cost_class` | `doc/check`, `fixture`, `fast-test`, `cache-probe`, or `expensive-evidence`. |

If any field is missing, the worker slot stays unassigned or is redirected to a
ready reserve task. Missing metadata is not inferred from memory.

## Active-Worker Matrix

Before queueing a new worker, record an active-worker matrix in the operator
notes, issue, or BRIEF:

| Worker | Phase | Target repo | Write set | Cost class | Status | Conflict notes |
|---|---|---|---|---|---|---|

A new task is dispatchable only when its write set is disjoint from every active
write set, or when the overlap is explicitly read-only. Treat these as conflicts
until split or sequenced:

- Same target repo plus same script, schema, output artifact, CI workflow, or
  documentation contract.
- Shared generated evidence or output path, even if the code paths differ.
- One task editing a producer while another edits the consumer contract without
  a pinned interface fixture.
- One task asking for claim, source-ledger, or thesis work while another is
  still generating or replaying the evidence that would support it.

When there is overlap, split the work into a narrower write set, convert one
task to read-only review, or queue the later task after the first branch is
merged. Do not rely on "workers can resolve it later" as the conflict plan.

## No-Idle Backlog

Keep at least two reserve tasks per likely idle worker, but reserve tasks must
be real work, not filler. A reserve task is valid when it satisfies the dispatch
rule and lands in one of these lanes:

- Contract hardening: schema, fixture, checker, or template that makes future
  submissions more plug-and-play.
- Comparability hardening: metric, split, aggregation, provenance, or
  anti-leakage guard.
- Public benchmark readiness: monthly snapshot, release checklist, submission
  review checklist, or neutral reporting contract.
- Read-only audit: current artifact, cache, BRIEF, or policy check that records
  gaps without changing scientific claims.

If no valid reserve task exists, leave capacity idle and replenish the backlog.
Idle capacity is cheaper than duplicate work, merge conflicts, or unsupported
claim drift.

## Claim And Source-Ledger Guardrail

No worker may use this policy to accelerate SOTA, novelty, leaderboard,
breakthrough, or verified-claim language. A comparison task must have a source
ledger with stable URL or DOI, retrieval date, metric, dataset, split,
BSEBench frozen value, and comparability caveat. Without that ledger, the task
may only create neutral infrastructure or record that comparison work is
blocked.

Evidence generation, SOTA comparison, and claim registration remain separate
lanes. Scaling workers never permits one branch to combine those lanes.

## Stop Or Backoff Conditions

Pause new worker launch and re-plan when any condition appears:

- Two active or queued workers own the same write set.
- A task cannot name its falsification gate or validation gate.
- A worker proposes unsupported scientific claim language.
- A branch starts touching protected thesis, registry, roadmap, or `claim_55`
  files without explicit claim-registration authorization.
- The same target repo has repeated non-fast-forward or merge-conflict failures
  from adjacent work.
- The backlog contains only expensive empirical runs and no dry-run, fixture,
  schema, or audit tasks to de-risk them.

Backoff means splitting the work, narrowing the write set, adding a fixture or
contract first, or leaving capacity idle until a useful task is ready.

## Operator Checklist

Use this checklist before queueing each additional worker:

1. The task states universal benchmark value.
2. The task owns a distinct write set and target branch.
3. The active-worker matrix has been reviewed for duplicate or conflicting work.
4. The BRIEF includes falsification and validation gates.
5. The cost class is appropriate for the current evidence budget.
6. The task does not edit protected thesis, registry, roadmap, or claim files.
7. Any comparison language is blocked unless a complete source ledger exists.
8. A reserve task exists for the next idle worker, or backlog replenishment is
   the next operation.

## Falsification Gate

This policy fails if an operator can queue an additional worker without a
distinct write set, universal benchmark value, conflict check, falsification
gate, and validation gate. It also fails if the policy can be used to justify
duplicate work, conflicting writes, expensive empirical runs without a dry-run
path, or unsupported scientific claim language.

## Validation

Policy sanity is checked by:

```bash
bash scripts/check-no-idle-capacity-policy.sh
```

The checker verifies that this document retains the dispatch rule, active-worker
matrix, no-idle reserve backlog, duplicate/conflict guard, source-ledger
guardrail, protected-file guardrail, falsification gate, validation gate, and
universal benchmark value language.
