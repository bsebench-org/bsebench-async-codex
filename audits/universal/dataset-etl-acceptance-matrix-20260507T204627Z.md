# GLASSBOX Dataset ETL Acceptance Matrix

Timestamp: 2026-05-07T22:57:00+02:00
Worker: W4-15
Branch: `phase-8-3-o-dataset-etl-acceptance-matrix-20260507T204627Z`
Owned artifact: `audits/universal/dataset-etl-acceptance-matrix-20260507T204627Z.md`
Scope: CTO validation/spec artifact only. No dataset, runner, stats, thesis, manuscript, roadmap, claim registry, `claims/registry.yaml`, or `claim_55` files edited.

## Objective

Define a falsifiable acceptance matrix for dataset ETL across raw equipment exports, especially Arbin, Maccor, Neware, generic raw/source-ledger inputs, and Tier 2 Parquet/loader outputs. The matrix is intended to prevent anti-hallucination failures by requiring explicit source, equipment, parser, schema, sign-convention, ground-truth, leakage, and availability evidence before a dataset source is treated as benchmark-ready.

## Evidence Inspected

- Phase 8 watchdog logs under `/home/oakir/.local/state/bsebench-async-watchdog`.
- `bsebench-datasets` main at `2b97c256c86128bc057ec394a40610a086a7d665`.
- D1 ETL contract branch `phase-8-0-m-universal-datasets-etl-contract` at `6b6bab2df83b8b9c18a01842814c60debda41c9c`.
- D2 ground-truth metadata audit branch at `a52c81dd80b8e31de63719fbe874c45a9f68382f`.
- D3 split metadata branch at `2f0caba08b026cba1c448608394ffc33b1badbc2`.
- D4 dataset card schema branch at `e5f2305dfc2019d3676224b5409ebc536409b1ed`.
- D5 raw equipment registry branch at `96566f9bdd1794ccf5d2ece556bd55cdad55ba41`.
- D6 monthly availability branch at `c1af5d0b4c7fa09c23b8d0c15113c95e570c4fbd`.
- Phase 8.2 raw equipment ETL methodology artifact log, commit `20c91f3ca99c3996cddac7b7da4b156983b2636d`.
- `bsebench-specs` `TimeSeriesSchema` and `pyarrow_schema` in local checkout at `f928a185a619078d375144f838eafc566e271164`.

## Commands Run

```bash
git status --short --branch
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f \
  \( -name 'manual-phase-8-0-*.log' -o -name 'manual-phase-8-1-*.log' -o -name 'manual-phase-8-2-*.log' \) | wc -l
rg -l "^ERROR: You've hit your usage limit" \
  /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-2-*.log
rg -l "^(Implemented|Done\.|Changed files:|Changed file:|Commit:|Push status:)" \
  /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-[012]-*.log | wc -l
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets for-each-ref \
  --format='%(refname:short) %(objectname:short)' refs/heads refs/remotes/origin
rg -n "ETL_FIELD_CONTRACT|TIER2_FIELD_CONTRACTS|LOADER_FIELD_CONTRACTS|derive_dt_s|bpx_current_to_runner_current" \
  -S /mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-8-0-m-universal-datasets-etl-contract/src \
     /mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-8-0-m-universal-datasets-etl-contract/tests
rg -n "EquipmentVendor|RawEquipmentRecord|arbin|maccor|neware|raw_file_extensions|sampling_rate_hz" \
  -S /mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-8-0-q-universal-datasets-equipment-registry/src \
     /mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-8-0-q-universal-datasets-equipment-registry/tests
rg -n "Maccor|maccor|Neware|neware|Arbin|arbin|cycler" \
  -S /mnt/c/doctorat/bsebench-org/bsebench-datasets/README.md \
     /mnt/c/doctorat/bsebench-org/bsebench-datasets/src \
     /mnt/c/doctorat/bsebench-org/bsebench-datasets/tests \
     /mnt/c/doctorat/bsebench-org/bsebench-datasets/manifests
git diff --check
```

## Log Census

