---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-aq-runner-phase8-11-handoff-bundle-preflight
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.aq - runner Phase 8/11 handoff bundle preflight

You are a rigorous BSEBench runner preflight engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Define a dry-run handoff-bundle preflight so Phase 8 cross-chemistry and Phase 11 residual-decomposition runs expose missing metadata before expensive filters are launched.

## Roadmap mapping

- Roadmap scope: Phase 8 cross-chemistry extension, Phase 11 residual decomposition, and validation infrastructure.
- Active lane: Evidence generation, limited to pre-dispatch validation without running filters.
- Handoff artifact: deterministic readiness JSON with intended inputs, output paths, stats schema version, dataset provenance pointer, source-ledger placeholder status, and blocking reasons.

## Required behavior

- Add or extend a dry-run command that assembles the intended Phase 8/11 handoff bundle metadata without executing filters or writing empirical outputs.
- The preflight must report dataset/config identifiers, chemistry labels, units/timebase availability, provenance manifest pointers, local-cache readiness, stats dependency identity, expected output schema version, and sanitized intended output paths.
- Output JSON must distinguish `ready`, `not_ready`, and `insufficient_metadata` per config with concrete blocking reasons.
- Do not generate residual traces, recompute Hinf evidence, download data, or commit local-machine absolute paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8/11 handoff-bundle preflight.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any Phase 8 or Phase 11 config lacks units, timebase, chemistry/provenance identity, local-cache readiness, stats dependency identity, or schema version but is marked `ready`, the preflight must fail and block downstream scheduling.

## Validation

Run and record:

- focused tests for ready bundles, missing provenance, missing units/timebase, missing chemistry, missing stats schema, cache not ready, and unsanitized output paths;
- a real dry-run handoff-bundle preflight over the current candidate config set without running filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
