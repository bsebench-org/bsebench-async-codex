# Cross-Chemistry, Temperature, and SOH Split Audit

GLASSBOX audit timestamp: 2026-05-07T21:58:00+02:00
Worker: M-XCHEM
Branch: phase-8-2-e-cross-chemistry-soh-split-audit-20260507T193528Z
Owned write-set: audits/methodology/cross-chemistry-soh-splits-20260507T193528Z.md

## Objective

Define a falsifiable split-design runbook for cross-chemistry, temperature, and
aging/SOH generalization in BSEBench. The audit is a methodology artifact only:
it inspects current split and metadata contracts, identifies what they can and
cannot prove, and specifies the metadata and validation gates required before
future SOC/SOH or transfer reports can treat a split as leakage-safe.

This audit does not edit datasets, runner code, stats code, thesis files,
manuscript files, roadmap files, claim registry files, `claims/registry.yaml`,
or `claim_55`.

## Evidence Inspected

Read-only evidence inspected from the report worktree and sibling target
repositories:

| Evidence | Inspection result |
| --- | --- |
| `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md` | The charter requires chemistry, profile, temperature, aging/SOH, and cross-chemistry transfer axes, with split and leakage validation before community snapshots. |
| `bsebench-datasets/splits/audit_j_v1.yaml` | Current split schema version is `1.1`; role is `heldout_evaluation`; calibration policy is `forbidden`; leakage boundary is `config_tuple`; config id fields are `wrapper`, `profile`, and `T_C`. |
| `bsebench-datasets/src/bsebench_datasets/splits.py` | Split schema validates unique `(wrapper, profile, T_C)` tuples and requires metadata/calibration/evaluation blocks for schema `1.1`, but config records do not carry cell, cycle, source-file, chemistry, SOH, or aging-window fields. |
| `bsebench-datasets/tests/test_split_audit_j_v1.py` | Tests pin 26 Audit J configs, wrapper breakdown, metadata blocks, no duplicate tuples, and temperature envelope. |
| `bsebench-datasets/README.md` | Loader-facing trace metadata includes `cell_id`, `dataset`, `chemistry`, `T_amb`, and optional `soc_truth`/`soh_truth` where provided, but split configs do not require those fields. |
| `bsebench-datasets/src/bsebench_datasets/manifest.py` and selected manifests | Dataset manifests carry dataset-level `chemistries`, `n_cells_total`, sampling rate, source provenance, and file hashes, with richer axis details often present only in notes or file names. |
| `bsebench-datasets/src/bsebench_datasets/auditj_local_cache_manifest.py` | The local-cache manifest can report readiness and Phase 11 provenance fields such as chemistry, profile, temperature, voltage/current units, and sampling cadence when known. |
| `bsebench-runner/src/bsebench_runner/split_guard.py` in the split-guard worktree | Runner guard rejects calibration/evaluation overlap only at normalized `(wrapper, profile, T_C)` identity. It explicitly allows same wrapper/profile at different temperatures. |
| `bsebench-runner/src/bsebench_runner/manifest_preflight.py` in the Phase 8/11 preflight worktree | Dry-run preflight resolves Phase 8 LG HG2 manifest-backed configs and Phase 11 5x5 configs, and blocks missing loader/cache/metadata/filter/stats readiness without running filters. |
| Wave 1 / Wave 2 logs and audits | Prior work covers universal API gaps, source-ledger gates, local-cache readiness, Phase 11 provenance inventory, and runner manifest preflight. This audit avoids duplicating those artifacts and focuses on split-axis design. |

Concrete inspection commands used included:

```bash
rg --files /mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-8-0-o-universal-datasets-split-metadata
rg -n "split|chemistry|temperature|SOH|soh|aging|metadata|manifest|profile|leakage" /mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-8-0-o-universal-datasets-split-metadata
sed -n '1,220p' splits/audit_j_v1.yaml
sed -n '1,520p' src/bsebench_datasets/splits.py
sed -n '1,280p' src/bsebench_datasets/manifest.py
sed -n '1,240p' tests/test_split_audit_j_v1.py
sed -n '1,180p' src/bsebench_runner/split_guard.py
sed -n '1,1040p' src/bsebench_runner/manifest_preflight.py
```

## Current Split Capability

Current Audit J split metadata is suitable as a frozen held-out voltage
prediction config matrix. It can answer whether a method was evaluated on the
same declared 26 config tuples and whether those tuples were not also used as
the named calibration split.

It is not, by itself, a proof of cross-chemistry, temperature, or SOH
generalization. The blocking reason is mechanical: the split identity is the
config tuple, while the generalization questions require disjointness over
chemistry family, manufacturer/model, cell identity, source artifact,
temperature bin, cycle/SOH window, and future labels.

