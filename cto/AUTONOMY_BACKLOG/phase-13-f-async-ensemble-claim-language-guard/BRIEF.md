---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-13-f-async-ensemble-claim-language-guard
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 13.f - async ensemble claim-language guard

You are a rigorous BSEBench orchestration guardrail engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add guard coverage so Phase 13 ensemble briefs and reports cannot use unsupported SOTA, novelty, leaderboard, or result-improvement claims.

## Active lane

Async reliability and claim-safety fixtures only. Do not edit scientific result artifacts.

## Required behavior

- Add tests or fixtures that reject Phase 13 ensemble briefs/reports using unsupported SOTA, novelty, leaderboard, breakthrough, best, superior, or result-improvement language without required source-ledger and comparability fields.
- Ensure guard fixtures also require falsification, validation, no thesis/registry edits, no `claim_55` targeting, and no upload/download authorization.
- Keep changes limited to local guard scripts, fixtures, or documentation needed by the tests.
- Do not create or modify `QUEUED.json`.
- Do not upload, download, publish, or sync any dataset artifact.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 13 guardrail.
- Do not make SOTA, novelty, leaderboard, breakthrough, or result claims without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The guard must fail if a Phase 13 ensemble brief or report can imply performance improvement, novelty, leaderboard status, or SOTA status without the required evidence and caveats.

## Validation

Run and record:

- focused guard tests with pass and fail Phase 13 ensemble fixtures;
- `scripts/check-research-brief-gates.sh --dry-run --all` or the updated equivalent if Phase 13 support is added;
- the repo standard tests if available;
- `ruff check .` if Python tooling is present;
- `ruff format --check .` if Python tooling is present;
- `git diff --check`.

Commit with GLASSBOX metadata. Do not add prohibited co-author trailers.
