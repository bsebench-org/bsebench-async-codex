# Phase phase-6-11-d-friedman-nemenyi-stats summary (worker crash)

- Worker : france-personal
- Crash exit code : 137
- Crash line in remote-worker.sh : 223
- Pre-crash phase progress : marked running, then the worker/codex exec process was killed before completion.
- CTO repair : removed the worker-2 claim race, restored valid JSON, and marked the phase `status=error`.

## Recovery

Requeue this phase as `phase-6-11-d-friedman-nemenyi-stats-fix-1` with the same BRIEF after daemon stability is confirmed.
