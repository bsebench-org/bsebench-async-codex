# External Submission Adversarial Test Spec

GLASSBOX metadata:

- Artifact id: `submission-adversarial-test-spec-20260507T213656Z`
- Worker: `W6-10`
- Branch: `phase-8-5-j-submission-adversarial-test-spec-20260507T213656Z`
- Date: 2026-05-07
- Owned path: `specs/submissions/adversarial-test-spec-20260507T213656Z.md`
- Scope: adversarial tests for external estimator submissions before public or
  alpha benchmark execution.
- Non-scope: implementation, public ranking policy, claim registration, thesis
  prose, manuscript prose, and scientific roadmap edits.

## Source Inspection

Inspected repository context before writing this spec:

- `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`: defines the
  plug-and-play estimator objective, blind evaluation separation, provenance,
  degraded initialization, and recurring community benchmark workflow.
- `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`: identifies the
  external submission smoke path and contributor submission template as current
  Wave 1 work items, while this artifact supplies sidecar adversarial gates for
  later hardening.
- `templates/freelance-dev-template.md` and `templates/merge-validate-template.md`:
  current async templates are worker/merge templates, not estimator submission
  templates.
- Existing outbox and inbox records for determinism, cache provenance, and
  source-ledger gates: useful patterns for explicit, falsifiable pass/fail
  criteria.

No concrete external-estimator submission template was present in this
worktree at inspection time. The test plan below is therefore stated against
the expected lifecycle boundary rather than a specific merged implementation.

## Expected Submission Lifecycle

Adversarial tests should bind to these lifecycle stages:

1. Intake: read submission manifest, declared dependencies, estimator entry
   point, metadata, and optional calibration policy.
2. Isolated install: build or install the submission in a fresh environment with
   network disabled after dependency resolution.
3. Adapter load: import the declared entry point without giving access to
   evaluation labels, hidden split metadata, or benchmark internals beyond the
   public estimator contract.
4. Calibration or training: run only on explicitly permitted calibration data.
5. Reset: call the standard reset hook before each independent episode, fold,
   cell, profile, and protocol replicate.
6. Blind evaluation: stream `voltage`, `current`, `temperature`, `dt`, and other
   public observation fields through `step(...)`; labels remain inside the
   harness.
7. Reporting: collect estimates, runtime, memory, dependency identity, and
   guardrail outcomes without accepting self-reported accuracy.

## Baseline Harness Requirements

These requirements are shared by every adversarial test case:

- Run each submission in a per-test scratch directory with a clean process
  unless a test explicitly checks process reuse.
- Pass observations through the public estimator API only.
- Keep ground-truth SOC/SOH labels, metric code, split assignment, and held-out
  dataset identifiers outside the submission-visible filesystem and Python
  object graph.
- Record process id, package versions, Python version, platform, environment
  variables allowed to the submission, wall-clock seed policy, and input trace
  hashes.
- Fail closed: inability to inspect, import, sandbox, replay, or hash an
  external submission is a failed adversarial gate, not a warning.
- Treat all tests as mechanical integrity gates. Passing these gates does not
  establish scientific strength or claim validity.

## Acceptance Summary

A submission is alpha-eligible only if all required gates pass:

| Gate | Required outcome |
| --- | --- |
| `ADV-STATE-*` | Predictions for an episode are independent of previous hidden episodes after reset. |
| `ADV-LABEL-*` | Submission cannot read, infer by identifier lookup, or cache hidden labels. |
| `ADV-NONDET-*` | Replays with fixed inputs produce identical outputs within the configured tolerance. |
| `ADV-DEPS-*` | Dependencies and runtime behavior stay inside the allowed install, filesystem, network, and process boundaries. |
| `ADV-REPORT-*` | The final report includes all adversarial gate statuses and blocks publication on any failure. |

Default numeric replay tolerance:

- SOC/SOH estimates: exact JSON hash match when the estimator declares
  deterministic arithmetic.
- Floating output tolerance fallback: absolute tolerance `1e-12` and relative
  tolerance `1e-12` for platforms where serialization or BLAS order makes exact
  bytes impractical.
- Any estimator that requires looser tolerance must declare why in metadata and
  receive explicit maintainer approval before public execution.

## State Leakage Tests

### ADV-STATE-001: Cross-Fold Order Invariance

Purpose: detect hidden module globals, class-level caches, mutable singletons,
or persisted state that cause fold `B` predictions to depend on whether fold
`A` ran first.

Procedure:

1. Build two synthetic evaluation folds, `fold_alpha` and `fold_beta`, with
   distinct trace hashes and no shared object identity.
2. Run sequence `alpha -> reset -> beta`.
3. Run sequence `beta -> reset -> alpha` in a fresh process.
4. Compare predictions for each fold across both sequences.

