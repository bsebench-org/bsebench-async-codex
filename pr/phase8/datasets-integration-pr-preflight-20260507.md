# GLASSBOX: Phase 8 Datasets Integration PR Preflight

Metadata:
- Worker: W9-c
- Wave: 9 pre-merge and alpha-readiness acceleration
- Timestamp: 2026-05-07T22:10:00Z
- Owned write-set: `pr/phase8/datasets-integration-pr-preflight-20260507.md`
- CTO report branch: `phase-8-8-c-datasets-integration-pr-preflight-20260507T215348Z`
- Target datasets integration branch:
  `phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z`
- Target datasets pushed head observed read-only:
  `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66`
- Target datasets base observed read-only:
  `origin/main` at `2b97c256c86128bc057ec394a40610a086a7d665`
- Report status: PR PREFLIGHT READY WITH ALPHA BLOCKERS

## Decision

The datasets integration branch is a concrete PR candidate for technical review. Current pushed
evidence pins the branch head, shows it descends from current datasets `origin/main`, has clean
diff hygiene, has no conflict markers in checked source/test/split paths, and has focused test
evidence from W8-b.

Do not treat this as alpha-readiness approval. W6/W7 sidecars still record actionable blockers
around public API export intent, dataset identity joins, target normalization, truth-target
leakage, `dt_s` ownership, current-sign adoption, availability wording, and equipment provenance
aggregation. Those blockers should be either fixed before merge or recorded as explicit alpha
release blockers in the PR body.

## Direct Read-Only Checks Run By W9-c

Commands were run read-only in `/mnt/c/doctorat/bsebench-org/bsebench-datasets`.

| Check | Result |
| --- | --- |
| `git status --short --branch` | PASS: `## main...origin/main` |
| `git fetch origin --prune` | PASS |
| `git rev-parse origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z` | PASS: `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66` |
| `git rev-parse origin/main` | PASS: `2b97c256c86128bc057ec394a40610a086a7d665` |
| `git merge-base --is-ancestor origin/main origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z` | PASS: exit code 0 |
| `git diff --check origin/main..origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z` | PASS: no output |
| `git grep -n -E '<<<<<<<\|=======\|>>>>>>>' origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z -- src tests splits` | PASS: no matches; exit code 1 is expected for no matches |

Changed paths in the pushed datasets integration branch versus datasets `origin/main`:

```text
M  splits/audit_j_v1.yaml
M  src/bsebench_datasets/__init__.py
A  src/bsebench_datasets/availability.py
A  src/bsebench_datasets/dataset_card.py
A  src/bsebench_datasets/equipment_registry.py
A  src/bsebench_datasets/etl_contract.py
A  src/bsebench_datasets/ground_truth_metadata_audit.py
M  src/bsebench_datasets/splits.py
M  tests/conftest.py
A  tests/test_availability_snapshot.py
A  tests/test_dataset_card.py
A  tests/test_equipment_registry.py
A  tests/test_etl_contract.py
A  tests/test_ground_truth_metadata_audit.py
M  tests/test_split_audit_j_v1.py
```

## Evidence Chain

W5-07 validator artifact:
- Source: `validation/wave-5/datasets-integration-validator-20260507T213125Z.md` on
  `origin/phase-8-4-g-datasets-integration-validator-20260507T213125Z`.
- Status at creation time: `PENDING_REMOTE_PUSH`.
- Important limit: W5-07 did not validate focused tests on the mutable local W5-03 branch because
  the requested pushed integration branch was not present yet.
- Use in PR: historical caution only. It should not be cited as current failure evidence after the
  later pushed-head checks.

W6-03 datasets red-team artifact:
- Source: `redteam/wave5/datasets-integration-redteam-20260507T213656Z.md` on
  `origin/phase-8-5-c-datasets-integration-redteam-20260507T213656Z`.
- Observed pushed head: `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66`.
- Records worker-log evidence for focused D1-D6 tests: `60 passed`.
- Records worker-log evidence for broad non-slow suite: `292 passed, 29 deselected`.
- Records worker-log evidence that `ruff check src tests` and `git diff --check` passed.
- Red-team posture: hold public/release language and final merge readiness until successor
  validators replay gates and cross-schema falsification gates are handled or carried as blockers.

W7-k datasets ETL/backcompat audit:
- Source: `audits/wave-7/datasets-etl-backcompat-audit-20260507.md` on local branch
  `phase-8-6-k-datasets-etl-backcompat-audit-20260507T214305Z`.
- Observed pushed head: `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66`.
- Status: actionable cautions; not a merge approval.
- Main cautions: incomplete package-root exports for some Wave 1 contracts, optional `dt_s` while
  listed as a universal estimator input, metadata-only truth leakage policy, fragmented dataset
  identity keys, split target names that need explicit normalization, metadata-only availability,
  and equipment provenance states that must not be promoted.
