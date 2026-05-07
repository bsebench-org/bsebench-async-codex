# Phase 8 Post-Merge CI Triage Runbook

GLASSBOX artifact: W6-12, Wave 6 red-team and merge hardening.
Timestamp: 2026-05-07T21:36:56Z.
Owned path: `runbooks/ci/post-merge-ci-triage-20260507T213656Z.md`.
Scope: post-merge CI triage for Phase 8 integration branches only.

## Non-Negotiables

- Treat a red post-merge CI run as a publication stop until classified.
- Do not rewrite or force-push shared history. Rollback means a new revert commit.
- Do not edit thesis files, manuscript files, claim registry files, `claim_55`,
  or the scientific roadmap during triage.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim
  statements while summarizing the incident.
- Preserve unrelated worker changes. Stage and commit only the incident artifact
  or fix files explicitly owned by the assigned owner.
- Include GLASSBOX metadata in every triage, fix, or rollback commit.

## First Response

1. Record the failing branch, merge commit, workflow run URL, job name, attempt
   number, and first failing step.
2. Check whether the failure is already present on `origin/main` before the
   merge. If yes, classify as inherited red main and hand off to CI infra unless
   the Phase 8 merge made the failure worse.
3. Compare the merge diff to the failing step. Use changed paths and failing
   imports/tests as the first owner signal, not speculation.
4. Decide one of three actions within 15 minutes: rerun, owner fix, or rollback.
5. Post the handoff record before starting code changes so the audit trail is
   readable if another worker takes over.

## Failure Classification

Use the first matching class that explains the observed failure.

| Class | Signals | Action |
|---|---|---|
| Transient CI infrastructure | GitHub runner startup failure, cancelled job, network timeout, registry 5xx, cache service error, artifact upload/download flake | Rerun once. If the same step fails again, reclassify. |
| Dependency or environment drift | Lock/install mismatch, missing system package, Python version mismatch, changed CI env var, expired token, cache root permission issue | Assign CI infra owner plus affected package owner. No blind rerun after one repeat. |
| Lint, format, or static gate | `ruff`, formatting, import sort, shell syntax, YAML syntax, markdown link gate, claim-language linter | Owner fix. Do not rerun until the diff changes. |
| Unit or regression test | Deterministic assertion, missing function, changed exception, import error, snapshot mismatch | Owner fix. Roll back if main stays red past SLA. |
| Integration contract | Runner/stats/datasets/async boundary mismatch, changed CLI flag, schema mismatch, manifest path drift, artifact naming drift | Lead owner is the module that changed the contract; secondary owner is the first consumer that fails. |
| Data, cache, or provenance | Missing fixture, checksum mismatch, manifest parse failure, cache root resolution failure, provenance ledger mismatch | Stop publication. Assign datasets owner and consider rollback if public artifacts or reproducibility gates are affected. |
| Numeric or statistical stability | Deterministic numeric delta outside tolerance, seed instability, non-reproducible panel output, changed threshold | Assign stats owner. Require reproduction command and before/after numeric evidence before merge. |
| Security or secret exposure | Token in logs, credential failure with leak risk, unexpected write to protected path | Stop publication and escalate to maintainer. Prefer rollback if the merge introduced exposure. |
| Documentation or claim guardrail | Claim linter failure, unsupported public claim text, forbidden file touched by integration branch | Stop publication. Assign async/research-gate owner; do not patch scientific text without source ledger ownership. |

## Rerun Policy

Rerun is allowed only when the failure is plausibly external to the code diff.
Allowed examples: runner provisioning error, cancelled workflow, network 5xx,
registry timeout, cache service outage, or artifact transfer failure.

Rerun limits:

- First rerun: rerun the failed job only when the platform supports it.
- Second rerun: rerun the whole workflow only if the first rerun fails in a
  different infrastructure step.
- Stop after two attempts. Same failing command, same assertion, same missing
  file, same checksum, or same lint output means deterministic failure.

Do not rerun before fixing when the log shows syntax errors, test assertions,
missing repository files, import errors, manifest drift, claim guard failures,
or reproducible numeric deltas.

## Rollback Policy

Rollback is a revert commit, not a reset. Prefer rollback when any condition is
true:

- `origin/main` is red after the merge and the failure is deterministic.
- The merge blocks publication gates and no owning worker can start a fix within
  30 minutes.
- The failure affects data integrity, manifest integrity, cache provenance, or
  public artifact reproducibility.
- A claim, thesis, manuscript, or roadmap guardrail was violated.
- A secret or protected-path write may have been introduced.
- Multiple independent Phase 8 modules fail and the root cause is unclear.

Rollback steps:

1. Create a rollback branch from current `origin/main`.
2. Revert the offending merge commit with `git revert -m 1 <merge_sha>` for a
   true merge commit, or `git revert <sha>` for a squash/non-merge commit.
3. Run the failing CI command locally when feasible, plus `git diff --check`.
4. Push the rollback branch and request normal chef/maintainer merge handling.
5. Keep the original integration branch intact for root-cause analysis.

If newer commits landed after the offending merge, revert only the offending
commit and record the risk that conflicts may require maintainer review.

## Owner Handoff

Assign one primary owner and optional secondary owners from the first failing
evidence.

| Failing surface | Primary owner |
|---|---|
| Runner CLI, benchmark execution, result files, report generation | runner integration owner |
| Statistical panels, tolerances, uncertainty, replay summaries | stats integration owner |
| Dataset adapters, manifests, cache roots, fixture checksums | datasets integration owner |
| Async orchestration, worker/chef gates, claim-language checks | async integration owner |
| GitHub Actions YAML, dependency install, cache service, credentials | CI infra owner |
| Claim wording, source ledger, scientific guardrail | research-gate owner |

Handoff record template:

```text
Phase / branch:
Merge commit:
Workflow run / attempt:
Failing job and step:
Classification:
Primary owner:
Secondary owner:
Rollback decision: required | deferred | not required
Rerun attempts used:
First failing log lines:
Changed paths implicated:
Local reproduction command:
Expected owner output:
Deadline / SLA:
```

Expected owner output must be concrete: fix commit SHA, rollback SHA, or a
written blocker with the command that still fails.

## Local Validation Checklist

Before declaring triage complete:

- Confirm the incident is classified using the table above.
- Confirm rerun count is recorded and within policy.
- Confirm rollback decision is explicit.
- Confirm one primary owner is named.
- Confirm any commit touches only owned files for that worker.
- Run `git diff --check`.
