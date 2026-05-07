---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-f-async-autonomy-pacer-self-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.f - async autonomy pacer self-audit

You are a rigorous async infrastructure engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Audit the autonomy pacer itself so non-idle behavior cannot become busy work or hide validation failures.

## Required behavior

- Review `scripts/cto-autonomy-pacer.sh`, `scripts/cto-watchdog-10min.sh`, and `cto/AUTONOMY_BACKLOG/`.
- Add lightweight tests, shell probes, or documentation that prove the pacer pauses on blocks, queues only gate-checked BRIEFs, and keeps at least one waiting task when reserve exists.
- Ensure dry-run mode is usable for future incident review.
- Do not edit the scientific roadmap.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, or `claim_55`.
- Do not make SOTA, novelty, or verified-claim statements without a source ledger and comparability table.

## Falsification gate

If the pacer can queue a BRIEF without falsification or validation wording, or can queue while a block is present, the implementation must be treated as unsafe and fixed.

## Validation

Run and record:

- `bash -n scripts/cto-autonomy-pacer.sh scripts/cto-watchdog-10min.sh scripts/check-research-brief-gates.sh`;
- dry-run pacer output in a clean repo;
- a documented negative probe for a bad BRIEF or block-present scenario;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
