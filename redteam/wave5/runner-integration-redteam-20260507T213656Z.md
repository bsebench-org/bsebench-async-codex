---
GLASSBOX:
  worker: W6-01
  role: runner-integration-redteam
  artifact: runner-integration-redteam
  created_utc: 2026-05-07T21:56:00Z
  target_branch: phase-8-5-a-runner-integration-redteam-20260507T213656Z
  write_set: redteam/wave5/runner-integration-redteam-20260507T213656Z.md
---

# Runner Integration Red-Team

## Objective

Red-team the Wave 5 runner integration risk for the universal benchmark runner
surface. This artifact is sidecar evidence only: it does not modify runner
code, integration branches, thesis files, manuscript files, claim registries,
`claims/registry.yaml`, `claim_55`, or the scientific roadmap.

## Evidence Inspected

CTO-report validation branches:

- `phase-8-1-k-validator-runner-wave1-20260507T193050Z`
  (`validation/wave-1/runner-20260507T193050Z.md`): initial V-RUNNER checkpoint
  found R1-R6 remote heads absent and all six runner outputs pending.
- `phase-8-3-d-runner-wave1-deep-validation-20260507T204627Z`
  (`validation/wave-4/runner-wave1-deep-validation-20260507T204627Z.md`):
  later W4 runner deep validation found all six R1-R6 remote heads available,
  clean, replayed focused branch tests, and validated a temporary R1-R6 merge
  with `43 passed`.
- `phase-8-4-e-runner-integration-validator-20260507T213125Z`
  (`validation/wave-5/runner-integration-validator-20260507T213125Z.md`):
  W5 validator initially recorded `PENDING_REMOTE_PUSH` for W5-01 because the
  runner integration branch was not yet on `origin`.

Runner repository evidence:

- Target repo inspected: `/mnt/c/doctorat/bsebench-org/bsebench-runner`.
- W5 runner integration branch:
  `phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`.
- Current remote head observed by `git ls-remote --heads origin`:
  `e0664de6e02dd45832068de427666dbcc2bd3d10`.
- W5 runner integration watchdog log inspected:
  `/home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z.log`.
- W5 runner validator watchdog log inspected:
  `/home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-4-e-runner-integration-validator-20260507T213125Z.log`.

## Branch Map

| Runner output | Branch | Remote head | Main surface |
| --- | --- | --- | --- |
| R1 | `phase-8-0-a-universal-runner-estimator-plugin-contract` | `7f590c24085395ea8c9a999e196c50defa00b139` | Estimator adapter contract and smoke-test helpers. |
| R2 | `phase-8-0-b-universal-runner-protocol-registry` | `acf95fa072d3a91e32669b66f7c170012d8289de` | Metadata-only protocol registry models and resolver. |
| R3 | `phase-8-0-c-universal-runner-degraded-initialization` | `944a15213ed40e62788d668c442ff9ffa74393a1` | Forced wrong-initial-SOC fixture helpers. |
| R4 | `phase-8-0-d-universal-runner-leakage-split-guard` | `5d8efab0c9533315ae9b3371ba74d05899ceaffc` | Split leakage guard helpers and package-root exports. |
| R5 | `phase-8-0-e-universal-runner-compute-profiling-hooks` | `2006dffa8aba6b6bd500657ee41973c828069d3e` | Estimator step profiling metadata and orchestrator hook. |
| R6 | `phase-8-0-f-universal-runner-submission-smoke` | `ce792f35b96a3aaa544c8c21b7c859f68f8400cf` | Toy external submission example and smoke test. |
| W5-01 | `phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z` | `e0664de6e02dd45832068de427666dbcc2bd3d10` | R1-R6 merged with six explicit GLASSBOX merge commits. |

## W5 Integration Log Findings

The W5 runner integration log reports:

- R1-R6 remote branches were fetched and merged in order.
- Six explicit merge commits were created:
  `e81a2df` R1, `4d7f6b9` R2, `d91c53a` R3, `9e4cd81` R4,
  `b14d471` R5, `e0664de` R6.
- No manual conflicts were reported. R5 auto-merged overlapping
  `src/bsebench_runner/__init__.py` and `tests/test_orchestrator.py`.
- Focused integrated runner gate reported `43 passed`.
- Broader non-slow runner gate reported `176 passed, 5 deselected`.
- `uv run --extra dev ruff check .` passed.
- `git diff --check` passed.
- The branch was pushed to
  `origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`.