The Audit J split description says it spans multiple wrappers and chemistry
families, but the machine-validated config rows do not include chemistry fields.
Chemistry is currently discoverable from loader metadata, manifest-level
metadata, or file naming conventions depending on the dataset. A future
cross-chemistry claim must not rely on prose descriptions or wrapper names when
a split guard could require structured chemistry metadata instead.

The runner split guard is a useful first barrier, but it is too narrow for this
audit's target axes. A calibration split containing `yao:BCDC:T25` and an
evaluation split containing `yao:BCDC:T35` is treated as non-overlapping today.
That may be correct for a config-holdout voltage benchmark, but it is not
enough for temperature extrapolation if both configs share the same cell,
source file, preprocessing fit, or truth-label derivation.

## Decisions and Recommendations

1. Keep `audit_j_v1` scoped as a voltage-prediction held-out config split unless
   a later artifact adds structured axis metadata and stronger leakage guards.
2. Introduce a split schema revision for universal generalization protocols
   before running cross-chemistry, temperature, or SOH conclusions. The revision
   should be additive and should not weaken the existing config-tuple checks.
3. Require split authors to declare the intended generalization axis for each
   protocol: `chemistry_holdout`, `temperature_holdout`,
   `soh_band_holdout`, `future_cycle_forecast`, `cell_disjoint_soh`,
   `dataset_holdout`, or an explicit combination.
4. Require runner guards to enforce all declared disjointness boundaries, not
   only tuple disjointness. A split should fail closed when required metadata is
   missing.
5. Treat missing chemistry, temperature, cell, cycle, capacity, or SOH metadata
   as `unknown_metadata`, not as inferred metadata from filenames or wrapper
   labels.
6. Separate within-cell temporal SOH forecasting from cell-disjoint SOH
   generalization. The former may intentionally train on early cycles of the
   same cell and evaluate future cycles; the latter must keep cell identities
   disjoint.
7. Require normalization, feature selection, ECM parameter fitting, estimator
   tuning, and threshold selection to declare their data scope. Evaluation
   traces and labels must not be visible to those steps unless a protocol
   explicitly marks the split as calibration.

## Required Metadata

Every config row used by a cross-axis split should include these fields or fail
the readiness gate:

| Field | Required for | Reason |
| --- | --- | --- |
| `dataset_id` | all axes | Separates dataset holdout from within-dataset holdout. |
| `tier1_artifact_id`, `tier1_sha256`, `tier2_artifact_id`, `tier2_sha256` | all axes | Makes cache/source identity auditable and replayable. |
| `wrapper`, `profile`, `T_C_nominal` | all axes | Preserves the existing config identity. |
| `temperature_bin`, `T_C_actual_min`, `T_C_actual_max`, `temperature_source` | temperature, SOH | Distinguishes setpoint, measured chamber, and measured cell temperature. |
| `chemistry_family`, `cathode`, `anode`, `manufacturer`, `cell_model`, `nominal_capacity_Ah` | chemistry, SOH | Prevents wrapper names from standing in for chemistry metadata. |
| `cell_id`, `replicate_id`, `experiment_id`, `source_file_id` | chemistry, temperature, SOH | Enables cell/source disjointness checks. |
| `cycle_start`, `cycle_end`, `sample_start_s`, `sample_end_s` | aging/SOH | Defines the scored time or cycle window. |
| `age_index`, `equivalent_full_cycles`, `capacity_Ah`, `initial_capacity_Ah`, `soh_truth` | aging/SOH | Makes SOH state and aging progression explicit. |
| `soh_reference_method`, `capacity_test_id`, `rpt_id`, `truth_timestamp` | aging/SOH | Records how SOH was measured and prevents future-label leakage. |
| `aging_regime`, `charge_protocol`, `discharge_protocol`, `rest_policy` | aging/SOH, temperature | Distinguishes calendar aging, cycle aging, RPT, and drive profiles. |
| `estimator_visible_fields`, `metric_only_fields` | all axes | Blocks truth labels and future metadata from estimator inputs. |
| `calibration_allowed`, `normalization_scope`, `parameter_fit_scope` | all axes | Documents what fitting steps can see. |

Dataset-level manifests should keep high-level fields, but split rows need
resolved per-config values. If a value is derived from a manifest, loader probe,
or Parquet schema, the split should record `source` and `status` for that field.

## Falsifiable Split Axes

### Cross-Chemistry Holdout

Protocol condition:

- Training/calibration chemistries and evaluation chemistries are disjoint at
  `chemistry_family` when the protocol is family-level transfer.
- Manufacturer/model may also be required disjoint for within-family transfer,
  for example NMC source cells to different NMC manufacturer/model cells.
