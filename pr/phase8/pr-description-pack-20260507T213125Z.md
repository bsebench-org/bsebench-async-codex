# GLASSBOX Phase 8 PR Description Pack

Worker: W5-09
Branch: `phase-8-4-i-phase8-pr-description-pack-20260507T213125Z`
Generated: 2026-05-07T23:35:19+02:00
Owned write-set: `pr/phase8/pr-description-pack-20260507T213125Z.md`

## Objective

Create integration-ready pull request descriptions for the Phase 8 universal
SOC/SOH benchmark branches, preserving GLASSBOX evidence, validation commands,
non-claims, and residual risks. This pack is a release-hardening artifact only.
It does not merge source branches, approve publication, or create scientific
claims.

## Evidence Inspected

Commands were run from:

`/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-4-i-phase8-pr-description-pack-20260507T213125Z`

Source repositories inspected:

- `/mnt/c/doctorat/bsebench-org/bsebench-runner`
- `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- `/mnt/c/doctorat/bsebench-org/bsebench-datasets`
- `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report`

Representative commands:

```bash
git fetch origin --prune
git status --short --branch
git ls-remote --heads origin 'phase-8-4-*'
git for-each-ref --format='%(refname:short) %(objectname:short) %(subject)' refs/remotes/origin/phase-8-*

git -C /mnt/c/doctorat/bsebench-org/bsebench-runner fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets fetch origin --prune

git show origin/phase-8-3-h-phase8-branch-ledger-20260507T204627Z:ledgers/phase8/branch-ledger-20260507T204627Z.md
git show origin/phase-8-3-t-phase8-merge-readiness-dashboard-20260507T204627Z:dashboards/phase8/merge-readiness-dashboard-20260507T204627Z.md
git show origin/phase-8-3-d-runner-wave1-deep-validation-20260507T204627Z:validation/wave-4/runner-wave1-deep-validation-20260507T204627Z.md
git show origin/phase-8-3-e-stats-wave1-deep-validation-20260507T204627Z:validation/wave-4/stats-wave1-deep-validation-20260507T204627Z.md
git show origin/phase-8-3-f-datasets-wave1-deep-validation-20260507T204627Z:validation/wave-4/datasets-wave1-deep-validation-20260507T204627Z.md
git show origin/phase-8-3-g-async-wave1-wave2-deep-validation-20260507T204627Z:validation/wave-4/async-wave1-wave2-deep-validation-20260507T204627Z.md
git show origin/phase-8-3-i-forbidden-edit-audit-20260507T204627Z:audits/guardrails/forbidden-edit-audit-20260507T204627Z.md
git show origin/phase-8-3-j-unsupported-claim-language-audit-20260507T204627Z:audits/guardrails/unsupported-claim-language-audit-20260507T204627Z.md

