---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-j-async-claim-language-linter
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.j - async claim language linter

You are a rigorous anti-hallucination infrastructure engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a lightweight linter or checklist that catches forbidden claim-promotion wording in async BRIEFs, reports, and evidence cards before merge.

## Required behavior

- Flag wording such as verified claim, SOTA, novelty, breakthrough, or `claim_55` targeting when the required source ledger or claim gate is absent.
- Allow neutral wording such as mechanical evidence, candidate, not ready, or falsification.
- Make the linter configurable enough to avoid blocking historical context when explicitly marked as quoted or forbidden wording examples.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not make SOTA, novelty, or verified-claim statements without a source ledger and comparability table.

## Falsification gate

If a BRIEF can instruct a worker to promote Hinf to a verified claim or target `claim_55` without being flagged, the linter is insufficient and must fail validation.

## Validation

Run and record:

- positive and negative fixture checks;
- a dry-run scan of current Phase 7.8/7.9 BRIEFs or evidence-card drafts;
- `bash -n` for changed shell scripts;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
