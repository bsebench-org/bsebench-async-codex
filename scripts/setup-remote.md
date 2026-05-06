# One-time setup on the remote PC

> Run these once. After that, the worker runs every 60 s via cron / Task Scheduler. The chef queues phases by pushing `inbox/<phase-id>/BRIEF.md` ; the worker picks them up and pushes results back.

## Default reference layout (France personal PC, Windows + Git Bash)

```
C:\doctorat\bsebench-org\          (Posix : /c/doctorat/bsebench-org/)
├── bsebench-datasets\
├── bsebench-runner\
├── bsebench-filters\
├── bsebench-async-codex\          (this repo)
├── bsebench-specs\
├── bsebench-stats\
└── _datasets\                     (created by the onboarding dispatch — large raw datasets)
```

If your remote PC uses a different OS or layout, adjust paths in section 5/5-bis below.

## Prerequisites

- `git` (any version ≥ 2.30)
- `bash` (Git Bash on Windows, native bash on Linux/macOS)
- `jq` (`apt install jq` / `brew install jq` / `choco install jq` / Git-Bash includes recent versions)
- `flock` (Linux/macOS native ; Git Bash on Windows ships with `util-linux`'s flock)
- `node` + `npm` (for codex)
- `codex` CLI ≥ 0.129.0-alpha.7 : `npm install -g @openai/codex@0.129.0-alpha.7`
- GitHub credentials configured for `git push` (HTTPS PAT or SSH key) for `bsebench-org/*` repos
- OpenAI API key for codex (set via `codex login`, or `OPENAI_API_KEY` env var)

## 1. Clone all bsebench-org repos under one root

```bash
mkdir -p /c/doctorat/bsebench-org
cd /c/doctorat/bsebench-org

git clone https://github.com/bsebench-org/bsebench-datasets.git
git clone https://github.com/bsebench-org/bsebench-async-codex.git
# add other target repos as phases require :
# git clone https://github.com/bsebench-org/bsebench-runner.git
# git clone https://github.com/bsebench-org/bsebench-filters.git
# git clone https://github.com/bsebench-org/bsebench-specs.git
# git clone https://github.com/bsebench-org/bsebench-stats.git
```

## 2. Make worker script executable

```bash
chmod +x /c/doctorat/bsebench-org/bsebench-async-codex/scripts/remote-worker.sh
```

## 3. Configure codex

```bash
codex --version           # confirm ≥ 0.129.0-alpha.7
codex login               # interactive — paste your OpenAI API key when prompted
                          # (skip if OPENAI_API_KEY is already in env)

# Verify writes work via the bypass flag :
mkdir -p /tmp/codex-canary
codex exec --dangerously-bypass-approvals-and-sandbox -C /tmp/codex-canary \
  "Create a 1-line file canary.txt with the text 'hello'. Use apply_patch." \
  < /dev/null
ls /tmp/codex-canary/   # should now contain canary.txt
```

If the canary fails, see `docs/onboarding-codex.md` §3 ("The bypass flag is not optional on Windows").

## 4. Run the codex onboarding (saves memory + downloads CALCE)

This is the **first interactive dispatch**. Codex reads `docs/onboarding-codex.md` from this repo, persists context to `~/.codex/memories/`, and downloads ~5-10 GB of CALCE zips into `_datasets/`. Wallclock ~30-60 min depending on your bandwidth.

```bash
cd /c/doctorat/bsebench-org

codex exec --dangerously-bypass-approvals-and-sandbox \
  -C /c/doctorat/bsebench-org \
  --add-dir /c/doctorat/bsebench-org/bsebench-datasets \
  --add-dir /c/doctorat/bsebench-org/bsebench-async-codex \
  < /c/doctorat/bsebench-org/bsebench-async-codex/docs/onboarding-codex.md
```

When codex exits, it should print :

```
ASYNC-CODEX ONBOARDING COMPLETE
- memory saved : ~/.codex/memories/bsebench-async-codex-context.md (size: <bytes>)
- CALCE A123 dynamic : <N>/8 zips downloaded
- CALCE INR-20R dynamic : <N>/12 zips downloaded
- log : C:/doctorat/bsebench-org/_datasets/.calce-download-log.txt
- next step : user installs the cron worker per scripts/setup-remote.md, then chef queues phase-async-canary
```

Verify :

```bash
ls ~/.codex/memories/bsebench-async-codex-context.md
ls /c/doctorat/bsebench-org/_datasets/calce_a123_lfp_dynamic/
ls /c/doctorat/bsebench-org/_datasets/calce_inr18650_20R_dynamic/
cat /c/doctorat/bsebench-org/_datasets/.calce-download-log.txt
```

If fewer than 16 / 20 zips downloaded, retry the failed ones manually before proceeding (the worker will not handle these — they are pre-flight data the chef's BRIEFs will assume present).

## 5. Register the worker

```bash
cd /c/doctorat/bsebench-org/bsebench-async-codex
cat > workers/france-personal.json <<EOF
{
  "worker_id": "france-personal",
  "owner": "Oussama Akir",
  "os": "$(uname -s)",
  "target_repos": ["bsebench-datasets"],
  "datasets_root": "/c/doctorat/bsebench-org/_datasets",
  "registered_at": "$(date -Iseconds)",
  "git_user_name": "$(git config --global user.name)",
  "git_user_email": "$(git config --global user.email)"
}
EOF
git add workers/france-personal.json
git commit -m "chore(workers): register france-personal worker"
git push origin main
```

## 5-bis. Multi-worker parallelization (optional, for parallel phase execution)

Since 2026-05-06 the worker-daemon supports multiple instances via different `WORKER_ID` env vars + automatic per-worker lock files (`/tmp/codex-async-worker-${WORKER_ID}.lock`). With Codex Max Pro High subscription (unlimited tokens), launching N workers lets the system process N independent phases in parallel. Phase-claim race (when two workers select the same queued phase) is handled by the existing `git push origin main --quiet` rejection retry pattern : only one worker wins the push, the loser pulls + retries on the next phase.

**Launch 2 workers in parallel** (replace step 6 below) :

```bash
# Worker #1
WORKER_ID=france-personal-1 nohup bash \
  /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/worker-daemon.sh \
  > /mnt/c/doctorat/bsebench-org/.async-worker-1.log 2>&1 &
disown

# Worker #2 (different WORKER_ID = different lock = parallel)
WORKER_ID=france-personal-2 nohup bash \
  /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/worker-daemon.sh \
  > /mnt/c/doctorat/bsebench-org/.async-worker-2.log 2>&1 &
disown

# Optional : Worker #3, #4, etc. — same pattern, different WORKER_ID.

sleep 3
pgrep -af 'worker-daemon.sh|chef-daemon.sh'
```

Constraints :
- Each worker needs a unique `WORKER_ID` (used in lock filename + commit author "started by").
- Chef-daemon is single-instance (only one verifies/merges/emails — no parallelization on the chef side).
- Phases must have ZERO file-overlap to safely parallelize (e.g., 6.10.e modifies adapters/calce_a123_2014.py, 6.10.f modifies adapters/calce_inr_20r_2014.py — different files, parallel-safe).

## 6. Start the worker daemon (recommended — userspace, no sudo, no cron)

The simplest and most portable option. One bash process loops in the background and calls `remote-worker.sh` every 60 s. No `sudo apt install cron`, no `/etc/wsl.conf`, no Task Scheduler.

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts
chmod +x worker-daemon.sh remote-worker.sh

nohup bash worker-daemon.sh > ~/.async-worker.log 2>&1 &
echo "worker daemon started, PID $!"
```

Verify :

```bash
ps -ef | grep worker-daemon.sh | grep -v grep    # should show 1 row
tail -f ~/.async-worker.log                       # tick lines every 60 s
```

To stop :

```bash
pkill -f worker-daemon.sh
```

To auto-start the daemon on every new shell (optional, append to `~/.bashrc`) :

```bash
cat >> ~/.bashrc <<'EOF'

# auto-start bsebench-async-codex worker daemon if not running
if ! pgrep -f worker-daemon.sh > /dev/null 2>&1 ; then
  nohup bash /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/worker-daemon.sh \
    > ~/.async-worker.log 2>&1 &
  disown
fi
EOF
```

This pattern survives WSL2 reboots without `/etc/wsl.conf` ; the next time you open a WSL terminal, the daemon respawns if it's not already running.

## 6-bis. System cron / Task Scheduler (alternative — only if you need the worker to run without ANY shell open)

The userspace daemon (§6) is enough for ~99 % of cases. Use system-level scheduling only if you want the worker to keep running when no WSL2 / Git-Bash / shell session exists at all (e.g., user logged out completely on a server).

### Linux / macOS / WSL2 cron :

```bash
sudo apt install -y cron && sudo service cron start

( crontab -l 2>/dev/null ; \
  echo "* * * * * cd /mnt/c/doctorat/bsebench-org/bsebench-async-codex && WORKER_ID=france-personal ASYNC_REPO=/mnt/c/doctorat/bsebench-org/bsebench-async-codex bash scripts/remote-worker.sh >> /mnt/c/doctorat/bsebench-org/.async-worker.log 2>&1" \
) | crontab -

# WSL2 only : persist cron daemon across WSL2 reboots
sudo bash -c 'cat > /etc/wsl.conf <<EOF
[boot]
command="service cron start"
EOF'
```

### Windows Task Scheduler (PowerShell as Admin) :

```powershell
$bash = "C:\Program Files\Git\bin\bash.exe"
$cmd = "cd /c/doctorat/bsebench-org/bsebench-async-codex && WORKER_ID=france-personal ASYNC_REPO=/c/doctorat/bsebench-org/bsebench-async-codex bash scripts/remote-worker.sh >> /c/doctorat/bsebench-org/.async-worker.log 2>&1"

$action = New-ScheduledTaskAction -Execute $bash -Argument "-c '$cmd'"
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) `
  -RepetitionInterval (New-TimeSpan -Minutes 1) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledTask -TaskName "BSEBenchAsyncCodexWorker" `
  -Action $action -Trigger $trigger -RunLevel Highest -User $env:USERNAME
```

## 7. Smoke test

After the worker is registered + cron/Task Scheduler is running, the **chef** queues `phase-async-canary` with a trivial brief. Within ≤ 60 s the worker should pick it up, write `outbox/phase-async-canary/SUMMARY.md` with status `done`, and push back. The chef confirms the round-trip via `git pull` on bsebench-async-codex.

If the canary fails : check `/c/doctorat/bsebench-org/.async-worker.log` for the error, fix, reset STATUS to `queued`, and the next cron tick retries.

## Failure modes already accounted for

| Symptom | Likely cause | Recovery |
|---|---|---|
| `flock` exits silently | another worker tick still running | normal — bail and retry next tick |
| jq error | malformed STATUS.json | worker writes `error` status with exit code -1 |
| codex exit 124 | `timeout` killed it (wallclock cap hit) | adjust `hard_wallclock_min` in BRIEF.md frontmatter |
| git push rejected from worker | branch already pushed by another worker | worker re-pulls on next tick |
| `target_repo` not on disk | path in BRIEF.md doesn't match remote layout | chef must align paths with remote filesystem before queuing |
| codex session header says `sandbox: read-only` | upstream issue #6667 regression in 0.129-alpha.7 | already handled : worker passes `--dangerously-bypass-approvals-and-sandbox` |

## Stopping the worker

Windows :

```powershell
Unregister-ScheduledTask -TaskName "BSEBenchAsyncCodexWorker" -Confirm:$false
```

Linux/macOS :

```bash
crontab -l | grep -v remote-worker.sh | crontab -
```
