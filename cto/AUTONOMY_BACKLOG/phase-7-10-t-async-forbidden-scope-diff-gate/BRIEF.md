---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-t-async-forbidden-scope-diff-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.t - async forbidden-scope diff gate

You are a rigorous async validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a lightweight forbidden-scope gate so autonomous research tasks fail fast when a diff attempts thesis, claim registry, roadmap, or protected claim edits without an explicit claim-registration BRIEF.

## Roadmap mapping

- Active lane: validation infrastructure.
- Supports Phase 7/8/11 anti-hallucination and claim-separation gates.
- Produces async CI or shell-gate tooling only; it does not change the scientific roadmap.

## Required behavior

- Review the research gate protocol, existing brief checker, autonomy pacer, and chef/worker validation hooks.
- Add a script, test fixture, or CI-ready probe that can inspect staged or explicit path lists and fail on forbidden paths or protected-claim targeting.
- Forbidden examples must include thesis paths, claim registry files, `claims/registry.yaml`, `docs/RESEARCH-ROADMAP-2026-05-06.md`, and any direct `claim_55` targeting.
- Allow only documented non-claim metadata files when the BRIEF is not a claim-registration task.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this async forbidden-scope gate.
- Do not make SOTA, novelty, leaderboard, breakthrough, verified-claim, or claim-promotion statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if a synthetic diff containing a thesis file, claim registry file, roadmap edit, `claims/registry.yaml`, or `claim_55` target passes as safe for a non-claim-registration task.

## Validation

Run and record:

- positive and negative probes for allowed async-only paths, forbidden thesis paths, forbidden registry paths, roadmap edits, and protected `claim_55` targeting;
- `bash -n` for changed shell scripts;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
