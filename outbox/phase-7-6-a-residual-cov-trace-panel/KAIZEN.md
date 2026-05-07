# Kaizen retro for phase-7-6-a-residual-cov-trace-panel

[role: kaizen-FR]
Decision audited : approved
Generated at : 2026-05-07T01:49:36Z

## KEEP
- Fail-loud-before-write behavior plus `allow_nan=False` coverage preserved evidence hygiene cleanly.

## FIX
- none — clean run.

## SHIP-ONE
- `scripts/chef-daemon.sh`: add one verdict checklist bullet that prints the changed-file list used for G5/G6 scope checks, so `uv.lock`/claim-prose exclusions are auditable from CHEF_VERDICT alone.
