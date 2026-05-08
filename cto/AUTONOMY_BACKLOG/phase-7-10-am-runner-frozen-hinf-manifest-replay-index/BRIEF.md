---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-am-runner-frozen-hinf-manifest-replay-index
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.am - runner frozen Hinf manifest replay index

You are a rigorous BSEBench runner validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a read-only replay index for the frozen strict Hinf evidence bundle so future validators can prove which committed artifact, manifest row, stats dependency, and replay command are being checked before any claim work starts.

## Roadmap mapping

- Phase 7: Hinf evidence validation and fragility, without targeting `claim_55`.
- Validation infrastructure: manifest replay, artifact hashes, provenance identity, and CI-ready mismatch reporting.

## Active lane

Evidence generation: mechanical manifest/replay validation only. The handoff artifact is a JSON or Markdown replay index that records artifact paths, hashes, dependency identities, replay commands, mismatch counts, and neutral pass/fail fields.

## Required behavior

- Consume committed runner artifacts such as `outputs/hinf_residual_artifact_manifest.json` and `outputs/hinf_residual_evidence_5x5.json` without regenerating runner filters.
- Add or extend a deterministic command that links each evidence config to its manifest row, source identity, artifact hash, stats dependency SHA, and stats replay command.
- Report missing paths, duplicate config identifiers, hash mismatches, unknown dependency identity, local-only paths, and manifest/evidence config drift as explicit machine-readable failures.
- Treat unavailable metadata as a provenance gap, not inferred metadata.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Hinf manifest replay task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any frozen Hinf evidence artifact is missing, has a hash mismatch, lacks a known source/dependency identity, disagrees with the manifest config set, or cannot name a replay command over committed artifacts, the index must fail and block downstream claim registration.

## Validation

Run and record:

- focused tests for missing artifact, hash mismatch, duplicate config, unknown stats dependency, and manifest/evidence drift fixtures;
- a real read-only replay-index run against the current committed Hinf artifact manifest and evidence JSON;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
