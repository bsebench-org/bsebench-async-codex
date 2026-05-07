---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-q-runner-hinf-evidence-audit-matrix-ci
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 75
---

# Phase 7.10.q - runner Hinf evidence audit matrix CI

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make the strict Hinf mechanical evidence replayable as one CI-safe audit matrix that checks the committed runner artifacts without recomputing filters or changing any scientific claim.

## Required behavior

- Active lane: Evidence generation, limited to validation tooling and neutral audit artifacts.
- Add or extend a runner-owned script that reads the committed Hinf evidence, artifact manifest, candidate report summary, determinism summary, and sensitivity sidecar, then emits one deterministic JSON matrix with artifact paths, hashes, audit command names, pass/fail status, mismatch counts, and unavailable-reason fields.
- The matrix must invoke or reuse the existing runner audit logic where practical; do not duplicate numeric comparison rules in an inconsistent way.
- The script must be safe for CI: no network access, no filter reruns, no cache mutation, no local absolute path as scientific identity, and no new empirical evidence generation.
- The output must use neutral language such as `mechanical_evidence_only` and `scientific_verdict=none`.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, the roadmap, or manuscript prose.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this audit-matrix task.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements; any SOTA comparison requires a source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if any required Hinf audit artifact is missing, any artifact hash differs from the manifest, any replay mismatch count is non-zero, any matrix row lacks a command/artifact identity, or the matrix can pass while `scientific_verdict` is anything other than `none`.

## Validation

Run and record:

- focused tests for pass, missing artifact, hash mismatch, non-zero mismatch count, missing command identity, and forbidden scientific-verdict cases;
- `uv run --locked --all-extras python scripts/audit_hinf_residual_evidence_matrix.py --evidence outputs/hinf_residual_evidence_5x5.json --manifest outputs/hinf_residual_artifact_manifest.json --report-summary outputs/hinf_candidate_report_summary.json --sensitivity outputs/hinf_residual_sensitivity_5x5.json --output /tmp/hinf_evidence_audit_matrix.json`;
- `uv run --locked --all-extras pytest tests/test_audit_hinf_residual_evidence_matrix.py -q`;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
