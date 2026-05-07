# Phase 8 Alpha Golden Submission Packet

GLASSBOX metadata:

- Artifact id: `phase8-alpha-golden-submission-packet-20260507`
- Worker: `W7-d`
- Branch: `phase-8-6-d-submission-contract-golden-examples-20260507T214305Z`
- Date: 2026-05-07
- Scope: community estimator submission examples for alpha intake.
- Non-scope: benchmark results, public rankings, scientific claims, claim
  registry edits, thesis prose, manuscript prose, and roadmap edits.

## Golden Example A: Causal Voltage Adapter

This example is acceptable for an alpha smoke check because it is executable
through the inspected per-sample estimator API and does not request hidden
evaluation information.

| Field | Value |
|---|---|
| Submission ID | `phase8_alpha_golden_causal_voltage_v1` |
| Submission type | `estimator_adapter` |
| Method family | `other` |
| Maintainer | `BSEBench alpha fixture maintainer, local-only fixture` |
| License | `MIT-compatible fixture text, pending package-level license file` |
| Code URL or archive | `examples/submissions/phase8-alpha/golden_causal_voltage_adapter.py` |
| Submission commit or artifact hash | `filled by release packager after merge` |
| BSEBench version | `filled by release packager after merge` |
| Expected entry point | `golden_causal_voltage_adapter:build_estimator` |
| Runtime environment | `Python 3.11+, standard library only` |
| Hardware used for timing claims | `n/a; no timing claim is made` |

### Adapter Contract

- Initialization hook: runner calls `build_estimator()` for a fresh instance per
  independent config, fold, or episode.
- Step hook:
  `step(t: float, voltage_V: float, current_A: float, temperature_C: float) -> dict[str, float]`.
- State reset behavior: `reset(soc_init=...)` is available, but the golden
  alpha path should prefer a fresh factory instance for each independent run.
- Output schema:
  - required: `voltage_predicted`, finite float, volts;
  - optional: `soc_estimated`, finite float in `[0, 1]`.
- Determinism policy: deterministic arithmetic; no random seed required.
- External services: none.

### Blind Evaluation Declaration

| Use | Dataset/profile/cell scope | Purpose | Tuning allowed? | Evidence path |
|---|---|---|---|---|
| Calibration | `none` | no fitted parameter | `no` | `n/a` |
| Training | `none` | no model training | `no` | `n/a` |
| Validation | `synthetic alpha smoke only` | import and step-contract check | `no` | `validation/wave-7/submission-contract-golden-examples-20260507.md` |
| Evaluation | `blind benchmark protocol selected later` | benchmark run | `no` | `pending integrated runner protocol` |

Leakage statement:

- Evaluation data used during development: `no`.
- Public benchmark labels used for tuning: `no`.
- Preprocessing fitted on evaluation data: `no`.
- Repeated submissions used to choose hyperparameters: `no`.

### Metrics Requested

- Voltage RMSE or residual metrics may be computed mechanically by the runner
  when the protocol requires `voltage_predicted`.
- SOC/SOH public metrics are not requested by this fixture. The optional
  `soc_estimated` value is included only to demonstrate that finite numeric
  scalar extras can be serialized under the candidate contract.

### Comparison Source Ledger

No comparison requested.

### Reproduction Commands

```bash
python3 -m py_compile examples/submissions/phase8-alpha/golden_causal_voltage_adapter.py
python3 examples/submissions/phase8-alpha/golden_causal_voltage_adapter.py
```

### Alpha Eligibility Notes

This packet is a golden intake example, not a release approval. A real
community submission still needs a package-specific dependency restore record,
sandbox smoke report, determinism replay report, leakage review, protocol
assignment, evidence manifest, and frozen release hash bundle before public
monthly use.

## Golden Example B: SOC/SOH Output Without Metric Claim

This example is acceptable as a manifest pattern when an estimator emits
additional state outputs but does not request unsupported public scoring.

| Field | Acceptable value |
|---|---|
| Entry point | same `step(t, voltage_V, current_A, temperature_C)` contract |
| Required output | finite numeric `voltage_predicted` |
| Optional outputs | finite numeric `soc_estimated` and/or `soh_estimated` |
| Metric request | `mechanical voltage metrics only` until a selected protocol has validated SOC/SOH labels and stats contracts |
| Comparison text | `No comparison requested`, or complete source-ledger rows before any comparison wording |

Required caveat text for this pattern:

> SOC/SOH estimates are emitted for serialization and later protocol use. They
> are not public accuracy evidence unless the selected benchmark protocol has
> validated ground-truth labels, metric definitions, and leakage gates.

## Reviewer Acceptance Checklist

- [x] Uses the inspected universal step API.
- [x] Returns finite numeric `voltage_predicted`.
- [x] Emits only scalar numeric optional outputs.
- [x] Does not read labels, metrics, hidden split metadata, prior reports, or
  future samples.
- [x] Does not make any public comparison or claim statement forbidden by the
  Wave 7 guardrails.
- [x] Declares that a real external package still needs sandbox, dependency,
  replay, leakage, protocol, and freeze artifacts before public use.
