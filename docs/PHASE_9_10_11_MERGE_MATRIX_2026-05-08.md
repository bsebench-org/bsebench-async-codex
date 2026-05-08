# Phase 9/10/11 Merge Matrix - 2026-05-08

Snapshot: 2026-05-08T21:56:00+0200
Scope: Phase 9/10/11 closure branches only.
Directive: Do not merge from this document. Use it to order validation and to
identify missing evidence before any branch is selected for integration.

## Sources

- Local checkpoint report:
  `/home/oakir/.local/state/bsebench-async-watchdog/phase9-11-checkpoint-status.md`
  reported 17 active workdirs, target 17, and zero upload processes at
  2026-05-08T21:51:44+0200.
- Local git status and branch heads in the Phase 9/10/11 refill worktrees.
- Existing dependency order in `docs/PHASE-9-10-11-DAG-2026-05-08.md`.
- Audit gate policy in `docs/POST_PHASE_11_GENERAL_AUDIT_PLAN_2026-05-08.md`.

## Current Decision

- Merge status: `NO_GO_MERGE`.
- Empirical scheduling status: `NO_GO_EMPIRICAL`.
- Scientific status: `NO_GO_CLAIM`.
- Public status: `NO_GO_PUBLIC`.

The checkpoint remains blocked until cache/provenance, Tier2, source-ledger,
and empirical-run evidence are present where required. Tooling branches may
become merge candidates only after their local branch state, tests, format
checks, diff checks, push status, and protected-edit audit are reverified on a
clean integration base.

## Base Hygiene

The product repo bases are not uniformly clean and current. These base states
block direct merge work until a coordinator refreshes and isolates unrelated
changes.

| Repo | Main snapshot | Local base state | Merge implication |
| --- | --- | --- | --- |
| `bsebench-runner` | `cf65627e7091` | `main` behind `origin/main` by 3, clean worktree | Refresh before validating runner branches. |
| `bsebench-stats` | `b929c8fcf7c2` | `main` behind `origin/main` by 1, clean worktree | Refresh before validating stats branches. |
| `bsebench-datasets` | `f74d3267e7aa` | `main` behind `origin/main` by 4, clean worktree | Refresh before validating dataset branches. |
| `bsebench-specs` | `f928a185a619` | `main` behind `origin/main` by 19, 24 local changes | Do not use this base for merge validation. |
| `bsebench-filters` | `1117d17fa13f` | `main` behind `origin/main` by 2, 31 local changes | Do not use this base for merge validation. |
| `bsebench-async-codex` | `c7c8c2cc2807` | base worktree has 3 unrelated local entries; this worktree was clean before this matrix edit | Keep staging explicit. |

## Branch Matrix

Rows below are a point-in-time map of the latest local refill worktree observed
for each objective. A branch with `ahead=0` is a placeholder worktree, not an
integration candidate. A branch with local changes is blocked until committed,
pushed, and independently revalidated. A clean branch with commits is still only
a candidate until the validation artifacts are attached.

