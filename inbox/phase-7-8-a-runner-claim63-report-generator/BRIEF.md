---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-8-a-runner-claim63-report-generator
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 60
---

# Phase 7.8.a — neutral Hinf candidate report generator

You are a rigorous BSEBench research engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits. Keep the write scope narrow.

## Goal

Add a deterministic report generator for the strict Hinf residual evidence bundle in `bsebench-runner`.

The report must summarize only mechanical evidence from:

- `outputs/hinf_residual_evidence_5x5.json`
- `outputs/hinf_residual_artifact_manifest.json`

It must not assert a scientific verdict, verified claim, novelty, or SOTA status.

## Required behavior

- Create a script such as `scripts/build_hinf_candidate_report.py`.
- Produce a compact JSON summary and a neutral Markdown report under `outputs/` or a clearly named artifacts directory.
- Include the evidence guardrails in the output:
  - `scientific_verdict == "none"`
  - `claim_target == "new_hinf_candidate_not_claim_55"`
  - `mechanical_evidence_only == true`
  - `claim_55_targeted == false`
- Include exact numeric facts already present in the evidence:
  - config/filter counts
  - Hinf correlations
  - variance-decomposition shares
  - artifact hashes or manifest pointer
- Fail closed if any required guardrail is missing or changed.

## Falsification gate

If the report cannot prove it is mechanical-only and not targeting `claim_55`, the script must exit non-zero. Do not weaken existing Hinf audits to make this pass.

## Validation

Run and record:

- `uv run --locked --all-extras python scripts/audit_hinf_residual_manifest.py`
- the new report script
- focused tests for the new script
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`
- `uv run --locked --all-extras ruff check .`

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
