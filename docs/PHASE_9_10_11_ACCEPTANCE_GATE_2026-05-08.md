# Phase 9/10/11 Acceptance Gate - 2026-05-08

This gate separates tooling acceptance from scientific closure for Phase 9,
Phase 10, and Phase 11 only. It is intentionally conservative: missing local
evidence keeps the top-level decision at `NO_GO`.

Machine-readable checklist:
`docs/PHASE_9_10_11_ACCEPTANCE_GATE_2026-05-08.json`

Validator:
`scripts/check-phase9-11-acceptance-gate.sh`

## Tooling Acceptance

Tooling can be marked complete only when the relevant validators, schedulers,
schema checks, and dry-run commands exist, are referenced by local artifacts,
and fail closed on missing inputs. Tooling completion does not imply scientific
closure.

Current state:

- Phase 9: partial tooling evidence only; empirical profile outputs remain
  dependency-gated.
- Phase 10: partial tooling evidence only; aging/SOH empirical outputs remain
  dependency-gated.
- Phase 11: partial tooling evidence only; residual trace outputs remain
  dependency-gated.

## Scientific Closure

Scientific closure requires all of the following for each phase:

- local cache/provenance evidence;
- Tier2 readiness evidence;
- source-ledger evidence;
- empirical run output evidence;
- replay or stats validation evidence.

Current state: `NO_GO` for Phase 9, Phase 10, and Phase 11 because the checklist
does not record accepted local artifacts for those required evidence classes.

## Acceptance Rule

The gate may only become `GO` when every Phase 9/10/11 scientific closure gate
is `GO` and every required evidence item is `present` with a local path that
exists in the repository checkout. Any missing evidence keeps the gate at
`NO_GO`.
