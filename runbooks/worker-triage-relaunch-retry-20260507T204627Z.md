# GLASSBOX Worker Triage And Relaunch Retry Runbook

- Artifact: `runbooks/worker-triage-relaunch-retry-20260507T204627Z.md`
- Worker: W4-03
- Branch: `phase-8-3-c-retry-worker-triage-runbook-20260507T204627Z`
- Sample time: `2026-05-07T22:49:15+02:00`
- Scope: CTO validation, integration, and anti-hallucination hardening only.

## Objective

Retry and complete the worker triage/relaunch runbook that previously stopped on
a usage-limit error. This artifact defines how to classify stale or failed
workers, when to relaunch, when to preserve evidence without retrying, and how
to keep a falsifiable reserve backlog without making scientific or benchmark
performance claims.

## Evidence Inspected

| Evidence | Path or command | Result used |
| --- | --- | --- |
| Current branch and worktree state | `git status --short --branch` | Branch matched the assigned retry branch; clean before this file was added. |
| Phase 8 manual log inventory | `find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-*.log'` | Live inventory contained 70 Phase 8 logs at sampling time: 24 wave0, 12 wave1, 12 wave2, 22 wave3/retry. |
| Original usage-limit failures | `rg -n "^ERROR: You've hit your usage limit" .../manual-phase-8-2-*.log` | Original failed logs were `phase-8-2-j`, `phase-8-2-k`, and `phase-8-2-l`, each ending at lines 44-45 with the usage-limit error. |
| Additional retry pressure | Same usage-limit search across all Phase 8 logs | Several later `phase-8-3-*` logs also contained direct usage-limit lines; treat these as capacity failures until a later final summary proves otherwise. |
| Watchdog script | `sed -n '1,240p' scripts/cto-watchdog-10min.sh` | Audit-only; warns `queued` and `needs_fix` after 20 minutes, `running` after 120 minutes, and reports backlog guard state. |
| Supervisor script | `sed -n '1,260p' scripts/cto-supervisor-10h.sh` | Runs every 600 seconds by default, warns below 2 unique `codex exec` workdirs, and warns on silent watched logs after 1200 seconds. |
| Pacer script | `sed -n '1,920p' scripts/cto-autonomy-pacer.sh` | Maintains `MIN_RUNNING=2`, `MIN_QUEUED=1`, `MIN_RESERVE=6`, `MAX_QUEUE_PER_TICK=3`, stale running threshold 180 minutes, block remediation cooldown 30 minutes, and replenishment cooldown 12 hours. |
| Worker daemon and remote worker | `sed -n '1,620p' scripts/worker-daemon.sh scripts/remote-worker.sh` | Worker has per-worker locks, stale git lock cleanup, hard wallclock timeout, error trap, branch push, outbox summary, and final `done` or `error` status update. |
| Live supervisor/watchdog/pacer tails | `tail -220/260 .../{supervisor-10h.log,watchdog.log,pacer.log}` | Two statuses were still `running`, no queued items, no blocks, reserve reported 0, and `phase-7-10-l` was warning-stale at 152 minutes in watchdog output. |
| Async inbox status mirror | `find .../inbox -name STATUS.json | jq ...` across the three async clones | Each clone reported 55 done, 9 error, and 2 running statuses. |

## Commands Run

```bash
git status --short --branch
rg --files | rg '(^|/)(watchdog|supervisor|runbooks|scripts|tools|bin|.github)'
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-*.log' | wc -l
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-*.log' -printf '%f\n'
rg -n "^ERROR: You've hit your usage limit" /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-*.log
sed -n '1,240p' scripts/cto-watchdog-10min.sh
sed -n '1,260p' scripts/cto-supervisor-10h.sh
sed -n '1,920p' scripts/cto-autonomy-pacer.sh
sed -n '1,620p' scripts/worker-daemon.sh scripts/remote-worker.sh
tail -220 /home/oakir/.local/state/bsebench-async-watchdog/supervisor-10h.log
tail -260 /home/oakir/.local/state/bsebench-async-watchdog/watchdog.log
tail -220 /home/oakir/.local/state/bsebench-async-watchdog/pacer.log
```

