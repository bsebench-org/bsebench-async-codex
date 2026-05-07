---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-8-d-async-research-gate-protocol
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
hard_wallclock_min: 60
---

# Phase 7.8.d — anti-hallucination and SOTA comparison research gate

You are a rigorous research-methodology engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits. Keep the write scope narrow.

## Goal

Add a concrete research gate protocol for BSEBench autonomous tasks so future claim work cannot silently turn into hallucinated claims or unfair SOTA comparisons.

## Required behavior

- Create a new document such as `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`.
- Include gates for:
  - evidence provenance
  - independent replay
  - falsification condition
  - SOTA comparison source ledger
  - no-claim-until-validated rule
  - hourly direction checkpoint
- Add a lightweight checker script if practical, for example verifying that new Phase 7/8/11 BRIEFs mention falsification, validation, no thesis registry edits, and no unsupported SOTA claims.
- Do not edit `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not edit `HISTORY.md`; CTO owns history entries separately.

## Falsification gate

The protocol must explicitly distinguish evidence generation, SOTA comparison, and claim registration. If it cannot prevent those from being conflated, the task is incomplete.

## Validation

Run and record:

- `bash -n` for any new shell script
- a dry run of any new checker against at least one current BRIEF
- repository formatting/lint checks that are locally available

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
