# Ground-Truth Methodology Audit for Universal SOC/SOH Evaluation

GLASSBOX metadata:

- Worker: M-GT.
- Date: 2026-05-07.
- Branch: `phase-8-2-a-ground-truth-methodology-audit-20260507T193528Z`.
- Owned artifact: `audits/methodology/ground-truth-methodology-20260507T193528Z.md`.
- Scope: methodology audit/spec/runbook only; no dataset, runner, stats, thesis, manuscript, roadmap, or claim-registry edits.
- Claim status: no SOTA, novelty, leaderboard, breakthrough, or verified-claim statement is made here.

## Objective

Define the minimum auditable ground-truth methodology required before BSEBench
can fairly evaluate universal SOC/SOH estimators across ECMs, Kalman filters,
observers, AI estimators, hybrid methods, and future methods.

The central decision is that a numeric `soc_truth` or `soh_truth` column is not
itself evidence. A benchmark record is admissible for SOC/SOH scoring only when
the derivation method, source data, calibration anchors, leakage boundary, and
caveats are explicit enough to be re-audited.

## Evidence Inspected

Local evidence inspected, read-only:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`: requires auditable SOC/SOH references and prefers SOC ground truth based on coulomb counting recalibrated by OCV rest points or an explicitly documented equivalent.
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`: Wave 1 included a datasets-owned `universal-datasets-ground-truth-audit`, so this report avoids duplicating implementation work and focuses on acceptance methodology.
- `bsebench-datasets/README.md`: Tier 2 schema uses `time_s`, `voltage_V`, `current_A`, `temperature_C`, with optional `capacity_Ah`, `soc_truth`, and `soh_truth`; loader output currently exposes smaller feature arrays.
- `bsebench-specs/src/bsebench_specs/timeseries.py`: schema bounds `soc_truth` to `[0, 1]`, allows `soh_truth` up to `1.5`, and records BPX current convention at the Tier 2 layer.
- `bsebench-datasets` adapters: several current adapters write `soc_truth`/`soh_truth` as null when unavailable; Yao raw CSV requires `SOC` but the inspected adapter currently does not propagate it into Tier 2; Oxford/Severson/NASA examples preserve capacity-like fields but not final SOC/SOH truth labels.
- Wave 1 worktrees, read-only: `etl_contract.py`, `ground_truth_metadata_audit.py`, dataset-card schema, split metadata, and protocol registry drafts. These add useful contract pieces but are not a completed universal SOC/SOH evidence standard by themselves.
- `bsebench-runner/src/bsebench_runner/orchestrator.py`: current main runner scores voltage prediction against measured voltage, not SOC/SOH labels.
- `bsebench-runner-phase-8-0-b-universal-runner-protocol-registry`: draft registry explicitly bans initialization from `ground_truth_soc`, `ground_truth_soh`, future samples, and test labels.

## Methodology Decisions

1. **Truth fields are target-only.** `soc_truth`, `soh_truth`, capacity references, OCV anchors, and recalibration points must never be passed to estimator `step(...)` inputs, initialization policy, feature normalization, hyperparameter tuning, model selection, or threshold selection on held-out splits.

2. **SOC scoring requires method-qualified truth.** A SOC target is admissible only when its method is one of:
   - `ocv_recalibrated_coulomb_counting`;
   - `coulomb_counting_with_documented_anchor` for datasets with no valid rest/OCV anchor, explicitly marked lower evidence grade;
   - `source_reported_soc` only when the source documentation states how it was computed and the same evidence fields can be filled or marked as source-provided.

3. **OCV recalibration is an anchor, not a magic correction.** OCV anchors must record rest criteria, temperature basis, curve source, hysteresis handling, anchor timestamps/events, and whether anchors are allowed in calibration, evaluation, or both. Evaluation-set future anchors may be used only to construct an offline label after the benchmark trace is frozen, never to initialize or adapt the estimator during that trace.

4. **SOH scoring requires capacity-test provenance.** A `soh_truth` target is admissible only when the capacity basis, reference capacity, normalization formula, RPT/diagnostic cycle identity, aging-state alignment, and interpolation policy are explicit.

5. **Current BSEBench Audit J evidence is not automatically SOC/SOH-ready.** The inspected production runner and existing loaders mainly support voltage-prediction evaluation. Null `soc_truth`/`soh_truth` fields, unpropagated source SOC columns, or capacity integrals without anchor metadata must be recorded as gaps rather than silently treated as benchmark targets.

## Required Evidence Fields

Every SOC/SOH dataset card, manifest extension, or evidence bundle that claims
SOC/SOH benchmark readiness should include these fields.

Common fields for SOC and SOH:

- `dataset_id`, `cell_id`, `trace_id`, `profile`, `temperature_basis`, `split_id`, `split_role`, `leakage_boundary`.
- `raw_source_path_or_url`, `raw_source_sha256`, `tier2_path`, `tier2_sha256`, `transform_script`, `transform_commit`, `generated_at_utc`.
- `retrieval_date`, `stable_url_or_doi`, `source_ledger_row_id`, `license_or_access_caveat`.
- `timebase_column`, `timebase_unit`, `sampling_or_resampling_policy`.
- `raw_current_column`, `raw_current_sign_convention`, `tier2_current_sign_convention`, `loader_current_sign_convention`.
- `truth_field_name`, `truth_units`, `truth_bounds`, `truth_null_policy`, `truth_target_only=true`.
- `leakage_guard.split_scope`, `leakage_guard.allowed_anchor_scope`, `leakage_guard.uses_future_test_labels=false`.
- `evidence_grade`: `ready`, `partial`, `not_comparable`, or `gap`.
- `caveat`: plain-language reason for every partial, not-comparable, or gap status.

SOC-specific fields:

