# One-time setup on the remote PC (France personal PC)

> Run these once. After that, the worker runs every 60 s via cron / Task Scheduler.

## Prerequisites

- `git` (any version ≥ 2.30)
- `bash` (Git Bash on Windows, native bash on Linux/macOS)
- `jq` (`apt install jq` / `brew install jq` / `choco install jq`)
- `flock` (built-in on Linux ; on Windows Git Bash it ships with the standard install ; on macOS install via `brew install flock`)
- `codex` CLI ≥ 0.129.0-alpha.7 (`npm install -g @openai/codex@0.129.0-alpha.7`)
- GitHub credentials configured for `git push` (HTTPS PAT or SSH key) for `bsebench-org/*` repos
- OpenAI API key for codex (set in `~/.codex/auth.json` after `codex login`, or via env var)

## 1. Clone target repos

```bash
mkdir -p ~/doctorat/workspace/bsebench-org
cd ~/doctorat/workspace/bsebench-org
git clone https://github.com/bsebench-org/bsebench-datasets.git
# add other target repos here as phases require :
# git clone https://github.com/bsebench-org/bsebench-runner.git
# git clone https://github.com/bsebench-org/bsebench-filters.git
```

## 2. Clone this orchestration repo

```bash
cd ~
git clone https://github.com/bsebench-org/bsebench-async-codex.git
chmod +x bsebench-async-codex/scripts/remote-worker.sh
```

## 3. Configure codex

```bash
codex --version           # should be ≥ 0.129.0-alpha.7
codex login               # interactive — provide your OpenAI API key when prompted
# OR set OPENAI_API_KEY env var system-wide

# Verify writes work via the bypass flag :
mkdir -p /tmp/codex-canary
codex exec --dangerously-bypass-approvals-and-sandbox -C /tmp/codex-canary \
  "Create a 1-line file canary.txt with the text 'hello'. Use apply_patch." \
  < /dev/null
ls /tmp/codex-canary/   # should now contain canary.txt
```

If the canary fails, see `~/.claude/projects/<project>/memory/reference_codex_cli_windows_bug.md` (Phase 6.6.b notes) for the regression workaround.

## 4. Register the worker

```bash
cd ~/bsebench-async-codex
cat > workers/france-personal.json <<EOF
{
  "worker_id": "france-personal",
  "owner": "Oussama Akir",
  "os": "$(uname -s)",
  "target_repos": ["bsebench-datasets"],
  "registered_at": "$(date -Iseconds)",
  "git_user_name": "$(git config --global user.name)",
  "git_user_email": "$(git config --global user.email)"
}
EOF
git add workers/france-personal.json
git commit -m "chore(workers): register france-personal worker"
git push origin main
```

## 5. Configure cron (Linux/macOS)

```bash
( crontab -l 2>/dev/null ; \
  echo "* * * * * cd $HOME/bsebench-async-codex && WORKER_ID=france-personal ASYNC_REPO=$HOME/bsebench-async-codex bash scripts/remote-worker.sh >> $HOME/.async-worker.log 2>&1" \
) | crontab -
```

Verify : `crontab -l | grep remote-worker.sh`

Tail the worker log :

```bash
tail -f ~/.async-worker.log
```

## 5-bis. Configure Task Scheduler (Windows)

Open PowerShell as Admin and create a scheduled task that runs every 1 minute :

```powershell
$action = New-ScheduledTaskAction -Execute "C:\Program Files\Git\bin\bash.exe" `
  -Argument "-c 'cd ~/bsebench-async-codex && WORKER_ID=france-personal ASYNC_REPO=$HOME/bsebench-async-codex bash scripts/remote-worker.sh >> $HOME/.async-worker.log 2>&1'"
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) `
  -RepetitionInterval (New-TimeSpan -Minutes 1) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledTask -TaskName "BSEBenchAsyncCodexWorker" `
  -Action $action -Trigger $trigger -RunLevel Highest -User $env:USERNAME
```

## 6. Smoke test

After the worker is registered + cron/Task Scheduler is running, the chef will queue a small canary phase ("phase-async-canary") with a trivial brief. Within ≤ 60 s the worker should pick it up, write `outbox/phase-async-canary/SUMMARY.md` with status `done`, and push back. Chef confirms the round-trip via git pull.

If the canary fails : check `~/.async-worker.log` for the error, fix, reset STATUS to `queued`, and the next cron tick retries.

## Failure modes already accounted for

| Symptom | Likely cause | Fix |
|---|---|---|
| `flock` exits silently | another worker tick still running | normal — bail and retry next tick |
| jq errors | malformed STATUS.json | the worker writes `error` status with exit code -1 |
| codex exit 124 | `timeout` killed it (wallclock cap hit) | adjust `hard_wallclock_min` in the brief |
| git push rejected | branch already pushed by another worker | worker re-pulls on next tick |
| `target_repo` not on disk | the path in BRIEF.md doesn't match remote layout | chef must align paths with the remote's filesystem before queuing |

## Stopping the worker

Linux/macOS : `crontab -l | grep -v remote-worker.sh | crontab -`

Windows : `Unregister-ScheduledTask -TaskName "BSEBenchAsyncCodexWorker" -Confirm:$false`
