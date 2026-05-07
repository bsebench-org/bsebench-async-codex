# Estimator Interface Compatibility Matrix

Artifact: `audits/universal/estimator-interface-compatibility-matrix-20260507T204627Z.md`
Worker: W4-14
Timestamp: 2026-05-07T20:46:27Z dispatch, inspected through 2026-05-07T21:00Z local evidence window
Scope: validation/spec artifact only; no code, thesis, manuscript, claim registry, `claim_55`, or roadmap edits.

## Objective

Build a GLASSBOX compatibility matrix for the estimator interface needed to run ECM, Kalman-filter, observer, AI, hybrid, and future methods in BSEBench without inventing unsupported scientific claims.

The audit asks one practical question: can each estimator class be mapped onto the runner interfaces visible in Phase 8 evidence, and what hooks or caveats must be present before the method is safe for monthly benchmark execution?

## Evidence Inspected

- Watchdog logs under `/home/oakir/.local/state/bsebench-async-watchdog`.
- Runner Wave 1 branches:
  - `bsebench-runner-phase-8-0-a-universal-runner-estimator-plugin-contract`
  - `bsebench-runner-phase-8-0-b-universal-runner-protocol-registry`
  - `bsebench-runner-phase-8-0-c-universal-runner-degraded-initialization`
  - `bsebench-runner-phase-8-0-d-universal-runner-leakage-split-guard`
  - `bsebench-runner-phase-8-0-e-universal-runner-compute-profiling-hooks`
  - `bsebench-runner-phase-8-0-f-universal-runner-submission-smoke`
- Canonical sibling repos read-only:
  - `/mnt/c/doctorat/bsebench-org/bsebench-runner`
  - `/mnt/c/doctorat/bsebench-org/bsebench-filters`
- Prior Wave 2/3 evidence from the API gap audit log and current Wave 4 runner deep-validation log.

## Commands

Read-only inspection commands used for this artifact:

```bash
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f | sort
git branch --all --list '*phase-8-*'
rg --files -g '*runner*' -g '*adapter*' -g '*interface*' -g '*estimator*' -g '*observer*' -g '*kalman*' -g '*ecm*' -g '*hybrid*' -g '*ai*' -g '*dataset*' -g '*stats*'
tail -n 80 /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-0-a-universal-runner-estimator-plugin-contract.log
tail -n 80 /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-0-b-universal-runner-protocol-registry.log
tail -n 80 /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-0-f-universal-runner-submission-smoke.log
sed -n '1,240p' src/bsebench_runner/estimator_contract.py
sed -n '1,280p' src/bsebench_runner/protocol_registry.py
sed -n '1,260p' src/bsebench_runner/initialization_policy.py
sed -n '1,280p' src/bsebench_runner/split_guard.py
sed -n '1,260p' src/bsebench_runner/profiling.py
sed -n '1,220p' examples/submissions/toy_external_estimator.py
sed -n '1,340p' src/bsebench_filters/base.py
sed -n '1,260p' src/bsebench_runner/orchestrator.py
sed -n '1,260p' src/bsebench_runner/residuals.py
sed -n '1,240p' src/bsebench_runner/default_registries.py
```

Status-accounting commands used:

```bash
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f \( -name 'manual-phase-8-0-*.log' -o -name 'manual-phase-8-1-*.log' -o -name 'manual-phase-8-2-*.log' \) -printf '%f\n' | sort | wc -l
rg -l "ERROR: You've hit your usage limit" /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-{0,1,2}-*.log | sort
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-3-*.log' -printf '%f\n' | sort | wc -l
git diff --check
```

## Observed Interface Surface

Current and candidate runner evidence defines this minimum execution surface:

| Surface | Evidence | Compatibility meaning |
|---|---|---|
| Factory hook | `FilterRegistry` and candidate `EstimatorAdapter.factory` | Every benchmark cell must receive a fresh estimator instance. Cross-config state must not leak unless explicitly allowed by a protocol, which is currently not allowed. |
| Per-sample step hook | `step(t, voltage_V, current_A, temperature_C)` | The runner calls estimators one sample at a time with measured voltage, current, temperature, and timestamp. |
| Required output | `voltage_predicted` finite numeric scalar | Current RMSE and residual paths require predicted terminal voltage. Additional numeric scalar outputs are accepted by the candidate contract. |
| Optional state hooks | `get_state()` and `get_innovation()` in `bsebench_filters.StateEstimator` | Existing filter implementations expose state and innovation, but the Phase 8 minimal candidate protocol only requires `step`. |
| Protocol metadata | `EstimatorAdapterSpec.estimator_family`, `output_signals`, `supports_training`, `training_data_policy`, `provenance` | Universal monthly execution needs declarative family and training policy metadata before integration. |
| Initialization policy | forced wrong initial SOC fixture and banned leaky initialization sources in protocol registry | Wrong-start/convergence protocols can be represented, but initialization must not consume future samples or ground-truth labels. |
| Split guard | calibration/evaluation config identity disjointness | Any method with calibration/training must keep calibration and evaluation configs disjoint. |
| Profiling hook | per-step wall-time and traced Python memory metadata | Compute evidence can be captured per `(filter, config)` cell, with memory caveats. |
| Submission smoke | external toy estimator imports registries and runs through `run_benchmark` | External methods can be loaded by path through registry builders, but a full submission manifest is still needed. |

## Compatibility Matrix

Legend:

- `Pass`: current or Phase 8 candidate hooks can execute the class with ordinary wrapping.
- `Conditional`: execution is plausible, but monthly/public benchmark use needs additional required metadata or guards.
- `Fail until adapted`: the method class violates a required hook unless a wrapper changes its interface or policy.

