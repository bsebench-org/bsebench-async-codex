# GLASSBOX Wave 8 Stats/Datasets Cross-Validation

- Worker: W8-c
- Created UTC: 2026-05-07T21:52:16Z
- Branch: `phase-8-7-c-stats-datasets-cross-validation-20260507T214728Z`
- Owned write-set: `validation/wave-8/stats-datasets-cross-validation-20260507.md`
- Scope: read-only current-state validation for stats and datasets Wave 5 integration heads.

This artifact checks pushed branch evidence only. It does not edit stats or datasets repos, does
not merge integration branches, and does not make benchmark-result, SOTA, novelty, leaderboard,
breakthrough, superiority, universal-proven, or verified scientific claims.

## Evidence Sources

Prior evidence inspected:

- W5-06 stats validator:
  `validation/wave-5/stats-integration-validator-20260507T213125Z.md` on
  `origin/phase-8-4-f-stats-integration-validator-20260507T213125Z`.
- W5-07 datasets validator:
  `validation/wave-5/datasets-integration-validator-20260507T213125Z.md` on
  `origin/phase-8-4-g-datasets-integration-validator-20260507T213125Z`.
- W5-15 cross-repo API contract ledger:
  `ledgers/contracts/cross-repo-api-contract-ledger-20260507T213125Z.md` on
  `origin/phase-8-4-o-cross-repo-api-contract-ledger-20260507T213125Z`.
- W6/W7 sidecar context:
  `redteam/wave5/stats-integration-redteam-20260507T213656Z.md`,
  `redteam/wave5/datasets-integration-redteam-20260507T213656Z.md`,
  `audits/wave-7/stats-metrics-backcompat-audit-20260507.md`, and
  `audits/wave-7/datasets-etl-backcompat-audit-20260507.md`.
- W8-b current datasets validation:
  `validation/wave-8/datasets-current-validation-20260507.md` in the
  `phase-8-7-b-datasets-current-validation-20260507T214728Z` worktree.

## Current Branch Head Checks

Commands were run read-only after `git fetch origin --prune` in each source repo.

### Stats

Source repo: `/mnt/c/doctorat/bsebench-org/bsebench-stats`

Target branch:
`origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z`

Observed heads:

| Ref | SHA |
| --- | --- |
| `origin/main` | `d7bb8bc333895e41e377c7e21eed389a6bd83097` |
| Integration branch | `08d7c2cef00a1830ac908310535e2320c41d2276` |

Checks:

| Check | Result |
| --- | --- |
| `git ls-remote --heads origin phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` | PASS, returned `08d7c2cef00a1830ac908310535e2320c41d2276`. |
| `git merge-base --is-ancestor origin/main origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` | PASS, exit code 0. |
| `git diff --check origin/main..origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` | PASS, no output. |
| `git grep -n -E '<<<<<<<|=======|>>>>>>>' origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z -- src tests` | PASS, no matches; exit code 1 is expected for no matches. |

Name-status versus `origin/main`:

```text
M	src/bsebench_stats/__init__.py
A	src/bsebench_stats/compute_cost.py
A	src/bsebench_stats/convergence.py
A	src/bsebench_stats/metric_matrix.py
A	src/bsebench_stats/multi_axis_ranking.py
A	src/bsebench_stats/robustness_noise_schema.py
A	src/bsebench_stats/transfer_matrix.py
A	tests/test_compute_cost.py
A	tests/test_convergence.py
A	tests/test_metric_matrix.py
A	tests/test_multi_axis_ranking.py
A	tests/test_robustness_noise_schema.py
A	tests/test_transfer_matrix.py
```

Comparison to prior evidence:

- W5-06 pins the same pushed stats head, `08d7c2cef00a1830ac908310535e2320c41d2276`,
  and records focused stats tests, export checks, scoped Ruff checks, and `git diff --check` as
  passed.
- W5-15 also recorded this stats pushed head, but characterized the ledger evidence as
  `git diff --check` only. Current W8-c evidence independently reconfirms the exact pushed head,
  fast-forward ancestry from `origin/main`, name-status surface, whitespace hygiene, and absence
  of conflict markers.

