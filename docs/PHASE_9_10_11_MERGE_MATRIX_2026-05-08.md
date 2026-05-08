# Phase 9/10/11 Merge Matrix - 2026-05-08

Snapshot source: `/home/oakir/.local/state/bsebench-async-watchdog/phase9-11-checkpoint-status.md` at `2026-05-08T22:02:06+0200`, plus local worktree status checks from this branch.

Scope: Phase 9, Phase 10, and Phase 11 only. This is a validation-order artifact, not a merge action. Do not merge from this matrix alone.

## Current Decision

- Tooling merge: `NO_GO_MERGE` for the combined checkpoint until every selected row has a clean worktree, a pushed GLASSBOX commit, recorded validation commands, and a clean diff check.
- Empirical scheduling: `NO_GO_EMPIRICAL` until runner schedulers emit runnable candidates backed by cache, provenance, Tier2, source identity, split or unit evidence, and blocker status.
- Scientific claim gate: `NO_GO_CLAIM` until empirical-run artifacts exist and stats validators consume them with source-ledger IDs and reproducible validation logs.
- Public communication: `NO_GO_PUBLIC` while any Phase 9/10/11 claim row remains `NO_GO_CLAIM`.

Missing cache, provenance, Tier2, source-ledger, empirical-run, unit, cadence, split, or ground-truth evidence is a blocker. Synthetic fixtures and dry-run outputs count as tooling evidence only.

## Validation Order

1. Freeze the integration base and collect branch, commit, worktree status, changed files, validation command, artifact, and blocker fields for each candidate.
2. Validate async guardrails first: acceptance gate, anti-claim audit, checkpoint report, merge matrix, and stats wording linter. These gates must block unsupported promotion from tooling to empirical or scientific status.
3. Validate specs and filters contracts next, because runner and stats rows depend on stable schema and filter-output contracts.
4. Validate dataset evidence rows next: Phase 9 profile cache, Phase 10 aging cache, Phase 11 residual cache, and local path discovery. Any missing local evidence keeps downstream rows blocked.
5. Validate runner schedulers only after dataset rows are ready. Scheduler success is not enough if every candidate is blocked.
6. Validate stats verdict-input rows only after the runner and dataset rows expose artifact identity, source identity, units, cadence, and blocker status.
7. Run empirical jobs only after the preceding rows produce at least one runnable candidate with evidence. Record empirical-run artifacts before any scientific decision.
8. Re-run the checkpoint report and matrix checks after all candidate rows are clean and pushed. Merge order must follow this sequence; this branch performs no merge.

## Candidate Branch Matrix

