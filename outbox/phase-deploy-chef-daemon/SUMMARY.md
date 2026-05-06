# Phase phase-deploy-chef-daemon summary (worker crash)

- Worker : france-personal
- Crash exit code : 124
- Crash line in remote-worker.sh : 199
- Pre-crash phase progress : marked running, but a step before "codex exec" failed.
- Most likely cause : git fetch / git worktree add / cd to target_repo failed.

## Recovery

The chef should re-queue this phase as <phase-id>-fix-1 with the same BRIEF.
The worker script is now ERR-trap-safe ; the next attempt will surface a clean
status=error if the same problem recurs.
