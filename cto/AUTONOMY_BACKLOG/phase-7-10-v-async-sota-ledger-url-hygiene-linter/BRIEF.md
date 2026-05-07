---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-v-async-sota-ledger-url-hygiene-linter
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.v - async SOTA ledger URL hygiene linter

You are a rigorous anti-hallucination and comparison-protocol engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a source-ledger hygiene linter that makes future SOTA or novelty comparison tasks fail when source identity, retrieval date, metric, dataset, split, frozen BSEBench value, or comparability caveat is missing.

## Roadmap mapping

- Active lane: SOTA comparison validation.
- Supports Phase 7/8/11 fair-comparison gates before any claim registration.
- Produces ledger validation tooling and synthetic fixtures only; it does not change the scientific roadmap.

## Required behavior

- Review the research gate protocol and any existing source-ledger schema, examples, or fixtures in async.
- Add a linter, schema check, or shell/Python probe that accepts explicit ledger files and reports row-level failures.
- Required row fields must include stable URL or DOI, retrieval date, metric, dataset, split, method, reported value, frozen BSEBench value, comparability status, and comparability caveat.
- Include synthetic fixtures for comparable, partial, not-comparable, missing URL/DOI, missing retrieval date, missing metric, missing split, missing frozen value, and missing caveat.
- Do not invent real literature numbers; use synthetic fixtures unless a vetted source ledger with stable URL or DOI and retrieval date already exists.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this source-ledger hygiene linter.
- Do not make SOTA, novelty, leaderboard, breakthrough, verified-claim, or claim-promotion statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if any SOTA or novelty comparison row can pass with a missing stable URL or DOI, retrieval date, metric, dataset, split, frozen BSEBench value, or comparability caveat.

## Validation

Run and record:

- positive and negative fixture checks for comparable, partial, not-comparable, and each missing-required-field row;
- `bash -n` for changed shell scripts;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
