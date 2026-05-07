# CTO autonomy pacer - non-idle but bounded

Saved: 2026-05-07. Role: codex-cto-FR.

## Incident

The audit watchdog correctly logged `BACKLOG_GUARD=empty`, but it was audit-only. After Phase 7.9 drained, workers stayed alive with no `codex exec` because nothing replenished the queue.

## Correction

`scripts/cto-autonomy-pacer.sh` is the mutating counterpart to the audit watchdog. Every 10 minutes it:

- pulls the async orchestration repo;
- restarts the two worker daemons if either is missing;
- pauses if advisor blocks exist;
- compares actual `codex exec` count plus queued tasks against `MIN_RUNNING + MIN_QUEUED`;
- copies gate-checked tasks from `cto/AUTONOMY_BACKLOG/` into `inbox/`;
- keeps at least six unqueued reserve tasks, and queues a replenishment task when the reserve drops below six;
- commits and pushes with GLASSBOX metadata.

## Quality Boundaries

The pacer does not run Codex directly and does not invent scientific results. It only queues prewritten BRIEFs with falsification gates, validation commands, no thesis or claim-registry edits, and no unsupported SOTA wording.

If a block exists, the pacer pauses instead of hiding a red validation signal under more work.
