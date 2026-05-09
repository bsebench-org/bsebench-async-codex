# Phase 12 Execution Plan

Date: 2026-05-09 10:09 CEST

Status: `READY_AFTER_CLEANUP`

Scope: Phase 12 only. This is an orchestration plan for mechanical product
integration after the Phase 1-11 trajectory audit. It does not open scientific
claim language, does not edit the thesis, and does not modify the research
roadmap.

## Executive Decision

Phase 12 should start only after the workspace cleanup report is committed and
the product repositories show clean `main` worktrees with stale Phase 9/10/11
worktrees pruned or archived.

Reason: launching more workers while thousands of stale worktrees remain would
make branch ownership, validation evidence, and cleanup accountability
ambiguous. The correct fast path is to finish cleanup, then launch a small set
of high-value disjoint workers with explicit outputs.

Maximum useful parallelism for the first Phase 12 wave is `6` product workers
plus `1` audit worker. More than that is not justified until the first product
commits establish stable schemas and fixtures.

## Phase Objective

Convert the Phase 9/10/11 mechanical evidence chain into a cross-chemistry and
transfer-readiness product path:

`source dataset -> ETL/truth readiness -> leakage-safe inventory -> transfer
contract -> estimator/filter adapter metadata -> bounded runner plan -> stats
preflight -> artifact ledger`

Phase 12 is successful only if the path becomes more executable and less
report-only. It remains `NO_GO_CLAIM`.

## Non-Negotiable Guardrails

- No external performance, ranking, or superiority wording.
- No thesis prose or claim-registry edit from autonomous workers.
- No Hugging Face upload before a consolidated source/license/status table
  exists for the candidate dataset.
- No broad formatting rewrites.
- No worker may write outside its assigned repo and paths.
- Every accepted product change needs a validation command and a current-head
  artifact or test.
- Any SOC/SOH metric eligibility must fail closed when truth evidence,
  source identity, split discipline, or leakage constraints are missing.

## Launch Gate

Before launching Phase 12 product workers:

1. `bsebench-specs`, `bsebench-datasets`, `bsebench-stats`,
   `bsebench-runner`, `bsebench-filters`, and `bsebench-website` are clean on
   `main`.
2. Non-main worktrees are either removed or explicitly listed as kept caches.
3. Dirty/untracked async files are either committed, archived, or deleted as
   generated junk with a logged reason.
4. Cleanup archive exists with bundles, patches, inventories, and reset logs.
5. `docs/WORKSPACE_CLEANUP_AUDIT_2026-05-09.md` is committed.

## Task Graph

