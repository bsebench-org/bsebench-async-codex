# Hourly Red-Team Checkpoint Template

Generated: 2026-05-07T22:50:50+02:00
Worker: W4-22
Branch: phase-8-3-v-hourly-red-team-checkpoint-template-20260507T204627Z
Owned path: runbooks/hourly-red-team-checkpoint-template-20260507T204627Z.md

## Objective

Provide a repeatable hourly checkpoint that challenges Phase 8 direction,
evidence, integration readiness, and anti-hallucination controls before any
BSEBench universal-benchmark artifact is treated as merge-ready or public-facing.

The checkpoint supports the project objective that BSEBench become a universal
open SOC/SOH benchmark standard for ECMs, Kalman filters, observers, AI
estimators, hybrid methods, and future filters. It does not assert that the
objective has already been achieved.

## Evidence Inspected

- Local worktree:
  `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-3-v-hourly-red-team-checkpoint-template-20260507T204627Z`
- Watchdog log root:
  `/home/oakir/.local/state/bsebench-async-watchdog`
- Repo templates reviewed for local style:
  `templates/merge-validate-template.md`, `templates/freelance-dev-template.md`
- Local sibling target repos inspected read-only for Wave 1 branch distribution:
  `/mnt/c/doctorat/bsebench-org/bsebench-runner`,
  `/mnt/c/doctorat/bsebench-org/bsebench-stats`,
  `/mnt/c/doctorat/bsebench-org/bsebench-datasets`,
  `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report`

## Commands Run

```bash
git status --short --branch
pwd
git rev-parse --show-toplevel
git branch --show-current
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-[012]-*.log' -printf '%f\n' | sort | wc -l
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-3-*.log' -printf '%f\n' | sort | wc -l
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-*.log' -printf '%f\n' | sort | wc -l
rg -l "You've hit your usage limit|usage limit" /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-[012]-*.log | xargs -r -n1 basename | sort
git remote -v
git ls-remote --heads origin 'phase-8-0-*'
git ls-remote --heads origin 'phase-8-1-*'
git ls-remote --heads origin 'phase-8-2-*'
git ls-remote --heads origin 'phase-8-3-*'
git branch --list 'phase-8-0-*'
git branch --list 'phase-8-1-*'
git branch --list 'phase-8-2-*'
git branch --list 'phase-8-3-*'
git worktree list
git branch --list 'phase-8-0-*'  # read-only in bsebench-runner
git branch --list 'phase-8-0-*'  # read-only in bsebench-stats
git branch --list 'phase-8-0-*'  # read-only in bsebench-datasets
```

## Findings

- PASS: The original pre-Wave-4 checkpoint basis is reproducible from logs:
  48 `manual-phase-8-[012]-*.log` files exist.
- PASS: The three pre-Wave-4 usage-limit failures are identifiable and should
  remain explicit blockers until retried or accounted for:
  `manual-phase-8-2-j-reproducibility-artifact-manifest-audit-20260507T193528Z.log`,
  `manual-phase-8-2-k-merge-queue-runbook-20260507T193528Z.log`, and
  `manual-phase-8-2-l-worker-triage-and-relaunch-runbook-20260507T193528Z.log`.
- PASS WITH CONTEXT: Excluding those three usage-limit logs yields 45
  completion-like pre-Wave-4 logs.
- PASS WITH CONTEXT: Current watchdog state has moved past the original 48-log
  snapshot. It now contains 72 `manual-phase-8-*.log` files, including 24 Wave 4
  `manual-phase-8-3-*.log` files.
- PASS: Local branch/worktree evidence matches Wave 1 distribution across repos:
  runner owns Phase 8.0 `a-f`, stats owns `g-l`, datasets owns `m-r`, and the
  CTO/report async side owns `s-x`.
- PASS WITH CONTEXT: In this CTO/report repo, local branches show Wave 2
  `phase-8-1-k` through `phase-8-1-v`, Wave 3 `phase-8-2-a` through
  `phase-8-2-l`, and Wave 4 `phase-8-3-a` through `phase-8-3-x`.
- WARN: Remote heads are not a complete historical branch ledger. At inspection
  time, this repo's remote heads showed only already-pushed subsets for earlier
  waves and no Wave 4 heads yet. The checkpoint must therefore require local
  worktree, watchdog-log, and target-repo evidence instead of relying on one
  repo's remote head list.

## Hourly Checkpoint Procedure

Copy the section below for each hourly red-team pass. Keep answers short,
evidence-backed, and falsifiable.

```markdown
## Red-Team Checkpoint: <ISO timestamp>

Reviewer:
Scope under review:
Branches/logs/artifacts inspected:

### 1. Direction Challenge

- What user-facing benchmark objective is this wave advancing?
- Which methods/classes are covered: ECMs, Kalman filters, observers, AI
  estimators, hybrid methods, future filters, or governance-only artifacts?
- What would make this direction the wrong next step?
- Which adjacent work should pause if this checkpoint fails?

Decision: GO | STOP | REWORK
Evidence:

### 2. Evidence Challenge

- What concrete files, commits, logs, commands, and outputs support the claim of
  completion?
- Which evidence is absent, indirect, generated from logs only, or not yet
  source-ledgered?
- Are usage-limit, timeout, all-skipped, all-error, auth, cache, or missing-data
  failures accounted for by name?
- Can an independent reviewer reproduce the same finding without reading model
  chat context?

Decision: GO | STOP | REWORK
Evidence:

### 3. Anti-Hallucination Challenge

- Does any text imply SOTA, novelty, leaderboard status, benchmark dominance,
  breakthrough, verified scientific claim, or public standard status?
- If yes, is every such sentence backed by a completed source ledger and a
  named artifact?
- Are non-claims explicit enough that a downstream merger cannot accidentally
  cite the artifact as scientific validation?
- Are branch names, log counts, dates, and failure names mechanically checked?

Decision: GO | STOP | REWORK
Evidence:

### 4. Integration Challenge

- Does the branch touch only its owned write-set?
- Are thesis, manuscript, claim registry, `claims/registry.yaml`, `claim_55`,
  and scientific-roadmap files untouched?
- Are code-worker write-sets duplicated or overridden?
- Does `git diff --check` pass?

Decision: GO | STOP | REWORK
Evidence:

### 5. Residual Risk Challenge

- What remains unknown after this pass?
- Which unknowns can change the merge decision?
- What is the smallest next evidence item that would reduce the biggest risk?
- Who owns that next evidence item?

Decision: GO | STOP | REWORK
Evidence:
```