- `soc_method`: one of the method-qualified labels above.
- `reference_capacity_Ah`, `reference_capacity_source`, `reference_capacity_test_id`.
- `initial_soc`, `initial_soc_source`, `initial_soc_timestamp_or_event`.
- `integration_rule`, `integration_direction`, `reset_policy`, `current_offset_policy`.
- `ocv_curve_source`, `ocv_curve_sha256_or_version`, `ocv_curve_temperature_basis`.
- `rest_criterion`: minimum rest time, current threshold, voltage-slope threshold if used.
- `recalibration_points`: timestamps, step ids, or event ids used as anchors.
- `hysteresis_handling`: charge curve, discharge curve, average curve, or not handled.
- `anchor_interpolation_policy`: how drift between anchors is distributed.

SOH-specific fields:

- `soh_method`: capacity retention, impedance/resistance proxy, source-reported SOH, or other documented method.
- `capacity_test_protocol`, `capacity_test_current_rate`, `capacity_cutoff_voltage`, `capacity_temperature_basis`.
- `reference_capacity_Ah`, `reference_capacity_source`, `normalization_formula`.
- `diagnostic_cycle_id`, `aging_cycle_or_date`, `mapping_to_trace`.
- `interpolation_policy_between_diagnostics`, `extrapolation_policy`, `eol_definition` when relevant.
- `separation_from_soc_target`: whether SOH is held constant per trace, per cycle, or per diagnostic interval.

## Acceptance Gates

A future SOC/SOH benchmark run is mergeable only when all gates below pass:

1. Dataset evidence audit returns no blocking gaps for every evaluated config.
2. The runner proves estimator inputs exclude `soc_truth`, `soh_truth`, OCV anchors, capacity tests, and future labels.
3. Split metadata states calibration/evaluation use explicitly and forbids target-derived tuning on held-out data.
4. The metric report names the target field, unit, aggregation, missing-label policy, and config set.
5. Any row lacking method evidence is reported as `gap` or `not_comparable`, not omitted.
6. Any external comparison or leaderboard text has a completed source ledger with stable URL/DOI, retrieval date, metric, dataset, split, method, reported value, BSEBench frozen value, comparability status, and caveat.

## Runbook

For a candidate dataset:

1. Confirm Tier 2 trace schema contains the required measurement columns and, if present, `soc_truth`/`soh_truth` are nullable target columns.
2. Build or inspect the ground-truth metadata record using the required evidence fields above.
3. Run the dataset-side ground-truth metadata audit. Missing OCV anchor, capacity reference, current sign convention, timebase, integration rule, reset policy, or leakage guard must block SOC readiness.
4. Run split/leakage validation. The same cell/profile/config tuple must not cross forbidden calibration/evaluation boundaries.
5. Run a runner smoke test that instruments estimator inputs and fails if target-only fields are observable by the estimator.
6. Freeze hashes for raw source, Tier 2 file, split, protocol, metric code, and generated evidence bundle.
7. Only then allow SOC/SOH metric reporting. If any gate is partial, report the dataset as partial or not comparable rather than scoring it as a clean SOC/SOH benchmark row.

## Validation Commands

Commands used for this audit or recommended as exact local checks:

```bash
rg -n "soc_truth|soh_truth|capacity_Ah|ground_truth|truth|OCV|coulomb|SOC" -S \
  /mnt/c/doctorat/bsebench-org/bsebench-datasets/src \
  /mnt/c/doctorat/bsebench-org/bsebench-datasets/tests \
  /mnt/c/doctorat/bsebench-org/bsebench-datasets/README.md

rg -n "soc_truth|soh_truth|capacity_Ah|current_A|time_s|TimeSeriesSchema" -S \
  /mnt/c/doctorat/bsebench-org/bsebench-specs/src \
  /mnt/c/doctorat/bsebench-org/bsebench-specs/tests \
  /mnt/c/doctorat/bsebench-org/bsebench-specs/README.md

rg -n "ground_truth|soc_truth|soh_truth|truth|target_only|leakage|ground_truth_soc|ground_truth_soh" -S \
  /mnt/c/doctorat/bsebench-org/bsebench-runner/src \
  /mnt/c/doctorat/bsebench-org/bsebench-runner/tests \
  /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-b-universal-runner-protocol-registry/src

rg -n "SOTA|novel|leaderboard|breakthrough|verified claim|claim_55" -S \
  audits/methodology/ground-truth-methodology-20260507T193528Z.md

git diff --check
```

## Residual Risks

- Wave 1 dataset contracts were inspected from active worktrees; until merged, their exact APIs and field names may change.
- Several existing adapters expose capacity or source SOC signals inconsistently. The methodology therefore records requirements, not a completed migration.
- OCV-rest availability varies by chemistry and protocol. Datasets without valid rest points may still be useful, but their SOC targets must carry lower evidence grade or be excluded from clean SOC scoring.
- Coulomb-counted SOC is sensitive to current offset, capacity fade, irregular timebases, and reset policy. These uncertainties need explicit metadata and, where practical, uncertainty bands.
- SOH labels can leak future aging information if a full-life capacity curve is used to label early-cycle evaluation traces. The split policy must say whether labels are offline targets only or available causally at the time of estimation.

## Explicit Non-Claims

- This audit does not verify any SOC or SOH benchmark result.
- This audit does not claim BSEBench is state of the art, novel, leaderboard-leading, or publication-ready.
- This audit does not validate a scientific claim, update `claim_55`, or modify any claim registry.
- This audit does not assert that current BSEBench datasets already satisfy the SOC/SOH evidence standard.
- This audit does not replace the dataset-owned ground-truth metadata audit; it specifies the methodology that audit should enforce before SOC/SOH scoring is accepted.
