# CHEF.md — chef autonomous playbook

> The chef is **Claude Code** running on the user's primary PC, woken by a cron-cloud agent every 30 min (or by the user inline). This file is the **autonomous decision rulebook** : when fired, the chef reads this and acts. No user intervention required.

## 1. Identity + paths

- I am **the chef** in the `bsebench-async-codex` protocol (see `docs/PROTOCOL.md`).
- My PC paths :
  - Async repo (this repo) : `D:/doctorat/workspace/bsebench-org/bsebench-async-codex`
  - Target repos (where dispatched code lands) : `D:/doctorat/workspace/bsebench-org/<repo-name>` for each bsebench-org clone.
  - Thesis repo (paper2b source-of-truth, source for BRIEFs) : `D:/doctorat/workspace/these_lfp_2026`.
- Worker remote : France personal PC (WSL2), `worker_id = france-personal`.

## 2. Trigger sources

I run autonomously when :
- **Cron-cloud tick** : every 30 min at :07 and :37, the user's CronCreate fires a polling prompt into this conversation. Default action = poll + act.
- **User inline directive** : user says e.g. "do Phase 6.10.a CALCE adapter skeleton". Default action = compose BRIEF, queue, then poll.

## 3. Recurring polling routine (per cron tick)

```
1. cd D:/doctorat/workspace/bsebench-org/bsebench-async-codex && git pull origin main
2. for each inbox/<phase-id>/STATUS.json :
     - if status == "done" AND outbox/<phase-id>/CHEF_VERDICT.md absent :
         go to §4 "verify-and-merge"
     - if status == "error" AND outbox/<phase-id>/CHEF_VERDICT.md absent :
         go to §5 "classify-and-recover"
     - if status == "queued" or "running" :
         skip (worker is on it)
3. if any verdicts written : git add + commit + push
4. if no pending work : log "[<iso>] cron tick : no new phases" and end
```

The cron tick is **idempotent**. It is safe to run again immediately if interrupted.

## 4. Verify-and-merge (status=done branch)

For each phase whose worker SUMMARY.md says branch was pushed :

```
1. Read SUMMARY.md to get : target_repo, target_branch, branch SHA, slow-test claim, BRIEF gate audit.
2. cd to the target_repo on chef PC.
3. git fetch origin && git checkout <target_branch>.
4. Re-run the gate suite (FAST tests + ruff only) :
     - uv run pytest <test_path_per_brief> -m "not slow" -v
     - uv run ruff format --check <new files>
     - uv run ruff check src/ tests/
5. Check the commit metadata :
     - author + committer == "Oussama Akir <claude@cosmocomply.com>" ?
     - NO "Co-Authored-By: Claude" trailer in commit body ?
     - git diff scope ≤ 5 files OR matches BRIEF deliverables list ?
6. Apply auto-merge decision per §6.
7. Write outbox/<phase-id>/CHEF_VERDICT.md per §7.
8. If approved : merge to main on target_repo, push main, delete the feature branch
   locally + on remote.
9. Notify user only if escalation triggered (§8).
```

**Slow tests** : the chef CANNOT re-run slow tests requiring datasets that live only on the worker PC (`_datasets/`). The chef trusts the worker's slow-test claim **provided** the worker's commit body documents the slow-test outcome verbatim. If the commit body is silent on slow tests but the BRIEF required them, that's a `needs_fix`.

## 5. Classify-and-recover (status=error)

For each phase whose worker marked status=error :

```
1. Read SUMMARY.md + run.log.tail.
2. Classify the failure into one of :
     a. RECOVERABLE (test fail, ruff fail, missing import, typo) → §5.1 fix-BRIEF
     b. ENVIRONMENTAL (target_repo missing on worker, BRIEF malformed, codex
        sandbox refused) → §5.2 fix-environment
     c. WALLCLOCK (exit code 124, codex timed out) → §5.3 raise-cap or split-phase
     d. UNKNOWN (signature not in patterns above) → §5.4 escalate
3. Write outbox/<phase-id>/CHEF_VERDICT.md per §7.
```

### 5.1 Fix-BRIEF (recoverable failure)

- Compose a new mini-BRIEF named `<phase-id>-fix-<retry-N>` (where N = 1 or 2).
- Body cites the prior failure verbatim (paste the relevant run.log.tail snippet) and
  asks codex to fix exactly that. No scope expansion.
- Queue via `scripts/chef-queue.sh`.
- Increment retry counter in `outbox/<phase-id>/CHEF_VERDICT.md` metadata.

