# GLASSBOX Submission Sandbox Security Audit

- Worker: M-SUBSEC
- Branch: `phase-8-2-g-submission-sandbox-security-audit-20260507T193528Z`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-2-g-submission-sandbox-security-audit-20260507T193528Z`
- Timestamp: 2026-05-07T21:58:00+02:00
- Owned write-set: `audits/methodology/submission-sandbox-security-20260507T193528Z.md`
- Scope: audit/spec/runbook only. No thesis, manuscript, claim registry, `claims/registry.yaml`, `claim_55`, or scientific roadmap files were edited.

## Objective

Audit the external estimator submission surface for deterministic execution, dependency isolation, and unsafe code boundaries. The goal is to define concrete validation gates for future BSEBench contributor submissions without claiming that those gates are already implemented.

This audit treats contributor estimator code as untrusted until it passes an intake review, dependency restore, sandboxed smoke run, deterministic replay, leakage review, and artifact manifest check.

## Evidence Inspected

Commands and paths inspected before drafting:

| Evidence | Command or path | Result used |
|---|---|---|
| Current worktree state | `git status --short --branch` in this worktree | Confirmed the scoped branch before editing. |
| Universal wave plan | `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md` | Wave 1 includes estimator plugin contract, submission smoke, and async submission template tasks. |
| Universal API gap audit | `audits/universal/api-gap-audit-20260507T193050Z.md` in sibling Wave 2 worktree | Identified submission intake as documented but not yet an executable public API. |
| CI/test budget audit | `audits/universal/test-budget-ci-matrix-20260507T193050Z.md` in sibling Wave 2 worktree | Reinforced that validators must use fetched branch SHAs and exact commands, not dirty worktree summaries. |
| Public release risk register | `audits/universal/public-release-risk-register-20260507T193050Z.md` in sibling Wave 2 worktree | PRR-009 names external submission execution, dependency, and safety risk as a release blocker. |
| Source-ledger audit | `audits/universal/source-ledger-audit-20260507T193050Z.md` in sibling Wave 2 worktree | Comparison language remains blocked unless source-ledger and frozen evidence gates pass. |
| Async submission template | `templates/universal-contributor-submission-template.md` on `phase-8-0-s-universal-async-submission-template` | Template asks for artifact hash, environment, determinism policy, external services, lockfile, data separation, reproduction commands, and non-claim checklist. |
| Async validation checklist | `docs/BSEBENCH-UNIVERSAL-CONTRIBUTOR-VALIDATION-CHECKLIST-2026-05-07.md` on `phase-8-0-s-universal-async-submission-template` | Checklist covers intake, plug-and-play, leakage, provenance, metric, ledger, reproduction, and reviewer decision states. |
| Runner estimator-contract candidate | `src/bsebench_runner/estimator_contract.py` and `tests/test_estimator_contract.py` in `bsebench-runner-phase-8-0-a-universal-runner-estimator-plugin-contract` | Candidate validates a callable `step()` and finite numeric `voltage_predicted`, but it is a dirty Wave 1 worktree and not treated as committed implementation evidence. |
| Runner submission-smoke candidate | `examples/submissions/*` and `tests/test_submission_smoke.py` in `bsebench-runner-phase-8-0-f-universal-runner-submission-smoke` | Candidate imports a toy estimator by file path using `importlib.util.spec_from_file_location`, registers toy factories, and runs through `run_benchmark`; it is not sandbox isolation. |
| Runner dependency/CI files | `pyproject.toml`, `uv.lock`, `.github/workflows/ci.yml` in the runner submission-smoke worktree | Runner CI uses locked installs for the package environment, but no submission-specific lock/container policy was observed in the inspected candidate. |

Important evidence boundary: the inspected runner Wave 1 contract and submission-smoke files were present in dirty worktrees whose branch heads still tracked `origin/main` during inspection. They are useful design evidence only; this audit does not claim that the runner has landed a public submission sandbox.

## Threat Model

External estimator submissions can execute arbitrary code at import time, factory creation time, reset time, step time, or report export time. A malicious or accidental submission could:

- read hidden evaluation labels, future samples, split metadata, cached datasets, credentials, or previous benchmark outputs;
- write into benchmark code, dataset caches, result directories, or sibling worktrees;
- open network connections or external services during inference;
- depend on undeclared local packages, mutable branch dependencies, credentials, GPUs, host-specific libraries, or unpinned native extensions;
- introduce nondeterminism through wall-clock time, random seeds, thread scheduling, multiprocessing, hardware kernels, or remote calls;
- spawn subprocesses, fork workers, allocate excessive memory, run indefinitely, or emit oversized outputs;
- mutate module-level state so repeated benchmark cells are not independent.

Therefore, a same-process Python import smoke test is acceptable as an internal developer fixture, but it is not an acceptable boundary for untrusted public submissions.

## Audit Findings

### 1. Same-process import is a useful smoke path, not a sandbox

The runner submission-smoke candidate loads `toy_external_estimator.py` through `importlib.util.spec_from_file_location` and `spec.loader.exec_module(module)`. This proves that external code can be imported by path and wired into registries. It does not limit import-time side effects, filesystem reads/writes, network access, environment access, subprocess creation, CPU time, memory, or output size.

Recommendation: keep this pattern only for trusted in-repo fixtures. Public submission execution should happen in a separate isolated process or container with a narrow input/output protocol.

### 2. Estimator contract validation is necessary but insufficient

The estimator-contract candidate validates that an estimator factory returns an object with callable `step()` and finite numeric outputs. That catches interface errors and non-finite values, but it does not establish deterministic replay, dependency integrity, absence of leakage, or safe resource behavior.

Recommendation: separate "contract shape valid" from "accepted for benchmark". A contract smoke pass should be one required input to sandboxed execution, not the final acceptance state.

### 3. Dependency isolation is not a contributor-facing gate yet

The runner package has a lockfile and CI uses locked installs. The contributor template asks for a dependency lockfile or environment export. The inspected submission-smoke candidate does not define a submission-specific dependency restore protocol, ban mutable refs, record lockfile hash, or prove that the submission can run without the developer's existing environment.

Recommendation: require every executable submission to provide one of:

- a lockfile plus package-manager restore command that works in an empty environment;
- a container image digest plus entrypoint contract;
- a non-Python executable bundle with equivalent immutable dependency metadata.

Mutable dependencies such as `@main`, unpinned Git URLs, ambient editable installs, and implicit system packages should block `accepted_for_benchmark`.

### 4. Determinism is declared in templates but not yet replay-gated

The async template asks for a determinism policy, seed manifest, and reproduction commands. A reviewer still needs an executable gate that runs the same public smoke protocol twice from fresh scratch directories and compares normalized outputs.

Recommendation: deterministic replay should compare sorted JSON output hashes after removing allowed volatile fields such as wall-clock timestamps. If a method is intentionally stochastic, it must provide fixed seeds and a declared repeated-run policy; otherwise it should be marked `partial` or `not_comparable`, not ranked.

### 5. Leakage boundaries require runtime enforcement

The template and checklist correctly ask contributors to separate calibration, training, validation, and evaluation data. Runtime gates should enforce that separation by controlling mounts and estimator-visible inputs. Review text alone cannot prevent a submission from reading hidden files or benchmark outputs.

Recommendation: the runner-facing sandbox should mount only the submission artifact, public protocol inputs, and a scratch output directory. Dataset truth fields and hidden evaluation labels should remain outside the estimator process and be consumed only by metric code after inference.

### 6. Failure status needs to be structured

The current runner path historically converts many cell failures to sentinel RMSE values. For untrusted public submissions, failure class matters: import error, dependency restore error, timeout, memory limit, network attempt, non-finite output, leakage guard violation, and invalid schema should be distinguishable.

Recommendation: submission artifacts should emit a structured status table with one status per method/config cell. Public reports must preserve `invalid`, `timeout`, `resource_limited`, `dependency_failed`, `sandbox_denied`, and `not_comparable` states instead of silently collapsing them into a numeric score.

## Proposed Validation Gates

These are proposed gates, not claims of current implementation.

| Gate | Purpose | Required checks | Blocking condition |
|---|---|---|---|
| G0 Intake schema | Make the submission reviewable before any code runs. | Manifest contains submission id, method family, license, immutable code identity, entrypoint, target signals, dependency policy, resource request, seed policy, external-service declaration, data-use declaration, and artifact hash. | Missing required field, unresolved placeholder, unsupported claim language, or mutable code identity. |
| G1 Static risk preflight | Catch obvious side effects early. | Parse Python when applicable; scan imports/calls for network, subprocess, dynamic code execution, file writes outside output root, credential/env reads, and benchmark-output reads. | High-risk operation without explicit reviewer exception. Static pass is advisory and never replaces runtime sandboxing. |
| G2 Dependency restore | Prove the submission does not rely on the host dev environment. | Create a fresh environment from the submitted lockfile or container digest; record package manager, lock hash, Python/runtime version, and resolved package list. | Restore fails, uses mutable refs, installs during benchmark execution, or depends on undeclared ambient packages. |
| G3 Sandboxed smoke | Execute the smallest public protocol safely. | Run in isolated process/container with no network by default, read-only benchmark/submission mounts, scratch-only writable output, environment whitelist, timeout, memory limit, process limit, and output-size cap. | Import/entrypoint failure, denied syscall/resource action, non-zero exit, missing output, invalid schema, or non-finite values. |
| G4 Deterministic replay | Make reproducibility falsifiable. | Run G3 twice from fresh scratch roots with identical manifest, seed, and protocol; compare normalized output JSON and artifact hashes. | Outputs differ outside allowed volatile fields; seed manifest missing; stochastic method lacks repeated-run policy and comparability caveat. |
| G5 Leakage guard | Keep evaluation targets outside estimator reach. | Verify allowed input channels, mounted files, split roles, calibration/training/evaluation declarations, and absence of hidden-output reads. | Estimator can access hidden truth labels, future samples, previous benchmark outputs, private cache roots, or undeclared evaluation metadata. |
| G6 Resource and failure ledger | Preserve invalid and failed outcomes. | Record per-cell status, timeout, memory peak, CPU time, stdout/stderr digest, output size, and sandbox policy version. | Any failure class is collapsed into a score without status, or resource logs are missing. |
| G7 Artifact manifest | Make review replayable. | Emit BSEBench repo SHAs, submission artifact hash, dependency lock hash, dataset/split identity, command, seed, sandbox policy, result hash, and reviewer decision. | Result cannot be traced to committed code, immutable input artifacts, and exact execution command. |
| G8 Public-report gate | Prevent overstated public language. | Run claim/source-ledger checks before any comparison, ranking, or monthly snapshot prose. | SOTA, novelty, leaderboard, breakthrough, or verified-claim wording appears without completed source ledger and frozen BSEBench evidence. |

## Minimal Runbook

1. Receive a submission package and place it in a quarantine intake area.
2. Validate the manifest against G0. Do not import code yet.
3. Run G1 static risk preflight and record warnings or blocks.
4. Build a clean dependency environment or resolve the container digest under G2.
5. Execute the public smoke protocol through G3 in a sandbox with no network and scratch-only writes.
6. Repeat the smoke protocol under G4 from a fresh scratch root and compare normalized output hashes.
7. Run G5 leakage checks using declared split roles and file access boundaries.
8. Emit G6/G7 status and artifact manifests.
9. Assign one reviewer decision: `blocked`, `accepted_for_smoke`, `accepted_as_partial`, or `accepted_for_benchmark`.
10. Permit expensive benchmark scheduling only after `accepted_for_benchmark`; permit public comparison language only after G8 also passes.

## Residual Risks

- Static code scans cannot prove safety; they only catch obvious hazards.
- Python-level restrictions are not a secure sandbox. Isolation should rely on OS or container boundaries with network, filesystem, process, and resource controls.
- Native extensions, GPU libraries, JIT compilers, and subprocess-capable runtimes may bypass high-level checks unless the sandbox blocks them at the system boundary.
- Deterministic replay does not prove scientific validity, absence of leakage, or cross-platform determinism.
- Offline mounts can still leak information through output artifacts if the allowed input set is too broad.
- Non-Python submissions need the same manifest and sandbox semantics through a language-neutral entrypoint protocol.
- This audit did not implement or test the sandbox executor; it specifies gates for future implementation and validation.

## Explicit Non-Claims

- This document does not claim that BSEBench currently has an implemented external submission sandbox.
- This document does not claim that inspected Wave 1 dirty worktree files are merged, public, or release-ready.
- This document does not claim that same-process toy submission smoke tests are safe for untrusted contributor code.
- This document does not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements.
- This document does not approve public release of arbitrary external estimator execution.

## Validation Commands

Inspection commands run during this audit included:

```bash
git status --short --branch
rg --files | rg '(^audits/|^logs/|^outbox/|^inbox/|^docs/|submission|runner|template|example)'
rg -n "Wave 1|Wave 2|universal|submission|sandbox|external estimator|runner|template|determin|dependency|isolation|unsafe" docs audits outbox inbox 2>/dev/null | head -300
find /mnt/c/doctorat/bsebench-org -maxdepth 2 -type d -name '*runner*' -o -name '*bench*' | sort
rg --files | rg '(submission|template|estimator|adapter|protocol|sandbox|example|smoke|README|pyproject|lock|ci|workflow|orchestrator|registry)'
nl -ba examples/submissions/README.md | sed -n '1,220p'
nl -ba examples/submissions/toy_external_estimator.py | sed -n '1,240p'
nl -ba examples/submissions/toy_external_submission_split.yaml | sed -n '1,240p'
nl -ba tests/test_submission_smoke.py | sed -n '1,280p'
nl -ba src/bsebench_runner/estimator_contract.py | sed -n '1,220p'
nl -ba tests/test_estimator_contract.py | sed -n '1,220p'
nl -ba templates/universal-contributor-submission-template.md | sed -n '1,220p'
nl -ba docs/BSEBENCH-UNIVERSAL-CONTRIBUTOR-VALIDATION-CHECKLIST-2026-05-07.md | sed -n '1,220p'
nl -ba pyproject.toml | sed -n '1,220p'
nl -ba .github/workflows/ci.yml | sed -n '1,220p'
```

Final local validation for this report:

```bash
git diff --check
```

Result: passed with no output.