Independent W6-01 observations:

- `git ls-remote --heads origin` now shows W5-01 at
  `e0664de6e02dd45832068de427666dbcc2bd3d10`; this supersedes the older W5
  validator `PENDING_REMOTE_PUSH` status, but does not by itself replace a fresh
  post-push validation checkout.
- `git -C /mnt/c/doctorat/bsebench-org/bsebench-runner diff --check origin/main...origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`
  passed in this red-team pass.
- `git -C /mnt/c/doctorat/bsebench-org/bsebench-runner grep -n -E '<<<<<<<|=======|>>>>>>>' origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z -- .`
  returned no matches.
- `git log --format=%B origin/main..origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`
  grep for the forbidden Claude coauthor trailer returned no matches.

## API Overlap Risks

1. Package-root export boundary is inconsistent.
   R4 and R5 added root exports for split guards and profiling, while R1
   estimator contract, R2 protocol registry, and R3 initialization policy remain
   submodule-only. This is not inherently wrong, but alpha docs and examples
   must define whether universal runner APIs are imported from
   `bsebench_runner` or from submodules. Falsification gate: root-import tests
   must cover every API promised in public docs, and docs must not advertise
   root imports for submodule-only APIs.

2. R1 estimator contract is not enforced by `run_benchmark`.
   The orchestrator still calls `filt.step(...)` and directly reads
   `out["voltage_predicted"]`; it does not call
   `validate_estimator_step_output`. A filter returning `nan`, `inf`, a bool,
   or a non-mapping can still enter the broad exception/sentinel path or leak
   non-finite values depending on the exact failure mode. Falsification gate:
   add integrated tests for non-finite, missing, bool, and non-mapping step
   outputs on the merged branch; require deterministic sentinel behavior or an
   explicit validation error.

3. R2 protocol registry is metadata-only and not yet an execution entrypoint.
   The registry can resolve declared component specs, but W5 integration does
   not demonstrate a protocol snapshot resolving into the runtime
   `FilterRegistry` and `AdapterRegistry` consumed by `run_benchmark`.
   Falsification gate: round-trip a `ProtocolRegistrySnapshot`, resolve a
   `BenchmarkProtocolSpec`, build the runtime registries, and run the toy
   submission or synthetic split through `run_benchmark`.

4. R3 initialization policy is a fixture helper, not a runner policy hook.
   The forced wrong-SOC cases are used in tests through direct helper calls, but
   they are not connected to R2 protocol registry execution or a CLI/runtime
   policy selector. Falsification gate: a protocol-driven run must select the
   forced initialization fixture without test-only helper plumbing.

5. R4 split guard is opt-in.
   The guard correctly detects overlapping calibration/evaluation configs when
   called, but W5 integration does not wire it into `run_benchmark`, protocol
   resolution, or submission smoke execution. Falsification gate: a merged
   integration test must construct overlapping calibration/evaluation splits and
   fail before benchmark scoring starts.

6. R5 profiling changes the default orchestrator output and runtime profile.
   `run_benchmark(..., profile_estimator_steps=True)` is now the default, adding
   `metadata.profiling` and using `tracemalloc` around every estimator step.
   This is useful evidence metadata, but it can break strict downstream schema
   consumers and changes runtime overhead. Falsification gate: test
   `profile_estimator_steps=False`, existing JSON/schema consumers, and behavior
   when `tracemalloc` is already active before the runner starts.

7. R6 submission smoke is positive-path only.
   The toy submission proves a simple external estimator can run, but it does
   not exercise invalid entrypoints, unsafe file layout, missing registries,
   non-finite predictions, or malformed split YAML. Falsification gate: add
   negative submission fixtures before treating the external-submission path as
   alpha-safe.

## Missing Or Weak Gates Before Alpha

- Fresh post-push validation checkout of
  `origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`.
  The W5 validator artifact was written before the W5-01 push; the W5 integrator
  log is strong pre-push evidence but should be reproduced from the fetched
  remote head.
- `uv run --extra dev ruff format --check .` on the integrated runner tree. The
  W5 log records `ruff check`, but the W4 recommendation also included format
  checking.
- Full CI matrix or documented reason for skipping slow tests. W5 ran
  `pytest -m "not slow"` with `5 deselected`; this is acceptable as a merge
  hardening gate only if slow coverage is explicitly scheduled before public
  release.
- Public API compatibility check for `OrchestratorRunResult.metadata` JSON after
  adding profiling metadata.
