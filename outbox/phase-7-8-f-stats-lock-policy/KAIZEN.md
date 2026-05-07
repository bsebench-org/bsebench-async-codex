# Kaizen retro for phase-7-8-f-stats-lock-policy

[role: kaizen-FR]
Decision audited : approved
Generated at : 2026-05-07T06:56:29Z

## KEEP
- Lock policy became explicit in README and CI, with chef re-running locked gates before approval.

## FIX
- none — clean run.

## SHIP-ONE
- `scripts/chef-daemon.sh`: when `uv.lock` changes, include a short gate-command list in `CHEF_VERDICT.md` so lock-policy approvals show `uv lock --check` without requiring log-tail archaeology.
