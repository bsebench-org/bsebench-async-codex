# GLASSBOX Phase 8 Integration PR Body Templates

Worker: W7-h
Branch: `phase-8-6-h-integration-pr-bodies-ready-20260507T214305Z`
Generated: 2026-05-07
Owned write-set: `pr/phase8/integration-pr-bodies-20260507.md`

## Purpose

Prepare non-claiming pull request body templates for Wave 5 runner, stats,
datasets, and async integration branches. These bodies are templates only. They
do not open pull requests, merge branches, approve alpha release, or assert any
benchmark result, public comparison, ranking, originality, better-than status,
or scientific verification.

## Evidence Snapshot

Commands were run from:

`/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-6-h-integration-pr-bodies-ready-20260507T214305Z`

Read-only repositories inspected:

- `/mnt/c/doctorat/bsebench-org/bsebench-runner`
- `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- `/mnt/c/doctorat/bsebench-org/bsebench-datasets`
- `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report`

Fresh remote-head checks:

| Area | Integration branch | Observed remote head | Current template status |
| --- | --- | --- | --- |
| Runner | `phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z` | `e0664de6e02dd45832068de427666dbcc2bd3d10` | Ready as integration PR body, with residual gates. |
| Stats | `phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` | `08d7c2cef00a1830ac908310535e2320c41d2276` | Ready as integration PR body, with residual gates. |
| Datasets | `phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z` | `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66` | HOLD until pushed-head validation is reissued. |
| Async docs | `phase-8-4-d-async-universal-docs-integration-20260507T213125Z` | `52a7b14d0c41ab56c315bd9e14d36bcf7f358248` | HOLD until BRIEF gate failure is resolved or explicitly waived. |

Evidence branches inspected by `git show`:

- `origin/phase-8-4-e-runner-integration-validator-20260507T213125Z`
- `origin/phase-8-4-f-stats-integration-validator-20260507T213125Z`
- `origin/phase-8-4-g-datasets-integration-validator-20260507T213125Z`
- `origin/phase-8-4-h-async-integration-validator-20260507T213125Z`
- `origin/phase-8-5-a-runner-integration-redteam-20260507T213656Z`
- `origin/phase-8-5-b-stats-integration-redteam-20260507T213656Z`
- `origin/phase-8-5-c-datasets-integration-redteam-20260507T213656Z`
- `origin/phase-8-5-d-async-docs-integration-redteam-20260507T213656Z`

Fresh checks run for this artifact:

```bash
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner ls-remote --heads origin phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner diff --check origin/main..origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z

git -C /mnt/c/doctorat/bsebench-org/bsebench-stats fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats ls-remote --heads origin phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats diff --check origin/main..origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z

git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets ls-remote --heads origin phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets diff --check origin/main..origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z

git fetch origin --prune
git ls-remote --heads origin phase-8-4-d-async-universal-docs-integration-20260507T213125Z
git diff --check origin/main..origin/phase-8-4-d-async-universal-docs-integration-20260507T213125Z
```

Observed result: all four `diff --check` commands completed with no output.

Commit-message scans over runner, stats, datasets, and async integration ranges
found no forbidden Claude coauthor trailer.

## PR Body 1: Runner Integration

Repository: `bsebench-runner`

Title:

```text
[phase8] Integrate universal runner Wave 1 surfaces
```

Body:

````markdown
## Summary

Integrates the Phase 8 runner Wave 1 branch set:

- estimator adapter contract
- protocol registry models
- degraded-initialization fixtures
- leakage split guard helpers
- estimator-step profiling metadata
- toy external-submission smoke path

Integrated branch:

- `phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`
- pinned head: `e0664de6e02dd45832068de427666dbcc2bd3d10`

## GLASSBOX Evidence

- W5 runner validator recorded focused pushed-head validation at `e0664de6e02dd45832068de427666dbcc2bd3d10`.
- W6 runner red-team observed the same remote head and recorded W5 integrator log evidence for focused tests, non-slow tests, lint, and whitespace checks.
- Fresh pre-template check: `git diff --check origin/main..origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z` passed with no output.
- Commit-message scan over `origin/main..origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z` found no forbidden Claude coauthor trailer.

## Validation Commands

```bash
git fetch origin --prune
git checkout phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z
test "$(git rev-parse HEAD)" = "e0664de6e02dd45832068de427666dbcc2bd3d10"

