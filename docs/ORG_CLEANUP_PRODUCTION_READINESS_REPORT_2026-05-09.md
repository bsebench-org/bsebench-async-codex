# BSEBench Organization Cleanup And Production Readiness Report

Generated: 2026-05-09 20:51 CEST

Scope: final organization hygiene check before opening Phase 16.

## Executive Verdict

The local workspace and current production `main` branches are clean and ready
for Phase 16 work.

The whole GitHub organization is not yet branch-empty, by design. A large set
of remote branches remains unmerged into `origin/main`; those branches may
contain unique commits. They must not be deleted blindly.

Release state:

- Local workspace: `PRODUCTION_READY_FOR_PHASE_16`.
- Current `main` branches: `CLEAN_AND_ALIGNED`.
- Safe remote branch cleanup: `COMPLETE`.
- Risky remote branch cleanup: `BLOCKED_PENDING_ARCHIVE_REVIEW`.
- Scientific status: `NO_GO_CLAIM`.

## What Was Cleaned

Removed local workspace clutter directories:

```text
bsebench-async-codex-bootstrap
bsebench-async-codex-deploy
bsebench-async-codex-diag
bsebench-async-codex-merge-validate
bsebench-async-codex-worker-2
bsebench-datasets-canary
```

These were either empty temporary folders or stale worker/check clones. The only
remaining BSEBench directories in the workspace are the seven canonical repos:

```text
bsebench-async-codex
bsebench-datasets
bsebench-filters
bsebench-runner
bsebench-specs
bsebench-stats
bsebench-website
```

## Safe Remote Branch Deletions

Only branches proven by Git to be merged into `origin/main` were deleted.

Deletion rule:

```text
git branch -r --merged origin/main
```

Excluded from deletion:

```text
origin/main
origin/master
origin/HEAD
```

Deleted branch count:

| Repo | Deleted merged remote branches |
| --- | ---: |
| `bsebench-async-codex` | 3 |
| `bsebench-specs` | 7 |
| `bsebench-filters` | 7 |
| `bsebench-stats` | 17 |
| `bsebench-runner` | 17 |
| `bsebench-datasets` | 15 |
| `bsebench-website` | 0 |
| Total | 66 |

Reason for deletion: each branch was already reachable from `origin/main`.
Deleting these references does not delete integrated commits from the project
history.

Deleted branch ledger source during the operation:

```text
/tmp/bsebench_deleted_merged_branches.tsv
```

## Remaining Remote Branches

After fetch/prune and safe deletion, no merged non-default remote branches
remain.

Remaining remote branches are all non-merged relative to `origin/main`:

| Repo | Merged remote branches remaining | Non-merged remote branches remaining |
| --- | ---: | ---: |
| `bsebench-async-codex` | 0 | 212 |
| `bsebench-specs` | 0 | 18 |
| `bsebench-filters` | 0 | 17 |
| `bsebench-stats` | 0 | 71 |
| `bsebench-runner` | 0 | 74 |
| `bsebench-datasets` | 0 | 67 |
| `bsebench-website` | 0 | 1 |
| Total | 0 | 460 |

These branches were intentionally not deleted. They are not ancestors of
`origin/main`; deleting them without an archive/review step could lose unique
work.

## Why Non-Merged Branches Were Kept

The user requested no branch left behind and production-ready cleanup. That goal
is correct, but safe engineering requires a distinction:

- Merged branch: safe to delete.
- Non-merged branch: may contain unique commits, artifacts, reports, or failed
  experiments that still matter.

The non-merged branches include older Phase 7/8/9/10/11/12/13 task branches,
refill branches, audits, remediation loops, and status/documentation branches.
Some are likely obsolete. Some may contain unique evidence or useful code that
was superseded but not merged. They require a branch-by-branch archive ledger
before deletion.

Production readiness does not require deleting unique historical branches today.
It requires:

1. current `main` branches clean;
2. no stale local worktrees;
3. no merged branch clutter;
4. clear ledger of non-merged branch debt;
5. no hidden uncommitted changes.

Those conditions are satisfied except for the known non-merged remote branch
debt, which is documented and isolated.

## Current Local Repo State

All canonical local repos are on `main` and aligned with `origin/main`:

```text
bsebench-async-codex  main...origin/main
bsebench-specs        main...origin/main
bsebench-filters      main...origin/main
bsebench-stats        main...origin/main
bsebench-runner       main...origin/main
bsebench-datasets     main...origin/main
bsebench-website      main...origin/main
```

All local phase branches were already absent before this cleanup:

```text
bsebench-async-codex  local=main
bsebench-specs        local=main
bsebench-filters      local=main
bsebench-stats        local=main
bsebench-runner       local=main
bsebench-datasets     local=main
bsebench-website      local=main
```

## GitHub CLI State

`gh` is now available inside WSL through a wrapper:

```text
/home/oakir/.local/bin/gh
```

Wrapper target:

```text
/mnt/c/Program Files/GitHub CLI/gh.exe
```

Version:

```text
gh version 2.62.0 (2024-11-14)
```

Authentication state:

```text
gh auth status -> not logged into any GitHub hosts
```

Remote branch cleanup used existing Git credentials through `git push
origin --delete`, not `gh`.

## Required Future Cleanup For True Branch-Zero Organization

Do not bulk-delete the 460 non-merged branches. Use this procedure:

1. For each repo, list `git branch -r --no-merged origin/main`.
2. For each branch, record:
   - branch name;
   - tip SHA;
   - commit count ahead of `origin/main`;
   - changed file list;
   - whether the changes are obsolete, superseded, or still useful.
3. If useful:
   - cherry-pick, merge, or port the useful files into `main`;
   - add tests;
   - document the integration.
4. If obsolete:
   - write a ledger reason;
   - optionally export a patch with `git format-patch` or `git diff`;
   - delete the remote branch.
5. Commit the cleanup ledger in `bsebench-async-codex/docs`.

This is a full task by itself. It should not block Phase 16 unless the branch
debt touches the exact Phase 16 files being edited.

## Phase 16 Gate

Phase 16 may start from the current local production state.

Mandatory Phase 16 constraints:

- Keep `NO_GO_CLAIM`.
- Start with adversarial claim-readiness validation.
- Do not publish, upload, or claim performance.
- Do not delete remaining non-merged remote branches without a ledger.
- Do not use old branches as evidence unless they are replayed or explicitly
  archived into a current report.

Recommended first Phase 16 artifact:

```text
bsebench-async-codex/docs/PHASE_16_OPENING_AUDIT_2026-05-09.md
```

Recommended first product task:

```text
bsebench-stats: claim-readiness/adversarial review schema and gate
```

## Final Decision

Proceed to Phase 16 from current `main` branches.

Do not promise that the GitHub organization has zero branch debt. It does not.
Promise the accurate production condition:

```text
All current production mains are clean.
All safe merged branch references were removed.
All risky non-merged branch references are documented and preserved.
Phase 16 can start without relying on stale worktrees or hidden local changes.
```

