---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-ad-async-claim-gate-ci-fixtures
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.ad - async claim-gate CI fixtures

You are a rigorous async research-gate infrastructure engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add CI-usable fixtures or probes proving that BRIEF guardrails reject claim promotion, unsupported SOTA wording, and protected-claim targeting before workers start.

## Roadmap mapping

- Research-gate lane: block false scientific claims before evidence, comparison, and claim registration lanes are separated.
- Async reliability lane: keep autonomous queueing from dispatching unsafe research instructions.
- Active lane: validation infrastructure only.

## Required behavior

- Review `scripts/check-research-brief-gates.sh`, any claim-language linter, source-ledger schema, and current `cto/AUTONOMY_BACKLOG/` guardrails.
- Add fixture BRIEFs, a shell probe, or CI documentation that exercises acceptable neutral wording and unacceptable claim-promotion wording.
- Negative fixtures must include at least missing falsification, missing validation, thesis or claim registry edit authorization, `claim_55` targeting, and unsupported SOTA or novelty language.
- Any fixture with SOTA wording must be synthetic or explicitly marked forbidden unless it includes a source ledger with stable URL or DOI, retrieval date, metric, dataset, split, and comparability caveat.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to claim-gate fixture validation.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a BRIEF can authorize thesis or claim registry edits, target `claim_55`, or make unsupported SOTA or verified-claim wording while the gate still passes, the task must fail and fix the checker or fixture expectations.

## Validation

Run and record:

- positive and negative fixture checks for all required guardrail categories;
- `bash -n scripts/check-research-brief-gates.sh scripts/cto-autonomy-pacer.sh`;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
