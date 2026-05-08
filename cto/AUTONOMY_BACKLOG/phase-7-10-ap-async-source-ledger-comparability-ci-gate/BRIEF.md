---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-ap-async-source-ledger-comparability-ci-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.ap - async source-ledger comparability CI gate

You are a rigorous BSEBench async research-gate engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a CI-usable guard that rejects SOTA, novelty, leaderboard, or better-than-prior-work wording unless the task includes a source ledger with the mandatory comparability fields from the research gate protocol.

## Roadmap mapping

- Validation infrastructure: anti-hallucination and source-ledger comparability gates before any scientific comparison.
- Phase 7/8/11 support: protects Hinf, cross-chemistry, and residual-decomposition work from unsupported external comparisons.

## Active lane

Validation infrastructure: async gate tooling only. The handoff artifact is a checker plus fixtures that can be run against BRIEFs, outbox reports, or source-ledger files.

## Required behavior

- Add or extend an async-side script that detects SOTA, novelty, leaderboard, state-of-the-art, or better-than-prior-work language in research BRIEFs/reports.
- Require a source ledger row or table with stable URL or DOI, retrieval date, exact metric, dataset, split/protocol, BSEBench artifact value, comparability status, and caveat before allowing comparison wording.
- Treat missing ledger fields as `partial` or `not_comparable`, not as permission to compare.
- Provide fixtures for allowed neutral evidence wording, blocked SOTA wording with no ledger, blocked incomplete ledger, and allowed complete ledger with caveats.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this source-ledger CI gate.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If the checker accepts SOTA or novelty wording without a complete source ledger and comparability caveat, or rejects neutral mechanical-evidence wording that makes no external comparison, this task must fail.

## Validation

Run and record:

- focused tests for neutral wording, missing ledger, incomplete ledger, complete comparable ledger, and complete `partial`/`not_comparable` ledger cases;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `bash -n scripts/check-research-brief-gates.sh`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