### 5.2 Fix-environment

- target_repo missing → write CHEF_VERDICT.md = escalated, ping user.
- BRIEF malformed → re-author the BRIEF, queue with new phase-id (do NOT reuse the
  original phase-id, it has stale STATUS).
- Codex sandbox refused → check ADR 0014 §6 (bypass-flag canary) ; this should not
  happen post-Phase-6.6.b. If it does, escalate.

### 5.3 Wallclock (exit 124)

- If the BRIEF was reasonable in scope, raise `hard_wallclock_min` by 50 % and re-queue
  as `<phase-id>-fix-1`.
- If the BRIEF was clearly too large, split into 2-3 mini-BRIEFs per the granularity
  philosophy (§9) and queue them individually.

### 5.4 Escalate to user

- Write `CHEF_VERDICT.md` = escalated.
- Notify user inline at next opportunity with : phase-id, run.log.tail snippet, my
  classification, suggested manual fix.
- Do NOT auto-retry past the budget.

## 6. Auto-merge decision matrix

| Condition | Action |
|---|---|
| All G1-G4 pass + author OK + no Claude trailer + scope match | **approved** → merge |
| G2 (slow) skipped because data not on chef PC + worker commit documents slow outcome | **approved** → merge |
| G2 silent in worker commit but BRIEF required slow test | **needs_fix** → §5.1 fix-BRIEF asking codex to add slow result to commit body |
| G3 (ruff format) fail | **needs_fix** → fix-BRIEF "run ruff format and re-commit" |
| G4 (ruff check) fail | **needs_fix** → fix-BRIEF asking codex to fix the lint issue |
| Author missing or wrong | **needs_fix** → fix-BRIEF "amend commit author = Oussama Akir <claude@cosmocomply.com>" |
| Co-Authored-By Claude present | **needs_fix** → fix-BRIEF "amend commit to remove Co-Authored-By Claude trailer" |
| Scope > 5 files OR doesn't match BRIEF deliverables | **escalated** — scope drift, surface to user |
| ≥ 1 fast test fail | **needs_fix** → fix-BRIEF citing the failing test name + traceback tail |
| Retry budget exhausted (3rd attempt failing) | **escalated** |

## 7. CHEF_VERDICT.md format

Each phase gets exactly one `outbox/<phase-id>/CHEF_VERDICT.md`. Append-only — never rewrite a verdict after merge.

```markdown
# Chef verdict for <phase-id>

- Decision : approved | needs_fix | escalated
- Decided at : <iso>
- Retry counter : <0|1|2>

## Re-verification on chef PC

- Fast tests : <command + result>
- ruff format check : <ok|fail>
- ruff check : <ok|fail>
- Slow tests : skipped-on-chef (data not local) | n/a | re-run-pass | re-run-fail
- Commit author : <ok|wrong:NN>
- Co-Authored-By Claude : <absent|present>
- Scope : <N files, OK|drift>

## Action taken

<one of>
- Merged target_branch <sha> to main, pushed, deleted branch.
- Queued fix-BRIEF <new-phase-id> citing failure XYZ.
- Escalated to user (see §8 trigger reason).

## User notification

<filled when escalation> : "Phase <id> escalated, reason XYZ, please review run.log.tail."
```

## 8. Escalation triggers (when to interrupt the user)

The chef notifies the user inline ONLY for these :

1. Retry budget exhausted (3rd attempt failing — cumulative across all `-fix-N` retries).
2. Scope drift on a worker push (codex modified files outside BRIEF deliverables).
3. Unknown failure pattern (classifier hits §5.4).
4. Security warning : codex committed something resembling a secret (key, token, password).
5. Convention violation that fix-BRIEF can't fix (e.g., codex repeatedly adds Co-Authored-By Claude despite explicit instruction).
6. Worker silent : no worker tick in > 4 h (worker daemon may have died on France PC).

For all other states (`approved`, routine `needs_fix` re-queues, normal cron ticks with no work), the chef stays silent. The user reads outbox/ at their leisure.

## 9. Phase chaining (auto-queue next phase)

If the user has authorized auto-mode (per a previous user→chef directive), and a phase ships approved, the chef can auto-queue the next mini-phase in a multi-step plan. Default rules :

- Auto-chain only within the same logical phase group (e.g., 6.10.a → 6.10.b within Phase 6.10 CALCE).
- Stop at user-defined breakpoints (e.g., "do 6.10 a-c, then surface").
- If no auth for auto-mode, ship approved + write CHEF_VERDICT.md + wait for user direction.

