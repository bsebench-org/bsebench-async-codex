# Autonomy Watchdog Postmortem and Alpha SLO

Saved: 2026-05-07T21:53:48Z. Owner: W9-h. Scope: async orchestration capacity only.

This note documents the operational failure modes behind idle Codex capacity and
false capacity counting. It does not make scientific, SOTA, novelty,
leaderboard, breakthrough, or verified-result claims.

## Evidence Inspected

- `scripts/cto-watchdog-10min.sh`: audit-only 10 minute watchdog that writes
  only to `/home/oakir/.local/state/bsebench-async-watchdog/`.
- `scripts/cto-autonomy-pacer.sh`: mutating queue pacer with default
  `MIN_RUNNING=2`, `MIN_QUEUED=1`, `MIN_RESERVE=6`,
  `MAX_QUEUE_PER_TICK=3`, `STALE_RUNNING_MIN=180`,
  `REPLENISHMENT_COOLDOWN_HOURS=12`, and
  `BLOCK_REMEDIATION_COOLDOWN_MIN=30`.
- `scripts/cto-supervisor-10h.sh`: bounded 10 hour supervisor with default
  `INTERVAL_SECONDS=600`, `DURATION_SECONDS=36000`,
  `MIN_UNIQUE_CODEX_EXEC=2`, and `SILENT_LOG_WARN_SECONDS=1200`.
- `scripts/probe-autonomy-pacer-safety.sh`: isolated dry-run probe for pacer
  safety cases.
- Memory notes: `docs/CTO-AUTONOMY-PACER-2026-05-07.md`,
  `cto/OUTBOX/CTO_INCIDENT_20260507T165000Z_IDLE_AFTER_BLOCK.md`,
  `cto/OUTBOX/CTO_INCIDENT_20260506T222000Z.md`, and
  `cto/OUTBOX/CTO_REPORT_20260506T235500Z.md`.

Unknowns: W8's final validation report and W7 alpha-readiness artifacts were not
available in this branch at inspection time. This note treats them as pending
external inputs, not evidence.

## Incident Pattern

The async system had daemons alive but no useful work executing. The watchdog
could observe this, but it could not repair it because it was intentionally
audit-only. The pacer was later added as the bounded mutating counterpart.

Two incident classes are represented in the notes:

1. Empty or drained queue: `BACKLOG_GUARD=empty` was logged, but no process
   queued roadmap-mapped validation work.
2. Blocked but idle: an `outbox/_blocks/*.block` file paused normal work after
   an infra/provenance problem had been fixed elsewhere, leaving no active
   `codex exec` and no bounded remediation task.

Both classes shared the same bad outward signal: worker, chef, or CTO daemon
processes were visible, but there was no active worker-style Codex execution
and no guaranteed next useful task.

## Root Causes

### 1. Audit Without Actuation

`cto-watchdog-10min.sh` correctly reports process state, status counts, stale
queued/running entries, block files, and backlog guard output. It is constrained
to the state directory and cannot mutate queues. That is the right safety
boundary, but it means watchdog alerts alone cannot preserve useful capacity.

Fix now present: `cto-autonomy-pacer.sh` is the actuation path. It pulls the
async repo, checks reserve candidates, queues gate-checked BRIEFs, appends
`HISTORY.md`, commits, and pushes.

### 2. Daemon Liveness Was Treated as Capacity

The incidents show worker and chef daemons alive while no worker-style
`codex exec` was active. A daemon tick can be blocked by queue emptiness, a
stale git lock, a stale block file, or a branch-state problem. Counting those
daemons as capacity hid the absence of useful work.

Fix now present: pacer and supervisor count unique worker Codex workdirs using
`pgrep` for `codex exec`, `/usr/bin/codex`, or `@openai/codex` processes that
include `-C` or `--cd` under the BSEBench root. The pacer excludes its own
watchdog/supervisor/pacer processes and treats `STATUS.json` running rows as
diagnostics only.

### 3. Status Rows Could Lag Reality

`STATUS.json` can remain `running` after a wrapper exits early or a daemon fails
before updating terminal state. The pacer records `status_running` and
`fresh_running`, but effective capacity is now `codex_exec` only.

Fix now present: `effective_running="$execs"` in `cto-autonomy-pacer.sh`.
`STALE_RUNNING_MIN=180` is retained as a diagnostic warning threshold, not as a
capacity credit.

### 4. Block Safety Had No Remediation Path

