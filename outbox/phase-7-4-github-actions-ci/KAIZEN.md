# Kaizen retro for phase-7-4-github-actions-ci

[role: kaizen-FR]
Decision audited : escalated
Generated at : 2026-05-06T22:57:29Z

## KEEP
- Preserve CTO/chef revalidation that records branch SHA, push race, and the dependency reason before escalation.

## FIX
- BRIEF asked `uv sync --extra dev`, but non-slow pytest collection imports `adapters-mat` deps (`scipy`, `h5py`), so the worker followed an under-specified CI command.

## SHIP-ONE
- `inbox/phase-7-4-github-actions-ci-fix-1/BRIEF.md`: add one acceptance bullet requiring CI to use `uv sync --all-extras`, because marker filtering happens after collection imports.
