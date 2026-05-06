# Phase phase-6-10-h-bsebench-runner-registry-swap summary (CTO stale-running reconciliation)

- Worker : france-personal
- Original status : running
- CTO final status : error
- Exit code : 125
- Reconciled at : 2026-05-06T22:36:00Z

## Evidence

- Status was `running` since `2026-05-06T21:16:07Z`, beyond the 30 min cap.
- No active `codex exec` referenced this phase.
- No local or remote branch existed in `bsebench-runner` for this phase.
- No outbox `SUMMARY.md`, `run.log.tail`, or verdict existed before this note.
- `bsebench-runner/src/bsebench_runner/default_adapters.py` still used the stub loaders, so the deliverable was not present.

## Decision

Mark stale `running` as `error` and requeue as
`phase-6-10-h-bsebench-runner-registry-swap-fix-1`.
