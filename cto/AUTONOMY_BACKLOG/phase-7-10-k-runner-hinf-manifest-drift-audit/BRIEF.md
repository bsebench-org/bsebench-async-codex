---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-k-runner-hinf-manifest-drift-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.k - runner Hinf manifest drift audit

You are a rigorous BSEBench runner reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a lightweight audit that proves the committed strict Hinf artifacts still agree with their manifest, guardrail fields, and replay-sidecar hashes without recomputing expensive filters.

## Required behavior

- Read the committed strict Hinf evidence, artifact manifest, candidate report, CI summary, and sensitivity sidecar when present.
- Add or extend a deterministic command that reports artifact path, SHA256, source commit fields, strict config identity, and guardrail status in JSON.
- The command must fail loud on missing required artifacts, hash drift, mismatched source SHAs, non-finite JSON values, or guardrail fields that no longer say mechanical evidence only.
- Keep the output mechanical: no scientific verdict, no claim promotion, no thesis-ready interpretation.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf candidate evidence lane.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any committed Hinf artifact hash, source SHA, strict config list, status count, or guardrail field disagrees with the manifest or sidecar, the audit must fail and mark the evidence bundle drifted rather than normalizing the mismatch.

## Validation

Run and record:

- focused tests for hash drift, missing artifact, source-SHA mismatch, and forbidden guardrail wording;
- the real manifest drift audit command against committed Hinf artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
