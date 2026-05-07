---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-q-stats-hinf-fragility-sidecar-replay
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 75
---

# Phase 7.10.q - stats Hinf fragility sidecar replay

You are a rigorous BSEBench stats validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make Hinf evidence fragility sidecars independently replayable from frozen runner artifacts, without creating a scientific verdict.

## Roadmap mapping

- Active lane: evidence generation.
- Phase 7: strict Hinf candidate evidence fragility, with no `claim_55` targeting.
- Validation infrastructure: manifest replay and machine-readable mismatch reporting before any claim-registration work.

## Required behavior

- Review the committed Hinf residual evidence, manifest, replay scripts, and existing sensitivity or uncertainty reports.
- Add or extend a stats-owned replay command that reads frozen runner evidence plus a fragility sidecar and recomputes the machine-readable fragility fields.
- The replay output must include artifact path, artifact hash when available, compared field count, mismatch count, tolerance, pass/fail status, and neutral materiality flags.
- Treat missing sidecar fields, changed filter/config identifiers, non-finite values, or tolerance drift as replay failures.
- Do not generate new filter evidence; this task may only read frozen artifacts or synthetic fixtures.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf sidecar replay task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if the replay mismatch count is non-zero, if any sidecar numeric value is non-finite, if a config/filter key exists in the sidecar but not in the frozen evidence, or if the sidecar cannot prove it is mechanical-only and not a claim verdict.

## Validation

Run and record:

- focused tests for exact replay, numeric mismatch, missing field, non-finite value, and unknown config/filter cases;
- one real replay over the current committed Hinf fragility sidecar or a clearly labeled synthetic fixture if no committed sidecar exists;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
