# HF Dataset Wave 3 GLASSBOX — 2026-05-08

Timestamp UTC: 2026-05-08T10:04:19Z

## Objective

Advance the BSEBench public/private Hugging Face dataset corpus toward the
symbolic +100 dataset target without fabricating provenance or benchmark
claims. This wave focuses on SOC/SOH/RUL/ECM-relevant public sources from
Mendeley Data, Zenodo, RWTH, Sandia, and BatteryArchive.

## Active State At Launch

- Hugging Face visible dataset count before wave 3 launch: 60.
- Existing upload workers still active: 3.
  - `kit-nmc-csio-aging-2024-raw`
  - `uconn-isu-ilcc-lfp-aging-2025-raw`
  - `oxford-21700-comprehensive-cycle-aging-2024-raw`
- Newly launched wave 3 Codex upload workers: 16.
- Total dataset Codex upload workers after launch: 19.
- Separate Sandia Preger export process active outside Codex upload workers.

## Wave 3 Workers

All workers use the standard token-file protocol and must create private HF
dataset repos first. Each worker is required to verify source URL, DOI, license,
duplicate status, file hashes, and file list before marking upload success.

1. `veeramsetty-ev-soc-2026-raw`
2. `malaya-liion-battery-test-2022-raw`
3. `trieste-calb-prismatic-drivecycle-2024-raw`
4. `snu-markov-rul-2025-raw`
5. `warwick-second-life-dm-2025-raw`
6. `lin-lfp-nmc-soh-rul-2021-raw`
7. `indiana-liion-impedance-soc-2022-raw`
8. `windsor-eis-soc-resttime-2025-raw`
9. `polimi-tub-lg18650he4-2024-raw`
10. `sr-engineering-ev-fault-diagnosis-2024-raw`
11. `bayreuth-degradation-path-indicators-2025-raw`
12. `turku-pack-thermal-gradient-2023-raw`
13. `mcmaster-lg-hg2-kollmeyer-2020-raw`
14. `rwth-isea-drive-cycle-aging-2021-raw`
15. `sandia-wittman-temp-degradation-2023-raw`
16. `offenburg-neural-ode-ecm-measurements-2022-raw`

## Sandia Preger 2020 Decision

The existing `bsebench-org/sandia-preger-2020-raw` HF repo contained only a
dataset card and no raw CSV payload. BatteryArchive's static FAQ says batch
downloads require contacting BatteryArchive, but public Redash dashboards expose
safe query exports for cell list, cycle summaries, and charted voltage traces.

Decision:

- Start a forensic BatteryArchive Redash export into
  `.hf-upload-stage/sandia-preger-2020-raw/batteryarchive_redash_export`.
- Record limitations explicitly: this is an official-public-dashboard export,
  not the original bulk per-cell CSV dump.
- After export finishes, upload it to the existing private HF repo with a
  dataset card status that does not overclaim completeness.
- Continue pursuing full bulk CSV source separately.

## Integrity Guardrails

- No public/SOTA benchmark claims are made by these uploads.
- Any unverified license or inaccessible source must result in blocked metadata,
  not a false success.
- Existing blocked entries remain preserved as evidence:
  `upc-wltp-pack-model3-2025-raw`, `poznan-nmc-2600mah-aging-2021-raw`,
  `bayreuth-panasonic-ncr18650b-cell-variation-2023-raw`,
  `virtual-vehicle-panasonic-ncr18650b-aging-2023-raw`.
- Secrets must remain token-file only and must not appear in logs.

## Immediate Next Actions

1. Monitor all 19 Codex workers and the Sandia export.
2. Archive/delete completed local staging directories after HF proof files are
   preserved.
3. Upload Sandia Preger Redash export once complete.
4. Prepare wave 4 from local CALCE caches and additional verified public
   sources, but launch only when worker capacity or failures justify it.
