# Phase 9/10/11 Acceptance Gate Checklist - 2026-05-08

Scope: Phase 9, Phase 10, and Phase 11 only.

This checklist separates tooling readiness from empirical readiness and
scientific closure. It is a gate, not evidence by itself. A schema, contract,
dry-run, linter, or checklist can support tooling acceptance, but it cannot make
any Phase 9/10/11 scientific result acceptable without the required empirical
artifacts and source-ledger support.

## Evidence Fields Required In Every Acceptance Row

Every row used for acceptance must cite:

- branch;
- commit;
- validation command;
- artifact path or output path;
- blocker status.

If any field is missing, the row is `NO_GO_MERGE` for tooling and
`NO_GO_CLAIM` for scientific closure.

## Phase Gate Table

| Phase | Tooling acceptance | Empirical acceptance | Scientific closure acceptance | Current blocker status |
| --- | --- | --- | --- | --- |
| Phase 9 - profile-axis comparability | `NO_GO_MERGE` until runner inventory, dispatch budget, and stats comparability branches cite branch, commit, validation command, artifact, and clean diff-check evidence. | `NO_GO_EMPIRICAL` until at least one profile empirical-run artifact exists with cache, provenance, Tier2, split/protocol, and source identity evidence. | `NO_GO_CLAIM` until empirical-run artifacts pass stats comparability with source-ledger IDs and reproducible validation logs. | Missing consolidated branch/commit/artifact table in this checkpoint worktree. |
| Phase 10 - aging/SOH generalization | `NO_GO_MERGE` until datasets readiness, runner budget, and stats aging-contract branches cite branch, commit, validation command, artifact, and clean diff-check evidence. | `NO_GO_EMPIRICAL` until aging/SOH empirical-run artifacts exist with cache, provenance, Tier2, ground-truth/SOH, split identity, and unit evidence. | `NO_GO_CLAIM` until empirical-run artifacts pass aging verdict-input validation with source-ledger IDs and reproducible validation logs. | Missing consolidated branch/commit/artifact table in this checkpoint worktree. |
| Phase 11 - residual decomposition | `NO_GO_MERGE` until runner residual input, runner dry-run manifest, and stats decomposition-contract branches cite branch, commit, validation command, artifact, and clean diff-check evidence. | `NO_GO_EMPIRICAL` until residual empirical-run artifacts exist with voltage/current/timebase unit, cadence, cache, provenance, Tier2, and component evidence. | `NO_GO_CLAIM` until residual trace artifacts pass decomposition verdict-input validation with source-ledger IDs and reproducible validation logs. | Missing consolidated branch/commit/artifact table in this checkpoint worktree. |

## Acceptance Policy

Tooling merge:

- Accept only rows with branch, commit, focused test command, formatter or style
  command when available, `git diff --check`, artifact path, and clean worktree
  status.
- Keep tooling rows separate from empirical and scientific closure rows.
- Treat synthetic fixtures as tooling validation only.

Empirical scheduling:

- Accept only if the scheduler emits at least one runnable candidate and does
  not hide all-blocked matrices behind a success status.
- Require explicit cache, provenance, Tier2, split/protocol, source identity,
  and phase-specific unit or ground-truth fields before running.
- If readiness is unknown or inferred from filenames, mark the row
  `NO_GO_EMPIRICAL`.

Scientific closure:

- Accept only after empirical-run artifacts exist, stats validators consume the
  artifacts, source-ledger IDs are present, and replay or validation logs are
  recorded.
- If cache, provenance, Tier2, source-ledger, or empirical-run evidence is
  absent, the decision is `NO_GO_CLAIM`.
- Do not promote branch readiness, dry-run output, synthetic fixtures, or raw
  mirrored data into a scientific result.

Public communication:

- Keep public communication at `NO_GO_PUBLIC` while any Phase 9/10/11 row is
  `NO_GO_CLAIM`.
- Allowed wording is limited to tooling status, blocker status, and validation
  commands already recorded in the acceptance table.

## Current Checkpoint Decisions

| Decision | Status | Reason |
| --- | --- | --- |
| Tooling merge | `NO_GO_MERGE` for the combined checkpoint | This worktree has the acceptance gate and guardrail only; it does not contain the required product-branch evidence table. |
| Empirical scheduling | `NO_GO_EMPIRICAL` | No empirical-run artifact list is committed in this worktree. |
| Scientific closure | `NO_GO_CLAIM` | The required cache/provenance/Tier2/source-ledger/empirical-run evidence bundle is not present here. |
| Public communication | `NO_GO_PUBLIC` | Scientific closure remains `NO_GO_CLAIM`. |

## Validation Checklist For Future Gate Updates

- Run `scripts/check-phase9-11-acceptance-gate.sh --dry-run <report>`.
- Run `scripts/probe-phase9-11-acceptance-gate.sh`.
- Run `scripts/check-research-diff-scope.sh --dry-run --staged` before commit.
- Run `git diff --check`.
