---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-t-async-sota-ledger-ci-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.t - async SOTA ledger CI gate

You are a rigorous anti-hallucination and CI gate engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a lightweight async-side CI or preflight gate that fails future BRIEFs or reports when SOTA, novelty, leaderboard, or better-than-prior-work wording appears without source-ledger comparability evidence.

## Roadmap map

- Research-gate lane: block unsupported scientific comparison claims before claim registration.
- Async reliability lane: make the autonomy queue reject unsafe wording early and reproducibly.

## Required behavior

- Extend an existing checker or add a small new script that scans specified Markdown/JSON inputs for SOTA or novelty wording and verifies an accompanying source ledger when such wording is allowed.
- Required ledger fields must include DOI or stable URL, retrieval date, metric, dataset, split, method, reported value, BSEBench frozen value, comparability status, and comparability caveat.
- Include fixtures for allowed no-SOTA wording, blocked SOTA wording without a ledger, blocked incomplete ledger rows, and allowed synthetic comparable/partial/not-comparable rows.
- Use synthetic fixture values unless a real source ledger with stable URL or DOI and retrieval date is already present.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this source-ledger CI gate.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a future task can pass the gate while making a SOTA or novelty comparison with a missing DOI/stable URL, retrieval date, metric, dataset, split, BSEBench frozen value, or comparability caveat, the gate must fail and the task must be marked incomplete.

## Validation

Run and record:

- positive and negative fixture checks for no-SOTA text, unsupported SOTA text, missing-required-field ledger rows, and complete synthetic comparable/partial/not-comparable rows;
- `bash -n` for changed shell scripts;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