git diff --check origin/main...phase-8-4-d-async-universal-docs-integration-20260507T213125Z
```

## Branch Head Snapshot

### Runner Wave 1

| Branch | Remote head | Evidence status |
| --- | --- | --- |
| `phase-8-0-a-universal-runner-estimator-plugin-contract` | `7f590c2` | Deep validation PASS; focused gate 9 passed. |
| `phase-8-0-b-universal-runner-protocol-registry` | `acf95fa` | Deep validation PASS; focused gate 6 passed. |
| `phase-8-0-c-universal-runner-degraded-initialization` | `944a152` | Deep validation PASS; focused fast gate 17 passed. |
| `phase-8-0-d-universal-runner-leakage-split-guard` | `5d8efab` | Deep validation PASS; focused gate 6 passed. |
| `phase-8-0-e-universal-runner-compute-profiling-hooks` | `2006dff` | Deep validation PASS; focused fast gate 12 passed. |
| `phase-8-0-f-universal-runner-submission-smoke` | `ce792f3` | Deep validation PASS; focused gate 1 passed. |

Runner integration evidence:

- `origin/phase-8-3-d-runner-wave1-deep-validation-20260507T204627Z` at `d41a3f6`.
- Temporary R1-R6 integration replay over `origin/main`: no conflicts.
- Integrated focused runner suite: `43 passed in 3.58s`.
- `git diff --check`: PASS in the temporary integrated replay.

### Stats Wave 1

| Branch | Remote head | Evidence status |
| --- | --- | --- |
| `phase-8-0-g-universal-stats-metric-matrix` | `646bf3c` | Deep validation PASS; focused gate 12 passed. |
| `phase-8-0-h-universal-stats-convergence-metrics` | `eddb345` | Deep validation PASS; focused gate 6 passed in isolated UV env. |
| `phase-8-0-i-universal-stats-robustness-noise-schema` | `0d7e275` | Deep validation PASS; focused gate 8 passed. |
| `phase-8-0-j-universal-stats-compute-cost-aggregator` | `f11a151` | Deep validation PASS; focused gate 6 passed. |
| `phase-8-0-k-universal-stats-multi-axis-ranking` | `f42e0a0` | Deep validation PASS; focused gate 10 passed in isolated UV env. |
| `phase-8-0-l-universal-stats-transfer-matrix` | `59dfd52` | Deep validation PASS; focused gate 10 passed. |

Stats integration evidence:

- `origin/phase-8-3-e-stats-wave1-deep-validation-20260507T204627Z` at `dbe9e57`.
- All S1-S6 local heads matched explicit remote branches after fetch.
- Focused tests passed, but merge-readiness dashboard reports `15/15` pairwise
  conflicts centered on additive exports in `src/bsebench_stats/__init__.py`.
- S2 and S5 require isolated UV or freshly rebuilt environments for replay.

### Datasets Wave 1

| Branch | Remote head | Evidence status |
| --- | --- | --- |
| `phase-8-0-m-universal-datasets-etl-contract` | `6b6bab2` | Deep validation PASS; focused gate 8 passed. |
| `phase-8-0-n-universal-datasets-ground-truth-audit` | `a52c81d` | Deep validation PASS; focused gate 5 passed. |
| `phase-8-0-o-universal-datasets-split-metadata` | `2f0caba` | Deep validation PASS; focused gate 21 passed in isolated UV env. |
| `phase-8-0-p-universal-datasets-card-schema` | `e5f2305` | Deep validation PASS; focused gate 14 passed. |
| `phase-8-0-q-universal-datasets-equipment-registry` | `96566f9` | Deep validation PASS; focused gate 9 passed. |
| `phase-8-0-r-universal-datasets-monthly-availability` | `c1af5d0` | Deep validation PASS; focused gate 3 passed. |

Datasets integration evidence:

- `origin/phase-8-3-f-datasets-wave1-deep-validation-20260507T204627Z` at `ab2a3f2`.
- All D1-D6 local heads matched explicit remote branches after fetch.
- Merge-readiness dashboard classifies D1/D3/D5 as low-conflict and D2/D4/D6 as
  export-conflict branches centered on `src/bsebench_datasets/__init__.py`.
- D3 requires isolated UV or a rebuilt environment for replay.

### CTO Report Async, Validation, And Audit Branches

Wave 1 async branches present:

| Branch | Remote head |
| --- | --- |
| `phase-8-0-s-universal-async-submission-template` | `8b8110b` |
| `phase-8-0-t-universal-async-monthly-snapshot-schema` | `669a4ea` |
| `phase-8-0-u-universal-async-charter-gate` | `9ee3b55` |
| `phase-8-0-v-universal-async-disjoint-wave-planner` | `cbd60b3` |
| `phase-8-0-w-universal-async-public-release-checklist` | `1a337a6` |
| `phase-8-0-x-universal-async-no-idle-capacity-policy` | `ce60824` |

Wave 2 validation and audit branches present:

| Branch | Remote head | Note |
| --- | --- | --- |
| `phase-8-1-k-validator-runner-wave1-20260507T193050Z` | `4cb3433` | Stale checkpoint; runner heads later became available. |
| `phase-8-1-l-validator-stats-wave1-20260507T193050Z` | `3494f5b` | Supporting evidence. |
| `phase-8-1-m-validator-datasets-wave1-20260507T193050Z` | `03ed2ec` | Stale checkpoint; dataset heads later became available. |
| `phase-8-1-n-validator-async-wave1-20260507T193050Z` | `43da876` | Supporting evidence. |
| `phase-8-1-o-integration-conflict-map-20260507T193050Z` | `308ba38` | BLOCKED by whitespace until fixed. |
| `phase-8-1-p-universal-api-gap-audit-20260507T193050Z` | `13a91ef` | Supporting evidence. |
| `phase-8-1-q-anti-hallucination-source-ledger-audit-20260507T193050Z` | `8a0923b` | Supporting evidence; not a completed source ledger. |
| `phase-8-1-r-monthly-benchmark-workflow-design-20260507T193050Z` | `dba3ce2` | Supporting evidence. |
| `phase-8-1-s-phase17-delivery-radar-20260507T193050Z` | `a31a4f5` | Supporting evidence. |
| `phase-8-1-t-test-budget-ci-matrix-20260507T193050Z` | `be6be01` | Supporting evidence. |
| `phase-8-1-u-public-release-risk-register-20260507T193050Z` | `e6c61c3` | Supporting evidence. |
| `phase-8-1-v-48h-backlog-replenishment-20260507T193050Z` | `298b5cc` | Supporting evidence. |

Additional evidence branches:

| Branch | Remote head | Use |
| --- | --- | --- |
| `phase-8-3-a-retry-repro-artifact-manifest-20260507T204627Z` | `4185c09` | Replacement for original `phase-8-2-j` usage-limit branch. |
| `phase-8-3-b-retry-merge-queue-runbook-20260507T204627Z` | `10415cd` | Replacement for original `phase-8-2-k` usage-limit branch. |
| `phase-8-3-c-retry-worker-triage-runbook-20260507T204627Z` | `1bb6ad4` | Replacement for original `phase-8-2-l` usage-limit branch. |
| `phase-8-3-h-phase8-branch-ledger-20260507T204627Z` | `b5b0adf` | Branch ledger. |
| `phase-8-3-i-forbidden-edit-audit-20260507T204627Z` | `7fd44f3` | Protected-path and Co-Authored-By scan evidence. |
| `phase-8-3-j-unsupported-claim-language-audit-20260507T204627Z` | `a6e9296` | Unsupported claim-language scan evidence. |
| `phase-8-3-t-phase8-merge-readiness-dashboard-20260507T204627Z` | `2d550ef` | Merge readiness dashboard. |
| `phase-8-3-x-universal-bsebench-definition-of-done-20260507T204627Z` | `8d3f428` | Definition-of-done gate set. |

### Phase 8-4 Integration Branch State

After `git fetch origin --prune`, `git ls-remote --heads origin 'phase-8-4-*'`
returned no remote Phase 8-4 heads at inspection time.

Local branch state:

| Local branch | Local head | Integration status |
| --- | --- | --- |
| `phase-8-4-d-async-universal-docs-integration-20260507T213125Z` | `a4962c8` | Local-only integration branch; blocked by `git diff --check` failure. |
| `phase-8-4-e-runner-integration-validator-20260507T213125Z` | `69761bf` | Base placeholder; not completed integration evidence. |
| `phase-8-4-f-stats-integration-validator-20260507T213125Z` | `69761bf` | Base placeholder; not completed integration evidence. |
| `phase-8-4-g-datasets-integration-validator-20260507T213125Z` | `69761bf` | Base placeholder; not completed integration evidence. |
| `phase-8-4-h-async-integration-validator-20260507T213125Z` | `69761bf` | Base placeholder; not completed integration evidence. |
| `phase-8-4-j-phase8-merge-order-decision-record-20260507T213125Z` | `69761bf` | Base placeholder; not completed integration evidence. |
| `phase-8-4-k-release-candidate-manifest-20260507T213125Z` | `69761bf` | Base placeholder; not completed integration evidence. |

The local `phase-8-4-d` branch should not be used as a passing PR until this
replay failure is fixed:

```bash
git diff --check origin/main...phase-8-4-d-async-universal-docs-integration-20260507T213125Z
```

Observed result:

```text
audits/wave-1/integration-conflict-map-20260507T193050Z.md:3: trailing whitespace.
+Generated: 2026-05-07T21:43:09+02:00
audits/wave-1/integration-conflict-map-20260507T193050Z.md:4: trailing whitespace.
+Worker: I-MAP
```

## PR Body 1: Runner Integration

Repository: `bsebench-runner`

Title:

```text
[phase8] Integrate universal runner benchmark surfaces
```

Body:

````markdown
## Summary

Integrates the six Phase 8 runner Wave 1 branches that add the universal runner
foundation:

- estimator adapter contract
- protocol registry
- degraded initialization fixtures
- leakage split guard
- estimator step profiling hooks
- toy external submission smoke path

Branches:

- `phase-8-0-a-universal-runner-estimator-plugin-contract` at `7f590c2`
- `phase-8-0-b-universal-runner-protocol-registry` at `acf95fa`
- `phase-8-0-c-universal-runner-degraded-initialization` at `944a152`
- `phase-8-0-d-universal-runner-leakage-split-guard` at `5d8efab`
- `phase-8-0-e-universal-runner-compute-profiling-hooks` at `2006dff`
- `phase-8-0-f-universal-runner-submission-smoke` at `ce792f3`

## GLASSBOX Evidence

- Wave 4 runner deep-validation artifact:
  `origin/phase-8-3-d-runner-wave1-deep-validation-20260507T204627Z` at `d41a3f6`.
- All six branch heads matched their explicit `origin/<branch>` refs after
  fetch.
- Temporary R1-R6 integration replay over `origin/main` merged without
  conflicts.
- Integrated focused runner suite result: `43 passed in 3.58s`.
- Integrated replay `git diff --check`: PASS.

## Validation Commands

```bash
git fetch origin --prune

