---
GLASSBOX:
  worker: W7-i
  role: runner-protocol-backcompat-auditor
  artifact: runner-protocol-backcompat-audit
  created_utc: 2026-05-07T22:13:00Z
  target_branch: phase-8-6-i-runner-protocol-backcompat-audit-20260507T214305Z
  write_set: audits/wave-7/runner-protocol-backcompat-audit-20260507.md
  inspected_runner_branch: phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z
  inspected_runner_head: e0664de6e02dd45832068de427666dbcc2bd3d10
---

# Runner Protocol Backcompat Audit

## Objective

Audit the runner Wave 1 integration surface for backward-compatibility risks
and missing migration notes before alpha promotion. This is a sidecar audit
only. It does not edit runner, stats, datasets, thesis, manuscript, claim
registry, `claims/registry.yaml`, `claim_55`, or roadmap files.

## Evidence Inspected

- CTO-report wave charter:
  `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`.
- CTO-report Wave 4 runner validation branch:
  `phase-8-3-d-runner-wave1-deep-validation-20260507T204627Z`,
  artifact `validation/wave-4/runner-wave1-deep-validation-20260507T204627Z.md`.
- CTO-report Wave 5 runner red-team branch:
  `phase-8-5-a-runner-integration-redteam-20260507T213656Z`,
  artifact `redteam/wave5/runner-integration-redteam-20260507T213656Z.md`.
- Runner integration worktree, read-only:
  `/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`.
- Runner integration branch:
  `phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`
  at `e0664de6e02dd45832068de427666dbcc2bd3d10`.
- Runner base for comparison:
  `origin/main` at `66bd8273fde4f19dde1283f8739f322794e612db`.

## Branch Surface

The inspected integration branch contains six merge commits over runner
`origin/main`:

| Output | Branch | Integrated commit | Surface |
| --- | --- | --- | --- |
| R1 | `phase-8-0-a-universal-runner-estimator-plugin-contract` | `7f590c24085395ea8c9a999e196c50defa00b139` | `estimator_contract.py` and toy adapter tests. |
| R2 | `phase-8-0-b-universal-runner-protocol-registry` | `acf95fa072d3a91e32669b66f7c170012d8289de` | Metadata-only protocol registry. |
| R3 | `phase-8-0-c-universal-runner-degraded-initialization` | `944a15213ed40e62788d668c442ff9ffa74393a1` | Forced wrong-initial-SOC fixture helpers. |
| R4 | `phase-8-0-d-universal-runner-leakage-split-guard` | `5d8efab0c9533315ae9b3371ba74d05899ceaffc` | Split overlap guard helpers and root exports. |
| R5 | `phase-8-0-e-universal-runner-compute-profiling-hooks` | `2006dffa8aba6b6bd500657ee41973c828069d3e` | Per-step profiling metadata in `run_benchmark`. |
| R6 | `phase-8-0-f-universal-runner-submission-smoke` | `ce792f35b96a3aaa544c8c21b7c859f68f8400cf` | Toy external submission smoke example. |

Observed integration diff against runner `origin/main`: 20 files changed,
2,117 insertions, 28 deletions. The modified runtime surface includes
`README.md`, `src/bsebench_runner/__init__.py`,
`src/bsebench_runner/orchestrator.py`, and new modules under
`src/bsebench_runner/`.

## Backcompat Findings

### BC-1: Default Output Schema Changed

Severity: high for strict JSON consumers.

Evidence:

- `RunMetadata` now includes `profiling: BenchmarkProfilingMetadata` at
  `src/bsebench_runner/orchestrator.py:42`.
- `run_benchmark` defaults `profile_estimator_steps=True` at
  `src/bsebench_runner/orchestrator.py:97`.
- `run_benchmark` always passes `profiling=profiling` into returned metadata at
  `src/bsebench_runner/orchestrator.py:213-223`.
- The README still says the runner writes "the verdict + the RMSE matrix + run
  metadata" but does not document the new profiling object, its size, or how to
  opt out.

Compatibility impact: callers that snapshot or validate the JSON result shape
from runner `origin/main` will now receive a nested `metadata.profiling` object
by default. Because the model uses `extra="forbid"` internally, runner-side
models are strict; downstream strict schemas are likely to be strict too.

Required migration note: document `metadata.profiling`, the default-on behavior,
and the programmatic opt-out `profile_estimator_steps=False`. Add a CLI opt-out
or explicitly state that CLI JSON always includes profiling on this alpha
branch.

Suggested gate: compare a golden `OrchestratorRunResult.model_dump(mode="json")`
from runner `origin/main` against the integration branch and require an
intentional schema version or migration note for each added field.

### BC-2: Runtime Cost Changed By Default

Severity: medium to high for large benchmark sweeps.

Evidence:

- `run_benchmark` instantiates `EstimatorStepProfiler(enabled=profile_estimator_steps)`
  before stepping filters at `src/bsebench_runner/orchestrator.py:156`.
- Every estimator step is wrapped in `profiler.measure_step(...)` at
  `src/bsebench_runner/orchestrator.py:179-187`.
