# CTO bootstrap — launch `cto-daemon.sh` on France PC

> **Architecture revised 2026-05-06 23:50 UTC** : the original "paste a prompt into codex interactive and let it loop" design did NOT work — codex interactive runs one turn per user input, never auto-polls. Replaced with the proven shell-while-loop pattern (mirrors `chef-daemon.sh`).

## What the CTO is now

`scripts/cto-daemon.sh` — a standalone shell daemon that :
1. Polls `cto/INBOX/CEO_DIRECTIVE_*.md` every 90 s.
2. Health-checks worker + chef daemons (`pgrep`), auto-relaunches on death.
3. Spawns `codex exec` ONLY when there's real work (a pending directive OR a missing daemon).
4. Writes `cto/OUTBOX/CTO_REPORT_<iso>.md` (or CTO_QUERY / CTO_INCIDENT) per directive.
5. Loops forever (subject to WSL2 reap, but with self-respawn on its own SHA change).

## One-time launch — copy-paste into a WSL2 terminal on France PC

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-async-codex
git pull origin main

# Sanity : workers + chef should already be alive (otherwise CTO will see and
# auto-restart on first tick — non-destructive)
pgrep -af 'worker-daemon|chef-daemon'

# Launch cto-daemon
nohup stdbuf -oL -eL bash scripts/cto-daemon.sh > ~/.async-cto.log 2>&1 &
disown

sleep 5
pgrep -af 'cto-daemon'
tail -15 ~/.async-cto.log
```

That's it. No prompt to paste, no codex session to keep alive — `nohup` + `disown` detaches the daemon from the terminal. WSL2 will only reap it if **all** terminals close (≥ 1 active terminal keeps the WSL distro alive).

## Verifying steady state

After ~3 min, check :
```bash
ls /mnt/c/doctorat/bsebench-org/bsebench-async-codex/cto/OUTBOX/
tail -30 ~/.async-cto.log
```

You should see :
- Tick log lines with `cto: tick start` / `cto: tick done` every 90 s
- If any pending CEO_DIRECTIVE existed, a CTO_REPORT_*.md (or CTO_INCIDENT/QUERY) appeared in OUTBOX
- If any daemon was missing, a CTO_INCIDENT_*.md auto-recovery log

## Stop / restart

Stop : `pkill -f cto-daemon.sh` (the running-state file `~/.async-cto-daemon.running` will be left behind ; harmless).
Restart : same launch command. Self-respawn handles future script updates : when `git pull` brings a new SHA, the daemon `exec`s itself with the new version on next tick.

## Why no codex-interactive layer anymore

Original idea : a long-running codex interactive session = "the CTO" + auto-poll loop inside. Empirically false — codex interactive blocks waiting for stdin between turns. There is no documented continuous-mode flag for codex CLI 0.129.0-alpha.7.

Pattern A (shell-while-loop calling codex exec per tick) is the only working primitive. cto-daemon.sh implements it. The CEO/CTO communication protocol via git INBOX/OUTBOX is unchanged.

## Persistence — same constraints as worker / chef

V1 : keep ≥ 1 WSL2 terminal alive. Daemons survive terminal closures EXCEPT when the last terminal closes (then WSL distro is reaped after ~10 min idle).

V2 (TODO) : Windows Task Scheduler running `wsl.exe -d Ubuntu -- bash -c "/mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/launch-all-daemons.sh"` on boot + interval keepalive task hitting `wsl.exe echo .` every 5 min.

## What the user paste step looked like (DEPRECATED — do not use)

Old version of this file asked user to paste a prompt block into codex interactive. That doesn't work. The 2-line `nohup` launch above replaces it.
