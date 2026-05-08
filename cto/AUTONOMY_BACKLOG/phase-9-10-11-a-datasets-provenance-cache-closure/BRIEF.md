---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-9-10-11-a-datasets-provenance-cache-closure
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 9/10/11.a - datasets provenance/cache closure

You are a rigorous BSEBench datasets provenance engineer. You are not alone in
this codebase; do not revert or overwrite unrelated edits.

## Goal

Convert the current dataset provenance/cache/license NO-GO blocker into a
machine-readable closure board for Phase 9, Phase 10, and Phase 11 candidates,
using existing local evidence only.

## Local evidence to consume

- Phase 9/10/11 completion audit and final synthesis in the async repo.
- Phase 11 provenance inventory summary and any merged datasets provenance
  ledger utilities.
- The local license/access evidence gap validation branch if present.
- Current datasets manifests, metadata records, loader provenance utilities, and
  local-cache status reports available in the target repo.

## Required behavior

- Add or extend a read-only command that emits a JSON and optional Markdown
  closure board for candidate datasets/configs needed by Phase 9, Phase 10, and
  Phase 11.
- Classify each row as `ready`, `partial`, `blocked_missing_source`,
  `blocked_missing_cache`, `blocked_license_access`, `blocked_loader`,
  `blocked_unknown_metadata`, or `not_applicable`.
- Preserve stable dataset/config IDs, chemistry/profile/temperature/split when
  locally known, source URL or DOI fields when locally known, cache-readiness
  status, license/access evidence status, and explicit blocker codes.
- Do not infer missing source identity, license terms, units, cadence, split,
  profile, or cache readiness from filenames, memory, or external knowledge.
- Do not run Hugging Face upload or download commands, do not browse, and do not
  mutate local caches.
- Do not edit thesis files, roadmap files, claim registry files,
  `claims/registry.yaml`, or `claim_55`.
- Do not make comparison, leaderboard, novelty, breakthrough, or
  verified-claim statements without a completed local source ledger and frozen
  BSEBench value rows.

## Dependencies

This task can run immediately. If a referenced audit or local provenance artifact
is absent, record it as `blocked_missing_artifact` and continue to a NO-GO
closure board.

## Falsification gate

If any dataset/config with missing source identity, cache readiness,
license/access evidence, units/cadence when required, loader readiness, or split
identity can be marked `ready`, the task must fail and block downstream
dispatch.

## Acceptance checks

- The output includes summary counts by phase, status, and blocker code.
- Every non-ready row has at least one concrete blocker code.
- No absolute local paths, private cache roots, tokens, or home-directory
  fragments appear in committed artifacts.
- Phase 9/10/11 empirical dispatch remains blocked unless every required row for
  that phase is `ready` or explicitly `not_applicable`.

## Validation

Run and record:

- focused tests for ready, partial, missing source, missing cache,
  license/access blocked, loader blocked, unknown metadata, and not-applicable
  rows;
- the real read-only closure command over current local manifests/candidates;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with a subject starting `GLASSBOX`. Do not add co-author trailers.
