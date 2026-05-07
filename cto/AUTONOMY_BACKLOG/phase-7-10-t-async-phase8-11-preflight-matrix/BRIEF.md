---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-t-async-phase8-11-preflight-matrix
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.t - async Phase 8/11 preflight matrix

You are a rigorous async validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add an async-side preflight matrix that shows whether queued or reserve tasks for Phase 8 and Phase 11 have the required validation, provenance, replay, and anti-claim guardrails before workers spend compute.

## Roadmap mapping

- Active lane: evidence generation.
- Phase 8/11 preparation: sensor floor, PCRLB/MAD, residual decomposition, and cross-dataset comparison tooling readiness.
- Validation infrastructure: anti-hallucination and claim-gate checks before expensive work.

## Required behavior

- Review `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`, `scripts/check-research-brief-gates.sh`, `scripts/cto-autonomy-pacer.sh`, and current Phase 7/8/11 BRIEFs.
- Add a lightweight script or documented dry-run probe that emits a matrix for inbox and backlog BRIEFs with columns for phase, target repo, active lane, validation command, falsification gate, provenance requirement, replay requirement, SOTA ledger requirement, and forbidden-write guardrails.
- The matrix must explicitly mark missing fields as blockers, not warnings, for Phase 8 and Phase 11 work.
- Do not modify worker queue semantics unless a failing test proves the preflight cannot be reported otherwise.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and unrelated to Phase 8/11 preflight matrix work.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a Phase 8 or Phase 11 BRIEF without a validation command, falsification condition, provenance/replay requirement, or forbidden-write guardrail is reported as ready, the task must fail.

## Validation

Run and record:

- a dry-run matrix over current `inbox/phase-{7,8,11}*/BRIEF.md` and `cto/AUTONOMY_BACKLOG/phase-{7,8,11}*/BRIEF.md` entries;
- at least one negative fixture or temp BRIEF proving a missing blocker is reported as not ready;
- `bash -n` for changed shell scripts;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
