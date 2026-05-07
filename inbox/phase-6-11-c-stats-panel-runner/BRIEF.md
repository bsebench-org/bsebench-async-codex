---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-6-11-c-stats-panel-runner
base_branch: main
add_dir:
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 40
---

# Phase 6.11.c - stats panel runner

## Mission

Add a small reusable runner/report layer in `bsebench-stats` that turns an RMSE
matrix into the panel-style statistics needed by BSEBench:

- Friedman omnibus test;
- Nemenyi critical-distance summary;
- Spearman rank-correlation matrix between filters.

This is the roadmap Phase 6.11.c bridge from paper2b scripts to the public
`bsebench-stats` package. It does not modify any claim.

## Source references

Read first:

- `src/bsebench_stats/friedman.py`
- `src/bsebench_stats/friedman_nemenyi.py`
- `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch/phase_J_audit_friedman_retune.py`
- `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch/friedman_nemenyi.py`
- `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch/friedman_nemenyi_v2.py`

## Deliverable

Add a focused module, preferably `src/bsebench_stats/runners/friedman.py`, with
one public function such as:

```python
run_friedman_panel(rmse_matrix: np.ndarray, filter_names: Sequence[str], alpha: float = 0.05) -> dict
```

Expected output shape:

- input dimensions (`n_configs`, `n_filters`);
- filter names;
- average ranks;
- Friedman chi2 and p-value;
- Nemenyi critical difference and pairwise significance;
- Spearman correlation matrix between filter RMSE columns;
- a compact `verdict` field with no claim wording.

If the existing package style suggests a better name, follow it, but keep a
single clear public entry point.

## Tests

Add focused fast tests with synthetic matrices:

- normal 5x4 matrix produces expected dimensions and keys;
- Spearman matrix is symmetric, diagonal = 1, shape k x k;
- invalid filter-name length raises a clear `ValueError`;
- output can be JSON-serialized after converting numpy arrays/lists as needed.

## Acceptance gates

- G1: focused tests pass.
- G2: `uv run --all-extras pytest -m "not slow" --tb=short` passes.
- G3: `uv run --all-extras ruff format --check .` passes.
- G4: `uv run --all-extras ruff check .` passes.
- G5: scope stays small (target <= 200 LOC net).
- G6: commit uses GLASSBOX with `[role: worker-codex-FR]`.
- G7: no `Co-Authored-By: Claude` trailer.

## Out of scope

- No claim registry changes.
- No thesis prose edits.
- No roadmap edits.
- No plotting.
- No hidden numerical claim such as "filter X wins" unless directly in a
  neutral returned data structure.

## If blocked

Write `outbox/phase-6-11-c-stats-panel-runner/BLOCKED.md` with the exact API or
source-reference ambiguity and smallest proposed next phase.
