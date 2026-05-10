# Phase 32 Tier 2 Overlay Remediation

Date: 2026-05-10
Status: CLOSED WITH RESIDUAL BLOCKERS
Runner commit: `d4b6eea`
Claim status: `NO_CLAIM`

## Objective

Reduce Phase 31 dataset-access blockers by using legitimate local Tier 2 cache roots and by harmonizing available raw mirrors into the exact Parquet files expected by current loaders.

## Work Performed

Existing local Tier 2 caches were activated:

- `BSEBENCH_CALCE_A123_DYN_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase9-local-cache/calce_a123_dyn_20260509`
- `BSEBENCH_CALCE_INR_DYN_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase9-local-cache/calce_inr_dyn_20260509`

New targeted raw downloads were performed from HF:

- LG HG2 raw: `bsebench-org/lg-hg2-stroebl-2024-raw/cell_logext_P066_1_S02_C03_truncated.csv`
- Yao raw: `bsebench-org/yao-tu-berlin-2024-raw/yao_tu_berlin.zip`
- Panasonic raw: `bsebench-org/panasonic-18650pf-kollmeyer-2018-raw/.../03-27-17_09.06 10degC_US06_Pan18650PF.mat`

Existing harmonizers were used:

- `LgHg2Stroebl2024Adapter(param_ids=[66], reps=[1], stages=[2])`
- `YaoTuBerlin2024Adapter(cycles=["BCDC"], temps=[35])`
- `PanasonicKollmeyer2018Adapter()`

New local Tier 2 files produced:

- `/mnt/c/doctorat/bsebench-org/.phase32-local-cache/lg_hg2_tier2_20260510/lg_P066_rep1_S02.parquet`
- `/mnt/c/doctorat/bsebench-org/.phase32-local-cache/yao_tier2_20260510/Yao-BCDC-T35.parquet`
- `/mnt/c/doctorat/bsebench-org/.phase32-local-cache/panasonic_tier2_20260510/pan_US06_T10.parquet`

The local cache directories are not committed. The evidence JSONs and reproduction commands are committed.

## Results

Phase 31 progression:

```text
before auth:             load_proven=0/7, Phase 29 sentinels=21/21
after HF auth:           load_proven=1/7, Phase 29 sentinels=19/21
after phase9 caches:     load_proven=3/7, Phase 29 sentinels=14/21
after Phase 32 overlay:  load_proven=6/7, Phase 29 sentinels=8/21
```

Phase 32 final loader status:

| Config | Loader status | Notes |
|---|---|---|
| `calce_legacy:DST:T25` | failed | No local source or Tier 2 Parquet found. Do not substitute dynamic CALCE. |
| `calce_a123_dyn:DST:T20` | loaded, `N=7303` | via Phase 9 local cache |
| `panasonic:US06:T10` | loaded, `N=42000` | via Phase 32 harmonized local cache |
| `nasa:CC-discharge:T24` | loaded, `N=197` | via authenticated HF |
| `lg_hg2:WLTC_P066:T25` | loaded, `N=568041` | via Phase 32 harmonized local cache |
| `yao:BCDC:T35` | loaded, `N=223058` | via Phase 32 harmonized local cache |
| `calce_inr_dyn:DST:T25` | loaded, `N=12561` | via Phase 9 local cache |

Phase 29 final matrix after Phase 32 overlay still has 8 sentinels:

- 3 loader sentinels: `calce_legacy` for all three filters.
- 5 filter-step sentinels: `EKF` on each loaded non-CALCE-legacy config except `calce_a123_dyn`, caused by out-of-bounds SOC contract failures.

## Artifact Hashes

| Artifact | SHA-256 |
|---|---|
| `outputs/phase31_hf_access_proof_20260510_local_cache_overlay.json` | `1842547583f782f84a96073061000041d89b68b17d2d167615e689d3c2f7bc23` |
| `outputs/phase29_real_micro_run_20260510_local_cache_overlay.json` | `d941a06830671809c87f307b9d1d224e63d710f91cfb2628db5bf6a0a818a069` |
| `outputs/phase31_hf_access_proof_20260510_phase32_tier2_overlay.json` | `9b6b84fd25090f873632807f27b8a2f2b08dad6b50c902f954e5023ebf667c0a` |
| `outputs/phase29_real_micro_run_20260510_phase32_tier2_overlay.json` | `b0af6ca21fed946785ad6d8b3f59a9fec508f494d2b7b18fe85a4994331f4640` |

## Validation

Previously executed after Phase 31 code addition:

```bash
uv run pytest tests/test_phase29_real_micro_run.py tests/test_phase31_hf_access_proof.py
uv run ruff check src/bsebench_runner/phase31_hf_access_proof.py scripts/phase31_hf_access_proof.py tests/test_phase31_hf_access_proof.py
git diff --check
```

Result:

```text
7 passed
All checks passed
git diff --check clean
```

Secret scan on Phase 32 committed artifacts found no raw HF token.

## Reproduction Commands

Use the same authenticated HF cache, then export:

```bash
export BSEBENCH_CALCE_A123_DYN_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase9-local-cache/calce_a123_dyn_20260509
export BSEBENCH_CALCE_INR_DYN_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase9-local-cache/calce_inr_dyn_20260509
export BSEBENCH_PANASONIC_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase32-local-cache/panasonic_tier2_20260510
export BSEBENCH_LG_HG2_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase32-local-cache/lg_hg2_tier2_20260510
export BSEBENCH_YAO_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase32-local-cache/yao_tier2_20260510
```

Then rerun:

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-runner
uv run python scripts/phase31_hf_access_proof.py \
  --output outputs/phase31_hf_access_proof_20260510_phase32_tier2_overlay.json \
  --micro-slice-manifest outputs/phase28_dataset_micro_slice_20260510.json

uv run python scripts/phase29_real_micro_run.py \
  --output outputs/phase29_real_micro_run_20260510_phase32_tier2_overlay.json \
  --micro-slice-manifest outputs/phase28_dataset_micro_slice_20260510.json \
  --checkpoints-dir data/audit_j_v1/checkpoints \
  --n-max 32
```

## Scientific Interpretation

Phase 32 turns the blocker from a broad dataset-access failure into two narrow issues:

1. `calce_legacy` still lacks a valid Tier 2 source for the selected micro-slice.
2. `EKF` is not contract-safe on most real loaded traces because it can emit SOC outside `[0, 1]`.

The pipeline has enough real data loaded to continue diagnostic work, but still cannot produce benchmark claims or a BSE-Score.

## Next Phase

Recommended Phase 33:

Goal: separate diagnostic bounded-projection execution from claim-eligible raw method execution.

Definition of Done:

- run a diagnostic panel where `EKF` is wrapped by the existing `Phase10BoundedProjectionAdapter`;
- preserve raw `EKF` failure traces as the claim-eligible truth;
- mark projected results `claim_eligible=false`;
- prove whether remaining Phase 29 sentinels are only `calce_legacy` loader failures;
- do not rank methods or compute BSE-Score.
