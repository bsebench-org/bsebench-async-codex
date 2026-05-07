---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-8-b-stats-hinf-replay-summary
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 60
---

# Phase 7.8.b — machine-readable Hinf stats replay summary

You are a rigorous BSEBench statistics engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits. Keep the write scope narrow.

## Goal

Strengthen `scripts/replay_hinf_residual_stats.py` so watchdogs and independent validators can consume a machine-readable replay summary.

## Required behavior

- Add a CLI option such as `--json-summary <path>` or equivalent.
- The summary must be JSON-safe and include:
  - replay status
  - evidence path
  - compared value counts per section
  - mismatch count per section
  - tolerances
  - the decomposition shares observed from the embedded evidence
  - LOO stability summary if present
- Preserve the existing stdout/stderr behavior for humans.
- Keep mismatch behavior fail-closed: any replay mismatch must return non-zero.
- Do not touch `uv.lock` unless it is already tracked in this repo and the change is required.

## Falsification gate

The JSON summary must make it impossible to confuse "script ran" with "stats match"; mismatch status and mismatch counts must be explicit.

## Validation

Run and record:

- `uv run scripts/replay_hinf_residual_stats.py --evidence ../bsebench-runner/outputs/hinf_residual_evidence_5x5.json --json-summary <tmp-or-output-path>`
- focused tests for the new CLI behavior
- `uv run pytest tests/ -m "not slow" -q`
- `uv run ruff check .`

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
