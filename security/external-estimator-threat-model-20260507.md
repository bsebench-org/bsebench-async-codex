# External Estimator Security Threat Model

GLASSBOX metadata:

- Artifact id: `external-estimator-threat-model-20260507`
- Worker: `W7-p`
- Branch: `phase-8-6-p-external-estimator-security-threat-model-20260507T214305Z`
- Date: 2026-05-07
- Owned path: `security/external-estimator-threat-model-20260507.md`
- Scope: security threat model for plug-and-play external estimator
  submissions, including sandbox, dependencies, data exfiltration, cached
  labels, and nondeterminism.
- Non-scope: sandbox implementation, runner edits, stats edits, dataset edits,
  claim registry edits, thesis prose, manuscript prose, scientific roadmap
  edits, public ranking policy, and scientific performance claims.

## Evidence Inspected

This document was drafted from repository-local and branch-local evidence only.

| Evidence | Location inspected | Use in this artifact |
| --- | --- | --- |
| Universal benchmark charter | `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md` | Defines plug-and-play estimator goal, anti-leakage separation, provenance, and recurring benchmark workflow. |
| Universal parallel wave plan | `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md` | Shows external submission smoke path, submission template, and estimator plugin contract are parallel Wave tasks. |
| Contributor submission template | `phase-8-0-s-universal-async-submission-template:templates/universal-contributor-submission-template.md` | Provides expected submission metadata, adapter contract, data/split declarations, provenance artifacts, determinism policy, and non-claim checklist. |
| Submission sandbox security audit | `phase-8-2-g-submission-sandbox-security-audit-20260507T193528Z:audits/methodology/submission-sandbox-security-20260507T193528Z.md` | Identifies same-process import as a smoke path rather than a sandbox and proposes intake, dependency, sandbox, replay, leakage, and artifact gates. |
| Submission adversarial test spec | `phase-8-5-j-submission-adversarial-test-spec-20260507T213656Z:specs/submissions/adversarial-test-spec-20260507T213656Z.md` | Provides concrete adversarial gates for state leakage, cached labels, nondeterminism, unsafe dependencies, and report blockers. |

No merged external-estimator sandbox implementation was found in this worktree.
Adjacent branch artifacts were treated as design evidence, not as claims that
the controls are already implemented.

## Threat Model Summary

External estimator submissions must be treated as untrusted code. A submission
can execute at dependency installation, package import, factory creation,
adapter reset, per-sample step, batch step, calibration, finalization, report
export, or error handling. Security controls must therefore cover the complete
submission lifecycle, not only the benchmark inference loop.

The primary assets to protect are:

- hidden SOC/SOH labels and held-out metric inputs;
- split assignments, hidden dataset identifiers, and protocol scheduling;
- dataset caches and cache manifests not explicitly exposed to the submission;
- benchmark source code, metric code, report code, and runner state;
- previous submissions, previous outputs, and monthly snapshot artifacts;
- host credentials, environment variables, home directories, SSH keys, tokens,
  package-manager credentials, and network metadata;
- reviewer worktrees, sibling branch checkouts, CI state, and local caches;
- result integrity, including deterministic replay hashes and failure status.

The security objective is narrow: make untrusted estimator execution reviewable,
isolated, replayable, and unable to access hidden benchmark information. Passing
these controls does not establish method quality, scientific validity, or public
comparability.

## Trust Boundaries

| Boundary | Trusted side | Untrusted side | Required rule |
| --- | --- | --- | --- |
| Intake | Reviewer-controlled quarantine and manifest parser | Submitted archive, repository URL, lockfile, container reference, model weights, notebooks, and scripts | Parse metadata before import or execution. |
| Dependency restore | Clean builder with pinned indexes or reviewed container digest | Package install hooks, VCS refs, local path dependencies, binary wheels, model downloads | Build in isolation and record immutable dependency identity. |
| Runtime process | Benchmark harness, metric computation, hidden labels, split scheduler | Estimator process and its imported dependencies | Communicate through a narrow adapter protocol only. |
| Filesystem | Read-only benchmark code and hidden data outside mounts | Submission package and per-run scratch directory | Permit only declared read roots and scratch-only writes. |
| Network | Approved dependency fetch phase, if any | Import, calibration, inference, report export | Deny network after dependency resolution unless an explicit exception is recorded. |
| Cache | Harness-owned dataset and result cache | Submission-visible calibration artifacts | Never mount hidden labels, metric outputs, private cache roots, or previous benchmark outputs. |
| Reporting | Harness-generated status and metrics | Submission self-reported accuracy or logs | Do not accept self-reported benchmark scores as authoritative. |

