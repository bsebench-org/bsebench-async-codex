# Wave 8 Validation - License Evidence Gap To Backlog

GLASSBOX metadata:
- role: W8-h
- created_at: 2026-05-07T21:47:28Z
- branch: phase-8-7-h-license-evidence-gap-to-backlog-20260507T214728Z
- owned_write_set:
  - cto/AUTONOMY_BACKLOG/phase-8-dataset-license-evidence-gap-20260507/BRIEF.md
  - validation/wave-8/license-evidence-gap-to-backlog-20260507.md
- posture: current-state validation; no independent license-status assertion

## Scope Check

Owned files only were added. No thesis files, manuscript files, claim registry
files, `claims/registry.yaml`, `claim_55`, scientific roadmap files, runner
repo files, stats repo files, datasets repo files, W5/W6/W7 branches, or
protected scientific artifacts were edited.

## Evidence Inspected

Available W6-08 artifact:

- Branch:
  `phase-8-5-h-dataset-license-redteam-20260507T213656Z`
- Commit:
  `17fad26` (`GLASSBOX [role: W6-08] Audit dataset license blockers`)
- File:
  `redteam/datasets/license-redteam-20260507T213656Z.md`
- Observed changed file set from `git show --name-status`:
  `A redteam/datasets/license-redteam-20260507T213656Z.md`

Available W7 follow-up artifact:

- Branch:
  `phase-8-6-f-dataset-license-clearance-template-20260507T214305Z`
- Commit:
  `d9e757c` (`GLASSBOX [role: codex-W7-f] Add dataset license clearance template`)
- Files inspected:
  - `templates/datasets/license-clearance-template-20260507.md`
  - `validation/wave-7/dataset-license-clearance-template-20260507.md`

Unavailable or blocked evidence:

- No separate W6-08 `run.log`, `README`, or outbox directory was found in the
  current report worktree or in the W6-08 branch diff. The W6-08 branch contains
  the red-team markdown artifact as its only changed file.
- The W7 validation note says a dataset-license red-team artifact was not
  available in that worker's clone at its validation time. Current validation
  sees the W6-08 branch locally and inspected its committed artifact.
- This validation did not browse provider pages, did not contact dataset
  hosts, and did not assert that any upstream license or access status is
  currently true.

## Current-State Finding

The current evidence supports a backlog task, not a clearance decision. W6-08
reported blocker classes that must be converted into reviewed evidence rows:

- missing or unknown redistribution evidence;
- anonymous public access gaps for hosted mirrors or cache URLs;
- ambiguous separation between code, metadata, source data, and generated data
  licenses;
- runtime provenance gaps for evidence-bearing loaders;
- missing attribution/notice handling;
- prospect-only datasets with unknown redistribution status.

The new backlog brief therefore requires a committed ledger, explicit evidence
paths, anonymous access checks for intended public URLs, SHA-256 inventory for
redistributed files, attribution/notice text, and fail-closed decisions for
unknown or blocked rows.

## Acceptance Criteria Added To Backlog

The backlog task fails closed when:

- source identity is missing;
- license or provider terms evidence is missing;
- redistribution permission is ambiguous;
- attribution/notice requirements are not recorded;
- checksums for redistributed files are absent;
- an intended public URL is not anonymously accessible;
- a dataset appears only in prospects and has not been promoted to a strict
  manifest;
- any dataset-bearing artifact is present without a cleared ledger row.

The backlog task also prohibits unsupported SOTA, novelty, leaderboard,
breakthrough, superior, universal-proven, or verified scientific claims.

## Validation Commands

Commands run during this Wave 8 task:

```sh
git status --short --branch
rg --files | rg 'W6-08|w6-08|license|LICENSE|readme|README|validation/wave-6|wave-6|AUTONOMY_BACKLOG|wave-8|alpha|readiness'
git branch -a --list '*W6*' '*w6*' '*phase-6*' '*license*' '*dataset*'
git log --all --decorate --oneline --grep='W6-08\|w6-08\|license\|dataset license\|access blocker' -n 80
git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | rg -i 'w6|phase-6|license|dataset|access|blocker|evidence'
git diff --name-only origin/main..phase-8-5-h-dataset-license-redteam-20260507T213656Z
git diff --name-only origin/main..phase-8-6-f-dataset-license-clearance-template-20260507T214305Z
git show phase-8-5-h-dataset-license-redteam-20260507T213656Z:redteam/datasets/license-redteam-20260507T213656Z.md
git show phase-8-6-f-dataset-license-clearance-template-20260507T214305Z:templates/datasets/license-clearance-template-20260507.md
git show phase-8-6-f-dataset-license-clearance-template-20260507T214305Z:validation/wave-7/dataset-license-clearance-template-20260507.md
git show --stat --oneline --name-status phase-8-5-h-dataset-license-redteam-20260507T213656Z
git show --stat --oneline --name-status phase-8-7-b-datasets-current-validation-20260507T214728Z
git show --stat --oneline --name-status phase-8-7-c-stats-datasets-cross-validation-20260507T214728Z
sed -n '1,220p' cto/AUTONOMY_BACKLOG/phase-7-10-m-datasets-phase11-provenance-inventory/BRIEF.md
sed -n '1,220p' cto/AUTONOMY_BACKLOG/phase-7-10-o-runner-phase8-cross-dataset-manifest-preflight/BRIEF.md
git diff --check
```

Result:

- `git diff --check`: passed after staging the owned new files.

## Blockers

- Dataset license/access evidence is not cleared by this task. The required
  follow-up is the new backlog brief under
  `cto/AUTONOMY_BACKLOG/phase-8-dataset-license-evidence-gap-20260507/BRIEF.md`.
- No separate W6-08 run log or README output was available to inspect.
