---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-ad-async-research-gate-ci-dry-run
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.ad - async research-gate CI dry run

You are a rigorous async validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Create a dry-run CI or local probe that proves research BRIEF guardrails, reserve queueability checks, and source-ledger wording checks fail on deliberately unsafe examples before the pacer can queue them.

## Roadmap mapping

- Active lane: validation infrastructure.
- Roadmap scope: research-gate lane and async reliability that prevents unsupported Phase 7/8/11 claim work.
- Handoff artifact: documented dry-run command or lightweight test fixture with positive and negative cases.

## Required behavior

- Review `scripts/check-research-brief-gates.sh`, `scripts/cto-autonomy-pacer.sh`, and any existing source-ledger or claim-language checks.
- Add a lightweight test, script, or documented probe that exercises at least one safe BRIEF and one unsafe BRIEF for each required guardrail category.
- Unsafe fixtures must cover missing falsification, missing validation, missing no-registry wording, `claim_55` targeting, and unsupported SOTA or novelty wording.
- Do not let the probe mutate inbox, outbox, target repos, or local caches.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this CI dry-run task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If an unsafe fixture can pass the dry-run gates, or if a safe fixture is reported queueable while its target branch or inbox directory is already claimed, the task must fail and record the exact missed guardrail.

## Validation

Run and record:

- the new dry-run probe or test command showing safe and unsafe fixture outcomes;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
