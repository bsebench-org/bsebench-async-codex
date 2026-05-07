# GLASSBOX Phase 8 Docs Integration Ledger

Worker: W5-04

Branch: `phase-8-4-d-async-universal-docs-integration-20260507T213125Z`

Scope: CTO report docs, templates, specs, audits, validation artifacts,
ledgers, dashboards, runbooks, backlog notes, and the async shell gates/tests
that were part of the committed Wave 1 control-plane artifacts.

This ledger records integration mechanics only. It does not publish benchmark
results, approve a public release, compare methods, or make SOTA, novelty,
leaderboard, breakthrough, or verified-claim statements.

## Inputs Fetched

The integration work fetched these remote branch families from origin:

- `phase-8-0-*`
- `phase-8-1-*`
- `phase-8-2-*`
- `phase-8-3-*`
- `phase-8-4-*`

Fetched Phase 8 CTO-report branches were inspected with:

```bash
git for-each-ref refs/remotes/origin --format='%(refname:short) %(committerdate:iso8601) %(subject)' | rg 'origin/phase-8-[0-4]-'
for b in $(git for-each-ref refs/remotes/origin --format='%(refname:short)' | rg '^origin/phase-8-[0-4]-'); do git diff --name-status origin/main..."$b"; done
```

## Merge Batches

| Batch | Integrated remote heads | Commit | Conflict result |
| --- | --- | --- | --- |
| Wave 1 async/control-plane artifacts | `phase-8-0-s` through `phase-8-0-x` | `b681416` | Automatic merge, no file-level conflicts. |
| Wave 2 validation/audit/workflow artifacts | `phase-8-1-k` through `phase-8-1-v` | `a4962c8` | Automatic merge, no file-level conflicts. |
| Wave 3 methodology audits | `phase-8-2-a` through `phase-8-2-i` | `fb81fb4` | Automatic merge, no file-level conflicts. |
| Wave 4 retries, validations, specs, dashboards, runbooks | `phase-8-3-a` through `phase-8-3-k`, plus `phase-8-3-m` through `phase-8-3-y` | `31df084` | Automatic merge, no file-level conflicts. |
| Current main baseline | `origin/main` at `357e990` | `9968bae` | Automatic merge, no file-level conflicts. |

## Explicit Exclusions

| Branch | Disposition | Reason |
| --- | --- | --- |
| `phase-8-2-j-reproducibility-artifact-manifest-audit-20260507T193528Z` | Not merged | Original Wave 3 usage-limit placeholder had no completed remote artifact. Superseding retry `phase-8-3-a` was merged. |
| `phase-8-2-k-merge-queue-runbook-20260507T193528Z` | Not merged | Original Wave 3 usage-limit placeholder had no completed remote artifact. Superseding retry `phase-8-3-b` was merged. |
| `phase-8-2-l-worker-triage-and-relaunch-runbook-20260507T193528Z` | Not merged | Original Wave 3 usage-limit placeholder had no completed remote artifact. Superseding retry `phase-8-3-c` was merged. |
| `phase-8-3-l-monthly-snapshot-artifact-schema-20260507T204627Z` | Superseded, not merged | Retry branch `phase-8-3-y-monthly-snapshot-artifact-schema-retry-20260507T205258Z` is the more complete monthly snapshot artifact schema and explicitly references the earlier W4-12 artifact. |

## Conflict And Cleanup Log

- All merge batches completed without Git conflict markers.
- `origin/main` was merged after the Phase 8 artifact batches so validation
  ran against the current main pacer safety baseline.
- Range-level whitespace validation found two trailing spaces in
  `audits/wave-1/integration-conflict-map-20260507T193050Z.md`. This
  integration commit removes those trailing spaces while preserving the
  artifact text.
- No thesis files, manuscript files, claim registry files,
  `claims/registry.yaml`, `claim_55`, or scientific roadmap paths are touched
  by the integrated branch diff.

## Validation Record

Validation commands run from this worktree:

| Command | Result |
| --- | --- |
| `bash -n scripts/check-research-brief-gates.sh scripts/cto-autonomy-pacer.sh scripts/probe-autonomy-pacer-safety.sh scripts/plan-disjoint-wave.sh scripts/check-no-idle-capacity-policy.sh` | PASS |
| `bash tests/check-research-brief-gates.sh` | PASS |
| `bash tests/test-disjoint-wave-planner.sh` | PASS |
| `bash scripts/check-no-idle-capacity-policy.sh --self-test` | PASS |
| `bash scripts/probe-autonomy-pacer-safety.sh` | PASS |
| `bash scripts/check-research-brief-gates.sh --dry-run --staged` | PASS, `0 checked`, `0 skipped` because no BRIEF files were staged. |
| `jq empty docs/schemas/bsebench-monthly-benchmark-snapshot-v1.schema.json docs/fixtures/monthly-benchmark-snapshot/valid-minimal.json docs/fixtures/monthly-benchmark-snapshot/invalid-missing-row-caveat.json` | PASS |
| `git diff --name-only origin/main...HEAD \| rg -i '(^|/)(thesis|manuscript|claims/registry|registry\.ya?ml|claim_55|.*roadmap.*)'` | PASS, no matches. |
| `git log --format='%H%n%B%n---END---' origin/main..HEAD \| rg -i 'Co-Authored-By: Claude|Co-authored-by:.*Claude'` | PASS, no matches. |
| `git diff --check` | PASS before this ledger commit. |

Final whitespace validation should be repeated after this ledger commit with:

```bash
git diff --check
git diff --check origin/main...HEAD
```

## Residual Risks

- This branch integrates CTO-report control-plane artifacts only. Runner,
  stats, and datasets source branches still need their own merge queues and
  code-level validation in their target repositories.
- Several imported artifacts are validation or readiness snapshots taken while
  Phase 8 work was moving. They are preserved as evidence, not treated as
  public release approval.
- Source-ledger schema and report-comparability audits define gates, but they
  do not complete an external comparison ledger.
- The broad `--all` research BRIEF gate is intentionally not used here because
  legacy Phase 7 backlog files predate the universal benchmark value field.
  The merged fixture test and staged-only dry run cover the new gate behavior.

## Non-Claims

This integration does not state that BSEBench is public-ready, SOTA, novel,
leaderboard-leading, a breakthrough, or externally verified. It does not rank
ECMs, Kalman filters, observers, AI estimators, hybrid methods, or future
filters. It does not update thesis, manuscript, claim registry, `claim_55`, or
scientific roadmap material.
