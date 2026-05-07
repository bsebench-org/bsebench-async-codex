---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-6-11-b-chi2-multi-cfg-sweep-fix-2
base_branch: phase-6-11-b-chi2-multi-cfg-sweep-fix-1
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 45
---

# Phase 6.11.b fix-2 - chi2 sweep evidence hygiene

## Why this is fix-2

`phase-6-11-b-chi2-multi-cfg-sweep-fix-1` implemented a useful sweep script and
mocked tests, but it also committed `outputs/chi2_sweep_5x5.json` with
`summary.ok == 0` and `summary.skipped == 25` because Hugging Face data access
returned 401/repository-not-found responses.

That all-skipped JSON is a diagnostic, not scientific evidence. It must not land
on `main` as if it validated chi2, p-values, or RMSE for the 5x5 matrix.

## Mission

Start from `origin/phase-6-11-b-chi2-multi-cfg-sweep-fix-1` and make the branch
scientifically honest.

Choose the strongest feasible path:

1. If authenticated/local Tier 2 data is available, regenerate
   `outputs/chi2_sweep_5x5.json` with real cells and commit it only if at least
   one real cell is `ok`. Prefer 25/25 `ok`.
2. If real data is not available, remove `outputs/chi2_sweep_5x5.json` from the
   branch and keep only the reusable script/tests. Add a guard such as
   `--require-ok-cells N` so future evidence runs can fail loudly instead of
   silently producing 0/25 evidence.

## Required behavior

- Never commit a versioned `outputs/chi2_sweep_5x5.json` with `summary.ok == 0`.
- Keep unavailable-cell handling in the script; runtime diagnostics may still
  represent skipped cells explicitly.
- If adding `--require-ok-cells`, tests must cover both pass and failure cases.
- No claim registry changes. No thesis prose edits. No roadmap edits.

## Acceptance gates

- G1: focused sweep tests pass.
- G2: `uv run --all-extras pytest -m "not slow" --tb=short` passes.
- G3: `uv run --all-extras ruff format --check .` passes.
- G4: `uv run --all-extras ruff check .` passes.
- G5: no committed 0-ok sweep JSON.
- G6: commit uses GLASSBOX with `[role: worker-codex-FR]`.
- G7: no `Co-Authored-By: Claude` trailer.

## If blocked

Write `outbox/phase-6-11-b-chi2-multi-cfg-sweep-fix-2/BLOCKED.md` with:

- whether HF auth is missing or dataset IDs are wrong;
- the exact exception type without leaking tokens;
- whether the script/tests are otherwise ready to merge as tooling.
