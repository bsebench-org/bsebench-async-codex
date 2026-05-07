---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-s-datasets-strict-hinf-provenance-gap-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.s - datasets strict Hinf provenance gap gate

You are a rigorous BSEBench dataset provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a dataset-side provenance gap gate for the strict Hinf evidence configs so downstream evidence cannot be treated as claim-supporting when loader or cache source identity is incomplete.

## Roadmap mapping

- Phase 7: Hinf evidence can only remain useful if each strict config has deterministic dataset provenance.
- Phase 8 and Phase 11 preparation: provenance gaps found here should generalize to cross-chemistry and residual-decomposition preflights.
- Validation infrastructure: block false scientific claims caused by unknown data identity.

## Active lane

Evidence generation, validation infrastructure only. The handoff artifact is a read-only provenance gap report with explicit ready, missing, unknown, and not-applicable statuses.

## Required behavior

- Map the strict Hinf evidence config identifiers to dataset adapter/source metadata without modifying the evidence outputs.
- Report dataset name, profile/cell identity when available, loader path or adapter id, local-cache readiness, and unavailable metadata as explicit gaps.
- Avoid committing local absolute cache paths as scientific evidence; if paths are needed for diagnostics, redact or hash them consistently.
- The gate must distinguish missing cache, loader unsupported, source metadata unknown, and successful deterministic mapping.
- No thesis or claim registry edits are permitted.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this dataset provenance gate.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if any strict Hinf config is counted as provenance-ready while its loader, source identity, profile/cell metadata, or cache readiness is unknown, or if unavailable metadata is inferred instead of recorded as a gap.

## Validation

Run and record:

- focused tests for ready, missing cache, unknown source metadata, unsupported loader, and redacted or hashed local path output;
- a real read-only provenance gap command over the strict Hinf config list;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
