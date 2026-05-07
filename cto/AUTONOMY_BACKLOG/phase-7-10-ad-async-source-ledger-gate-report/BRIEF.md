---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-ad-async-source-ledger-gate-report
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.ad - async source-ledger gate report

You are a rigorous anti-hallucination and comparison-gate engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add an async-side source-ledger gate report that blocks SOTA or novelty wording unless every comparison row has the required source, metric, dataset, split, BSEBench frozen value, and comparability caveat fields.

## Active lane

SOTA comparison gate tooling only. The handoff artifact is a completeness/comparability report over source-ledger rows; it must use synthetic fixtures or already committed ledgers and must not create new empirical evidence.

## Required behavior

- Read `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` and existing async source-ledger schema, fixtures, or brief checks when present.
- Add or extend a lightweight checker or fixture report that classifies rows as `comparable`, `partial`, or `not_comparable` based only on explicit fields.
- Required fields must include stable URL or DOI, retrieval date, metric, dataset, split, method, reported value, BSEBench frozen value, and comparability caveat.
- Use synthetic fixture rows unless a committed source ledger already includes stable URLs or DOIs and retrieval dates; do not invent real literature numbers from memory.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to source-ledger gate validation.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a row with missing source identity, retrieval date, metric, dataset, split, BSEBench frozen value, or comparability caveat can pass as comparable, the gate must fail and mark the comparison incomplete.

## Validation

Run and record:

- positive and negative fixture checks for comparable, partial, not-comparable, missing-source, missing-split, and missing-caveat rows;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `bash -n scripts/check-research-brief-gates.sh scripts/cto-autonomy-pacer.sh`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
