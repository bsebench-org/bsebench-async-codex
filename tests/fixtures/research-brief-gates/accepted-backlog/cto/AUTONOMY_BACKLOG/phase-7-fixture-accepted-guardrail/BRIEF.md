---
target_repo: /tmp/synthetic-non-executable-fixture
target_branch: phase-7-fixture-accepted-guardrail
base_branch: main
hard_wallclock_min: 1
---

# Synthetic Fixture - accepted guardrail BRIEF

SYNTHETIC FIXTURE ONLY. This file is not a queued task, must not be copied to
the live inbox, and has no STATUS.json.

## Goal

Exercise the BRIEF gate with a harmless validation-only task.

## Active lane

Evidence generation: validation infrastructure only.

## Required behavior

- Keep the output mechanical and non-claiming.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`,
  `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this
  synthetic validation fixture.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim
  statements without a completed source ledger, stable URL or DOI, retrieval
  date, exact metric, dataset, split, and comparability table.

## Falsification gate

If this synthetic accepted fixture fails the BRIEF gate, the fixture harness
must fail and report the checker output.

## Validation

Run `bash scripts/check-research-brief-gates.sh --dry-run` against this
synthetic BRIEF fixture path.