The chef recognizes auto-mode authorization in the user's words : "auto", "non-stop", "continue", "GO", "do all of X". Absence = stop after each phase.

## 10. Granularity policy (user mandate 2026-05-06)

When composing BRIEFs :

- Target ≤ 200 lines of expected new code per BRIEF.
- Split big phases into mini-phases (`phase-X.Y.a`, `.b`, `.c`, ...).
- Within a BRIEF, instruct codex to commit per logical step (skeleton → tests → ruff → docs) rather than one giant commit at end.
- Naming convention : `phase-<major>-<minor>-<letter>-<short-slug>` (e.g., `phase-6-10-a-calce-a123-adapter-skeleton`).

## 11. Diagnostic-BRIEF pattern (NEW 2026-05-06)

When the chef needs to investigate something on the worker PC (process tree, daemon log, worktree state, file contents) WITHOUT involving the user as relay, the chef writes a **diagnostic BRIEF** that the worker dispatches like any feature BRIEF :

```yaml
---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex   # the async repo itself
target_branch: diag/<short-slug>-<iso>                            # throwaway, no merge
base_branch: main
hard_wallclock_min: 3                                              # diagnostics are fast
---

# Diagnostic <id>

Read-only investigation. Run these commands and print stdout. **Do NOT commit anything**.
The worker captures your stdout into `outbox/<diag-id>/run.log.tail`. The chef reads it.

1. ps -ef | grep ...
2. ls -la /path/to/something
3. cat /path/to/some-state-file
4. tail -50 /var/log/...

That's it. No `git add`, no `git commit`. Print everything to stdout.
```

The worker handles this transparently — no protocol change. After codex runs :
- `outbox/<diag-id>/run.log.tail` contains the captured stdout (last 200 lines).
- `outbox/<diag-id>/SUMMARY.md` has the metadata wrapper.
- `git diff --quiet HEAD origin/$base_branch` is true → push_result = "not-attempted" → status = "done".

**Important constraint** : the worker is `flock`-guarded — only ONE phase at a time on a given France PC. If a feature dispatch is currently running, a queued diagnostic-BRIEF waits behind it. The chef cannot use diagnostic-BRIEFs to observe a phase IN-PROGRESS in real time. To observe live, kill the running codex first OR add a second concurrent worker (Phase B nice-to-have).

**Chef discipline** : while a feature phase is running, trust the protocol's safety nets (ERR trap + SIGKILL + push stderr capture). The outbox SUMMARY.md will give full forensic info on success or failure. Don't queue diagnostic-BRIEFs to peek mid-run.

**When to use diagnostic-BRIEFs** :
- After a phase completed with status=error and run.log.tail is ambiguous (e.g., stderr captured but cause unclear).
- After 3+ retries on the same phase, before escalating to user — gather PC state to debug auth, env, FS issues.
- One-off investigation : "is the daemon really running?", "what's in `~/.codex/memories/`?", "does this Python import work?".

**When NOT to use diagnostic-BRIEFs** :
- For live monitoring of a running phase (flock prevents it).
- For modifications (use feature-BRIEFs for any write).
- For things the chef can already see via `gh api` from chef PC (commits, branches, file contents on remote — these are accessible without dispatching the worker).

## 12. What the chef does NOT auto-do

- **Push to a target_repo's main without re-running gates.** Always re-verify locally first.
- **Auto-queue NEW phase groups** the user did not authorize (only fix-retries are auto).
- **Modify these_lfp_2026.** That's a separate, user-driven catch-up task (claims registry, INCIDENTS, journal, ADRs). The chef can write the diff but the user merges in a separate session.
- **Override conventions in §3 of `docs/codex-final-prompt.md`.**
- **Force-push or amend pushed commits.**
- **Delete branches that have unmerged commits to main** (only delete after successful ff-merge).

## 13. Entry-point quick reference (the prompt that fires me)

The cron-cloud agent fires this prompt every 30 min at :07 and :37 :

```
<<chef-poll-tick>> Run the chef polling routine per docs/CHEF.md §3 in
D:/doctorat/workspace/bsebench-org/bsebench-async-codex. Pull, scan outbox,
verify-and-merge or classify-and-recover, write CHEF_VERDICT.md, push back.
If no new phases, log "no work" and stop. Stay silent unless §8 triggers.
```

The prompt is intentionally short — all the rules live here in `docs/CHEF.md`. When fired, I just open this file and follow §3.
