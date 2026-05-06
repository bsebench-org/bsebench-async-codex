# PROTOCOL — async-codex state machine

> The full end-to-end protocol between **chef** (Claude on user's primary PC), **worker** (codex on a remote PC), and **user** (Oussama, owner of both). This is the definitive spec — every other doc in `docs/` and every script in `scripts/` is a concrete realization of one of the steps below.

## Three roles

| Role | Where | What it does |
|---|---|---|
| **chef** | Claude on user's primary PC | Composes BRIEFs from user intent, queues them, polls outbox, re-verifies gates, merges to main, reports to user |
| **worker** | Codex via cron on remote PC (`france-personal`) | Polls inbox, runs codex with bypass-flag, pushes resulting branch on target repo, writes outbox SUMMARY |
| **user** | Oussama | Sets direction at high level ("Phase 6.10 CALCE"), reviews summaries, intervenes only on escalations |

## State machine per phase

```
                                         ┌──────────────────────────────────┐
                                         │ user expresses intent to chef    │
                                         └─────────────┬────────────────────┘
                                                       │
                                                       ▼
                                         ┌──────────────────────────────────┐
                                         │ chef composes BRIEF.md           │
                                         │ + STATUS.json (status=queued)    │
                                         │ + push to bsebench-async-codex   │
                                         └─────────────┬────────────────────┘
                                                       │
                                                       ▼ ≤ 60 s cron tick
                                         ┌──────────────────────────────────┐
                                         │ worker pulls, finds queued phase │
                                         │ marks status=running, pushes     │
                                         └─────────────┬────────────────────┘
                                                       │
                                                       ▼
                                         ┌──────────────────────────────────┐
                                         │ worker creates worktree on       │
                                         │ target_repo from base_branch     │
                                         │ runs codex exec --bypass-flag    │
                                         │ < BRIEF.md                       │
                                         └─────────────┬────────────────────┘
                                                       │
                                                       ▼
                                         ┌──────────────────────────────────┐
                                         │ codex commits on target_branch   │
                                         │ (no push — worker handles it)    │
                                         └─────────────┬────────────────────┘
                                                       │
                                       ┌───────────────┴────────────────┐
                                       │                                │
                              codex exit 0                       codex exit non-0
                                       │                                │
                                       ▼                                ▼
                            ┌──────────────────────┐      ┌──────────────────────┐
                            │ worker pushes branch │      │ worker writes        │
                            │ to target repo       │      │ status=error +       │
                            │ writes SUMMARY +     │      │ run.log.tail +       │
                            │ run.log.tail +       │      │ pushes               │
                            │ status=done +        │      └──────────┬───────────┘
                            │ pushes               │                 │
                            └──────────┬───────────┘                 │
                                       │                              │
                                       └───────────────┬──────────────┘
                                                       │
                                                       ▼ chef polls every 25 min
                                         ┌──────────────────────────────────┐
                                         │ chef pulls, finds done/error     │
                                         │ phase                            │
                                         └─────────────┬────────────────────┘
                                                       │
                                       ┌───────────────┴───────────────┐
                                       │                               │
                                  status=done                     status=error
                                       │                               │
                                       ▼                               ▼
                            ┌──────────────────────┐      ┌──────────────────────┐
                            │ chef fetches branch  │      │ chef reads           │
                            │ on target repo       │      │ run.log.tail         │
                            │ re-runs gates        │      │ classifies failure   │
                            │ (fast tests + ruff)  │      │ per CHEF.md         │
                            └──────────┬───────────┘      └──────────┬───────────┘
                                       │                             │
                              ┌────────┴────────┐                    │
                              │                 │                    │
                          gates green       gates red                │
                              │                 │                    │
                              ▼                 ▼                    ▼
                  ┌──────────────────┐  ┌──────────────────────────────────────┐
                  │ chef merges to   │  │ chef composes fix BRIEF              │
                  │ main, pushes,    │  │ (max 2 retries per phase)            │
                  │ deletes branch,  │  │ OR escalates to user                 │
                  │ writes           │  │ (per CHEF.md retry rules)            │
                  │ CHEF_VERDICT.md  │  └──────────────────────────────────────┘
                  │ = approved,      │
                  │ pushes           │
                  │ updates outbox   │
                  └──────────┬───────┘
                             │
                             ▼
                  ┌──────────────────┐
                  │ chef notifies    │
                  │ user with one-   │
                  │ paragraph status │
                  └──────────────────┘
```

## File contracts

### `inbox/<phase-id>/BRIEF.md`

YAML frontmatter (parsed by worker) :

```yaml
---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-6-10-calce-a123-dyn
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/_datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---
```

Then the body is the actual prompt fed to codex via stdin.

### `inbox/<phase-id>/STATUS.json`

```json
{
  "phase_id": "phase-6-10-calce-a123-dyn",
  "status": "queued",
  "ts_queued": "2026-05-06T10:00:00+02:00",
  "ts_started": null,
  "ts_done": null,
  "exit_code": null,
  "worker_id": null,
  "target_repo": "/mnt/c/doctorat/bsebench-org/bsebench-datasets",
  "target_branch": "phase-6-10-calce-a123-dyn",
  "base_branch": "main"
}
```

### State transitions

| From → To | Trigger | Who writes |
|---|---|---|
| (none) → `queued` | chef pushes BRIEF + STATUS | chef |
| `queued` → `running` | worker takes the lock, marks ts_started | worker |
| `running` → `done` | codex exit 0 + worker push of branch succeeds | worker |
| `running` → `error` | codex exit non-0 OR push fails | worker |
| `done` → `approved` | chef gates pass, merge to main, push | chef |
| `done` → `needs_fix` | chef gates fail | chef |
| `error` → `retried` | chef composes fix BRIEF + queues new phase | chef |
| `*` → `escalated` | retry budget exhausted OR unknown failure | chef |

### `outbox/<phase-id>/SUMMARY.md` (worker-written)

```markdown
# Phase <id> summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 90 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-6-10-calce-a123-dyn
- Branch SHA : abc1234
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-06T11:23:45+02:00

## Tail of codex stdout (last 200 lines)

\`\`\`
[paste]
\`\`\`

## Next step for chef

git fetch origin && git checkout phase-6-10-calce-a123-dyn in target_repo. Verify gates. Merge to main if green.
```

### `outbox/<phase-id>/CHEF_VERDICT.md` (chef-written, after gate re-verification)

```markdown
# Chef verdict for phase-<id>

- Decision : approved | needs_fix | escalated
- Gates re-run on chef PC (fast tests + ruff) : <result>
- Slow tests : skipped (data not on chef PC) | re-run | n/a
- Branch merged to main : abc1234 → main@<sha>
- Followups : <empty | list>
- Notified user at : 2026-05-06T11:35:00+02:00

## Gate evidence

\`\`\`
[paste of test output]
\`\`\`
```

## Concurrency model

- One `flock`-guarded worker per remote PC. Workers identify themselves via `WORKER_ID` env var ; multiple workers across multiple PCs can coexist on different `target_repos`.
- Phases are picked in inbox lexicographic order (so naming with date prefix works as a queue).
- The chef is single-instance — only one Claude session at a time should be polling and writing CHEF_VERDICT.md.
- Lost-update prevention : both chef and worker do `git pull --rebase` before any push, retry on conflict.

## Failure recovery

See `docs/FAILURE-MODES.md` for the full matrix. Quick reference :

| Failure | Recovery |
|---|---|
| codex exit ≠ 0 | chef classifies → fix BRIEF (recoverable) or escalate |
| timeout (codex hung) | exit 124 → escalate, raise hard_wallclock_min in next BRIEF |
| git push from worker fails | next cron tick retries automatically |
| git push from chef fails | chef pulls and retries up to 3 times before escalating |
| BRIEF malformed | worker writes status=error with exit_code=-2 ; chef rewrites BRIEF |
| target_repo missing on worker | exit_code=-3 ; chef tells user to clone the missing repo |

## Commit format — GLASSBOX (mandatory for every actor)

Every commit on `bsebench-async-codex`, `bsebench-datasets`, or any target repo MUST use the glassbox format. The body starts with a `[role: ...]` tag identifying the author actor, followed by Context / Objective / Problem / Result sections. This makes the history forensically readable : at any point in 6 months, you can grep the log and see which actor wrote what, why, and what evidence backs the claim.

### Roles

| Tag | Actor | Where it runs |
|---|---|---|
| `claude-TN` | Claude Opus / Sonnet (the chef on the user's primary PC, Tunisia) | Claude Code conversation |
| `codex-FR` | Codex CLI in interactive mode (rare ; user-driven) | France personal PC, WSL2 |
| `worker-FR` | `remote-worker.sh` automated commits (start, error, done) | France PC, daemon |
| `chef-FR` | `chef-daemon.sh` automated commits (verdict) | France PC, daemon |
| `worker-codex-FR` | `codex exec` dispatched by the worker (the actual feature work) | France PC, sandboxed under bypass-flag |

### Format (full — for substantive commits)

```
<type>(<scope>): <subject — imperative, ≤ 50 chars>

[role: <one of claude-TN | codex-FR | worker-codex-FR | worker-FR | chef-FR>]

## Context
1-3 sentences : what state of the system triggered this work.

## Objective
1-2 sentences : what success looks like for this commit.

## Problem
1-3 sentences : the blocker / bug / requirement / gap being addressed.

## Result
- bullet 1 : concrete deliverable (file added, function changed, etc.)
- bullet 2 : concrete deliverable
- bullet 3 : evidence (test pass count, ruff exit, SHA, bytes-changed, etc.)

Refs:
- <ADR / claim / prior commit / file path / issue link>

Verified-By: <command or empirical signal that supports the Result section>
```

### Format (lite — for daemon auto-transitions)

Status-change commits from `worker-FR` and `chef-FR` are short and templated. They use the lite format :

```
<type>(<scope>): <subject>

[role: <worker-FR | chef-FR>]

<one-line description of the transition + relevant key-value facts>
```

Examples :
- `chore(async): start phase-X on france-personal\n\n[role: worker-FR]\n\nWorker took the lock at 2026-05-06T13:36:06Z, marked phase-X status=running, parsed YAML frontmatter (target_repo=..., target_branch=...).`
- `chore(async): chef verdict approved on phase-X\n\n[role: chef-FR]\n\nGates green (5 fast tests, ruff format/check ok, author OK), merged X@abc1234 -> main, branch deleted.`

### Anti-patterns (these will be flagged in chef verification)

- Missing `[role: ...]` tag.
- Generic body like "Update X" or "Fix bug" without sections.
- `Co-Authored-By: Claude` trailer (project mandate, see CHEF.md §3.4).
- Hidden numerical claims ("12% improvement") without `Verified-By:`.

The chef-daemon's verify step DOES NOT currently enforce the glassbox format (V1 only checks author + Co-Authored-By + scope). V2 will pattern-match the `[role: ...]` tag presence as part of the auto-merge matrix.

## Polling cadences

- worker → bsebench-async-codex : every 60 s (cron).
- chef → bsebench-async-codex : every 25 min (`ScheduleWakeup`).
- chef → bsebench-datasets / other target repos : on-demand (when CHEF_VERDICT.md needs to be written).

## Cross-references

- `docs/CHEF.md` — chef-side autonomous decision rules
- `docs/CONVENTIONS.md` — non-negotiables for codex (sign, cell_id, commit format)
- `docs/FAILURE-MODES.md` — error handling matrix
- `docs/PHASE-LIFECYCLE.md` — end-to-end checklist per phase
- `docs/onboarding-codex.md` — first-run setup for the remote codex
- `scripts/remote-worker.sh` — concrete worker implementation
- `scripts/chef-queue.sh` — concrete chef-queue helper
- `templates/` — reusable BRIEF templates per phase type
