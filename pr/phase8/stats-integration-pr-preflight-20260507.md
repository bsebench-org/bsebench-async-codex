# GLASSBOX Stats Integration PR Preflight

- Worker: W9-b
- Created: 2026-05-07
- Branch: `phase-8-8-b-stats-integration-pr-preflight-20260507T215348Z`
- Owned write-set: `pr/phase8/stats-integration-pr-preflight-20260507.md`
- Scope: pre-merge report for the pushed Wave 5 stats integration branch.
- PR action: no PR opened by this worker.

This report uses pushed branch evidence and read-only source inspection only.
It does not edit stats, runner, datasets, thesis, manuscript, claim registry,
`claims/registry.yaml`, `claim_55`, or roadmap files.

## Preflight Decision

Status: AMBER for merge preflight.

The current pushed stats integration branch is present, descendant from the
current stats `origin/main`, whitespace-clean, and has no conflict markers in
the inspected source/test paths. W5-02 and W5-06 evidence records focused Wave
1 tests, package export checks, Ruff checks, and the stats non-slow suite as
passed on the pushed integration surface.

This is not an alpha-readiness approval. W6/W7 sidecars still block public
metric tables, sorted summaries, compute comparisons, and broad transfer
summaries until the report-layer metadata and wording gates below are in place.

## Pinned Branch Evidence

| Item | Evidence |
| --- | --- |
| Stats source repo | `/mnt/c/doctorat/bsebench-org/bsebench-stats` |
| Stats integration ref | `origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` |
| Stats integration SHA | `08d7c2cef00a1830ac908310535e2320c41d2276` |
| Stats `origin/main` SHA at inspection | `d7bb8bc333895e41e377c7e21eed389a6bd83097` |
| W5-06 validator artifact ref | `origin/phase-8-4-f-stats-integration-validator-20260507T213125Z` at `ca913c8` |
| W6 stats red-team artifact ref | `origin/phase-8-5-b-stats-integration-redteam-20260507T213656Z` |
| W7-j backcompat audit ref | `origin/phase-8-6-j-stats-metrics-backcompat-audit-20260507T214305Z` at `bff7f9d` |
| W8-c current cross-check ref | `origin/phase-8-7-c-stats-datasets-cross-validation-20260507T214728Z` |

The stats integration head commit subject is:

```text
GLASSBOX [role: worker-W5-02] Integrate Wave 1 universal stats branches
```

Its commit body records S1-S6 integration for metric matrix, convergence
metrics, robustness noise schema, compute cost aggregation, multi-axis ranking,
and transfer matrix. It also records that S2-S6 conflicted only in
`src/bsebench_stats/__init__.py` package exports and were resolved by preserving
all branch-owned imports and `__all__` entries.

## Source Diff Surface

Read-only `git diff --name-status origin/main..origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z`
in the stats repo reported:

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

No stats source files were edited by W9-b.

## Validation Evidence

| Check | Status | Evidence |
| --- | --- | --- |
| Remote branch exists | PASS | `git ls-remote --heads` returned `08d7c2cef00a1830ac908310535e2320c41d2276`. |
| Main ancestry | PASS | `git merge-base --is-ancestor origin/main origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` exited 0. |
| Stats diff whitespace | PASS | `git -C .../bsebench-stats diff --check origin/main..origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z` produced no output. |
| Conflict markers | PASS | `git grep -n -E '<<<<<<<|=======|>>>>>>>' ... -- src tests` produced no matches; exit 1 is expected for no matches. |
| Focused Wave 1 tests | PASS from W5 evidence | W5-06 records `52 passed in 10.33s`; W5-02 commit body records focused S1-S6 pytest passed with `52 passed`. |
| Stats non-slow suite | PASS from W5-02 log evidence | W5-02 commit body records stats non-slow pytest passed with `148 passed`. |
| Package export check | PASS from W5-06 evidence | W5-06 records 15 integrated top-level exports present. |
| Ruff check and format | PASS from W5 evidence | W5-06 records scoped Ruff check and format check passed; W5-02 commit body records repository Ruff check and format check passed. |
| Current W8-c branch-head hygiene | PASS with limits | W8-c reconfirms pushed SHA, ancestry, name-status surface, whitespace hygiene, and conflict-marker absence. It did not rerun source package tests. |

