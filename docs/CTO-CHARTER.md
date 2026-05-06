# CTO charter — codex CLI persistent on France PC

## Role

The CTO is a **codex CLI interactive session running 24/7 on the France PC** (subject to WSL2 alive). It has direct visibility on the local infrastructure (processes, logs, files, daemons) that claude-TN (CEO) does NOT have.

## Authority

The CTO can :
- `pgrep` / `pkill` / `nohup` worker-daemon, chef-daemon, codex exec processes.
- `tail` / `cat` daemon logs in real time.
- Inspect `~/.codex/`, `~/.async-*.log`, `/tmp/codex-async-*.lock`.
- Restart daemons when they die (inside WSL2).
- Queue **freelance dev BRIEFs** into `bsebench-async-codex/inbox/` to dispatch ad-hoc code work to other codex exec instances (which become "freelance devs").
- Read `cto/INBOX/CEO_DIRECTIVE_<iso>.md` files written by claude-TN, act on them.
- Write `cto/OUTBOX/CTO_REPORT_<iso>.md` files for claude-TN to read.
- Resolve infrastructure incidents without claude-TN involvement (daemon crash, lock files orphaned, push race resolution, etc.).

The CTO **CANNOT** :
- Modify the strategic roadmap (`docs/RESEARCH-ROADMAP-2026-05-06.md`) — that's CEO's call.
- Add new research phases to inbox (CEO queues those — CTO can only queue infrastructure / merge-validate / freelance-dev BRIEFs).
- Bypass GLASSBOX commit format or the no-Co-Authored-By-Claude rule.
- Make scientific decisions (claim verification, hypothesis selection).

## Tooling

> **Revised 2026-05-06 23:50 UTC**: original design was "codex interactive long-running session". Empirically broken — codex interactive does not auto-poll. Replaced with the shell-while-loop pattern (mirrors `chef-daemon.sh`).

The CTO is `scripts/cto-daemon.sh` — a shell daemon that loops every 90 s, performs cheap shell health-checks, and spawns `codex exec` ONLY when there's real work (a pending CEO_DIRECTIVE OR a missing daemon). Each `codex exec` invocation is stateless ; persistent state lives in git (cto/INBOX, cto/OUTBOX, ~/.async-cto-daemon.running).

Launch (one-time on France PC, see `CTO-BOOTSTRAP-PROMPT.md`):
```bash
nohup stdbuf -oL -eL bash scripts/cto-daemon.sh > ~/.async-cto.log 2>&1 &
disown
```

Inside each codex-exec tick the model uses `Bash`, `apply_patch`, `Read`, `Write` tools (full sandbox bypass + `--add-dir` to repos). Memory across ticks is via files in `cto/OUTBOX/` and the running-state file `~/.async-cto-daemon.running`.

## Communication channel — `cto/INBOX/` ↔ `cto/OUTBOX/`

```
bsebench-async-codex/
├── cto/
│   ├── INBOX/
│   │   ├── CEO_DIRECTIVE_<iso>.md   ← claude-TN writes
│   │   └── ...
│   └── OUTBOX/
│       ├── CTO_REPORT_<iso>.md      ← CTO writes
│       └── ...
```

**Polling cadence** : CTO polls `cto/INBOX/` every 60-120 seconds (its own loop). When a new `CEO_DIRECTIVE_*.md` file appears that has no matching `CTO_REPORT_*.md`, CTO reads it, acts, writes report, commits + pushes.

## CEO_DIRECTIVE format

```markdown
# CEO directive <iso>

[role: claude-TN]
Priority : <urgent | normal | low>

## Goal
<1-2 sentences : what the CEO wants done>

## Context
<optional, 2-5 lines : why now, prior incident, etc.>

## Action requested
<concrete asks : restart daemons, kill stuck codex, queue X dev BRIEF, report N state, etc.>

## Reporting
<what CTO should write back in CTO_REPORT_<iso>.md>
```

## CTO_REPORT format

```markdown
# CTO report for CEO_DIRECTIVE_<iso>

[role: cto-FR]
Generated at : <iso>
Acted on directive : CEO_DIRECTIVE_<iso>.md

## Actions taken
- <bullet 1>
- <bullet 2>

## State observed
- <ps output summary>
- <log tail relevant>
- <inbox/outbox status>

## Issues / blockers
<empty if none>

## Next freelance dev dispatched
<list of BRIEFs queued by CTO if any>
```

## Freelance dev BRIEFs

When CTO needs code work done (rare for infra ; happens for "fix this script" or "add this small helper"), it queues a BRIEF in the standard `bsebench-async-codex/inbox/<phase-id>/`. Worker daemon picks it up. Codex exec runs as freelance dev. Worker writes outbox. CTO sees outbox, includes in next report.

## Failure modes

| Failure | CTO action |
|---|---|
| Worker daemon dies | pkill stale + nohup relaunch |
| Chef-daemon dies | pkill stale + nohup relaunch (with stdbuf wrapper) |
| codex exec hangs > 60 min | pkill -9 specific PID, mark phase=error, write outbox SUMMARY for the dead phase |
| WSL2 process reap (all daemons gone) | full relaunch sequence, write CTO_INCIDENT_<iso>.md to OUTBOX explaining |
| CEO directive ambiguous | write CTO_REPORT with "AMBIGUOUS, please clarify" + specific questions |

## Persistence

V1 (current) : user keeps ≥ 1 WSL2 terminal alive. cto-daemon (along with worker, chef) survives terminal closures except when ALL terminals close (then WSL distro reaped after ~10 min idle). cto-daemon has self-respawn on its own SHA change (same primitive as chef-daemon).
V2 (future) : Windows Task Scheduler runs `wsl.exe -d Ubuntu -- bash -c "/path/to/launch-all-daemons.sh"` on boot + a 5-min `wsl.exe echo .` keepalive task to prevent idle reap.

## Why this architecture

CEO (claude-TN) provides strategy + roadmap + roadmap-edits. Doesn't need to know which PID died.
CTO (codex on France PC) executes. Has local visibility. Doesn't need to know what Phase 11 is in the research roadmap.
Freelance devs (codex exec via worker) ship features. Don't need state across runs.

Each layer has the right scope. claude-TN tokens go to strategy. CTO tokens go to ops. Freelance dev tokens go to features. Total : codex saturated, claude-TN minimal, no double-supervision waste.
