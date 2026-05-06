# Phase phase-6-11-b-chi2-multi-cfg-sweep summary (CTO stale-running reconciliation)

- Worker : france-personal-2
- Original status : running
- CTO final status : error
- Exit code : 125
- Reconciled at : 2026-05-06T22:36:00Z

## Evidence

- Status was `running` since `2026-05-06T21:16:09Z`, beyond the 60 min cap.
- No active `codex exec` referenced this phase.
- No local or remote branch existed in `bsebench-runner` for this phase.
- No `scripts/chi2_sweep_5x5.py`, test, outbox summary, or stdout tail existed.

## Decision

Mark stale `running` as `error`. Do not requeue immediately: this phase depends
on `phase-6-10-h-bsebench-runner-registry-swap-fix-1` replacing runner stubs with
real loaders.
