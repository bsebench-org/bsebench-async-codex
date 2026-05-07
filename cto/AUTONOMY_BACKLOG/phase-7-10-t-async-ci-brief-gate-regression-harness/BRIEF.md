---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-t-async-ci-brief-gate-regression-harness
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.t - async CI brief-gate regression harness

You are a rigorous BSEBench async validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make the research BRIEF gate itself regression-tested so future Phase 7/8/11 backlog tasks cannot silently lose falsification, validation, SOTA-safety, registry, or `claim_55` guardrails.

## Active lane

Validation infrastructure. This task tests guardrail enforcement only and must not alter scientific roadmap content.

## Required behavior

- Review `scripts/check-research-brief-gates.sh`, `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`, and current autonomy backlog examples.
- Add a lightweight regression harness or fixture set that checks at least one valid BRIEF and invalid BRIEFs missing each required guardrail.
- Required negative cases must cover missing falsification, missing validation/replay wording, missing no-thesis-or-claim-registry edit language, missing `claim_55` prohibition, and unsupported SOTA or novelty language without a source ledger.
- The harness must be runnable locally and suitable for CI without network access.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this async CI brief-gate harness.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If an invalid fixture missing any required research-gate guardrail exits successfully, or if a valid fixture fails without identifying the broken rule, the task must fail and block use of the harness as a CI gate.

## Validation

Run and record:

- the new regression harness against valid and invalid fixture BRIEFs;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
