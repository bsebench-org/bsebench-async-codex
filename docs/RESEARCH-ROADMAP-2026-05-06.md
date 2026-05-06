# RESEARCH ROADMAP — purely scientific (Phase 7 → 17)

> **Saved at user request 2026-05-06 ~19:00 UTC.** User mandate : "oublié les paper, et la manuscrite, defense, etc.. on se concentre sur le travaille [...] roadmap de découverte et innovation". Papers / thesis manuscript / defense are NOT objectives. They are downstream artifacts produced when the committee says "go to publish". This document is the research roadmap.

## Objective

Become an expert + contribute to the field of battery state estimation. Specifically :
1. Verify rigorously the existing claims (claim_55, _57, _59, _60, etc.).
2. Discover new properties of ECM / Joint UKF / ensemble methods.
3. Innovate on methodology where the empirical pushes us toward novelty.

## State of the field (as of 2026-05-06)

**Established in this PhD** :
- BSEBench infrastructure (Tier 1 + Tier 2 loaders for 5+ datasets, chi² baseline 157.636).
- claim_59 : BMA ceiling near-optimality (status proposed).
- claim_60 : Yao TU Berlin profile-axis stress (status proposed).
- claim_55 : H∞ filter outlier (proposed).
- claim_57 : R0 measurement biased (retracted).

**Open questions in the field** :
1. Is the BMA ceiling reachable theoretically (PCRLB-tight) or only empirical ?
2. Cross-chemistry : does the ceiling hold on NMC, NCA, Si-C, as well as LFP ?
3. Aging : do filters gracefully degrade on aged cells, or must they be re-tuned ?
4. Sensor-noise vs model-mismatch : what fraction of residual is irreducible ?
5. Profile axis : DST vs WLTC vs OCV-pulse, does the ceiling shift ?
6. Why does H∞ behave differently from L2 filters ? Underlying theory ?
7. Cross-chemistry transfer : tune on chemistry A, test on B, what fraction of skill transfers ?

---

## Research phases (each = 1 scientific question + 1 empirical answer)

### Phase 6 — BSEBench infrastructure (current)
- **Question** : can we build a reproducible platform that allows rigorous testing of any ECM / filter hypothesis ?
- **Discovery test** : chi²=157.636 reproducible cross-machine ?
- **State** : 6.10.a-c shipped. 6.10.d running. 6.10.e queued.

### Phase 7 — claim_55 verification (H∞ outlier)
- **Question** : why is H∞ uncorrelated with the rest of the ensemble ? Tuning artifact or structural ?
- **Hypotheses** :
  - H1 : H∞ optimizes a different norm (worst-case vs L2) → low correlation with MMSE filters.
  - H2 : H∞ has a different hyperparameter dependence → outlier by instability.
  - H3 : H∞ exploits an information that other filters ignore (robustness in exchange for bias).
- **Output** : claim_55 verified OR retracted with mechanism explained.
- **Tools** : bsebench-stats (Friedman + Spearman correlation), variance decomposition.
- **Innovation potential** : if H1, novelty for ensemble combination (heterogeneity bonus).

### Phase 8 — claim_59 verification + cross-chemistry extension
- **Question** : does BMA approach the PCRLB / sensor-noise floor ? On how many cfgs ? With what margin ?
- **Hypotheses** :
  - H1 : ceiling holds on LFP A123 (partially verified).
  - H2 : ceiling holds on NMC (LG HG2 = Si-C stress test).
  - H3 : if ceiling breaks, only because of model mismatch (Si-C hysteresis).
- **Discovery test** : MAD / PCRLB ratio per cfg → distribution. If median ≤ 1.05, ceiling holds.
- **Output** : claim_59 verified with cross-chemistry extension, OR scoped to its valid domain.
- **Innovation potential** : analytical derivation of ceiling under Gaussian + linear conditions = Q1 contribution.

### Phase 9 — Profile-axis stress (claim_60)
- **Question** : is the ceiling invariant to dynamic profile type (DST, FUDS, US06, WLTC, BCDC, OCV-pulse) ?
- **Hypotheses** :
  - H1 : ceiling holds across all dynamic profiles.
  - H2 : ceiling breaks on profiles with high OCV transitions (slow dynamics).
  - H3 : ceiling depends on excitation richness (Fisher info matrix property).
- **Output** : claim_60 verified OR scoped.
- **Innovation potential** : if H3, derive optimal profile design for identifiability (active learning / experimental design).

### Phase 10 — Aging invariance
- **Question** : does the ceiling hold on aged cells (SoH < 80 %) ?
- **Data** : NASA B0039 family (EOL), Severson cycled cells, LG HG2 aged.
- **Hypotheses** :
  - H1 : ceiling is universal (independent of SoH).
  - H2 : ceiling degrades with SoH (parameters drift).
  - H3 : ceiling holds but at higher level (sensor-noise floor elevated on aged cells).
- **Output** : new understanding of aging × estimation skill coupling.
- **Innovation potential** : if H3, predict ceiling from SoH (empirical law).

### Phase 11 — Sensor-noise vs model-mismatch decomposition
- **Question** : of the residual V_pred − V_meas, what fraction is sensor noise (irreducible) vs model mismatch (reducible) ?
- **Method** : MAD-based PCRLB analysis vs ECM order ablation.
- **Output** : per-dataset, fraction (sensor / model / numerical) of the residual.
- **Innovation potential** : novel benchmark metric for battery models. Strong methodological contribution.

