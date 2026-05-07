# Phase 8 Integration Merge Command Dry Run - 2026-05-07

GLASSBOX:
- worker: W9-i
- branch: `phase-8-8-i-integration-merge-command-dryrun-20260507T215348Z`
- owned_write_set: `runbooks/merge/phase8-integration-merge-command-dryrun-20260507.md`
- integration_action_taken: none
- scope: manual dry-run runbook for runner, stats, datasets, and async/docs integration branches

This runbook lists exact commands for a manual integration dry run. It is not a
merge approval and does not perform, request, or imply any source merge. Unknown
or stale evidence remains unknown or blocked until replayed at the exact fetched
head.

## Candidate Refs

Snapshot sources: Wave 8 current validation artifacts and local read-only ref
inspection on 2026-05-07.

| Lane | Repo path | Candidate ref | Candidate SHA | Base SHA sampled | Current state |
| --- | --- | --- | --- | --- | --- |
| runner | `/mnt/c/doctorat/bsebench-org/bsebench-runner` | `origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z` | `e0664de6e02dd45832068de427666dbcc2bd3d10` | `66bd8273fde4f19dde1283f8739f322794e612db` | Code merge candidate after exact-head replay. |
| stats | `/mnt/c/doctorat/bsebench-org/bsebench-stats` | `origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` | `08d7c2cef00a1830ac908310535e2320c41d2276` | `d7bb8bc333895e41e377c7e21eed389a6bd83097` | Conditional code candidate; W6 asked for fresh clean replay. |
| datasets | `/mnt/c/doctorat/bsebench-org/bsebench-datasets` | `origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z` | `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66` | `2b97c256c86128bc057ec394a40610a086a7d665` | Candidate after W8 focused replay; bare default `uv run ruff` and `uv run pytest` tooling remain blocked unless tools are supplied. |
| async/docs | `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-8-i-integration-merge-command-dryrun-20260507T215348Z` | `origin/phase-8-4-d-async-universal-docs-integration-20260507T213125Z` | `52a7b14d0c41ab56c315bd9e14d36bcf7f358248` | `357e990ffd23c3d41581117bb02bf7368816ddcd` | Blocked for merge GO by broad BRIEF-gate failure. Dry-run only. |

## Global Abort Conditions

Abort the lane and write a failure note instead of merging if any condition
below is observed:

- `git fetch origin --prune` fails.
- The candidate SHA differs from the expected SHA above and no newer validation
  artifact pins and approves the new SHA.
- `git rev-list --left-right --count origin/main...<candidate>` shows the
  candidate is behind `origin/main`.
- `git merge-tree --write-tree origin/main <candidate>` exits non-zero.
- The merge-tree textual conflict scan finds `<<<<<<<`, `=======`, or `>>>>>>>`.
- `git diff --check origin/main..<candidate>` fails.
- Protected paths appear in the candidate diff: thesis, manuscript, claim
  registry, `claims/registry.yaml`, `claim_55`, or roadmap paths.
- A commit body contains a Claude coauthor trailer.
- Unsupported performance-claim wording appears outside an explicit guardrail
  or ban-list context.
- Focused replay, non-slow tests, import checks, ruff, format, or project-local
  guard scripts fail.
- The operator would need to delete existing validation artifacts, public
  exports, GLASSBOX metadata, or tests to resolve a conflict.

## Shared Dry-Run Harness

Use this helper pattern per repo. It records candidate identity, ancestry,
diff hygiene, protected-path checks, claim-language scan, and merge-tree
feasibility without changing any branch.

```bash
set -euo pipefail

REPO=/mnt/c/doctorat/bsebench-org/bsebench-runner
REF=origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z
EXPECTED_SHA=e0664de6e02dd45832068de427666dbcc2bd3d10

cd "$REPO"
git fetch origin --prune
test "$(git rev-parse "$REF")" = "$EXPECTED_SHA"
git rev-list --left-right --count origin/main..."$REF"
git merge-base --is-ancestor origin/main "$REF"
git diff --name-status origin/main.."$REF"
git diff --check origin/main.."$REF"
git merge-tree --write-tree origin/main "$REF" >/tmp/bsebench-phase8-merge-tree.txt
git merge-tree origin/main "$REF" | rg -n '<<<<<<<|=======|>>>>>>>' && exit 1 || true
git diff --name-only origin/main.."$REF" \
  | rg -i '(^|/)(thesis|manuscript|claims/registry|registry\.ya?ml|claim_55|.*roadmap.*)' \
  && exit 1 || true
git log --format='%H%n%B%n---END---' origin/main.."$REF" \
  | rg -i 'co-authored-by:.*claud[e]' \
  && exit 1 || true
git grep -n -i -E 'state-of-the-art|SOTA|leaderboard|breakthrough|superior|superiority|verified scientific|verified claim' "$REF" -- . \
  || true
```

