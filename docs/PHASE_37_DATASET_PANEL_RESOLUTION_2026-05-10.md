# Phase 37 Dataset Panel Resolution

Date: 2026-05-10
Status: CLOSED
Runner commit: `f062f2e`
Claim status: `NO_CLAIM`

## Objective

Resolve the last Phase 36 blocker:

```text
calce_legacy-DST-T25
```

The decision had to be scientific and auditable: either find a legitimate legacy Tier 2 source, or formally exclude the config without substituting a different CALCE dataset.

## Definition Of Done

- Verify the Phase 36 failures are exactly the three loader failures on `calce_legacy-DST-T25`.
- Preserve the distinction between `calce_legacy` and CALCE dynamic datasets.
- Record why the config is excluded from the current claimable micro-panel.
- Build a reduced micro-slice manifest with no silent replacement.
- Rerun Phase 36 on the reduced panel.
- Keep ranking and BSE-Score disabled.
- Validate with tests, Ruff, whitespace checks, and secret scan.

## Evidence

Phase 36 remaining failures were exactly:

```text
EKF_projected:loader_failed:RepositoryNotFoundError count=1
GRU_light:loader_failed:RepositoryNotFoundError count=1
SO_SMO:loader_failed:RepositoryNotFoundError count=1
```

All were on:

```text
calce_legacy-DST-T25
```

The expected Tier 2 object was:

```text
bsebench-org/calce-a123-2014/calce_a123_DST_T25.parquet
```

The resolution record documents:

- HF Tier 2 repo/object inaccessible for the expected legacy file.
- `calce_a123_DST_T25.parquet` absent from local workspace caches.
- raw legacy source `A123_25C.csv` absent locally.
- accessible related CALCE repos are dynamic or other CALCE families, not the legacy Tier 2 object.

## Decision

`calce_legacy:DST:T25` is formally excluded from the current resolved micro-panel:

```text
decision=exclude_without_substitution
scope=phase37_resolved_micro_slice_only
```

Explicit non-substitutions:

```text
calce_a123_dyn:DST:T25
calce_inr_dyn:DST:T25
calce-a123-lfp-dynamic-raw
```

Future reinstatement condition:

```text
Reinstate only if calce_a123_DST_T25.parquet is produced from A123_25C.csv
through the legacy adapter, or if a matching Tier 2 repo becomes accessible.
```

## Implementation

Added to `bsebench-runner`:

```text
src/bsebench_runner/phase37_dataset_panel_resolution.py
scripts/phase37_dataset_panel_resolution.py
tests/test_phase37_dataset_panel_resolution.py
outputs/phase37_dataset_panel_resolution_20260510.json
outputs/phase37_resolved_micro_slice_20260510.json
outputs/phase36_amended_micro_run_20260510_phase37_resolved_panel.json
```

The Phase 37 builder blocks unless the input run is exactly the expected state:

```text
status=amended_micro_run_completed_with_blockers
sentinel_cell_count=3
failure_trace_count=3
filter_names=[EKF_projected, GRU_light, SO_SMO]
failure_config=calce_legacy-DST-T25
failure_stage=loader
failure_reason=loader_failed
failure_type=RepositoryNotFoundError
```

## Resolved Panel

The reduced manifest contains six configs:

```text
calce_a123_dyn-DST-T20
panasonic-US06-T10
nasa-CC-discharge-T24
lg_hg2-WLTC_P066-T25
yao-BCDC-T35
calce_inr_dyn-DST-T25
```

No replacement config was inserted for `calce_legacy:DST:T25`.

## Resolved Rerun

Command used with Phase 9 / Phase 32 local caches:

```bash
uv run python scripts/phase36_amended_micro_run.py \
  --output outputs/phase36_amended_micro_run_20260510_phase37_resolved_panel.json \
  --micro-slice-manifest outputs/phase37_resolved_micro_slice_20260510.json \
  --checkpoints-dir data/audit_j_v1/checkpoints \
  --amendment-artifact ../bsebench-specs/outputs/phase35_method_panel_amendment_20260510.json \
  --n-max 32
```

Result:

```text
status=amended_micro_run_completed
sentinel_cell_count=0
failure_trace_count=0
blockers=[]
```

Filter order:

```text
EKF_projected, GRU_light, SO_SMO
```

## Artifact Hashes

| Artifact | SHA-256 |
|---|---|
| `bsebench-runner/outputs/phase37_dataset_panel_resolution_20260510.json` | `f598bbf75641e3b952c14c33bda22934ccdaf142e3606fe4e10e477ad0fa0c0f` |
| `bsebench-runner/outputs/phase37_resolved_micro_slice_20260510.json` | `dd75cdb5b961491e9d1e8266c0f2aba1b4a71dd6058e29c7ebfc9d5a276c8cb5` |
| `bsebench-runner/outputs/phase36_amended_micro_run_20260510_phase37_resolved_panel.json` | `0e800b813de2c70854f57f0b9a1a5ed6f9a7748aa3aab92b270b42ce6f7f2e9e` |

## Validation

Executed in `bsebench-runner`:

```bash
uv run pytest tests/test_phase37_dataset_panel_resolution.py
uv run pytest tests/test_phase25_three_family_panel.py tests/test_phase29_real_micro_run.py tests/test_phase33_diagnostic_projection_run.py tests/test_phase36_amended_micro_run.py tests/test_phase37_dataset_panel_resolution.py
uv run ruff check src/bsebench_runner/phase37_dataset_panel_resolution.py scripts/phase37_dataset_panel_resolution.py tests/test_phase37_dataset_panel_resolution.py
git diff --check
```

Result:

```text
4 passed
19 passed
Ruff: All checks passed
git diff --check: clean
strict token scan: no raw Hugging Face token found
```

## Scientific Interpretation

Phase 37 removes the dataset-access confound from the current executable micro-panel. The panel is now runnable end-to-end across three method families on six real configs, with zero sentinels and zero failure traces.

This does not authorize a headline ranking or BSE-Score yet. The resolved panel is reduced, and the scoring policy must explicitly account for the formal exclusion before any aggregate claim is made.

The key scientific point is that `calce_legacy` was not replaced by a convenient dynamic CALCE source. The exclusion is conservative and reversible only if the true legacy Tier 2 artifact becomes available.

## Next Phase

Recommended Phase 38: build the score-readiness gate for the resolved six-config panel.

Definition of Done:

- consume the Phase 37 resolved run;
- verify all methods and configs are complete;
- compute or stage the precision, latency, compute-cost, and robustness KPI inputs only where measured;
- explicitly block missing KPI categories instead of filling them;
- define whether reduced-panel BSE-Score is still blocked or can be computed as a clearly labelled reduced-panel diagnostic;
- keep any ranking labelled as non-final until the scoring contract is closed.
