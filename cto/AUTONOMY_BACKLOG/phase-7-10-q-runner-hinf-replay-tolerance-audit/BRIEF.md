---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-q-runner-hinf-replay-tolerance-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.q - runner Hinf replay tolerance audit

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make the strict Hinf evidence replay tolerance envelope explicit and machine-auditable before any downstream claim-registration work is considered.

## Active lane

Evidence generation: validation infrastructure over already committed runner artifacts. The handoff artifact is a read-only audit report with artifact hashes, replay tolerance fields, mismatch counts, and dependency identity checks.

## Required behavior

- Inspect the current Hinf evidence manifest, replay/audit scripts, and committed strict Hinf output artifacts in `bsebench-runner`.
- Add or extend a read-only audit command that reports artifact identity, stats dependency identity, numeric tolerance names and values, maximum absolute/relative deltas where applicable, mismatch counts, stale dependency status, and `claim_55_targeted=false`.
- The audit must fail loudly when tolerances are missing, non-finite, or looser than the documented replay contract; when artifact hashes drift; or when replay mismatch counts are non-zero.
- Do not regenerate filters, do not commit new empirical evidence outputs, and do not convert this into a scientific Hinf verdict.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf replay tolerance audit.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any committed Hinf artifact hash differs from the manifest, any tolerance is absent/non-finite/too loose, the stats dependency identity is unknown or stale, or the replay mismatch count is non-zero, the audit must fail and mark the evidence not claim-ready.

## Validation

Run and record:

- `uv run --locked --all-extras pytest tests/test_audit_hinf_replay_tolerance.py -q`;
- the real read-only tolerance audit against the current committed Hinf manifest and outputs;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