Failure signals:

- Prediction hashes for the same fold differ between orders.
- Memory or scratch files created during `fold_alpha` are read during
  `fold_beta` without being declared calibration artifacts.
- Reset hook is missing or returns without clearing estimator state.

Acceptance gate:

- For every fold, prediction arrays and invalid-output masks match the replay
  tolerance independent of fold order.

### ADV-STATE-002: Episode Boundary Reset

Purpose: catch estimators that continue internal SOC state across independent
cells, profiles, temperatures, or benchmark protocols.

Procedure:

1. Use two short episodes with deliberately incompatible initial SOC values.
2. Run them back-to-back under one process, calling the public reset hook before
   each episode.
3. Repeat each episode alone in a fresh process.
4. Compare the back-to-back output for each episode against the fresh-process
   output.

Failure signals:

- First estimate in episode 2 is shifted toward the final estimate of episode 1.
- Output length or invalid markers change between isolated and reused-process
  execution.
- Reset depends on private labels or hidden split identity.

Acceptance gate:

- Back-to-back and fresh-process episode outputs match the replay tolerance.

### ADV-STATE-003: Calibration Artifact Boundary

Purpose: allow legitimate calibration while blocking accidental or adversarial
reuse of evaluation-state artifacts.

Procedure:

1. Provide a declared calibration split in a writable calibration directory.
2. Provide a blind evaluation split in a separate read-only execution directory.
3. Permit reads of declared calibration artifacts only through the runner's
   calibration artifact registry.
4. Run a filesystem access audit during blind evaluation.

Failure signals:

- Reads from evaluation scratch files from previous folds.
- Writes to shared package directories, repository root, home directories, or
  global caches during blind evaluation.
- Calibration artifact names include hidden evaluation identifiers.

Acceptance gate:

- Every blind-evaluation file access is either read-only package code, the
  current public observation stream, or a declared calibration artifact.

### ADV-STATE-004: Warm-Start Declaration Check

Purpose: prevent undeclared warm starts from being benchmarked as cold-start
estimators.

Procedure:

1. Run the same evaluation episode once with the standard cold-start reset.
2. Run it again after an allowed calibration phase.
3. Compare metadata declarations to observed stateful behavior.

Failure signals:

- Submission metadata declares `cold_start=true` while output depends on a prior
  calibration or evaluation episode.
- The estimator persists learned parameters without a manifest entry that
  identifies the calibration data used to create them.

Acceptance gate:

- Warm-start behavior is either absent or explicitly declared, provenance-linked,
  and separated from cold-start results.

## Cached Label and Identifier Leakage Tests

### ADV-LABEL-001: Hidden Label File Denial

Purpose: ensure the submission never receives direct ground-truth labels during
blind evaluation.

Procedure:

1. Store labels outside the submission container, Python path, and scratch
   directory.
2. Place a decoy `labels.csv` or `soc_ground_truth.parquet` in the submission
   scratch directory with wrong synthetic labels.
3. Run blind evaluation with syscall or language-level file-open auditing.

Failure signals:

- The submission opens any file matching denied label patterns during blind
  evaluation.
- Predictions track the decoy labels more closely than the public observations
  justify in the synthetic test.
- The estimator requests labels, metrics, or split truth through public API
  introspection.

Acceptance gate:

- No hidden or decoy label file is opened, imported, memory-mapped, or parsed by
  the submission.

### ADV-LABEL-002: Dataset Identifier Canary

Purpose: catch lookup tables keyed by dataset, cell, profile, temperature, trace
length, path, or hash.

Procedure:

1. Generate paired traces with identical public observations and labels but
   different visible identifiers and path names.
2. Generate paired traces with different observations and labels but identical
   identifier aliases.
3. Run the estimator across both pairs.

Failure signals:

- Predictions change when only a visible identifier or path changes.
- Predictions remain suspiciously unchanged when observations change under a
  reused alias.
- Submission metadata, logs, or scratch files contain hidden benchmark
  identifiers not provided through the public API.

Acceptance gate:

- Predictions are a function of public observations and declared calibration
  artifacts, not visible names, path digests, or hidden identifiers.

### ADV-LABEL-003: Label Perturbation Sentinel

Purpose: detect cached labels even when file or identifier access is not
observed directly.

Procedure:

1. Create a synthetic trace with simple public dynamics and known labels.
2. Run the same public observations under two harness-only label variants:
   canonical labels and perturbed labels.
3. The submission sees the same observations and metadata in both runs.
4. Metrics are computed internally by the harness only.

Failure signals:

- Predictions change when only hidden labels change.
- Runtime behavior, file access, or logs change when only hidden labels change.

Acceptance gate:

- Output predictions and submission-visible side effects are identical across
  hidden label variants.

