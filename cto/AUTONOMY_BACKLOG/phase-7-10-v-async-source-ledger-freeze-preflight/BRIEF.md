---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-v-async-source-ledger-freeze-preflight
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.v - async source-ledger freeze preflight

You are a rigorous BSEBench anti-hallucination gate engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a preflight that blocks any future SOTA, novelty, or claim-registration queue unless the source ledger and frozen BSEBench evidence identifiers are explicit and hashable.

## Active lane

Validation infrastructure. This task may validate ledger readiness, but it must not compare real literature numbers or register a claim.

## Required behavior

- Review `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`, existing source-ledger schema/checker artifacts, and current claim-candidate readiness outbox files when present.
- Add or extend a preflight that requires a source-ledger path, ledger SHA256, frozen BSEBench evidence path, evidence SHA256, retrieval date, DOI or stable URL, metric, dataset, split, method, reported value, BSEBench frozen value, comparability status, and caveat for every comparison row.
- The preflight must distinguish missing ledger, missing evidence hash, partial comparability, not-comparable rows, missing DOI/stable URL, missing retrieval date, and missing caveat.
- Use synthetic fixtures or existing committed readiness artifacts; do not invent real literature values.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this source-ledger freeze preflight.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a comparison or claim-registration preflight can pass without a hashable source ledger, hashable frozen evidence artifact, DOI or stable URL, retrieval date, exact metric, dataset, split, reported value, BSEBench frozen value, comparability status, and caveat, the task must fail and mark the queue request incomplete.

## Validation

Run and record:

- positive and negative fixture checks for complete comparable rows, partial rows, not-comparable rows, missing ledger hash, missing evidence hash, missing DOI/stable URL, missing retrieval date, and missing caveat;
- `bash -n` for changed shell scripts;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
