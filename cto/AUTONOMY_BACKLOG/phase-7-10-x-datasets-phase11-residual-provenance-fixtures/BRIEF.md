---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-x-datasets-phase11-residual-provenance-fixtures
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.x - datasets Phase 11 residual provenance fixtures

You are a rigorous BSEBench dataset validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add fixture-level provenance checks for Phase 11 residual-decomposition readiness, especially voltage/current/SOC identity, sample-rate metadata, and sensor-noise metadata gaps.

## Roadmap mapping

- Phase 11: sensor-noise vs model-mismatch decomposition requires explicit measurement and provenance metadata.
- Phase 8 preparation: the same provenance fixtures help cross-dataset comparability before PCRLB/MAD interpretation.
- Validation infrastructure: missing metadata is a gap, not permission to infer readiness.

## Active lane

Evidence generation, validation infrastructure only. The handoff artifact is a dataset provenance fixture/checker report that distinguishes ready, gap, unsupported, and unknown states.

## Required behavior

- Add fixtures, metadata checks, or a lightweight provenance validator for residual-decomposition readiness.
- Required checks should cover voltage channel identity, current channel identity, SOC or target-state identity, sample-rate or timebase metadata, dataset/config identifier, and sensor-noise metadata when available.
- If sensor-noise metadata is unavailable, the output must mark it as a gap rather than inventing a value.
- The task must not run filters, alter raw datasets, or create claim-supporting empirical results.
- No thesis or claim registry edits are permitted.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 11 provenance task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if a dataset/config fixture can be marked Phase 11-ready while missing voltage/current/SOC identity, sample-rate or timebase metadata, dataset/config identity, or an explicit sensor-noise metadata value or gap marker.

## Validation

Run and record:

- focused tests for ready fixtures, missing voltage identity, missing current identity, missing SOC/target identity, missing timebase, missing dataset/config identity, and missing sensor-noise value-or-gap marker;
- a read-only fixture/provenance command over representative dataset metadata if available;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
