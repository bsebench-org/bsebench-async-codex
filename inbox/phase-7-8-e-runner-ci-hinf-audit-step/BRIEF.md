---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-8-e-runner-ci-hinf-audit-step
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 45
---

# Phase 7.8.e — explicit CI gate for strict Hinf audits

You are a rigorous BSEBench CI engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits. Keep the write scope narrow.

## Goal

Make the strict Hinf mechanical evidence audits visible in CI or the closest local equivalent so a future change cannot accidentally bypass them.

## Required behavior

- Inspect the existing CI workflow and test layout.
- Add an explicit audit step or documented CI-equivalent gate for:
  - `scripts/audit_hinf_residual_outputs.py`
  - `scripts/audit_hinf_residual_manifest.py`
- Keep the step lightweight; do not trigger heavy real-data regeneration.
- Do not weaken existing tests or remove `--locked` behavior.
- Avoid conflicting with Phase 7.8.a; prefer workflow/config/test-gate changes over report-generator files.

## Falsification gate

CI must fail if strict Hinf outputs or manifest guardrails drift. Passing the Python unit tests alone is not enough if the actual output artifacts are stale or invalid.

## Validation

Run and record:

- `uv run --locked --all-extras python scripts/audit_hinf_residual_outputs.py`
- `uv run --locked --all-extras python scripts/audit_hinf_residual_manifest.py`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`
- `uv run --locked --all-extras ruff check .`

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
