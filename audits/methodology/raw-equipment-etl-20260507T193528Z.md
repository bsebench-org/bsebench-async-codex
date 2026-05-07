# Raw Equipment ETL Audit for Universal V/I/T/dt Traces

GLASSBOX metadata:

- Worker: M-ETL.
- Date: 2026-05-07.
- Branch: `phase-8-2-f-raw-equipment-etl-audit-20260507T193528Z`.
- Owned artifact: `audits/methodology/raw-equipment-etl-20260507T193528Z.md`.
- Scope: methodology audit/spec/runbook only; no dataset, runner, stats, thesis, manuscript, roadmap, or claim-registry edits.
- Claim status: no SOTA, novelty, leaderboard, breakthrough, or verified-claim statement is made here.

## Objective

Define the minimum raw-equipment ETL contract needed before Arbin-, Maccor-,
Neware-, or unknown-cycler exports can become BSEBench benchmark traces with
auditable `V`, `I`, `T`, and `dt` inputs.

The acceptance decision is conservative: a raw export is not benchmark-ready
because it can be parsed. It is benchmark-ready only when the equipment
provenance, column mapping, unit conversion, current sign, timebase,
synchronization, segmentation, and dropped-row policy are all explicit and
replayable from the raw source hash to the loader-facing arrays.

## Evidence Inspected

Local evidence inspected, read-only:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`: requires raw laboratory ETL support for Arbin, Maccor, and related equipment outputs; synchronized `V`, `I`, `T`, and `dt`; documented interpolation/resampling; explicit provenance and cache identity.
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`: Wave 1 already includes dataset-owned ETL and equipment-registry work, so this audit focuses on methodology acceptance and failure modes.
- `bsebench-specs/src/bsebench_specs/timeseries.py`: Tier 2 row schema requires `cell_id`, `time_s`, `voltage_V`, `current_A`, `temperature_C`, and nullable optional target fields; current convention is BPX charge-positive/discharge-negative at Tier 2.
- `bsebench-datasets/README.md`: current loaders expose `t`, `V`, `I`, `T_meas`, `N`, `T_amb`, and provenance fields; loader current is discharge-positive, so loaders flip BPX `current_A`.
- `bsebench-datasets/src/bsebench_datasets/adapters/calce_a123_2014.py`: CALCE A123 legacy CSV and dynamic XLSX handling documents Arbin-style discharge-negative raw current and maps source time/current/voltage/temperature columns to Tier 2 names.
- `bsebench-datasets/src/bsebench_datasets/adapters/calce_inr_20r_2014.py`: INR-20R adapter documents Arbin workbooks with misleading `.xls` suffixes, XLSX payloads, and a sign-convention verification note based on negative current with falling voltage.
- `bsebench-datasets/src/bsebench_datasets/adapters/yao_tu_berlin_2024.py`: CSV adapter validates required columns, filters finite positive-voltage rows, zero-bases time, and records metadata, but also shows that source SOC can exist without being propagated as a benchmark truth field.
- `bsebench-datasets/src/bsebench_datasets/loaders/*calce*` and `*yao*`: loaders rebase time to zero, read Tier 2 measurement columns, and flip current to discharge-positive `I`.
- Wave 1 worktrees, read-only: `etl_contract.py` defines field-level Tier 2/loader contracts and `derive_dt_s`; `equipment_registry.py` defines a raw-equipment provenance skeleton for Arbin, Maccor, and unknown vendors. The inspected registry draft does not yet accept `neware` as a normalized vendor, which is a gap for this task's target scope.

## Canonical Input Contract

The universal raw-equipment ETL path should be treated as four layers:

1. **Raw source ledger.** Preserve each input file's path, SHA256, byte size, source URL or local mirror id, retrieval date, license/access caveat, archive member path, equipment vendor/model/software when known, channel id, source sheet/table name, and raw row count.
2. **Raw normalized staging table.** Parse vendor exports into a table with at least `source_file`, `source_row`, `channel_id`, `cell_id`, `raw_time_value`, `time_s`, `dt_s`, `voltage_V`, `current_A_raw`, `current_A_bpx`, `temperature_C`, `cycle_number`, `step_index`, `step_id`, `profile`, and `row_status`.
3. **Tier 2 Parquet.** Write BSEBench canonical fields using `time_s`, `voltage_V`, `current_A`, and `temperature_C`, with BPX convention `current_A > 0` for charge and `current_A < 0` for discharge. Optional target fields remain nullable and target-only.
4. **Loader trace.** Expose `t`, `V`, `I`, `T_meas`, and deterministic `dt_s` to benchmark protocols, where `I = -current_A` under the current runner convention. `soc_truth`, `soh_truth`, capacity references, OCV anchors, or source SOC columns must not be estimator features.

