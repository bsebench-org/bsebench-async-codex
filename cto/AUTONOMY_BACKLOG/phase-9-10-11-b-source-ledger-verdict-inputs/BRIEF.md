---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-9-10-11-b-source-ledger-verdict-inputs
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 75
---

# Phase 9/10/11.b - source-ledger verdict inputs

You are a rigorous BSEBench source-ledger and verdict-gate engineer. You are not
alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Build a local verdict-input matrix showing exactly which source-ledger rows,
frozen BSEBench value rows, comparison bindings, and verdict artifacts are
missing before Phase 9, Phase 10, or Phase 11 can leave NO-GO.

## Local evidence to consume

- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`
- Phase 9/10/11 completion audit and final synthesis.
- Local source-ledger audit branches and fixture branches already present in
  git refs.
- Current DAG wait states for `P9-VERDICT-1`, `P10-VERDICT-1`, and
  `P11-VERDICT-1`.

## Required behavior

- Add an async-side source-ledger verdict-input matrix artifact or generator that
  reads only local files and git refs.
- For each phase, list required row classes: external source rows, BSEBench
  frozen value rows, comparison binding rows, claim/report binding rows, and
  final verdict artifact.
- Mark each requirement `present`, `side_branch_only`, `missing`,
  `synthetic_only`, `not_applicable`, or `blocked`.
- Positive comparison wording must be blocked unless local rows include stable
  source identity, retrieval date, exact metric, dataset, split/protocol,
  BSEBench artifact path, branch/commit identity, replay/generation command,
  comparability decision, and caveat.
- Do not browse, retrieve external sources, upload artifacts, download data, run
  Hugging Face upload or download commands, or contact dataset hosts.
- Do not edit thesis files, roadmap files, claim registry files,
  `claims/registry.yaml`, or `claim_55`.
- Do not make comparison, leaderboard, novelty, breakthrough, or
  verified-claim statements.

## Dependencies

This task can run immediately. If a branch or artifact named by earlier audits is
not present locally, mark that requirement `missing` or `side_branch_unavailable`
instead of inferring content.

## Falsification gate

If a Phase 9, Phase 10, or Phase 11 verdict row can be marked ready while any
required source-ledger row, frozen BSEBench value row, comparison binding, replay
command, commit identity, or verdict artifact is missing, the task must fail.

## Acceptance checks

- The matrix has one row per phase and one row per required verdict input class.
- Missing or synthetic-only rows force a phase-level `no_go_missing_inputs`
  status.
- Side-branch-only evidence is not treated as merged current-head evidence.
- The artifact includes exact local refs or file paths for present evidence.

## Validation

Run and record:

- focused tests or fixtures covering present, side-branch-only, synthetic-only,
  missing, and blocked verdict inputs;
- one real local matrix generation over current refs without network access;
- a protected-path scan showing no thesis, roadmap, claim registry,
  `claims/registry.yaml`, or `claim_55` edits;
- a text scan for unsupported comparison or claim-promotion wording;
- `git diff --check`.

Commit with a subject starting `GLASSBOX`. Do not add co-author trailers.
