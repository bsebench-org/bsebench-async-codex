---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-r-stats-hinf-dropout-fragility-map
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.r - stats Hinf dropout fragility map

You are a rigorous BSEBench statistics engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Stress the mechanical Hinf residual-covariance evidence against leave-one-dataset-out and leave-one-filter-out dropout summaries, so downstream reviewers can see whether the candidate observation is fragile.

## Active lane

Evidence generation. The handoff artifact is a neutral fragility-map JSON over frozen runner evidence. It is not a SOTA comparison and not claim registration.

## Required behavior

- Add a stats-side command such as `scripts/hinf_dropout_fragility_map.py` that reads committed runner Hinf evidence and, where available, stats replay, sensitivity, and uncertainty artifacts.
- Recompute only derived summaries from frozen residual traces or frozen stats payloads; do not run filters or generate new empirical traces.
- Emit deterministic JSON with dropout axis, omitted dataset or filter, values compared, mismatch or sign-flip count, tolerance, material-fragility status, and missing-artifact status.
- Treat missing required artifacts, inconsistent config identities, non-finite values, or divergent ok-filter sets as failures.
- Keep wording neutral: candidate observation, mechanical evidence, replay or fragility status only. Do not write a verified claim.
- Do not edit thesis files, claim registry files, claims/registry.yaml, claim_55, docs/RESEARCH-ROADMAP-2026-05-06.md, or roadmap text.
- Do not target claim_55; claim_55 is protected and unrelated to this backlog task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If omitting any single strict dataset or filter reverses a key residual-covariance direction, crosses a configured uncertainty threshold, changes the ok-filter set, or reveals a replay mismatch, the report must mark `material_fragility_detected=true` and block claim promotion.

## Validation

Run and record:

- `uv run --locked --all-extras pytest tests/test_hinf_dropout_fragility_map.py -q`;
- `uv run --locked --all-extras python scripts/hinf_dropout_fragility_map.py --evidence ../bsebench-runner/outputs/hinf_residual_evidence_5x5.json --out /tmp/hinf_dropout_fragility_map.json`;
- a negative fixture where one dropout changes the mechanical conclusion and the command marks material fragility;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
