---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-an-stats-hinf-fragility-report-schema
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.an - stats Hinf fragility report schema

You are a rigorous BSEBench stats validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make Hinf fragility reports validator-friendly by adding a strict schema/checker for leave-source, leave-config, null-control, and threshold-calibration outputs before those reports can be used downstream.

## Roadmap mapping

- Phase 7: Hinf evidence fragility and falsification support, without touching `claim_55`.
- Phase 8/11 preparation: reusable stability-report contract for cross-dataset and residual-decomposition diagnostics.

## Active lane

Validation infrastructure: schema and fixture validation only. The handoff artifact is a checker plus synthetic fixtures that distinguish valid fragility reports from incomplete or overclaiming reports.

## Required behavior

- Add or extend a deterministic stats-side checker for Hinf fragility report JSON/Markdown sidecars.
- Require omitted source/config identifiers, sample counts, compared values, tolerances, mismatch counts, category changes, input artifact hashes, and a neutral status such as `stable`, `fragile`, or `insufficient_evidence`.
- Fail reports that collapse missing source identity into success, omit tolerance definitions, hide mismatch counts, or use claim-verdict language.
- Keep the checker usable on synthetic fixtures and on committed runner/stats Hinf artifacts when available.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf fragility schema task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If the checker accepts a fragility report with missing source identifiers, missing sample counts, missing tolerance thresholds, non-finite values, hidden mismatch counts, or claim-verdict wording, this task must fail.

## Validation

Run and record:

- focused tests covering valid reports, missing source identifiers, missing tolerances, non-finite values, hidden mismatch counts, and banned claim-verdict wording;
- a read-only validation attempt against any current committed Hinf fragility or replay report fixtures, recording `insufficient_evidence` if no such report exists yet;
- `uv run --locked --all-extras pytest tests/ -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
