---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-v-stats-pcrlb-mad-input-contract
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.v - stats PCRLB/MAD input contract

You are a rigorous BSEBench stats validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Define and validate the input contract for Phase 8 PCRLB/MAD ceiling checks and Phase 11 residual-decomposition inputs before those analyses are interpreted.

## Roadmap mapping

- Phase 8: PCRLB/MAD ratio checks need finite metrics, units, dataset identity, and split/profile metadata.
- Phase 11: residual-decomposition analysis must distinguish sensor floor, model mismatch, and numerical gaps with explicit metadata.
- Validation infrastructure: malformed metric payloads must fail before any claim-supporting result is produced.

## Active lane

Evidence generation, validation infrastructure only. The handoff artifact is a schema, validator, or contract report for stats input payloads; it must not assert a ceiling, SOTA, novelty, or claim verdict.

## Required behavior

- Add a lightweight schema, validator, or parser contract for PCRLB/MAD and residual-decomposition input payloads.
- Require finite numeric arrays or scalars, explicit units, dataset/config identifiers, split or profile metadata, and provenance/replay references when applicable.
- Missing metadata must be represented as a gap or failure, not inferred from filenames.
- Include synthetic positive and negative fixtures so future workers know the minimum payload shape.
- No thesis or claim registry edits are permitted.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this stats input-contract task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if non-finite values, missing units, missing dataset/config identity, missing split/profile metadata, or absent provenance/replay references can pass as claim-ready input.

## Validation

Run and record:

- focused tests for valid payloads, non-finite values, missing units, missing dataset/config identity, missing split/profile metadata, and missing provenance/replay references;
- a dry-run contract check over any existing committed PCRLB/MAD or residual-decomposition fixture, if present;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
