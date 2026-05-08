---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-aq-runner-phase11-residual-replay-smoke
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.aq - runner Phase 11 residual replay smoke

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a tiny Phase 11 residual replay smoke check that proves runner residual trace metadata can be consumed by stats decomposition tooling before scheduling expensive full runs.

## Active lane

Evidence generation: preflight replay validation on synthetic or already committed sample artifacts. The handoff artifact is a smoke JSON with residual input identity, stats command identity, compared fields, mismatch count, and blocking gaps.

## Required behavior

- Inspect runner residual trace export helpers, Phase 11 residual input contract work, and stats residual decomposition contract tooling.
- Add or extend a runner smoke command that uses a minimal fixture or committed sample artifact to validate field names, voltage/current/time units, sample counts, residual arrays, stats dependency identity, and replay command wiring.
- The smoke command must not run full filters, must not create new real-data evidence, and must report `mechanical evidence only` plus `claim_55_targeted=false`.
- The output must distinguish fixture replay success from real Phase 11 evidence readiness; passing the smoke check alone must not be described as a scientific result.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 11 residual replay smoke.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements. A SOTA claim requires a source ledger with stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If the smoke fixture lacks required units, residual component fields, sample counts, stats dependency identity, replay command identity, or reports a non-zero mismatch count, the task must fail and block Phase 11 scheduling.

## Validation

Run and record:

- `uv run --locked --all-extras pytest tests/test_phase11_residual_replay_smoke.py -q`;
- the real smoke command over the fixture or committed sample artifact without running filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