tmp=$(mktemp -d /tmp/bsebench-runner-wave1-integrated.XXXXXX)
git worktree add --detach "$tmp" origin/main
for ref in \
  origin/phase-8-0-a-universal-runner-estimator-plugin-contract \
  origin/phase-8-0-b-universal-runner-protocol-registry \
  origin/phase-8-0-c-universal-runner-degraded-initialization \
  origin/phase-8-0-d-universal-runner-leakage-split-guard \
  origin/phase-8-0-e-universal-runner-compute-profiling-hooks \
  origin/phase-8-0-f-universal-runner-submission-smoke
do
  git -C "$tmp" merge --no-edit --no-ff "$ref"
done

git -C "$tmp" diff --check
cd "$tmp"
BSEBENCH_LEGACY_AUTORESEARCH_DIR=/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch \
  UV_PROJECT_ENVIRONMENT=/tmp/bsebench-runner-wave1-integrated-venv \
  uv run --with pytest --with pytest-cov pytest \
    tests/test_estimator_contract.py \
    tests/test_protocol_registry.py \
    tests/test_initialization_policy.py \
    tests/test_split_guard.py \
    tests/test_profiling.py \
    tests/test_submission_smoke.py \
    tests/test_orchestrator.py \
    -m fast -q

BSEBENCH_LEGACY_AUTORESEARCH_DIR=/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch \
  .venv/bin/pytest -m "not slow"
