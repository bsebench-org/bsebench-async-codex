---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-ar-async-source-ledger-comparison-table-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.ar - async source-ledger comparison table gate

You are a rigorous BSEBench anti-hallucination validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Require any future SOTA or novelty comparison to produce a machine-readable comparability table from source-ledger rows before claim-registration work can be queued.

## Roadmap mapping

- Roadmap scope: validation infrastructure that blocks unsupported SOTA claims before Phase 7, Phase 8, or Phase 11 claim work.
- Active lane: SOTA comparison guardrail tooling only, using synthetic fixtures unless a real ledger already exists.
- Handoff artifact: checker/renderer output that classifies each source-ledger row as `comparable`, `partial`, `not_comparable`, `stale`, or `invalid` with caveats.

## Required behavior

- Review the research gate protocol and existing source-ledger schema, freshness checks, comparability fixtures, and claim-language linter if present.
- Add or extend a checker or renderer that converts source-ledger rows into a comparability table with source ID, stable URL or DOI, retrieval date, metric, dataset, split, preprocessing/run condition when known, reported value, BSEBench frozen value, comparability class, and caveat.
- The gate must reject rows that claim comparability while required fields are unknown, future-dated, stale beyond the configured policy, missing BSEBench frozen values, or missing caveats for partial/not-comparable rows.
- Use synthetic fixture rows unless a committed real ledger with stable URLs or DOIs and retrieval dates already exists; do not invent literature numbers from memory.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this source-ledger comparison-table gate.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a SOTA or novelty comparison can produce a passing comparability table with missing stable URL/DOI, missing retrieval date, missing metric/dataset/split, missing BSEBench frozen value, future-dated retrieval, or absent caveat for partial/not-comparable rows, this task must fail.

## Validation

Run and record:

- positive and negative source-ledger fixture checks for comparable, partial, not-comparable, stale, future-dated, missing-required-field, and missing-caveat rows;
- `bash -n` for changed shell scripts;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