BSEBENCH_LEGACY_AUTORESEARCH_DIR=/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch \
  uv run --extra dev pytest \
    tests/test_estimator_contract.py \
    tests/test_protocol_registry.py \
    tests/test_initialization_policy.py \
    tests/test_split_guard.py \
    tests/test_profiling.py \
    tests/test_submission_smoke.py \
    tests/test_orchestrator.py \
    -m fast -q

BSEBENCH_LEGACY_AUTORESEARCH_DIR=/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch \
  uv run --extra dev pytest -m "not slow"
uv run --extra dev ruff check .
uv run --extra dev ruff format --check .
git diff --check origin/main..HEAD
git grep -n -E '<<<<<<<|=======|>>>>>>>' -- . && exit 1 || true
git log --format=%B origin/main..HEAD | awk 'BEGIN{IGNORECASE=1} /co-authored-by:/ && /claude/ {bad=1} END{exit bad}'
```

## Residual Risks

- Universal runner APIs are split between package-root exports and submodule-only imports; public docs must match the actual import surface.
- Estimator output validation, protocol-driven execution, split guard enforcement, and invalid submission cases still need negative integration tests before public use.
- Validation depends on the legacy autoresearch path until CI supplies an equivalent fixture or the dependency is removed.

## Rollback

Before merge: close this PR and rebuild a new integration branch from `origin/main` after fixing the failed R branch.

After merge as one PR: revert the PR merge commit, rerun the previous runner non-slow gate, then rebuild from `origin/main`.

After direct merge commits: revert the integration merge commits in reverse first-parent order, rerun focused tests and `git diff --check`, then reintroduce only the fixed branch set.

## Explicit Non-Claims

This PR does not publish benchmark results, compare estimator performance, approve public release, certify datasets, or assert ranking, better-than status, originality, or scientific verification.
````

## PR Body 2: Stats Integration

Repository: `bsebench-stats`

Title:

```text
[phase8] Integrate universal stats Wave 1 reports
```

Body:

````markdown
## Summary

Integrates the Phase 8 stats Wave 1 branch set:

- metric matrix schema and builders
- convergence and recovery metrics
- robustness noise report schema
- compute cost aggregation helpers
- multi-axis report helper
- transfer matrix helpers

Integrated branch:

- `phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z`
- pinned head: `08d7c2cef00a1830ac908310535e2320c41d2276`

## GLASSBOX Evidence

- W5 stats validator records pushed-head validation at `08d7c2cef00a1830ac908310535e2320c41d2276`, including focused Wave 1 tests, export checks, scoped lint, scoped format, and whitespace check.
- W6 stats red-team confirms the branch was pushed and identifies report-schema and aggregation risks to gate before public reporting.
- Fresh pre-template check: `git diff --check origin/main..origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` passed with no output.
- Commit-message scan over `origin/main..origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` found no forbidden Claude coauthor trailer.

## Validation Commands

```bash
git fetch origin --prune
git checkout phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z
test "$(git rev-parse HEAD)" = "08d7c2cef00a1830ac908310535e2320c41d2276"

PYTHONPATH=src uv run --locked --all-extras pytest -o addopts='' \
  tests/test_metric_matrix.py \
  tests/test_convergence.py \
  tests/test_robustness_noise_schema.py \
  tests/test_compute_cost.py \
  tests/test_multi_axis_ranking.py \
  tests/test_transfer_matrix.py \
  -q