.venv/bin/ruff check src tests examples
.venv/bin/ruff format --check src tests examples
git diff --check
```

## Residual Risks

- Wave 4 replay covered focused integrated tests, not the full slow suite.
- Validation depends on the local legacy autoresearch path until imports are
  decoupled or CI supplies the equivalent path.
- Shared exports and `tests/test_orchestrator.py` should receive final reviewer
  attention even though the tested merge order was conflict-free.

## Explicit Non-Claims

This PR does not claim a SOC/SOH benchmark result, public release readiness,
dataset source-ledger completion, external comparison, SOTA status, novelty,
leaderboard status, breakthrough status, or scientific claim verification.
````

## PR Body 2: Stats Integration

Repository: `bsebench-stats`

Title:

```text
[phase8] Integrate universal metrics and report helpers
```

Body:

````markdown
## Summary

Integrates the six Phase 8 stats Wave 1 branches that define universal benchmark
metric/report surfaces:

- metric matrix schema
- convergence and recovery metrics
- robustness noise report schema
- compute cost aggregation helpers
- multi-axis ranking/report helper
- transfer matrix helpers

Branches:

- `phase-8-0-g-universal-stats-metric-matrix` at `646bf3c`
- `phase-8-0-h-universal-stats-convergence-metrics` at `eddb345`
- `phase-8-0-i-universal-stats-robustness-noise-schema` at `0d7e275`
- `phase-8-0-j-universal-stats-compute-cost-aggregator` at `f11a151`
- `phase-8-0-k-universal-stats-multi-axis-ranking` at `f42e0a0`
- `phase-8-0-l-universal-stats-transfer-matrix` at `59dfd52`

## GLASSBOX Evidence

- Wave 4 stats deep-validation artifact:
  `origin/phase-8-3-e-stats-wave1-deep-validation-20260507T204627Z` at `dbe9e57`.
- All six branch heads matched their explicit remote branch refs after fetch.
- Focused gates passed:
  - S1 metric matrix: `12 passed`
  - S2 convergence metrics: `6 passed` in isolated UV env
  - S3 robustness noise schema: `8 passed`
  - S4 compute cost aggregator: `6 passed`
  - S5 multi-axis ranking: `10 passed` in isolated UV env
  - S6 transfer matrix: `10 passed`
- Branch-level `git diff --check` replay passed for S1-S6.

## Required Merge Handling

The Phase 8 merge-readiness dashboard reports pairwise conflicts for all S1-S6
pairs, centered on additive top-level exports in
`src/bsebench_stats/__init__.py`. Merge serially and resolve that file by
preserving the union of new exports. Do not drop any branch's public helper
exports during conflict resolution.

## Validation Commands

```bash
git fetch origin --prune

