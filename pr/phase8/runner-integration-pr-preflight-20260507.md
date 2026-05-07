---
GLASSBOX:
  worker: W9-a
  role: runner-integration-pr-preflight
  artifact: runner-integration-pr-preflight
  created_utc: 2026-05-07T21:56:16Z
  target_branch: phase-8-8-a-runner-integration-pr-preflight-20260507T215348Z
  write_set: pr/phase8/runner-integration-pr-preflight-20260507.md
  inspected_runner_branch: phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z
  inspected_runner_head: e0664de6e02dd45832068de427666dbcc2bd3d10
---

# Runner Integration PR Preflight - 2026-05-07

## Scope

This is a preflight report for a future runner integration PR. It does not open
a PR and does not edit runner, stats, datasets, thesis, manuscript, claim
registry, `claims/registry.yaml`, `claim_55`, or roadmap files.

The inspected runner integration branch is:

`phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`

Current pushed head observed by read-only `git ls-remote`:

`e0664de6e02dd45832068de427666dbcc2bd3d10`

The local runner integration worktree at
`/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`
was clean and tracking the same remote branch at the same head.

No `origin/phase-8-4-a*` branch exists in the CTO-report repository. The
actionable `phase-8-4-a` branch is runner-scoped.

## Evidence Sources Inspected

| Evidence | Ref / artifact | Relevant result |
| --- | --- | --- |
| W5-05 runner validator | `origin/phase-8-4-e-runner-integration-validator-20260507T213125Z`, `validation/wave-5/runner-integration-validator-20260507T213125Z.md` | W5-01 remote branch appeared on `origin`; local/remote heads matched `e0664de6e02dd45832068de427666dbcc2bd3d10`; focused post-push runner gate passed with `43 passed in 13.61s`; remote integrated diff whitespace check passed; conflict-marker scan returned no matches; no forbidden Claude coauthor trailer was observed. |
| W6-01 runner red-team | `origin/phase-8-5-a-runner-integration-redteam-20260507T213656Z`, `redteam/wave5/runner-integration-redteam-20260507T213656Z.md` | W5 integrator log reported R1-R6 merged in order, focused integrated runner gate `43 passed`, broader non-slow gate `176 passed, 5 deselected`, `ruff check` passed, `git diff --check` passed, and branch push completed. Red-team found API and alpha-readiness risks requiring migration notes and negative tests. |
| W7-i backcompat audit | `origin/phase-8-6-i-runner-protocol-backcompat-audit-20260507T214305Z`, `audits/wave-7/runner-protocol-backcompat-audit-20260507.md` | Backcompat audit of runner branch `e0664de6e02dd45832068de427666dbcc2bd3d10` found eight compatibility/migration risks, including default profiling output, runtime overhead, import-boundary ambiguity, unenforced estimator contract, metadata-only protocol registry, opt-in split/degraded-initialization helpers, positive-path-only submission smoke, and stale CLI README usage. |
| W4 runner deep validation | `origin/phase-8-3-d-runner-wave1-deep-validation-20260507T204627Z`, `validation/wave-4/runner-wave1-deep-validation-20260507T204627Z.md` | R1-R6 isolated heads were clean and matched upstream; focused branch replay passed; temporary R1-R6 integration over runner `origin/main` merged without conflicts and passed focused integrated tests with `43 passed in 3.58s`. |
| W8 W6 closure audit | `phase-8-7-d-w6-remaining-closure-audit-20260507T214728Z`, `validation/wave-8/w6-remaining-closure-audit-20260507.md` | W6-01 runner red-team branch was complete, clean, pushed, and remote-matched. Its next action remains advisory use plus fresh post-push validation before promotion. |

## Integration Surface

The W5 runner branch integrates six runner Wave 1 outputs with explicit
GLASSBOX merge commits:

| Output | Integrated branch | Integration commit | Surface |
| --- | --- | --- | --- |
| R1 | `phase-8-0-a-universal-runner-estimator-plugin-contract` | `e81a2df2673745560101392e9863addedfd62881` | Estimator adapter contract and smoke helper tests. |
| R2 | `phase-8-0-b-universal-runner-protocol-registry` | `4d7f6b9c777bd71883b023fca70ce98f9530da00` | Metadata-only protocol registry. |
| R3 | `phase-8-0-c-universal-runner-degraded-initialization` | `d91c53a4710f01d251e4e2ed15c39525c8652df5` | Wrong-initial-SOC fixture helpers. |
| R4 | `phase-8-0-d-universal-runner-leakage-split-guard` | `9e4cd81bce604007061212f93aa8b8ecbcb7650c` | Split leakage guard helpers and exports. |
| R5 | `phase-8-0-e-universal-runner-compute-profiling-hooks` | `b14d4716d8ae34f58cbdf4a45f555f3cc681d786` | Per-step profiling metadata and orchestrator hook. |
| R6 | `phase-8-0-f-universal-runner-submission-smoke` | `e0664de6e02dd45832068de427666dbcc2bd3d10` | Toy external submission smoke example. |

Observed local runner log head order:

```text
e0664de GLASSBOX [role: codex-runner-integrator] Merge R6 submission smoke
b14d471 GLASSBOX [role: codex-runner-integrator] Merge R5 profiling hooks
9e4cd81 GLASSBOX [role: codex-runner-integrator] Merge R4 leakage split guard
d91c53a GLASSBOX [role: codex-runner-integrator] Merge R3 degraded initialization
4d7f6b9 GLASSBOX [role: codex-runner-integrator] Merge R2 protocol registry
e81a2df GLASSBOX [role: codex-runner-integrator] Merge R1 estimator adapter contract
```

## Preflight Decision

Decision: `DRAFT_PR_READY_WITH_BLOCKERS`

