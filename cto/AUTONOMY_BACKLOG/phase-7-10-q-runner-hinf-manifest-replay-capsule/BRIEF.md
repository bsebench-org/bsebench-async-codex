---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-runner
target_branch: phase-7-10-q-runner-hinf-manifest-replay-capsule
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.q - runner Hinf manifest replay capsule

You are a rigorous BSEBench runner reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Make the committed strict Hinf evidence bundle easier to replay and falsify by producing a small manifest replay capsule over existing artifacts, without rerunning filters or changing any scientific claim.

## Active lane

Evidence generation. The handoff artifact is a deterministic replay-capsule JSON plus validation logs. It is mechanical evidence only, not a SOTA comparison and not claim registration.

## Required behavior

- Add a runner-side command such as `scripts/build_hinf_manifest_replay_capsule.py` that reads committed Hinf evidence, artifact manifest, cache preflight, chi2 sweep, output audit, and manifest-audit artifacts when present.
- The capsule must record artifact paths, expected hashes, observed hashes, command lines, dependency SHAs, input config identifiers, output paths, and explicit pass/fail or unavailable statuses.
- Missing optional artifacts must be represented as gaps. Missing required artifacts, hash mismatches, stale dependency identity, non-finite JSON, or absent replay commands must fail loud.
- The command must not recompute filters, download data, or treat local-machine paths as scientific evidence.
- The output must keep `mechanical_evidence_only=true`, `scientific_verdict=none`, and `claim_55_targeted=false` or equivalent fields.
- Do not edit thesis files, claim registry files, claims/registry.yaml, claim_55, docs/RESEARCH-ROADMAP-2026-05-06.md, or roadmap text.
- Do not target claim_55; claim_55 is protected and unrelated to this backlog task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any required Hinf artifact is missing, has a hash mismatch, lacks a replay command, lacks dependency identity, contains a forbidden scientific verdict, or targets claim_55, the capsule command must exit non-zero and mark the bundle not replay-ready.

## Validation

Run and record:

- `uv run --locked --all-extras pytest tests/test_build_hinf_manifest_replay_capsule.py -q`;
- `uv run --locked --all-extras python scripts/build_hinf_manifest_replay_capsule.py --manifest outputs/hinf_residual_artifact_manifest.json --evidence outputs/hinf_residual_evidence_5x5.json --out /tmp/hinf_manifest_replay_capsule.json`;
- existing Hinf artifact audit commands that the capsule cites;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
