# Phase 28 Dataset Micro-Slice Report

Date: 2026-05-10
Phase: 28
Status: CLOSED
Verdict: PASS for real dataset micro-slice selection, NO_CLAIM for benchmark results

## Objective

Bind the benchmark path to real harmonized dataset evidence by selecting a minimal Audit J micro-slice.

This phase verifies dataset identity and loader-declared availability only. It does not load traces, download files, run filters, compute KPIs, or rank methods.

## Definition Of Done

- A Phase 28 micro-slice module exists in `bsebench-runner`.
- The source split is the real `audit_j_v1` split from `bsebench-datasets`.
- The selected slice contains one config per Audit J wrapper.
- Each selected config exists in the split.
- Each selected config is declared available by its loader.
- No trace loads or downloads are performed.
- Manifest, tests, lint, whitespace checks, and artifact hash pass.

## Implementation

Repository: `bsebench-runner`

Added files:

- `src/bsebench_runner/phase28_dataset_micro_slice.py`
- `scripts/phase28_dataset_micro_slice.py`
- `tests/test_phase28_dataset_micro_slice.py`
- `outputs/phase28_dataset_micro_slice_20260510.json`

Updated file:

- `src/bsebench_runner/__init__.py`

## Selected Micro-Slice

Source split:

- split id: `audit_j_v1`
- total configs: `26`
- selected configs: `7`
- excluded configs: `19`
- policy: one config per Audit J wrapper

Selected configs:

| Wrapper | Profile | Temperature C | Loader | Declared available |
|---|---|---:|---|---:|
| `calce_legacy` | `DST` | 25 | `CalceLegacyLoader` | yes |
| `calce_a123_dyn` | `DST` | 20 | `CalceA123DynLoader` | yes |
| `panasonic` | `US06` | 10 | `PanasonicKollmeyerLoader` | yes |
| `nasa` | `CC-discharge` | 24 | `NasaPcoeLoader` | yes |
| `lg_hg2` | `WLTC_P066` | 25 | `LgHg2Stroebl2024Loader` | yes |
| `yao` | `BCDC` | 35 | `YaoTuBerlin2024Loader` | yes |
| `calce_inr_dyn` | `DST` | 25 | `CalceInr20RLoader` | yes |

Manifest summary:

```json
{
  "schema_version": "phase28_dataset_micro_slice_v1",
  "phase": 28,
  "status": "ready_for_phase29_micro_run",
  "claim_status": "NO_CLAIM",
  "selected_config_count": 7,
  "excluded_config_count": 19,
  "blockers": []
}
```

## Guardrails

The manifest records:

- `loads_performed: false`
- `downloads_performed: false`
- `benchmark_executed: false`
- `ranking_authorized: false`

This matters because Phase 28 is a dataset-binding gate, not an execution phase.

## Validation

Commands executed in `bsebench-runner`:

```bash
uv run ruff format src/bsebench_runner/phase28_dataset_micro_slice.py scripts/phase28_dataset_micro_slice.py tests/test_phase28_dataset_micro_slice.py src/bsebench_runner/__init__.py
uv run ruff check src/bsebench_runner/phase28_dataset_micro_slice.py scripts/phase28_dataset_micro_slice.py tests/test_phase28_dataset_micro_slice.py src/bsebench_runner/__init__.py
uv run python scripts/phase28_dataset_micro_slice.py --output outputs/phase28_dataset_micro_slice_20260510.json --split-path ../bsebench-datasets/splits/audit_j_v1.yaml
uv run pytest tests/test_phase28_dataset_micro_slice.py tests/test_default_adapters.py -q
git diff --check
```

Results:

- Ruff format: passed.
- Ruff check: passed.
- Micro-slice manifest generation: passed.
- Micro-slice status: `ready_for_phase29_micro_run`.
- Tests: `30 passed, 1 skipped`.
- Skip reason: HF slow adapter loading test skipped because `BSEBENCH_RUN_HF_SLOW` was not set.
- Whitespace check: passed.

Artifact hash:

```text
aa3bf8cc82ceb87edf46a6900f4381123e589c56a9bf72b70225607d92bba975  outputs/phase28_dataset_micro_slice_20260510.json
```

## Scientific Guardrails

This phase does not prove model performance or dataset trace readability. It proves that the planned real-data micro-slice is grounded in the canonical split and loader metadata.

The next phase must still handle trace loading and may encounter file/cache/HF issues. Those must be logged as execution blockers, not hidden.

## Next Phase

Phase 29 should have one objective:

Run the three-family panel on the Phase 28 real dataset micro-slice with a strict sample cap and record raw evidence, sentinel cells, and failure traces. KPI/ranking/BSE-Score claims remain blocked.
