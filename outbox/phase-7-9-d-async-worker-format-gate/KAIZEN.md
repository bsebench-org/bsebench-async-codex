# Kaizen retro for phase-7-9-d-async-worker-format-gate

[role: kaizen-FR]
Decision audited : escalated
Generated at : 2026-05-07T09:05:43Z

## KEEP
- Worker SUMMARY preserved useful BRIEF gate audit evidence: static checker exit, `ruff check`, and `ruff format --check` parity.

## FIX
- Chef escalation only said `ff-merge ... failed (non-linear ?)`; it did not record base/head/divergence evidence needed for fast diagnosis.

## SHIP-ONE
- `scripts/chef-daemon.sh`: in the non-linear ff-merge escalation path, append branch SHA, `origin/main` SHA, merge-base SHA, and first 20 lines of `git log --oneline --left-right origin/main...$branch` to `CHEF_VERDICT.md` so the next block is self-diagnosing.