PYTHONPATH=src .venv/bin/python -m pytest -o addopts='' tests/test_metric_matrix.py -q
PYTHONPATH=src uv run --no-project --isolated --with pytest --with numpy --with scipy --with pydantic python -m pytest -o addopts='' tests/test_convergence.py -q
PYTHONPATH=src .venv/bin/python -m pytest -o addopts='' tests/test_robustness_noise_schema.py -q
PYTHONPATH=src .venv/bin/python -m pytest -o addopts='' tests/test_compute_cost.py -q
PYTHONPATH=src uv run --no-project --isolated --with pytest --with numpy --with scipy --with pydantic python -m pytest -o addopts='' tests/test_multi_axis_ranking.py -q
PYTHONPATH=src .venv/bin/python -m pytest -o addopts='' tests/test_transfer_matrix.py -q

PYTHONPATH=src .venv/bin/python -m pytest -m "not slow"
.venv/bin/ruff check src tests
.venv/bin/ruff format --check src tests
git diff --check
```

## Residual Risks

- S2 and S5 local `.venv` directories were not reliable during validation; use
  isolated UV or a freshly rebuilt environment.
- Broader gates reported by original worker logs were not all replayed by Wave
  4; rerun them on the final merged tree.
- Conflict resolution in `src/bsebench_stats/__init__.py` is mechanical but
  still needs reviewer inspection.

## Explicit Non-Claims

This PR does not rank any estimator, publish SOC/SOH results, certify dataset
truth, establish a public leaderboard, or make SOTA, novelty, breakthrough, or
scientific claim verification statements.
````

## PR Body 3: Datasets Integration

Repository: `bsebench-datasets`

Title:

```text
[phase8] Integrate universal dataset provenance and schema gates
```

Body:

````markdown
## Summary

Integrates the six Phase 8 datasets Wave 1 branches that harden universal
dataset ingestion and provenance:

- ETL field contract
- ground-truth metadata audit
- split metadata contract
- dataset card schema
- raw equipment registry schema
- dataset availability snapshot schema

Branches:

- `phase-8-0-m-universal-datasets-etl-contract` at `6b6bab2`
- `phase-8-0-n-universal-datasets-ground-truth-audit` at `a52c81d`
- `phase-8-0-o-universal-datasets-split-metadata` at `2f0caba`
- `phase-8-0-p-universal-datasets-card-schema` at `e5f2305`
- `phase-8-0-q-universal-datasets-equipment-registry` at `96566f9`
- `phase-8-0-r-universal-datasets-monthly-availability` at `c1af5d0`

## GLASSBOX Evidence

- Wave 4 datasets deep-validation artifact:
  `origin/phase-8-3-f-datasets-wave1-deep-validation-20260507T204627Z` at `ab2a3f2`.
- All six local branch heads matched explicit remote branch refs after fetch.
- Focused gates passed:
  - D1 ETL field contract: `8 passed`
  - D2 ground-truth metadata audit: `5 passed`
  - D3 split metadata contract: `21 passed` in isolated UV env
  - D4 dataset card schema: `14 passed`
  - D5 equipment registry schema: `9 passed`
  - D6 availability snapshot schema: `3 passed`

## Required Merge Handling

Recommended order:

1. D1 ETL contract.
2. D3 split metadata.
3. D5 equipment registry.
4. D2 ground-truth metadata audit.
5. D4 dataset card schema.
6. D6 availability snapshot.

The merge-readiness dashboard reports export conflicts among D2, D4, and D6 in
`src/bsebench_datasets/__init__.py`. Resolve by preserving the additive union of
exports, then rerun focused gates and package import checks after each merge.

## Validation Commands

```bash
git fetch origin --prune

