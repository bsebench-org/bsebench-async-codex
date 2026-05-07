# Kaizen retro for phase-7-10-n-async-brief-reserve-integrity-gate

[role: kaizen-FR]
Decision audited : escalated
Generated at : 2026-05-07T18:40:37Z

## KEEP
- Reserve-check evidence was concrete: queueable count, malformed and branch-claimed probes, gate pass/fail, and diff checks were all reported.

## FIX
- Chef escalation was merge-shape only: ff-merge failed as non-linear despite green worker validation.

## SHIP-ONE
- `scripts/remote-worker.sh`: before push, rebase the phase branch onto `origin/main` or write a one-line SUMMARY failure; this prevents green work from arriving non-FF at chef.
