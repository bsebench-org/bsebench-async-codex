---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-t-async-source-ledger-ci-enforcement
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.t - async source-ledger CI enforcement

You are a rigorous anti-hallucination and comparison-gate engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make unsupported SOTA or novelty language mechanically unmergeable unless a source ledger row supplies the required comparability fields.

## Roadmap mapping

- Phase 7, Phase 8, and Phase 11: scientific interpretation is blocked until evidence and fair comparison gates are complete.
- Research-gate lane: enforce source-ledger comparability before any claim-registration work.
- Async reliability: chef and workers need a dry-run check that catches missing ledger fields early.

## Active lane

SOTA comparison validation infrastructure. The handoff artifact is a checker, fixture set, or CI dry-run that validates source-ledger completeness and comparability status; it must not create new empirical evidence or register claims.

## Required behavior

- Add or extend a source-ledger checker so rows marked comparable require stable URL or DOI, retrieval date, metric, dataset, split, method, reported value, BSEBench frozen value, and comparability caveat.
- Add negative fixtures proving missing fields cannot pass as comparable.
- If claim-like text contains SOTA, novelty, leaderboard, breakthrough, better-than-prior-work, or verified-claim language, the check must require a completed source ledger or fail.
- Use synthetic fixture rows unless an existing committed ledger already provides stable URL or DOI and retrieval date.
- No thesis or claim registry edits are permitted.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this source-ledger enforcement task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if a comparable source-ledger row can pass while missing a DOI/stable URL, retrieval date, metric, dataset, split, BSEBench frozen value, or comparability caveat, or if unsupported SOTA/novelty text passes without a ledger.

## Validation

Run and record:

- positive and negative source-ledger fixture checks for comparable, partial, not-comparable, missing-field, and unsupported-language cases;
- `bash -n` for changed shell scripts;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