.venv/bin/python -m pytest tests/test_etl_contract.py -q
.venv/bin/python -m pytest tests/test_ground_truth_metadata_audit.py -q
UV_PROJECT_ENVIRONMENT=/tmp/bsebench-datasets-d3-venv uv run --extra dev pytest tests/test_split_audit_j_v1.py -q
.venv/bin/python -m pytest tests/test_dataset_card.py -q
uv run --extra dev pytest tests/test_equipment_registry.py -q
.venv/bin/pytest tests/test_availability_snapshot.py -q

.venv/bin/python -m pytest -m "not slow"
.venv/bin/ruff check src tests
.venv/bin/ruff format --check src tests
git diff --check
```

## Residual Risks

- D3 branch-local `.venv` had a stale or broken NumPy import state; use isolated
  UV or rebuild the environment.
- D1-D6 were validated as focused branch candidates. A combined post-merge run
  can still expose import/export issues.
- D6 availability snapshots are manifest/prospect records only. They do not
  verify live remote endpoint uptime.

## Explicit Non-Claims

This PR does not claim dataset source ledgers are complete, remote mirrors are
live, redistribution licenses are sufficient, SOC/SOH labels are scientifically
established, or any estimator family has been benchmarked or ranked.
````

## PR Body 4: CTO Report Async And Wave 2 Control Plane

Repository: `bsebench-async-codex`

Status: HOLD. Do not submit the current local integration branch as a passing
PR until the whitespace replay failure is fixed.

Title:

```text
[phase8] Integrate async control-plane and Wave 2 evidence
```

Body:

````markdown
## Summary

This integration branch is intended to assemble Phase 8 CTO-report control-plane
artifacts:

- Wave 1 async submission, monthly snapshot, charter gate, disjoint planner,
  release checklist, and no-idle policy branches.
- Wave 2 validator, audit, workflow, test-budget, release-risk, and backlog
  branches.

## GLASSBOX Evidence

- Async/Wave 1 deep-validation artifact:
  `origin/phase-8-3-g-async-wave1-wave2-deep-validation-20260507T204627Z` at `5e06094`.
- Branch ledger:
  `origin/phase-8-3-h-phase8-branch-ledger-20260507T204627Z` at `b5b0adf`.
- Guardrail audits:
  - forbidden edit audit at `7fd44f3`
  - unsupported claim language audit at `a6e9296`
- Merge readiness dashboard:
  `origin/phase-8-3-t-phase8-merge-readiness-dashboard-20260507T204627Z` at `2d550ef`.

## Current Blocker

Replay against the local integration branch fails:

```bash
git diff --check origin/main...phase-8-4-d-async-universal-docs-integration-20260507T213125Z
```

Observed failure:

```text
audits/wave-1/integration-conflict-map-20260507T193050Z.md:3: trailing whitespace.
audits/wave-1/integration-conflict-map-20260507T193050Z.md:4: trailing whitespace.
```

The branch must remove the trailing whitespace from
`audits/wave-1/integration-conflict-map-20260507T193050Z.md` and replay the
checks below before this PR body can be used as a passing integration PR.

## Validation Commands

```bash
git fetch origin --prune
git diff --check origin/main...HEAD
bash -n scripts/*.sh
bash scripts/check-research-brief-gates.sh --dry-run
bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md

git log --format=%B origin/main..HEAD | rg -i 'Co-Authored-By:.*Claude' && exit 1 || true
git diff --name-only origin/main..HEAD | rg -i '(^|/)(thesis|manuscript|claims/registry\.yaml|claim_55|RESEARCH-ROADMAP)' && exit 1 || true
git diff origin/main..HEAD | rg -i 'SOTA|novelty|leaderboard|breakthrough|verified-claim' && exit 1 || true
```

The broad command below is known to fail on legacy inbox Phase 7 BRIEFs and
should not be used as the sole branch verdict until that pre-existing debt is
remediated:

```bash
bash scripts/check-research-brief-gates.sh --dry-run --all
```

## Residual Risks

- The local `phase-8-4-d` branch is not a remote head at inspection time.
- Wave 2 `phase-8-1-k` and `phase-8-1-m` are historical validator snapshots
  that became stale after runner and dataset heads appeared.
- The source-ledger audit defines required fields and rejection rules; it is not
  a completed public source ledger.
- Original failed branches `phase-8-2-j/k/l` must stay excluded. Use retry
  branches `phase-8-3-a/b/c` instead.

## Explicit Non-Claims

This PR does not approve public release, source-ledger completion, external
comparability, benchmark ranking, SOTA status, novelty, breakthrough status, or
scientific claim verification.
````

## Non-Claims For This Pack

- This pack does not claim BSEBench is public-ready.
- This pack does not claim any SOC/SOH numerical benchmark result.
- This pack does not rank ECMs, Kalman filters, observers, AI estimators,
  hybrid methods, or future filters.
- This pack does not certify dataset licensing, public availability, ground
  truth, or source-ledger completeness.
- This pack does not edit thesis files, manuscript files, claim registry files,
  `claims/registry.yaml`, `claim_55`, or the scientific roadmap.
- This pack does not create or submit any GitHub pull request.

## Residual Risks

- Watchdog logs are live operational records, not immutable CI artifacts.
- Some Phase 8-4 local branches were still placeholders at inspection time.
- Runner, stats, and datasets integration bodies rely on remote Phase 8 Wave 1
  branch heads and Wave 4 validation artifacts, but final PRs must re-fetch and
  pin exact SHAs immediately before merge.
- Stats and datasets have known additive export conflicts that need serial,
  reviewer-visible resolution.
- Broad async research-brief gate `--all` currently fails on legacy inbox debt;
  use scoped gates unless the legacy backlog is fixed.

## Validation For This Artifact

Commands run for W5-09 artifact creation:

```bash
git fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets fetch origin --prune
git merge --ff-only origin/main
git diff --check origin/main...phase-8-4-d-async-universal-docs-integration-20260507T213125Z
git diff --check
```

Results:

- Current worktree fast-forwarded cleanly to `origin/main` at `357e990`.
- `git ls-remote --heads origin 'phase-8-4-*'`: no remote Phase 8-4 heads.
- Local `phase-8-4-d` replay: FAIL on trailing whitespace in
  `audits/wave-1/integration-conflict-map-20260507T193050Z.md` lines 3-4.
- This artifact's `git diff --check`: PASS after writing.