PYTHONPATH=src uv run --locked --all-extras pytest -m "not slow"
uv run --locked --all-extras ruff check src tests
uv run --locked --all-extras ruff format --check src tests
git diff --check origin/main..HEAD
git grep -n -E '<<<<<<<|=======|>>>>>>>' -- src tests && exit 1 || true
git log --format=%B origin/main..HEAD | awk 'BEGIN{IGNORECASE=1} /co-authored-by:/ && /claude/ {bad=1} END{exit bad}'
```

## Residual Risks

- `src/bsebench_stats/__init__.py` was the repeated conflict hotspot; future stats branches that add exports should be merged serially and checked for additive union.
- Public report code still needs a shared report envelope, schema-discriminator checks, and macro-versus-pooled aggregation labeling before public tables are generated.
- Runner profiling output and stats compute aggregation need a compatibility test for units and missing fields.

## Rollback

Before merge: close this PR and rebuild a new stats integration branch from `origin/main` after fixing the implicated S branch.

After merge as one PR: revert the PR merge commit, rerun the prior stats non-slow gate, and reopen a replacement integration branch.

After direct merge commits: revert S6 through S1 merge commits in reverse order, rerun focused stats tests plus export checks, then reapply a corrected serial merge.

## Explicit Non-Claims

This PR does not rank estimators, publish SOC/SOH results, establish a public comparison, or assert ranking, better-than status, originality, or scientific verification.
````

## PR Body 3: Datasets Integration

Repository: `bsebench-datasets`

Status: HOLD. The integration branch is now pushed, but the W5 independent
validator artifact predates the push and recorded `PENDING_REMOTE_PUSH`. Use
this body only after a successor validator replays the pushed head.

Title:

```text
[phase8] Integrate universal dataset Wave 1 schemas
```

Body:

````markdown
## Summary

Integrates the Phase 8 datasets Wave 1 branch set:

- ETL field contract
- ground-truth metadata audit helper
- split metadata contract
- dataset card schema
- raw equipment registry schema
- dataset availability snapshot schema

Integrated branch:

- `phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z`
- pinned head pending validator replay: `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66`

## GLASSBOX Evidence

- W5 datasets validator recorded `PENDING_REMOTE_PUSH` before the branch appeared on `origin`.
- W6 datasets red-team later observed pushed head `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66` and recorded worker-log evidence for focused tests, non-slow tests, lint, and whitespace checks.
- Fresh pre-template check: `git diff --check origin/main..origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z` passed with no output.
- Commit-message scan over `origin/main..origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z` found no forbidden Claude coauthor trailer.

## Required Pre-PR Validation

This PR body must stay on HOLD until a successor validator checks the pushed head, not a live local worktree.

```bash
git fetch origin --prune
git checkout phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z
test "$(git rev-parse HEAD)" = "6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66"

uv run --extra dev pytest \
  tests/test_etl_contract.py \
  tests/test_ground_truth_metadata_audit.py \
  tests/test_split_audit_j_v1.py \
  tests/test_dataset_card.py \
  tests/test_equipment_registry.py \
  tests/test_availability_snapshot.py \
  -q

