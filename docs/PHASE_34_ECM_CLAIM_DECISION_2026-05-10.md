# Phase 34 ECM Claim Decision

Date: 2026-05-10
Status: CLOSED / DECISION
Runner commit: `e43abf0`
Claim status: `NO_CLAIM`

## Objective

Decide the claim-eligible path for the physics/ECM family after Phase 32 showed raw `EKF` contract failures on real loaded configurations and Phase 33 showed that `EKF_projected` can execute diagnostically.

## Definition Of Done

- Test whether a different existing ECM-family method can replace raw `EKF` without projection.
- Preserve raw failure evidence.
- Avoid silent changes to the frozen Phase 23 / Phase 25 method panel.
- Record a decision that can drive a formal amendment in the next phase.
- Do not compute or claim BSE-Score.

## Probes Executed

All probes used the Phase 32 local Tier 2 overlays:

```text
BSEBENCH_CALCE_A123_DYN_CACHE_ROOT=.phase9-local-cache/calce_a123_dyn_20260509
BSEBENCH_CALCE_INR_DYN_CACHE_ROOT=.phase9-local-cache/calce_inr_dyn_20260509
BSEBENCH_PANASONIC_CACHE_ROOT=.phase32-local-cache/panasonic_tier2_20260510
BSEBENCH_LG_HG2_CACHE_ROOT=.phase32-local-cache/lg_hg2_tier2_20260510
BSEBENCH_YAO_CACHE_ROOT=.phase32-local-cache/yao_tier2_20260510
```

Config order:

```text
calce_legacy-DST-T25
calce_a123_dyn-DST-T20
panasonic-US06-T10
nasa-CC-discharge-T24
lg_hg2-WLTC_P066-T25
yao-BCDC-T35
calce_inr_dyn-DST-T25
```

## Probe A: UKF_def Replacement Candidate

Filters:

```text
UKF_def, GRU_light, SO_SMO
```

RMSE matrix, mV:

```text
UKF_def:   [10000.0, 0.00922533330123149, 10000.0, 10000.0, 10000.0, 10000.0, 10000.0]
GRU_light: [10000.0, 115.59096906266561, 627.7498102299072, 352.93535389122957, 77.19048959702502, 590.7083721695728, 492.1392516534149]
SO_SMO:    [10000.0, 3.556254073446374, 705.8640160874662, 854.5809320805795, 227.99029884235424, 677.3723961948413, 239.60050619545945]
```

Failure summary:

```text
UKF_def loader_failed RepositoryNotFoundError count=1
UKF_def filter_failed ValueError count=5
GRU_light loader_failed RepositoryNotFoundError count=1
SO_SMO loader_failed RepositoryNotFoundError count=1
```

Interpretation: `UKF_def` is not a clean replacement for raw `EKF`. It has the same `soc_estimated must be bounded in [0, 1]` contract failure pattern on the loadable real configs.

## Probe B: Default Registry Scan

Filters:

```text
Hinf, EKF, AUKF_SR, DUKF, FO_EKF, ICRPF, SO_SMO, UKF_def, EnsembleMeta, JUKF_V6B
```

Sentinel counts:

```text
Hinf         6/7
EKF          6/7
AUKF_SR      6/7
DUKF         7/7
FO_EKF       6/7
ICRPF        7/7
SO_SMO       1/7
UKF_def      6/7
EnsembleMeta 6/7
JUKF_V6B     6/7
```

RMSE matrix, mV:

```text
Hinf:         [10000.0, 0.07961208785687618, 10000.0, 10000.0, 10000.0, 10000.0, 10000.0]
EKF:          [10000.0, 0.01098986948904848, 10000.0, 10000.0, 10000.0, 10000.0, 10000.0]
AUKF_SR:      [10000.0, 2.617376141315795, 10000.0, 10000.0, 10000.0, 10000.0, 10000.0]
DUKF:         [10000.0, 10000.0, 10000.0, 10000.0, 10000.0, 10000.0, 10000.0]
FO_EKF:       [10000.0, 0.00947939012927659, 10000.0, 10000.0, 10000.0, 10000.0, 10000.0]
ICRPF:        [10000.0, 10000.0, 10000.0, 10000.0, 10000.0, 10000.0, 10000.0]
SO_SMO:       [10000.0, 3.556254073446374, 705.8640160874662, 854.5809320805795, 227.99029884235424, 677.3723961948413, 239.60050619545945]
UKF_def:      [10000.0, 0.00922533330123149, 10000.0, 10000.0, 10000.0, 10000.0, 10000.0]
EnsembleMeta: [10000.0, 0.12610449890707157, 10000.0, 10000.0, 10000.0, 10000.0, 10000.0]
JUKF_V6B:     [10000.0, 0.3044585433916192, 10000.0, 10000.0, 10000.0, 10000.0, 10000.0]
```