## Rollback Plan

If merge preflight fails or a post-merge smoke check regresses, revert the stats
integration branch merge as a single unit on the target stats branch. The branch
surface is isolated to the additive Wave 1 helper modules, their tests, and
top-level exports listed above.

Recommended rollback steps:

1. Stop promotion or release packaging that consumes the stats integration
   branch.
2. In the stats repo, revert the merge commit or reset the target integration
   branch pointer back to the pre-merge `origin/main` base
   `d7bb8bc333895e41e377c7e21eed389a6bd83097`, depending on the target branch
   policy.
3. Re-run `git diff --check`, conflict-marker grep, focused Wave 1 tests, and
   the stats non-slow suite before re-opening the gate.
4. Preserve the W5-02 conflict log because `src/bsebench_stats/__init__.py`
   remains the repeat conflict hotspot for future additive exports.

## Open Blockers

These blockers come from W6/W7 sidecars and remain open unless another branch
has since supplied the required gates:

| Blocker | Current impact |
| --- | --- |
| Public metric tables need report-layer metadata | Require metric family, target signal, unit, comparison unit, split identity, aggregation policy, and explicit failed-row policy before public tables. |
| Sample-pooled metric aggregate is not enough for public comparison tables | Add macro comparison-unit aggregation and label pooled values as secondary diagnostics. |
| Sorted multi-axis summaries need a ranking policy and wording gate | Keep mechanical ranks scoped to the supplied panel until policy, source-ledger status, uncertainty caveats, and wording checks are enforced. |
| Compute comparison needs evidence-tier metadata | Add compute tier, measurement scope, hardware/software identity, backend identity, repeat policy, and stratified aggregation before compute rows are compared. |
| Runner profiling units need bridge tests | Add conversion or rejection tests for runner nanosecond and byte telemetry before stats compute aggregates consume runner profiling output. |
| Transfer/generalization reporting needs richer axes | Temperature, aging or SOH bin, dataset, and equipment-family axes must be represented or explicitly unavailable for broad reports. |
| Cross-module schema registry is missing | Add registry tests for public stats payloads and common report envelope fields before release-facing report integration. |

Unknowns:

- No PR was opened or inspected by W9-b.
- W9-b did not rerun the stats source pytest or Ruff suites locally; this report
  relies on pinned W5 evidence and W8 branch-head hygiene for those results.
- Any new stats integration SHA after `08d7c2cef00a1830ac908310535e2320c41d2276`
  requires replaying this preflight.

## Commands Run By W9-b

```bash
git fetch --all --prune
git branch -r | rg 'phase-8|stats|W5|W7|w5|w7'
git show origin/phase-8-4-f-stats-integration-validator-20260507T213125Z:validation/wave-5/stats-integration-validator-20260507T213125Z.md
git show origin/phase-8-5-b-stats-integration-redteam-20260507T213656Z:redteam/wave5/stats-integration-redteam-20260507T213656Z.md
git show origin/phase-8-6-j-stats-metrics-backcompat-audit-20260507T214305Z:audits/wave-7/stats-metrics-backcompat-audit-20260507.md
git show origin/phase-8-7-c-stats-datasets-cross-validation-20260507T214728Z:validation/wave-8/stats-datasets-cross-validation-20260507.md
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats ls-remote --heads origin phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats rev-parse origin/main origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats merge-base --is-ancestor origin/main origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats diff --name-status origin/main..origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats diff --check origin/main..origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats grep -n -E '<<<<<<<|=======|>>>>>>>' origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z -- src tests
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats log -1 --format='commit %H%nsubject %s%nbody%n%B' origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z
```

## Local Report Validation

- `git diff --check`: PASS with no output after writing this report.
- Forbidden co-author trailer scan: PASS with no matches.
- Guardrail wording scan for disallowed comparative/research-claim terms: PASS
  with no matches.
- `git status --short --branch`: only the owned `pr/` path was untracked
  before staging.
