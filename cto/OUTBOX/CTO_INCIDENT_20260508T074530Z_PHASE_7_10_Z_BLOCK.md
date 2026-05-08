# CTO Incident - phase-7-10-z backlog replenishment block

Saved: 2026-05-08T07:45:30Z. Role: incident-remediation-codex-FR.

## Classification

Infra/process block, still valid as a safety stop. This is not classified as a scientific-validity block and not stale-after-fix.

The blocked worker commit is reviewable and narrow, but the target branch remains stale relative to `origin/main`. The block file must stay in place until the target branch is rebased or replayed on current `origin/main`, re-verified from the actual diff, and documented with `outbox/phase-7-10-z-autonomy-backlog-replenishment-20260508T072012Z/CTO_UNBLOCK.md`.

## Root Cause

`phase-7-10-z-autonomy-backlog-replenishment-20260508T072012Z` completed its Codex run and pushed commit `fc55fb7da89a5610b401bc11bf28bfd7ee151fae`, but `remote-worker.sh` marked the phase `status=error` because merge readiness was `stale-base`: `origin/main` was not an ancestor of the pushed branch.

Chef then took the conservative V1 path for `worker status=error`: it wrote an escalated verdict without checking out the target branch or auditing the actual changed files. The panel had only the SUMMARY and run tail, scored 81, and escalated because the real diff was unavailable. The advisor Codex invocation exited non-zero and did not write `ADVISOR_CHECK.md`; `chef-daemon.sh` defaults missing advisor output to `BLOCK`, so it wrote `outbox/_blocks/phase-7-10-z-autonomy-backlog-replenishment-20260508T072012Z.block` and paused.

## Blast Radius

- Chef-daemon is paused while `outbox/_blocks/` contains the block file.
- Normal scientific backlog queueing is paused by `cto-autonomy-pacer.sh`; only bounded block-remediation work may be queued while the block remains.
- The blocked target branch has not been merged.
- No thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files were changed by this remediation note.

## Current Evidence

- Block file: `outbox/_blocks/phase-7-10-z-autonomy-backlog-replenishment-20260508T072012Z.block` says the phase was blocked at `2026-05-08T09:39:12+02:00`, panel average 81, advisor BLOCK.
- `outbox/phase-7-10-z-autonomy-backlog-replenishment-20260508T072012Z/ADVISOR_CHECK.md` is absent. The block came from chef's conservative default after advisor Codex exit non-zero.
- `inbox/phase-7-10-z-autonomy-backlog-replenishment-20260508T072012Z/STATUS.json` records `status=error`, `exit_code=0`, worker `france-personal-2`, target branch `phase-7-10-z-autonomy-backlog-replenishment-20260508T072012Z`.
- `outbox/phase-7-10-z-autonomy-backlog-replenishment-20260508T072012Z/SUMMARY.md` records `Push result : ok`, branch SHA `fc55fb7da89a5610b401bc11bf28bfd7ee151fae`, and `Merge readiness : stale-base`.
- `outbox/phase-7-10-z-autonomy-backlog-replenishment-20260508T072012Z/PANEL_CHECK.md` records the panel concern that chef did not verify the branch diff and that changed files were unavailable.
- `outbox/phase-7-10-z-autonomy-backlog-replenishment-20260508T072012Z/KAIZEN.md` records the same process gap: chef treated worker `status=error` as terminal even though Codex exit and push were green.
- Chef log: advisor Codex exited non-zero at `2026-05-08T09:39:12+02:00`, then chef wrote the block and paused.
- Pacer log: at `2026-05-08T09:40:11+02:00`, pacer saw one block and queued this remediation phase with `force=idle_no_real_capacity`.
- Target commit `fc55fb7da89a5610b401bc11bf28bfd7ee151fae` changes only six backlog BRIEF files under `cto/AUTONOMY_BACKLOG/phase-7-10-{q,r,s,t,u,v}-*/BRIEF.md`.
- `git merge-base --is-ancestor origin/main fc55fb7da89a5610b401bc11bf28bfd7ee151fae` exits non-zero in the target repo, confirming the stale-base condition is still active.

## Exact Recovery Gate

Do not delete the block file yet.

Before unblocking, a maintainer or follow-up remediation branch must:

1. Fetch the target branch in `/mnt/c/doctorat/bsebench-org/bsebench-async-codex`.
2. Rebase or cherry-pick only the six `cto/AUTONOMY_BACKLOG/phase-7-10-{q,r,s,t,u,v}-*/BRIEF.md` additions from `fc55fb7da89a5610b401bc11bf28bfd7ee151fae` onto current `origin/main`.
3. Verify `git merge-base --is-ancestor origin/main HEAD` succeeds on the rebased target branch.
4. Re-run and record the branch gates from the worker summary: `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`, `bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh`, `git diff --check`, and the reserve count command.
5. Have chef or a maintainer inspect the actual rebased diff, not just SUMMARY artifacts.
6. Add `outbox/phase-7-10-z-autonomy-backlog-replenishment-20260508T072012Z/CTO_UNBLOCK.md` with the rebased SHA, gate outputs, changed-file list, and explicit statement that no protected thesis/registry/roadmap or `claim_55` files were touched.
7. Remove `outbox/_blocks/phase-7-10-z-autonomy-backlog-replenishment-20260508T072012Z.block` in the same commit as `CTO_UNBLOCK.md`.

Durable follow-up, separate from this unblock gate: update `scripts/chef-daemon.sh` so a worker `status=error` with `Codex exit : 0` and `Push result : ok` can fetch the target branch and classify stale-base separately before escalating.

## Remediation Validation

- `find outbox/_blocks -maxdepth 1 -type f -name '*.block' -print`: returned only `outbox/_blocks/phase-7-10-z-autonomy-backlog-replenishment-20260508T072012Z.block`.
- `pgrep -af 'worker-daemon|chef-daemon|cto-daemon|codex exec|/usr/bin/codex|@openai/codex'`: returned live worker daemons, chef daemon, CTO daemon, this remediation `codex exec`, and other active Codex worktrees.
- `bash scripts/check-research-brief-gates.sh --dry-run inbox/phase-7-10-y-block-remediation-20260508T074011Z/BRIEF.md`: passed, `1 checked, 0 skipped`.
- `bash -n scripts/cto-autonomy-pacer.sh scripts/remote-worker.sh scripts/chef-daemon.sh scripts/cto-watchdog-10min.sh`: passed.
- `git diff --check`: passed for this incident-note diff before commit.