A draft runner integration PR can be prepared from the pushed W5 runner branch
head `e0664de6e02dd45832068de427666dbcc2bd3d10`, but it should not be merged
until the blockers below are resolved or explicitly accepted as alpha-scoped
follow-up work.

Minimum PR body content should include:

- Source branch and exact head:
  `phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z` at
  `e0664de6e02dd45832068de427666dbcc2bd3d10`.
- R1-R6 integration order and merge commits listed above.
- Test evidence from W5-05, W6-01, W7-i, and W4 runner deep validation.
- Explicit non-claim language: no public-release readiness, no full integrated
  CI pass unless CI later proves it, no estimator-performance claim, and no
  external benchmark/leaderboard/novelty claim.
- Blockers and migration notes from W7-i.
- Rollback plan from this report.

## Validation Evidence To Carry Into PR

Already recorded evidence:

- Focused integrated runner gate on temporary W4 replay: `43 passed in 3.58s`.
- W5 integrator log: focused integrated gate `43 passed`.
- W5 integrator log: broader non-slow runner gate `176 passed, 5 deselected`.
- W5 integrator log: `uv run --extra dev ruff check .` passed.
- W5 integrator log: `git diff --check` passed.
- W5-05 post-push validator on remote-matched head: focused runner gate
  `43 passed in 13.61s`.
- W5-05 remote integrated diff whitespace check: pass.
- W5-05 conflict-marker scan: no matches.
- W5-05 forbidden Claude coauthor trailer scan: no matches.
- W6-01 red-team re-checks: remote head present, `git diff --check` passed,
  conflict-marker scan returned no matches, and forbidden Claude coauthor scan
  returned no matches.

Current W9-a read-only checks:

```bash
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z \
  status --short --branch
```

Observed result:

```text
## phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z...origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z
```

No dirty files were printed.

```bash
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z \
  ls-remote --heads origin phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z
```

Observed result:

```text
e0664de6e02dd45832068de427666dbcc2bd3d10	refs/heads/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z
```

Current CTO-report branch validation before this report was written:

```bash
git diff --check
```

Observed result: pass with no output.

## Required Pre-Merge Gates

Run these on a fresh fetched checkout of
`origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`
before merge:

```bash
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
```

```bash
BSEBENCH_LEGACY_AUTORESEARCH_DIR=/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch \
  uv run --extra dev pytest -m "not slow"
uv run --extra dev ruff check .
uv run --extra dev ruff format --check .
git diff --check origin/main...HEAD
git grep -n -E '<<<<<<<|=======|>>>>>>>' HEAD -- .
git log --format=%B origin/main..HEAD | rg 'Co-Authored-By:.*Claude|Co-Authored-By:.*claude'
```

Expected result for the final command is no matches. Treat any match as a hard
blocker.

## Open Blockers

1. Fresh full pre-merge validation from a detached or clean fetched checkout has
   not been recorded in this W9-a report. W5-05 did focused post-push
   validation; W6-01 recorded W5 integrator non-slow log evidence.
2. `ruff format --check` is not recorded in the W5 integrator evidence, although
   W4 and W7 gate recommendations include it.
3. Full CI status for the pushed runner integration branch is unknown from the
   inspected CTO-report artifacts.
4. Slow test coverage is explicitly not covered by the `pytest -m "not slow"`
   evidence.
5. The runner validation environment depends on local
   `BSEBENCH_LEGACY_AUTORESEARCH_DIR`; CI/release docs need an explicit,
   reproducible setup or an equivalent isolation of pure runner tests.
6. W7-i compatibility blockers remain open: default profiling output, runtime
   profiling overhead, root-vs-submodule import policy, estimator contract
   enforcement, metadata-only protocol registry boundary, opt-in split/degraded
   initialization helpers, positive-path-only submission smoke, and stale CLI
   README command.
7. Negative tests for malformed estimator outputs, overlapping
   calibration/evaluation splits, malformed protocol references, and invalid
   external submissions are not recorded as passing on the integration branch.
8. Migration/release notes for alpha users are incomplete until the W7-i items
   are documented or intentionally scoped out.

## Rollback Plan

Preferred rollback before merge:

1. Do not promote or merge
   `origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`.
2. Keep runner `main` at pre-integration base
   `66bd8273fde4f19dde1283f8739f322794e612db`.
3. Fix only the failed R output branch or create a narrow follow-up branch, then
   rebuild a new R1-R6 integration branch from runner `origin/main` in the
   validated order.

Rollback if W5-01 is merged to runner `main` as one PR:

1. Revert the merge commit that introduced W5-01 into `main`.
2. Re-run prior runner `main` CI and the non-slow gate.
3. Re-open a replacement integration branch from the restored `main`.

Rollback if R1-R6 merge commits are applied directly:

```bash
git revert -m 1 e0664de6e02dd45832068de427666dbcc2bd3d10
git revert -m 1 b14d4716d8ae34f58cbdf4a45f555f3cc681d786
git revert -m 1 9e4cd81bce604007061212f93aa8b8ecbcb7650c
git revert -m 1 d91c53a4710f01d251e4e2ed15c39525c8652df5
git revert -m 1 4d7f6b9c777bd71883b023fca70ce98f9530da00
git revert -m 1 e81a2df2673745560101392e9863addedfd62881
```

Then run `git diff --check`, conflict-marker scan, focused runner tests,
`pytest -m "not slow"`, `ruff check`, and `ruff format --check` on the reverted
tree.

## Non-Claims

- This report does not claim the runner integration is merged.
- This report does not claim full CI passed.
- This report does not claim public alpha readiness.
- This report does not claim dataset licensing, source availability, or
  provenance completeness.
- This report does not make SOTA, novelty, leaderboard, breakthrough,
  superiority, or verified scientific claims.