| Item | Observed result | Interpretation |
| --- | --- | --- |
| Wave 1-3 manual Phase 8 logs | 48 | Matches expected Wave 1 `8-0-a..x`, Wave 2 `8-1-k..v`, and Wave 3 `8-2-a..l` count. |
| Completion-like Wave 1-3 logs | 45 | Matches expected completed/pushed or final-report-like logs. |
| Exact Wave 3 usage-limit errors | 3 | `8-2-j`, `8-2-k`, and `8-2-l` hit the prior usage limit. They are accounted for here and are not used as dataset ETL evidence. |
| Dataset Wave 1 branch heads | 6 local and 6 remote heads | D1-D6 now exist and local refs match `origin` after fetch evidence in the W4 logs. |

## Current Dataset ETL Evidence

| Evidence area | Evidence | Acceptance impact |
| --- | --- | --- |
| Tier 2 field contract | D1 defines `time_s`, `voltage_V`, `current_A`, `temperature_C`, optional `soc_truth`, `soh_truth`, loader `t`, `V`, `I`, `T_meas`, and optional `dt_s`. | Provides a concrete field-level contract but does not alone prove every existing adapter writes strict universal Parquet. |
| Sign convention bridge | D1 defines Tier 2 `current_A` as BPX charge-positive/discharge-negative and loader `I = -current_A` for discharge-positive runner input. | Required for all raw-equipment adapters and loader tests. |
| Timebase guard | D1 includes `derive_dt_s` with finite, one-dimensional, monotone non-decreasing checks. | Required before an estimator can consume `dt_s` without hidden time-axis assumptions. |
| Equipment registry | D5 supports `arbin`, `maccor`, and `unknown`; raw formats include `arbin_csv`, `arbin_xlsx`, `maccor_csv`, and `maccor_txt`. | Arbin and Maccor can be represented. Neware cannot pass registry validation yet. |
| Neware handling | D5 test `test_equipment_record_rejects_unregistered_vendor` rejects `vendor: neware`. | Current status is FAIL for Neware acceptance until `neware` and expected raw formats are added intentionally. |
| Arbin adapter evidence | Main `bsebench-datasets` contains CALCE A123 and CALCE INR-20R adapters. Both document Arbin negative-current discharge and preserve BPX-aligned `current_A`; CALCE INR has a voltage-trend smoking-gun note. | Arbin is the only source family with concrete adapter evidence in this inspection. |
| Maccor adapter evidence | Search found no production Maccor parser in `bsebench-datasets` main. | Maccor is registry-ready only, not ETL-ready. |
| Dataset card metadata | D4 defines chemistry, profile, temperature, aging/SOH, source ledger status, content digest, license, and transformations. | Required metadata shape exists, but real dataset cards must be populated per source. |
| Ground-truth metadata | D2 requires SOC method evidence for coulomb counting or OCV recalibration, including capacity source, initial SOC, sign convention, timebase, integration rule, reset policy, retrieval date, and leakage guard. | Required before any SOC/SOH target field is accepted as evaluation truth. |
| Split metadata | D3 adds split role, leakage boundary, config-id fields, calibration policy, and evaluation metadata. | Required before any ETL output is used in a frozen benchmark split. |
| Availability | D6 distinguishes `tier2_available`, `tier1_available`, `manifest_registered`, and `prospect_tracked` without checking remote uptime. | Required for monthly reports, but not a substitute for raw/Tier2 parser validation. |

## Acceptance Test Matrix

Legend: PASS means the inspected Phase 8 artifact can express the gate. CONDITIONAL means partial implementation exists but source-specific evidence is still required. FAIL means the current inspected artifacts cannot accept that source class without a change.

