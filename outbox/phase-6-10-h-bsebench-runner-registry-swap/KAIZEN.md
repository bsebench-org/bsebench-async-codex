# Kaizen retro for phase-6-10-h-bsebench-runner-registry-swap

[role: kaizen-FR]
Decision audited : escalated
Generated at : 2026-05-06T22:46:25Z

## KEEP
- CTO stale-running reconciliation preserved concrete evidence and requeued `fix-1` cleanly.

## FIX
- Worker left the phase `running` past cap with no SUMMARY, stdout tail, branch, or deliverable.

## SHIP-ONE
- `scripts/worker-daemon.sh`: add one stale-running sweep before picking work; if `STATUS.json` is `running` older than `hard_wallclock_min` and no matching `codex exec` PID exists, emit SUMMARY/run.log.tail and set status=error so CTO cleanup is not manual.
