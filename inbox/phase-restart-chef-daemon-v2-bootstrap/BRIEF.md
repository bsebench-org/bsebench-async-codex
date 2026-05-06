---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: bootstrap/chef-daemon-v2-respawn-2026-05-06
base_branch: main
hard_wallclock_min: 5
---

# One-time chef-daemon V2 bootstrap (pkill + nohup respawn)

## Why this exists

Chef-daemon process on the France PC is currently running V1.0 code (loaded into bash memory at original launch). All subsequent patches (V1.1 reset-hard, kaizen step, panel/advisor/block, unified email, GLASSBOX role tags, self-respawn-on-SHA-change) were committed AFTER the daemon process started, so they exist on disk but the running bash interpreter does not have them.

Self-respawn (commit `0a33178`) was specifically designed to auto-pick-up future patches — but it has a bootstrap problem : it must BE in the running version for it to work. The currently-running V1.0 doesn't have it. So the daemon will NEVER auto-update itself.

This dispatch fixes the bootstrap : pkill the old daemon, launch a fresh nohup of the latest chef-daemon.sh from disk. From that point on, every future patch auto-applies via the now-active self-respawn.

## Mission

Run on the France PC :

1. Verify the worker daemon is alive (we don't touch it — only chef) :
   ```bash
   pgrep -af 'worker-daemon.sh' || echo "WARN: worker daemon not running"
   ```

2. Identify and kill the running chef-daemon :
   ```bash
   pgrep -af 'chef-daemon.sh' || echo "(no chef-daemon currently running)"
   pkill -f 'chef-daemon.sh' 2>&1 || true
   sleep 2
   pgrep -af 'chef-daemon.sh' && echo "ERROR: chef-daemon survived pkill" || echo "OK: chef-daemon killed"
   ```

3. Confirm the latest chef-daemon.sh on disk has the V2 features (kaizen, panel, email, self-respawn) :
   ```bash
   grep -c 'run_kaizen' /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh
   grep -c 'run_panel_check' /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh
   grep -c 'write_progress_email' /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh
   grep -c 'SCRIPT_SHA_AT_START' /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh
   ```
   Each of these greps should return ≥ 1. If any returns 0, the disk file is stale — abort and tell chef.

4. Launch chef-daemon V2 :
   ```bash
   chmod +x /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh
   nohup bash /mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/chef-daemon.sh \
     > /mnt/c/doctorat/bsebench-org/.async-chef.log 2>&1 &
   disown
   sleep 3
   pgrep -af 'chef-daemon.sh'
   ```

5. Tail the new daemon's log to confirm V2 startup messages :
   ```bash
   tail -20 /mnt/c/doctorat/bsebench-org/.async-chef.log
   ```
   Look for the `chef-daemon start` line + `script_sha=...` line (the SHA that will be watched for self-respawn).

6. Print final report to stdout (worker captures it for outbox SUMMARY) :
   ```
   CHEF-DAEMON V2 BOOTSTRAP DONE :
   - old chef-daemon PID(s) killed : <list or "none">
   - new chef-daemon PID : <pid>
   - script SHA at start : <sha>
   - V2 features verified on disk : kaizen=<count>, panel=<count>, email=<count>, self-respawn=<count>
   - log path : /mnt/c/doctorat/bsebench-org/.async-chef.log
   - first ticks visible in log : yes|no
   ```

## DO NOT

- Touch the worker daemon (it works fine, has self-respawn already).
- Modify any code file (this dispatch is process management only).
- Push (worker handles).
- Add `Co-Authored-By: Claude` trailer.

## Acceptance gates

- **G1** : `pgrep -af 'chef-daemon.sh'` shows exactly 1 PID after the bootstrap.
- **G2** : `tail -20 /mnt/c/doctorat/bsebench-org/.async-chef.log` shows `chef-daemon start` line with the V2 features (the script_sha line is the marker — only V2 has it).
- **G3** : The 4 grep counts in step 3 are all ≥ 1.

That's it. After this, the next phase that closes (worker → done) will trigger the FULL V2 cascade : verify_and_merge → run_kaizen → run_panel_check → (advisor if needed) → write_progress_email. The first email will land in outbox/_emails_pending/.
