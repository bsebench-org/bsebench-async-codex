---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-ap-async-source-ledger-command-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 75
---

# Phase 7.10.ap - async source-ledger command gate

You are a rigorous BSEBench async research-gate engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add an async-side gate that rejects BRIEFs or reports that request SOTA/novelty comparison work without a concrete source-ledger validation command.

## Active lane

Evidence generation: orchestration validation, not scientific comparison. The handoff artifact is a shell-checkable gate plus fixtures proving that source-ledger work declares the command, required fields, and comparability caveats before workers run.

## Required behavior

- Inspect `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`, existing brief gate scripts, source-ledger schema work, and backlog/inbox examples.
- Add or extend an async gate that detects SOTA, novelty, leaderboard, better-than-prior-work, or comparison wording and requires a source-ledger validation command plus required fields: stable URL or DOI, retrieval date, metric, dataset, split, BSEBench value, comparability, and caveat.
- Include positive and negative fixtures for BRIEFs that mention SOTA comparison, BRIEFs that explicitly ban unsupported SOTA claims, and mechanical evidence tasks that do not perform comparison.
- The gate must not require source ledgers for tasks that only prohibit unsupported SOTA language and do no comparison work.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this async source-ledger command gate.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements. A SOTA claim requires a source ledger with stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a fixture can request SOTA/novelty/comparison work without declaring a source-ledger validation command and the required comparability fields, or if a purely prohibitive no-SOTA BRIEF is falsely rejected, the task must fail.

## Validation

Run and record:

- `bash scripts/check-source-ledger-command-gate.sh --fixtures`;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `bash -n scripts/check-source-ledger-command-gate.sh scripts/check-research-brief-gates.sh`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
