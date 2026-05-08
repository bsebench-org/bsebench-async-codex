---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-ap-async-brief-validation-command-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.ap - async BRIEF validation command gate

You are a rigorous BSEBench async validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Harden async BRIEF checks so future research tasks cannot satisfy the gate with vague validation prose instead of concrete commands.

## Roadmap mapping

- Roadmap scope: validation infrastructure that blocks false scientific claims across Phase 7, Phase 8, and Phase 11.
- Active lane: Evidence generation, limited to orchestration guardrail tooling and synthetic fixtures.
- Handoff artifact: checker output that classifies BRIEF validation sections as concrete, missing, placeholder-only, or unsupported.

## Required behavior

- Review `scripts/check-research-brief-gates.sh`, current inbox BRIEFs, and autonomy-backlog BRIEFs.
- Add or extend a checker that requires Phase 7/8/11 BRIEFs to include at least one concrete validation or replay command in the validation section, not only generic words like "validate" or "run tests".
- The checker must reject placeholder commands, prose-only validation, omitted falsification gates, and BRIEFs that authorize claim work without a source ledger or evidence handoff.
- Use synthetic fixture BRIEFs for positive and negative cases; do not rewrite historical inbox tasks unless required for the checker to run.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this async BRIEF validation-command gate.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If a Phase 7/8/11 BRIEF with no concrete validation command, a placeholder-only command, a missing falsification gate, or unsupported claim/SOTA authorization can pass the checker, this task must fail.

## Validation

Run and record:

- positive and negative fixture checks for concrete commands, prose-only validation, placeholder commands, missing falsification gates, and unsupported claim/SOTA wording;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `bash -n scripts/check-research-brief-gates.sh scripts/cto-autonomy-pacer.sh`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
