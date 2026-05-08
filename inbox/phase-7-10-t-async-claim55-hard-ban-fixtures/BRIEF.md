---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-t-async-claim55-hard-ban-fixtures
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.t - async claim_55 hard-ban fixtures

You are a rigorous async research-gate engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Harden the async BRIEF gate with fixture coverage that proves protected `claim_55` targeting cannot pass through the autonomy backlog or inbox.

## Active lane

Evidence generation: validation infrastructure for async guardrails. The handoff artifact is a fixture-backed gate result showing positive and negative protected-claim cases.

## Required behavior

- Review `scripts/check-research-brief-gates.sh`, the research gate protocol, and current autonomy backlog wording.
- Add fixture BRIEFs or a lightweight shell-test harness that proves the gate rejects tasks that target `claim_55`, edit thesis/claim registries without authorization, or make unsupported SOTA/novelty claims.
- Keep fixtures synthetic and clearly non-executable; they must not queue real work or create `STATUS.json`.
- Preserve current valid backlog behavior and make the failure output actionable enough for a future CTO to fix a bad BRIEF.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
- Do not target `claim_55`; `claim_55` is protected and this task must only test that targeting attempts fail.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a synthetic BRIEF that targets `claim_55`, edits a claim registry, or makes a SOTA/novelty statement without a source ledger can pass the gate, this task must fail and leave the failing fixture in the validation log.

## Validation

Run and record:

- the new fixture or shell-test harness for accepted and rejected BRIEF examples;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
