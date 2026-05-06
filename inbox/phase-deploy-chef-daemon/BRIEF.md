---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: deploy/chef-daemon-2026-05-06
base_branch: main
hard_wallclock_min: 5
---

# Deploy chef-daemon on the France PC (one-time setup)

## Mission

A new daemon `scripts/chef-daemon.sh` has landed on origin/main of bsebench-async-codex. It is the autonomous chef counterpart to `scripts/worker-daemon.sh` : polls outbox, verifies gates, merges to main, writes CHEF_VERDICT.md. Eliminates the dependency on Anthropic cloud routine OR Claude Code conversation for chef-side operations.

Your job in this dispatch : install + start the chef-daemon on this PC, side by side with the existing worker-daemon. Add an auto-respawn snippet to ~/.bashrc so the chef-daemon restarts on next shell login if it dies.

## Workspace

The worker provides a worktree of bsebench-async-codex at `<target_repo>-<target_branch>` ; you can use it but most of this work is not in-tree (it's launching processes + editing ~/.bashrc).

## Steps

1. Verify chef-daemon.sh exists in the worktree :
   ```bash
   ls -la /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh
   chmod +x /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh
   ```

2. Confirm the worker-daemon is still alive :
   ```bash
   pgrep -af worker-daemon.sh
   ```
   It should show 1 row (the existing daemon since 12:07).

3. Launch chef-daemon (different flock from worker — they coexist) :
   ```bash
   nohup bash /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh \
     > /mnt/c/doctorat/bsebench-org/.async-chef.log 2>&1 &
   disown
   sleep 3
   pgrep -af 'worker-daemon.sh\|chef-daemon.sh'
   ```
   pgrep should now show BOTH daemons.

4. Append auto-respawn snippet to ~/.bashrc (idempotent) :
   ```bash
   if ! grep -q "chef-daemon.sh" ~/.bashrc 2>/dev/null ; then
     cat >> ~/.bashrc <<'EOF'

   # auto-start bsebench-async-codex chef daemon if not running
   if ! pgrep -f chef-daemon.sh > /dev/null 2>&1 ; then
     nohup bash /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh \
       > /mnt/c/doctorat/bsebench-org/.async-chef.log 2>&1 &
     disown
   fi
   EOF
     echo "appended chef-daemon respawn snippet"
   else
     echo "chef-daemon respawn snippet already present"
   fi
   ```

5. Tail both logs briefly to confirm both are ticking :
   ```bash
   tail -5 /mnt/c/doctorat/bsebench-org/.async-worker.log
   echo "---"
   tail -5 /mnt/c/doctorat/bsebench-org/.async-chef.log
   ```

   You should see "tick" lines from worker and "chef-daemon start" + "chef:" lines from chef.

6. **DO NOT commit anything.** This dispatch is purely an install task on the PC. The async repo gets STATUS updates from the worker (which mark this phase done after you finish) but no code change in the worktree.

## Acceptance gates

- **G1** : `pgrep -af 'worker-daemon.sh\|chef-daemon.sh'` shows 2 distinct PIDs.
- **G2** : `tail -5 /mnt/c/doctorat/bsebench-org/.async-chef.log` shows "chef-daemon start" line + recent "chef:" log lines.
- **G3** : `~/.bashrc` contains both auto-respawn snippets (worker + chef).

That's it. Print a short success report at the end :
```
DEPLOY chef-daemon DONE :
- worker-daemon PID : <pid>
- chef-daemon PID : <pid>
- ~/.bashrc respawn : worker-snippet=<present|added>, chef-snippet=<present|added>
- log paths : .async-worker.log, .async-chef.log
- both daemons confirmed ticking via tail
```

After this dispatch lands, the system is fully autonomous : the user closes Claude Code, the cron-cloud routine becomes irrelevant (can be cancelled), and the loop runs on the France PC indefinitely.