| Order | Repo | Branch or workdir | Observed state | Merge decision | Required validation before merge |
| --- | --- | --- | --- | --- | --- |
| 0 | async | `phase9-11-refill-p9-11-acceptance-gate-20260508T215244+0200` | Clean at `e89d452`; prior gate artifact exists. | HOLD | Re-run acceptance gate check, probe, diff-scope guard, and `git diff --check` on the selected head. |
| 1 | async | `phase9-11-refill-p9-11-anti-claim-audit-20260508T220147+0200` | Dirty worktree with 2 changed paths at snapshot. | `NO_GO_MERGE` | Commit or discard worker-owned changes, then validate wording gate and protected-file scope. |
| 2 | async | `phase9-11-refill-p9-11-checkpoint-report-20260508T220012+0200` | Clean at `470df9c`; no new checkpoint evidence committed in that worktree yet. | HOLD | Re-run after product rows finish; require branch, commit, validation command, artifact, and blocker table. |
| 3 | async | `phase9-11-refill-p9-11-merge-matrix-20260508T220131+0200` | This branch; matrix artifact being added. | HOLD | Run `bash scripts/check-phase9-11-merge-matrix.sh --dry-run docs/PHASE_9_10_11_MERGE_MATRIX_2026-05-08.md`, probe, diff-scope guard, and `git diff --check`. |
| 4 | specs | `phase9-11-refill-p9-11-schema-export-audit-20260508T215904+0200` | Dirty worktree with 6 changed paths; latest subject does not start with GLASSBOX. | `NO_GO_MERGE` | Require GLASSBOX commit subject, clean worktree, schema export tests, format check when available, and diff check. |
| 5 | filters | `phase9-11-refill-p9-11-contract-export-audit-20260508T220007+0200` | Clean at `1117d17`. | HOLD | Re-run focused contract/export tests, format check when available, diff check, and verify no hidden empirical or scientific claim. |
| 6 | datasets | `phase9-11-refill-p9-tier2-profile-cache-20260508T215254+0200` | Dirty worktree with 3 changed paths. | `NO_GO_MERGE` | Validate Phase 9 profile cache/provenance/Tier2 evidence and commit worker-owned changes with focused tests. |
| 7 | datasets | `phase9-11-refill-p10-tier2-aging-cache-20260508T215302+0200` | Dirty worktree with 2 changed paths. | `NO_GO_MERGE` | Validate Phase 10 aging/SOH cache, provenance, Tier2, ground-truth, and split evidence with focused tests. |
| 8 | datasets | `phase9-11-refill-p11-tier2-residual-cache-20260508T215408+0200` | Dirty worktree with 2 changed paths. | `NO_GO_MERGE` | Validate Phase 11 residual cache, unit, cadence, provenance, Tier2, and source identity evidence with focused tests. |
| 9 | datasets | `phase9-11-refill-p9-11-local-path-discovery-20260508T215013+0200` | Dirty worktree with 7 changed paths. | `NO_GO_MERGE` | Ensure local path discovery reports sanitized paths and explicit blocker status; no uploads or downloads. |
| 10 | runner | `phase9-11-refill-p9-profile-empirical-scheduler-20260508T215517+0200` | Dirty worktree with 2 changed paths. | `NO_GO_MERGE` | Validate all-blocked matrices fail closed and runnable Phase 9 candidates require cache/provenance/Tier2 evidence. |
| 11 | runner | `phase9-11-refill-p10-aging-empirical-scheduler-20260508T215522+0200` | Dirty worktree with 3 changed paths. | `NO_GO_MERGE` | Validate runnable Phase 10 candidates require aging/SOH evidence, split identity, and local cache readiness. |
| 12 | runner | `phase9-11-refill-p11-residual-trace-scheduler-20260508T215527+0200` | Dirty worktree with 3 changed paths. | `NO_GO_MERGE` | Validate residual trace scheduling requires units, cadence, component fields, sample counts, cache, provenance, and stats dependency identity. |
| 13 | runner | `phase9-11-refill-p9-11-dryrun-cli-smoke-20260508T215025+0200` | Prior refill branch observed in logs, not active in the checkpoint snapshot. | HOLD | Re-read branch status before use; validate dry-run CLI only after dataset and contract rows are clean. |
| 14 | stats | `phase9-11-refill-p9-11-no-claims-linter-20260508T215035+0200` | Dirty worktree with 5 changed paths. | `NO_GO_MERGE` | Validate wording linter rejects unsupported promotion while allowing evidence-backed status rows. |
| 15 | stats | `phase9-11-refill-p9-profile-verdict-inputs-20260508T215536+0200` | Dirty worktree with 2 changed paths. | `NO_GO_MERGE` | Validate Phase 9 verdict inputs reject missing empirical-run artifact, source-ledger, cache, provenance, and comparability evidence. |
| 16 | stats | `phase9-11-refill-p10-aging-verdict-inputs-20260508T215745+0200` | Dirty worktree with 2 changed paths. | `NO_GO_MERGE` | Validate Phase 10 verdict inputs reject missing aging/SOH, split, ground-truth, source-ledger, cache, and provenance evidence. |
| 17 | stats | `phase9-11-refill-p11-residual-verdict-inputs-20260508T215755+0200` | Dirty worktree with 2 changed paths. | `NO_GO_MERGE` | Validate Phase 11 verdict inputs reject missing residual component, unit, cadence, source-ledger, cache, provenance, and empirical-run evidence. |
| 18 | stats | `phase9-11-refill-p11-residual-verdict-inputs-20260508T214201+0200` | Clean at `5178d05`; older duplicate active workdir. | HOLD | Resolve duplicate selection against the newer Phase 11 stats branch before any merge queue entry. |

## Merge Ordering Rule

Only clean, pushed, validated rows can enter the actual merge queue. If two rows touch the same repo, validate the lowest order first unless the later row explicitly supersedes it and carries the full evidence table. Dirty worktrees, non-GLASSBOX subjects, missing validation logs, or missing evidence keep the row out of merge order.

## Minimum Validation Commands

Run these before committing updates to this matrix:

- `bash scripts/check-phase9-11-merge-matrix.sh --dry-run docs/PHASE_9_10_11_MERGE_MATRIX_2026-05-08.md`
- `bash scripts/probe-phase9-11-merge-matrix.sh`
- `bash scripts/check-research-diff-scope.sh --dry-run --staged`
- `git diff --check`

Run these for each product candidate before it can be marked mergeable:

- `git status --short`
- `git log -1 --pretty=%s`
- focused tests for changed files
- `ruff check` and `ruff format --check` when available in that repo
- `git diff --check`
- push verification for the exact branch and commit
