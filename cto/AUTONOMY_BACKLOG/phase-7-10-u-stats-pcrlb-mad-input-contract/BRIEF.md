---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-u-stats-pcrlb-mad-input-contract
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 75
---

# Phase 7.10.u - stats PCRLB/MAD input contract

You are a rigorous BSEBench stats preflight engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Define and validate the input contract for future PCRLB/MAD and sensor-floor calculations before Phase 8 or Phase 11 code consumes empirical artifacts.

## Roadmap mapping

- Active lane: evidence generation.
- Phase 8 preparation: PCRLB/MAD ceiling validation requires explicit metric, unit, dataset, split, and sensor-floor inputs.
- Phase 11 preparation: residual decomposition requires separating sensor-noise, model-mismatch, and numerical terms without unsupported interpretation.

## Required behavior

- Review existing stats replay summaries, Hinf residual outputs, and any PCRLB/MAD preflight helpers.
- Add a schema, dataclass validator, fixture, or command that validates PCRLB/MAD input rows before computation.
- Required row fields must include dataset/config identifier, split/profile, chemistry when known, metric name and unit, MAD value, PCRLB or sensor-floor value, sample count, artifact source, artifact hash when practical, and provenance caveat.
- The validator must reject missing units, missing split/profile, non-finite values, negative variances/floors, mismatched dataset identifiers, and ambiguous sensor-floor source.
- Do not compute or state a Phase 8 or Phase 11 scientific conclusion in this task.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to PCRLB/MAD input-contract validation.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If an input row with missing units, missing split/profile, non-finite numeric values, negative floor terms, unknown artifact source, or an ambiguous sensor-floor definition can pass validation, the task must fail.

## Validation

Run and record:

- focused tests for valid rows plus each rejection case listed in the falsification gate;
- a dry-run validation over any current PCRLB/MAD fixture or a clearly labeled synthetic fixture if no real fixture exists;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
