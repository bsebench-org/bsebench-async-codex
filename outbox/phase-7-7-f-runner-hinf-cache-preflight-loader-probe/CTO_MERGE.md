# CTO Merge: phase-7-7-f-runner-hinf-cache-preflight-loader-probe

Status: approved and pushed

Actor: codex-cto-FR

UTC: 2026-05-07T03:56:34Z

## Context

The first strict Hinf cache preflight checked exact local file presence. That is
necessary but not sufficient: a present file can still be unreadable by the
adapter. `bsebench_specs.validate_parquet` is too strict for the current
loader-facing Tier 2 subset used by Yao, so the right acceptance check is
adapter-loader readability on the exact strict config.

## Change

Repository: `bsebench-runner`

Commit: `d2b94d8`

Subject: `GLASSBOX [role: codex-cto-FR] Probe loaders during Hinf cache preflight`

Pushed to: `origin/main`

Changed files:

- `scripts/hinf_residual_cache_preflight.py`
- `tests/test_hinf_residual_cache_preflight.py`

The preflight now:

- checks required file presence first;
- invokes the local default adapter loader for each config whose files exist;
- records loaded sample count and returned keys;
- reports `status=load_error` and keeps `evidence_ready=False` if the adapter
  cannot load the config;
- keeps `--no-loader-probe` as an explicit presence-only diagnostic mode only.

## Validation

Local CTO gates:

- focused preflight tests: `7 passed`
- full runner non-slow: `98 passed, 5 deselected`
- ruff check over `src scripts tests`: pass
- ruff format check over `src scripts tests`: pass
- `git diff --check`: pass

Real local diagnostic run with probes:

- `ok_configs=1`
- `missing_configs=4`
- `evidence_ready=False`
- `Yao BCDC T25` loader probe succeeds with `loaded_samples=216683`

Independent validator `Beauvoir`: GO.

Beauvoir confirmed:

- default behavior probes loader readability;
- load errors keep evidence readiness false;
- strict real cache remains incomplete at `1/5`;
- only preflight script/tests changed;
- no outputs, claims, thesis, or roadmap files changed;
- no secret token values exposed.

## Scope Boundary

Diagnostic tooling hardening only. No benchmark output was committed. No Hinf
evidence was approved. No claim, thesis prose, or roadmap text was changed.

## Next Step

The operational gate is now stricter: before any Hinf residual evidence run, the
preflight must report all five configs as `status=ok` with loader probes
enabled.
