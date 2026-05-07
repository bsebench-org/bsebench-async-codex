# Freelance dev BRIEF template

> **Used by** : CEO (claude-TN) OR CTO (codex on France PC) when dispatching ad-hoc code work to a stateless codex exec via the worker-daemon pipeline.
>
> **NOT used for** : research phases (those have their own BRIEF format with claim cross-refs, panel-validate gates, etc.). Use this template only for infrastructure / tooling / one-shot fixes.

## File location

```
inbox/<phase-id>/BRIEF.md       # canonical BRIEF
inbox/<phase-id>/STATUS.json    # initial state (queued)
```

`<phase-id>` for freelance dev work :
- `dev-<short-slug>-<isodate>` — e.g., `dev-fix-push-retry-2026-05-06`
- prefix `dev-` distinguishes from research `phase-N-N-N` BRIEFs

## STATUS.json initial content

```json
{
  "phase_id": "dev-<slug>-<isodate>",
  "status": "queued",
  "ts_queued": "<iso>",
  "ts_started": null,
  "ts_done": null,
  "exit_code": null,
  "worker_id": null,
  "target_repo": "/mnt/c/doctorat/bsebench-org/<repo>",
  "target_branch": "dev-<slug>-<isodate>",
  "base_branch": "main",
  "dispatcher_role": "ceo | cto",
  "freelance_dev": true
}
```

## BRIEF.md template (copy-paste below)

```markdown
# Freelance dev BRIEF — <slug>

[role-dispatcher: <claude-TN | cto-FR>]
Generated at : <iso>

## Mission (1 sentence)
<what this dev needs to do, e.g., "Add retry-with-backoff to the push step in worker-daemon.sh">

## Why now
<2-5 lines : the pain we're solving, observed incident if any, why CTO/CEO chose to dispatch this rather than fix in CEO/CTO scope>

## Scope
- IN scope : <bullet list of files, repos, behaviors that this dev MAY touch>
- OUT of scope : <bullet list of things this dev MUST NOT touch — e.g., "do NOT modify chef-daemon.sh">

## Acceptance criteria (binary)
- [ ] <criterion 1, must be objectively verifiable>
- [ ] <criterion 2>
- [ ] <criterion N>

## Verification commands
```bash
# what the dev should run before declaring done
# Python repos using ruff must include both formatter and lint gates:
# uv run ruff format --check .
# uv run ruff check .
<command 1>
<command 2>
```

## Commit format
- One commit, GLASSBOX format, body sections : Context / Objective / Problem / Result.
- Role tag : `[role: worker-FR]` (the dev IS a freelance worker spawned by worker-daemon).
- NO Co-Authored-By trailer (per project rule 2026-04-29).
- Subject ≤ 72 chars, imperative.

## Reporting
The worker-daemon will auto-create :
- `outbox/<phase-id>/SUMMARY.md` with commit SHA, diff stats, verification result
- Update `STATUS.json` with `status=done|error`, `ts_done`, `exit_code`

The dispatcher (CEO or CTO) reads SUMMARY.md and writes the next move (merge to main, request fix, escalate).

## Time budget
<estimate, e.g., "30 min compute, 1 commit, < 100 LOC diff">

## If blocked
Write a `BLOCKED.md` in the BRIEF folder with :
- What you tried
- Why it didn't work
- 1-2 specific questions for the dispatcher

## Memory
Save nothing to long-term memory. You are a stateless freelance dev. Ship + leave.
```

## Examples of good freelance dev BRIEFs

- `dev-fix-push-retry-2026-05-06` : add retry+backoff to one shell function
- `dev-add-gitignore-pytest-cache-2026-05-06` : append `.pytest_cache/` to .gitignore in 3 repos
- `dev-rotate-async-worker-log-2026-05-06` : implement logrotate-style truncation for `~/.async-worker.log` when > 100 MB
- `dev-fix-summary-md-encoding-2026-05-06` : ensure all SUMMARY.md emit UTF-8 BOM-less

## Examples of NOT-freelance dev work (use research phase BRIEF instead)

- `phase-6-11-d-friedman-nemenyi-stats` : has scientific claim, panel-validate gate, advisor escalation
- `phase-11-sensor-noise-decomposition` : touches research code, requires claim registry update
- `phase-7-2-zenodo-citation-metadata` : not pure dev — requires DOI minting + cross-ref to claims/registry.yaml

The line : if it touches `claims/registry.yaml`, the research roadmap, or paper-text, it's NOT a freelance dev task. Use a phase BRIEF.
