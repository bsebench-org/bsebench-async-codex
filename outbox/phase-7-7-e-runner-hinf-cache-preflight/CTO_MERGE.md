# CTO Merge: phase-7-7-e-runner-hinf-cache-preflight

Status: approved and pushed

Actor: codex-cto-FR

UTC: 2026-05-07T03:50:06Z

## Context

Strict Phase 7.7 Hinf residual evidence still cannot be run honestly because
the current machine lacks Hugging Face auth and has incomplete local Tier 2
caches. The project needs a reproducible preflight that says whether the exact
strict 5-config target is ready before any evidence command is launched.

## Change

Repository: `bsebench-runner`

Commit: `2a8c7456e6de4bd82dec5379cecf95054f5139bf`

Subject: `GLASSBOX [role: codex-cto-FR] Add strict Hinf cache preflight`

Pushed to: `origin/main`

Changed files:

- `scripts/hinf_residual_cache_preflight.py`
- `tests/test_hinf_residual_cache_preflight.py`

The script checks exact local cache readiness for the strict Hinf residual 5x5
target without running filters, downloading from Hugging Face Hub, or producing
benchmark evidence.

Strict expected files:

- `Yao-BCDC-T25.parquet`
- `Yao-US06-T25.parquet`
- `pan_US06_T25.parquet`
- NASA `metadata.csv` plus metadata-selected `{battery_id}_test{test_id}.parquet`
- `calce_a123_DST_T25.parquet`

## Validation

Local CTO gates:

- `uv run --locked --all-extras pytest tests/test_hinf_residual_cache_preflight.py -q --tb=short`
  - `5 passed`
- `uv run --locked --all-extras ruff check src scripts tests`
  - pass
- `uv run --locked --all-extras ruff format --check src scripts tests`
  - pass
- `uv run --locked --all-extras pytest -m 'not slow' -q --tb=short`
  - `96 passed, 5 deselected`
- `git diff --check`
  - pass

Real local diagnostic run:

```bash
uv run --locked --all-extras python scripts/hinf_residual_cache_preflight.py \
  --no-output --allow-missing \
  --cache-root yao=/tmp/bsebench_yao_tier2_cache \
  --cache-root panasonic=/mnt/c/doctorat/bsebench-org/_datasets \
  --cache-root nasa=/mnt/c/doctorat/bsebench-org/_datasets \
  --cache-root calce_legacy=/mnt/c/doctorat/bsebench-org/_datasets
```

Observed:

- `ok_configs=1`
- `missing_configs=4`
- `evidence_ready=False`

Independent validators:

- `Poincare`: read-only data availability audit confirmed only `1/5` strict
  configs exists locally and scoped raw material cannot produce the four missing
  strict targets without HF/raw acquisition.
- `Ohm`: GO on commit `2a8c745`; confirmed diagnostic-only semantics, strict
  filenames, fail-loud exit behavior, no output/claim/thesis/roadmap change,
  and no secret token exposure.

## Scope Boundary

This is diagnostic tooling only. No output JSON was committed. No Hinf evidence
was produced. No claim, thesis prose, or roadmap text was changed. The strict
requirement remains `5 configs / 25 filter runs`.

## Next Step

Do not run or accept Hinf residual evidence until this preflight reports
`evidence_ready=True` for all five strict configs. If HF auth remains
unavailable, acquire or restore the exact missing Tier 2 files or the exact raw
sources needed to create them.