### Phase 12 — Cross-chemistry transfer
- **Question** : if we tune on LFP, what fraction of the skill transfers to NMC / NCA / Si-C ?
- **Method** : tune cell_params on chemistry A, evaluate on chemistry B, measure RMSE inflation.
- **Output** : transfer coefficient matrix chemistry × chemistry.
- **Innovation potential** : if high transfer, ECM model universality. If low, quantification of necessary chemistry-specific tuning.

### Phase 13 — Beyond BMA : new ensemble methods
- **Question** : can we do better than BMA ? Hierarchical priors, Bayesian Model Combination, time-varying weights ?
- **Method** : implement 3-5 ensemble methods, benchmark via BSEBench.
- **Output** : ranking of ensemble methods per dataset.
- **Innovation potential** : new method superior → distinct claim, strong contribution.

### Phase 14 — Information-theoretic bounds
- **Question** : can we DERIVE a lower bound CRLB for state estimation with model uncertainty ?
- **Method** : extension Tichavsky 1998 PCRLB to model-uncertainty case (Bayesian PCRLB).
- **Output** : analytic bound, tight vs empirical observations.
- **Innovation potential** : strong theoretical contribution. Likely the most defensible Q1 claim.

### Phase 15 — Adaptive filter learning
- **Question** : can a filter learn online to compensate for chemistry-specific model bias ?
- **Method** : EMA bias correction (already partially tested) + extension by neural network for residual prediction.
- **Output** : RMSE gain measurement per adaptation.
- **Innovation potential** : if gain > 20 %, strong contribution. If marginal, confirms near-optimality of non-adaptive.

### Phase 16 — Reviewer-challenge adversarial validation
- **Meta-question** : which claims hold against simulated hostile Q1 reviewer ?
- **Method** : skill `reviewer-challenge` on each claim with 3 personas (ML/Stats, Battery, Q1 reviewer).
- **Output** : robust claims vs fragile claims.
- **No innovation** — consolidation phase.

### Phase 17 — Meta-analysis + perspective
- **Question** : what have we learned in total ? What remains open ?
- **Output** : 1 master document (internal, not paper) synthesizing.

---

## Decision gates (purely scientific)

At each phase close :
1. **Discovery ?** Yes → register claim with evidence_urls. No → register negative result.
2. **Pivot ?** If phase X fails interestingly, may suggest unforeseen new question. Adapt.
3. **Bottleneck ?** If phase X reveals missing dataset/tool, create mini-phase to add to BSEBench.

---

## Parallel artifacts (for future use, NOT objectives)

At each phase, generate :
- **Figures** : F-N plots, RMSE distributions, transfer matrices → archived in `figures/<phase>/`
- **Data tables** : per-cfg metrics → archived in `data/<phase>/`
- **Prose snippets** : 200-500 words of factual observation per phase, neutral tone → archived in `prose/<phase>.md`
- **Reproducibility bundle** : prove_all.py extended → ensures every claim re-derivable.

When the thesis committee says "publish", we'll have all ingredients ready in 1-2 days. But this is a side-effect, not a goal.

---

## What this is NOT

- ❌ Paper drafts as deliverables (no phase produces a paper)
- ❌ Thesis manuscript chapters as deliverables (no phase writes the thesis)
- ❌ Conference deadlines as gates (committee dictates timing)
- ❌ Reviewer feedback as bottleneck (we self-reviewer-challenge instead)

---

## Scope-bound : what we don't research

This roadmap focuses on **the existing battery state estimation problem space** that the user is already inside. We do NOT :
- Open new application domains (medical, finance, etc.).
- Switch chemistry families completely (no Na-ion, solid-state, post-Li).
- Move from cell-level to pack-level estimation.
- Pivot to RL-based filters (out of scope for this thesis).

If a phase organically reveals interesting frontier (e.g., adaptive transfer learning leads to RL for online tuning), we capture as `claim_NN status proposed for future work` but do NOT pursue.

---

## Cross-references

- `claims/registry.yaml` (in these_lfp_2026 repo) — registered claims
- `MASTER_DISCOVERIES_MAP.md` (in these_lfp_2026) — historical discoveries
- `INCIDENTS.md` (in these_lfp_2026) — what we've already learned the hard way
- `docs/AI-RISKS-2026-05-06.md` (this repo) — risks of AI-driven research methodology
- `HISTORY.md` (this repo) — narrative ledger of all events
- `decisions/` (in these_lfp_2026) — ADRs for major decisions

---

## Followup

User scheduled cron-cloud routine for hourly polling, 15-min ScheduleWakeup for tighter chef-side audit. Multi-worker parallelization activated 2026-05-06 for zero-correlation phases (6.10.e + 6.10.f as first parallel pair). User upgraded to Codex Max Pro High ($1000/month, unlimited tokens) to maximize parallel execution.

**Next session pickup point** : when Phase 6 chi² validation done, attack Phase 11 (sensor-noise decomposition) as first real scientific phase — accessible via existing BSEBench infrastructure, output measurable, may reveal surprises.
