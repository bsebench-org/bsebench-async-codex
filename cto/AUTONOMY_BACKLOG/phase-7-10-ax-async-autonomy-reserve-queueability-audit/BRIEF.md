---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-ax-async-autonomy-reserve-queueability-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.ax - async autonomy reserve queueability audit

You are a rigorous async orchestration engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make the autonomy reserve count auditable so stale, already-queued, or already-claimed BRIEFs cannot be mistaken for usable capacity.

## Active lane

Evidence generation: async validation infrastructure only. The handoff artifact is a dry-run reserve audit that lists queueable, queued, inbox-present, branch-claimed, malformed, and gate-failing BRIEFs.

## Required behavior

- Review `scripts/cto-autonomy-pacer.sh`, `cto/AUTONOMY_BACKLOG/`, `inbox/`, and the research BRIEF gate script.
- Add or document a dry-run command that reports why each backlog BRIEF is or is not queueable under the same rules the pacer uses.
- The audit must include phase id, target repo, target branch, gate status, queued marker status, inbox status, target-branch claimed status, and final queueable status.
- Ensure the reserve count used for decisions cannot count `QUEUED.json` entries, existing inbox entries, malformed BRIEFs, or target branches that already exist locally or on origin.
- Do not queue new work as part of the audit command unless the operator explicitly runs the pacer outside dry-run mode.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this reserve queueability audit.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If the reserve audit counts a queued BRIEF, existing inbox task, malformed BRIEF, gate-failing BRIEF, or already-claimed target branch as queueable, this task must fail and show the bad row in the validation log.

## Validation

Run and record:

- fixture or temporary-directory probes for queueable, queued-marker, inbox-present, malformed-frontmatter, gate-failing, and branch-claimed cases;
- the real dry-run reserve audit against current `cto/AUTONOMY_BACKLOG/`;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
