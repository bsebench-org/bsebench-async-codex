---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-v-async-phase8-11-preflight-dispatch-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 75
---

# Phase 7.10.v - async Phase 8/11 preflight dispatch gate

You are a rigorous BSEBench async validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prevent the autonomy pacer from dispatching expensive Phase 8 or Phase 11 empirical tasks unless the queued BRIEF cites concrete preflight artifacts and falsification gates.

## Required behavior

- Active lane: Evidence generation, limited to async validation and dispatch-safety tooling.
- Add or extend an async-side gate that inspects inbox or autonomy-backlog BRIEFs before dispatch and detects Phase 8/11 tasks that request filter runs, evidence generation, SOTA comparison, or claim registration.
- For expensive Phase 8/11 empirical work, the gate must require cited preflight artifacts or commands covering dataset/config identity, cache/provenance readiness, filter availability, stats dependency identity, validation commands, and a concrete falsification gate.
- The gate must distinguish safe validation/preflight tasks from expensive empirical runs so useful tooling tasks are not blocked.
- It must report actionable reasons in machine-readable form or stable text suitable for pacer logs.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, the roadmap, or manuscript prose.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8/11 dispatch gate.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements; any SOTA comparison requires a source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if a fixture Phase 8/11 expensive empirical BRIEF can be dispatched without preflight artifact identity and validation commands, if a BRIEF lacking a falsification gate passes, if claim-registration wording passes without explicit authorization, or if a harmless preflight-only BRIEF is incorrectly blocked.

## Validation

Run and record:

- fixture tests for safe preflight task, expensive task with complete preflight, expensive task missing artifact, missing validation command, missing falsification gate, forbidden claim-registration wording, and unsupported SOTA wording;
- `bash scripts/check-phase8-11-preflight-dispatch-gate.sh --fixtures tests/fixtures/phase8-11-preflight-dispatch`;
- `bash scripts/check-phase8-11-preflight-dispatch-gate.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `bash -n scripts/check-phase8-11-preflight-dispatch-gate.sh scripts/check-research-brief-gates.sh scripts/cto-autonomy-pacer.sh`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