uv run --extra dev --extra adapters-mat pytest -m "not slow" -q
uv run --extra dev ruff check src tests
uv run --extra dev ruff format --check src tests
git diff --check origin/main..HEAD
git grep -n -E '<<<<<<<|=======|>>>>>>>' -- src tests splits && exit 1 || true
git log --format=%B origin/main..HEAD | awk 'BEGIN{IGNORECASE=1} /co-authored-by:/ && /claude/ {bad=1} END{exit bad}'
```

## Residual Risks

- Dataset identity fields differ across component schemas; report builders need a canonical dataset id join gate.
- Target names differ across ETL, split, and card schemas; public workflows need explicit target mapping instead of string similarity.
- Availability snapshots are manifest records only and must not be described as live remote uptime checks.
- Equipment provenance states such as inferred or unknown must remain evidence gaps, not verified provenance.

## Rollback

Before merge: do not promote the branch; rebuild from `origin/main` after the pushed-head validator passes.

After merge as one PR: revert the PR merge commit, rerun the previous datasets non-slow gate, and open a replacement branch with the fixed schema joins.

After direct merge commits: revert D6 through D1 merge commits in reverse order, run focused dataset tests and import/export checks, then reapply only validated components.

## Explicit Non-Claims

This PR does not certify dataset licenses, source ledgers, remote uptime, SOC/SOH ground truth, benchmark results, ranking, better-than status, originality, or scientific verification.
````

## PR Body 4: Async Docs Integration

Repository: `bsebench-async-codex`

Status: HOLD. The current pushed docs integration head is whitespace-clean, but
the W5 async validator recorded a research BRIEF gate failure on the pushed
target branch.

Title:

```text
[phase8] Integrate universal benchmark control-plane docs
```

Body:

````markdown
## Summary

Integrates Phase 8 async/control-plane documentation and evidence artifacts:

- Wave 1 async submission, snapshot, charter, planner, release-checklist, and no-idle policy branches
- Wave 2 validation, audit, workflow, budget, release-risk, and backlog artifacts
- Wave 4 readiness, guardrail, source-ledger, merge-readiness, and definition-of-done artifacts
- Wave 5 docs integration ledger

Integrated branch:

- `phase-8-4-d-async-universal-docs-integration-20260507T213125Z`
- pinned head: `52a7b14d0c41ab56c315bd9e14d36bcf7f358248`

## GLASSBOX Evidence

- W5 async validator observed pushed head `52a7b14d0c41ab56c315bd9e14d36bcf7f358248`.
- W5 async validator recorded `git diff --check` and `bash -n scripts/*.sh` as passing on the pushed target.
- W5 async validator recorded `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-*/BRIEF.md` as failing with 16 failures.
- W6 async red-team later observed that the earlier trailing-whitespace replay problem was clean at `52a7b14d0c41ab56c315bd9e14d36bcf7f358248`.
- Fresh pre-template check: `git diff --check origin/main..origin/phase-8-4-d-async-universal-docs-integration-20260507T213125Z` passed with no output.
- Commit-message scan over `origin/main..origin/phase-8-4-d-async-universal-docs-integration-20260507T213125Z` found no forbidden Claude coauthor trailer.

## Required Pre-PR Validation

This PR body must stay on HOLD until the BRIEF gate failure is fixed on the pushed head or a GLASSBOX decision records why that scoped gate is not required for this docs integration.

```bash
git fetch origin --prune
git checkout phase-8-4-d-async-universal-docs-integration-20260507T213125Z
test "$(git rev-parse HEAD)" = "52a7b14d0c41ab56c315bd9e14d36bcf7f358248"

git diff --check origin/main..HEAD
bash -n scripts/*.sh
bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-*/BRIEF.md
git diff --name-only origin/main..HEAD | rg -i '(^|/)(thesis|manuscript|claims/registry\.yaml|claim_55|RESEARCH-ROADMAP)' && exit 1 || true
git log --format=%B origin/main..HEAD | awk 'BEGIN{IGNORECASE=1} /co-authored-by:/ && /claude/ {bad=1} END{exit bad}'
```

## Residual Risks

- Source-ledger definitions are duplicated across several docs; new public artifacts should treat the canonical source-ledger schema as the required source of truth.
- Public text redline policy exists as documentation, but an executable public text scanner was not inspected in this integration branch.
- Some validation snapshots are historical and should not be treated as current branch-head validation.
- Broad legacy BRIEF debt can obscure new gate failures; scoped checks must identify exactly which paths are being judged.

## Rollback

Before merge: keep the branch on HOLD and merge only after the scoped BRIEF gate passes or a written GLASSBOX waiver is recorded.

After merge as one PR: revert the PR merge commit, rerun `git diff --check`, `bash -n scripts/*.sh`, protected-path scan, and the scoped BRIEF gate on restored `main`.

After direct commits: revert the async integration commits newest-first until the scoped BRIEF gate passes, then reintroduce only the cleaned docs/control-plane artifact set.

## Explicit Non-Claims

This PR does not approve public release, source-ledger completion, public comparison text, benchmark results, ranking, better-than status, originality, or scientific verification.
````

## Artifact Validation

Required validation for this W7-h artifact:

```bash
git diff --check
```

No shell script was added, so `bash -n` and script self-test gates are not
applicable.

## Blockers

- Datasets: pushed branch exists at `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66`, but the independent W5 validator artifact predates that push and must be reissued against the pushed head before using the PR body as a passing integration PR.
- Async docs: pushed branch exists at `52a7b14d0c41ab56c315bd9e14d36bcf7f358248`, but W5 async validation recorded a scoped BRIEF gate failure on that target; keep HOLD until fixed or explicitly waived.
- Runner/stats: templates are usable for integration PRs, but both retain residual alpha-hardening gates before public release or public reporting.
