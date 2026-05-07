---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-t-async-source-ledger-ci-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 75
---

# Phase 7.10.t - async source-ledger CI gate

You are a rigorous anti-hallucination infrastructure engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Turn the research-gate source-ledger requirements into a CI-friendly preflight for future comparison tasks.

## Roadmap mapping

- Validation infrastructure: SOTA and novelty language must be impossible to merge without source-ledger comparability metadata.
- Phase 8/11 preparation: future cross-dataset and sensor-floor comparisons need explicit metric, split, dataset, and caveat fields before interpretation.

## Required behavior

- Add or extend an async-side checker, fixture, or CI script that validates source-ledger rows and flags comparison wording without required metadata.
- Required fields must include stable URL or DOI, retrieval date, metric, dataset, split, reported value, BSEBench artifact value or artifact reference, comparability status, and caveat.
- Include positive and negative fixtures that exercise missing URL/DOI, missing retrieval date, missing split, and unsupported comparison wording.
- The checker must be usable by future BRIEFs without editing thesis or claim registries.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this source-ledger CI gate.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements. Any future SOTA comparison requires a source ledger with stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a fixture can include SOTA, novelty, or leaderboard wording while omitting stable source metadata or comparability caveats, the CI gate must fail.

## Validation

Run and record:

- positive and negative checker fixtures for complete ledger rows and missing required fields;
- a negative wording probe containing comparison language without ledger evidence;
- `bash -n` for changed shell scripts;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
