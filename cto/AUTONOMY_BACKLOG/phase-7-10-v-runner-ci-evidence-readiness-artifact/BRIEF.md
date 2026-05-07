---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-v-runner-ci-evidence-readiness-artifact
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 75
---

# Phase 7.10.v - runner CI evidence readiness artifact

You are a rigorous BSEBench runner CI engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make CI produce a small evidence-readiness artifact that tells async reviewers whether Hinf, Phase 8, or Phase 11 evidence bundles are replayable, audited, and provenance-complete.

## Roadmap mapping

- Active lane: evidence generation.
- Phase 7: Hinf evidence readiness and replay status, with no `claim_55` targeting.
- Phase 8/11 preparation: CI preflight for future cross-dataset and residual-decomposition evidence bundles.

## Required behavior

- Review existing runner CI, Hinf output audit, manifest audit, and preflight commands.
- Add or extend a CI-safe command that writes a deterministic JSON readiness artifact summarizing: artifact existence, manifest audit status, stats replay status when available, dataset provenance status, local-cache readiness status, and forbidden-claim guardrail status.
- The readiness artifact must be finite JSON and must distinguish not-run, skipped-with-reason, failed, and passed states.
- Keep the command dry-run by default; it must not run expensive filters unless explicitly invoked by an existing evidence-generation workflow.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to CI readiness artifact work.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If CI can report evidence readiness as passed while the manifest audit failed, stats replay is missing without a reason, provenance is incomplete, or forbidden claim wording is present in the evidence metadata, the task must fail.

## Validation

Run and record:

- focused tests for passed, failed, not-run, skipped-with-reason, missing-provenance, and forbidden-wording cases;
- one dry-run command that writes or prints the readiness JSON without running filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