Minimum field rules:

- `time_s`: elapsed seconds from the selected trace origin, finite, monotone non-decreasing, and derived from a named raw time axis such as absolute datetime, test elapsed time, step elapsed time plus step offsets, or sample index plus sampling rate.
- `dt_s`: same length as `time_s`, `dt_s[0] = 0.0`, `dt_s[i] = time_s[i] - time_s[i - 1]`, no negative values. Repeated timestamps are allowed only when explicitly kept as zero-cadence samples or resolved by a documented aggregation policy.
- `voltage_V`: finite single-cell terminal voltage in volts. Millivolt inputs must record the conversion. Pack/module voltages are not admissible as cell voltage unless the cell decomposition is documented.
- `current_A_bpx`: finite current in amperes after sign normalization. The raw sign convention must be recorded separately; vendor name alone is not proof.
- `temperature_C`: finite measured or ambient temperature in Celsius. Missing, constant, chamber-only, surface, or interpolated temperature must be marked with a measurement-basis field.
- `row_status`: one of `kept`, `dropped_nonfinite`, `dropped_voltage`, `dropped_time`, `dropped_unmapped_step`, `dropped_duplicate`, `dropped_out_of_segment`, or another registered reason. Silent row removal is not acceptable.

## Decisions And Recommendations

1. **Fail closed on sign ambiguity.** A raw current column may be accepted only with source documentation, file-header evidence, or a smoking-gun segment check that links current sign to voltage trend under a known charge/discharge step. If this evidence is absent, the dataset can be parsed for exploratory use but must be marked `gap` or `not_comparable`.

2. **Do not infer equipment truth from filenames alone.** Arbin/Maccor/Neware-like column names are useful hints, but the equipment record must preserve evidence kind and confidence. Unknown or unsupported vendors should remain explicit rather than being coerced into a known parser.

3. **Add Neware to the equipment registry before claiming coverage.** The inspected Wave 1 registry draft models `arbin`, `maccor`, and `unknown`, and rejects `neware`. A universal raw-equipment policy should either register `neware` with evidence-backed formats or state that Neware-style inputs are accepted only through `unknown` until a schema extension lands.

4. **Make `dt_s` a first-class benchmark input.** Existing loaders expose `t`; Wave 1 adds a `derive_dt_s` helper. Universal estimator protocols should receive `dt_s` from a single runner/dataset utility, not recompute cadence ad hoc inside estimators.

5. **Separate parsing from resampling.** Vendor exports should first be represented on their native sample grid. Any interpolation or resampling to align multi-rate `V`, `I`, and `T` must be a named transform with method, target grid, tolerance, extrapolation behavior, and fraction of imputed samples. Hidden forward-fill is not acceptable.

6. **Preserve segment predicates.** Profile extraction must record the predicate used, such as a step index, protocol name, file name, or current/voltage rule. CALCE-style hard-coded `Step_Index` mappings should become auditable metadata, not only adapter constants.

7. **Reconcile current simplified Parquet with strict schema.** Some inspected adapters write only `time_s`, `voltage_V`, `current_A`, and `temperature_C`, while `bsebench-specs` requires `cell_id` and optional nullable fields in the canonical schema. This should be tracked as a universal ETL readiness gap until each supported adapter either writes the exact schema or has a documented compatibility exception.

8. **Treat source SOC/SOH as target-only evidence.** If an equipment export contains SOC, capacity, energy, or state flags, those columns may support offline target derivation or quality checks only after ground-truth methodology review. They must not enter `V/I/T/dt` estimator inputs.

## Required Failure Modes

A raw-equipment ETL validator should produce machine-readable failures for:

- missing required measurement columns or ambiguous aliases;
- raw units that cannot be mapped to seconds, volts, amperes, and Celsius;
- unknown or unsupported raw current sign convention;
- double sign flip between raw staging, Tier 2, and loader output;
- nonfinite values in kept `time_s`, `voltage_V`, `current_A`, or `temperature_C`;
- voltage outside physical single-cell bounds or pack voltage mistaken for cell voltage;
- non-monotone time, timestamp rollover, mixed absolute and relative time axes, daylight-saving or timezone ambiguity, or accidental lexical sorting of timestamps;
- duplicate timestamps without a declared zero-cadence or aggregation policy;
- hidden resampling, interpolation, forward-fill, or extrapolation;
- multi-channel workbooks where channel id, cell id, or sheet selection is not explicit;
- misleading file suffixes, compressed archive member ambiguity, repeated header rows, locale decimal-comma parsing, or mixed unit rows;
- profile/step selection that drops rows without an auditable predicate;
- temperature source missing, constant-by-assumption, or not synchronized with electrical measurements;
- raw file hash drift, archive member drift, or cache root confusion;
- target leakage through source SOC, source SOH, capacity tests, OCV rest labels, or future samples entering estimator features.