- Root import / submodule import contract tests for R1-R5 APIs.
- Negative tests for split leakage, malformed protocol references, malformed
  estimator outputs, and invalid external submissions.
- Environment reproducibility gate for the legacy path dependency
  `BSEBENCH_LEGACY_AUTORESEARCH_DIR=/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch`,
  because earlier runner validation needed it for focused replays.

## Promotion Falsification Checklist

Before promoting W5-01 beyond integration branch status, fail the promotion if
any item below is not true:

1. `git ls-remote --heads origin phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`
   returns `e0664de6e02dd45832068de427666dbcc2bd3d10` or a newer head with a
   recorded reason for the change.
2. A fresh detached checkout from the fetched remote head passes:
   `uv run --extra dev pytest tests/test_estimator_contract.py tests/test_protocol_registry.py tests/test_initialization_policy.py tests/test_split_guard.py tests/test_profiling.py tests/test_submission_smoke.py tests/test_orchestrator.py`.
3. The same checkout passes `uv run --extra dev pytest -m "not slow"`.
4. The same checkout passes `uv run --extra dev ruff check .`.
5. The same checkout passes `uv run --extra dev ruff format --check .`.
6. The same checkout passes `git diff --check origin/main...HEAD`.
7. Conflict marker scan over the fetched tree returns no matches.
8. Commit-message scan over `origin/main..HEAD` returns no forbidden Claude
   coauthor trailer.
9. The API boundary decision is documented: either export R1-R3 public classes
   at package root or document submodule-only imports and test those imports.
10. Negative integrated tests cover non-finite estimator outputs, overlapping
    calibration/evaluation splits, malformed protocol references, and invalid
    external submissions.

## Rollback Plan

Preferred rollback before merge to runner `main`:

1. Do not promote
   `origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`.
2. Keep runner `main` at pre-integration base
   `66bd8273fde4f19dde1283f8739f322794e612db`.
3. Open fix branches only for the failed R output(s), then rebuild a new
   integration branch from `origin/main` in R1-R6 order after gates pass.

Rollback if W5-01 is merged to runner `main` as a single merge/PR:

1. Revert the merge commit that introduced W5-01 into `main`.
2. Re-run the previous runner `main` CI/non-slow gate.
3. Re-open a replacement integration branch from the restored `main`.

Rollback if R1-R6 merge commits are applied directly to runner `main`:

1. Revert merge commits with mainline parent 1 in reverse order:
   `git revert -m 1 e0664de6e02dd45832068de427666dbcc2bd3d10`,
   `git revert -m 1 b14d4716d8ae34f58cbdf4a45f555f3cc681d786`,
   `git revert -m 1 9e4cd81bce604007061212f93aa8b8ecbcb7650c`,
   `git revert -m 1 d91c53a4710f01d251e4e2ed15c39525c8652df5`,
   `git revert -m 1 4d7f6b9c777bd71883b023fca70ce98f9530da00`,
   `git revert -m 1 e81a2df2673745560101392e9863addedfd62881`.
2. Run `git diff --check`, conflict marker scan, focused runner tests, and
   `pytest -m "not slow"` on the reverted tree.
3. If only one R output is implicated, rebuild from `origin/main` by merging
   the known-good subset first and the fixed output last.

## Non-Claims

- This artifact does not claim final public-release readiness.
- This artifact does not claim full integrated CI passed.
- This artifact does not make SOTA, novelty, leaderboard, breakthrough, or
  verified scientific claims.
- This artifact does not claim dataset licensing, public availability, or source
  ledger completeness.

## W6-01 Validation

Commands run for this red-team pass:

```bash
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner ls-remote --heads origin \
  'phase-8-0-*-universal-runner-*' \
  'phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z'
```

Observed result: R1-R6 heads and W5-01 head were present on `origin`.

```bash
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner diff --check \
  origin/main...origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z
```

Observed result: pass.

```bash
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner grep -n -E \
  '<<<<<<<|=======|>>>>>>>' \
  origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z -- .
```

Observed result: no matches.

```bash
forbidden=Claude
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner log --format=%B \
  origin/main..origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z |
  rg "Co-Authored-By:.*${forbidden}|Co-Authored-By:.*${forbidden,,}"
```

Observed result: no matches.

```bash
git diff --check
```

Observed result before writing this artifact: pass. Final post-write result is
recorded in the branch commit/final worker report.