| Method class | Execution status | Required hooks | Required metadata and guards | Caveats |
|---|---:|---|---|---|
| ECM open-loop or equivalent-circuit model baseline | Pass, if wrapped as an estimator | Fresh factory; `step(t, voltage_V, current_A, temperature_C)`; finite `voltage_predicted` output; optional `soc_estimated` when model state tracks SOC | `estimator_family="ecm"` or `baseline`; ECM topology, parameter source, units, initialization policy, protocol id | A pure voltage model that has no SOC/SOH state can be scored only on voltage targets. SOC/SOH metrics require separate truth evidence and estimator outputs. |
| EKF/UKF/JUKF/AUKF/DUKF/FO-EKF family | Pass for current Audit J style filters | Fresh factory; per-sample `step`; finite `voltage_predicted`; recommended `get_state` and `get_innovation`; deterministic config construction from `FilterConfig` | `estimator_family="kalman_filter"`; process/measurement covariance source; tuning source; initialization policy; calibration/evaluation split guard | Current default registry already carries EKF, UKF_def, JUKF_V6B, AUKF_SR, DUKF, and FO_EKF wrappers. Future variants must declare whether covariance/tuning came from train split, external pretraining, or fixed source. |
| Robust filters such as H-infinity | Pass, with same streaming hook | Fresh factory; per-sample `step`; finite `voltage_predicted`; optional uncertainty/robustness diagnostics only as numeric scalars or sidecar artifacts | `estimator_family="kalman_filter"` or `other` until a robust-filter family is added; tuning/provenance ledger; compute profiling | Do not promote residual evidence to a scientific claim without a completed source ledger and claim gate. |
| Observers such as sliding-mode observers | Pass, if they expose predicted voltage | Fresh factory; per-sample `step`; finite `voltage_predicted`; state/innovation recommended for residual analysis | `estimator_family="observer"`; observer order/type; gain source; initialization policy; split guard for tuned gains | The observed `SO_SMO` wrapper fits the current StateEstimator path. Observers that output only state without voltage prediction need a measurement model adapter before runner RMSE can score them. |
| Particle filters and ensemble/meta-estimators | Pass for per-sample implementations, conditional for stochastic execution | Fresh factory; per-sample `step`; finite `voltage_predicted`; deterministic seed handling; structured failure behavior | Family should be `hybrid`, `other`, or a future `particle_filter` enum; random seed; particle/ensemble size; resampling policy; compute profiling | Current `ICRPF` and `EnsembleMeta` are registered through StateEstimator. Public comparisons need reproducible seed policy and resource metadata because runtime can scale with particles or ensemble members. |
| AI estimator trained offline | Conditional | Adapter must provide fresh inference object; per-sample `step` or an approved batch-to-step wrapper; finite `voltage_predicted`; optional `soc_estimated`/`soh_estimated` | `estimator_family="ai_estimator"`; training_data_policy; model artifact hash; dependency/runtime policy; hardware/resource expectations; source ledger; license; no test-label access | Current candidate protocol can describe `ai_estimator`, but the runner has no full submission manifest or sandboxed model artifact loader yet. Batch models must not see future evaluation samples unless the protocol explicitly defines causal batch windows. |
| AI estimator trained during benchmark | Conditional, high risk | Separate train/calibrate hook before evaluation; fresh evaluation instance; evaluation `step` must not access labels or future data | Train split id; calibration split id; split leakage report; random seed; full command/env capture; model artifact hash after training | Training inside monthly runs requires a stricter lifecycle than current `run_benchmark`, which only executes evaluation. Until that lifecycle exists, training should occur outside the evaluation runner with a manifest and ledger. |
| Hybrid physics plus AI method | Conditional | All hooks required for the physical estimator and the AI component; final per-sample `step`; finite `voltage_predicted`; optional component diagnostics | `estimator_family="hybrid"`; component list; component artifact hashes; training/tuning policy for each component; initialization and split guards | Hybrid methods are compatible only if every learned component has a ledger and every physical component has parameter provenance. A hybrid wrapper must make the visible target output unambiguous. |
| SOH-only estimator | Conditional | Per-sample or per-window adapter; must output `soh_estimated` and, for current voltage RMSE path, either also output `voltage_predicted` or run in a future SOH metric-only protocol | Ground-truth SOH evidence; target signal metadata; windowing policy; degradation-label provenance; leakage restrictions | Current runner scoring is voltage-centered. SOH-only public scoring is not ready without dataset ground-truth evidence and stats target-signal contracts. |
| Future filters or control-oriented observers | Conditional | Fresh factory; causal evaluation hook; finite declared target outputs; explicit reset/initialization behavior | Family enum or `other`; entrypoint; target signals; initialization policy; training/pretraining policy; compute and source ledger | Unknown methods should enter through the minimal adapter only after a smoke test proves no future labels, no hidden cross-config state, and serializable numeric outputs. |
| Any method that uses evaluation labels, future samples, or cross-config state | Fail until adapted | Must remove label/future-sample dependency and enforce fresh per-config state | Must pass split guard and source-ledger review | This violates benchmark leakage safety. It should not produce public monthly benchmark results. |
| Any method that returns non-finite, nested, string, boolean, or missing `voltage_predicted` output | Fail until adapted | Must return finite numeric scalar `voltage_predicted` for current runner metrics | Output schema must be validated before benchmark execution | Candidate `validate_estimator_step_output` rejects non-finite and nonnumeric scalar outputs. Nested diagnostics should go to a sidecar schema, not the step result. |

## Findings

1. **Minimum universal execution hook is viable.** The Phase 8 estimator contract is intentionally small enough for ECM, Kalman filters, observers, particle filters, AI inference wrappers, and hybrid methods to adapt through a fresh factory plus causal per-sample `step`.

2. **Voltage prediction is the current scoring anchor.** Existing runner code computes RMSE from `voltage_predicted` against measured voltage. SOC/SOH outputs may be carried, but SOC/SOH metric compatibility requires ground-truth evidence, target-signal metadata, and stats contracts before public scoring.

3. **Training and pretraining are not yet a first-class execution phase.** The protocol registry candidate can describe `supports_training` and `training_data_policy`, but the runner execution path inspected here evaluates registered factories directly. AI and hybrid methods that train must have a separate train/calibrate lifecycle before monthly benchmark use.

4. **Initialization is partly covered but should become explicit in every protocol.** Current legacy filters can initialize from first voltage unless `soc_init` is injected. The wrong-initial-SOC fixture and banned leaky sources are useful, but monthly protocols should require an initialization policy id for every estimator family.

5. **Failure semantics need one consistent artifact schema.** The main orchestrator converts failed cells to a divergence sentinel; residual helpers produce structured `status="error"` payloads. Universal results should prefer structured cell status plus optional sentinel values so stats does not silently confuse divergence, loader failure, and schema failure.

