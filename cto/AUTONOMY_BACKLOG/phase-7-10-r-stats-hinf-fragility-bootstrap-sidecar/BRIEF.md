---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-r-stats-hinf-fragility-bootstrap-sidecar
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.r - stats Hinf fragility bootstrap sidecar

You are a rigorous BSEBench statistics validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Stress the existing strict Hinf residual-covariance/decomposition evidence for fragility using deterministic resampling over committed runner traces, without registering or verifying a scientific claim.

## Required behavior

- Active lane: Evidence generation, limited to stats-side fragility diagnostics over frozen artifacts.
- Add a stats-owned command that consumes `../bsebench-runner/outputs/hinf_residual_evidence_5x5.json`, uses deterministic seeds, and emits a JSON sidecar with config coverage, resample counts, interval summaries, unstable-comparison flags, and explicit skipped/unavailable reasons.
- The diagnostic must not rerun filters, download datasets, or mutate runner outputs; it may only read committed evidence traces and recompute stats-side summaries.
- Fragility must be expressed as neutral diagnostics such as `material_sensitivity_detected`, `stable_within_threshold`, or `insufficient_trace`, not as claim verification.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, the roadmap, or manuscript prose.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this fragility sidecar.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements; any SOTA comparison requires a source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if the sidecar can report success with zero eligible configs, non-deterministic resampling output for a fixed seed, unbounded or non-finite intervals, missing mismatch/skipped counters, or any text that upgrades the Hinf candidate from mechanical evidence to a scientific verdict.

## Validation

Run and record:

- focused tests for deterministic seed replay, zero-config failure, non-finite interval rejection, unstable-comparison reporting, insufficient-trace reporting, and forbidden verdict wording;
- `uv run --locked --all-extras python scripts/hinf_fragility_bootstrap_sidecar.py --evidence ../bsebench-runner/outputs/hinf_residual_evidence_5x5.json --resamples 200 --seed 20260507 --output /tmp/hinf_fragility_bootstrap_sidecar.json`;
- repeat the command above and prove the two JSON outputs are byte-stable or content-stable after deterministic timestamp removal;
- `uv run --locked --all-extras pytest tests/test_hinf_fragility_bootstrap_sidecar.py -q`;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
