---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
target_branch: phase-7-10-v-stats-residual-decomp-null-model-preflight
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.v - stats residual decomposition null-model preflight

You are a rigorous BSEBench statistics validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 11 residual decomposition by adding null-model fixtures and checks that prove the stats tooling can reject impossible sensor/model/numerical decompositions before real evidence is interpreted.

## Active lane

Evidence generation. The handoff artifact is a synthetic preflight and validation report for decomposition invariants. It is not a SOTA comparison and not claim registration.

## Required behavior

- Add or extend stats-side preflight tooling such as `scripts/residual_decomp_null_model_preflight.py`.
- Use synthetic fixtures with known sensor-noise, model-mismatch, and numerical components; do not depend on undocumented real-data assumptions.
- The preflight must verify finite values, non-negative components, dimensional consistency, component sums within tolerance, unit metadata, sample-count sufficiency, and deterministic JSON output.
- Include failure modes for missing components, negative variance, sum mismatch, non-finite values, unit mismatch, and too few samples.
- The output must use neutral labels such as `preflight_ready`, `preflight_blocked`, and `mechanical_validation_only`; it must not state that Phase 11 is solved.
- Do not edit thesis files, claim registry files, claims/registry.yaml, claim_55, docs/RESEARCH-ROADMAP-2026-05-06.md, or roadmap text.
- Do not target claim_55; claim_55 is protected and unrelated to this backlog task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If the preflight accepts non-finite values, negative components, incompatible units, insufficient samples, or a decomposition whose components do not sum to the residual total within tolerance, it must fail and block Phase 11 interpretation work.

## Validation

Run and record:

- `uv run --locked --all-extras pytest tests/test_residual_decomp_null_model_preflight.py -q`;
- `uv run --locked --all-extras python scripts/residual_decomp_null_model_preflight.py --fixture tests/fixtures/residual_decomp/null_model_valid.json --out /tmp/residual_decomp_null_model_preflight.json`;
- focused fixtures for valid, missing-component, negative-component, non-finite, unit-mismatch, sum-mismatch, and too-few-samples cases;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
