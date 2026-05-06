---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-6-11-b-chi2-multi-cfg-sweep-fix-1
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 60
---

# Phase 6.11.b fix-1 - chi2 sweep multi-cfg (5 cfgs x 5 filters)

## Why this is fix-1

The original `phase-6-11-b-chi2-multi-cfg-sweep` fossilized in `running` and was
reconciled to `error` by the CTO. It was deliberately deferred until
`phase-6-10-h-bsebench-runner-registry-swap-fix-1` landed, because the sweep
needs real default Tier 2 loader factories instead of stubs.

`bsebench-runner/main` now contains:

- `34acb8b9d8ca2fbce8ea99cd31984e43403b4f88`
  (`feat(adapters): swap default stubs to Tier 2 loaders [role: worker-codex-FR]`)

Execution base requirement: create the worktree from `origin/main` after
`git fetch origin`, not from any existing local `main` checkout. On the France
PC, the reusable `/mnt/c/doctorat/bsebench-org/bsebench-runner` checkout may
contain unrelated local modifications; do not reset or reuse that dirty checkout
for this phase.

## Mission

Extend 6.11.a (1 cfg smoke) into a small multi-cfg sweep:

- 5 configs x 5 filters = 25 cells.
- Config targets: Yao BCDC T25, Yao US06 T25, Panasonic US06 T25,
  NASA B0005 T24, CALCE A123 DST T25.
- Filter subset: EnsembleMeta, EKF, UKFDef, JUKFV6B, Hinf.
- Output: `outputs/chi2_sweep_5x5.json` with matrix, per-cell chi2, p-values,
  RMSE metadata, and explicit skipped/error cells if a dataset is unavailable.

## Pre-flight

1. Read `scripts/chi2_smoke_yao_bcdc_t25.py` from 6.11.a.
2. Read `src/bsebench_runner/default_adapters.py` on current `main` to confirm
   real loaders are used lazily.
3. Inspect the relevant dataset loader APIs before calling them; do not assume
   every profile/temperature is locally cached.
4. Confirm `git rev-parse --short HEAD` in the worker worktree resolves to
   `34acb8b` or a direct descendant before editing.

## Deliverables

### `scripts/chi2_sweep_5x5.py`

Loop over the 5 configs x 5 filters, compute each chi2 result, save JSON, and
print a concise summary table. Use small, explicit helper functions rather than
large ad hoc blocks.

The script must be robust to unavailable remote data: represent unavailable
cells explicitly in JSON instead of crashing the whole sweep.

### `tests/test_chi2_sweep_5x5.py`

Add fast tests that do not hit Hugging Face or thesis legacy code:

- import/CLI smoke works;
- mocked data run produces the expected 5x5 matrix shape;
- unavailable cell handling is explicit and deterministic.

## Acceptance gates

- G1: at least 2 fast tests pass for the new sweep.
- G2: `uv run pytest -m "not slow" --tb=short` passes.
- G3: `uv run ruff format --check .` passes.
- G4: `uv run ruff check .` passes.
- G5: scope is limited to the sweep script, its focused tests, and minimal
  supporting code only if unavoidable.
- G6: commit uses GLASSBOX with `[role: worker-codex-FR]`.
- G7: no `Co-Authored-By: Claude` trailer.

## Out of scope

- No roadmap changes.
- No retuning filters.
- No edits to scientific claims in the thesis repo.
- No broad refactor of the runner.

## If blocked

Write `outbox/phase-6-11-b-chi2-multi-cfg-sweep-fix-1/BLOCKED.md` with the
exact missing dataset/import, traceback, and the smallest proposed next phase.
