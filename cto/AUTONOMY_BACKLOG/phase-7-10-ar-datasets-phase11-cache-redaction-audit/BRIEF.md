---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-ar-datasets-phase11-cache-redaction-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 75
---

# Phase 7.10.ar - datasets Phase 11 cache redaction audit

You are a rigorous BSEBench dataset provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a Phase 11 cache/provenance redaction audit so readiness reports can be committed without leaking user-specific local paths or secrets.

## Active lane

Evidence generation: provenance sanitation validation. The handoff artifact is a read-only audit report that shows which cache/provenance fields are safe to commit, redacted, hashed, or blocked.

## Required behavior

- Inspect existing local-cache manifest, Phase 11 provenance inventory, dataset catalog, and loader provenance audit outputs.
- Add or extend a datasets command that audits Phase 11 cache/provenance reports for absolute local paths, home-directory fragments, access tokens, private cache roots, unstable timestamps, and missing dataset source identity.
- The command must preserve useful provenance through stable dataset IDs, source URL or DOI fields when known, hashes where practical, and explicit `redacted` markers for unsafe local details.
- The report must distinguish `safe_to_commit`, `redacted`, `blocked_missing_source`, and `blocked_secret_or_path` per field or dataset.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 11 cache redaction audit.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements. A SOTA claim requires a source ledger with stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If an audit fixture with a local absolute path, home-directory fragment, token-like value, missing source identity, or unstable machine-specific field is marked safe to commit, the task must fail.

## Validation

Run and record:

- `uv run --locked --all-extras pytest tests/test_phase11_cache_redaction_audit.py -q`;
- the real read-only redaction audit over current Phase 11 provenance/cache candidate output or fixtures;
- `uv run --locked --all-extras pytest tests/ -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
