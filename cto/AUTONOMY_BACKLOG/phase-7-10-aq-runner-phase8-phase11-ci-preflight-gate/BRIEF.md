---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-aq-runner-phase8-phase11-ci-preflight-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.aq - runner Phase 8/11 CI preflight gate

You are a rigorous BSEBench runner CI validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Turn Phase 8/11 dry-run readiness outputs into a CI gate that blocks expensive cross-dataset or residual-decomposition scheduling when loader, cache, provenance, filter, stats dependency, or output-path readiness is incomplete.

## Roadmap mapping

- Phase 8: cross-chemistry jobs need deterministic config, loader, and provenance readiness before runs.
- Phase 11: residual decomposition jobs need residual input and stats dependency readiness before runs.
- Validation infrastructure: CI gates and manifest preflight, no scientific verdict.

## Active lane

Validation infrastructure: CI/preflight tooling only. The handoff artifact is a deterministic gate command and fixtures for ready and not-ready dry-run payloads.

## Required behavior

- Add or extend a runner-side gate that consumes a preflight/readiness JSON rather than running filters.
- The gate must distinguish loader unavailable, cache missing, provenance incomplete, filter unavailable, stats dependency unknown, output path unsafe, and stale manifest timestamp or SHA fields.
- Fail loudly for non-finite values, absolute local-machine paths used as evidence, missing config identifiers, duplicate config identifiers, and all-skipped/all-error readiness payloads.
- Produce output suitable for GitHub Actions or worker pre-dispatch logs with counts by failure reason.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8/11 CI preflight gate.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a not-ready Phase 8/11 payload exits zero, or if a ready payload omits config identity, provenance identity, stats dependency identity, finite status fields, or safe output-path checks, this task must fail.

## Validation

Run and record:

- focused tests for ready, loader-missing, cache-missing, provenance-incomplete, filter-missing, stats-unknown, stale-manifest, unsafe-output-path, and all-skipped payloads;
- a real read-only gate run over the current Phase 8/11 dry-run payload if one exists, or an explicit `insufficient_evidence` validation note if none exists yet;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
