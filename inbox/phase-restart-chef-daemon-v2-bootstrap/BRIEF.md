---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: bootstrap/daemons-v2-respawn-2026-05-06
base_branch: main
hard_wallclock_min: 5
---

# One-time bootstrap : restart BOTH worker-daemon + chef-daemon

## Why this exists (incident learning)

The chef-daemon process on France PC has been running V1.0 code (loaded into bash memory at original launch). All subsequent patches (V1.1 reset-hard, kaizen step, panel/advisor/block, unified email, GLASSBOX role tags, self-respawn, SHA running-state file) exist on disk but the running bash interpreter does not have them. **Result : 4 phases (canary fix-1, 6.10.a fix-1, 6.10.b, 6.10.c) had to be manually merged by claude-TN because chef-daemon kept escalating with the V1 git-checkout bug.**

Self-respawn was added AFTER the daemon was launched → bootstrap chicken-and-egg. Same problem for worker-daemon (V0 launched before self-respawn + chef-monitoring were added).

The structural fix : **worker-daemon now meta-supervises chef-daemon**. After each worker tick, `ensure_chef_daemon_fresh()` checks if chef-daemon process is alive AND if its running SHA matches disk SHA. Mismatch → pkill + nohup-launch. **From this bootstrap forward, every chef-daemon patch auto-applies in ≤ 60 s. Zero manual intervention required for daemon updates.**

This dispatch is the ONE-TIME bootstrap that activates the new self-supervising stack.

## Mission

Restart BOTH daemons. Order : kill old, launch new from latest disk version.

## Steps

1. Show current state :
   ```bash
   echo "--- BEFORE ---"
   pgrep -af 'worker-daemon.sh' || echo "no worker-daemon"
   pgrep -af 'chef-daemon.sh' || echo "no chef-daemon"
   ```

2. Kill BOTH daemons :
   ```bash
   pkill -f 'worker-daemon.sh' 2>/dev/null || true
   pkill -f 'chef-daemon.sh' 2>/dev/null || true
   sleep 3
   echo "--- AFTER pkill ---"
   pgrep -af 'worker-daemon.sh' || echo "(worker dead)"
   pgrep -af 'chef-daemon.sh' || echo "(chef dead)"
   ```

3. Verify the latest disk versions have the V2 features :
   ```bash
   echo "--- disk version check ---"
   grep -c 'ensure_chef_daemon_fresh'   /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/worker-daemon.sh
   grep -c 'SCRIPT_SHA_AT_START'        /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/worker-daemon.sh
   grep -c 'run_kaizen'                 /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh
   grep -c 'run_panel_check'            /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh
   grep -c 'write_progress_email'       /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh
   grep -c 'RUNNING_STATE_FILE'         /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh
   ```
   Each grep should return ≥ 1. If any returns 0, the disk file is stale — abort and tell chef.

4. Launch worker-daemon V2 (with chef-monitoring) :
   ```bash
   chmod +x /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/worker-daemon.sh
   chmod +x /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/remote-worker.sh
   chmod +x /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh
   nohup bash /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/worker-daemon.sh \
     > /mnt/c/doctorat/bsebench-org/.async-worker.log 2>&1 &
   disown
   sleep 2
   ```

5. Launch chef-daemon V2 (with self-respawn + kaizen + panel + email) :
   ```bash
   nohup bash /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh \
     > /mnt/c/doctorat/bsebench-org/.async-chef.log 2>&1 &
   disown
   sleep 3
   echo "--- AFTER launch ---"
   pgrep -af 'worker-daemon.sh\|chef-daemon.sh'
   ```

6. Verify the chef-daemon running-state file was written :
   ```bash
   cat ~/.async-chef-daemon.running || echo "(not written — may indicate chef-daemon failed to start)"
   ```

7. Tail both logs for first ticks :
   ```bash
   echo "--- worker log tail ---"
   tail -10 /mnt/c/doctorat/bsebench-org/.async-worker.log
   echo "--- chef log tail ---"
   tail -10 /mnt/c/doctorat/bsebench-org/.async-chef.log
   ```

8. Print final report (worker captures it for outbox) :
   ```
   DAEMONS V2 BOOTSTRAP DONE :
   - old worker-daemon PID(s) killed : <list or "none">
   - old chef-daemon PID(s) killed : <list or "none">
   - new worker-daemon PID : <pid>
   - new chef-daemon PID : <pid>
   - chef running-state file : <path + size + content>
   - worker disk SHA : <sha>
   - chef disk SHA : <sha>
   - V2 features verified : worker-monitoring=<count>, kaizen=<count>, panel=<count>, email=<count>, sha-tracking=<count>
   - both ticking : yes|no (per log tails)
   ```

## DO NOT

- Modify any code file (this dispatch is process management only).
- Push (worker handles).
- Add `Co-Authored-By: Claude` trailer.

## Acceptance gates

- **G1** : `pgrep -af 'worker-daemon.sh\|chef-daemon.sh'` shows exactly 2 PIDs after the bootstrap.
- **G2** : `cat ~/.async-chef-daemon.running` shows a single line with PID + SHA.
- **G3** : `tail -5 .async-chef.log` contains `chef-daemon start` and `script_sha=<...>`.
- **G4** : `tail -5 .async-worker.log` contains `worker daemon start` and `script_sha=<...>`.
- **G5** : ALL grep counts in step 3 are ≥ 1.

## After this lands

- Every future patch on chef-daemon.sh auto-applies via :
  - chef-daemon's own self-respawn (its main loop checks SHA + execs)
  - worker-daemon's `ensure_chef_daemon_fresh()` (catches edge cases : chef-daemon crashed silently, chef stuck in a long codex run, etc.)
- Every future patch on worker-daemon.sh auto-applies via worker-daemon's self-respawn (checks SHA + execs).
- The next phase that closes (when claude-TN queues 6.10.d) will exercise the full V2 cascade end-to-end : verify_and_merge → kaizen → panel → (advisor) → unified email → next phase.
- **claude-TN should NOT need to manually merge any phase from this point forward.** The user's mandate is enforced by infrastructure, not vigilance.
