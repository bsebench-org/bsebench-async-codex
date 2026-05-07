---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-u-runner-phase11-residual-manifest-dry-run
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.u - runner Phase 11 residual manifest dry run

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 11 sensor-noise vs model-mismatch decomposition with a dry-run residual manifest that validates inputs, outputs, and stats handoff before real filters are scheduled.

## Roadmap map

- Phase 11 preflight: residual decomposition needs deterministic config, filter, trace, and stats-output contracts.
- Phase 7 evidence hygiene: reuse strict Hinf manifest lessons without targeting a protected claim.

## Required behavior

- Add or extend a runner-side dry-run command that resolves candidate Phase 11 configs, filter set, residual trace output schema, stats consumer compatibility, local-cache readiness, and intended output paths without running filters.
- The dry run must distinguish loader unavailable, cache missing, filter unavailable, trace schema unsupported, stats consumer unknown, and output path collision.
- Output JSON must be deterministic, finite, and suitable for worker pre-dispatch or CI review.
- Do not generate empirical evidence, run expensive filters, or commit machine-local paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 11 residual manifest dry run.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any Phase 11 candidate config cannot be mapped to a deterministic loader, cache/provenance source, filter set, residual trace schema, and stats consumer identity, the dry run must mark it not ready and block downstream expensive scheduling.

## Validation

Run and record:

- focused tests for ready, loader-missing, cache-missing, filter-missing, schema-unsupported, stats-unknown, and output-collision cases;
- a real dry-run manifest over the current Phase 11 candidate config set without running filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
