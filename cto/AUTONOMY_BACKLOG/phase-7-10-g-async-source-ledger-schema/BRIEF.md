---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-g-async-source-ledger-schema
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.g - async source ledger schema

You are a rigorous anti-hallucination and comparison-protocol engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a source-ledger schema and example placeholder that blocks future SOTA or novelty wording unless sources and comparability fields are present.

## Required behavior

- Extend async documentation or templates with a machine-readable source-ledger format.
- Required fields must include stable URL or DOI, retrieval date, metric, dataset, split, method, claimed number, and comparability caveat.
- Include a checker or checklist that flags SOTA wording without ledger evidence.
- Do not fill the ledger with invented literature entries.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not make SOTA, novelty, or verified-claim statements without a completed source ledger and comparability table.

## Falsification gate

If a future task can claim SOTA without stable source metadata and comparability fields, this schema/checker must fail or the task must be marked incomplete.

## Validation

Run and record:

- checker positive and negative examples, or a documented manual probe if no checker is added;
- `bash -n` for changed shell scripts;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
