# Kaizen retro for phase-7-10-al-datasets-phase11-unit-cadence-contract

[role: kaizen-FR]
Decision audited : needs_fix
Generated at : 2026-05-08T13:27:40Z

## KEEP
- Worker SUMMARY captured branch SHA, push status, gate commands, and focused behavior evidence clearly enough for chef to isolate the failure fast.

## FIX
- Chef failed only on commit provenance: author email was `akir.oussama@gmail.com`, not required `claude@cosmocomply.com`.

## SHIP-ONE
- Add one checklist bullet to future BRIEF templates: before commit, run `git config user.email` and fail early unless it equals `claude@cosmocomply.com`; this prevents green code from being blocked by author identity.
