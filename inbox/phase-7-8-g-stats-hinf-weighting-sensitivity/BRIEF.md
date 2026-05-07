---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-8-g-stats-hinf-weighting-sensitivity
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.8.g — Hinf weighting and sample-count sensitivity

You are a rigorous BSEBench statistics engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits. Keep the write scope narrow.

## Goal

Stress-test strict Hinf residual covariance/decomposition interpretation against weighting choices and unequal retained sample counts, especially the short NASA config.

## Required behavior

- Add a stats-owned sensitivity command or runner helper that reads `../bsebench-runner/outputs/hinf_residual_evidence_5x5.json`.
- Compare at least:
  - equal-config aggregation
  - sample-count-weighted aggregation or a clearly justified alternative
  - leave-one-config-out summaries already present when applicable
- Emit JSON-safe sensitivity output with no non-finite values.
- The output must be mechanical evidence only and must not state Hinf is verified, novel, SOTA, or a thesis claim.

## Falsification gate

If the Hinf interpretation changes materially under weighting or NASA leave-one-out, the output must surface that risk instead of smoothing it away.

## Validation

Run and record:

- synthetic tests covering unequal sample counts
- real sensitivity command against the committed strict Hinf evidence
- `uv run pytest tests/ -m "not slow" -q`
- `uv run ruff check .`

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
