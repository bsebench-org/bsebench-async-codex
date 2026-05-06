# Kaizen retro for phase-6-10-f-calce-inr-20r-adapter

[role: kaizen-FR]
Decision audited : approved
Generated at : 2026-05-06T21:58:31Z

## KEEP
- Worker SUMMARY preserved the useful audit bundle : branch SHA, push result, exact pytest/ruff gates, slow real-data test, clean scope.

## FIX
- Chef approved via "SHA already in origin/main" fast path, but CHEF_VERDICT did not restate the gate evidence.

## SHIP-ONE
- `scripts/chef-daemon.sh` : in the already-in-main verdict path, copy the SUMMARY verification block into CHEF_VERDICT before approving; keeps fast-path approvals audit-complete without rerunning gates.
