# Kaizen retro for phase-7-10-aj-async-research-gate-diff-scope-guard

[role: kaizen-FR]
Decision audited : escalated
Generated at : 2026-05-08T13:09:04Z

## KEEP
- Fixture-backed guard evidence was strong: allowed, protected-path, `claim_55`, unsupported comparison, and ledger-present cases were all recorded in SUMMARY.

## FIX
- Worker reported merge readiness ok, but chef still escalated on failed fast-forward merge; readiness did not predict chef mergeability.

## SHIP-ONE
- `scripts/chef-daemon.sh`: add a <=30 LOC pre-merge check using `git merge-base --is-ancestor origin/main HEAD`; if false, mark `needs_fix: non_linear_merge` before ff-merge attempt so workers get a direct rebase/remediation cue.