Manual classification is required for claim-language hits because guardrail
documents may intentionally quote banned words.

## Runner Dry Run

The runner branch is mechanically clean in Wave 8 evidence and remains a code
candidate only after exact-head replay.

```bash
set -euo pipefail
REPO=/mnt/c/doctorat/bsebench-org/bsebench-runner
REF=origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z
EXPECTED_SHA=e0664de6e02dd45832068de427666dbcc2bd3d10
cd "$REPO"
git fetch origin --prune
test "$(git rev-parse "$REF")" = "$EXPECTED_SHA"
git merge-base --is-ancestor origin/main "$REF"
git rev-list --left-right --count origin/main..."$REF"
git diff --check origin/main.."$REF"
git merge-tree --write-tree origin/main "$REF" >/tmp/bsebench-runner-phase8.tree
git merge-tree origin/main "$REF" | rg -n '<<<<<<<|=======|>>>>>>>' && exit 1 || true
git diff --name-only origin/main.."$REF" \
  | rg -i '(^|/)(thesis|manuscript|claims/registry|registry\.ya?ml|claim_55|.*roadmap.*)' \
  && exit 1 || true
git log --format='%H%n%B%n---END---' origin/main.."$REF" \
  | rg -i 'co-authored-by:.*claud[e]' \
  && exit 1 || true

tmpdir=$(mktemp -d /tmp/bsebench-runner-phase8-dryrun-XXXXXX)
git archive "$REF" | tar -x -C "$tmpdir"
cd "$tmpdir"
uv run --all-extras pytest tests/test_universal_estimator_plugin_contract.py tests/test_universal_protocol_registry.py tests/test_degraded_initialization.py tests/test_leakage_split_guard.py tests/test_compute_profiling.py tests/test_submission_smoke.py -q
uv run --all-extras pytest -m "not slow" --tb=short
uv run --all-extras ruff check src tests examples
uv run --all-extras ruff format --check src tests examples
```

Runner abort additions:
- Abort if `BSEBENCH_LEGACY_AUTORESEARCH_DIR` is required by the target test
  environment and is unavailable.
- Abort if focused tests pass only by relying on uncommitted sibling checkout
  state.

## Stats Dry Run

Stats is a conditional code candidate. W6 recorded AMBER status and asked for a
fresh clean validator pinned to `08d7c2c`.

```bash
set -euo pipefail
REPO=/mnt/c/doctorat/bsebench-org/bsebench-stats
REF=origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z
EXPECTED_SHA=08d7c2cef00a1830ac908310535e2320c41d2276
cd "$REPO"
git fetch origin --prune
test "$(git rev-parse "$REF")" = "$EXPECTED_SHA"
git merge-base --is-ancestor origin/main "$REF"
git rev-list --left-right --count origin/main..."$REF"
git diff --check origin/main.."$REF"
git grep -n -E '<<<<<<<|=======|>>>>>>>' "$REF" -- src tests && exit 1 || true
git merge-tree --write-tree origin/main "$REF" >/tmp/bsebench-stats-phase8.tree
git merge-tree origin/main "$REF" | rg -n '<<<<<<<|=======|>>>>>>>' && exit 1 || true
git diff --name-only origin/main.."$REF" \
  | rg -i '(^|/)(thesis|manuscript|claims/registry|registry\.ya?ml|claim_55|.*roadmap.*)' \
  && exit 1 || true
git log --format='%H%n%B%n---END---' origin/main.."$REF" \
  | rg -i 'co-authored-by:.*claud[e]' \
  && exit 1 || true

tmpdir=$(mktemp -d /tmp/bsebench-stats-phase8-dryrun-XXXXXX)
git archive "$REF" | tar -x -C "$tmpdir"
cd "$tmpdir"
uv run --all-extras pytest tests/test_metric_matrix.py tests/test_convergence.py tests/test_robustness_noise_schema.py tests/test_compute_cost.py tests/test_multi_axis_ranking.py tests/test_transfer_matrix.py -q
uv run --all-extras pytest -m "not slow" --tb=short
uv run --all-extras ruff check src tests
uv run --all-extras ruff format --check src tests
uv run --all-extras python - <<'PY'
from bsebench_stats import (
    compute_cost_summary,
    convergence_summary,
    metric_matrix,
    multi_axis_ranking,
    robustness_noise_summary,
    transfer_matrix,
)
print("stats imports ok")
PY
```

