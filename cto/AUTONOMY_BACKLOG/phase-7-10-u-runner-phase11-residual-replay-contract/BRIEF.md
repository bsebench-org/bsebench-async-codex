---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-u-runner-phase11-residual-replay-contract
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.u - runner Phase 11 residual replay contract

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 11 sensor-noise versus model-mismatch decomposition with a runner-to-stats residual replay contract that can be checked before expensive filter runs are scheduled.

## Active lane

Evidence generation. The handoff artifact is a schema/contract checker over existing or synthetic residual payloads. It is mechanical evidence only, not a SOTA comparison and not claim registration.

## Required behavior

- Add a dry-run contract checker such as `scripts/check_phase11_residual_replay_contract.py` that validates residual trace payloads intended for stats decomposition.
- The checker must verify config identity, filter identity, residual vector shape, timestamp alignment, measured/predicted voltage units, finite numeric values, sample counts, and stats-consumer compatibility.
- It must support synthetic fixtures and a read-only probe over existing committed Hinf residual evidence if available.
- The checker must not run filters, mutate outputs, or promote Hinf observations into a scientific claim.
- Output JSON must distinguish schema mismatch, non-finite values, insufficient samples, unit metadata missing, stats dependency unknown, and ready statuses.
- Do not edit thesis files, claim registry files, claims/registry.yaml, claim_55, docs/RESEARCH-ROADMAP-2026-05-06.md, or roadmap text.
- Do not target claim_55; claim_55 is protected and unrelated to this backlog task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any residual payload lacks identity, finite aligned vectors, unit metadata, or stats-consumer compatibility, the checker must mark it not ready and block Phase 11 decomposition scheduling for that payload.

## Validation

Run and record:

- `uv run --locked --all-extras pytest tests/test_phase11_residual_replay_contract.py -q`;
- `uv run --locked --all-extras python scripts/check_phase11_residual_replay_contract.py --input outputs/hinf_residual_evidence_5x5.json --out /tmp/phase11_residual_replay_contract.json`;
- focused fixtures for ready, missing-units, non-finite, length-mismatch, missing-filter-id, and stats-unknown cases;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