| Source class | Current status | Required acceptance tests | Required metadata |
| --- | --- | --- | --- |
| Arbin raw export | CONDITIONAL | Parse at least one fixture per export shape; assert archive member/sheet/channel selection; assert raw negative discharge remains Tier 2 negative; assert voltage trend or source documentation backs sign; assert `time_s` finite and monotone; assert dropped-row accounting; assert Tier 2 and loader outputs pass field contract. | Equipment record with `vendor: arbin`, raw vendor name, file format, extension, current sign convention, time axis, sampling rate or explicit unknown, channel count if known, evidence pointer, raw file SHA256/size, retrieved date, source URL/license, parser version, row lineage, profile/cell/temperature mapping. |
| Maccor raw export | FAIL for production ETL; CONDITIONAL for registry schema | Add Maccor raw parser fixtures before use; cover `.txt` and `.csv` variants if both are claimed; assert delimiter/header/unit parsing; assert current sign convention from source or voltage trend; assert cycle/step timebase conversion; assert schema and loader output. | Same as Arbin plus Maccor software/export version, header-derived units, channel/cell identifiers, native cycle/step counters, and explicit format family such as `maccor_txt` or `maccor_csv`. |
| Neware raw export | FAIL | First add `neware` vendor and Neware raw format literals with negative tests. Then add fixtures for known Neware CSV/XLSX variants; assert sign, units, timebase, cycle/step identifiers, and schema output. | Equipment record with `vendor: neware`; raw software/export version; file formats and extensions; exact current sign convention evidence; time axis kind; channel/cell IDs; source ledger, hashes, license, retrieval date, and parser lineage. |
| Unknown or generic raw export | FAIL until reviewed | Must not infer vendor from filename alone. Require manual review or source documentation; parser must emit explicit `unknown` confidence when vendor remains unknown; all signal, sign, time, row-status, and leakage tests still apply. | `vendor: unknown`, `confidence: unknown` or evidence-backed level, notes explaining why vendor is unknown, observed raw columns, units, sign/time evidence, and source ledger. |
| Raw staging table | SPEC REQUIRED | Parser must emit source row id, archive member, sheet/table, channel, native timestamp, native cycle/step, raw voltage/current/temperature, normalized fields, row status, and drop reason. Unit tests must include malformed rows and repeated/nonfinite timestamps. | Staging schema version, parser commit, raw file digest, row count in/out, dropped-row counts by reason, source column mapping, unit conversion policy, sign normalization policy, interpolation/resampling policy. |
| Tier 2 Parquet | CONDITIONAL | Validate strict field names/types against `bsebench-specs` where possible, or record an explicit compatibility exception; sample rows must validate `time_s`, `voltage_V`, `current_A`, `temperature_C`, optional `capacity_Ah`, `soc_truth`, `soh_truth`; per-cell time monotonicity must be tested. | Dataset id, cell id, chemistry, profile, temperature, source URL, license, Tier 2 schema version, writer version, raw and staging digests, BPX current convention, optional truth field basis, and transformation notes. |
| Loader trace | CONDITIONAL | Loader must prove `t = time_s - time_s[0]`, `I = -current_A`, `dt_s` finite/nonnegative where emitted, `N == len(t) == len(V) == len(I) == len(T_meas)`, and no `soc_truth`/`soh_truth` enters estimator inputs. | Loader version, cache root source, selected Tier 2 path, runtime identity (`cell_id`, `dataset`, `chemistry`, `source_url`), ambient and measured temperature basis, config tuple, and split identity. |
| SOC/SOH truth labels | FAIL until evidence-ready per dataset | Ground truth metadata audit must return `ready` for each accepted method; negative controls must fail missing reference capacity, missing initial SOC, unknown sign convention, missing timebase, missing integration rule, missing reset policy, and future-label leakage. | Method, reference capacity and source, initial SOC anchor and source, OCV curve/rest criterion if used, sign convention, timebase, integration rule, reset policy, retrieval date, split-scope leakage guard, and `uses_future_test_labels: false`. |
| Monthly availability row | CONDITIONAL | Snapshot row may report metadata availability only; it must not be used as proof that raw/Tier2 files are readable. If a row says Tier 2 available, loader-readability evidence must be linked separately. | Manifest/prospect source, status, HF Tier 1/Tier 2 repos if present, license, redistribution, access friction, blockers, chemistries, tasks, sampling rate, canonical URL/DOI, and snapshot month. |

