# Kaizen retro for phase-7-1-bsebench-readme-examples

[role: kaizen-FR]
Decision audited : approved
Generated at : 2026-05-06T22:09:08Z

## KEEP
- Worker SUMMARY preserved strong gate evidence: exact SHA, push result, file scope, ruff, pytest, clean status, and no Claude trailer.

## FIX
- Example smoke-runs hit Hugging Face `401 Unauthorized`; accepted, but public-release examples depend on mirror visibility or token access.

## SHIP-ONE
- `inbox/*/BRIEF.md`: add one checklist bullet requiring workers to record whether example scripts need public dataset access or authenticated mirrors, so chef can classify smoke-run 401s consistently.
