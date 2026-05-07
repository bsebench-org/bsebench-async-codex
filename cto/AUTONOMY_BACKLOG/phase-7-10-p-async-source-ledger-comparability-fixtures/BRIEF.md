---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-p-async-source-ledger-comparability-fixtures
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.p - async source-ledger comparability fixtures

You are a rigorous anti-hallucination and comparison-protocol engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add source-ledger fixture cases that make future SOTA or novelty comparison checks falsifiable before any claim-registration task is allowed.

## Required behavior

- Review the research gate protocol and any existing source-ledger schema, linter, or checklist in async.
- Add fixtures, examples, or a lightweight checker that distinguishes comparable, partial, and not-comparable source rows.
- Required fixture fields must include stable URL or DOI, retrieval date, metric, dataset, split, method, reported value, BSEBench frozen value, and comparability caveat.
- Do not invent real literature numbers; use clearly synthetic fixture rows or empty templates unless a source ledger with stable URL or DOI and retrieval date is already present.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to source-ledger fixture validation.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a SOTA or novelty comparison can pass with a missing DOI/stable URL, retrieval date, metric, dataset, split, BSEBench frozen value, or comparability caveat, the fixture/checker must fail and mark the comparison incomplete.

## Validation

Run and record:

- positive and negative fixture checks for comparable, partial, not-comparable, and missing-required-field rows;
- `bash -n` for changed shell scripts;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
