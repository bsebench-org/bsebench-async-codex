# Phase diag-hf-cache-auth-20260507T032519Z summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 5 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-async-codex
- Target branch : diag/hf-cache-auth-20260507T032519Z
- Branch SHA : d997ebf3190eccd41a5bb2159e65e082e30bb1c9
- Push result : not-attempted
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T05:31:35+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
**Loader / Cache Probe**
- Yao BCDC/US06 T25
  - HF repo: `bsebench-org/yao-tu-berlin-2024`
  - local `available_configs()`: success, no network
  - configs found: `[('BCDC', 25.0)]`
  - BCDC T25 present: yes
  - US06 T25 present: no

- Panasonic US06 T25
  - HF repo: `bsebench-org/panasonic-kollmeyer-2018`
  - local `available_configs()`: success, no network
  - configs found: `[]`
  - target present: no

- NASA B0005 T24 / CC-discharge
  - HF repo: `bsebench-org/nasa-pcoe-saha-goebel-2007`
  - `available_configs()`: success, no network, returns `[('CC-discharge', 24.0)]`
  - local `metadata.csv`: missing

- CALCE A123 DST T25 legacy
  - HF repo: `bsebench-org/calce-a123-2014`
  - `available_configs()`: success, no network, returns `[('DST', 0.0), ('DST', 25.0), ('DST', 40.0)]`
  - local `calce_a123_DST_T25.parquet`: missing

**Diagnosis**
`mixed`

The prior strict real 5x5 run used the default runner registry, which instantiates HF-backed loaders without local cache roots. With no HF token configured and no HF hub cache, every missing dataset had to go through `hf_hub_download`, producing the observed `401` / `RepositoryNotFoundError` / auth failures. Local fallback is also incomplete: only Yao BCDC T25 exists locally, while Yao US06, Panasonic, NASA metadata/data, and CALCE legacy Parquet are missing.
tokens used
74,259
Read-only diagnostic complete.

**Repo SHAs**
- `bsebench-runner`: `13ec00459341fe380f7fcb6864232ef8ee12fc0f`
- `bsebench-datasets`: `a941b4a0538f53e4b9055d226af269f67f747a30`

**HF Auth**
- `HF_TOKEN` set: no
- `HUGGINGFACE_HUB_TOKEN` set: no
- `~/.cache/huggingface/token` exists: no
- `huggingface-cli whoami`: unavailable

**Local Caches**
- `/mnt/c/doctorat/bsebench-org/_datasets`: `157M`
- `/tmp/bsebench_yao_tier2_cache`: `3.3M`
- `/tmp/bsebench_panasonic_tier2_cache`: missing
- `/tmp/bsebench_nasa_tier2_cache`: missing
- `/tmp/bsebench_calce_legacy_tier2_cache`: missing
- `~/.cache/huggingface/hub`: missing

`/tmp/bsebench_yao_tier2_cache` contains only `Yao-BCDC-T25.parquet`. `_datasets` contains raw CALCE zip bundles, not the harmonized Parquet files the Tier 2 loaders expect.

**Loader / Cache Probe**
- Yao BCDC/US06 T25
  - HF repo: `bsebench-org/yao-tu-berlin-2024`
  - local `available_configs()`: success, no network
  - configs found: `[('BCDC', 25.0)]`
  - BCDC T25 present: yes
  - US06 T25 present: no

- Panasonic US06 T25
  - HF repo: `bsebench-org/panasonic-kollmeyer-2018`
  - local `available_configs()`: success, no network
  - configs found: `[]`
  - target present: no

- NASA B0005 T24 / CC-discharge
  - HF repo: `bsebench-org/nasa-pcoe-saha-goebel-2007`
  - `available_configs()`: success, no network, returns `[('CC-discharge', 24.0)]`
  - local `metadata.csv`: missing

- CALCE A123 DST T25 legacy
  - HF repo: `bsebench-org/calce-a123-2014`
  - `available_configs()`: success, no network, returns `[('DST', 0.0), ('DST', 25.0), ('DST', 40.0)]`
  - local `calce_a123_DST_T25.parquet`: missing

**Diagnosis**
`mixed`

The prior strict real 5x5 run used the default runner registry, which instantiates HF-backed loaders without local cache roots. With no HF token configured and no HF hub cache, every missing dataset had to go through `hf_hub_download`, producing the observed `401` / `RepositoryNotFoundError` / auth failures. Local fallback is also incomplete: only Yao BCDC T25 exists locally, while Yao US06, Panasonic, NASA metadata/data, and CALCE legacy Parquet are missing.
```

## Next step for chef

Investigate the failure mode in run.log.tail and the push stderr above. Re-queue with corrections if recoverable.
