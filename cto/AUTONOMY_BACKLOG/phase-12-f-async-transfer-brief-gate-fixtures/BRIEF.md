---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-12-f-async-transfer-brief-gate-fixtures
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
hard_wallclock_min: 60
---

# Phase 12.f - async transfer brief gate fixtures

You are a rigorous BSEBench orchestration guardrail engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Extend local brief-gate coverage so Phase 12 transfer briefs require provenance, validation, falsification, no-upload, and no-unsupported-claim wording.

## Active lane

Async reliability and guard fixtures only. Do not edit scientific outputs.

## Required behavior

- Add tests or fixtures that catch Phase 12 briefs missing falsification conditions, validation commands, no thesis/registry scope, no `claim_55` targeting, no upload/download authorization, and no unsupported SOTA/novelty/leaderboard/result claims.
- Keep changes limited to local guard scripts, fixtures, or documentation needed by the tests.
- Do not create or modify `QUEUED.json`.
- Do not upload, download, publish, or sync any dataset artifact.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 12 guardrail.
- Do not make SOTA, novelty, leaderboard, breakthrough, or result claims without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The guard must fail if a Phase 12 brief can omit no-upload/no-download, falsification, validation, claim-safety, or protected-file scope wording and still pass.

## Validation

Run and record:

- focused guard tests with pass and fail Phase 12 brief fixtures;
- `scripts/check-research-brief-gates.sh --dry-run --all` or the updated equivalent if Phase 12 support is added;
- the repo standard tests if available;
- `ruff check .` if Python tooling is present;
- `ruff format --check .` if Python tooling is present;
- `git diff --check`.

Commit with GLASSBOX metadata. Do not add prohibited co-author trailers.
