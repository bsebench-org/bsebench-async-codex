---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-8-f-stats-lock-policy
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 45
---

# Phase 7.8.f — stats lockfile and CI reproducibility policy

You are a rigorous BSEBench reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits. Keep the write scope narrow.

## Goal

Resolve the reproducibility ambiguity around `bsebench-stats` dependency locking and CI behavior.

## Required behavior

- Inspect whether `uv.lock` is intended to be tracked in this repo.
- If the project convention supports a tracked lockfile, commit the lockfile and update CI/local instructions to use `uv sync --locked --all-extras` and `uv run --locked ...`.
- If the convention is intentionally library-style without a tracked lockfile, document that policy and add a lightweight guard so CI cannot silently claim locked reproducibility.
- Do not delete an existing untracked user file from the primary checkout.
- Do not change scientific code unless directly needed for reproducibility policy.

## Falsification gate

The final result must make it clear whether `bsebench-stats` is lockfile-reproducible or intentionally not lockfile-reproducible. Ambiguity is a failure.

## Validation

Run and record the policy-appropriate gates, for example:

- `uv lock --check` if a lockfile is committed
- `uv sync --locked --all-extras` if a lockfile is committed
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q` if locked
- `uv run --locked --all-extras ruff check .` if locked
- otherwise the existing non-locked pytest/ruff plus the new policy guard

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