| Order | Objective | Repo | Branch | Snapshot SHA | State | Required next gate |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `p9-11-anti-claim-audit` | `bsebench-async-codex` | `phase9-11-refill-p9-11-anti-claim-audit-20260508T214757+0200` | `c7c8c2cc280701dd7f345b6e6d1f6511f6515fb9` | `BLOCKED_UNCOMMITTED`, `ahead=0`, local changes observed | Finish worker branch, then run protected-edit and wording guards. |
| 2 | `p9-11-no-claims-linter` | `bsebench-stats` | `phase9-11-refill-p9-11-no-claims-linter-20260508T215035+0200` | `b929c8fcf7c2a2bd7498e5f948a21c8736080ecd` | `BLOCKED_NO_BRANCH_DELTA`, `ahead=0` | Wait for a GLASSBOX delta and focused stats validation. |
| 3 | `p9-11-local-path-discovery` | `bsebench-datasets` | `phase9-11-refill-p9-11-local-path-discovery-20260508T215013+0200` | `f74d3267e7aadc47f6b2f8c22608decd325a0d05` | `BLOCKED_NO_BRANCH_DELTA`, `ahead=0` | Wait for read-only path report and redacted evidence. |
| 4 | `p9-tier2-profile-cache` | `bsebench-datasets` | `phase9-11-refill-p9-tier2-profile-cache-20260508T215254+0200` | `f74d3267e7aadc47f6b2f8c22608decd325a0d05` | `BLOCKED_NO_BRANCH_DELTA`, `ahead=0` | Require Tier2 profile cache/provenance evidence. |
| 5 | `p10-tier2-aging-cache` | `bsebench-datasets` | `phase9-11-refill-p10-tier2-aging-cache-20260508T215302+0200` | `f74d3267e7aadc47f6b2f8c22608decd325a0d05` | `BLOCKED_NO_BRANCH_DELTA`, `ahead=0` | Require aging/SOH cache/provenance and split evidence. |
| 6 | `p11-tier2-residual-cache` | `bsebench-datasets` | `phase9-11-refill-p11-tier2-residual-cache-20260508T215408+0200` | `f74d3267e7aadc47f6b2f8c22608decd325a0d05` | `BLOCKED_NO_BRANCH_DELTA`, `ahead=0` | Require unit, cadence, residual cache, and provenance evidence. |
| 7 | `p9-11-schema-export-audit` | `bsebench-specs` | `phase9-11-refill-p9-11-schema-export-audit-20260508T214207+0200` | `e84672f63bc0ae5006f7f5652b234d8dc5a0df62` | `CANDIDATE_NEEDS_REVALIDATION`, `ahead=1`, clean | Rebase onto a clean specs base, rerun schema export tests and diff checks. |
| 8 | `p9-11-contract-export-audit` | `bsebench-filters` | `phase9-11-refill-p9-11-contract-export-audit-20260508T214209+0200` | `c8c5c6de158f1176ec503b1be328112d9ce5e7b1` | `CANDIDATE_NEEDS_REVALIDATION`, `ahead=1`, clean | Rebase onto a clean filters base, rerun contract/export tests and diff checks. |
| 9 | `p9-profile-empirical-scheduler` | `bsebench-runner` | `phase9-11-refill-p9-profile-empirical-scheduler-20260508T214007+0200` | `3e949c914b5de334a0e3a131eba51b19c18f33d4` | `CANDIDATE_NEEDS_REVALIDATION`, `ahead=1`, clean | Validate after profile Tier2/cache and schema/filter gates. |
| 10 | `p10-aging-empirical-scheduler` | `bsebench-runner` | `phase9-11-refill-p10-aging-empirical-scheduler-20260508T214017+0200` | `cf65627e7091fe77d17f5833055f712dd5969138` | `BLOCKED_UNCOMMITTED`, `ahead=0`, local changes observed | Finish branch, then validate after aging/SOH cache and split gates. |
| 11 | `p11-residual-trace-scheduler` | `bsebench-runner` | `phase9-11-refill-p11-residual-trace-scheduler-20260508T214023+0200` | `1aeaeafeb029851bd9b2689b075962aae694208d` | `CANDIDATE_NEEDS_REVALIDATION`, `ahead=1`, clean | Validate after residual cache, unit, cadence, schema, and filter gates. |
| 12 | `p9-11-dryrun-cli-smoke` | `bsebench-runner` | `phase9-11-refill-p9-11-dryrun-cli-smoke-20260508T215025+0200` | `cf65627e7091fe77d17f5833055f712dd5969138` | `BLOCKED_UNCOMMITTED`, `ahead=0`, local changes observed | Finish branch and prove tiny dry-run CLI fixtures only. |
| 13 | `p9-profile-verdict-inputs` | `bsebench-stats` | `phase9-11-refill-p9-profile-verdict-inputs-20260508T214031+0200` | `67695dfe27ee2ed48f05851ec5a4ba61ae3b8604` | `CANDIDATE_NEEDS_REVALIDATION`, `ahead=1`, clean | Validate only after empirical profile artifacts and source-ledger IDs exist. |
| 14 | `p10-aging-verdict-inputs` | `bsebench-stats` | `phase9-11-refill-p10-aging-verdict-inputs-20260508T214101+0200` | `d31337a63b4839fea1c0184f30c8eb8ff78fd8db` | `CANDIDATE_NEEDS_REVALIDATION`, `ahead=1`, clean | Validate only after aging/SOH empirical artifacts and source-ledger IDs exist. |
| 15 | `p11-residual-verdict-inputs` | `bsebench-stats` | `phase9-11-refill-p11-residual-verdict-inputs-20260508T214201+0200` | `b929c8fcf7c2a2bd7498e5f948a21c8736080ecd` | `BLOCKED_UNCOMMITTED`, `ahead=0`, local changes observed | Finish branch; require residual traces with explicit component evidence. |
| 16 | `p9-11-checkpoint-report` | `bsebench-async-codex` | `phase9-11-refill-p9-11-checkpoint-report-20260508T214501+0200` | `c7c8c2cc280701dd7f345b6e6d1f6511f6515fb9` | `BLOCKED_UNCOMMITTED`, `ahead=0`, local changes observed | Finish only after branch rows above have stable evidence. |
| 17 | `p9-11-merge-matrix` | `bsebench-async-codex` | `phase9-11-refill-p9-11-merge-matrix-20260508T214701+0200` | `c7c8c2cc280701dd7f345b6e6d1f6511f6515fb9` | `IN_PROGRESS_THIS_BRANCH` | Commit this matrix and validator, then push. |
| 18 | `p9-11-acceptance-gate` | `bsebench-async-codex` | `phase9-11-refill-p9-11-acceptance-gate-20260508T215244+0200` | `c7c8c2cc280701dd7f345b6e6d1f6511f6515fb9` | `BLOCKED_NO_BRANCH_DELTA`, `ahead=0` | Run after checkpoint report and matrix are current. |

