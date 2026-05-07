# Phase 7.10.f - autonomy pacer self-audit

## Summary

- Tightened `scripts/cto-autonomy-pacer.sh` so reserve candidates must be Phase 7/8/11 backlog items before gate evaluation.
- Moved generated reserve-replenishment BRIEF gate checking ahead of queue mutation, including dry-run mode.
- Added `scripts/probe-autonomy-pacer-safety.sh`, an isolated dry-run probe that builds clean temporary async repos and checks waiting-task reserve behavior, block pauses, and bad-BRIEF rejection.
- Documented the probe in `docs/CTO-AUTONOMY-PACER-2026-05-07.md`.

No roadmap, thesis, claim registry, `claims/registry.yaml`, or `claim_55` files were edited.

## Validation

`bash -n scripts/cto-autonomy-pacer.sh scripts/cto-watchdog-10min.sh scripts/check-research-brief-gates.sh`

- Passed.

`bash scripts/probe-autonomy-pacer-safety.sh`

- Clean-repo dry-run reserve case:
  `SNAPSHOT codex_exec=0 status_running=2 fresh_running=2 effective_running=2 queued=0 reserve=3 blocks=0 needed=1`
- Waiting-task proof:
  `QUEUE reserve task: phase-7-probe-good-a`
- Block-present negative probe:
  `PAUSE blocks present; not restarting daemons or hiding red validation with new work`
- Bad-BRIEF negative probe:
  `SKIP research gate failed: phase-7-probe-bad-a`
- Good fallback after bad BRIEF:
  `QUEUE reserve task: phase-7-probe-good-b`
- Final result:
  `PASS: autonomy pacer dry-run safety probes passed.`

`bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`

- Passed: `10 checked, 0 skipped`.

`git diff --check`

- Passed.