### ADV-LABEL-004: Train/Eval Split Poison Pill

Purpose: catch submissions that overfit or memorize evaluation examples by using
split metadata beyond the declared calibration split.

Procedure:

1. Include a calibration split with one public trace.
2. Include a hidden evaluation trace that shares superficial metadata but has
   inverted synthetic dynamics.
3. Add a poison calibration example whose label pattern would be catastrophic if
   applied to evaluation without observation-driven adaptation.

Failure signals:

- Evaluation predictions copy calibration labels or final calibration state.
- The estimator accesses evaluation split assignment before blind evaluation.
- The estimator produces near-perfect results on a hidden synthetic trace whose
  labels are not implied by observations or declared calibration.

Acceptance gate:

- Evaluation behavior changes with public observations and does not copy
  calibration labels by identifier, position, or trace length.

## Nondeterminism Tests

### ADV-NONDET-001: Same-Process Replay

Purpose: catch nondeterminism caused by unseeded RNGs, clock use, mutable
process state, or unordered data structures.

Procedure:

1. Load the submission once.
2. Run the same episode five times in the same process with reset before each
   run.
3. Hash serialized predictions and invalid-output masks.

Failure signals:

- Any replay hash differs beyond tolerance.
- Logs show use of wall-clock time, random seeds from OS entropy, or unordered
  iteration over mutable containers during prediction.

Acceptance gate:

- All five replay hashes match the configured deterministic tolerance.

### ADV-NONDET-002: Fresh-Process Replay

Purpose: catch nondeterminism that only appears across imports, build paths,
process ids, CPU thread scheduling, or dependency initialization.

Procedure:

1. Run the same submission and episode in at least five fresh processes.
2. Pin allowed environment variables, thread counts, and random seeds.
3. Compare output hashes and runtime metadata.

Failure signals:

- Predictions differ across fresh processes.
- The estimator requires network, current time, host-specific paths, or GPU
  availability to reproduce outputs.

Acceptance gate:

- Fresh-process outputs match replay tolerance; runtime metadata may vary only
  in explicitly allowed timing fields.

### ADV-NONDET-003: Input Batch Partition Invariance

Purpose: catch estimators whose output depends on arbitrary runner chunk size
  rather than the actual time series.

Procedure:

1. Stream the same episode one sample at a time.
2. Stream it in runner-selected chunks if the adapter supports batch stepping.
3. Stream it with randomized chunk boundaries that preserve observation order.

Failure signals:

- Estimates differ when only chunk boundaries change.
- The estimator relies on lookahead beyond the public batch contract.

Acceptance gate:

- Outputs match the declared streaming semantics for all chunking modes the
  submission claims to support.

### ADV-NONDET-004: Parallel Scheduling Invariance

Purpose: catch shared global state and race conditions when multiple submissions
or episodes run under benchmark parallelism.

Procedure:

1. Execute identical episodes serially.
2. Execute them concurrently under the benchmark's intended worker pool.
3. Compare predictions and side effects.

Failure signals:

- Cross-worker scratch files collide.
- Predictions differ under parallel execution.
- Dependency-level thread pools ignore configured deterministic thread counts.

Acceptance gate:

- Parallel execution is prediction-equivalent to serial execution, with isolated
  scratch paths per submission and episode.

## Unsafe Dependency and Runtime Tests

### ADV-DEPS-001: Dependency Manifest Static Audit

Purpose: reject dependency declarations that make results non-reproducible,
non-auditable, or unsafe to run in a public benchmark environment.

Procedure:

1. Parse dependency manifests using package-manager APIs where available.
2. Reject dynamic install hooks and dependency sources outside the allowlist.
3. Record pinned package names, versions, hashes where available, licenses when
   exposed by package metadata, and native-extension build requirements.

Failure signals:

- Unpinned direct dependency versions.
- VCS, local path, URL, or post-install downloads not explicitly approved.
- Install scripts that access network, secrets, home directories, or repository
  roots.
- Dependencies that monkeypatch benchmark, metric, dataset, or serialization
  modules.

Acceptance gate:

- Direct dependencies are pinned and installable from approved indexes or
  prebuilt artifacts; all exceptions are reviewed and recorded before alpha
  execution.

### ADV-DEPS-002: Network Denial at Import and Evaluation

Purpose: ensure external estimators do not fetch data, labels, models, telemetry,
or code during benchmark execution.

Procedure:

1. Disable network after dependency resolution.
2. Import the estimator entry point.
3. Run calibration and blind evaluation under the same network denial policy.
4. Audit failed socket attempts.

Failure signals:

- Any socket creation, DNS lookup, HTTP client use, model hub call, telemetry
  call, or package-manager invocation during import or evaluation.
