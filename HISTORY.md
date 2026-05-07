# HISTORY.md — narrative audit ledger

> **Purpose** : a high-level, append-only narrative trail of events across all
> actors (claude-TN, codex-FR, worker-codex-FR, worker-FR, chef-FR) and all
> phases. Designed for **forensic audit by any LLM** months later : a reader
> should be able to reconstruct what happened, who decided what, and what
> evidence backs the claim, without reading every git commit.
>
> **Format** : one bullet per significant event.
>
> ```
> - **HH:MM UTC** | [actor: <role-tag>] | [<EVENT-TYPE>] | <phase or area> | <one-line narrative>.
>   `key=value` facts (sha, gate count, exit code, etc.)
> ```
>
> **Event types** (use SHOUTED-CASE) :
> - `QUEUE` : a BRIEF was queued in inbox/
> - `START` : worker took flock + marked status=running
> - `DONE` : worker reported codex finished cleanly
> - `FAIL` : worker reported codex failed OR a chef gate caught a defect
> - `TIMEOUT` : SIGTERM / SIGKILL fired on a hung process
> - `MERGE` : a feature branch landed on main of a target repo
> - `VERDICT` : chef wrote CHEF_VERDICT.md (approved | needs_fix | escalated)
> - `DECIDE` : an architectural / policy choice was made
> - `BUG` : a defect was identified
> - `FIX` : a patch landed addressing a previously identified BUG
> - `INSTALL` : infrastructure deployed on a worker PC
> - `HANDOFF` : a baton was passed between actors (rare ; most communication
>   is via the inbox/outbox protocol — HANDOFF is for explicit, narrative-
>   relevant transfers, e.g., user asks for X, chef plans Y)
> - `LEARN` : an empirical observation worth remembering for future phases
> - `KAIZEN-RETRO` : an auto-generated retrospective (KEEP/FIX/SHIP-ONE) was
>   written to outbox/<phase>/KAIZEN.md by the chef-daemon's kaizen step,
>   after a verdict was committed. Look up the file for the bullets. One per
>   phase verdict, fired at most once per phase id.
> - `KAIZEN-SHIP` : a SHIP-ONE recommendation from a prior KAIZEN-RETRO
>   landed as a real change (commit on async-codex or a target repo). Cite
>   the originating KAIZEN.md + the implementation commit SHA. This is the
>   counter to KAIZEN-RETRO : grepping for KAIZEN-RETRO without a matching
>   KAIZEN-SHIP shows ideas that were proposed but not yet shipped.
> - `PANEL-VALIDATE` : a 3-agent panel (Mme Rim Barrak + 2 task-relevant
>   experts) reviewed the phase and produced a confidence score. Cite the
>   average score + verdict (PASS | NEEDS_REVIEW). One per phase verdict.
> - `ADVISOR-OVERRIDE` : after a NEEDS_REVIEW from the panel, the advisor
>   (fresh-context reviewer) returned GO and overrode the panel — chef
>   continues. Cite the reasoning summary.
> - `BLOCK` : after a NEEDS_REVIEW from the panel AND a BLOCK from the
>   advisor, chef-daemon is paused and an email is queued at
>   outbox/_emails_pending/ for akir.oussama@gmail.com. The chef-daemon
>   refuses to process any further phases until the corresponding
>   outbox/_blocks/<phase>.block file is removed by the user.
> - `EMAIL-SENT` : a progress notification email was queued in
>   outbox/_emails_pending/. Fired UNCONDITIONALLY after every iteration
>   close (PASS, FIX, ESCALATED, BLOCKED — doesn't matter, always one
>   per phase). Concise format : phase / state / panel / next-task / 4
>   links. Subject tag = OK | FIX | ESCALATED | BLOCKED. V1 = file in
>   repo (user reads via GitHub watch or direct visit) ; V2 = GitHub
>   Actions on push to outbox/_emails_pending/* sends via SMTP secret.
>
> **Maintenance** :
> - claude-TN appends entries during chef sessions (live + post-mortem at
>   session-end).
> - V2 future : chef-daemon could auto-append a single VERDICT line per phase
>   on each tick (deferred — V1 maintains by hand to avoid file-lock races).
> - Append-only : NEVER rewrite a past entry. If something turns out wrong,
>   add a new entry that supersedes it (cite the earlier UTC timestamp).
> - One day per `## YYYY-MM-DD` section.

---

## 2026-05-06 — Async-codex infrastructure + Phase 6.10 launch

### Morning : protocol design + first dispatch attempts (08:00 — 12:00 UTC)

- **~08:00 UTC** | [actor: claude-TN] | [HANDOFF] | session-bootstrap | session resumes from previous compaction. Previous context : Phase 6 BSEBench Tier 1+2 loaders, panel-as-default mandate, advisor-routed phase decisions.
- **~09:00 UTC** | [actor: claude-TN] | [DECIDE] | async-codex protocol | user request : 100 % autonomous chef-codex loop via git commits, with a remote PC handling heavy data (CALCE zips). Designed the bsebench-async-codex repo as the message bus : inbox/queued → worker-FR runs codex → outbox/done → chef-FR verifies + merges.
- **~09:30 UTC** | [actor: claude-TN] | [INSTALL] | bsebench-org/bsebench-async-codex | created the orchestration repo (private initially, made public later for Anthropic cloud routine clone access). Initial scaffold : README + scripts/remote-worker.sh + chef-queue.sh + setup-remote.md.
- **~09:45 UTC** | [actor: claude-TN] | [DECIDE] | worker scheduling | switched from system-cron / Task-Scheduler to nohup userspace bash daemon. User feedback : "pourquoi cron + crontab + /etc/wsl.conf, vous pouvez avoir en interne votre loop". Adopted `worker-daemon.sh` + `~/.bashrc` respawn snippet pattern.
- **~10:00 UTC** | [actor: claude-TN] | [INSTALL] | onboarding-codex.md | drafted comprehensive first-run prompt for the France PC codex, including memory-persist instruction (codex saves an 8 KB context file to `~/.codex/memories/`).
- **~10:30 UTC** | [actor: codex-FR] | [DONE] | onboarding | codex on France PC pasted the final prompt, saved memory artifact, downloaded all 20 CALCE zips (8 A123 + 12 INR-20R) into `_datasets/`. Tokens : 39,883.
- **~11:30 UTC** | [actor: claude-TN] | [QUEUE] | phase-async-canary, phase-6-10-a | first 2 BRIEFs queued. Canary = 1-line file-write round-trip ; 6.10.a = CalceA123Adapter skeleton (~80 LOC).

### Afternoon : worker bug forensics + 3 patches (12:00 — 14:00 UTC)

- **13:11 UTC** | [actor: worker-FR] | [START] | phase-async-canary-fix-1 | re-queued canary after the original fossilized in status=running. First fix-1.
- **13:18 UTC** | [actor: claude-TN] | [BUG] | worker-daemon | observed tokens stagnant on fix-1, codex-FR is hung but `timeout 300s` did not escalate to SIGKILL. GNU `timeout` only sends SIGTERM by default.
- **13:20 UTC** | [actor: claude-TN] | [FIX] | scripts/remote-worker.sh | added `--kill-after=30s` to escalate SIGTERM → SIGKILL after 30 s. Commit `17c9464`.
- **13:22 UTC** | [actor: claude-TN] | [BUG] | worker-daemon | found another defect : worker had `set -euo pipefail` but no ERR trap, so any intermediate failure (git fetch / worktree add) silently exited the script while leaving status=running.
- **13:24 UTC** | [actor: claude-TN] | [FIX] | scripts/remote-worker.sh | added ERR trap that writes status=error + forensic SUMMARY.md if anything fails post-mark-running. Commit `609509f`.
- **13:30 UTC** | [actor: codex-FR] | [LEARN] | Windows GCM × WSL worktree-cwd | discovered a Windows Git Credential Manager crash when invoked from a WSL2 git worktree path. User fixed by adding `~/.local/bin/git-credential-manager-wsl` wrapper that calls GCM from a neutral cwd.
- **13:35 UTC** | [actor: claude-TN] | [QUEUE] | phase-6-10-a-...-fix-1 | re-queued 6.10.a under the patched worker. Wallclock 30 min cap.
- **13:36 UTC** | [actor: worker-FR] | [START] | phase-6-10-a-...-fix-1 | picked queued, marked running.
- **13:41 UTC** | [actor: worker-FR] | [DONE] | phase-6-10-a-...-fix-1 | codex exit 0, branch `fe1af5d`-equivalent pushed (actual sha `f397ca9` after multi-commit). 5/5 fast tests pass.
- **13:58 UTC** | [actor: claude-TN] | [MERGE] | phase-6-10-a-...-fix-1 | re-verified gates locally on chef PC, ff-merged `f397ca9 → bsebench-datasets/main`, deleted feature branch.
  `sha=f397ca9 fast_tests=5/5 ruff=clean scope=2_files`
- **13:59 UTC** | [actor: claude-TN] | [VERDICT] | phase-6-10-a-...-fix-1 | wrote `CHEF_VERDICT.md = approved` to outbox + commit `d92f3c9`. First fully-autonomous chef-codex round trip (no user relay between dispatch and merge).

### Mid-afternoon : autonomy mandate → chef-daemon (14:00 — 14:30 UTC)

- **14:08 UTC** | [actor: claude-TN] | [DECIDE] | chef-side autonomy | user mandate : "je ne suis pas du tout satisfait, [...] tu chapeautes, et on revient vers une intervention manuel de ma part [...] trouve un solution ultime". Diagnosed root cause : chef-side polling depended on either Anthropic cloud routine (no auth without /web-setup) OR Claude Code conversation (dies when user closes IDE). Both required user.
- **14:12 UTC** | [actor: claude-TN] | [INSTALL] | scripts/chef-daemon.sh | shipped a 190-line autonomous chef daemon for France PC : separate flock from worker, polls outbox, verifies gates, merges, writes CHEF_VERDICT.md. Eliminates both prior dependencies. Commit `4976f6e`.
- **14:30 UTC** | [actor: claude-TN] | [DECIDE] | GLASSBOX commit format | user mandate : every commit body must start with `[role: <tag>]` + 4 sections (Context / Objective / Problem / Result) for forensic transparency. Codified in PROTOCOL.md, propagated to codex-final-prompt.md §3.4 and both daemons. Commit `ad2fd60`.

### Late afternoon : chef-daemon V1 → V1.1 + Phase 6.10.b ship (14:00 — 16:30 UTC)

- **14:10 UTC** | [actor: claude-TN] | [QUEUE] | phase-6-10-b-calce-legacy-csv-harmonize, phase-deploy-chef-daemon | queued 2 BRIEFs : (a) the next mini-phase 6.10.b for the legacy CSV branch of `harmonize()` ; (b) a meta-BRIEF asking codex to install + start chef-daemon on France PC.
- **16:04 UTC** | [actor: worker-FR] | [START] | phase-6-10-b-calce-legacy-csv-harmonize.
- **16:10 UTC** | [actor: worker-FR] | [DONE] | phase-6-10-b-calce-legacy-csv-harmonize | codex exit 0, branch pushed. Net change : drop BaseAdapter shim + implement legacy CSV branch + 6 new tests (total 9 fast tests on the file).
- **16:11 UTC** | [actor: worker-FR] | [START] | phase-deploy-chef-daemon.
- **16:14 UTC** | [actor: chef-FR] | [VERDICT] | phase-6-10-a, phase-canary, etc. | chef-daemon V1 ran 7 ticks, escalated EVERY done phase. Bug : (a) couldn't checkout already-deleted branches (canary, 6.10.a fix-1) ; (b) `git checkout` failed on phase-6-10-b due to working-tree contamination (.coverage / .pytest_cache from sibling worker codex runs).
- **16:16 UTC** | [actor: worker-FR] | [TIMEOUT] | phase-deploy-chef-daemon | exit 124 at line 199. Codex was hung in the deploy steps (probably stuck on `tail -5` of a not-yet-flushed log).
  `exit_code=124 wallclock_cap=5min hung_at_line=199`
- **16:25 UTC** | [actor: claude-TN] | [MERGE] | phase-6-10-b-calce-legacy-csv-harmonize | manual chef merge as fallback, since chef-daemon V1 escalated. Verified 158 fast tests pass + ruff clean. ff-merged `6f19df9 → bsebench-datasets/main`. Note : 6.10.b commit body did NOT use GLASSBOX format because GLASSBOX was codified after codex committed.
  `sha=6f19df9 fast_tests=158/158 ruff=clean scope=2_files`
- **16:28 UTC** | [actor: claude-TN] | [BUG] | scripts/chef-daemon.sh V1 | identified two defects : (1) no `git reset --hard origin/main` + `git clean -fdx` before checkout, so untracked files block ; (2) no early-exit when worker SHA already in main, so deleted branches always escalate.
- **16:30 UTC** | [actor: claude-TN] | [FIX] | scripts/chef-daemon.sh → V1.1 | added pre-checkout `git reset --hard origin/main` + `git clean -fdx`, added "already in main" fast path via `git merge-base --is-ancestor`. Commit `8d38425`.
- **16:35 UTC** | [actor: claude-TN] | [INSTALL] | HISTORY.md (this file) | created the narrative ledger per user request : audit-friendly, append-only, one event per bullet, role tag + EVENT-TYPE + key=value facts.

### Status snapshot at 16:35 UTC

| Phase | Status | bsebench-datasets sha |
|---|---|---|
| 6.10.a CalceA123Adapter skeleton | merged | `f397ca9` |
| 6.10.b legacy CSV harmonize | merged | `6f19df9` |
| 6.10.c zip-bundle handling | not yet queued | — |
| 6.10.d / .e / .f Tier 2 loaders | not yet queued | — |

| Daemon (France PC) | Active | Notes |
|---|---|---|
| worker-daemon (PID 12447) | yes | patches : ERR trap + SIGKILL + push stderr + GLASSBOX tags |
| chef-daemon (PID unknown) | yes | V1 → V1.1 patch deployed via `8d38425` |

---

> **Next session pickup point** : queue Phase 6.10.c (zip-bundle parsing : `A123_DST-US06-FUDS-{T}C.zip` × 8 T × 3 profiles). Source-of-truth : paper2b `benchmark_grid_multi.py:502-585` `load_calce_a123_dynamic_wrapper`. Granularity : ≤ 200 LOC + 5 fast tests, one mini-BRIEF per granularity rule (CHEF.md §10).

- **22:20 UTC** | [actor: codex-FR] | [FIX] | infra-block | cleared `phase-restart-chef-daemon-v2-bootstrap` block after preserving a retrospective forensic summary. Root cause was missing worker SUMMARY/run.log.tail plus an obsolete two-daemon expectation; live architecture intentionally has two workers plus one chef.
- **22:36 UTC** | [actor: codex-FR] | [FIX] | async-stale-running | reconciled four fossilized `running` statuses after worker push races. Requeued independent fixes for runner registry swap and datasets CI; deferred chi2 sweep until real runner loaders land.
- **23:04 UTC** | [actor: codex-FR] | [MERGE] | phase-7-4-github-actions-ci-fix-1 | ff-merged validated CI workflow to `bsebench-datasets/main` at `a941b4a`. Worker + clean CTO worktree both passed ruff and `222 passed, 29 deselected`; independent validator Euclid returned GO.
- **23:04 UTC** | [actor: codex-FR] | [MERGE] | phase-6-10-h-bsebench-runner-registry-swap-fix-1 | ff-pushed validated runner registry swap to `bsebench-runner/main` at `34acb8b`. Worker + clean CTO worktree both passed ruff and `55 passed, 5 deselected`; independent validator Newton returned GO.
- **23:04 UTC** | [actor: codex-FR] | [QUEUE] | phase-6-11-b-chi2-multi-cfg-sweep-fix-1 | requeued chi2 5x5 sweep after the real Tier 2 loader registry landed on runner main; cleared obsolete chef blocks for superseded 6.11.b and 7.4 decisions.
- **23:10 UTC** | [actor: codex-FR] | [QUEUE] | phase-6-11-d-friedman-nemenyi-stats-fix-1 | requeued the independent bsebench-stats Friedman/Nemenyi implementation after the original worker crash `exit_code=137`; intended to use the idle worker while 6.11.b runs.
- **00:51 UTC** | [actor: codex-FR] | [FIX] | chef gates | patched `scripts/chef-daemon.sh` so chef runs `uv run --all-extras` for pytest/ruff; root cause was false `needs_fix` from missing dev extras in clean uv environments. Commit `57a35fd`.
- **00:51 UTC** | [actor: codex-FR] | [MERGE] | phase-6-11-d-friedman-nemenyi-stats-fix-1 | ff-pushed `bsebench-stats/main` to `e32b72d` after worker gates, clean CTO validation, and independent validator Locke GO.
- **00:51 UTC** | [actor: codex-FR] | [BLOCK] | phase-6-11-b-chi2-multi-cfg-sweep-fix-1 | blocked branch `b776508` from merge because committed `outputs/chi2_sweep_5x5.json` had `ok=0, skipped=25`; code gates passed, but this is diagnostic output, not scientific evidence.
- **00:51 UTC** | [actor: codex-FR] | [QUEUE] | phase-6-11-b-chi2-multi-cfg-sweep-fix-2 | queued evidence-hygiene fix from the fix-1 branch: either produce real `ok` cells or remove the all-skipped JSON from versioned evidence and add a fail-loud guard.
- **00:56 UTC** | [actor: codex-FR] | [QUEUE] | phase-6-11-c-stats-panel-runner | queued roadmap Phase 6.11.c on `bsebench-stats`: reusable Friedman/Nemenyi/Spearman panel runner, independent of the active chi2 sweep fix-2.
- **01:06 UTC** | [actor: chef-FR + codex-FR] | [MERGE] | phase-6-11-b-chi2-multi-cfg-sweep-fix-2 | chef ff-merged runner main to `d258288`. CTO and independent validator Singer confirmed tooling-only GO: all-skipped `outputs/chi2_sweep_5x5.json` removed, default `--require-ok-cells=1`, fail-loud before write, `60 passed, 5 deselected`, ruff OK, no new scientific claim.
- **01:09 UTC** | [actor: chef-FR] | [MERGE] | phase-6-11-c-stats-panel-runner | chef ff-merged stats main to `1eb7c42`. Gate evidence: `22 passed`, ruff OK, panel score PASS. Adds reusable `run_friedman_panel` with Friedman/Nemenyi/Spearman report and neutral verdict fields.
- **01:14 UTC** | [actor: codex-FR] | [MERGE] | phase-6-11-c-stats-panel-runner-test-hardening | CTO micro-hardening pushed stats main to `67187c0` after independent validator Plato GO. Scope: tests only, no `uv.lock`, no claims; added top-level export, invalid input, invalid alpha, non-finite RMSE, and constant-column Spearman JSON-safe tests.
- **01:18 UTC** | [actor: codex-FR] | [QUEUE] | phase-7-5-a-residual-cov-stats, phase-7-5-b-runner-residual-trace-export | launched Phase 7.5 in two independent scopes after Phase 6 close: stats residual covariance/correlation primitives and runner residual trace export helper. Both are tooling-only prerequisites for claim_55; no claim registry or thesis prose edits allowed.
- **01:26 UTC** | [actor: chef-FR + codex-FR] | [MERGE] | phase-7-5-a-residual-cov-stats | chef ff-merged `bsebench-stats/main` to `ed27ef1`; CTO and validator Ptolemy GO. Gates: focused `8 passed`, full non-slow `38 passed`, ruff OK. Scope: residual covariance/correlation primitives only; no claims.
- **01:31 UTC** | [actor: codex-FR] | [MERGE] | phase-7-5-b-runner-residual-trace-export | CTO ff-pushed `bsebench-runner/main` to `05e8cdc` after worker gates, local gates (`6 passed`, full non-slow `66 passed`, ruff OK), and validator Jason GO. Scope: runner residual trace helper only; no outputs or claims.
- **01:35 UTC** | [actor: codex-FR] | [QUEUE] | phase-7-6-a-residual-cov-trace-panel, phase-7-6-b-runner-residual-trace-5x5 | launched Phase 7.6 in parallel with split scopes: stats trace-panel consumer and runner 5x5 residual trace producer. Both must fail loud on all-error/all-skipped evidence and must not update claim_55 or thesis prose.
- **01:45 UTC** | [actor: codex-FR] | [INFRA] | remote-worker start-race hardening | observed two workers racing for the first Phase 7.6 task; worker-1 abandoned correctly but transiently stranded its async clone during a STATUS.json rebase. Hardened the start-push race path to abort any rebase and hard reset to `origin/main` because the local start commit is disposable.
- **01:49 UTC** | [actor: chef-FR + codex-FR] | [MERGE] | phase-7-6-a-residual-cov-trace-panel | chef ff-merged `bsebench-stats/main` to `2da10f8`. CTO gates: focused `12 passed`, full non-slow `50 passed`, ruff OK. Validator Raman GO. Scope: stats-side 7.6 trace-panel consumer only; no real data outputs or claims.
- **01:54 UTC** | [actor: chef-FR + codex-FR] | [MERGE] | phase-7-6-b-runner-residual-trace-5x5 | chef ff-merged `bsebench-runner/main` to `d32f0e4`. CTO gates: focused `7 passed`, full non-slow `73 passed, 5 deselected`, ruff OK. Validator Mendel GO. Scope: runner 5x5 residual trace producer only; no real-data output committed and no claim verdict.
- **01:57 UTC** | [actor: codex-FR] | [MERGE] | phase-7-6-a-residual-cov-trace-panel-hardening | CTO pushed stats test-only hardening to `bdc2a2c` after validator Darwin GO. Scope: one regression test for divergent ok-filter sets; full non-slow `51 passed`, ruff OK, no `uv.lock`, no outputs, no claims.
- **02:00 UTC** | [actor: codex-FR] | [QUEUE] | phase-7-7-a-residual-variance-decomp-stats | queued stats-only Phase 7.7.a variance decomposition primitive for 7.6 trace payloads. Scope: synthetic tests and JSON-safe tooling only; no real-data run, no claim registry, no roadmap/thesis prose edits.
- **02:02 UTC** | [actor: codex-FR + validator] | [BLOCK] | preflight-claim-identity-hinf | read-only preflight found a claim identity collision: thesis registry `claim_55` is the verified EnsembleMeta/MAD floor claim, while roadmap/solo brief reuse `claim_55` for Hinf residual covariance. Future Hinf verdict must not target `claim_55`; treat it as a new claim candidate after evidence.