- Push status of this evidence branch from this CTO repo: no `origin/phase-8-6-k...` ref was
  found by W9-c after `git fetch --all --prune`; treat W7-k as local evidence unless it is pushed
  before the PR is opened.

W8-b datasets current validation:
- Source: `validation/wave-8/datasets-current-validation-20260507.md` on
  `origin/phase-8-7-b-datasets-current-validation-20260507T214728Z`.
- Observed pushed head: `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66`.
- Confirmed branch existence, ancestry from current datasets `origin/main`, name-status surface,
  and `git diff --check`.
- Ran focused validation from a temporary archive of the exact remote ref.
- Focused pass signal: `60 passed in 2.53s`.
- Tooling caveat: bare `uv run ruff ...` and `uv run pytest ...` were blocked because `ruff`,
  `pytest`, and then `pytest-cov` were missing from the default environment; the checks passed
  when supplied ephemerally with `uv --with`.

W8-c stats/datasets cross-validation:
- Source: `validation/wave-8/stats-datasets-cross-validation-20260507.md` on
  `origin/phase-8-7-c-stats-datasets-cross-validation-20260507T214728Z`.
- Reconfirmed datasets pushed head `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66`, ancestry,
  diff hygiene, no conflict markers, and the same changed-path surface.
- Explicitly superseded the stale W5-07 pending-remote-push status for current branch-existence
  questions, while preserving W6/W7 blockers as not superseded.

## Suggested PR Body Facts

Safe facts to include:
- The datasets integration branch currently exists on origin at
  `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66`.
- It is a descendant of datasets `origin/main` at
  `2b97c256c86128bc057ec394a40610a086a7d665` as checked on 2026-05-07.
- `git diff --check origin/main..origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z`
  passed with no output in W8-b/W8-c evidence and in W9-c direct preflight.
- Conflict-marker grep under `src`, `tests`, and `splits` found no markers in W8-c evidence and
  in W9-c direct preflight.
- W8-b focused archive replay of the exact pushed ref recorded `60 passed in 2.53s`.
- W6-03 records W5-03 worker-log evidence for `292 passed, 29 deselected`, `ruff check src tests`,
  and `git diff --check`, but this is inherited log evidence rather than W9-c direct execution.

Do not include public wording that implies dataset source ledgers, licenses, remote mirrors,
SOC/SOH ground-truth labels, live availability, or benchmark result quality are complete or
scientifically established.

## Rollback Plan

If the datasets integration PR introduces regressions after merge:
1. Revert the merge commit in `bsebench-datasets` with a normal revert commit rather than
   rewriting history.
2. Re-run `git diff --check HEAD` and conflict-marker grep under `src`, `tests`, and `splits`.
3. Re-run the focused dataset checks from W8-b:
   `tests/test_etl_contract.py`, `tests/test_ground_truth_metadata_audit.py`,
   `tests/test_split_audit_j_v1.py`, `tests/test_dataset_card.py`,
   `tests/test_equipment_registry.py`, and `tests/test_availability_snapshot.py`.
4. If the regression is confined to package exports, either revert the export hardening commit or
   add a package-root import contract test before reattempting merge.
5. If the regression is cross-repo, leave the datasets revert in place and open follow-up issues
   for runner/stats contract ownership instead of changing runner/stats branches during this
   datasets rollback.

## Open Blockers For Alpha Readiness

Blockers to fix or explicitly carry:
- Package-root API intent: decide whether D1 ETL contract, D3 split helpers, and D5 equipment
  registry are package-root public APIs, then add an import/`__all__` contract test.
- `dt_s` ownership: choose whether every benchmark trace includes `dt_s` or runner materializes it
  before estimator stepping.
- Truth-target leakage: add runner-facing evidence that estimator step inputs exclude
  `soc_truth` and `soh_truth`.
- Current sign adoption: add one known discharge fixture per Tier 2 loader used by protocols,
  proving runner-facing discharge current has the intended sign and is not double inverted.
- Dataset identity joins: add a cross-schema fixture requiring one canonical dataset id across
  dataset cards, availability records, equipment records, and ground-truth audit records.
- Target normalization: add an explicit mapping from split targets to exact ETL fields, derived
  aggregate targets, or non-ETL metadata targets.
- Availability wording: keep D6 availability as metadata/prospect availability, not live remote
  uptime.
- Equipment provenance: keep `unknown` and `inferred` equipment states separate from
  `reported`/`file_header` evidence.
- W7-k push status: W9-c did not find an origin ref for
  `phase-8-6-k-datasets-etl-backcompat-audit-20260507T214305Z`; push or cite it as local-only
  evidence.

## W9-c Local Validation

In this CTO report worktree before commit:
- `git diff --check`: PASS, no output.

## Non-Claims

This preflight report does not claim:
- The datasets integration branch has merged to datasets `main`.
- Any dataset source ledger, license review, remote mirror, SOC/SOH truth label, or live endpoint
  is complete.
- Any benchmark result, estimator comparison, ranking position, or public release claim is
  established by this branch.
