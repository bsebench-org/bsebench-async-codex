# HF Dataset Wave 6 Part3 GLASSBOX Ledger

Date: 2026-05-08 12:35 Europe/Paris

Purpose: process `DatasetNameID-ProvidingInstitutionAuthors-Chemistr_part3.csv`
without duplicating already mirrored datasets, and launch only source-verifiable
SOC/SOH/safety datasets that materially expand BSEBench.

## Input

- Source CSV:
  `/mnt/c/doctorat/bsebench-org/DatasetNameID-ProvidingInstitutionAuthors-Chemistr_part3.csv`
- Rows parsed: 13.
- Decision file:
  `/mnt/c/doctorat/bsebench-org/.codex-dataset-upload/wave6_part3_decisions.json`
- Launch specs:
  `/mnt/c/doctorat/bsebench-org/.codex-dataset-upload/wave6_part3_specs.json`

## Decisions

Launched as new dataset workers:

- `rwth-jellyroll-deformation-2021-raw`: RWTH DOI
  `10.18154/RWTH-2021-04558`, low-SOC jelly-roll deformation, cycling plus CT
  archives. Worker verified the record is CC BY 4.0 and found nine source files
  totaling 44,525,118,339 bytes before starting the official download.
- `rwth-commercial-fleet-ev-battery-2024-raw`: RWTH DOI
  `10.18154/RWTH-2024-01907`, commercial EV fleet vehicle/battery field data.
  Worker verified CC BY 4.0 and official `Electric_Vehicle_and_Battery_Data.zip`.
- `stanford-second-life-grid-storage-2024-raw`: OSF DOI
  `10.17605/OSF.IO/8JNR5`, Stanford second-life INR21700-M50T grid-storage
  cycling data linked from Data in Brief DOI `10.1016/j.dib.2024.111046`.
- `tum-wildfeuer-vtc5a-aging-2023-raw`: mediaTUM DOI
  `10.14459/2023MP1713382`, TUM commercial Sony/Murata US18650VTC5A aging
  dataset; mediaTUM states CC BY 4.0 and exposes a 26 GB dataserv payload.

Skipped as already covered:

- RWTH 48-cell cyclic aging: already mirrored as
  `bsebench-org/rwth-ur18650e-cyclic-aging-2021-raw`.
- RWTH drive-cycle 28-cell NCA/C+Si: already present as
  `bsebench-org/rwth-isea-drive-cycle-aging-2021-raw`, but partial. A separate
  remediation worker was launched to upload the missing `TimeSeriesData.zip`.
- KIT NMC/C-SiO expanded description: already covered by the original,
  version-2 log-data, and fixed-EIS addendum workers.
- Multi-stage Samsung INR21700-50E aging: already mirrored as
  `bsebench-org/imperial-multistage-aging-2024-raw`.
- Battery Failure Databank and McMaster high-power dataset: already launched
  from part2.
- Sandia/BatteryArchive feature-engineering row: local Redash export already
  exists. A separate upload/remediation worker was launched instead of adding a
  duplicate dataset target.

Skipped as not a raw SOC/SOH/ECM mirror target:

- RWTH CARL portal index: portal-level page, handled by child datasets.
- Database of Battery Materials / ChemDataExtractor: material-property corpus,
  not a battery time-series or safety benchmark input for the current BSEBench
  raw mirror scope.

## Active Workers After Launch

Observed dataset workers: 11.

- `calce-cx2-prismatic-aging-raw`
- `kit-nmc-csio-aging-2024-raw`
- `kit-nmc-csio-aging-v2-logdata-2024-raw`
- `mcmaster-highpower-stochastic-2025-raw`
- `rwth-commercial-fleet-ev-battery-2024-raw`
- `rwth-isea-drive-cycle-aging-2021-raw` remediation
- `rwth-jellyroll-deformation-2021-raw`
- `sandia-preger-2020-raw` upload/remediation
- `shandong-deep-sorting-reused-2025-raw`
- `stanford-second-life-grid-storage-2024-raw`
- `tum-wildfeuer-vtc5a-aging-2023-raw`

## Hugging Face Snapshot

- Authenticated `bsebench-org` dataset count after part3 launch: 94.
- Public dataset count at snapshot: 20.
- New repos are created private first. Verified open-license workers may switch
  public only to bypass HF private LFS quota, and must record that exception in
  `FINAL_STATUS.json`.

## Guardrails

- No SOTA, leaderboard, benchmark-readiness, or validation claim is made by
  these raw mirrors.
- Workers must verify source identity, DOI, license, and official download path
  before uploading payload bytes.
- Unverified or blocked downloads must become blocked metadata records, not
  fake complete mirrors.
- Hugging Face token handling remains token-file-only:
  `/run/user/$(id -u)/bsebench/hf_token`.