## Falsification Questions

Ask these every hour. A single confirmed "yes" under a STOP rule is enough to
halt merge/public-facing use until the evidence is fixed.

1. Can any completion-like Phase 8 log be shown to contain an unresolved usage
   limit, timeout, auth failure, all-skipped output, all-error output, or missing
   push?
2. Can any branch name in the wave ledger fail to resolve locally, remotely, or
   in the target repo claimed by its log?
3. Can any artifact claim more than its inspected evidence supports?
4. Can any artifact be read as validating SOTA, novelty, leaderboard position,
   breakthrough status, or a verified scientific claim without a completed
   source ledger?
5. Can any Phase 8 validation artifact cite chat memory, intention, or unstated
   context instead of file/commit/log/command evidence?
6. Can any merge-ready label be assigned while the three prior usage-limit Wave 3
   logs are neither retried nor explicitly accounted for?
7. Can any branch touch thesis, manuscript, claim registry, `claim_55`,
   `claims/registry.yaml`, scientific roadmap, or code-worker write-sets outside
   its assigned scope?
8. Can an independent reviewer reproduce a pass/fail decision using only the
   named files, commands, and commits?

## Stop/Go Criteria

### STOP

- Any unsupported SOTA, novelty, leaderboard, breakthrough, public-standard, or
  verified-claim language is present without a completed source ledger.
- Any forbidden write-set is modified.
- Any claimed completed task has unresolved usage-limit, timeout, all-skipped,
  all-error, missing-branch, missing-push, missing-commit, or missing-validation
  evidence.
- The reviewer cannot name the file/commit/log/command supporting a finding.
- `git diff --check` fails and is not fixed before commit.

### REWORK

- Evidence exists but is indirect, log-only, stale, or split across repos without
  a branch ledger.
- The artifact is useful but lacks explicit non-claims.
- The artifact passes scope checks but does not define a falsifiable next gate.
- Remote branch evidence differs from local worktree evidence and the reason is
  not recorded.

### GO

- Scope is limited to the owned write-set.
- Required commands and evidence are listed with exact paths or branch names.
- Usage-limit and retry accounting is explicit.
- Claims are limited to process, validation, or template readiness.
- All public/scientific language is either removed or source-ledgered.
- `git diff --check` passes.

## Evidence Requirements

Minimum evidence for each hourly checkpoint:

- Current branch and worktree:
  `git status --short --branch`, `git branch --show-current`,
  `git rev-parse --show-toplevel`
- Changed files:
  `git diff --name-status` before commit, `git show --stat --oneline HEAD`
  after commit
- Log ledger:
  counts for pre-Wave-4 `manual-phase-8-[012]-*.log`, current
  `manual-phase-8-*.log`, and named usage-limit logs
- Branch ledger:
  target-repo-local branch list plus remote head list, with mismatches explained
- Scope guard:
  explicit statement that thesis, manuscript, claim registry, `claim_55`,
  `claims/registry.yaml`, scientific roadmap, and code-worker write-sets were
  not edited
- Formatting guard:
  `git diff --check`
- Non-claim guard:
  explicit list of phrases not asserted by the artifact

## Recommendations

- Treat the original 45 completion-like logs as a checkpoint basis, not as a
  scientific validation result.
- Keep the three prior usage-limit Wave 3 logs named in every merge-readiness
  dashboard until retry branches or accounting artifacts close them.
- Require cross-repo branch evidence for Phase 8.0 because the branch alphabet
  is distributed across runner, stats, datasets, and async/report scopes.
- Require every validation artifact to include a "non-claims" section before it
  can be merged into a public-facing narrative.
- Prefer STOP over ambiguous GO when branch refs, logs, or source-ledger evidence
  disagree.

## Residual Risks

- The watchdog directory is live; counts can change during Wave 4 execution.
- Remote branches may be deleted after merge, so remote refs alone are not a
  stable historical ledger.
- Completion-like logs are not equivalent to independent source-ledgered
  validation.
- This template does not inspect scientific datasets, benchmark outputs, or
  claim registries.
- This template cannot prove future workers will use it correctly; it only makes
  the falsification and evidence requirements explicit.

## Explicit Non-Claims

- This artifact does not claim BSEBench is already a universal standard.
- This artifact does not claim SOTA, novelty, leaderboard, breakthrough, or
  verified scientific status for any method or benchmark result.
- This artifact does not validate ECMs, Kalman filters, observers, AI
  estimators, hybrid methods, or future filters scientifically.
- This artifact does not update thesis prose, manuscript prose, claim registry
  files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap.
- This artifact does not approve any code-worker branch for merge.

## Artifact Validation

- `git diff --check`: PASS after intent-to-add validation of this new file.
- Scope: intended single-file addition under
  `runbooks/hourly-red-team-checkpoint-template-20260507T204627Z.md`.
