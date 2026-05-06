# bsebench-async-codex

> Git-as-message-queue between the **chef PC** (Windows, this side) and a **remote codex worker** (any OS with codex CLI + GitHub creds + OpenAI API key + lots of storage).

## Purpose

Some BSEBench dispatches need datasets too large to keep on the chef PC (e.g., CALCE A123 dynamic, CALCE INR-20R, full Severson, full Stroebl). This repo is the async dispatch protocol : the chef pushes a brief, the remote worker reads it, runs codex, and pushes the result back.

## Protocol

```
chef ── push BRIEF.md + STATUS.json (queued) ──> origin/main
                                                       │
                                                       │  ≤ 25 min later
                                                       ▼
                         remote worker (cron 60 s) ── git pull
                                                       │
                                                       │  picks first inbox/<id>/STATUS.json
                                                       │  with status == "queued"
                                                       │  flock-guarded, one at a time
                                                       │
                                                       ▼
                            codex exec --bypass --add-dir <target> < BRIEF.md
                                                       │
                                                       ▼
                       commit branch on target repo, push to origin
                                                       │
                                                       ▼
                  push outbox/<id>/SUMMARY.md + run.log.tail + STATUS.json (done)
                                                       │
                                                       ▼
chef <── poll origin/main every 25 min ── git pull ── read SUMMARY.md
```

## Directory layout

```
bsebench-async-codex/
├── README.md                  (this file)
├── inbox/<phase-id>/
│   ├── BRIEF.md               (instructions for codex)
│   └── STATUS.json            (state machine; chef writes "queued", worker writes "running"/"done"/"error")
├── outbox/<phase-id>/
│   ├── SUMMARY.md             (≤ 50-line distilled result + branch SHA + gate evidence)
│   └── run.log.tail           (last ~200 lines of codex stdout/stderr)
├── scripts/
│   ├── chef-queue.sh          (run on chef PC to queue a phase)
│   ├── remote-worker.sh       (run on remote PC every 60 s via cron)
│   └── setup-remote.md        (one-time setup steps for the remote PC)
└── workers/
    └── <worker-id>.json       (registered worker descriptor : owner, OS, target repos, last_heartbeat)
```

## STATUS.json schema

```json
{
  "phase_id": "phase-6-10-calce-a123-dyn",
  "status": "queued",
  "ts_queued": "2026-05-06T03:00:00+02:00",
  "ts_started": null,
  "ts_done": null,
  "exit_code": null,
  "worker_id": null,
  "target_repo": "bsebench-org/bsebench-datasets",
  "target_branch": "phase-6-10-calce-a123-dyn",
  "base_branch": "main"
}
```

State transitions :
- `queued` → `running` : worker took the lock and started codex.
- `running` → `done` : codex exited 0 AND worker pushed the result.
- `running` → `error` : codex exited non-zero OR push failed. SUMMARY.md captures the failure mode.

## BRIEF.md frontmatter (parsed by worker)

```markdown
---
target_repo: D:/doctorat/workspace/bsebench-org/bsebench-datasets   # absolute path on remote
target_branch: phase-6-10-calce-a123-dyn                            # branch worker creates
base_branch: main                                                    # what to fork from
add_dir:
  - D:/doctorat/workspace/these_lfp_2026
  - D:/doctorat/workspace/bsebench-org/bsebench-datasets
hard_wallclock_min: 90
---

# (rest of BRIEF.md is the prompt fed to codex via stdin)
```

The worker parses these YAML keys, sets up the worktree, runs codex, and pushes the resulting branch.

## Concurrency model

- One worker per `workers/<id>.json` entry. Workers select phases atomically by writing `running` to STATUS.json + pushing first ; loser-pushes are detected by `git push` rejection and the worker tries the next queued phase.
- `flock` on the remote prevents two cron ticks from racing into the same `git pull` / codex run.
- Chef polls every 25 min ; if multiple phases finished between polls, all are surfaced together.

## Failure recovery

- If a worker dies mid-run (machine off, codex crash) : STATUS stays `running` with stale `ts_started`. After 2 hours of `running` with no `ts_done`, chef may force-reset to `queued` for re-pickup. Stale-heartbeat detector is a Phase B nice-to-have.
- If `git push` from worker fails (auth expired, conflict) : worker writes `outbox/<id>/SUMMARY.md` locally and waits — next cron tick retries the push.
- If codex hangs : the wallclock cap in BRIEF.md is enforced by `timeout` wrapper in the worker. Hung dispatch ends with exit 124 + STATUS = `error`.

## Setup

See `scripts/setup-remote.md` for the one-time setup on the remote PC.