Final whitespace validation is recorded in the validation section.

## Findings

| ID | Status | Finding | Operational effect |
| --- | --- | --- | --- |
| F1 | PASS | The original incomplete set is identifiable and bounded: `phase-8-2-j`, `phase-8-2-k`, and `phase-8-2-l` stopped on usage-limit lines, not on a code validation failure. | These should be retried or explicitly accounted for as capacity failures; do not classify them as scientific or implementation failures. |
| F2 | PASS | The watchdog is audit-only and does not mutate worker state. | It is safe as evidence for stale threshold detection, but it cannot by itself relaunch or repair workers. |
| F3 | PASS | `remote-worker.sh` preserves crash evidence through `STATUS.json`, `SUMMARY.md`, `run.log.tail`, exit codes, branch SHA, and push result. | Relaunch decisions should cite these files instead of replaying from memory. |
| F4 | AMBER | Live state showed 2 running statuses, 0 queued, 0 reserve, and 0 unique `codex exec` workdirs in the supervisor, while watchdog still saw daemon processes. | Capacity is not healthy enough to queue broad new work; triage stale running items before launching additional waves. |
| F5 | AMBER | `phase-7-10-l-stats-hinf-fragility-threshold-calibration` was 152 minutes old in watchdog output, past the 120-minute warning threshold but below the pacer 180-minute stale cutoff. | If it crosses 180 minutes without matching active `codex exec` evidence, mark it stale and requeue or classify according to the policy below. |
| F6 | FAIL | Reserve backlog was 0 while the pacer reported replenishment already open or inside cooldown. | The reserve policy is not currently satisfied; keep relaunches limited to recovery and do not start discretionary Phase 8 expansion until reserve is restored. |
| F7 | FAIL | Multiple later `phase-8-3-*` logs contain direct usage-limit lines. | Usage-limit retry pressure is still active; repeated retry loops can burn capacity without producing GLASSBOX artifacts. |

## Stale Thresholds

Use these thresholds consistently in operator summaries and relaunch decisions:

| State | Warning threshold | Stale threshold | Evidence required before action |
| --- | ---: | ---: | --- |
| `queued` | 20 minutes | 60 minutes or 2 supervisor ticks with worker daemons alive | `STATUS.json`, daemon pids, worker log mtime, absence or presence of block files. |
| `needs_fix` | 20 minutes | 60 minutes | `CHEF_VERDICT.md`, `PANEL_CHECK.md`, `ADVISOR_CHECK.md` when present, plus target branch state. |
| `running` | 120 minutes | 180 minutes | `STATUS.json ts_started`, active `codex exec` process for the workdir, manual log mtime, and target branch/worktree state. |
| watched log silence | 20 minutes | 60 minutes if paired with no active worker process | Supervisor `WARN_SILENT_LOG`, process table, and latest `run.log.tail`. |
| git lock | 15 minutes | 30 minutes if no git process references the repo | `.git/index.lock` mtime and `ps` scan; `remote-worker.sh` already has stale lock cleanup. |
| usage limit | immediate | repeated after one scheduled retry | Direct `ERROR: You've hit your usage limit` line and reset time in the log. |

The stale decision must not be based on age alone. A `running` item with an
active `codex exec` process and a moving log remains running; a `running` item
without a matching process after the stale threshold is an orphan candidate.

## Relaunch Policy

1. Preserve first failure evidence.
   Do not overwrite the original log, `STATUS.json`, `SUMMARY.md`, or
   `run.log.tail`. If relaunching, use a new branch or phase id with
   `retry-<n>` or a timestamp suffix.

2. Classify before relaunch.
   Use one of these labels in the relaunch note: `usage-limit`,
   `orphan-running`, `queued-stale`, `push-failed`, `worker-crash`,
   `blocked-by-verdict`, or `validation-failed`.

3. Usage-limit handling.
   If a log ends with the direct usage-limit error, mark the attempt as
   capacity-failed and wait until the reset time in the log before retrying.
   Relaunch once with the same owned write-set and a narrower command plan. If
   the retry also hits usage limits, stop relaunching automatically and record
   the task as accounted capacity debt for manual scheduling.

