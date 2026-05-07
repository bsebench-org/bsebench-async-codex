# CTO autonomy pacer - non-idle but bounded

Saved: 2026-05-07. Role: codex-cto-FR.

## Incident

The audit watchdog correctly logged `BACKLOG_GUARD=empty`, but it was audit-only. After Phase 7.9 drained, workers stayed alive with no `codex exec` because nothing replenished the queue.

The 2026-05-07 follow-up incident exposed a second failure mode: a Chef block stayed present after the underlying infra-only cause had been corrected. The pacer intentionally paused on blocks, but the pause had no remediation path, so workers remained alive while no new `codex exec` could be started.

## Correction

`scripts/cto-autonomy-pacer.sh` is the mutating counterpart to the audit watchdog. Every 10 minutes it:

- pulls the async orchestration repo;
- restarts the two worker daemons if either is missing;
- pauses normal backlog queueing if advisor blocks exist;
- if blocked and idle, queues one bounded block-remediation task per cooldown window instead of leaving the system silent;
- compares actual `codex exec` count plus queued tasks against `MIN_RUNNING + MIN_QUEUED`;
- copies gate-checked tasks from `cto/AUTONOMY_BACKLOG/` into `inbox/`;
- keeps at least six unqueued reserve tasks, and queues a replenishment task when the reserve drops below six;
- commits and pushes with GLASSBOX metadata.

## Quality Boundaries

The pacer does not run Codex directly and does not invent scientific results. It only queues prewritten BRIEFs with falsification gates, validation commands, no thesis or claim-registry edits, and no unsupported SOTA wording.

If a block exists, the pacer does not queue ordinary scientific work. It queues only a remediation task whose purpose is to diagnose the red signal, record root cause, and define the exact recovery gate. This preserves the block while avoiding silent idle time.

The worker and chef scripts also remove stale `.git/index.lock` files only when they are older than `STALE_GIT_LOCK_MIN` and no `git` process references the repo. This prevents a crashed git operation from making a live daemon look healthy while every tick fails before useful work starts.

Codex process accounting is intentionally limited to worker-style invocations: `codex exec`, or Codex wrapper/vendor processes that include `-C <worktree>`. The long-lived interactive CTO session is not counted as active worker capacity.

Backlog candidate selection also skips tasks whose target branch already exists locally or on `origin`, so manual CTO launches cannot be duplicated merely because they were not queued by the pacer.

The worker and chef daemons explicitly check out `main` before resetting to `origin/main`. A reset alone is not enough when a clone was left on a feature branch; async state commits must land on the branch that will be pushed.

Reserve replenishment cooldown applies only while a replenishment task is open (`queued`, `running`, or `needs_fix`). Once a replenishment exits to a terminal state, the pacer may create another task if reserve is still empty; otherwise a failed or non-merged replenishment can hold the system idle for the cooldown window.

## Self-Audit Probe

`scripts/probe-autonomy-pacer-safety.sh` builds isolated temporary async repos and runs the pacer in dry-run mode. The probe checks three incident-review cases:

- two fresh running tasks, no queued task, and reserve available: the pacer queues exactly one waiting BRIEF;
- `outbox/_blocks/*.block` present: the pacer queues remediation only and does not queue normal backlog work;
- malformed or non-eligible backlog BRIEFs present: the pacer skips them and queues only a Phase 7/8/11 BRIEF that passes `scripts/check-research-brief-gates.sh`.

The probe commits each fixture before invoking the pacer and asserts that dry-run mode leaves the fixture worktree clean.
