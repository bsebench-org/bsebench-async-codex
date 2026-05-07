---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-t-async-source-ledger-comparability-ci-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.t - async source-ledger comparability CI gate

You are a rigorous anti-hallucination and CI guardrail engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Turn the source-ledger comparability policy into a CI-usable gate so future SOTA or novelty wording cannot pass without stable source metadata and a comparability table.

## Active lane

SOTA comparison guardrail tooling. The handoff artifact is a checker plus fixtures; it does not perform a new comparison and does not register a claim.

## Required behavior

- Add or extend an async-side checker such as `scripts/check-source-ledger-comparability-gate.sh` with positive and negative fixtures.
- The checker must require stable URL or DOI, retrieval date, exact metric, dataset, split, reported value, BSEBench value or frozen artifact reference, comparability status, and caveat for every comparison row.
- It must fail when a report uses SOTA, novelty, leaderboard, breakthrough, best-in-field, or verified-claim wording without a valid source ledger and comparability table.
- Missing fields must be reported as comparability gaps, not guessed or silently accepted.
- Wire the checker into an existing lightweight validation path or document the exact CI command if there is no CI file to edit safely.
- Do not edit thesis files, claim registry files, claims/registry.yaml, claim_55, docs/RESEARCH-ROADMAP-2026-05-06.md, or roadmap text.
- Do not target claim_55; claim_55 is protected and unrelated to this backlog task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any unsupported SOTA or novelty statement can pass the checker, or if any malformed ledger row with missing source, retrieval, metric, dataset, split, value, comparability, or caveat fields passes, the gate must fail and the task is incomplete.

## Validation

Run and record:

- `bash -n scripts/check-source-ledger-comparability-gate.sh`;
- `bash scripts/check-source-ledger-comparability-gate.sh tests/fixtures/source-ledger/valid-comparison.md`;
- a negative fixture command that exits non-zero for unsupported SOTA wording;
- a negative fixture command that exits non-zero for missing comparability fields;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
