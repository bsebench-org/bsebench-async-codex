---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-aj-async-research-gate-diff-scope-guard
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 75
---

# Phase 7.10.aj - async research-gate diff-scope guard

You are a rigorous async research-gate engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a dry-run diff-scope guard so chef or worker validation can reject unauthorized thesis, registry, roadmap, `claim_55`, or unsupported comparison edits before merge.

## Roadmap mapping

- Roadmap scope: validation infrastructure that blocks false scientific claims and async reliability for Phase 7/8/11 work.
- Active lane: Evidence generation, limited to guardrail tooling and fixture validation.
- Handoff artifact: deterministic dry-run report over a changed-file list or git diff that labels allowed, blocked, and review-required paths.

## Required behavior

- Review the research gate protocol, chef/worker scripts, and existing BRIEF gate checker before choosing the implementation surface.
- Add a lightweight script, fixture, or documented dry-run path that checks changed files and blocks unauthorized edits to thesis files, claim registry files, `claims/registry.yaml`, roadmap files, and any direct `claim_55` target.
- The guard must distinguish allowed validation-only changes, blocked protected-path changes, and review-required SOTA or novelty comparison changes that lack a source ledger.
- Include negative fixtures for protected paths and unsupported comparison language; the guard must fail loudly rather than silently skipping them.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files except as synthetic fixture paths inside tests.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this diff-scope guard.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a fixture diff that edits `claims/registry.yaml`, thesis prose, roadmap files, `claim_55`, or unsupported SOTA/novelty language can pass the guard without an explicit review-required or blocked status, the task must fail.

## Validation

Run and record:

- positive and negative fixture checks for allowed validation changes, protected-path changes, `claim_55` targeting, unsupported SOTA/novelty language, and source-ledger-present comparison changes;
- `bash -n` for changed shell scripts;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
