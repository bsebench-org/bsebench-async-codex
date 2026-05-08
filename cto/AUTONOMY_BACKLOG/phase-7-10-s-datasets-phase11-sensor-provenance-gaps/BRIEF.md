---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-s-datasets-phase11-sensor-provenance-gaps
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.s - datasets Phase 11 sensor provenance gaps

You are a rigorous BSEBench dataset provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 11 sensor-noise versus model-mismatch work by auditing whether candidate loaders expose enough sensor/provenance metadata to support residual decomposition preflight decisions.

## Required behavior

- Active lane: Evidence generation, limited to provenance and readiness auditing.
- Add or extend a datasets-owned audit that enumerates Phase 11 candidate datasets/loaders and emits deterministic JSON with dataset identity, loader identity, local-cache status when available, voltage/current units, sampling cadence, sensor-noise metadata, preprocessing notes, provenance source, and explicit gap fields.
- Unknown metadata must be recorded as `unknown` or `not_available` with a reason; do not infer sensor precision, split identity, or provenance from memory.
- The audit must distinguish loader unavailable, cache missing, metadata missing, provenance source missing, and field present but unsupported by a stable source.
- Do not generate empirical filter evidence, modify caches, or commit local-machine paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, the roadmap, or manuscript prose.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 11 provenance audit.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements; any SOTA comparison requires a source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if the audit reports Phase 11 readiness while any required sensor/provenance field is missing, if unknown metadata is silently filled, if two distinct datasets collapse to the same identity, or if the JSON cannot tell metadata-missing from cache-missing.

## Validation

Run and record:

- focused tests for complete metadata, metadata unknown, cache missing, loader unavailable, duplicate identity, and unsupported provenance-source cases;
- `uv run --locked --all-extras python scripts/audit_phase11_sensor_provenance_gaps.py --output /tmp/phase11_sensor_provenance_gaps.json`;
- a real dry-run audit over the current candidate set that performs no downloads and no filter runs;
- `uv run --locked --all-extras pytest tests/test_phase11_sensor_provenance_gaps.py -q`;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
