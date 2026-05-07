# Kaizen retro for phase-7-8-d-async-research-gate-protocol

[role: kaizen-FR]
Decision audited : escalated
Generated at : 2026-05-07T06:47:44Z

## KEEP
- Worker scope discipline worked: it added only the protocol doc and checker, recorded validation, and avoided HISTORY/roadmap edits.

## FIX
- Chef escalated before semantic review because ff-merge failed on a non-linear branch.

## SHIP-ONE
- `scripts/worker-daemon.sh`: after worker commit and before push, add a `git merge-base --is-ancestor origin/main HEAD` check; if false, record `NON_FF_REBASE_NEEDED` in SUMMARY and stop before push, so chef receives a fixable worker artifact instead of a merge-only escalation.
