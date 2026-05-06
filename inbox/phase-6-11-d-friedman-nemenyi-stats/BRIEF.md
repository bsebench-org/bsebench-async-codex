---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-6-11-d-friedman-nemenyi
base_branch: main
add_dir:
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 30
---

# Phase 6.11.d — Friedman + Nemenyi statistical test

## Mission

Implémenter Friedman test + Nemenyi post-hoc dans `bsebench-stats`. Demšar 2006 reference. Input : RMSE matrix [n_configs × n_filters]. Output : Friedman p-value + Nemenyi pairwise critical difference + ranking.

## Pre-flight

1. Read existing `bsebench-stats/src/` end-to-end (probably small lib).
2. Source-of-truth : Demšar 2006 "Statistical Comparisons of Classifiers over Multiple Data Sets". Also paper2b reference dans `these_lfp_2026/ecm_fidelity_lfp/autoresearch/phase_J_audit_friedman_retune.py`.
3. NO Co-Authored-By Claude. GLASSBOX.

## Deliverable

### `src/bsebench_stats/friedman_nemenyi.py`

- `friedman_test(rmse_matrix: np.ndarray) -> dict` : returns {chi2, p_value, ranks, n_configs, n_filters}
- `nemenyi_test(ranks: np.ndarray, n_configs: int, alpha: float = 0.05) -> dict` : returns {critical_difference, pairwise_significance_matrix}
- Use scipy.stats.friedmanchisquare + scipy.stats.studentized_range

### `tests/test_friedman_nemenyi.py`

≥ 5 fast tests : sanity check on 3×3 / 5×4 synthetic matrices, edge cases (all equal → p≈1, clearly distinct → p<0.001).

## Acceptance gates

- G1 : ≥ 5 fast tests pass
- G2-G3 : ruff
- G4 : scope ≤ 2-3 files
- G5-G6 : GLASSBOX, no Claude trailer

## Cross-refs

- Demšar 2006 [DOI](https://doi.org/10.5555/1248547.1248548)
- paper2b phase_J_audit_friedman_retune.py