## Pass/Fail Criteria

An ETL source passes universal acceptance only when all of these are true:

1. Source ledger is complete enough to identify raw files, archive members, hashes, license, retrieval date, and upstream citation or portal.
2. Equipment registry validates with a supported vendor or an explicitly justified `unknown`; Neware is not supported today.
3. Raw parser has source-family fixtures and negative controls for wrong sign, bad time axis, missing temperature, malformed rows, and missing required columns.
4. Current sign convention is documented and tested with either source documentation or an identified voltage-trend segment.
5. `time_s`, `dt_s`, `V`, `I`, `T`, and `N` are deterministic, finite, length-consistent, and convention-checked at both Tier 2 and loader layers.
6. Tier 2 output validates against strict `bsebench-specs` schema, or a tracked compatibility exception blocks universal readiness.
7. SOC/SOH target fields are marked target-only and backed by ground-truth metadata audit before scoring.
8. Split metadata declares leakage boundary, calibration policy, evaluation task, config-id fields, and freeze date before public comparison.
9. Availability snapshots are linked to loader-readability probes and do not stand in for data validation.

## Findings

- Arbin has the strongest current evidence because CALCE A123 and CALCE INR-20R adapters already parse Arbin-shaped inputs and preserve BPX-aligned negative discharge current.
- Maccor has schema-level registry support but no inspected production parser, fixture, or loader path. It should be treated as not ETL-ready.
- Neware is currently blocked by the equipment registry. A Neware source cannot pass the raw equipment gate without adding a deliberate vendor and format schema update.
- The D1 ETL contract is necessary but narrower than full `bsebench-specs` canonical Parquet. Existing adapters that write only the four core signal columns must either be upgraded or explicitly marked as compatibility exceptions before universal acceptance.
- Source ledger, dataset card, ground-truth metadata, split metadata, and monthly availability are separate gates. Passing one must not be reported as passing the others.
- The three prior usage-limit Wave 3 logs are accounted for and excluded from ETL evidence. They do not affect this matrix because they are reproducibility, merge-queue, and triage/runbook tasks, not dataset ETL outputs.

## Recommendations

1. Add a real `equipment_registry.yaml` or equivalent registry fixture with Arbin CALCE records backed by raw file hashes and evidence pointers.
2. Add Neware intentionally, with `neware_csv`/`neware_xlsx` or a narrower set of observed formats, rather than mapping it to `unknown`.
3. Add a Maccor parser spike only after obtaining a representative raw fixture and source documentation for columns, units, and sign convention.
4. Promote a shared raw staging schema so every vendor parser reports row lineage and drop reasons before writing Tier 2.
5. Add a dataset acceptance CI target that runs: equipment registry validation, raw fixture parser tests, strict Tier 2 schema checks, loader trace checks, ground-truth audit, leakage negative controls, and `git diff --check`.
6. Treat monthly availability rows as report metadata only unless linked to a specific loader-readability artifact and immutable commit SHA.

## Residual Risks

- This artifact did not execute real Arbin, Maccor, or Neware raw files. It inspected code, logs, and schemas and defines acceptance gates.
- Some inspected repositories have unrelated local changes, especially `bsebench-specs`; no changes were made there.
- Branch heads may advance after this audit. The commit SHAs above are the evidence points used for this matrix.
- Existing dataset adapters may pass their local tests while still missing strict universal source-ledger or full canonical Parquet requirements.
- Raw cycler exports vary by software version, locale, and user export settings; one fixture per vendor is not sufficient for broad support.

## Explicit Non-Claims

- This artifact does not claim BSEBench currently supports all Arbin, Maccor, or Neware exports.
- This artifact does not claim any SOC, SOH, voltage, runtime, leaderboard, novelty, or state-of-the-art result.
- This artifact does not validate any scientific claim or update any claim registry.
- This artifact does not assert public dataset availability beyond local metadata evidence.
- This artifact does not replace dataset implementation work; it defines gates that future ETL work must satisfy before benchmark use.
