---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-u-runner-phase11-residual-contract-preflight
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.u - runner Phase 11 residual contract preflight

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 11 residual-decomposition work with a dry-run contract preflight that validates residual trace payload shape, dataset identity, filter identity, and stats compatibility before expensive runs are scheduled.

## Roadmap mapping

- Active lane: evidence generation validation.
- Supports Phase 11 sensor-noise versus model-mismatch decomposition and reuses Phase 7 residual trace lessons.
- Produces preflight tooling only; it does not change the scientific roadmap.

## Required behavior

- Add or extend a dry-run command that checks residual trace payload schema, voltage/residual dimensions, dataset/config identifiers, filter identifiers, stats package identity, and intended output paths without running filters.
- The preflight must distinguish dataset unavailable, cache/provenance missing, residual payload schema mismatch, non-finite values, filter unavailable, and stats dependency unknown.
- Output JSON must be deterministic, finite, and suitable for CI or worker pre-dispatch review.
- Do not generate new empirical evidence or commit local-machine paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 11 residual contract preflight.
- Do not make SOTA, novelty, leaderboard, breakthrough, verified-claim, or claim-promotion statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The preflight must block downstream scheduling if any Phase 11 candidate cannot be mapped to deterministic dataset provenance, a valid residual trace contract, a known filter set, and a known stats dependency identity.

## Validation

Run and record:

- focused tests for ready, dataset-missing, provenance-missing, schema-mismatch, non-finite, filter-missing, and stats-unknown cases;
- a real dry-run preflight over the current candidate set without running filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
