# CTO Incident - idle after unresolved block

Saved: 2026-05-07T16:50:00Z. Role: codex-cto-FR.

## Symptom

From 2026-05-07T16:20:05+02:00 through 2026-05-07T18:50:04+02:00, `cto-autonomy-pacer.sh` logged `PAUSE blocks present` every 10 minutes. Worker, chef, and CTO daemons were alive, but no queued/running async work remained and no `codex exec` worker process was active.

## Root Cause

1. `phase-7-10-a-stats-hinf-uncertainty-report` was correctly blocked by Chef/Panel/Advisor because the original stats commit used the wrong author email. This was an infra/provenance failure, not a scientific claim failure.
2. The stats commit was later amended and pushed as `ad248425b3eaf2a27c2d4ea014e9173f5b1f459c` with `Oussama Akir <claude@cosmocomply.com>`, and that commit is now on `origin/main` and `origin/phase-7-10-a-stats-hinf-uncertainty-report`.
3. The async block file remained after the fix. The pacer was designed to pause on any block and had no remediation queue path, so the safety stop became a silent global idle condition.
4. A separate stale `.git/index.lock` failure appeared in `bsebench-async-codex-worker-2`, making one live worker tick fail before useful work. This made daemon liveness a poor proxy for actual forward progress.

## Blast Radius

- Normal scientific queueing stopped while the block existed.
- Chef stayed paused by design.
- Workers kept ticking, but had no useful queued tasks to start.
- No thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files were changed by this incident response.

## Durable Fix

- `scripts/cto-autonomy-pacer.sh` now pauses normal backlog queueing on blocks but queues one bounded block-remediation task when blocked and idle.
- The pacer now counts live worker Codex CLI processes by accepting `codex exec` or Codex wrapper/vendor processes that include `-C <worktree>`, so monitoring is not blind to wrapper process names and does not count the long-lived interactive CTO session.
- The pacer now skips backlog BRIEFs whose target branch already exists locally or on `origin`, preventing duplicate re-queue of work that was launched manually rather than by pacer.
- `scripts/remote-worker.sh` and `scripts/chef-daemon.sh` now remove stale `.git/index.lock` files only when they are older than `STALE_GIT_LOCK_MIN` and no `git` process references the repo.
- `scripts/probe-autonomy-pacer-safety.sh` now asserts that a block queues remediation only and does not queue ordinary backlog work.

## Current Recovery

The blocked stats commit has been corrected:

```text
ad248425b3eaf2a27c2d4ea014e9173f5b1f459c
Oussama Akir <claude@cosmocomply.com>
GLASSBOX [role: codex-stats-engineer] Add Hinf uncertainty fragility report
```

The stale block is cleared in the same GLASSBOX incident commit as this note, with `outbox/phase-7-10-a-stats-hinf-uncertainty-report/CTO_UNBLOCK.md` preserving the unblock rationale.
