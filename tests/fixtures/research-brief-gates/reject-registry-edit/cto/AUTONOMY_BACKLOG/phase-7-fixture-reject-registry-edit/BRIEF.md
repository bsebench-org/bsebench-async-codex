---
target_repo: /tmp/synthetic-non-executable-fixture
target_branch: phase-7-fixture-reject-registry-edit
base_branch: main
hard_wallclock_min: 1
---

# Synthetic Fixture - rejected registry edit

SYNTHETIC FIXTURE ONLY. This file is not a queued task, must not be copied to
the live inbox, and has no STATUS.json.

## Goal

Exercise a bad backlog BRIEF that contains the required guardrail wording but
then asks for a protected write.

## Active lane

Evidence generation: validation infrastructure only.

## Required behavior

- Do not edit thesis files, claim registry files, `claims/registry.yaml`,
  `claim_55`, or roadmap files.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this
  synthetic validation fixture.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim
  statements without a completed source ledger, stable URL or DOI, retrieval
  date, exact metric, dataset, split, and comparability table.
- Update `claims/registry.yaml` with the synthetic candidate result.

## Falsification gate

If this synthetic rejected fixture passes the BRIEF gate, the fixture harness
must fail and print the checker output.

## Validation

Run `bash scripts/check-research-brief-gates.sh --dry-run` against this
synthetic BRIEF fixture path.
