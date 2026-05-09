# Phase 12 First Transfer Pilot Design

Generated: 2026-05-09 11:58 CEST

Scientific claim status: `NO_GO_CLAIM`.

Execution status: **not authorized yet**.

This design selects the first plausible real source-target transfer pilot using
only evidence already present in the workspace. It is a pre-execution design,
not an empirical result.

## Candidate Pair

| Role | Dataset/config | Evidence already present |
|---|---|---|
| Source/calibration | `calce_a123_dyn`, LFP, `DST`, 25 °C | `bsebench-datasets/docs/PHASE_9_PROFILE_AXIS_CALCE_READY_2026-05-09.md`; local cache `.phase9-local-cache/calce_a123_dyn_20260509`; manifest `manifests/calce_a123_lfp_dynamic.yaml` |
| Target/evaluation | `nasa:CC-discharge:T24`, LCO, B0005 discharge | `bsebench-datasets/docs/PHASE_10_NASA_PCOE_AGING_SOH_READY_2026-05-09.md`; local cache `.phase10-local-cache/nasa_pcoe_b0005_20260509`; manifest `manifests/nasa_pcoe_saha_goebel_2007.yaml` |

Why this pair:

- It exercises cross-chemistry transfer: LFP -> LCO.
- It exercises cross-profile transfer: dynamic DST -> constant-current discharge.
- Both sides have prior readiness evidence in the current workspace.
- NASA B0005 has explicit SOH/capacity/cycle evidence in the Phase 10 slice.
- CALCE A123 dynamic has loader-facing Tier 2 Parquet cache and profile-axis
  readiness evidence.

## Non-Goals

This pilot must not claim:

- benchmark superiority;
- filter ranking;
- SOC or SOH transfer success;
- SOTA;
- leaderboard readiness.

The first run, if later authorized, must be labeled a no-claim empirical smoke.

## Required Artifacts Before Execution

| Artifact | Required status | Current status |
|---|---|---|
| Source dataset manifest | `manifests/calce_a123_lfp_dynamic.yaml` validated | present |
| Target dataset manifest | `manifests/nasa_pcoe_saha_goebel_2007.yaml` validated | present |
| Source ledger | SHA-256-backed source/canonical ledger for selected CALCE files | partial from Phase 9 docs; must be materialized as artifact |
| Target ledger | SHA-256-backed source/canonical ledger for selected NASA files | partial from Phase 10 docs; must be materialized as artifact |
| Truth manifest | Explicit SOC/SOH truth policy for source and target | missing |
| Split manifest | Calibration/evaluation split with no leakage | missing |
| Parameter manifest | Frozen estimator/ECM/filter parameters | missing |
| TransferReadiness inventory | Built by `bsebench-datasets` manifest-backed producer | missing |
| Stats preflight | `preflight_ready` from real inventory | missing |
| Runner transfer plan | ready row from real preflight | missing |

## Blocking Gaps

Execution remains blocked by:

- `missing_truth_manifest`: source/target SOC/SOH truth policy must be explicit.
- `missing_split_manifest`: calibration/evaluation separation must be defined.
- `missing_parameter_manifest`: the estimator and its parameters must be frozen.
- `missing_source_ledger_artifact`: Phase 9/10 evidence must be converted into
  checksummed artifact files.
- `missing_real_transfer_readiness_inventory`: current ready inventory is still
  synthetic demo-only.

## Proposed Minimal Pilot Scope

Source:

- Wrapper: `calce_a123_dyn`
- Candidate trace family: `DST`
- Temperature: 25 °C
- Chemistry: LFP

Target:

- Wrapper/config: `nasa:CC-discharge:T24`
- Candidate cell: B0005
- Temperature: 24 °C
- Chemistry: LCO
- SOH evidence: capacity-derived SOH from Phase 10 readiness slice

Estimator:

- Initial candidate: one deterministic baseline only.
- Parameters must be frozen before target evaluation.
- No adaptive fitting on target traces.

## Acceptance Gate For Authorizing Execution

Execution can start only if all checks pass:

1. `bsebench-datasets` generates a real `TransferReadiness` inventory from the
   two manifests and local evidence artifacts.
2. The inventory validates through `bsebench-specs`.
3. `bsebench-stats` preflight returns `preflight_ready`.
4. `bsebench-runner` transfer matrix returns exactly one ready row for the
   selected source-target-estimator-split.
5. The runner output still records `result.status = not_run` until the explicit
   empirical smoke command is issued.

## Next Concrete Work

1. Materialize source and target ledger artifact JSON files from Phase 9/10
   evidence.
2. Create a truth manifest describing SOC/SOH availability and limitations.
3. Create a split manifest with calibration/evaluation boundaries.
4. Create a frozen parameter manifest for one deterministic baseline.
5. Use `build_transfer_readiness_from_manifests` to emit the first real
   inventory.
6. Run stats preflight and runner plan only; do not run the estimator yet.
