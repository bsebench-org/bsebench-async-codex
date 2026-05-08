# CTO superseded duplicate remediation

- Phase : phase-7-10-y-block-remediation-20260508T082012Z
- Recorded at : 2026-05-08T13:02:15+02:00
- Decision : clear the recursive block and do not merge the stale remediation
  branch.
- Root cause : the remediation branch documented an already-resolved async
  orchestration block, then became stale/non-linear. The panel/advisor safety
  path treated that stale duplicate as a fresh BLOCK, pausing the chef again.
- Durable correction : `scripts/chef-daemon.sh` now recognizes this narrow
  class of superseded duplicate remediations before the block gate and before
  `advisor=BLOCK` can recreate the same pause.
- Specific merge risk : the stale target branch has an add/add conflict on
  `outbox/phase-7-10-ah-stats-hinf-null-control-audit/CTO_UNBLOCK.md`.
  Current `origin/main` already contains the equivalent AH unblock/remediation
  record and no longer contains the original AH block file.

## Guardrail

Do not merge `origin/phase-7-10-y-block-remediation-20260508T082012Z`.
If future tooling needs this state, use the already-merged AH unblock evidence
on `origin/main` instead.

This record does not approve a scientific claim, does not modify the research
roadmap, and does not merge the stale target branch.
