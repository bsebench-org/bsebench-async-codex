# Phase 8 Alpha Source-Ledger Fixture Pack

Pack ID: `phase8-alpha-20260507`
Created: `2026-05-07`
Owner: `worker-W7-c`
Status: `synthetic_fixture`

## Purpose

This fixture pack gives comparability-audit gates a minimal, reviewable set of
rows before real Phase 8 alpha benchmark evidence is frozen.

It contains three row classes:

- `bsebench-values.json`: synthetic frozen BSEBench value rows.
- `external-sources.json`: synthetic external-source rows.
- `comparison-bindings.json`: synthetic bindings from external rows to frozen
  BSEBench rows.

## Fixture Scope

All numeric values in this directory are synthetic placeholders. They are not
literature numbers, not benchmark results, and not evidence for any scientific
claim. The rows are intended only to test source-ledger field completeness and
comparability classification.

Real Phase 8 alpha source-ledger rows remain blocked until a committed
BSEBench evidence artifact, external source ledger, retrieval date, exact
metric, dataset, split, and comparison-binding review are available.

## Expected Audit Decisions

| Binding ID | Expected decision | Reason |
|---|---|---|
| `cmp-synth-comparable-001` | `pass_fixture_only` | Complete synthetic rows with matching metric, dataset, split, method basis, preprocessing, and no known leakage risk. |
| `cmp-synth-partial-001` | `needs_caveat` | Complete synthetic rows but the source split is a different horizon. |
| `cmp-synth-not-comparable-001` | `block_positive_comparison` | Complete synthetic rows but task, metric, dataset, split, method basis, and preprocessing differ. |

## Explicit Non-Claims

- This pack does not claim that BSEBench is alpha-ready.
- This pack does not compare real methods or datasets.
- This pack does not make SOTA, novelty, leaderboard, breakthrough, superior,
  universal-proven, or verified scientific statements.
- This pack does not edit thesis files, manuscript files, claim registry files,
  `claims/registry.yaml`, `claim_55`, or the scientific roadmap.