## Attacker Capabilities

Assume a malicious or careless submitter can:

- run arbitrary Python or native code at import time;
- declare dependencies with install hooks, native extensions, dynamic downloads,
  telemetry clients, or mutable references;
- inspect paths, environment variables, process ids, hostname, time, available
  devices, package versions, and CPU/GPU properties;
- read and write any file reachable from its process unless the sandbox blocks
  it;
- open sockets, DNS lookups, subprocesses, shells, compilers, and package
  managers unless the sandbox blocks them;
- allocate excessive memory, spawn workers, emit large logs, or run indefinitely;
- cache state in module globals, package directories, home directories, model
  cache roots, scratch directories, or serialized artifacts;
- infer hidden split identity from filenames, trace length, path hashes, order,
  wall-clock schedule, calibration artifact names, or error messages;
- return outputs that encode hidden data, host data, or canary values in
  predictions, invalid-output masks, logs, timing, or artifacts.

## Threats and Required Controls

### T1: Hidden Label or Metric Access

Threat: the estimator reads SOC/SOH labels, metric inputs, split truth, or
intermediate metric outputs during blind evaluation.

Required controls:

- Keep labels and metric state outside the estimator process, Python path, and
  mounted filesystem.
- Pass only public observations and declared calibration artifacts to the
  estimator.
- Use decoy label files and file-access auditing during adversarial smoke tests.
- Fail alpha eligibility on any open, import, memory-map, path traversal, or API
  request involving denied label patterns.

Minimum gate mapping:

- `ADV-LABEL-001`: hidden label file denial.
- `ADV-LABEL-003`: label perturbation sentinel.
- `G5`: leakage guard from the sandbox security audit.

### T2: Cached Label Lookup and Identifier Leakage

Threat: the estimator does not directly read labels during the run but contains
or downloads lookup tables keyed by dataset name, cell id, profile, temperature,
trace length, path, hash, or public benchmark order.

Required controls:

- Do not expose hidden dataset identifiers when public aliases are sufficient.
- Normalize submission-visible paths and names so they cannot reveal split role
  or hidden provenance.
- Run identifier canaries where observations are held constant while visible
  identifiers change, and where aliases are held constant while observations
  change.
- Require manifest disclosure of any pretrained model, calibration table,
  benchmark-derived feature table, or dataset-specific lookup artifact.
- Treat repeated public submission attempts as a potential tuning channel and
  record them in the submission ledger.

Minimum gate mapping:

- `ADV-LABEL-002`: dataset identifier canary.
- `ADV-LABEL-004`: train/eval split poison pill.
- Contributor template leakage statement and data/split declaration.

### T3: Filesystem Exfiltration and Cross-Run Contamination

Threat: the estimator reads hidden files, previous outputs, sibling worktrees,
  credentials, package caches, or other submissions; or writes persistent state
  that affects later evaluations.

Required controls:

- Execute from a fresh per-run scratch directory.
- Mount benchmark code, public observations, and declared calibration artifacts
  read-only.
- Deny reads from home directories, repository parents, hidden cache roots,
  result directories, previous submissions, metric outputs, and split manifests.
- Deny writes outside per-run scratch.
- Remove scratch after artifact capture unless retention is explicitly recorded.
- Record normalized file-access summaries in validation reports.

Minimum gate mapping:

- `ADV-DEPS-003`: filesystem boundary audit.
- `ADV-STATE-003`: calibration artifact boundary.
- `G3`: sandboxed smoke.

### T4: Network Data Exfiltration and Remote Dependency

Threat: the estimator sends hidden inputs, labels, cache canaries, host
information, or benchmark outputs to a remote service; or fetches code, labels,
models, telemetry configuration, or package updates during execution.

Required controls:

- Disable network during import, calibration, blind evaluation, and report
  export.
- Resolve dependencies only in a separate reviewed dependency phase.
- Block DNS, socket creation, package-manager invocation, model-hub calls,
  telemetry clients, and cloud credentials during runtime.
