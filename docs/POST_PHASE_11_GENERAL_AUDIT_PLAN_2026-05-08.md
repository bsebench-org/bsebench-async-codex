# Post Phase 11 General Audit Plan - BSEBench SOC/SOH Universal Benchmark

Timestamp: 2026-05-08
Scope lock: Phase 9, Phase 10, Phase 11 only until the checkpoint is closed.

## Purpose

This audit starts when the Phase 11 closure workers finish their current
validation pass. Its purpose is to stop, verify, and decide whether the project
is still aligned with the target: a universal open benchmark for SOC/SOH battery
state estimation across filters, ECMs, observers, and AI estimators.

The audit must distinguish:

- tooling readiness;
- empirical execution readiness;
- scientific claim readiness;
- public benchmark readiness.

No phase may be marked scientifically complete only because schemas, contracts,
or dry-run tools exist.

## Hard Rules

- No Hugging Face uploads during this checkpoint.
- No thesis, roadmap, claim-registry, or `claim_55` edits.
- No SOTA, leaderboard, winner, novelty, or phase-complete claims unless backed
  by source-ledger evidence and validated empirical artifacts.
- Every positive claim must cite a branch, commit, validation command, artifact,
  and blocker status.
- Missing cache, provenance, Tier2, unit, cadence, split, or ground-truth
  evidence is a blocking condition, not a narrative inconvenience.

## Inputs To Collect

- Product repo heads for:
  - `bsebench-runner`
  - `bsebench-stats`
  - `bsebench-datasets`
  - `bsebench-specs`
  - `bsebench-filters`
  - `bsebench-async-codex`
- Phase 9/10/11 final verdict branches and logs.
- Final gap-audit branches and logs.
- Tier2/cache/provenance remediation branches and logs.
- Runner empirical scheduler branches and logs.
- Stats verdict-input validator branches and logs.
- Current refill status report:
  `/home/oakir/.local/state/bsebench-async-watchdog/phase9-11-checkpoint-status.md`
- All `PHASE_9_10_11_*` reports in integration worktrees.
- Current chef blocks, outbox verdicts, and unresolved `needs_fix` items.

## Audit Axes

### 1. Universal Benchmark Alignment

Check whether the implementation still serves the universal benchmark goal:

- plug-and-play estimator interface;
- dataset-agnostic evaluation pipeline;
- SOC and SOH support;
- cross-chemistry and cross-profile readiness;
- strict calibration vs blind-evaluation separation;
- explicit provenance and source identity;
- reproducible public artifacts.

Any feature that only helps one local dataset or one estimator family must be
flagged for redesign or containment.

### 2. Phase 9 - Cross-Profile Comparability

Required evidence:

- profile-axis schemas/contracts exported and validated;
- runner dry-run scheduler rejects all-blocked matrices;
- at least one empirical profile-run artifact exists or a precise blocker list
  explains why none can run;
- stats validator accepts only real empirical artifacts with source-ledger IDs;
- no profile-axis scientific verdict if all candidates remain cache-blocked.

Decision labels:

- `GO_TOOLING`: schemas/contracts/schedulers validated.
- `GO_EMPIRICAL`: runnable profile jobs exist and pass validation.
- `GO_CLAIM`: empirical results and source-ledger-backed verdict exist.
- `NO_GO`: missing Tier2/cache/provenance or empirical artifacts.

### 3. Phase 10 - Aging/SOH Generalization

Required evidence:

- aging/SOH metadata readiness validated;
- calibration/evaluation split leakage guard active;
- ground-truth/SOH evidence explicit, not inferred from filenames;
- runner aging empirical scheduler emits runnable jobs only when evidence is
  ready;
- stats aging verdict-input validator rejects missing aging bins, SOH evidence,
  split identity, or provenance.

Decision labels are the same as Phase 9.

### 4. Phase 11 - Residual Decomposition

Required evidence:

- residual decomposition schemas/contracts exported and validated;
- voltage/current/timebase/unit/cadence evidence explicit;
- residual trace scheduler refuses missing units or cadence;
- residual verdict-input validator requires sensor-noise and model-mismatch
  component evidence;
- empirical residual trace artifacts exist before any scientific verdict.

Decision labels are the same as Phase 9.

## Validation Matrix

For every repo, record:

| Repo | Branch | Commit | Tests | Diff Check | Push | Merge Ready | Scientific Claim Ready |
| --- | --- | --- | --- | --- | --- | --- | --- |
| runner | TBD | TBD | TBD | TBD | TBD | TBD | TBD |
| stats | TBD | TBD | TBD | TBD | TBD | TBD | TBD |
| datasets | TBD | TBD | TBD | TBD | TBD | TBD | TBD |
| specs | TBD | TBD | TBD | TBD | TBD | TBD | TBD |
| filters | TBD | TBD | TBD | TBD | TBD | TBD | TBD |
| async | TBD | TBD | TBD | TBD | TBD | TBD | TBD |

Minimum validation:

- `git diff --check`
- focused pytest for changed files
- ruff check/format check when available
- non-slow test suite before merging shared product behavior
- no dirty worktree except explicitly documented user/worker artifacts

## Checkpoint Deliverables

Create one durable checkpoint report:

`docs/PHASE_9_10_11_GENERAL_AUDIT_CHECKPOINT_<timestamp>.md`

It must contain:

- executive status for Phase 9/10/11;
- percent complete, with separate tooling/empirical/claim percentages;
- branch/commit table;
- validation table;
- blocker table ranked by scientific impact;
- merge order;
- rollback/revert plan for risky branches;
- next 12 executable tasks, all Phase 9/10/11 only;
- explicit GO/NO-GO decision for:
  - tooling merge;
  - empirical scheduling;
  - scientific closure;
  - public communication.

## Decision Policy

Use these conservative defaults:

- If schemas/contracts are validated but empirical artifacts are missing:
  `GO_TOOLING`, `NO_GO_CLAIM`.
- If empirical scheduler emits zero runnable jobs:
  `NO_GO_EMPIRICAL`.
- If dataset cache/provenance readiness is zero:
  `NO_GO_CLAIM`.
- If validators find only synthetic fixtures:
  `NO_GO_CLAIM`.
- If any branch lacks tests or diff-check:
  `NO_GO_MERGE`.

## Immediate Post-Audit Actions

If NO-GO remains:

1. Keep refill locked to Phase 9/10/11.
2. Generate remediation tasks only for the top blockers.
3. Avoid starting Phase 12/13 work until the checkpoint report says Phase
   9/10/11 are either closed or intentionally deferred with evidence.
4. Update the user-facing status with:
   - active agent count;
   - progress delta;
   - blocker delta;
   - ETA to next GO decision.

If GO is reached:

1. Merge product tooling branches in dependency order.
2. Run non-slow suites across affected repos.
3. Create final Phase 9/10/11 closure report.
4. Only then unlock Phase 12/13 planning.
