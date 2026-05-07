---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-9-c-runner-hinf-sensitivity-sidecar
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 75
---

# Phase 7.9.c — strict Hinf sensitivity sidecar artifact

You are a rigorous BSEBench evidence engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Commit a runner-side mechanical sidecar artifact for the Hinf weighting sensitivity result now available in `bsebench-stats/main`.

## Required behavior

- Generate a JSON sidecar such as `outputs/hinf_residual_sensitivity_5x5.json` from the committed strict Hinf evidence.
- Record enough provenance to identify:
  - runner evidence SHA/hash;
  - stats command or stats git SHA used;
  - `scientific_verdict == "none"`;
  - `mechanical_evidence_only == true`;
  - material sensitivity status.
- Extend the manifest/audit only if it can be done without weakening existing audits.
- Do not overwrite the original strict evidence.
- Do not claim Hinf is verified, novel, or SOTA.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, or roadmap files.

## Falsification gate

If the sensitivity sidecar reports material instability, preserve that result as a caution. Do not hide it or transform it into a positive claim.

## Validation

Run and record:

- stats sensitivity command against runner evidence;
- runner output and manifest audits;
- focused sidecar tests;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
