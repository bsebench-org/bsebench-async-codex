# Kaizen retro for phase-6-11-b-chi2-multi-cfg-sweep-fix-2

[role: kaizen-FR]
Decision audited : approved
Generated at : 2026-05-07T01:06:46Z

## KEEP
- Evidence hygiene worked: worker chose the tooling-only path, deleted the 0-ok JSON, added `--require-ok-cells`, and chef re-ran gates before approval.

## FIX
- none — clean run.

## SHIP-ONE
- `scripts/chef-daemon.sh`: add a ≤30 LOC generic gate that fails any committed `outputs/chi2_sweep_5x5.json` with `.summary.ok == 0`, so this evidence rule is enforced even when a future BRIEF forgets G5.