Failure summary:

```text
Each registry filter has 1 calce_legacy loader failure.
Hinf, EKF, AUKF_SR, FO_EKF, UKF_def, EnsembleMeta, JUKF_V6B each have 5 filter_step ValueError failures.
DUKF and ICRPF each have 6 filter_step ValueError failures.
SO_SMO has no filter_step failure in this probe, only the calce_legacy loader failure.
```

Interpretation: no raw default-registry ECM candidate is contract-safe on the Phase 32 real micro-slice. `SO_SMO` is the only registry method with no filter-step failure over the six loaded configs, but it is the nonlinear observer family, not a physics/ECM replacement.

## Decision

Do not replace raw `EKF` with `UKF_def` or another default-registry ECM method.

The only currently executable ECM-family path over the six loaded real configs is `EKF_projected`, but it remains diagnostic-only until explicitly pre-registered as a bounded-output variant.

Therefore Phase 35 must choose and formalize one of two scientifically defensible paths:

1. Keep raw `EKF` in the method panel and score its contract failures as method failures.
2. Amend the method-family freeze to use `EKF_projected` as the ECM-family bounded-output variant, with explicit limits:
   - raw base estimator: `EKF`;
   - post-processing policy: `unit_interval_projection`;
   - purpose: enforce benchmark output contract;
   - claim limit: projection improves contract compliance, not physical model validity.

Recommended path: formal Phase 23 / Phase 25 amendment for `EKF_projected`, while retaining raw `EKF` failure artifacts as audit evidence.

## Artifact Hashes

| Artifact | SHA-256 |
|---|---|
| `bsebench-runner/outputs/phase34_ukf_def_probe_20260510.json` | `99a85dc5106f126ccb368e78387c53aa55f5aa56b46ff857c7418d06816e66cf` |
| `bsebench-runner/outputs/phase34_default_registry_probe_20260510.json` | `299f020aa7b7aeb0b8fd886b173f6c9ac72bba06670fa539667bb38c1c9e92cf` |

## Validation

Executed:

```bash
jq summaries over both Phase 34 artifacts
sha256sum outputs/phase34_ukf_def_probe_20260510.json outputs/phase34_default_registry_probe_20260510.json
rg -n "hf_|HF token|HUGGINGFACE|api key|token" outputs/phase34_ukf_def_probe_20260510.json outputs/phase34_default_registry_probe_20260510.json
```

Result:

```text
Artifacts are committed in bsebench-runner at e43abf0.
Raw Hugging Face token was not present in the artifacts.
The word "token" appears only inside generic Hugging Face authentication error text.
```

No code path was changed in Phase 34, so no unit test suite was required beyond artifact inspection.

## Scientific Interpretation

Phase 34 closes a key ambiguity. The benchmark cannot claim a fair three-family real-data run by silently swapping raw `EKF` to another unbounded ECM filter, because the alternative ECM registry methods also fail the same output contract.

The next scientifically clean step is a pre-registered amendment. This preserves traceability:

- raw `EKF` failure remains documented;
- `EKF_projected` is only introduced with an explicit contract-bounding rationale;
- no ranking is produced until the amended method panel is frozen and rerun.

## Next Phase

Phase 35: formal method-panel amendment.

Definition of Done:

- create an explicit amendment artifact in the specs repository;
- define whether the ECM family is raw-failure `EKF` or bounded `EKF_projected`;
- record claim limits and scoring consequences;
- rerun the real micro-slice using the amended method panel;
- keep BSE-Score disabled until the panel is frozen and loader blockers are accounted for.