The pacer must not hide a red validation signal by queueing ordinary scientific
work while a block exists. However, the 2026-05-07 idle-after-block incident
showed that "pause all queueing" also becomes unsafe when the block is stale or
infra-only and no one is actively diagnosing it.

Fix now present: when `outbox/_blocks/*.block` exists and effective capacity is
below `MIN_RUNNING + MIN_QUEUED`, the pacer queues one block-remediation task
per `BLOCK_REMEDIATION_COOLDOWN_MIN=30` minute cooldown. Normal backlog queueing
stays paused.

### 5. Reserve Depletion Was Not a First-Class Failure

Without a curated reserve, the system can avoid busy work only by going idle.
That is preferable to fabricating tasks, but not acceptable as steady state.

Fix now present: reserve candidates are restricted to Phase 7, 8, or 11 BRIEFs
that pass `scripts/check-research-brief-gates.sh --dry-run`, have target repo
and branch frontmatter, have no existing inbox directory, are not already marked
queued, and do not target an already-existing branch locally or on `origin`.
The pacer keeps `MIN_RESERVE=6` and queues a replenishment task when reserve is
low. Current implementation detail: the `REPLENISHMENT_COOLDOWN_HOURS=12`
environment variable is named, but the inspected function gates on open
`queued`, `running`, or `needs_fix` replenishment tasks rather than elapsed wall
time after terminal completion.

### 6. Git State Could Make Daemons Look Healthy While Work Failed

The incident memory notes record stale `.git/index.lock` failures and async
clones left on feature branches. In that state, daemon ticks can fail before
useful work starts, or commit async state on the wrong local branch.

Fix recorded in memory: worker and chef daemons remove stale index locks only
when older than `STALE_GIT_LOCK_MIN` and no git process references the repo, and
they explicitly check out `main` before resetting to `origin/main`.

## Alpha SLOs

These SLOs are operational. They measure whether useful Codex capacity remains
active without converting safety pauses into busy work.

### Capacity SLO

Target: during an active wave with nonempty eligible reserve and no global block,
keep at least two unique worker-style Codex exec workdirs active and at least
one queued task ready.

Implementation threshold:

- Desired floor: `MIN_RUNNING=2` and `MIN_QUEUED=1`.
- Alert warning: `UNIQUE_CODEX_EXEC < 2` on any supervisor tick.
- Page-level condition: `UNIQUE_CODEX_EXEC < 2` for two consecutive 10 minute
  ticks while `queued > 0` or eligible reserve exists.
- Critical condition: `UNIQUE_CODEX_EXEC=0` and `queued=0` for 20 minutes while
  eligible reserve exists and `blocks=0`.

Evidence source: `cto-supervisor-10h.sh` logs `UNIQUE_CODEX_EXEC`, runs pacer,
waits 45 seconds, and logs `RECHECK_UNIQUE_CODEX_EXEC`.

### No False Capacity SLO

Target: daemon process liveness and stale `STATUS.json` rows must not count as
useful capacity.

Implementation threshold:

- Capacity credit source: unique worker-style Codex CLI workdirs only.
- Diagnostic-only fields: `status_running` and `fresh_running`.
- Alert warning: any `running` status older than 120 minutes in watchdog output.
- Pacer stale warning: any `running` status older than `STALE_RUNNING_MIN=180`.
- Violation: capacity reported healthy when `codex_exec < MIN_RUNNING` only
  because daemon processes or `STATUS.json` rows exist.

Evidence source: `cto-watchdog-10min.sh` warns on `running` age >= 120 minutes;
`cto-autonomy-pacer.sh` logs `SNAPSHOT codex_exec=... status_running=...
fresh_running=... effective_running=...`.

### Useful Queue SLO

Target: the system may queue only falsifiable, roadmap-mapped, gate-checked
work or bounded incident remediation. It must not generate tasks merely to keep
processes busy.

Implementation threshold:

- Eligible normal backlog: Phase 7, 8, or 11 only.
- Reserve floor: `MIN_RESERVE=6`.
- Per-tick queue cap: `MAX_QUEUE_PER_TICK=3`.
- Waiting queue floor: `MIN_QUEUED=1`.
- Replenishment trigger: reserve below six after normal queueing decisions.
- Violation: queueing a BRIEF that fails `check-research-brief-gates.sh`, lacks
  a falsification gate, lacks validation, edits prohibited thesis/registry/
  roadmap paths, targets protected `claim_55`, or makes unsupported SOTA-style
  claims.

Evidence source: `queue_backlog_brief`, `reserve_candidates`, and
`queue_replenishment_task` in `cto-autonomy-pacer.sh`; dry-run safety coverage
in `scripts/probe-autonomy-pacer-safety.sh`.