## Acceptance Gates

For a new Arbin/Maccor/Neware-style source, accept a benchmark trace only when:

1. Raw source ledger and equipment registry records validate and include evidence confidence.
2. Parser emits a staging table with source row lineage, raw and normalized current signs, native time axis, and row-status accounting.
3. Sign normalization is backed by documentation or a voltage-trend check on an identified segment.
4. `time_s` and `dt_s` are deterministic, monotone, finite, and covered by tests for resets, repeated timestamps, and nonfinite values.
5. `V`, `I`, and `T` synchronization is either native-row aligned or governed by an explicit interpolation/resampling policy.
6. Tier 2 output validates against the canonical schema or records a compatibility exception that blocks universal readiness.
7. Loader output proves `I` convention, `dt_s` derivation, `N` consistency, and target-only field exclusion.
8. A negative-control fixture fails for one wrong sign, one bad time axis, one missing temperature, and one leaked source SOC/target field.

## Runbook

1. Identify all raw files, archive members, sheets, channels, and equipment records for the candidate dataset.
2. Hash raw files and record source ledger rows before parsing.
3. Parse to the normalized staging table without resampling; preserve raw row ids.
4. Validate aliases, units, numeric finite status, voltage range, current sign evidence, timebase, and row-status accounting.
5. Derive `time_s` and `dt_s`; reject negative cadence and document repeated timestamps.
6. Normalize current to BPX `current_A`; keep raw sign and sign-evidence fields.
7. Apply explicit segment/profile predicates and record dropped rows by reason.
8. Write Tier 2 Parquet and run schema validation.
9. Load through the dataset loader and verify `t`, `V`, `I`, `T_meas`, `dt_s`, `N`, `cell_id`, `dataset`, `chemistry`, and `source_url`/source identity.
10. Run leakage instrumentation proving source SOC/SOH/capacity/OCV fields are absent from estimator inputs.
11. Freeze raw, staging, Tier 2, loader, split, protocol, and validation hashes before public reporting.

## Validation Commands

Commands used for this audit or recommended as exact local checks:

```bash
rg -n "Arbin|Maccor|Neware|ETL|time_s|current_A|voltage_V|temperature_C|dt_s|sign|resampl" -S \
  docs README.md inbox outbox

rg -n "time_s|current_A|voltage_V|temperature_C|Test_Time|Step_Index|Current\\(A\\)|Voltage\\(V\\)|Temperature|SOC|openpyxl|read_excel|read_csv" -S \
  /mnt/c/doctorat/bsebench-org/bsebench-datasets/src \
  /mnt/c/doctorat/bsebench-org/bsebench-datasets/tests \
  /mnt/c/doctorat/bsebench-org/bsebench-datasets/README.md

rg -n "TimeSeriesSchema|pyarrow_schema|validate_parquet|current_A|soc_truth|soh_truth" -S \
  /mnt/c/doctorat/bsebench-org/bsebench-specs/src \
  /mnt/c/doctorat/bsebench-org/bsebench-specs/README.md

rg -n "EtlFieldContract|derive_dt_s|bpx_current_to_runner_current|RawEquipmentRecord|EquipmentVendor|neware" -S \
  /mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-8-0-m-universal-datasets-etl-contract/src \
  /mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-8-0-q-universal-datasets-equipment-registry/src

git diff --check
```

## Residual Risks

- Wave 1 ETL and equipment-registry work was inspected from active worktrees; field names and acceptance semantics may change before merge.
- This audit did not run real raw Arbin, Maccor, or Neware files through a new parser. It defines the acceptance contract and failure modes for future parser work.
- Existing loaders mainly support voltage-prediction traces. SOC/SOH target propagation needs separate ground-truth and leakage gates before universal SOC/SOH scoring.
- Some current adapters use minimal Parquet columns accepted by their loaders but not the strict `bsebench-specs` schema. That gap must be closed or explicitly tracked.
- Vendor exports vary by software version, locale, and user export settings. The registry and parser tests need representative fixtures, not assumptions based on one dataset.

## Explicit Non-Claims

- This audit does not claim BSEBench currently supports all Arbin, Maccor, or Neware exports.
- This audit does not verify any SOC, SOH, voltage, or leaderboard result.
- This audit does not claim BSEBench is state of the art, novel, leaderboard-leading, or publication-ready.
- This audit does not validate a scientific claim, update `claim_55`, or modify any claim registry.
- This audit does not replace dataset-owned ETL implementation work; it specifies the methodology gates that work should satisfy before raw equipment traces are benchmark-ready.
