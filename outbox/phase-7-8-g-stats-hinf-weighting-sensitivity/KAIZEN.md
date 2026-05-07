# Kaizen retro for phase-7-8-g-stats-hinf-weighting-sensitivity

[role: kaizen-FR]
Decision audited : needs_fix
Generated at : 2026-05-07T06:59:43Z

## KEEP
- Worker surfaced the actual material sensitivity risk in the real Hinf run while keeping the output mechanical and claim-free.

## FIX
- Worker validation reported ruff passed, but chef-side gates found `src/bsebench_stats/runners/hinf_sensitivity.py` still needed formatting.

## SHIP-ONE
- `inbox/phase-7-8-g-stats-hinf-weighting-sensitivity/BRIEF.md`: add one validation bullet, `uv run ruff format --check .`, beside `uv run ruff check .` so worker-reported gates match chef formatting enforcement.
