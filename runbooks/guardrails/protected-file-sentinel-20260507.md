# Protected-File Sentinel Runbook

Date: 2026-05-07
Scope: async branch merge/publication preflight
Owner: release/integration operator

## Purpose

Use this runbook before merging or publishing any autonomous branch. The
sentinel verifies that the branch did not touch protected thesis, claims,
`claim_55`, manuscript, or roadmap files. It also re-runs the existing async
research BRIEF guardrail and whitespace checks.

This is a fail-closed gate. If any command in this runbook fails, stop the merge
or publication step until a human release operator reviews the branch.

## Protected File Families

Treat a changed path as protected if it matches any of these families:

- thesis paths or filenames: `thesis`, `these`, `dissertation`
- manuscript paths or filenames: `manuscript`, `paper`, `draft`
- roadmap paths or filenames: `roadmap`, `RESEARCH-ROADMAP`
- claim registry paths: `claims/`, `claim-registry`, `claims/registry.yaml`
- protected claim identity paths: `claim_55`, `claim-55`, `claim55`

The guard is path-based. It does not approve or reject scientific content; it
only verifies that protected files were not changed by the autonomous branch.

## Preconditions

Run from the async CTO report repository root.

```bash
git status --short --branch
git branch --show-current
git fetch origin main
```

Fail conditions:

- `git status --short --branch` shows unexpected local changes outside the
  release branch under review.
- `git branch --show-current` is not the autonomous branch being reviewed.
- `git fetch origin main` fails.

## Branch Diff Sentinel

Set the base ref and inspect every path changed by the branch:

```bash
BASE_REF="${BASE_REF:-origin/main}"
git diff --name-only --diff-filter=ACDMRTUXB "$BASE_REF"...HEAD
```

Fail condition:

- The changed-file list contains any protected file family.

Run the path sentinel:

```bash
BASE_REF="${BASE_REF:-origin/main}"
protected_paths="$(
  git diff --name-only --diff-filter=ACDMRTUXB "$BASE_REF"...HEAD |
    rg -i '(^|/)(claims(/|$)|.*claims.*|.*claim-registry.*|claims/registry\.ya?ml$|claim[-_]?55([^[:alnum:]]|$)|claim55([^[:alnum:]]|$)|.*thesis.*|.*these.*|.*dissertation.*|.*manuscript.*|.*paper.*|.*draft.*|.*roadmap.*|RESEARCH-ROADMAP[^/]*)' || true
)"
if [ -n "$protected_paths" ]; then
  printf '%s\n' "[FAIL] protected files changed:"
  printf '%s\n' "$protected_paths"
  exit 1
fi
printf '%s\n' "[OK] no protected files changed"
```

Fail condition:

- The command prints `[FAIL] protected files changed:` and exits nonzero.

## Working Tree Sentinel

Before committing or amending, also check unstaged and staged paths:

```bash
protected_worktree="$(
  {
    git diff --name-only --diff-filter=ACDMRTUXB
    git diff --cached --name-only --diff-filter=ACDMRTUXB
  } |
    sort -u |
    rg -i '(^|/)(claims(/|$)|.*claims.*|.*claim-registry.*|claims/registry\.ya?ml$|claim[-_]?55([^[:alnum:]]|$)|claim55([^[:alnum:]]|$)|.*thesis.*|.*these.*|.*dissertation.*|.*manuscript.*|.*paper.*|.*draft.*|.*roadmap.*|RESEARCH-ROADMAP[^/]*)' || true
)"
if [ -n "$protected_worktree" ]; then
  printf '%s\n' "[FAIL] protected local paths staged or modified:"
  printf '%s\n' "$protected_worktree"
  exit 1
fi
printf '%s\n' "[OK] no protected local paths staged or modified"
```

Fail condition:

- The command prints `[FAIL] protected local paths staged or modified:` and
  exits nonzero.

## Existing Research Guardrail

Run the repository guardrail only on BRIEFs changed by the branch:

```bash
BASE_REF="${BASE_REF:-origin/main}"
mapfile -t changed_briefs < <(
  git diff --name-only --diff-filter=ACDMRTUXB "$BASE_REF"...HEAD -- \
    'inbox/phase-7*/BRIEF.md' \
    'inbox/phase-8*/BRIEF.md' \
    'inbox/phase-11*/BRIEF.md' \
    'cto/AUTONOMY_BACKLOG/phase-7*/BRIEF.md' \
    'cto/AUTONOMY_BACKLOG/phase-8*/BRIEF.md' \
    'cto/AUTONOMY_BACKLOG/phase-11*/BRIEF.md'
)
if [ "${#changed_briefs[@]}" -gt 0 ]; then
  bash scripts/check-research-brief-gates.sh --dry-run "${changed_briefs[@]}"
else
  printf '%s\n' "[OK] no changed Phase 7/8/11 BRIEF files"
fi
```

Fail conditions:

- The command exits nonzero.
- Any checked BRIEF is missing falsification wording, validation or replay
  wording, no thesis or claim-registry edit wording, no `claim_55` targeting
  wording, or unsupported SOTA wording.

## Commit Metadata Sentinel

Autonomous release branches must not carry a Claude co-author trailer:

```bash
BASE_REF="${BASE_REF:-origin/main}"
if git log --format=%B "$BASE_REF"..HEAD | rg -i 'Co-Authored-By:.*Claude'; then
  printf '%s\n' "[FAIL] forbidden Claude co-author trailer found"
  exit 1
fi
printf '%s\n' "[OK] no forbidden Claude co-author trailer"
```

Fail condition:

- The command prints a matching trailer and exits nonzero.

## Whitespace Sentinel

Run the standard git whitespace check:

```bash
git diff --check
```

Fail condition:

- The command exits nonzero or reports whitespace errors.

## Required Release Log Entry

Record these values in the final merge/publication note:

- branch name
- base ref used for the sentinel
- full changed-file list from `git diff --name-only`
- protected path sentinel result
- existing research guardrail result
- `git diff --check` result
- commit SHA
- push status
- blocker status

## Stop Conditions

Stop and escalate to the release operator if any of the following is true:

- Any protected file path appears in the branch diff, staged diff, or unstaged
  diff.
- The existing research BRIEF guardrail fails.
- `git diff --check` fails.
- The commit metadata includes `Co-Authored-By: Claude`.
- The branch cannot be pushed cleanly.
