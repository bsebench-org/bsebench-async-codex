# BSEBench Universal Parallel Wave

Saved: 2026-05-07. Role: codex-cto-FR.

## Purpose

Accelerate the Phase 7 to Phase 17 research roadmap toward the clarified
product objective: BSEBench as a universal SOC/SOH benchmark standard.

The wave is intentionally parallel. Tasks are grouped by repository and write
set so workers can run concurrently without blocking each other.

## Global Guardrails

- No thesis, manuscript, claim registry, `claims/registry.yaml`, `claim_55`, or
  scientific roadmap edits.
- No unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim
  statements.
- Every worker must preserve BSEBench universal benchmark direction:
  plug-and-play estimators, exhaustive metrics, ETL harmonization,
  anti-leakage, degraded initialization, provenance, and monthly community
  benchmark readiness.
- Every accepted worker output must include focused validation, `git diff
  --check`, GLASSBOX commit metadata, and no `Co-Authored-By Claude`.

## Wave 1 Tasks

### Runner

1. `universal-runner-estimator-plugin-contract`
   Define a minimal estimator adapter contract and smoke tests.

2. `universal-runner-protocol-registry`
   Add a protocol registry skeleton separating datasets, estimator adapters,
   initialization policy, and metrics.

3. `universal-runner-degraded-initialization`
   Add forced wrong-initial-SOC protocol fixtures.

4. `universal-runner-leakage-split-guard`
   Add calibration/evaluation split guard fixtures.

5. `universal-runner-compute-profiling-hooks`
   Add timing/memory metadata hooks around estimator stepping.

6. `universal-runner-submission-smoke`
   Add a toy external estimator submission smoke path.

### Stats

7. `universal-stats-metric-matrix`
   Formalize RMSE, MAE, MAXE, and per-cell/profile aggregation schema.

8. `universal-stats-convergence-metrics`
   Add convergence/recovery metrics for degraded initialization protocols.

9. `universal-stats-robustness-noise-schema`
   Add mechanical schema for Gaussian/non-Gaussian noise robustness reports.

10. `universal-stats-compute-cost-aggregator`
    Add aggregation helpers for runtime, memory, and hardware-independent cost
    metadata.

11. `universal-stats-multi-axis-ranking`
    Add non-SOTA multi-axis ranking/report schema with caveats.

12. `universal-stats-cross-domain-transfer-matrix`
    Add transfer-matrix metric helpers for chemistry/profile/domain transfer.

### Datasets

13. `universal-datasets-etl-contract`
    Define harmonized `V`, `I`, `T`, `dt`, SOC/SOH field contract.

14. `universal-datasets-ground-truth-audit`
    Add ground-truth metadata audit for coulomb counting and OCV recalibration
    evidence.

15. `universal-datasets-split-metadata`
    Add split/calibration/evaluation metadata contract and tests.

16. `universal-datasets-card-schema`
    Add dataset card schema for chemistry, profile, temperature, aging/SOH, and
    equipment provenance.

17. `universal-datasets-equipment-registry`
    Add raw equipment registry skeleton for Arbin/Maccor and unknown vendors.

18. `universal-datasets-monthly-availability`
    Add read-only dataset availability snapshot schema for public benchmark
    reports.

### Async / Public Benchmark Operations

19. `universal-async-submission-template`
    Add contributor submission template and validation checklist.

20. `universal-async-monthly-snapshot-schema`
    Add monthly benchmark snapshot schema and required caveat fields.

21. `universal-async-charter-gate`
    Add a lightweight check that new BRIEFs state how they improve universal
    benchmark value.

22. `universal-async-disjoint-wave-planner`
    Add a write-set/disjointness planning helper for high-parallel worker waves.

23. `universal-async-public-release-checklist`
    Add public benchmark release checklist with anti-leakage and source-ledger
    gates.

24. `universal-async-no-idle-capacity-policy`
    Add operator policy for scaling useful workers while avoiding duplicate or
    conflicting work.

## Scaling Rule

After this wave starts, the next wave should be created from remaining
independent axes, not by duplicating work:

- Phase 8 cross-chemistry candidate manifests;
- Phase 9 profile-axis stress protocol readiness;
- Phase 10 aging/SOH metadata readiness;
- Phase 11 residual decomposition execution and validation;
- Phase 12 transfer matrix execution;
- Phase 13 to 15 estimator families and adaptive methods.

The CTO should increase worker count only when each new worker has a distinct
write set, a falsification gate, and a useful path toward the universal
benchmark standard.
