---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-q-runner-hinf-artifact-replay-negative-fixtures
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.q - runner Hinf artifact replay negative fixtures

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Strengthen strict Hinf artifact replay by proving the runner-side manifest/audit tooling fails on realistic corrupted evidence cases before any downstream claim work can rely on those artifacts.

## Roadmap mapping

- Active lane: evidence generation validation.
- Supports Phase 7 Hinf candidate evidence fragility and manifest replay.
- Produces only tooling and synthetic negative fixtures; it does not change the scientific roadmap.

## Required behavior

- Review committed Hinf residual evidence, artifact manifest, output audit, manifest audit, and stats replay hooks where available.
- Add focused synthetic fixtures or tests that mutate one field at a time: command line, runner commit, stats dependency identity, input artifact hash, output artifact hash, numeric residual value, and mechanical-only guardrail fields.
- The audit must report which value was compared, the mismatch count, tolerance when applicable, and a pass/fail status.
- Do not recompute expensive filters or commit new real-data evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this artifact replay validation.
- Do not make SOTA, novelty, leaderboard, breakthrough, verified-claim, or claim-promotion statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if any intentionally corrupted Hinf manifest, dependency identity, hash, numeric value, or guardrail field passes replay/audit as valid. A zero-exit audit with a hidden mismatch is a blocker.

## Validation

Run and record:

- focused tests for each corrupted fixture class and one valid fixture;
- the real committed Hinf artifact audit without regenerating filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