Stats abort additions:
- Abort if `src/bsebench_stats/__init__.py` cannot preserve all existing and
  candidate exports by additive union.
- Abort if ranking or metric wording is promoted as public benchmark evidence
  instead of schema/tooling behavior.

## Datasets Dry Run

Datasets now has W8 focused validation at `6cbdc54`, but default project-tool
commands exposed missing `ruff`, `pytest`, and `pytest-cov` unless supplied
ephemerally. Treat that as a toolchain blocker for default-command merge gates.

```bash
set -euo pipefail
REPO=/mnt/c/doctorat/bsebench-org/bsebench-datasets
REF=origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z
EXPECTED_SHA=6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66
cd "$REPO"
git fetch origin --prune
test "$(git rev-parse "$REF")" = "$EXPECTED_SHA"
git merge-base --is-ancestor origin/main "$REF"
git rev-list --left-right --count origin/main..."$REF"
git diff --check origin/main.."$REF"
git grep -n -E '<<<<<<<|=======|>>>>>>>' "$REF" -- src tests splits && exit 1 || true
git merge-tree --write-tree origin/main "$REF" >/tmp/bsebench-datasets-phase8.tree
git merge-tree origin/main "$REF" | rg -n '<<<<<<<|=======|>>>>>>>' && exit 1 || true
git diff --name-only origin/main.."$REF" \
  | rg -i '(^|/)(thesis|manuscript|claims/registry|registry\.ya?ml|claim_55|.*roadmap.*)' \
  && exit 1 || true
git log --format='%H%n%B%n---END---' origin/main.."$REF" \
  | rg -i 'co-authored-by:.*claud[e]' \
  && exit 1 || true

tmpdir=$(mktemp -d /tmp/bsebench-datasets-phase8-dryrun-XXXXXX)
git archive "$REF" | tar -x -C "$tmpdir"
cd "$tmpdir"
uv run --with ruff ruff format --check \
  src/bsebench_datasets/availability.py \
  src/bsebench_datasets/dataset_card.py \
  src/bsebench_datasets/equipment_registry.py \
  src/bsebench_datasets/etl_contract.py \
  src/bsebench_datasets/ground_truth_metadata_audit.py \
  src/bsebench_datasets/splits.py \
  tests/test_availability_snapshot.py \
  tests/test_dataset_card.py \
  tests/test_equipment_registry.py \
  tests/test_etl_contract.py \
  tests/test_ground_truth_metadata_audit.py \
  tests/test_split_audit_j_v1.py
uv run --with ruff ruff check \
  src/bsebench_datasets/availability.py \
  src/bsebench_datasets/dataset_card.py \
  src/bsebench_datasets/equipment_registry.py \
  src/bsebench_datasets/etl_contract.py \
  src/bsebench_datasets/ground_truth_metadata_audit.py \
  src/bsebench_datasets/splits.py \
  tests/test_availability_snapshot.py \
  tests/test_dataset_card.py \
  tests/test_equipment_registry.py \
  tests/test_etl_contract.py \
  tests/test_ground_truth_metadata_audit.py \
  tests/test_split_audit_j_v1.py
uv run --with pytest --with pytest-cov pytest \
  tests/test_availability_snapshot.py \
  tests/test_dataset_card.py \
  tests/test_equipment_registry.py \
  tests/test_etl_contract.py \
  tests/test_ground_truth_metadata_audit.py \
  tests/test_split_audit_j_v1.py
```

Datasets abort additions:
- Abort if default project tooling is required and `uv run ruff ...` or
  `uv run pytest ...` still cannot spawn the executable without `--with`.
- Abort if raw dataset assets, source licenses, or availability snapshots are
  represented as public-release evidence without dedicated source-ledger proof.
- Abort if `src/bsebench_datasets/__init__.py` cannot preserve all existing and
  candidate exports by additive union.

## Async/Docs Dry Run

Async/docs is blocked for unconditional merge GO because the broad dry-run
research BRIEF gate still fails on 16 legacy Phase 7 backlog briefs. Use this
lane only to reproduce the block and confirm that the current ref remains
mechanically inspectable.