- `EstimatorStepProfiler` starts `tracemalloc` when memory tracking is enabled
  and tracing is not already active in `src/bsebench_runner/profiling.py`.

Compatibility impact: existing users calling `run_benchmark` without new
arguments get timing and traced-memory collection around every sample by
default. That changes overhead and can affect benchmark wall time or memory
measurement context even when the caller only expected RMSE/Friedman outputs.

Required migration note: document runtime overhead and the interaction with
externally active `tracemalloc`. If profiling is intended as evidence metadata,
prefer alpha-safe default `False` or expose a CLI flag with default stated in
the release note.

Suggested gate: run one small fixture with `profile_estimator_steps=True` and
`False`, assert identical `rmse_matrix` and `friedman_verdict`, and record
profiling payload differences only under `metadata.profiling`.

### BC-3: Public Import Boundary Is Inconsistent

Severity: medium.

Evidence:

- Package root now exports profiling and split-guard symbols at
  `src/bsebench_runner/__init__.py:10-14` and `:29-35`, with names listed in
  `__all__` at `:46-55` and `:57-68`.
- R1 estimator contract symbols remain submodule-only in
  `src/bsebench_runner/estimator_contract.py:149-158`.
- R2 protocol registry symbols remain submodule-only in
  `src/bsebench_runner/protocol_registry.py`.
- R3 initialization fixture symbols remain submodule-only in
  `src/bsebench_runner/initialization_policy.py:100-107`.

Compatibility impact: alpha docs can easily drift into advertising imports that
do not exist at package root. Existing root import consumers also receive new
names for R4/R5 only, which makes the public API boundary ambiguous.

Required migration note: define one import policy for alpha:
submodule-only for all new Wave 1 APIs, or root exports for all APIs intended
to be public. README examples must match the chosen policy.

Suggested gate: add import-contract tests for every symbol documented in README
or examples. Fail if docs use a root import for a submodule-only symbol.

### BC-4: Estimator Contract Is Not Enforced In The Orchestrator

Severity: medium.

Evidence:

- The estimator contract requires a mapping with finite numeric
  `voltage_predicted` in `src/bsebench_runner/estimator_contract.py:100-128`.
- `run_benchmark` directly reads `out["voltage_predicted"]` and casts it to
  `float` at `src/bsebench_runner/orchestrator.py:187`.
- The contract smoke helper validates a single adapter step at
  `src/bsebench_runner/estimator_contract.py:131-146`, but the orchestrator
  path does not call that validator.

Compatibility impact: public users may reasonably assume R1's contract applies
to all orchestrated submissions. In the current integration surface, invalid
step outputs are handled only indirectly by casts, metric sentinel behavior, or
the broad per-filter exception path. That is not a stable error contract.

Required migration note: state that `EstimatorAdapter` validation is currently
an adapter smoke helper, not an enforced runtime path, or wire
`validate_estimator_step_output` into `run_benchmark` with tests for malformed
outputs.

Suggested gate: integrated negative tests for missing `voltage_predicted`,
non-mapping output, bool output, non-finite output, and extra non-numeric
fields.

### BC-5: Protocol Registry Does Not Execute Protocols Yet

Severity: medium for user-facing "protocol" wording.

Evidence:

- The protocol registry docstring states it is "metadata-only" and avoids
  importing concrete loaders, estimators, or metric functions at
  `src/bsebench_runner/protocol_registry.py:1-7`.
- `ProtocolRegistry.resolve_protocol` returns a `ProtocolBundle` of specs at
  `src/bsebench_runner/protocol_registry.py:314-324`.
- `run_benchmark` still accepts concrete `FilterRegistry` and `AdapterRegistry`
  arguments at `src/bsebench_runner/orchestrator.py:89-98`.

Compatibility impact: callers cannot yet pass a `BenchmarkProtocolSpec` or
`ProtocolBundle` into the runner. If alpha docs present protocol registry as an
execution entrypoint, users will hit an unimplemented bridge.

Required migration note: document the protocol registry as declarative metadata
only until a protocol-to-runtime resolver lands. Avoid examples that imply
`BenchmarkProtocolSpec` can be run directly.

Suggested gate: before alpha, add a toy protocol snapshot that resolves into
runtime registries and runs the existing toy submission split, or record this as
an explicit blocker.

### BC-6: Split Guard And Degraded Initialization Are Opt-In Helpers

Severity: medium.

Evidence:

- `assert_no_calibration_evaluation_leakage` only runs when a caller invokes it
  with separate calibration/evaluation splits at
  `src/bsebench_runner/split_guard.py:85-106`.
- `run_benchmark` accepts a single `Split` and has no calibration split or guard
  parameter at `src/bsebench_runner/orchestrator.py:89-98`.
- Forced wrong-initial-SOC fixtures mutate `FilterConfig` copies at
  `src/bsebench_runner/initialization_policy.py:72-97`, but `run_benchmark`
  does not select or apply an initialization fixture.