### Block Handling SLO

Target: a block file preserves the red signal, but it must not silently stop all
diagnosis.

Implementation threshold:

- Normal backlog queueing is paused whenever `blocks > 0`.
- If blocked and `effective_capacity < MIN_RUNNING + MIN_QUEUED`, queue at most
  one block-remediation task per 30 minutes.
- Alert warning: `blocks > 0` and no open block-remediation task for one pacer
  tick while `codex_exec=0` and `queued=0`.
- Critical condition: `blocks > 0`, `codex_exec=0`, `queued=0`, and no open
  block-remediation task for 20 minutes.
- Violation: deleting a block without a recorded `CTO_UNBLOCK.md` or equivalent
  root-cause and recovery-gate record.

Evidence source: `block_count`, `queue_block_remediation_task`, and
`block_remediation_recent_or_open` in `cto-autonomy-pacer.sh`.

### Silence and Observability SLO

Target: monitoring logs must show fresh movement often enough that a silent
pipeline is distinguishable from a working one.

Implementation threshold:

- Watchdog cadence: every 10 minutes.
- Supervisor cadence: `INTERVAL_SECONDS=600`.
- Silent log warning: `SILENT_LOG_WARN_SECONDS=1200`.
- Hourly direction checkpoint: watchdog emits the research checkpoint when
  current minute is `00`.
- Alert warning: any watched manual, pacer, or watchdog log age >= 1200 seconds.
- Critical condition: pacer log or watchdog log absent or silent for 30 minutes
  during an active wave.

Evidence source: `log_watched_log_mtimes` in `cto-supervisor-10h.sh`.

### Dirty-Tree and Branch Hygiene SLO

Target: the pacer must not mutate a dirty async repo or duplicate manually
claimed branches.

Implementation threshold:

- Pacer mutation must stop on dirty async repo before queueing.
- Backlog candidate must be skipped if target branch exists locally or on
  `origin`.
- Violation: pacer writes inbox/HISTORY state on a non-main async branch or
  queues a duplicate target branch.

Evidence source: `ensure_repo_ready`, `git_dirty`, and
`brief_target_branch_claimed` in `cto-autonomy-pacer.sh`.

## Alpha Readiness Gate

Before declaring alpha-ready capacity controls, require these checks to pass on
the integration branch:

1. `bash -n scripts/cto-watchdog-10min.sh scripts/cto-autonomy-pacer.sh scripts/cto-supervisor-10h.sh`.
2. `bash scripts/probe-autonomy-pacer-safety.sh`.
3. One supervisor `--once` run records `UNIQUE_CODEX_EXEC`, status counts,
   watched log mtimes, watchdog execution, pacer execution, and pacer tail.
4. A dry-run pacer snapshot records `codex_exec`, `status_running`,
   `fresh_running`, `effective_running`, `queued`, `reserve`, `blocks`, and
   `needed`.
5. If `blocks > 0`, only block remediation is queued; if `blocks=0`, only
   gate-checked backlog or reserve replenishment is queued.
6. `git diff --check` passes.

Blocked or unknown today: W8 validation reports and W7 alpha-readiness outputs
were not present in this branch during W9-h inspection, so this note cannot
claim integration-level readiness.

## Operator Runbook

Use this sequence when capacity appears idle:

1. Check real worker capacity:
   `pgrep -af 'codex exec|/usr/bin/codex|@openai/codex'`.
2. Check async state:
   `find inbox -mindepth 2 -maxdepth 2 -name STATUS.json -print`.
3. Check block files:
   `find outbox/_blocks -maxdepth 1 -type f -name '*.block' -print`.
4. Check pacer snapshot:
   `tail -80 /home/oakir/.local/state/bsebench-async-watchdog/pacer.log`.
5. Check supervisor freshness:
   `tail -120 /home/oakir/.local/state/bsebench-async-watchdog/supervisor-10h.log`.
6. If no block exists, run pacer dry-run first:
   `bash scripts/cto-autonomy-pacer.sh --dry-run`.
7. If a block exists, preserve it and queue/inspect remediation. Do not delete
   the block unless the cause is fixed and the unblock record is written.

## Validation

- Inspected pacer, watchdog, supervisor, and probe scripts for capacity,
  queueing, block, reserve, stale-status, and log-silence thresholds.
- Inspected incident and memory notes listed above.
- `git diff --check`: passed on 2026-05-07 in this worktree.
