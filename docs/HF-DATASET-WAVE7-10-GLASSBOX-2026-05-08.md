# HF Dataset Waves 7-10 GLASSBOX - 2026-05-08

This note records the dataset-orchestration decisions made from
`DatasetNameID-ProvidingInstitutionAuthors-Chemistr_part4.csv`,
`part5.csv`, `part6.csv`, and `part7.csv`.

## Snapshot

- Time: 2026-05-08T13:28:20+02:00.
- Authenticated Hugging Face dataset count for `bsebench-org`: 107.
- Active dataset `codex exec` workers after wave10 launch: 14.
- Local durable decisions/specs:
  - `/mnt/c/doctorat/bsebench-org/.codex-dataset-upload/wave7_part4_decisions.json`
  - `/mnt/c/doctorat/bsebench-org/.codex-dataset-upload/wave7_part4_specs.json`
  - `/mnt/c/doctorat/bsebench-org/.codex-dataset-upload/wave8_part5_decisions.json`
  - `/mnt/c/doctorat/bsebench-org/.codex-dataset-upload/wave8_part5_specs.json`
  - `/mnt/c/doctorat/bsebench-org/.codex-dataset-upload/wave9_part6_duplicate_decisions.json`
  - `/mnt/c/doctorat/bsebench-org/.codex-dataset-upload/wave10_part7_decisions.json`
  - `/mnt/c/doctorat/bsebench-org/.codex-dataset-upload/wave10_part7_specs.json`

## Wave7 - Part4

Launched 10 source-primary workers:

- `stanford-calendar-cycle-multisoc-eis-2026-raw`
- `cassino-lfp-eis-soc-2024-raw`
- `perugia-broadband-eis-soc-2022-raw`
- `vub-warburg-eis-2024-raw`
- `leonardi-30q-eis-degradation-modes-2025-raw`
- `unisa-cau-thermal-eis-ncr18650b-2025-raw`
- `warwick-rapid-soh-eis-ml-2023-raw`
- `tum-naumann-lfp-cycle-aging-2021-raw`
- `stanford-ev-real-driving-aging-2022-raw`
- `snu-single-point-critical-health-30q-2024-raw`

Skipped known duplicates/non-primary rows:

- Keysight/SINTEF EIS 21700 already exists as
  `keysight-sintef-eis-21700-2025-raw`.
- OpenDataBay EIS row is a non-primary duplicate of Perugia Mendeley
  DOI `10.17632/mbv3bx847g.3`.
- Mendeley `v8k6bsr6tf.1` already exists as
  `bit-panasonic-gotion-soh-2022-raw`.
- Tropical EV row already exists as `cameroon-tropical-aging-2026-raw`.
- Path-dependent degradation row was deferred because the exact source ID was
  not resolved cleanly.

Early worker confirmations observed:

- `stanford-calendar-cycle-multisoc-eis-2026-raw`: uploaded, private HF repo,
  CC-BY-4.0 basis from OSF relation, 61,075,451 source bytes.
- `perugia-broadband-eis-soc-2022-raw`: uploaded, private HF repo, CC BY 4.0,
  187,425 source bytes.
- `vub-warburg-eis-2024-raw`: uploaded, private HF repo, CC-BY-4.0, 656,132
  payload bytes.
- `leonardi-30q-eis-degradation-modes-2025-raw`: uploaded.
- `tum-naumann-lfp-cycle-aging-2021-raw`: uploaded.
- `warwick-rapid-soh-eis-ml-2023-raw`: uploaded.

## Wave8 - Part5

Launched 2 BatteryLife aggregate workers:

- `batterylife-processed-v10-2026-raw`
- `batterylife-raw-hf-2026-raw`

Important caveat: these are aggregate benchmark corpus mirrors, not independent
experimental campaigns. They may overlap individual BSEBench mirrors and must
not be double-counted in scientific claims.

Skipped/deferred rows from part5:

- Kaggle LG HG2, NASA PCoE, NASA-cleaned, Perugia EIS, and notebooks are
  mirrors/duplicates of primary sources already present or launched.
- Kaggle synthetic degradation and thermal-runaway data are not experimental
  raw BSEBench sources.
- Text-only HF corpora and information-extraction datasets are out of the
  current SOC/SOH/EIS/cycling raw-mirror scope.
- ECM feature dataset is derived and points back to the Stanford EV real-driving
  source launched in wave7.

## Wave9 - Part6

No workers launched. `part6.csv` is byte-identical to `part5.csv`:

`5bbd5bba509580c49a5221646cb0e9cab870872258d39d74b5566dac28b945dc`

## Wave10 - Part7

Launched 4 workers:

- `sakuu-stanford-limetal-continuous-cycling-2025-raw`
- `kit-naion-upscaling-formation-cycling-2023-raw`
- `e3power-pulsed-liion-chemistries-2022-raw`
- `sintef-dlr-fzj-battery-pipeline-2025-raw`

Source checks before launch:

- Sakuu/Stanford lithium-metal Data in Brief article identifies OSF DOI
  `10.17605/OSF.IO/5DQWG`; OSF API confirms a public node but no explicit node
  license. Worker is required to block payload upload unless redistribution
  terms are verified.
- KIT Na-ion upscaling Zenodo DOI `10.5281/zenodo.7981011` is CC-BY-4.0 and
  exposes `Na-upscaling.zip` around 660 MB through the Zenodo API.
- e3Power Fairdata/Etsin DOI
  `10.23729/38ae45ec-6b0b-4119-a3b8-a5100f0cef9b` is open with CC-BY-4.0 in
  metadata; worker must resolve official IDA/Fairdata download endpoints.
- SINTEF/DLR/FZJ pipeline dataset Zenodo DOI `10.5281/zenodo.17295469` is
  CC-BY-4.0, 12 files around 408 MB, useful for ETL/parser robustness rather
  than leaderboard performance claims.

Skipped/deferred rows from part7:

- BatteryLife Na-ion/Zn-ion/CALB subsets are covered by BatteryLife aggregate
  workers and existing subset repos; do not double-count.
- Energy Reports LTO ECM row needs a public data endpoint before upload.
- Na-ion literature meta-dataset is not raw time series.
- Nature solid-state AI article states full generated/analyzed data are
  available to qualified researchers on request; code is open but full raw
  cycling data are not openly downloadable.
- MDPI/e3Power supporting LTO row lacks a direct raw public endpoint.
- Shmuel De-Leon database is proprietary commercial-spec metadata, not raw
  BSEBench measurements.

## Guardrails

- Token-file-only HF access remains mandatory. Do not print or persist tokens.
- No SOTA, leaderboard, or benchmark-quality claims from raw mirrors.
- Repos with unclear license/access must upload blocked provenance only, not
  payload bytes disguised as a complete mirror.
- BatteryLife aggregate datasets must be labeled as aggregate corpora and
  deduplicated against individual source mirrors during any scientific count.
