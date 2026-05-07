---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-v-stats-phase8-pcrlb-comparability-fixtures
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.v - stats Phase 8 PCRLB comparability fixtures

You are a rigorous BSEBench statistics and comparison-preflight engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add stats-side synthetic fixtures that make Phase 8 PCRLB/MAD floor comparability decisions testable before any real source-ledger or claim-registration work is allowed.

## Roadmap map

- Phase 8 preflight: PCRLB/MAD floor comparisons need explicit metric, dataset, split, and caveat handling.
- Research-gate lane: separate comparison mechanics from claim registration and unsupported SOTA language.

## Required behavior

- Add or extend a stats-side fixture, parser, or checker for PCRLB/MAD comparability rows over frozen BSEBench values.
- Required fields must include DOI or stable URL, retrieval date, metric, dataset, split, method, reported value, BSEBench frozen value, comparability status, and comparability caveat.
- Fixture rows must be synthetic or empty templates unless a real source ledger already provides stable source metadata.
- The checker must distinguish comparable, partial, and not-comparable rows, and must reject missing required fields.
- Do not generate new empirical evidence or compare against uncited literature.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8 PCRLB comparability fixture task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a PCRLB/MAD comparison row can pass with a missing stable source, retrieval date, exact metric, dataset, split, frozen BSEBench value, comparability status, or caveat, the checker must fail and block downstream comparison or claim work.

## Validation

Run and record:

- focused tests for comparable, partial, not-comparable, missing-source, missing-split, missing-frozen-value, and missing-caveat rows;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