## Validation Order

1. Freeze branch rows: refresh remotes, record full `HEAD`, `git status -sb`,
   push status, and changed files for each candidate. If any row changed from
   this snapshot, update the matrix before reviewing.
2. Clean base worktrees: isolate unrelated specs, filters, and async base
   changes before any product branch validation.
3. Run guardrails first: protected-edit scope, forbidden public wording,
   no upload processes, no dataset downloads, and no thesis or protected-claim
   file edits.
4. Validate datasets: profile Tier2 cache, aging/SOH cache, residual cache,
   unit/cadence evidence, and local path discovery. Missing evidence keeps the
   downstream rows blocked.
5. Validate specs and filters: schema/export and contract/export audits must be
   green before runner schedulers are interpreted.
6. Validate runners: profile, aging/SOH, and residual schedulers must reject
   all-blocked matrices and emit only dry-run job plans backed by the dataset
   gates.
7. Validate stats: verdict-input validators must reject synthetic-only inputs,
   missing source-ledger IDs, missing empirical artifacts, and missing residual
   components.
8. Run cross-repo integration checks on clean rebased candidates only. This is
   a validation step, not a merge step.
9. Rebuild the checkpoint report and acceptance gate after the product rows are
   stable.

## Blockers

- Dataset evidence blockers: profile, aging/SOH, and residual Tier2
  cache/provenance rows are not yet proven in this matrix.
- Empirical blockers: no row here proves real Phase 9/10/11 empirical-run
  artifacts.
- Source-ledger blockers: verdict rows remain blocked until empirical artifacts
  cite source-ledger IDs.
- Base blockers: specs and filters base worktrees have unrelated local changes;
  several product bases are behind their remotes.
- Duplicate refill blockers: multiple refill worktrees exist for the same
  objective. Select one branch per objective before merge validation.

## Rollback Plan

- Prefer no-op rollback while status is `NO_GO_MERGE`: do not merge.
- If a candidate was already merged elsewhere and later fails validation, revert
  that single merge or commit in its product repo before continuing to the next
  dependency group.
- Never use this matrix to justify a scientific or public claim. It is an
  operational validation order only.
