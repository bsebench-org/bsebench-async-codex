---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-al-datasets-phase11-unit-cadence-contract
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.al - datasets Phase 11 unit-cadence contract

You are a rigorous BSEBench datasets validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 11 sensor-noise versus model-mismatch decomposition by making voltage/current unit identity and sampling-cadence availability explicit before residual artifacts are trusted.

## Roadmap mapping

- Roadmap scope: Phase 11 sensor-noise versus model-mismatch decomposition and dataset provenance validation.
- Active lane: Evidence generation, limited to read-only metadata contract checks.
- Handoff artifact: deterministic unit/cadence contract report for candidate residual-decomposition datasets.

## Required behavior

- Reuse existing manifest, loader metadata, local-cache manifest, or provenance-audit helpers where practical.
- Add or extend a read-only command that reports voltage units, current units, timebase or sampling cadence, known missing fields, and whether each dataset can support Phase 11 residual decomposition without inferred metadata.
- The command must distinguish explicit metadata, missing metadata, loader-derived metadata, not-applicable fields, and unsafe filename-derived guesses.
- Output JSON must be finite and must include per-dataset readiness plus failure reasons suitable for runner preflight consumption.
- Do not download data, mutate caches, or commit local-machine absolute paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 11 unit-cadence contract.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a dataset without explicit voltage units, current units, timebase, or sampling cadence can be marked Phase 11 ready by inferring metadata from filenames or undocumented assumptions, the task must fail.

## Validation

Run and record:

- focused tests for explicit metadata, missing unit metadata, missing cadence metadata, loader-derived metadata, not-applicable fields, and filename-derived guess rejection;
- one read-only unit/cadence contract command against available manifests or local cache roots;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
