# Wave 8 Source-Ledger Gap Audit - Current State

Worker: `W8-g`
Date: `2026-05-07`
Branch: `phase-8-7-g-source-ledger-gap-audit-current-20260507T214728Z`
Current `HEAD`: `357e990ffd23c3d41581117bb02bf7368816ddcd`
Owned write set: `validation/wave-8/source-ledger-gap-audit-current-20260507.md`

## Scope

This is a current-state validation before any public report or monthly snapshot
comparison wording. It records source-ledger and comparability evidence only.
It does not create scientific evidence, compare real external results, register
claims, or edit protected thesis, manuscript, roadmap, registry, runner, stats,
or datasets files.

## Evidence Inspected

Commands were run read-only from this worktree unless noted:

| Evidence | Result |
|---|---|
| `git fetch --all --prune` | Completed with no output; remote refs were refreshed. |
| `git status --short --branch` | Branch started clean and tracked `origin/main`. |
| `git rev-parse HEAD origin/main` | Both resolved to `357e990ffd23c3d41581117bb02bf7368816ddcd`. |
| `git rev-parse origin/phase-7-10-g-async-source-ledger-schema` | `8e2447a13f2fb556d5e2d0174c10e625971c4439`. |
| `git rev-parse origin/phase-7-10-p-async-source-ledger-comparability-fixtures` | `91a0649c72eaf89d8c7d9b75322a6cc3c79b6e4a`. |
| `git rev-parse origin/phase-8-3-k-source-ledger-schema-spec-20260507T204627Z` | `808d046ca467be270ef39852db1127e41bc8e101`. |
| `git rev-parse origin/phase-8-6-c-source-ledger-fixture-pack-20260507T214305Z` | `e737c93b967cb42d123b3a3b81ad18557b47fc39`. |
| `git ls-tree -r --name-only HEAD \| rg 'source-ledger\|RESEARCH-GATE\|claim-language\|validation/wave-8'` | Current `HEAD` contains protocol/backlog/outbox records, but not the source-ledger checker scripts, fixture JSON pack, or Phase 8 schema spec artifact. |
| `git ls-tree -r --name-only origin/phase-7-10-p-async-source-ledger-comparability-fixtures` | Source-ledger comparability checker and synthetic JSON fixtures exist on that side branch. |
| `git show origin/phase-8-3-k-source-ledger-schema-spec-20260507T204627Z:specs/universal/source-ledger-schema-20260507T204627Z.md` | Schema specification defines source rows, BSEBench frozen value rows, comparison bindings, and claim bindings. |
| `git show origin/phase-8-6-c-source-ledger-fixture-pack-20260507T214305Z:fixtures/source-ledger/phase8-alpha-20260507/*.json` | Fixture pack contains synthetic external-source, BSEBench-value, and comparison-binding rows only. |
| Watchdog logs under `/home/oakir/.local/state/bsebench-async-watchdog/` | Logs exist for the anti-hallucination audit, schema spec, fixture pack, and this current audit. |

## Current Findings

1. Current `HEAD` is still `origin/main`; source-ledger schema/checker/fixture
   artifacts are present on side branches, not merged into this current branch.
2. The Phase 8 schema spec branch is pushed and defines the complete comparison
   gate shape, including source rows, frozen BSEBench rows, comparison rows, and
   claim-to-ledger bindings.
3. The Phase 8 fixture-pack branch is pushed and contains three synthetic
   comparison-binding rows: one comparable fixture, one partial fixture, and one
   not-comparable fixture.
4. The fixture pack explicitly states it is synthetic-only and lists blockers
   for real alpha rows: no committed frozen Phase 8 BSEBench evidence artifact,
   no completed real external-source ledger, and no claim-registration
   authorization.
5. The Phase 7 comparability checker branch validates required metadata and
   enum/format basics. Its panel review recorded a residual gap: the checker
   trusts the row's comparability label and does not independently prove
   semantic comparability when fields contradict the label.

## Required Rows

Before any public report or monthly snapshot can use external comparison
wording, the following row classes must exist as committed, reviewed artifacts:

| Row class | Required content |
|---|---|
| External source row | Stable `source_id`, source type, title, DOI or stable URL, retrieval date, source location, access status, exact method, task, target signal, metric, metric unit, metric direction, aggregation, dataset/version, chemistry/temperature when relevant, split or protocol, preprocessing, calibration policy, reported value, uncertainty when reported, value note, and caveat. |
| BSEBench frozen value row | Stable `bsebench_value_id`, exact value, metric/unit/direction, dataset, split, method, artifact repo/branch/commit/path/hash, generation command, replay command, validation log, environment, evidence status, and caveat. |
| Comparison binding row | Stable `comparison_id`, resolved `source_id`, resolved `bsebench_value_ids`, comparison scope, comparability enum, metric/dataset/split/method/preprocessing match decisions, leakage risk, concrete caveat, review status, and reviewer. |
| Claim binding row | Stable public-text context ID, report path, line/table reference, exact text hash, claim type, trigger terms, resolved comparison IDs and BSEBench value IDs, decision, safe wording when needed, and reviewer note. |

## Blocked Comparisons

The following must remain blocked or caveated in the current state:

| Comparison class | Current decision | Reason |
|---|---|---|
| Real external-source comparison rows for Phase 8 alpha. | `block` | No committed real external-source ledger with retrieval dates and source locations is present in current `HEAD` or the fixture pack. |
| Real BSEBench alpha value comparisons. | `block` | The inspected fixture pack uses synthetic values and records no committed empirical frozen evidence artifact. |
| Public report or monthly snapshot positive comparison wording. | `block` | Required source, frozen value, comparison, and claim-binding artifacts are incomplete or side-branch-only. |
| Partial fixture row `cmp-synth-partial-001`. | `needs_caveat` | The fixture intentionally has a different split/horizon, so it can only support scoped caveat/context validation. |
| Not-comparable fixture row `cmp-synth-not-comparable-001`. | `block_positive_comparison` | The fixture differs across task, metric, dataset, split, method basis, and preprocessing. |
| Checker acceptance of semantically contradictory rows. | `needs_follow_up` | Existing checker coverage is useful for required fields and formats, but panel review notes it does not independently falsify a mislabeled comparable row. |

## Validation Results

| Check | Result |
|---|---|
| Protected write set | Pass. Only this validation file is intended for commit. |
| Side branches inspected read-only | Pass. Branch contents were inspected with `git show`, `git ls-tree`, `git log`, and `git rev-parse`; no checkout or edits were made to those branches. |
| External scientific claims | Pass. This audit records blockers and fixture status only. |
| Source-ledger required rows identified | Pass. See "Required Rows". |
| Blocked comparisons identified | Pass. See "Blocked Comparisons". |
| `git diff --check` | Pass, run after creating this file. |

## Blockers

- Current `HEAD` does not contain the Phase 8 schema spec file or Phase 8
  fixture pack files.
- The fixture pack is synthetic-only and cannot support public comparison
  wording.
- No real retrieved external-source rows were found in the inspected source
  ledger artifacts.
- No empirical frozen BSEBench alpha evidence artifact was found in the
  inspected source-ledger fixture pack.
- Current checker evidence is field/format oriented and does not fully resolve
  semantic comparability risk.
