---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-h-stats-pcrlb-floor-preflight
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.h - stats PCRLB floor preflight

You are a rigorous BSEBench statistics engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 8/11 sensor-floor work with a neutral PCRLB/MAD preflight interface, without changing any scientific claim.

## Required behavior

- Add a small stats-side schema, parser, or preflight command for future PCRLB/MAD floor comparisons.
- The implementation must be synthetic-testable and must not depend on undocumented real-data assumptions.
- Output must be JSON-safe and finite.
- Keep it preparatory: no thesis prose, no registry edit, no verified floor claim.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not make SOTA, novelty, or verified-claim statements without a source ledger and comparability table.

## Falsification gate

If required noise-floor inputs are missing, non-finite, or dimensionally inconsistent, the preflight must fail loud instead of producing a usable-looking report.

## Validation

Run and record:

- focused tests for valid, missing, non-finite, and dimension-mismatch inputs;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
