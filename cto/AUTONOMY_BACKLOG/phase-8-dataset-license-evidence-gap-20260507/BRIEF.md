---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-8-dataset-license-evidence-gap-20260507
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 8 - Dataset License Evidence Gap Closure

GLASSBOX metadata:
- queued_by: W8-h
- queued_at: 2026-05-07T21:47:28Z
- source_branch: phase-8-7-h-license-evidence-gap-to-backlog-20260507T214728Z
- source_evidence:
  - phase-8-5-h-dataset-license-redteam-20260507T213656Z:redteam/datasets/license-redteam-20260507T213656Z.md
  - phase-8-6-f-dataset-license-clearance-template-20260507T214305Z:templates/datasets/license-clearance-template-20260507.md
- posture: evidence collection only; unknown or missing terms fail closed

You are a rigorous BSEBench datasets provenance engineer. You are not alone in
this codebase; do not revert or overwrite unrelated edits.

## Goal

Close the dataset license/access evidence gap identified by W6-08 by producing a
committed, machine-readable evidence ledger for dataset-bearing public artifacts.
This task does not clear any dataset by assumption. It records evidence,
unknowns, and exclusions so monthly public snapshots can fail closed.

## Context

W6-08 reported that dataset-inclusive public snapshots are blocked unless each
included dataset has redistribution evidence and anonymous access evidence.
Treat the W6-08 report as a blocker report, not as final legal clearance.

W6-08 blocker classes to resolve with committed evidence:

- source redistribution terms are missing, unknown, or not attached to a strict
  manifest;
- hosted mirrors or cache URLs may be non-public to anonymous users;
- repo-level software/citation licenses may be ambiguous for upstream data;
- runtime provenance may be incomplete for evidence-bearing loaders;
- attribution/notice obligations may be absent from the release package;
- prospect-only datasets may have unknown redistribution status.

## Required Behavior

- Add or extend a dataset license evidence ledger that can be reviewed in git.
- For every dataset that may appear in a public report, raw mirror, Tier 2
  cache, generated table, or release archive, record:
  - dataset id and version or source snapshot;
  - source URL, DOI, repository URL, provider page, or permission artifact;
  - reviewed license name and license/terms URL, or explicit
    `blocked_unknown_terms`;
  - retrieval/review date and reviewer identity;
  - artifact class: source pointer, raw mirror, processed cache, metadata,
    figure/table input, aggregate-only report input, or citation-only pointer;
  - SHA-256 inventory for any redistributed file;
  - anonymous access status for every public URL or hosted mirror used by the
    release candidate;
  - attribution/notice text required by the reviewed evidence;
  - raw redistribution decision and derived/cache redistribution decision;
  - caveat text required in public reports.
- Keep code license, BSEBench-authored metadata license, upstream source license,
  and generated dataset artifact license fields separate.
- Do not infer license terms from popularity, prior use, local cache presence,
  filenames, or loader names.
- Do not download private data, commit credentials, commit machine-local cache
  paths as evidence, or print provider tokens.
- If evidence is not available, record the dataset as blocked rather than
  omitting it from the ledger.

## Fail-Closed Acceptance Criteria

This task is complete only when all criteria below are met:

- A committed ledger exists and every dataset-bearing artifact candidate maps to
  exactly one ledger row.
- Every included raw or processed data file has `sha256`, source identity,
  license/terms evidence, attribution/notice, and redistribution decision.
- Every public download URL or hosted mirror used by the release candidate has a
  recorded anonymous access check with timestamp and status.
- Any row with missing source identity, missing license/terms, missing
  attribution requirements, missing checksum, non-public access, or ambiguous
  redistribution is marked blocked and is excluded from redistributed artifacts.
- Prospect-catalog entries are excluded from public artifacts unless promoted to
  strict manifests with complete evidence.
- Monthly report caveats are generated or recorded for aggregate-only,
  no-redistribution, unknown-terms, and permission-pending cases.
- The release gate fails if any dataset-bearing artifact is present without a
  cleared ledger row.
- No SOTA, novelty, leaderboard, breakthrough, superior, universal-proven, or
  verified scientific claims are added.

## Suggested Implementation

- Reuse existing manifest/provenance code and the W7 license clearance template
  rather than creating an unrelated format.
- Prefer a deterministic ledger format such as YAML or JSON with a small schema
  check.
- Add fixtures covering cleared, report-only, restricted, unknown, and
  non-public-access examples.
- Add a dry-run command or validation script that reports blocked rows without
  attempting to fetch restricted payloads.

## Validation

Run and record:

- focused tests for cleared, report-only, restricted, unknown-terms, missing
  checksum, and non-public-access rows;
- one dry-run ledger validation over the current dataset candidates;
- anonymous access checks only for URLs intentionally listed as public release
  candidates, with status and timestamp recorded;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