- Import fails only because network is unavailable.

Acceptance gate:

- Import, calibration, and blind evaluation complete without network access.

### ADV-DEPS-003: Filesystem Boundary Audit

Purpose: prevent submissions from reading hidden benchmark assets or writing
persistent artifacts outside their declared scratch space.

Procedure:

1. Run with an explicit allowlist:
   - read: installed package files, declared calibration artifacts, public
     observation stream;
   - write: per-run scratch directory only.
2. Deny home directory writes, repository writes, shared cache writes, and
   parent-directory traversal.
3. Log denied and allowed path accesses.

Failure signals:

- Writes outside scratch.
- Reads of hidden labels, metric outputs, split manifests, previous reports, or
  other submissions.
- Symlink traversal outside allowed roots.

Acceptance gate:

- All file accesses remain inside the allowlist, and the test report includes a
  normalized path-access summary.

### ADV-DEPS-004: Subprocess and Dynamic Code Audit

Purpose: prevent hidden execution paths that bypass runner instrumentation.

Procedure:

1. Wrap or deny subprocess creation by default.
2. Scan import-time and evaluation-time behavior for dynamic code execution,
   package installation, shell invocation, and binary loading outside installed
   dependencies.
3. Permit only declared native libraries already installed with the dependency
   set.

Failure signals:

- Calls to shell, compiler, package manager, notebook runtime, remote execution,
  or dynamically generated Python code during blind evaluation.
- Binary loading from scratch, home, repository root, or downloaded paths.

Acceptance gate:

- No subprocess or dynamic code path executes unless explicitly declared,
  reviewed, sandboxed, and recorded as a benchmark exception.

### ADV-DEPS-005: Resource Exhaustion Guard

Purpose: keep adversarial or accidental resource use from blocking public
benchmark operations.

Procedure:

1. Enforce per-step and per-episode CPU timeouts.
2. Enforce memory limits appropriate to the alpha runner.
3. Enforce log-size and artifact-size limits.
4. Run a synthetic long trace to verify limits fail closed.

Failure signals:

- The estimator exceeds CPU, memory, log, or artifact limits.
- The estimator handles limit exceptions by corrupting future runs in the same
  worker.

Acceptance gate:

- Resource use remains inside declared limits, or the run is marked invalid and
  isolated without affecting subsequent submissions.

## Report and Merge Gates

### ADV-REPORT-001: Required Gate Status Fields

Every external submission validation report must include:

- submission id and manifest hash;
- estimator entry point and version;
- dependency lock or resolved dependency hash;
- calibration split identifiers visible to the submission;
- evaluation trace hashes visible to the submission;
- hidden label hashes known only to the harness;
- adversarial gate status for every `ADV-*` case;
- replay tolerance used;
- allowed filesystem roots;
- network policy;
- subprocess policy;
- resource limits;
- full failure reason for every failed or skipped gate.

Acceptance gate:

- Missing, skipped without reason, or non-finite report fields block alpha
  eligibility.

### ADV-REPORT-002: Publication Blocker Rule

Purpose: prevent partial adversarial validation from appearing as benchmark
approval.

Procedure:

1. Aggregate all `ADV-*` statuses.
2. Mark the submission `alpha_eligible=false` if any required gate fails,
   errors, or is skipped without an approved waiver.
3. Require waivers to name the gate, reason, expiration date, maintainer, and
   public caveat text.

Acceptance gate:

- A report cannot mark a submission alpha-eligible while any required gate is
  unresolved.

## Minimal Alpha Gate Set

For the first external-submission alpha release, the minimum required cases are:

- `ADV-STATE-001`
- `ADV-STATE-002`
- `ADV-LABEL-001`
- `ADV-LABEL-002`
- `ADV-LABEL-003`
- `ADV-NONDET-001`
- `ADV-NONDET-002`
- `ADV-DEPS-001`
- `ADV-DEPS-002`
- `ADV-DEPS-003`
- `ADV-REPORT-001`
- `ADV-REPORT-002`

The remaining cases should be implemented before public recurring benchmark
snapshots or any report that compares external submissions across method
families.

## Implementation Notes for Future Workers

- Keep adversarial fixtures synthetic and small; they should not require real
  battery datasets.
- Prefer process-level isolation for black-box submissions and syscall or
  language-level audits where available.
- The test harness should expose only the public estimator contract; any helper
  object that contains labels or metric state should be outside the submission
  process.
- When a gate relies on sandbox behavior that is unavailable on a platform, mark
  the gate blocked and fail alpha eligibility rather than silently downgrading
  coverage.
- Store adversarial validation artifacts separately from scientific evidence
  artifacts to avoid accidental claim reuse.
- Do not include self-reported estimator accuracy in acceptance decisions.