- Rows with missing chemistry metadata cannot be used for a chemistry-holdout
  protocol.

Failing example:

- Evaluation row says `wrapper: yao` but has no structured
  `chemistry_family`, `manufacturer`, and `cell_model`.

Passing example:

- Calibration rows declare `chemistry_family: LFP`; evaluation rows declare
  `chemistry_family: NMC`; no row has `unknown_metadata` for chemistry fields;
  all cells and source files are disjoint unless the protocol explicitly allows
  same-dataset transfer.

### Temperature Holdout

Protocol condition:

- Split declares `temperature_generalization: interpolation`,
  `extrapolation_cold`, `extrapolation_hot`, or `leave_temperature_bin_out`.
- Evaluation temperature bins are absent from calibration for the declared
  boundary.
- Same cell/source reuse across temperature bins is either forbidden or
  explicitly declared as a within-cell temperature protocol.

Failing example:

- Calibration includes `T_C=25` and evaluation includes `T_C=35` from the same
  source trace after normalization was fit over all temperatures.

Passing example:

- Calibration uses nominal and cold bins; evaluation uses a held-out hot bin;
  `T_C_actual_min/max` are present; normalization scope excludes evaluation
  traces; the split records whether cell identities are shared or disjoint.

### Aging/SOH Band Holdout

Protocol condition:

- Split declares SOH bands, such as `fresh`, `mid_life`, `aged`, and `near_eol`,
  using numeric thresholds tied to `soh_truth` or capacity retention.
- Evaluation SOH bands are absent from calibration when the task is SOH-band
  generalization.
- Future capacity or RPT labels from the evaluation horizon are metric-only and
  unavailable to estimator inputs.

Failing example:

- A row includes `soh_truth` but no `soh_reference_method` or cycle/RPT identity,
  or the same cell has future cycles visible during hyperparameter tuning.

Passing example:

- Calibration includes cells with SOH above a declared threshold; evaluation
  includes later SOH bands from disjoint cells; every row records capacity test
  id, cycle window, and truth derivation.

### Within-Cell Future-Cycle Forecast

Protocol condition:

- Same cell may appear in calibration and evaluation only when the split
  declares a temporal forecast protocol.
- Calibration windows must end before evaluation windows begin.
- Labels after the forecast cutoff are hidden from tuning, normalization,
  feature engineering, and model selection.

Failing example:

- Split allows early and late cycles from one cell but has no `cycle_start`,
  `cycle_end`, or forecast cutoff.

Passing example:

- Split records `forecast_cutoff_cycle`; calibration windows end at or before
  that cycle; evaluation windows start after it; all future SOH labels are
  metric-only.

## Minimum Split Schema Additions

A universal split schema should add:

```yaml
schema_version: "2.0"
split_id: example_cross_chemistry_v1
protocol:
  task: soh_estimation
  generalization_axes: [chemistry_holdout, temperature_holdout]
  target_signals: [soh]
  estimator_visible_fields: [voltage_V, current_A, temperature_C, dt_s]
  metric_only_fields: [soh_truth, capacity_Ah]
leakage_policy:
  boundaries: [cell_id, source_file_id, chemistry_family, temperature_bin]
  calibration_policy: allowed_on_named_splits
  allowed_calibration_split_ids: [example_calibration_v1]
  normalization_scope: calibration_only
  parameter_fit_scope: calibration_only
configs:
  - config_id: example_config_001
    role: evaluation
    dataset_id: yao_tu_berlin_2024
    wrapper: yao
    profile: BCDC
    T_C_nominal: 35
    temperature_bin: hot
    chemistry_family: NMC
    manufacturer: LG
    cell_model: INR21700_M50LT
    cell_id: NMC063
    source_file_id: sha256:...
    cycle_start: null
    cycle_end: null
    soh_truth: null
    field_status:
      chemistry_family: ready
      temperature_bin: ready
      cell_id: ready
      soh_truth: not_applicable
```

This schema sketch is not a file format commitment. It is the minimum
information needed to make the split axes falsifiable.

## Validation Runbook

Required validation before accepting a future cross-axis split:

1. Split schema validation:
   ```bash
   uv run python -m bsebench_datasets.splits validate splits/<split_id>.yaml
   ```
2. Axis metadata readiness:
   ```bash
   uv run python -m bsebench_datasets.splits axis-report \
     --split splits/<split_id>.yaml \
     --require chemistry_family \
     --require temperature_bin \
     --require cell_id \
     --require source_file_id
   ```
