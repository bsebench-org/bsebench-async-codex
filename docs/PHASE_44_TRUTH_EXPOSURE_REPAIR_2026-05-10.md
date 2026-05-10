# Phase 44 Truth Exposure Repair

Date: 2026-05-10
Status: CLOSED
Datasets commit: `8135a5f`
Claim status: `NO_CLAIM`

## Objective

Repair admissible state-truth exposure in `bsebench-datasets` so the runner can compute state metrics where ground truth exists and is scientifically authorized.

The phase targets only loader and adapter truth pass-through. It does not derive new truth, fabricate missing labels, or authorize a final BSE-Score.

## Definition Of Done

- Expose Yao raw SOC as canonical `soc_truth` after finite-value validation.
- Expose NASA `soh_truth` and `capacity_Ah` when finite values are present.
- Refuse NASA `soc_truth` when the local Tier 2 column exists but has no finite values.
- Keep LG `soc_est` rejected as BMS estimate, not ground truth.
- Emit a machine-readable validation artifact.
- Validate with unit tests, Ruff, whitespace check, and secret scan.

## Implementation

Added or updated in `bsebench-datasets`:

```text
src/bsebench_datasets/adapters/yao_tu_berlin_2024.py
src/bsebench_datasets/loaders/yao_tu_berlin_2024_loader.py
src/bsebench_datasets/loaders/nasa_pcoe_loader.py
src/bsebench_datasets/phase44_truth_exposure_validation.py
scripts/phase44_truth_exposure_validation.py
tests/test_loader_nasa_pcoe.py
tests/test_loader_yao_tu_berlin_2024.py
tests/test_phase44_truth_exposure_validation.py
outputs/phase44_truth_exposure_validation_20260510.json
```

The Yao adapter now reads raw `SOC`, validates finite content, and writes canonical `soc_truth` into Tier 2 parquet. The Yao loader exposes `soc_truth` only when the column exists and contains finite values.

The NASA loader now exposes optional finite columns through a shared finite-column helper. On the local NASA Phase 10 cache, `soh_truth` and `capacity_Ah` are admissible; `soc_truth` is present but contains no finite values and is therefore not exposed.

## Real Run

Command:

```bash
uv run python scripts/phase44_truth_exposure_validation.py \
  --output outputs/phase44_truth_exposure_validation_20260510.json \
  --yao-raw-root /mnt/c/doctorat/bsebench-org/.phase32-local-cache/yao_raw_20260510/extracted \
  --yao-output-dir /mnt/c/doctorat/bsebench-org/.phase44-local-cache/yao_tier2_truth_20260510 \
  --nasa-cache-root /mnt/c/doctorat/bsebench-org/.phase10-local-cache/nasa_pcoe_b0005_20260509
```

Result:

```text
status=truth_exposure_validation_completed
blockers=[]
ranking_authorized=False
bse_score_authorized=False
```

## Truth Verdict

| Dataset | Truth Field | Verdict | Evidence |
|---|---:|---|---|
| Yao BCDC T35 | `soc_truth` | exposed | 223058 finite values, min 0.037747889426472045, max 1.0 |
| NASA B0005 test2 | `soh_truth` | exposed | 197 finite values |
| NASA B0005 test2 | `capacity_Ah` | exposed | 197 finite values |
| NASA B0005 test2 | `soc_truth` | rejected | column has zero finite values |
| LG HG2 | `soc_est` | rejected | BMS estimate, not ground truth |

## Artifact Hashes

| Artifact | SHA-256 |
|---|---|
| `bsebench-datasets/outputs/phase44_truth_exposure_validation_20260510.json` | `d0cbc6dbd8d7f7d804a6645b1638cb16933e80d966b6d68d758b8df15fa12a80` |
| `.phase44-local-cache/yao_tier2_truth_20260510/Yao-BCDC-T35.parquet` | `6eaba472485e19c873dc9ffad6c689c328cf12c3e61bc69f81bb7ed0d1abdb63` |

## Validation

Executed in `bsebench-datasets`:

```bash
uv run pytest tests/test_loader_yao_tu_berlin_2024.py tests/test_loader_nasa_pcoe.py tests/test_phase44_truth_exposure_validation.py
uv run ruff check src/bsebench_datasets/adapters/yao_tu_berlin_2024.py src/bsebench_datasets/loaders/yao_tu_berlin_2024_loader.py src/bsebench_datasets/loaders/nasa_pcoe_loader.py src/bsebench_datasets/phase44_truth_exposure_validation.py scripts/phase44_truth_exposure_validation.py tests/test_loader_yao_tu_berlin_2024.py tests/test_loader_nasa_pcoe.py tests/test_phase44_truth_exposure_validation.py
git diff --check
rg -n "hf_[A-Za-z0-9]{20,}" . --glob '!uv.lock' --glob '!**/.venv/**'
```

Result:

```text
45 passed, 1 skipped
Ruff: All checks passed
git diff --check: clean
TOKEN_SCAN=OK
```

## Publication Note

Local datasets commit now ahead of origin:

```text
8135a5f GLASSBOX expose Phase 44 admissible truth fields
```

Push remains blocked by the local GitHub/WSL credential path. The commit is local and ready to publish once credentials are restored.

## Scientific Interpretation

Phase 44 converts two previously blocked truth sources into auditable loader outputs:

```text
Yao -> SOC truth available
NASA -> SOH truth available
```

This is still not a full benchmark-state solution. SOC truth remains unavailable across most resolved configs, SOH estimators are not yet present in the three-family method panel, and reduced-panel scoring policy is not frozen. Therefore BSE-Score and final ranking remain disabled.

## Next Path

Phase 45 must rerun a truth-aware benchmark using the repaired local Yao and NASA caches. The expected scientific result is partial authorization:

```text
SOC accuracy and max SOC error: available for the Yao truth subset
SOH accuracy and max SOH error: likely still blocked by missing SOH estimates
BSE-Score and ranking: still disabled
```