| ID | Repo | Scope | Ready condition | Output | Validation |
| --- | --- | --- | --- | --- | --- |
| P12-SPECS-1 | `bsebench-specs` | Define cross-chemistry transfer readiness schema and required evidence fields. | Launch gate passed. | Schema/docs/tests. | Focused schema tests. |
| P12-DATASETS-1 | `bsebench-datasets` | Build transfer inventory over known ready Tier2/cache entries with chemistry, profile, temperature, SOH/truth flags, and source identity. | Launch gate passed. | JSON/Parquet-like manifest or fixture plus tests. | Unit test for fail-closed missing evidence. |
| P12-STATS-1 | `bsebench-stats` | Add transfer preflight validator that refuses single-axis or missing-truth matrices. | P12-SPECS-1 schema draft available; can start with local fixture. | Validator and fixture. | Pytest for ready/block cases. |
| P12-FILTERS-1 | `bsebench-filters` | Add parameter-freeze metadata export for transfer evaluation. | Launch gate passed. | Adapter metadata contract tests. | Focused adapter/export tests. |
| P12-RUNNER-1 | `bsebench-runner` | Convert inventory rows into bounded transfer plans without executing large runs. | P12-DATASETS-1 manifest shape stable. | Plan fixture plus smoke test. | Dry-run test using small fixture. |
| P12-RUNNER-2 | `bsebench-runner` | Run one bounded transfer smoke only on verified local cache. | P12-RUNNER-1 and P12-STATS-1. | Artifact ledger with hashes. | Smoke command plus manifest audit. |
| P12-ASYNC-1 | `bsebench-async-codex` | Worker brief pack and mobile dashboard update. | Launch gate passed. | Briefs and status table only. | Async tests and diff-scope guard. |
| P12-AUDIT-1 | `bsebench-async-codex` | Audit first Phase 12 product commits for scope, claims, and validation. | First product commit lands. | Short audit report. | Research diff-scope guard. |
| P12-HF-REGISTRY-1 | `bsebench-datasets` or async artifact | Consolidate all local dataset registry inputs: `DatasetNameID-ProvidingInstitutionAuthors-Chemistr_part2.csv` to `_part9.csv`, locate missing part 1 if it exists, and parse `"The Definitive Registry and Meta-Analysis of Open-Source Battery Cycling and Degradation Datasets.docx"`. | Launch gate passed; no product write conflict. | Single normalized candidate registry with source-file lineage. | Row-count, required-column, and duplicate-key checks. |
| P12-HF-MATCH-1 | `bsebench-datasets` or async artifact | Match consolidated candidates against existing Hugging Face `bsebench-org/datasets` roster and local dataset manifests. | P12-HF-REGISTRY-1 output. | Status per row: uploaded, duplicate, candidate, source missing, license unknown, blocked. | Deterministic matching script and sampled manual audit. |
| P12-HF-UPLOAD-PREP-1 | `bsebench-datasets` | Prepare upload queue only for candidates with public source URL, traceable institution/authors, license/status notes, and no duplicate. | P12-HF-MATCH-1 output. | Upload-ready manifest and dry-run commands. | Dry-run only; upload execution requires row-level GO. |

## Worker Ownership

First wave should use separate worktrees and branches:

- `glassbox-phase12-specs-transfer-schema-20260509`
- `glassbox-phase12-datasets-transfer-inventory-20260509`
- `glassbox-phase12-stats-transfer-preflight-20260509`
- `glassbox-phase12-filters-freeze-metadata-20260509`
- `glassbox-phase12-runner-transfer-plan-20260509`
- `glassbox-phase12-async-briefs-20260509`
- `glassbox-phase12-hf-registry-consolidation-20260509`
- `glassbox-phase12-hf-existing-match-20260509`
- `glassbox-phase12-hf-upload-prep-20260509`

Runner bounded smoke waits for datasets/stats outputs. Audit waits for at least
one product commit. HF upload preparation waits for registry consolidation and
deduplication. No worker should start from stale Phase 9/10/11 worktrees.

## Acceptance Criteria

Phase 12 can close mechanically when:

1. Specs define the transfer evidence contract.
2. Datasets can produce a transfer-readiness inventory with source/truth flags.
3. Stats can block under-supported transfer matrices.
4. Filters export parameter-freeze metadata.
5. Runner can create a bounded transfer plan from inventory evidence.
6. At least one bounded smoke artifact has hashes, cache/source references, and
   `NO_GO_CLAIM`.
7. Async contains a final Phase 12 audit report with exact product SHAs and
   validation commands.
8. Dataset-registry work produces a line-by-line consolidated status table for
   parts 1-9 plus the definitive-registry docx, with no blind upload.

## Explicit Non-Goals

- No monthly public ranking artifact.
- No external scientific conclusion.
- No claim that BSEBench is complete or universal in practice.
- No blind dataset upload campaign. Dataset ingestion may resume only after a
  consolidated status table separates uploaded, duplicate, candidate,
  source-missing, and license-unknown rows.
- No Phase 13 work until Phase 12 has a mechanical audit.

## Current Hold

At the time of this plan, workspace cleanup is still reducing stale worktrees.
Phase 12 implementation remains paused until cleanup finishes and the cleanup
audit is committed.
