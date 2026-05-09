# Workspace Cleanup Audit

Date: 2026-05-09 10:18 CEST

Status: `CLEANUP_COMPLETE`

Scope: BSEBench organization workspace cleanup before Phase 12. This report is
operational only. It does not change scientific roadmap, thesis prose, claim
registry, dataset content, or external-result claims.

## Why Cleanup Was Required

The workspace had accumulated thousands of Phase 7/8/9/10/11 worktrees,
validation clones, refill clones, and local branches. This made three things
unsafe:

- branch ownership was ambiguous;
- active-worker counts were noisy and hard to trust;
- launching Phase 12 would risk writing on stale worktrees instead of current
  product heads.

The decision was to archive first, then clean aggressively.

## Archive Location

Durable archive:

`/mnt/c/doctorat/bsebench-org/.cleanup-archive-20260509T092936`

Contents include:

- all-ref Git bundles for async/specs/datasets/stats/runner/filters/website;
- dirty patches and patch stats for product repos before reset;
- branch and worktree inventories before cleanup;
- reset/fast-forward logs;
- local branch deletion log;
- archived untracked async file;
- archived old top-level CTO/report directories.

This means deleted local branches and removed worktree directories are
recoverable from the archive if needed.

## Product Repositories

All product repositories now have only the primary `main` worktree registered:

| Repo | Branch | Secondary worktrees | Status | Head |
| --- | --- | ---: | --- | --- |
| `bsebench-specs` | `main` | `0` | clean | `2964ed7 GLASSBOX harden phase 9-11 schema evidence` |
| `bsebench-datasets` | `main` | `0` | clean | `e128cb3 GLASSBOX enable Phase 10 NASA aging SOH readiness` |
| `bsebench-stats` | `main` | `0` | clean | `ff68465 GLASSBOX add Phase 11 residual diagnostics readiness` |
| `bsebench-runner` | `main` | `0` | clean | `cc9e89b GLASSBOX refresh Phase 10 strict smoke artifacts` |
| `bsebench-filters` | `main` | `0` | clean | `bb72d59 GLASSBOX add Phase 10 bounded projection adapter` |
| `bsebench-website` | `main` | `0` | clean | `35c0ddd docs(datasets): publish V1.0 5-dataset roster + selection methodology` |

`bsebench-async-codex` also has only its primary `main` worktree after cleanup.

## Reset And Fast-Forward Decisions

Dirty product main worktrees were archived as patches before reset. Then each
repo was reset to its current `HEAD` and fast-forwarded on `main`.

Reason: those dirty diffs were pre-existing, broad, and not tied to an active
Phase 12 task. Keeping them in-place would pollute validation and make future
commits unverifiable. Archiving preserved the data without allowing it to
distort current-head work.

Fast-forward results:

- `bsebench-specs`: `51917f0` -> `2964ed7`
- `bsebench-datasets`: `88a9096` -> `e128cb3`
- `bsebench-stats`: `6b09b1f` -> `ff68465`
- `bsebench-runner`: `c062da5` -> `cc9e89b`
- `bsebench-filters`: already at `bb72d59`
- `bsebench-website`: already at `35c0ddd`

## Worktrees Removed

Registered non-main worktrees before cleanup:

- `bsebench-async-codex`: `196`
- `bsebench-specs`: `125`
- `bsebench-datasets`: `494`
- `bsebench-stats`: `493`
- `bsebench-runner`: `503`
- `bsebench-filters`: `127`
- `bsebench-website`: `1`

Registered non-main worktrees after cleanup:

- all seven repos: `0`

Reason: stale Phase 9/10/11 refill/validation worktrees were already represented
in branch refs and all-ref bundles. Keeping them on disk added risk but no
execution value.

## Branches Cleaned

Local branches were archived in repo bundles, then local non-`main` branches
were deleted. Remote branches were not deleted.

| Repo | Local branches before | Local branches after |
| --- | ---: | ---: |
| `bsebench-async-codex` | `472` | `1` |
| `bsebench-specs` | `126` | `1` |
| `bsebench-datasets` | `495` | `1` |
| `bsebench-stats` | `494` | `1` |
| `bsebench-runner` | `503` | `1` |
| `bsebench-filters` | `128` | `1` |
| `bsebench-website` | `2` | `1` |

Reason: local branch sprawl was no longer useful after merge/fast-forward and
bundle archival. Remote branch deletion is intentionally deferred because it is
a GitHub maintenance decision with collaboration impact.

## Top-Level Directories

After registered worktree cleanup, `153` stale top-level CTO/report directories
were moved into:

`/mnt/c/doctorat/bsebench-org/.cleanup-archive-20260509T092936/archived_top_level_dirs`

Remaining phase-like directories at workspace root:

- `/mnt/c/doctorat/bsebench-org/.phase9-local-cache`
- `/mnt/c/doctorat/bsebench-org/.phase10-local-cache`

Reason kept: those are small validation caches used by Phase 9/10 smoke and
audit commands.

## Async Untracked Cleanup

Archived:

- `outbox/phase-7-10-z-autonomy-backlog-replenishment-20260508T135020Z/CHEF_VERDICT.md`

Deleted as generated:

- `scripts/__pycache__/`
- `tests/__pycache__/`

Reason: keep human/agent verdict content recoverable, remove generated Python
cache files.

## Active Processes

Observed process still running:

- `/mnt/c/doctorat/bsebench-org/bsebench-async-codex/scripts/cto_readonly_status_loop.py`

No OS-level `codex exec`, worker-daemon, chef-daemon, or cto-daemon process was
active at the cleanup snapshot. The readonly status loop is kept because it
updates mobile status and does not mutate product repos.

## Protected Areas

`/mnt/c/doctorat/these_lfp_2026` was not destructively cleaned. It has thesis
and manuscript context outside this cleanup scope. Any cleanup there needs a
separate thesis-specific archive/merge decision.

## Phase 12 Gate

Phase 12 can now start from clean product `main` worktrees. First-wave
parallelism should be limited to useful disjoint work:

- specs transfer schema;
- datasets transfer inventory;
- stats transfer preflight;
- filters parameter-freeze metadata;
- runner transfer-plan dry-run;
- async worker briefs/status;
- dataset registry/HF consolidation workers gated by line-level source/license
  status, not blind upload.

Phase 12 remains `NO_GO_CLAIM`.
