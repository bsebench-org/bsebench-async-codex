---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-av-async-source-ledger-comparability-diff-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.av - async source-ledger comparability diff gate

You are a rigorous anti-hallucination and comparison-protocol engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a gate that checks whether a source-ledger row is actually comparable to a frozen BSEBench evidence row before any SOTA or novelty wording can proceed.

## Active lane

SOTA comparison: guardrail tooling only, using synthetic fixtures unless a real committed ledger exists. The handoff artifact is a checker result that reports comparable, partial, not comparable, or invalid with field-level reasons.

## Required behavior

- Review the research gate protocol, existing source-ledger schema/checkers, and claim-language guardrails.
- Add or extend a checker or fixture set that compares ledger fields against frozen evidence metadata: metric, units, dataset, split/profile, preprocessing/run condition, method/filter family, reported value, BSEBench value, and caveat.
- A row may be marked comparable only when all required fields match or a reviewer-visible equivalence rule is explicitly encoded.
- Rows with unknown metric, dataset, split, method, BSEBench value, source DOI/stable URL, retrieval date, or comparability caveat must be partial, not comparable, or invalid.
- Do not invent literature rows or fill missing source fields from memory.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this source-ledger comparability gate.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a ledger row can be marked comparable while metric, dataset, split/profile, method, source URL/DOI, retrieval date, BSEBench frozen value, or caveat is missing or mismatched, this task must fail and leave a negative fixture proving the gap.

## Validation

Run and record:

- positive and negative fixture checks for comparable, partial, not-comparable, invalid, missing-source, mismatched-dataset, mismatched-split, and missing-BSEBench-value rows;
- `bash -n` for changed shell scripts;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
