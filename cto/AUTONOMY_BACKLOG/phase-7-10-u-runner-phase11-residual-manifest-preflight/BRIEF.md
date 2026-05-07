---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-u-runner-phase11-residual-manifest-preflight
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.u - runner Phase 11 residual-manifest preflight

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 11 residual-decomposition runs with a dry-run manifest that proves each planned trace has the fields needed to separate sensor noise from model mismatch.

## Roadmap mapping

- Phase 11: residual decomposition requires explicit voltage/current/time fields, model output identity, sample counts, and profile metadata before interpretation.
- Validation infrastructure: dry-run manifests block expensive jobs that would produce unusable residual evidence.

## Required behavior

- Add or extend a runner dry-run manifest command for Phase 11 residual-trace planning.
- The manifest must report config id, dataset family, profile/split, expected trace fields, filter set, sample-count readiness, local-cache readiness, intended output path, and stats dependency identity.
- The command must not run filters or generate empirical residual evidence.
- It must distinguish missing trace field, loader unavailable, cache missing, profile unknown, filter unavailable, and stats dependency unknown.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 11 residual-manifest preflight.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements. Any future SOTA comparison requires a source ledger with stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a planned Phase 11 config cannot prove required residual trace fields, sample-count readiness, local-cache readiness, and stats dependency identity before execution, the manifest must mark it not ready and block scheduling.

## Validation

Run and record:

- focused tests for ready, missing trace field, cache missing, profile unknown, filter unavailable, and stats dependency unknown cases;
- a real dry-run manifest over the current Phase 11 candidate config set without running filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