- Record any denied network attempt as a failed adversarial gate.
- Require explicit maintainer waiver for any external service, with an offline
  fallback or non-comparability caveat.

Minimum gate mapping:

- `ADV-DEPS-002`: network denial at import and evaluation.
- Contributor template external-services declaration.
- `G2`: dependency restore.

### T5: Unsafe Dependencies and Supply Chain Drift

Threat: dependencies install arbitrary code, change between runs, rely on local
editable packages, use unpinned VCS refs, load unreviewed native libraries, or
download artifacts after review.

Required controls:

- Require lockfile, resolved environment export, or immutable container digest.
- Reject unpinned direct dependencies, mutable refs, local path dependencies,
  install-time downloads, and post-install scripts unless reviewed and recorded.
- Build in a clean environment, not the developer's ambient environment.
- Record package manager, runtime version, lock hash, resolved package list,
  native extension requirements, and artifact hash.
- Rebuild from the declared dependency identity during replay.

Minimum gate mapping:

- `ADV-DEPS-001`: dependency manifest static audit.
- `G2`: dependency restore.
- Contributor template provenance artifacts.

### T6: Subprocess, Dynamic Code, and Sandbox Escape

Threat: the estimator bypasses runner instrumentation by launching shells,
package managers, compilers, notebooks, remote execution, JIT-generated code, or
native binaries loaded from writable paths.

Required controls:

- Deny subprocess creation by default.
- Deny shell execution, compiler invocation, package installation, notebook
  runtimes, remote execution clients, and dynamic binary loading from scratch or
  home paths.
- Permit only reviewed native libraries that are part of the immutable
  dependency identity.
- Apply OS or container isolation; Python-only wrappers are not sufficient as a
  security boundary.

Minimum gate mapping:

- `ADV-DEPS-004`: subprocess and dynamic code audit.
- `G1`: static risk preflight.
- `G3`: sandboxed smoke.

### T7: Nondeterminism and Non-Replayable Results

Threat: outputs depend on wall-clock time, OS entropy, unordered iteration,
thread scheduling, process ids, hardware kernels, network state, mutable caches,
or undeclared stochastic behavior.

Required controls:

- Require a determinism policy and seed manifest at intake.
- Pin environment variables and deterministic thread counts where practical.
- Run same-process and fresh-process replays from clean scratch roots.
- Compare normalized output hashes after excluding approved volatile metadata.
- Mark intentionally stochastic methods with a repeated-run policy and do not
  collapse run variability into a single unqualified score.

Minimum gate mapping:

- `ADV-NONDET-001`: same-process replay.
- `ADV-NONDET-002`: fresh-process replay.
- `ADV-NONDET-003`: input batch partition invariance where batch stepping is
  supported.
- Contributor template determinism policy.

### T8: Stateful Leakage Across Episodes, Folds, or Submissions

Threat: an estimator carries hidden state across folds, cells, profiles,
chemistries, protocols, or previous submissions, causing blind evaluation to
depend on prior benchmark order.

Required controls:

- Require an explicit reset hook or stateless declaration.
- Run order-invariance tests across folds and episodes.
- Use fresh processes for acceptance-critical replays.
- Separate declared calibration artifacts from blind evaluation scratch.
- Record whether warm-start behavior is absent, declared, or blocked.

Minimum gate mapping:

- `ADV-STATE-001`: cross-fold order invariance.
- `ADV-STATE-002`: episode boundary reset.
- `ADV-STATE-004`: warm-start declaration check.

### T9: Resource Exhaustion and Operational Denial

Threat: the estimator blocks benchmark operations by exhausting CPU, memory,
processes, file descriptors, disk, stdout/stderr, artifact storage, or CI time.

Required controls:

- Enforce per-import, per-calibration, per-step, per-episode, and per-submission
  timeouts.
- Enforce memory, process, file descriptor, log-size, artifact-size, and disk
  quotas.
- Kill and isolate failed runs without reusing contaminated worker state.
- Preserve failure status instead of converting infrastructure failures into
  numeric metric values.

Minimum gate mapping:

- `ADV-DEPS-005`: resource exhaustion guard.
- `G6`: resource and failure ledger.

### T10: Report Tampering and Unsupported Public Claims

