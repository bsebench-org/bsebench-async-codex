---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-t-async-pacer-reserve-claim-guard-dry-run
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.t - async pacer reserve claim guard dry run

You are a rigorous async validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Roadmap mapping

- Research-gate lane: CI and async guardrails that block false scientific claims.
- Ops lane: keep autonomy useful while preserving reserve quality.
- Active lane: Evidence generation only.

## Goal

Add a dry-run guard that proves the autonomy pacer will not queue a reserve BRIEF that targets protected claims, lacks validation, or bypasses the research-gate checker.

## Required behavior

- Review `scripts/cto-autonomy-pacer.sh`, `scripts/check-research-brief-gates.sh`, and current `cto/AUTONOMY_BACKLOG/` entries.
- Add a shell test, dry-run fixture, or documented probe that demonstrates pacer skip reasons for: queued marker present, inbox already exists, target branch already claimed, malformed frontmatter, missing falsification gate, missing validation command, and protected `claim_55` targeting.
- The probe must count only queueable reserve BRIEFs and must print skipped reasons in a form useful for CI logs.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this async reserve guard task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a BRIEF that targets `claim_55`, lacks a falsification gate, lacks validation wording, or has a claimed target branch is counted as queueable, the dry-run guard must fail and explain the bad count.

## Validation

Run and record:

- positive and negative dry-run fixture checks for each skip reason;
- `bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh`;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- a reserve count command proving current queueable BRIEFs are reported;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
