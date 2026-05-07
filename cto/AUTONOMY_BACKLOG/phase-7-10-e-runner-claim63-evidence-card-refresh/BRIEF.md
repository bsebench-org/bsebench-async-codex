---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-e-runner-claim63-evidence-card-refresh
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.e - runner claim63 evidence card refresh

You are a rigorous BSEBench runner engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Refresh the neutral Hinf candidate evidence-card generator so it includes manifest, replay, sensitivity, and uncertainty status without promoting a scientific claim.

## Required behavior

- Extend the neutral evidence-card output to include links or hashes for strict evidence, artifact manifest, stats replay, sensitivity, uncertainty, and falsification matrix when available.
- The card must explicitly say mechanical evidence only and must not target `claim_55`.
- Fail or warn deterministically when optional artifacts are missing, depending on whether the input contract says required or optional.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not make SOTA, novelty, or verified-claim statements without a source ledger and comparability table.

## Falsification gate

If the generator cannot distinguish mechanical evidence from claim promotion, or if it writes a verified verdict, the task must fail.

## Validation

Run and record:

- focused tests for all-artifacts, missing-optional, missing-required, and forbidden-wording cases;
- real evidence-card command against committed artifacts;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
