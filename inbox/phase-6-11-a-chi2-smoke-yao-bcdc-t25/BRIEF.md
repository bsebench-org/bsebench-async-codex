---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-6-11-a-chi2-smoke-yao-bcdc-t25
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-filters
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 60
---

# Phase 6.11.a — chi² smoke test on Yao BCDC T25

## Mission

Premier test bout-en-bout du runner avec **un seul cfg** : Yao BCDC T25. Goal : produire chi² number reproducible. Pas de full sweep (defer 6.11.b/c). Si chi² number sortit avec succès → infrastructure validation OK ; on attaque 6.11.b multi-cfg sweep ensuite.

## Pre-flight

1. **Source-of-truth** : paper2b chi² calculation logic dans `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch/`. Cherche `chi2`, `compute_metrics`, `phase_J_audit_friedman_retune.py`. Reference value : 157.636.
2. **Reading** : bsebench-runner `src/bsebench_runner/orchestrator.py` end-to-end. Comprendre comment runner orchestrates loaders × filters → RMSE/chi².
3. **Bsebench-datasets** : YaoTuBerlin2024Loader is ready (`bsebench-datasets@5792706`). Use wrapper="yao", profile="BCDC", T_C=25.
4. **Filters** : utilise EnsembleMeta + EKF (les 2 plus stables) pour smoke. Pas tous les 10 filtres.
5. NO Co-Authored-By Claude. GLASSBOX format.

## Deliverable

### `bsebench-runner/scripts/chi2_smoke_yao_bcdc_t25.py`

Script standalone qui :
1. Charge YaoTuBerlin2024Loader avec profile=BCDC, T_C=25 (utilise local_cache_root pour test data)
2. Initialize EnsembleMeta + EKF with paper2b cell_params
3. Run filter on 1 cfg → V_pred trace
4. Compute chi² = sum((V_pred - V_meas)² / sigma²) sur la fenêtre de validation
5. Print chi² value + degrees of freedom + p-value
6. Sauve résultat dans `outputs/chi2_smoke_yao_bcdc_t25.json` (committed)

### `tests/test_chi2_smoke_yao_bcdc_t25.py`

1 fast test : import the script + assert it has the expected functions/structure (no actual run).

1 slow test : run the script end-to-end on synthetic / mocked data → chi² value computed without error. Optional skip if data missing.

## Acceptance gates

- G1 : `uv run pytest tests/test_chi2_smoke_yao_bcdc_t25.py -v` → fast tests pass
- G2-G3 : ruff format + check
- G4 : git status clean, scope ≤ 3 files (script + test + outputs/)
- G5 : commit body documents chi² value computed AND comparison to paper2b 157.636 if applicable
- G6 : NO Co-Authored-By Claude

## Cross-refs

- bsebench-datasets@5792706 (Yao loader)
- paper2b chi² ref : 157.636 from prove_all.py