3. Calibration/evaluation leakage guard:
   ```bash
   uv run python -m bsebench_runner.split_guard \
     --calibration splits/<calibration_split>.yaml \
     --evaluation splits/<evaluation_split>.yaml \
     --boundary config_tuple \
     --boundary cell_id \
     --boundary source_file_id \
     --boundary chemistry_family \
     --boundary temperature_bin
   ```
4. SOH temporal leakage guard when SOH is scored:
   ```bash
   uv run python -m bsebench_datasets.splits soh-guard \
     --split splits/<split_id>.yaml \
     --require-capacity-reference \
     --forbid-future-labels-outside-calibration
   ```
5. Manifest/cache readiness preflight before expensive runner dispatch:
   ```bash
   uv run python -m bsebench_runner.manifest_preflight \
     --include-phase8 \
     --include-phase11 \
     --no-run-filters
   ```
6. Report/source-ledger gate before public comparison language:
   ```bash
   scripts/check-research-brief-gates.sh <brief-or-report>
   ```

Commands 1-4 are recommended new or extended gates. A split that cannot pass
them should be marked `not_ready` or `unknown_metadata`, not silently accepted.

## Validation Performed For This Audit

| Check | Command | Result |
| --- | --- | --- |
| Current worktree/branch confirmed | `pwd && git status --short --branch` | On `phase-8-2-e-cross-chemistry-soh-split-audit-20260507T193528Z`; clean before this audit file. |
| Prior work inspected | `rg -n "Wave 1|Wave 2|cross-chem|chemistry|SOH|split|temperature|aging|metadata|ledger|GLASSBOX" audits logs reports docs data datasets .` | Prior work centered on source-ledger, local-cache, provenance, API, and guardrail audits; no duplicate cross-chemistry/SOH split-design audit was present. |
| Dataset split metadata inspected | `rg -n "split_metadata:|leakage_boundary:|config_id_fields:|calibration:|evaluation:|task:|target_signals:|primary_metric:" splits/audit_j_v1.yaml` | Confirmed `leakage_boundary: config_tuple`, config id fields `[wrapper, profile, T_C]`, task `voltage_prediction`, target `[voltage_V]`, and primary metric `rmse`. |
| Split config inventory inspected | `rg -c '^  - \{wrapper:' splits/audit_j_v1.yaml` and `rg -o 'wrapper: [^,}]+' splits/audit_j_v1.yaml \| sort \| uniq -c` | Confirmed 26 configs: 12 `calce_a123_dyn`, 5 `calce_inr_dyn`, 1 `calce_legacy`, 2 `lg_hg2`, 1 `nasa`, 3 `panasonic`, and 2 `yao`. |
| Split schema inspected | `rg -n "config_tuple|cell_id|cycle_id|source_file|dataset|CalibrationPolicy|EvaluationTask|soh_estimation|target_signals" src/bsebench_datasets/splits.py` | Schema enumerates potential leakage boundaries and SOH task vocabulary, but current config tuple validation still uses `(wrapper, profile, T_C)`. |
| Runner split guard inspected | `rg -n "same profile at different temperature|wrapper, profile, T_C|overlap|leakage|temperature" tests/test_split_guard.py src/bsebench_runner/split_guard.py` | Guard checks normalized `(wrapper, profile, T_C)` overlap and has a test allowing same profile at different temperature. |
| Falsifiable axes proposed | This document, sections "Required Metadata" and "Falsifiable Split Axes" | Complete for chemistry, temperature, SOH band, and future-cycle protocols. |
| Whitespace check | `git diff --check` | Passed before staging. |

## Residual Risks

- This audit is a specification/runbook, not an implementation. The proposed
  split schema and CLI gates must still be added in datasets and runner repos.
- Some dataset manifests already contain useful axis metadata in notes or file
  descriptions. Until those values are promoted into structured fields, they
  remain hard to enforce mechanically.
- Cross-chemistry and SOH protocols can conflict: a protocol may need
  chemistry-disjoint cells while SOH forecasting may intentionally allow
  within-cell temporal training. The split must declare which protocol it is.
- SOH truth can be source-specific and delayed. Capacity-test timing and
  truth-label availability must be audited per dataset before scoring SOH.
- Temperature setpoints and measured cell temperatures are not equivalent.
  Protocols that mix them need explicit caveats and separate fields.

## Explicit Non-Claims

- This audit does not claim BSEBench currently proves cross-chemistry
  generalization.
- This audit does not claim any estimator, filter, observer, ECM, AI method, or
  hybrid method is best, state of the art, novel, or validated for a public
  leaderboard.
- This audit does not verify the parent Audit J scientific verdict or any claim
  registry entry.
- This audit does not compare external literature results and does not create a
  source ledger.
- This audit does not authorize edits to thesis, manuscript, roadmap, claim
  registry, `claims/registry.yaml`, or `claim_55` files.
