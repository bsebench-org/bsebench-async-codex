---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-ai-datasets-manifest-source-identity-gap-report
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ai - datasets manifest source-identity gap report

You are a rigorous BSEBench datasets provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prepare Phase 8 and Phase 11 work with a source-identity gap report for dataset manifests, so downstream evidence cannot treat incomplete provenance as verified metadata.

## Roadmap mapping

- Roadmap scope: Phase 8 cross-chemistry preparation, Phase 11 residual decomposition preparation, and dataset provenance hygiene.
- Active lane: Evidence generation, limited to read-only manifest/provenance audit tooling.
- Handoff artifact: deterministic gap report listing dataset manifest IDs, source identity fields, missing fields, and readiness status.

## Required behavior

- Reuse existing manifest parsing, loader provenance audit, or Audit J cache manifest code where practical.
- Add or extend a read-only command that checks dataset manifests for stable source identity: stable URL or DOI when known, citation/title, dataset identifier, variant/profile, split/protocol when applicable, chemistry when known, and retrieval or local-cache provenance status when available.
- Missing source identity fields must be explicit gaps, not inferred from filenames or worker memory.
- Output JSON must distinguish `ready`, `partial`, `missing_source_identity`, `unknown_metadata`, and `not_applicable`.
- Do not download data, mutate local caches, or commit machine-local absolute paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this manifest source-identity audit.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a Phase 8 or Phase 11 candidate dataset has missing source URL/DOI, dataset identifier, chemistry/profile, split/protocol, or provenance status and the report still marks it `ready`, the task must fail.

## Validation

Run and record:

- focused tests for ready, partial, missing-source-identity, unknown-metadata, and not-applicable manifest cases;
- one read-only manifest gap report command against the repository manifests;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