Threat: the submission reports its own benchmark score, hides invalid cells,
collapses failures into plausible numbers, or includes unsupported comparison
language.

Required controls:

- Compute metrics only inside the harness.
- Emit structured status for every validation gate and benchmark cell.
- Preserve `invalid`, `timeout`, `resource_limited`, `dependency_failed`,
  `sandbox_denied`, `leakage_blocked`, and `not_comparable` states.
- Block public comparison, ranking, or monthly snapshot prose unless source
  ledger and frozen evidence requirements are separately satisfied.
- Reject SOTA, novelty, leaderboard, breakthrough, superior, universal-proven,
  or verified scientific claim language in submission artifacts unless an
  approved claims workflow explicitly permits it.

Minimum gate mapping:

- `ADV-REPORT-001`: required gate status fields.
- `ADV-REPORT-002`: publication blocker rule.
- Contributor template comparison source ledger and non-claim checklist.

## Alpha Readiness Gate

An external estimator submission should not be marked alpha-eligible unless the
validation report contains all fields below and every required gate is pass or
approved waiver:

- submission id, maintainer, license, artifact hash, and entry point;
- submission manifest hash and dependency identity hash;
- BSEBench commit or release identity used for validation;
- sandbox policy version, allowed read roots, allowed write roots, network
  policy, subprocess policy, and resource limits;
- calibration artifacts visible to the submission;
- evaluation trace hashes or aliases visible to the submission;
- hidden label hashes retained by the harness only;
- deterministic replay tolerance and seed policy;
- status for `ADV-STATE-001`, `ADV-STATE-002`, `ADV-LABEL-001`,
  `ADV-LABEL-002`, `ADV-LABEL-003`, `ADV-NONDET-001`, `ADV-NONDET-002`,
  `ADV-DEPS-001`, `ADV-DEPS-002`, `ADV-DEPS-003`, `ADV-REPORT-001`, and
  `ADV-REPORT-002`;
- failure reason, waiver reason, waiver expiration, and reviewer identity for
  every failed, skipped, or waived gate.

Default alpha decision rules:

| Condition | Decision |
| --- | --- |
| Manifest cannot be parsed without executing submission code | `blocked` |
| Dependency identity is mutable or cannot be rebuilt | `blocked` |
| Runtime sandbox is unavailable on the target platform | `blocked` |
| Hidden label, hidden cache, network, or denied filesystem access is observed | `blocked` |
| Deterministic replay differs outside approved tolerance | `blocked` or `accepted_as_partial` only with explicit stochastic policy |
| Resource limit is exceeded | `invalid` for the run and `blocked` for alpha eligibility until corrected |
| Required report fields are missing | `blocked` |
| All required gates pass | `accepted_for_benchmark_alpha` |

## Implementation Notes for Future Workers

- Keep adversarial fixtures synthetic and small so security gates do not depend
  on private battery datasets.
- Prefer process or container isolation for untrusted submissions. Same-process
  import is useful only for trusted smoke fixtures.
- Keep hidden labels outside the estimator process rather than relying on
  convention or reviewer discipline.
- Treat dependency restore, import, calibration, inference, and report export as
  separate phases because each phase has different side effects.
- Record denied actions as first-class validation outcomes, not as log-only
  warnings.
- Design the adapter protocol so estimator outputs cannot overwrite harness
  metric outputs or status fields.
- Store security validation artifacts separately from scientific evidence
  artifacts to avoid accidental reuse as performance evidence.

## Blockers and Unknowns

- No merged runner sandbox implementation was present in this worktree.
- No merged executable external-submission contract was present in this
  worktree.
- No merged contributor validation checklist was present in this worktree; the
  template and checklist evidence came from adjacent local branches.
- No platform-specific sandbox policy was available here, so this document does
  not choose between container, OS namespace, VM, or CI-native isolation.
- No finalized dependency allowlist, resource limits, or waiver authority matrix
  was available here.

## Explicit Non-Claims

- This document does not claim that BSEBench currently executes untrusted
  submissions safely.
- This document does not claim that any adjacent branch artifact is merged,
  implemented, or release-ready.
- This document does not approve public ranking or comparison language.
- This document does not make SOTA, novelty, leaderboard, breakthrough,
  superior, universal-proven, or verified scientific claims.
