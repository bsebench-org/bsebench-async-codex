---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-af-stats-phase8-cross-dataset-floor-contract
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.af - stats Phase 8 cross-dataset floor contract

You are a rigorous BSEBench statistics engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Define a synthetic-testable stats contract for Phase 8 cross-dataset MAD/PCRLB floor comparisons before any real cross-chemistry claim work starts.

## Roadmap mapping

- Phase 8 preparation: cross-chemistry BMA ceiling checks need comparable MAD/PCRLB units, splits, and aggregation rules.
- Phase 11 preparation: the same floor contract supports later sensor-noise versus model-mismatch decomposition.
- Active lane: preflight validation and schema enforcement only.

## Required behavior

- Add or extend a small schema, parser, or validator for cross-dataset floor comparison input rows.
- Required fields must include dataset/config identifier, chemistry or explicit unknown status, split/run condition, metric and units, MAD or PCRLB value with uncertainty when available, sample count, aggregation rule, and comparability caveat.
- The validator must reject non-finite values, mixed units without conversion metadata, missing split/run condition, missing sample counts, and aggregation rules that would hide dataset imbalance.
- Keep the task preparatory: no real scientific verdict, no thesis prose, no claim registry update, and no SOTA or novelty comparison.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8/11 floor contract.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If the contract accepts non-finite values, incompatible units, missing split metadata, missing sample counts, or an aggregation rule that masks dataset imbalance, the validator must fail and report the offending row.

## Validation

Run and record:

- focused tests for valid rows, non-finite values, mixed units, missing split, missing sample count, and imbalance-hiding aggregation;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
