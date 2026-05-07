---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-w-async-evidence-bundle-index-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.w - async evidence bundle index audit

You are a rigorous async evidence-audit engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add an async-side audit for evidence bundle indexes or readiness packs so mechanical evidence cannot be marked ready without commit SHAs, artifact hashes, replay commands, and guardrail fields.

## Roadmap mapping

- Phase 7: Hinf candidate evidence must keep a replayable mechanical-evidence trail.
- Phase 8 and Phase 11 preparation: future evidence cards need the same index requirements before claim work.
- Research-gate lane: claim registration remains blocked until evidence and comparison handoffs are complete.

## Active lane

Evidence generation, validation infrastructure only. The handoff artifact is an audit report over async evidence bundle metadata; it must not register claims or interpret scientific conclusions.

## Required behavior

- Add or extend a checker for async evidence cards, readiness packs, or bundle indexes under `outbox/` or a test fixture path.
- Require target repo, branch, commit SHA, artifact path, artifact hash when practical, replay command, validation command, scientific-verdict guardrail, claim-target guardrail, and thesis/registry edit guardrail.
- Include negative fixtures for missing commit SHA, missing replay command, missing artifact hash when practical, missing `scientific_verdict=none`, and missing `claim_55` protection.
- Do not modify historical evidence cards unless the task explicitly creates test fixtures or a backward-compatible checker.
- No thesis or claim registry edits are permitted.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this evidence bundle audit.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if an evidence bundle can be marked ready while omitting commit SHAs, replay commands, required artifact hashes, `scientific_verdict=none`, claim-target guardrails, or explicit `claim_55` protection.

## Validation

Run and record:

- positive and negative fixture checks for complete bundles, missing commit SHA, missing replay command, missing artifact hash, missing verdict guardrail, and missing `claim_55` protection;
- `bash -n` for changed shell scripts;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
