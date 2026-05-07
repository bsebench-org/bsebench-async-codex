---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-aa-runner-hinf-replay-negative-controls
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.aa - runner Hinf replay negative controls

You are a rigorous BSEBench runner reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prove the strict Hinf replay/audit path rejects tampered evidence, stale manifests, and missing guardrail fields before future Hinf candidate work can treat artifacts as replayable.

## Active lane

Evidence generation and validation infrastructure only. The handoff artifact is a mechanical replay-negative-control report or test fixture set; it is not a scientific verdict.

## Required behavior

- Read the committed strict Hinf evidence, artifact manifest, manifest drift audit, output audit, CI summary, and candidate report when present.
- Add synthetic or fixture-based negative controls that cover at least: evidence hash drift, manifest source SHA drift, missing `mechanical_evidence_only`, changed strict config identity, and non-finite residual payloads.
- The replay/audit command or fixtures must report which control failed, which artifact was read, and how many mismatches were detected.
- Keep outputs mechanical: candidate evidence may be marked replayable or drifted, but the task must not verify, reject, or promote any scientific claim.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf candidate replay validation.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any tampered fixture can pass the replay/audit path with zero mismatches, or if the report cannot identify the artifact and field that drifted, the task must fail and block downstream Hinf evidence promotion.

## Validation

Run and record:

- focused tests for hash drift, source-SHA drift, missing guardrail field, strict-config drift, and non-finite residual payloads;
- the real strict Hinf audit command against committed artifacts, without recomputing filters;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
