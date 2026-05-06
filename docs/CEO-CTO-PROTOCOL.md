# CEO ↔ CTO protocol — communication via git commits

## Roles

- **CEO** = claude-TN running on the Tunisia PC. Owns roadmap, scientific phases, scope locks, panel verdicts, advisor calls, blocking emails.
- **CTO** = codex CLI interactive on the France PC. Owns daemon lifecycle, process supervision, log inspection, infra incidents, freelance-dev BRIEF dispatch.
- **Freelance devs** = codex exec invocations spawned by worker-daemon, processing `inbox/<phase>/BRIEF.md`. Stateless. Ship + leave.

## Channel — git only

CEO and CTO **never share a process**. They communicate by writing markdown files to `cto/INBOX/` and `cto/OUTBOX/`, committing, pushing.

```
claude-TN  ──write──>  cto/INBOX/CEO_DIRECTIVE_<iso>.md  ──push──> github
                                                                        │
                                                                        ▼
                                                                CTO `git pull` polls
                                                                        │
                                                                        ▼
                                  CTO acts (pkill, nohup, queue BRIEF, etc.)
                                                                        │
                                                                        ▼
CTO  ──write──>  cto/OUTBOX/CTO_REPORT_<iso>.md  ──push──> github
                                                                        │
                                                                        ▼
                                                                claude-TN reads OUTBOX
```

**Never** :
- claude-TN never `pkill`s on France PC (no SSH, no remote shell).
- CTO never edits `docs/RESEARCH-ROADMAP-2026-05-06.md` or queues new research phases.
- Either side never modifies the other's INBOX/OUTBOX entries (append-only).

## Iso-timestamp matching

The `<iso>` in `CEO_DIRECTIVE_<iso>.md` and `CTO_REPORT_<iso>.md` MUST match. Pattern :

```
YYYYMMDDTHHMMSSZ      e.g. 20260506T235959Z
```

CEO generates the iso when writing the directive. CTO reuses the same iso when writing the report. Mismatched isos break the pairing — CTO must reject and write `CTO_INCIDENT_<iso>.md` instead.

## Directive priority semantics

| Priority | Meaning | CTO SLA |
|---|---|---|
| `urgent` | infra is down, blocking all work | act within 5 min, before any other directive |
| `normal` | routine ops (queue BRIEF, restart daemon) | act within 1 poll cycle (~90 s) |
| `low` | informational, batch-able | act within next hour or batch with next normal |

## CEO routine usage

Typical claude-TN session :

1. Wake on cron `944a949d` (every 30 min, `12,42 * * * *` UTC).
2. `git pull origin main` on async-codex repo.
3. List `cto/OUTBOX/` for new `CTO_REPORT_*` since last seen.
4. Read reports → updates HISTORY.md → decides next move.
5. If decisions require infra change : write `cto/INBOX/CEO_DIRECTIVE_<iso>.md`, commit + push.
6. Sleep until next cron tick.

claude-TN does NOT poll for CTO_REPORT freshness in real time. The 30-min cron is the natural cadence. If a CTO_REPORT signals BLOCK, claude-TN's email (V1 outbox/_emails_pending/) handles user notification.

## CTO routine usage

Typical codex CLI session on France PC :

1. Loop forever (90 s interval).
2. `git pull --rebase origin main`.
3. `ls cto/INBOX/CEO_DIRECTIVE_*.md` — find any without matching CTO_REPORT.
4. For each new directive : read, act, write report, commit + push.
5. Health-check daemons : `pgrep -af 'worker-daemon|chef-daemon'`. Auto-restart any missing.
6. Tail-check logs : if error patterns surface, write `CTO_INCIDENT_<iso>.md` proactively.

## Allowed CEO directive types

| Type | CEO use case |
|---|---|
| `daemon-restart` | force restart all daemons (e.g., after WSL2 reap) |
| `daemon-config-change` | new env var, new model, new flag |
| `queue-freelance-dev` | dispatch ad-hoc dev BRIEF (not a research phase) |
| `kill-stuck-codex` | a codex exec hung > 60 min, terminate it |
| `report-status` | full snapshot of daemons + locks + inbox/outbox |
| `archive-cleanup` | move old completed phases out of inbox/outbox |
| `escalate-block` | claude-TN seen email block in outbox/_blocks/, ask CTO to diagnose |

## Allowed CTO report types

| Type | When CTO writes |
|---|---|
| `CTO_REPORT_<iso>` | normal reply to a CEO directive |
| `CTO_INCIDENT_<iso>` | proactive : infra event without CEO directive (daemon died, codex hung, push race resolved, etc.) |
| `CTO_QUERY_<iso>` | CEO directive ambiguous, asks for clarification before acting |
| `CTO_BOOTSTRAP_<iso>` | one-time after pasting the bootstrap prompt |

## Conflict resolution

If CEO writes a directive that CTO believes is wrong (e.g., would destroy queued work) :

1. CTO writes `CTO_QUERY_<iso>.md` explaining the concern.
2. CTO does NOT act on the directive.
3. Next claude-TN poll reads the QUERY, replies with a new directive (revised or confirmed).
4. CTO acts on the revised directive only.

This is the only allowed back-pressure mechanism.

## Enabling the cron `944a949d` for CEO usage

claude-TN's cron `944a949d` (existing) fires `<<chef-poll-15min>>` directive every 15 min (configured `12,42 * * * *`, ~30 min). On wake, claude-TN runs steps 2-6 of "CEO routine usage" above. This replaces the prior chef-daemon-internal kaizen+panel+advisor cascade for cases where CTO has already merged + validated. Eventually claude-TN may shrink the cron to once / hour as CTO matures.

## Failure modes — full table

| Failure | Detection | Resolution |
|---|---|---|
| CTO codex session reaped (WSL2 idle timeout) | claude-TN sees no CTO_REPORT for > 30 min while INBOX has unanswered directives | claude-TN's next email-out tells user "re-bootstrap CTO on France PC" |
| Push race (CEO and CTO commit at same time) | `git push` rejected on either side | retry with `git pull --rebase && git push`. Worker / chef use the same pattern. |
| Directive wrongly formatted | CTO can't parse | CTO writes `CTO_QUERY_<iso>.md` with parse error |
| Directive iso clashes with existing | CTO sees 2 `CEO_DIRECTIVE_<iso>.md` with same iso | CTO acts on git timestamp order, mentions in CTO_REPORT |
| GitHub down | neither side can push | each retries with backoff. Worker-daemon already has retry. |

## Why this protocol over a synchronous channel

- **Async by construction** : CEO can sleep 30 min between checks ; CTO doesn't block.
- **Audit trail in git history** : every directive + report is a commit, signed (eventually), GLASSBOX-tagged.
- **No new infra** : leverages github + git pull/push already in the worker pipeline.
- **Survives PC reboots** : git is the only persistent state. Either side can crash and recover by reading INBOX/OUTBOX.
- **Scales to multi-CTO** : if a Tunisia PC also runs codex one day, two CTOs share the channel without coordination protocol changes.

## When to escalate beyond this protocol

| Trigger | Escalation |
|---|---|
| Both CEO and CTO are wrong about the same thing | inline user (claude-TN writes outbox/_emails_pending/<iso>-block-protocol-conflict.eml) |
| Infrastructure damage (data loss, force-push to main) | emergency : claude-TN writes `_blocks/protocol.block` and emails user |
| CTO repeatedly fails to act on directives within SLA | claude-TN escalates to user via email after 3 consecutive missed SLAs |