### Datasets

Source repo: `/mnt/c/doctorat/bsebench-org/bsebench-datasets`

Target branch:
`origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z`

Observed heads:

| Ref | SHA |
| --- | --- |
| `origin/main` | `2b97c256c86128bc057ec394a40610a086a7d665` |
| Integration branch | `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66` |

Checks:

| Check | Result |
| --- | --- |
| `git ls-remote --heads origin phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z` | PASS, returned `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66`. |
| `git merge-base --is-ancestor origin/main origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z` | PASS, exit code 0. |
| `git diff --check origin/main..origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z` | PASS, no output. |
| `git grep -n -E '<<<<<<<|=======|>>>>>>>' origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z -- src tests splits` | PASS, no matches; exit code 1 is expected for no matches. |

Name-status versus `origin/main`:

```text
M	splits/audit_j_v1.yaml
M	src/bsebench_datasets/__init__.py
A	src/bsebench_datasets/availability.py
A	src/bsebench_datasets/dataset_card.py
A	src/bsebench_datasets/equipment_registry.py
A	src/bsebench_datasets/etl_contract.py
A	src/bsebench_datasets/ground_truth_metadata_audit.py
M	src/bsebench_datasets/splits.py
M	tests/conftest.py
A	tests/test_availability_snapshot.py
A	tests/test_dataset_card.py
A	tests/test_equipment_registry.py
A	tests/test_etl_contract.py
A	tests/test_ground_truth_metadata_audit.py
M	tests/test_split_audit_j_v1.py
```

Comparison to prior evidence:

- W5-07 is stale as current evidence. It correctly recorded `PENDING_REMOTE_PUSH` when the
  datasets integration branch was absent from origin, but the branch now exists at
  `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66`.
- W5-15 recorded the same datasets pushed head and `git diff --check` pass, but did not have an
  independent focused-test replay at ledger creation time.
- W8-b subsequently pinned the same pushed datasets head, confirmed fast-forward ancestry,
  recorded the same name-status surface, and ran focused tests in a temporary archive of the
  exact remote ref: `60 passed in 2.53s` with `uv --with pytest --with pytest-cov`. W8-b also
  recorded that bare `uv run pytest` and `uv run ruff` were blocked by missing default tools until
  supplied ephemerally.

## W5-15 Supersession Decision

The W5-15 note is superseded for the narrow current-state questions it left open:

- Stats and datasets integration branch heads are currently present on origin.
- The current pushed SHAs match the W5-15 recorded pushed heads:
  `08d7c2cef00a1830ac908310535e2320c41d2276` for stats and
  `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66` for datasets.
- Both branches are descendants of their current `origin/main` refs.
- Both branches have clean `git diff --check` results and no conflict markers under the checked
  source/test paths.
- The W5-07 `PENDING_REMOTE_PUSH` status is historical and should not be used as current failure
  evidence for the datasets integration branch.

The W5-15 note is not superseded as a broad alpha-readiness approval. W6/W7 sidecars still record
actionable blockers or cautions around public metric tables, ranking language, compute evidence
tiers, dataset identity joins, target normalization, truth-target leakage, `dt_s` ownership, and
release wording. Those are outside this W8-c lightweight branch-head and diff-hygiene validation.

## Blockers and Limits

- W8-c did not rerun source-package focused or non-slow test suites. This report is limited to
  pushed-ref, ancestry, name-status, whitespace, and conflict-marker checks, plus comparison
  against existing W5/W6/W7/W8-b evidence.
- W8-c did not validate raw dataset assets, licenses, source-ledger completeness, estimator
  performance, SOC/SOH scores, external comparisons, or public benchmark results.
- Any newer stats or datasets integration SHA requires replaying this check.

## Local Artifact Validation

Before commit, this report branch had:

- `git status --short --branch`: on
  `phase-8-7-c-stats-datasets-cross-validation-20260507T214728Z`.
- `git diff --check`: PASS before writing this artifact.
