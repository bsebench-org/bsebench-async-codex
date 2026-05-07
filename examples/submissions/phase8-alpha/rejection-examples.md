# Phase 8 Alpha Submission Rejection Examples

GLASSBOX metadata:

- Artifact id: `phase8-alpha-submission-rejection-examples-20260507`
- Worker: `W7-d`
- Branch: `phase-8-6-d-submission-contract-golden-examples-20260507T214305Z`
- Date: 2026-05-07
- Scope: concrete rejection patterns for community estimator submission intake.
- Non-scope: scientific evaluation of any real method.

These examples are fail-closed patterns for alpha intake. They are deliberately
mechanical: rejection means the package cannot enter blind benchmark execution
until fixed or explicitly marked non-comparable.

## Reject R-001: Missing Or Invalid Step Output

Rejected submission pattern:

```python
def step(t, voltage_V, current_A, temperature_C):
    return {"soc_estimated": 0.5}
```

Why it fails:

- The inspected candidate runner contract requires finite numeric
  `voltage_predicted` for current voltage metric paths.
- Missing, non-finite, boolean, string, nested, or object outputs cannot be
  aggregated reliably.

Required fix:

- Return `{"voltage_predicted": <finite float>}` and keep optional diagnostics
  as finite numeric scalar fields or sidecar artifacts.

## Reject R-002: Hidden Label File Read

Rejected submission pattern:

```python
def step(t, voltage_V, current_A, temperature_C):
    labels = open("labels.csv", encoding="utf-8").read().splitlines()
    return {"voltage_predicted": float(labels[int(t)])}
```

Why it fails:

- Blind evaluation keeps ground-truth SOC/SOH labels inside the harness.
- Label reads violate the anti-leakage boundary and match the adversarial label
  denial gate.

Required fix:

- Use only public observations and declared calibration artifacts. Labels,
  metric outputs, hidden split manifests, and prior reports must remain
  submission-invisible during inference.

## Reject R-003: Future-Sample Or Whole-Episode Lookahead

Rejected submission pattern:

```python
class LookaheadEstimator:
    def __init__(self, evaluation_trace):
        self.future_voltage = evaluation_trace["V"]

    def step(self, t, voltage_V, current_A, temperature_C):
        return {"voltage_predicted": float(self.future_voltage[int(t) + 1])}
```

Why it fails:

- The alpha step API is causal and per-sample.
- Batch methods must not inspect future evaluation samples unless a future
  protocol explicitly defines a legal causal window.

Required fix:

- Compute each output from current and past public observations, current
  estimator state, and declared calibration artifacts only.

## Reject R-004: Cross-Fold Global Cache

Rejected submission pattern:

```python
GLOBAL_LAST_SOC = 0.9

class CachedEstimator:
    def step(self, t, voltage_V, current_A, temperature_C):
        return {"voltage_predicted": voltage_V, "soc_estimated": GLOBAL_LAST_SOC}
```

Why it fails:

- Fresh benchmark episodes, cells, profiles, and folds must not inherit hidden
  state from earlier evaluation episodes.
- This fails cross-fold order invariance and episode boundary reset gates.

Required fix:

- Use a fresh factory instance or a real reset hook that clears all run-specific
  state before each independent episode.

## Reject R-005: Evaluation-Tuned Hyperparameters

Rejected submission pattern:

```text
We ran the hidden evaluation split many times and chose covariance Q/R from the
best observed benchmark score.
```

Why it fails:

- Repeated blind submissions used for hyperparameter choice are evaluation
  leakage.
- Calibration, training, validation, and blind evaluation must be separated and
  declared.

Required fix:

- Freeze hyperparameters before blind evaluation and identify calibration,
  training, and validation evidence separately from evaluation.

## Reject R-006: Network Or Dynamic Dependency During Evaluation

Rejected submission pattern:

```python
def step(t, voltage_V, current_A, temperature_C):
    import urllib.request

    model = urllib.request.urlopen("https://example.invalid/model.bin").read()
    return {"voltage_predicted": voltage_V + len(model) * 0.0}
```

Why it fails:

- Import, calibration, and blind evaluation must complete without network
  access after dependency restoration.
- Dynamic downloads make results non-reproducible and can leak benchmark
  identity.

Required fix:

- Provide immutable model artifacts, dependency locks, hashes, and an offline
  restore path before benchmark execution.

## Reject R-007: Unsupported Comparison Or Claim Language

Rejected submission pattern:

```text
<forbidden public-comparison or benchmark-proof claim text>
```

Why it fails:

- Alpha intake examples cannot include public comparison or benchmark-proof
  claim language forbidden by the Wave 7 guardrails.
- Any comparison needs complete source-ledger rows with DOI or stable URL,
  retrieval date, exact metric, dataset, split, BSEBench frozen value,
  comparability, and caveat.

Required fix:

- Remove the claim language or attach a complete, reviewer-accepted source
  ledger and keep text descriptive with explicit caveats.

## Reject R-008: SOC/SOH-Only Output For Voltage Protocol

Rejected submission pattern:

```python
def step(t, voltage_V, current_A, temperature_C):
    return {"soc_estimated": 0.51, "soh_estimated": 0.98}
```

Why it fails:

- The inspected current runner scoring anchor is `voltage_predicted`.
- SOC/SOH-only scoring remains conditional on validated labels and stats target
  contracts for the selected protocol.

Required fix:

- Either add finite numeric `voltage_predicted` for the current voltage protocol
  or wait for a future SOC/SOH-only protocol with validated ground-truth and
  metric contracts.

## Minimal Rejection Decision Table

| Rejection id | Gate family | Alpha decision |
|---|---|---|
| `R-001` | output schema | reject until contract-compliant |
| `R-002` | label leakage | reject and mark non-blind |
| `R-003` | future-sample leakage | reject until causal or approved protocol exists |
| `R-004` | state leakage | reject until reset/fresh-factory replay passes |
| `R-005` | split leakage | reject until tuning provenance is separated |
| `R-006` | dependency/runtime | reject until offline reproducibility exists |
| `R-007` | public claim language | reject until removed or source-ledger complete |
| `R-008` | protocol mismatch | reject for current voltage protocol |
