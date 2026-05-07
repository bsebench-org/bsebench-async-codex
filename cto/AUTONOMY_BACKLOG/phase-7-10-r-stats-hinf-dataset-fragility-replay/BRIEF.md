---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-r-stats-hinf-dataset-fragility-replay
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.r - stats Hinf dataset-fragility replay

You are a rigorous BSEBench statistics validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a mechanical replay that stresses the strict Hinf residual-decomposition evidence against dataset grouping and sample-count imbalance.

## Roadmap mapping

- Phase 7: test whether the Hinf candidate evidence is structurally robust or fragile.
- Phase 11 preparation: make residual-decomposition summaries explicit about dataset imbalance before sensor-floor interpretation.

## Required behavior

- Add or extend a stats command that consumes frozen runner Hinf evidence and recomputes grouped summaries by config, dataset family, and equal-config weighting.
- The report must label changes as mechanical fragility signals only; it must not verify, reject, or register a scientific claim.
- It must expose compared values, tolerances, grouping keys, mismatch/material-change counts, and pass/fail status.
- It must fail loud on missing grouping metadata, non-finite values, inconsistent filter sets, or all-skipped/all-error evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this dataset-fragility replay.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements. Any future SOTA comparison requires a source ledger with stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If Hinf residual-decomposition summaries change materially under dataset-family grouping or equal-config weighting, the task must report that fragility and must not allow a downstream claim packet to treat the evidence as stable.

## Validation

Run and record:

- focused tests for stable synthetic evidence, material grouping change, missing grouping metadata, non-finite values, and divergent filter sets;
- the real replay command against the current frozen Hinf evidence artifact;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
