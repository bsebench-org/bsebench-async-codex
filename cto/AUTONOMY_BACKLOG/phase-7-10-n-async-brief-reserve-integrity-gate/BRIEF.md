---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-n-async-brief-reserve-integrity-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.n - async BRIEF reserve integrity gate

You are a rigorous async infrastructure engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a reserve-integrity check so the curated autonomy backlog cannot silently fall below useful capacity or include BRIEFs that pacer cannot safely queue.

## Required behavior

- Review `scripts/cto-autonomy-pacer.sh`, `scripts/check-research-brief-gates.sh`, and `cto/AUTONOMY_BACKLOG/`.
- Add a lightweight script, shell test, or documented dry-run probe that counts unqueued reserve BRIEFs using the same rules as pacer: no `QUEUED.json`, no existing inbox directory, and no claimed target branch.
- The check must validate each candidate BRIEF with the research-gate checker and report skipped reasons for queued, malformed, or branch-claimed tasks.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to backlog replenishment.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If the reserve count can drop below the configured minimum while checks still pass, or if a malformed/unsafe BRIEF is counted as queueable, the gate must fail and explain the mismatch.

## Validation

Run and record:

- `bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh`;
- a reserve count command proving current queueable BRIEFs are reported;
- a negative probe for a malformed BRIEF or branch-claimed BRIEF;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