```bash
set -euo pipefail
REPO=/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-8-i-integration-merge-command-dryrun-20260507T215348Z
REF=origin/phase-8-4-d-async-universal-docs-integration-20260507T213125Z
EXPECTED_SHA=52a7b14d0c41ab56c315bd9e14d36bcf7f358248
cd "$REPO"
git fetch origin --prune
test "$(git rev-parse "$REF")" = "$EXPECTED_SHA"
git merge-base --is-ancestor origin/main "$REF"
git rev-list --left-right --count origin/main..."$REF"
git diff --check origin/main.."$REF"
git merge-tree --write-tree origin/main "$REF" >/tmp/bsebench-async-docs-phase8.tree
git merge-tree origin/main "$REF" | rg -n '<<<<<<<|=======|>>>>>>>' && exit 1 || true
git diff --name-only origin/main.."$REF" \
  | rg -i '(^|/)(thesis|manuscript|claims/registry|registry\.ya?ml|claim_55|.*roadmap.*)' \
  && exit 1 || true
git log --format='%H%n%B%n---END---' origin/main.."$REF" \
  | rg -i 'co-authored-by:.*claud[e]' \
  && exit 1 || true

tmpdir=$(mktemp -d /tmp/bsebench-async-docs-phase8-dryrun-XXXXXX)
git archive "$REF" | tar -x -C "$tmpdir"
cd "$tmpdir"
bash -n scripts/*.sh
bash tests/check-research-brief-gates.sh
bash tests/test-disjoint-wave-planner.sh
bash scripts/check-no-idle-capacity-policy.sh --self-test
bash scripts/probe-autonomy-pacer-safety.sh
jq empty docs/schemas/bsebench-monthly-benchmark-snapshot-v1.schema.json docs/fixtures/monthly-benchmark-snapshot/valid-minimal.json docs/fixtures/monthly-benchmark-snapshot/invalid-missing-row-caveat.json
bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-*/BRIEF.md
```

Expected current result for the final command: blocked, with
`Research BRIEF gate checks failed: 16 failure(s), 16 checked, 0 skipped.`

Async/docs abort additions:
- Abort any merge promotion while the broad BRIEF-gate failure remains
  unresolved or unscoped by an accepted successor validator.
- Abort if stale validators are used as readiness evidence instead of blocker
  evidence.

## Post-Merge Checks To Run Only After An Approved Manual Merge

These commands are for a future operator after a separate approval to merge.
They must not be run as part of this dry-run task.

Runner:

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-runner
git status --short --branch
git diff --check
uv run --all-extras pytest -m "not slow" --tb=short
uv run --all-extras ruff check src tests examples
uv run --all-extras ruff format --check src tests examples
git log --oneline --decorate -20
```

Stats:

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-stats
git status --short --branch
git diff --check
uv run --all-extras pytest -m "not slow" --tb=short
uv run --all-extras ruff check src tests
uv run --all-extras ruff format --check src tests
git log --oneline --decorate -20
```

Datasets:

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-datasets
git status --short --branch
git diff --check
uv run --with pytest --with pytest-cov pytest tests/test_availability_snapshot.py tests/test_dataset_card.py tests/test_equipment_registry.py tests/test_etl_contract.py tests/test_ground_truth_metadata_audit.py tests/test_split_audit_j_v1.py
uv run --with ruff ruff check src tests
uv run --with ruff ruff format --check src tests
git log --oneline --decorate -20
```

Async/docs:

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report
git status --short --branch
git diff --check
bash -n scripts/*.sh
bash tests/check-research-brief-gates.sh
bash tests/test-disjoint-wave-planner.sh
bash scripts/check-no-idle-capacity-policy.sh --self-test
bash scripts/probe-autonomy-pacer-safety.sh
bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-*/BRIEF.md
git log --oneline --decorate -20
```

## Final Dry-Run Decision

- Runner: dry-run eligible; exact-head replay required before any merge.
- Stats: dry-run eligible; still conditional on fresh clean replay at
  `08d7c2c`.
- Datasets: dry-run eligible; W8 focused replay supports the pushed head, but
  default toolchain spawn failures remain a merge-gate caveat.
- Async/docs: blocked for merge promotion until the broad BRIEF-gate failure is
  remediated or a successor validator scopes and approves the failure.

No lane is release-ready or public-claims-ready from this runbook alone.