6. **AI/hybrid submissions need a manifest before public intake.** The toy external submission proves registry-based import can work, but production intake still needs estimator id, version, entrypoint, dependency policy, artifact hashes, license, supported target signals, resource expectations, and source ledger bindings.

7. **Compute profiling is compatible but not sufficient alone.** The candidate profiling hook records wall time and traced Python memory, which is useful for reproducibility. Public compute comparisons also need hardware label, Python/platform details, dependency lock, sample count, and measurement-source caveats.

## Recommendations

1. Make the compatibility gate require these common fields for every estimator adapter:
   - `adapter_id`
   - `estimator_family`
   - `entrypoint`
   - `contract_version`
   - `output_signals`
   - `supports_training`
   - `training_data_policy`
   - `initialization_policy_id`
   - `source_ledger_id`
   - `compute_profile_policy`

2. Keep the minimal causal step contract for universal interoperability:

```python
step(t: float, voltage_V: float, current_A: float, temperature_C: float) -> Mapping[str, float]
```

Require `voltage_predicted` for current voltage RMSE protocols. Require `soc_estimated` and/or `soh_estimated` only when the selected protocol contains validated SOC/SOH metrics and ground-truth evidence.

3. Add a future `EstimatorBatchProtocol` only if needed, and mark it non-causal by default unless it declares a legal causal window. Do not let batch AI methods inspect future evaluation samples under the streaming protocol.

4. Merge structured failure status from residual traces into the primary runner artifact schema:
   - `ok`
   - `estimator_error`
   - `loader_error`
   - `schema_error`
   - `leakage_guard_error`
   - `resource_limit_error`

5. Treat source-ledger, split-guard, and artifact-manifest checks as blockers for public monthly reports, not as optional documentation.

## Pass/Fail Result

Conditional pass.

The current and Phase 8 candidate interfaces are broad enough to host all requested method classes through adapters. They are not yet sufficient to claim universal public benchmark readiness because AI/hybrid training lifecycle, SOC/SOH ground-truth linkage, submission manifests, structured failure status, and source-ledger gates still need integration before monthly benchmark outputs can be treated as public evidence.

## Residual Risks

- The Phase 8 runner branches inspected here are candidate worktrees and logs, not necessarily merged target `main` state.
- The compatibility matrix is interface-level only. It does not validate numerical correctness, convergence, rank stability, or real-dataset performance for any estimator.
- The broad Phase 8 environment is moving concurrently. I observed 48 prior Wave 1-3 logs and 24 Wave 4 logs; not every Wave 4 branch was complete at this evidence window.
- Three prior Wave 3 logs hit a usage limit: `phase-8-2-j`, `phase-8-2-k`, and `phase-8-2-l`. Wave 4 retry/deep-validation logs exist for follow-up accounting, but this artifact does not certify those retry artifacts as merged.
- AI and hybrid methods can hide training-data or dependency leakage in external artifacts unless manifest hashes, source ledgers, and sandbox policies are enforced.
- SOH-only compatibility remains blocked on ground-truth and target-signal metric contracts, not on the estimator step hook alone.

## Explicit Non-Claims

- This artifact makes no SOTA, novelty, leaderboard, breakthrough, or verified scientific claim.
- This artifact does not claim any estimator class is empirically better than another.
- This artifact does not claim SOC/SOH public scoring is ready today.
- This artifact does not modify or validate `claim_55`, any claim registry entry, thesis prose, manuscript prose, or the scientific roadmap.
- This artifact does not certify that Phase 8 worker branches are merged; it only records the interface evidence inspected for this scoped compatibility matrix.

## Validation Record

- Inspected runner adapter/interface outputs: completed by reading the estimator contract, protocol registry candidate, initialization policy candidate, split guard candidate, profiling candidate, submission smoke fixture, canonical runner orchestrator/residual paths, and canonical filter base/default registry.
- Mapped method classes to required hooks and caveats: completed in the compatibility matrix above.
- Prior log accounting: observed 48 Wave 1-3 Phase 8 logs and three usage-limit Wave 3 logs (`8-2-j`, `8-2-k`, `8-2-l`); observed 24 Wave 4 logs at inspection time.
- `git diff --check` and `git diff --cached --check`: passed after whitespace fix with no whitespace errors.
