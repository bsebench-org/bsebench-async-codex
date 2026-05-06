---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-6-11-b-chi2-multi-cfg-sweep
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 60
---

# Phase 6.11.b — chi² sweep multi-cfg (5 cfgs × 5 filters)

## Mission

Étendre 6.11.a (1 cfg smoke) en sweep sur 5 configs × 5 filtres = 25 cellules de matrice RMSE/chi². Petit subset for fast iteration. Cibles : Yao BCDC T25, Yao US06 T25, Panasonic US06 T25, NASA B0005 T24, CALCE A123 DST T25.

## Pre-flight

1. Read `scripts/chi2_smoke_yao_bcdc_t25.py` (shipped 6.11.a, commit 76cb42a) for single-cfg pattern.
2. 5 filters : EnsembleMeta, EKF, UKFDef, JUKFV6B, Hinf (pick subset of 10).
3. Output : `outputs/chi2_sweep_5x5.json` with matrix + per-cell chi² + p-values.

## Deliverable

### `scripts/chi2_sweep_5x5.py`

Loop over 5 (loader, profile, T) cfgs × 5 filters → compute chi² each. Save JSON. Print summary table.

### `tests/test_chi2_sweep_5x5.py`

1-2 fast tests : import works, structure expected, mock data run produces non-empty matrix.

## Acceptance gates

- G1 : ≥ 2 fast tests pass
- G2-G3 : ruff
- G4 : scope ≤ 3 files
- G5-G6 : GLASSBOX, no Claude trailer

## Cross-refs

- 6.11.a (`76cb42a`) precedent