Compatibility impact: these helpers are useful, but they do not change runner
execution unless callers wire them manually. Alpha users could assume split
guarding or degraded initialization is automatic if the release note says the
runner "adds" these protocol components.

Required migration note: label both features as opt-in helper APIs. State that
the current CLI and `run_benchmark` path do not automatically apply them.

Suggested gate: integrated tests should fail overlapping calibration/evaluation
inputs before scoring once a protocol-driven execution path exists.

### BC-7: External Submission Smoke Is Positive-Path Only

Severity: medium.

Evidence:

- `examples/submissions/README.md:3-7` documents a toy external estimator that
  imports by path, builds registries, and runs through `run_benchmark`.
- The same README says real submissions should replace only the estimator
  factory side at `examples/submissions/README.md:43-44`.
- The smoke test covers the valid toy path, but no invalid entrypoint,
  malformed registry, malformed output, or malformed split cases were observed
  in the inspected integration branch.

Compatibility impact: the example is safe as a smoke fixture, but it is not an
alpha submission contract. Treating it as a public submission surface would
leave unclear failure modes.

Required migration note: call this a smoke fixture only. Document which
submission fields and failures are intentionally unsupported until a submission
contract gate lands.

Suggested gate: add negative submission fixtures for missing builders, malformed
split YAML, missing `voltage_predicted`, non-finite outputs, and unsafe import
paths before using this as an alpha contributor path.

### BC-8: README Quick Usage Is Still Stale For The CLI

Severity: low to medium.

Evidence:

- README quick usage shows `bsebench run --split ... --output ... --filters ...`
  at `README.md:29-34`.
- The CLI requires `--checkpoints-dir` in `src/bsebench_runner/cli.py`.

Compatibility impact: new users copying the README command will get an argparse
error. This is not introduced by Wave 1, but Wave 1 adds new README content
without repairing the pre-existing CLI mismatch.

Required migration note: update quick usage to include `--checkpoints-dir`, and
add a separate example for toy external submission smoke if that is the intended
no-checkpoint path.

Suggested gate: README command smoke test or docs lint that parses the shown
CLI command against `build_parser()`.

## Migration Notes Required Before Alpha

1. Result schema: document `metadata.profiling`, whether it is default-on, and
   whether older consumers can opt out.
2. Runtime profiling: document overhead, `tracemalloc` scope, and CLI support or
   lack of CLI support.
3. Import boundary: state root-vs-submodule policy for R1-R6 public APIs and add
   import tests for documented symbols.
4. Contract enforcement: state whether estimator output validation is a smoke
   helper or runtime guarantee.
5. Protocol registry: state that protocol specs are metadata-only until a
   resolver bridges them to `run_benchmark`.
6. Split guard and degraded initialization: state that both are opt-in helper
   APIs in the inspected branch.
7. Submission smoke: state that toy submission is a positive-path smoke fixture,
   not a full public submission contract.
8. CLI docs: repair required `--checkpoints-dir` usage.

## Alpha Gate Recommendations

Before promoting the inspected runner integration branch beyond integration
status, require:

- Fresh detached checkout from
  `origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`.
- Focused Wave 1 tests and full non-slow runner tests from that fetched head.
- `uv run --extra dev ruff check .`.
- `uv run --extra dev ruff format --check .`.
- `git diff --check origin/main...HEAD`.
- Conflict-marker scan.
- Commit-message scan for forbidden coauthor trailers.
- JSON schema golden comparison for pre-Wave and Wave 1 run outputs.
- Import-contract tests for documented public APIs.
- Negative tests for malformed estimator outputs, protocol references,
  split-overlap guards, and external submissions.

## Blockers

- I did not find a migration guide or release note in the inspected runner
  integration branch documenting the default profiling payload, import policy,
  protocol registry execution boundary, or opt-in status of split/degraded
  initialization helpers.
- I did not run runner tests from this audit branch because the owned write-set
  is restricted to this CTO-report artifact and runner repos were read-only for
  this task. I relied on existing Wave 4 and Wave 5 validation/red-team
  artifacts plus read-only source/test inspection.
- Full CI status for the pushed runner integration branch was not inspected in
  this audit. The Wave 5 red-team artifact also recorded the need for a fresh
  post-push validation checkout.

## Non-Claims

- This audit does not claim public-release readiness.
- This audit does not claim any estimator performance result.
- This audit does not claim dataset licensing, source availability, or
  provenance completeness.
- This audit only records compatibility and migration risks observed in the
  runner Wave 1 integration surface.

## Local Validation

Commands run in this CTO-report worktree:

```bash
git status --short --branch
git diff --check
```

Observed result after writing this artifact: pending local artifact only before
commit, and `git diff --check` passed.

Read-only runner inspection commands included:

```bash
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z status --short --branch
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z log --oneline --decorate --max-count=12
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z diff --stat origin/main...HEAD
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z diff --name-status origin/main...HEAD
```

Observed result: runner integration worktree was clean; branch head matched
`origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`;
integration commits R1-R6 were present; source/test inspection found the
compatibility risks above.