4. Orphan-running handling.
   If `running` exceeds 180 minutes and no matching `codex exec` workdir or
   moving log exists, write a triage note that cites `STATUS.json`, process
   scan, log mtime, and target worktree. Requeue as a new retry only when the
   target write-set is still unmodified or the partial branch has been inspected
   and explicitly carried forward.

5. Queued-stale handling.
   If `queued` exceeds 20 minutes, first verify daemons and locks. If workers
   are absent, restart the relevant worker daemon. If workers are present but
   the queue is not draining by 60 minutes, inspect for git push races, block
   files, malformed frontmatter, or a target branch that is already claimed.

6. Block handling.
   When `outbox/_blocks/*.block` exists, pause normal scientific queueing. Queue
   at most one block-remediation task per cooldown window and require a
   falsifiable unblock note before deleting any block.

7. Duplicate-branch guard.
   Before relaunch, check local and remote refs for the target branch. Do not
   queue a new worker against a branch that already exists unless the runbook
   explicitly names it as a retry that will inspect and extend that branch.

8. Scope guard.
   A retry may write only its assigned write-set. For this W4-03 run, that
   means only this runbook path.

## Reserve Backlog Policy

- Required steady state: at least 2 effective running workers, at least 1 queued
  item, and at least 6 unqueued reserve BRIEFs.
- Queue cap: no more than 3 new items per pacer tick.
- Reserve count must exclude BRIEFs with `QUEUED.json`, existing inbox entries,
  or already-claimed target branches.
- If reserve is below 6, queue exactly one backlog replenishment task unless one
  is queued, running, needs_fix, or inside the 12-hour cooldown.
- If reserve is 0 and usage-limit errors are active, prioritize cheap CTO audit
  or recovery tasks over expensive code-worker tasks until reserve is restored.
- Do not use stale `running` statuses as effective capacity once they pass the
  180-minute stale threshold without active process evidence.

## Recommended Triage Order

1. Freeze the Phase 8 ledger at the current sample time before launching more
   retries, because the log count is live and has already moved beyond the
   original 48-log state.
2. Account for the three original usage-limit failures:
   `phase-8-2-j`, `phase-8-2-k`, `phase-8-2-l`.
3. For each retry log with direct usage-limit lines, check whether a later final
   summary exists. If not, classify it as capacity-failed and do not retry again
   until after the reset window.
4. Inspect `phase-7-10-l` when it crosses 180 minutes or immediately if no
   active `codex exec` process can be tied to it.
5. Restore reserve backlog to at least 6 before launching non-recovery work.
6. Run `git diff --check` before every recovery commit.

## Pass/Fail Decision

Runbook artifact: PASS after `git diff --check` passes.

Operational state at sampling: FAIL for reserve backlog health and AMBER for
stale-running risk. This is not a scientific failure and not a benchmark-result
failure; it is an execution-capacity and orchestration hygiene issue.

## Residual Risks

- The watchdog directory is live. Counts and tails can change during this
  artifact's lifetime; future operators must resample before acting.
- The three async clones reported matching status counts, but local untracked
  outbox files existed in `/mnt/c/doctorat/bsebench-org/bsebench-async-codex`;
  this artifact did not touch or stage those unrelated files.
- Direct usage-limit lines in later retry logs show capacity pressure, but each
  branch still needs its own final summary or `STATUS.json` check before merge
  readiness can be inferred.
- No script changes were made, so this runbook cannot enforce the policy by
  itself.

## Explicit Non-Claims

- This artifact makes no SOTA, novelty, leaderboard, breakthrough, or verified
  scientific claim.
- This artifact does not claim any SOC/SOH method, estimator, observer, ECM,
  Kalman filter, AI estimator, or hybrid method is better than another.
- This artifact does not validate external datasets, benchmark scores, or
  public-release readiness.
- This artifact does not edit thesis files, manuscript files, claim registry
  files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap.

## Validation

| Command | Status | Notes |
| --- | --- | --- |
| `git diff --check` | PASS | Completed with no output after this file was written. |
