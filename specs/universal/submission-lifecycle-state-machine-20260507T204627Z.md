# GLASSBOX Submission Lifecycle State Machine

- Worker: W4-13
- Branch: `phase-8-3-m-submission-lifecycle-state-machine-20260507T204627Z`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-3-m-submission-lifecycle-state-machine-20260507T204627Z`
- Timestamp: 2026-05-07T22:51:30+02:00
- Owned write-set: `specs/universal/submission-lifecycle-state-machine-20260507T204627Z.md`
- Artifact type: validation/integration spec only

## Objective

Define the external estimator submission lifecycle from contributor intake to a
monthly public BSEBench report. The lifecycle must apply to ECM definitions,
Kalman-family filters, observers, AI estimators, hybrid methods, and future
estimator families without requiring contributor edits to dataset loaders,
metric code, split logic, or report generation.

This spec is intentionally operational. It defines states, transitions,
blockers, validators, artifacts, and publication gates. It does not publish
results, rank methods, register claims, or assert scientific superiority.

## Evidence Inspected

| Evidence | Command or path | Finding used |
|---|---|---|
| Current branch/scope | `git status --short --branch` | Branch started from `origin/main`; no owned artifact existed before this edit. |
| Repo templates | `templates/freelance-dev-template.md`, `templates/merge-validate-template.md` | GLASSBOX commits, no Claude coauthor trailer, scoped write-sets, and validation replay are local operating conventions. |
| Universal charter | `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md` | Monthly community snapshots and plug-and-play algorithm contracts are charter goals. |
| Universal wave plan | `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md` | Phase 8 Wave 1 defines runner, stats, datasets, and async/public benchmark workstreams. |
| Phase 8 watchdog logs | `/home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-*.log` | 64 Phase 8 logs are present now; the first Wave 1-3 set contains 48 logs. |
| Pre-Wave-4 status split | `for f in ... manual-phase-8-[012]-*.log; do ...; done` | First 48 logs classify as 45 completion-like and 3 prior usage-limit logs. |
| Prior usage-limit logs | `manual-phase-8-2-j`, `manual-phase-8-2-k`, `manual-phase-8-2-l` | Repro manifest, merge queue, and worker triage Wave 3 lanes hit usage limits and must not be counted as completed evidence without retry summaries. |
| Submission template | `templates/universal-contributor-submission-template.md` on `phase-8-0-s` | Intake asks for method family, artifact hash, environment, entry point, determinism, data use, provenance, source ledger, and reproduction commands. |
| Contributor checklist | `docs/BSEBENCH-UNIVERSAL-CONTRIBUTOR-VALIDATION-CHECKLIST-2026-05-07.md` on `phase-8-0-s` | Reviewer decisions include `accepted_for_smoke`, `accepted_for_benchmark`, `accepted_as_partial`, `blocked`, and `rejected`. |
| Monthly snapshot schema | `docs/BSEBENCH-MONTHLY-SNAPSHOT-SCHEMA-2026-05-07.md` on `phase-8-0-t` | Monthly snapshot rows require release caveats, result caveats, provenance, status, and comparability fields. |
| Monthly workflow | `docs/universal/monthly-benchmark-workflow-20260507T193050Z.md` on `phase-8-1-r` | Existing workflow defines monthly release states and publication gates G0-G9. |
| Runner estimator contract | `src/bsebench_runner/estimator_contract.py` on `bsebench-runner-phase-8-0-a` | Contract smoke validates callable `step()` and finite numeric output shape. |
| Runner submission smoke | `tests/test_submission_smoke.py` on `bsebench-runner-phase-8-0-f` | Toy external estimator can run through the orchestrator, but same-process import is not sandbox isolation. |
| Split leakage guard | `src/bsebench_runner/split_guard.py` on `bsebench-runner-phase-8-0-d` | Calibration and evaluation split overlap can be mechanically reported and rejected. |
| Sandbox audit | `audits/methodology/submission-sandbox-security-20260507T193528Z.md` on `phase-8-2-g` | Public submissions need dependency restore, sandboxed smoke, deterministic replay, leakage guard, and artifact manifests. |
| Public comparability audit | `audits/methodology/public-report-comparability-20260507T193528Z.md` on `phase-8-2-h` | Public report language requires complete source-ledger and comparability review. |

## Known State Verification

Observed Phase 8 log counts at inspection time:

```bash
find /home/oakir/.local/state/bsebench-async-watchdog \
  -maxdepth 1 -type f -name 'manual-phase-8-*.log' | wc -l
# 64

find /home/oakir/.local/state/bsebench-async-watchdog \
  -maxdepth 1 -type f \
  \( -name 'manual-phase-8-0-*.log' -o \
     -name 'manual-phase-8-1-*.log' -o \
     -name 'manual-phase-8-2-*.log' \) | wc -l
# 48

for f in /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-[012]-*.log; do
  if rg -q "You've hit your usage limit" "$f"; then
    printf 'USAGE_LIMIT %s\n' "${f##*/}"
  elif rg -q "Implemented and pushed|Commit:|Push status:|pushed to origin|Pushed branch|Remote branch confirmed|Worktree is clean" "$f"; then
    printf 'COMPLETION_LIKE %s\n' "${f##*/}"
  else
    printf 'OTHER %s\n' "${f##*/}"
  fi
done | cut -d' ' -f1 | sort | uniq -c
# 45 COMPLETION_LIKE
#  3 USAGE_LIMIT
```

Finding: the known "48 logs, 45 completion-like, 3 usage-limit" state is true
for Waves 1-3. It is no longer true for the whole watchdog directory because
Wave 4 logs have been added. Lifecycle and monthly release logic must therefore
scope log counts by wave or explicit branch list, not by every Phase 8 file in
the watchdog directory.

The three prior usage-limit lanes are not release evidence unless a retry branch
has a final artifact path, commit SHA, push confirmation, and validation result.
Any lifecycle transition depending on reproducibility manifest, merge queue, or
worker-triage evidence must remain blocked or explicitly caveated until those
retry artifacts are reviewed.

## Lifecycle States

Each submission has one current state and an append-only transition history.
The state name is machine-readable; the notes explain reviewer intent.

| State | Meaning | Public visibility |
|---|---|---|
| `intake_received` | Submission packet arrived before the cycle cutoff. | Not public. |
| `intake_quarantined` | Package is stored read-only; executable code has not been imported. | Not public. |
| `manifest_validating` | Required submission-template fields and hashes are being checked. | Not public. |
| `submission_incomplete` | Required fields, placeholders, hashes, or reproduction commands are missing. | Listed only in internal intake ledger. |
| `scope_triaged` | Method family, target signals, requested metrics, and unsupported regimes are recorded. | Public only after report freeze if included as caveated context. |
| `policy_blocked` | Protected-file edit request, forbidden public language, license blocker, or unsafe execution request exists. | Public only as excluded row if relevant to a frozen cycle. |
| `source_ledger_review` | External comparison text or numbers require source-ledger review. | Not public until accepted or removed. |
| `static_risk_review` | Code/package is scanned for network, subprocess, file-write, hidden-data, credential, or dynamic-exec risks. | Not public. |
| `dependency_restore` | Clean environment, lockfile, or container digest is restored and hashed. | Internal evidence; hashes may be public in release bundle. |
| `adapter_contract_smoke` | Minimal estimator/ECM/observer/hybrid entry point is checked for interface shape. | Not public. |
| `sandbox_smoke` | Small public protocol runs in an isolated process/container with controlled inputs and scratch-only output. | Not public. |
| `determinism_replay` | Smoke protocol is replayed from fresh roots and normalized outputs are compared. | Evidence summary may be public. |
| `leakage_review` | Calibration, training, validation, and blind evaluation scopes are checked. | Pass/fail/caveat must be public for included rows. |
| `protocol_assignment` | Submission is mapped to supported datasets, splits, metrics, robustness, compute, and transfer axes. | Public after freeze. |
| `benchmark_scheduled` | Frozen run manifest and resource limits are accepted for monthly execution. | Not public. |
| `benchmark_executed` | Raw output, logs, timing, failures, and hashes exist. | Public only through curated artifacts. |
| `evidence_manifested` | Command, config, environment, dataset, split, artifact, and result hashes are captured. | Release bundle candidate. |
| `metrics_ingested` | Stats outputs validate and every invalid/missing/excluded cell remains counted. | Public after freeze. |
| `comparability_review` | Result rows are labeled `comparable`, `partial`, `not_comparable`, `invalid`, `missing`, or `excluded`. | Public after freeze. |
| `monthly_candidate` | Submission row is eligible for the current monthly snapshot candidate. | Not public until release gate passes. |
| `release_gate_review` | Gated review covers scope, source ledger, artifacts, caveats, and public prose. | Internal sign-off record. |
| `release_blocked` | Monthly report cannot freeze because one or more publication gates failed. | Public only if release owner publishes a delay note. |
| `frozen_snapshot` | Snapshot JSON, report draft, release checklist, and artifact hashes are immutable. | Public bundle candidate. |
| `public_report_published` | Monthly public report and caveat table are released. | Public. |
| `erratum_opened` | Frozen record remains immutable while an append-only correction is prepared. | Public erratum ledger. |
| `closed` | Submission has no further action in the cycle. | Public only if included in a released snapshot or erratum. |
| `withdrawn` | Contributor or maintainer removed the submission before freeze. | Optional public caveat if it affected the cycle. |
| `rejected` | Submission cannot be evaluated without violating benchmark integrity rules. | Public only as an exclusion/caveat row when needed. |

## Transition Rules

Transitions are fail-closed. A transition may proceed only when its validator
returns a concrete pass result with artifact paths and commands.

| From | To | Required artifact | Validator | Blocking condition |
|---|---|---|---|---|
| `intake_received` | `intake_quarantined` | Raw package path, received timestamp, submitter identity | Intake clerk | Package is mutable, missing ownership/contact, or outside cutoff without release-owner exception. |
| `intake_quarantined` | `manifest_validating` | Submission template instance | Manifest validator | Code import is attempted before manifest review. |
| `manifest_validating` | `submission_incomplete` | Placeholder/error report | Manifest validator | Required field missing, unresolved placeholder, unknown hash, missing reproduction command. |
| `manifest_validating` | `scope_triaged` | Scope record | Intake reviewer | Unsupported method family is not caveated; requested metric has no definition. |
| `scope_triaged` | `policy_blocked` | Policy block note | Protected-file and public-language guards | Submission requests protected-file edits or includes unsupported public claim language. |
| `scope_triaged` | `source_ledger_review` | Source-ledger packet or `No comparison requested` | Source-ledger reviewer | External comparison text appears without source identity, retrieval date, exact metric, dataset, split, frozen value, and caveat. |
| `source_ledger_review` | `static_risk_review` | Accepted ledger or comparison removal note | Source-ledger reviewer | Ledger fields are incomplete for public comparison text. |
| `static_risk_review` | `dependency_restore` | Static risk report | Security reviewer | Undeclared network, subprocess, hidden-data, credential, or file-write behavior lacks reviewer exception. |
| `dependency_restore` | `adapter_contract_smoke` | Lockfile/env/container digest and restore log | Dependency validator | Mutable dependency ref, restore failure, ambient package dependency, or missing runtime hash. |
| `adapter_contract_smoke` | `sandbox_smoke` | Contract smoke report | Adapter validator | Entry point missing, `step`/output schema invalid, non-finite output, undeclared failure behavior. |
| `sandbox_smoke` | `determinism_replay` | Sandboxed smoke bundle | Sandbox validator | Network attempt, denied filesystem access, timeout, missing output, nonzero exit, oversized output, invalid schema. |
| `determinism_replay` | `leakage_review` | Replay comparison report | Reproducibility validator | Output differs outside allowed volatile fields; seed policy missing; stochastic policy lacks repeated-run caveat. |
| `leakage_review` | `protocol_assignment` | Split/leakage report | Leakage validator | Calibration/training/validation/evaluation overlap, hidden-label access, future-sample access, or public-output tuning. |
| `leakage_review` | `rejected` | Rejection note | Release owner | Leakage or safety issue cannot be mitigated by exclusion or non-comparable caveat. |
| `protocol_assignment` | `benchmark_scheduled` | Protocol/run manifest | Protocol validator | Dataset, split, metric, initialization, resource, or cache reference unresolved. |
| `benchmark_scheduled` | `benchmark_executed` | Execution logs and raw outputs | Execution validator | Command differs from frozen manifest or output path collision occurs. |
| `benchmark_executed` | `evidence_manifested` | Artifact manifest | Evidence validator | Missing command, config hash, result hash, env capture, dataset/split identity, or repository SHA. |
| `evidence_manifested` | `metrics_ingested` | Metric report bundle | Stats validator | Metric schema invalid, failed rows hidden, finite-value policy violated, aggregation caveats missing. |
| `metrics_ingested` | `comparability_review` | Result-row table | Comparability reviewer | Missing status, comparability label, source-ledger status, or row caveat. |
| `comparability_review` | `monthly_candidate` | Candidate row list | Release owner | A comparable row lacks leakage/provenance/source-ledger evidence. |
| `comparability_review` | `closed` | Exclusion note | Release owner | Result is valid evidence but out of scope for current monthly cycle. |
| `monthly_candidate` | `release_gate_review` | Snapshot candidate JSON and report draft | Release owner | Candidate uses mutable refs or incomplete retry evidence. |
| `release_gate_review` | `release_blocked` | Gate failure report | Publication validator | Any publication gate G0-G9 fails. |
| `release_gate_review` | `frozen_snapshot` | Freeze record, hashes, tag/ref | Freeze auditor | Snapshot JSON, report, checklist, and artifact hashes are not co-referential. |
| `frozen_snapshot` | `public_report_published` | Public report bundle | Publication owner | Protected files changed, caveats hidden, unsupported comparison text, or missing immutable artifact links. |
| `public_report_published` | `erratum_opened` | Erratum request | Release owner | Post-freeze artifact mismatch, metric bug, data license change, or comparability correction. |
| `erratum_opened` | `closed` | Append-only erratum or replacement snapshot | Freeze auditor | Erratum silently mutates frozen artifacts instead of adding a correction. |

## Review Decisions

Reviewer decisions are not synonyms for lifecycle states. They are signed
decisions that explain why a state transition is allowed or blocked.

| Decision | Allowed next state | Meaning |
|---|---|---|
| `accepted_for_smoke` | `adapter_contract_smoke` or `sandbox_smoke` | Intake, provenance, and scope are sufficient for cheap execution checks. |
| `accepted_for_benchmark` | `benchmark_scheduled` | Smoke, dependency, replay, leakage, and protocol gates passed for the requested monthly protocol. |
| `accepted_as_partial` | `comparability_review` or `monthly_candidate` | Runnable, but caveats prevent full comparability. Public report must show `partial`. |
| `non_comparable` | `comparability_review` or `closed` | Evidence can be archived but must not be presented as comparable. |
| `blocked` | Any blocked side state | A correctable blocker exists; no expensive benchmark execution should run. |
| `rejected` | `rejected` | Evaluation would violate integrity, safety, license, or scope rules. |
| `withdrawn` | `withdrawn` | Contributor removed the submission before freeze. |

## Validators

Every validator must emit `PASS`, `FAIL`, or `PASS_WITH_CAVEAT`, plus the exact
command, input artifact IDs, output artifact IDs, timestamp, reviewer/automation
identity, and residual risk note.

| Validator | Required checks | Minimum output |
|---|---|---|
| Intake validator | Required metadata, method family, code identity, license, target signal, requested metrics, and contact fields. | Intake report with missing-field list. |
| Protected-file guard | Submission does not request edits to thesis, manuscript, claim registry, `claims/registry.yaml`, `claim_55`, or scientific roadmap files. | Scope guard report. |
| Public-language guard | Unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim wording is absent unless a completed source ledger and separate claim workflow allow it. | Text scan report and remediation notes. |
| Source-ledger reviewer | Every external comparison row has stable source, retrieval date, metric, units, dataset, split/protocol, reported value, frozen BSEBench value, comparability, and caveat. | Ledger acceptance or removal note. |
| Static risk reviewer | Network, subprocess, dynamic execution, credential/env reads, writes outside output root, and benchmark-output reads are absent or explicitly excepted. | Risk report with block list. |
| Dependency validator | Clean restore from lockfile/env/container digest; immutable dependency refs; runtime and package hashes captured. | Restore log and dependency hash set. |
| Adapter validator | Fresh estimator factory, reset/init behavior, step signature, output schema, finite values, invalid-output policy. | Contract smoke report. |
| Sandbox validator | Isolated execution, no default network, read-only input mounts, scratch-only writes, resource caps, output schema validation. | Sandboxed smoke bundle. |
| Replay validator | Repeat smoke from fresh roots; compare normalized outputs and hashes; verify seed policy. | Replay diff report. |
| Leakage validator | Split roles, overlap set, preprocessing fit scope, hidden-label isolation, previous-output access, repeated submission tuning. | Leakage report with pass/fail and caveat. |
| Protocol validator | Dataset/profile/cell availability, split identity, initialization policy, metric set, compute policy, transfer axes. | Protocol assignment report. |
| Execution validator | Frozen command, unique output paths, cache identity, resource limits, stdout/stderr digest, failure class capture. | Execution ledger. |
| Evidence validator | Repository SHAs, submission artifact hash, dependency hash, dataset/split IDs, command, config hash, result hash, environment capture. | Artifact manifest. |
| Stats validator | Metric schema, finite/missing/invalid policy, aggregation counts, failed-run preservation, caveat fields. | Metric validation report. |
| Comparability reviewer | Status/comparability labels, source-ledger status, public table grouping, exclusion visibility. | Comparability decision table. |
| Publication validator | Release checklist G0-G9, no hidden failed rows, no protected-file edits, no unsupported public claims. | Release gate report. |
| Freeze auditor | Snapshot JSON, public report, checklist, artifact hashes, schema versions, tags/refs all identify the same release candidate. | Freeze record. |

## Monthly Public Report Gates

The monthly report may include a submission only when all required gates below
have `PASS` or an explicit `PASS_WITH_CAVEAT` whose caveat is visible in the
public snapshot.

| Gate | Release condition |
|---|---|
| G0 Scope | Only allowed release/report artifacts changed; protected files untouched. |
| G1 Intake | Submission packet and contributor checklist are complete or exclusion is visible. |
| G2 Security | Static risk, dependency restore, sandbox smoke, and replay records exist for executable submissions. |
| G3 Adapter | Contract smoke passed or the row is excluded with reason. |
| G4 Dataset | Dataset availability, license, split, chemistry/profile/temperature/aging metadata, and cache identity are recorded. |
| G5 Leakage | Calibration/training/validation/evaluation boundaries pass or row is `invalid`/`not_comparable`. |
| G6 Evidence | Every public value maps to command, config hash, result hash, output path, environment, and commit SHA. |
| G7 Metrics | Metric rows validate; missing, invalid, timeout, excluded, and failed cells remain counted. |
| G8 Comparability | Public comparison text has a completed source ledger; partial/non-comparable rows are not presented as comparable. |
| G9 Freeze | Snapshot JSON, report, release checklist, and artifact hashes are immutable under one release candidate ID. |

## Findings

1. The submission template and reviewer checklist already contain the right
   intake fields, but they do not by themselves define a durable lifecycle state
   history. This spec fills that gap with explicit states and transitions.
2. The runner contract and toy submission smoke path demonstrate a useful
   developer fixture, but same-process import is not a sandbox for public
   contributor code. Public acceptance must require dependency restore,
   sandboxed smoke, and deterministic replay.
3. Monthly snapshot schema work already requires caveats, provenance, status,
   and comparability fields. Lifecycle states should feed those fields directly
   instead of relying on prose review after the fact.
4. The first 48 Phase 8 logs verify 45 completion-like lanes and 3 prior
   usage-limit lanes. Release workflow must not infer completion from branch
   names alone.
5. The monthly workflow state machine is compatible with this submission-level
   machine. The monthly workflow governs snapshot release; this spec governs
   each external submission row feeding that snapshot.

## Pass/Fail Decision

State-machine artifact: PASS. It is scoped to the owned spec path, records the
evidence inspected, and defines objective validators and blockers.

Implementation readiness for public external submissions: FAIL-CLOSED until the
submission row can show dependency restore, sandboxed smoke, deterministic
replay, leakage review, artifact manifest, metric validation, comparability
review, and release freeze evidence.

Monthly public reporting readiness for any row with missing retry evidence:
BLOCKED or `PASS_WITH_CAVEAT`, depending on release-owner decision. Prior
usage-limit lanes must not be silently treated as completed GLASSBOX evidence.

## Recommendations

1. Add a machine-readable `submission_lifecycle.json` beside each monthly
   snapshot candidate with `submission_id`, `current_state`,
   `transition_history`, `review_decisions`, `validator_outputs`, and
   `public_visibility`.
2. Require every transition to record immutable artifact IDs and command lines.
   Human notes are useful, but they are not sufficient validator output.
3. Make same-process toy submission smoke an internal fixture state only. Public
   contributor code should move through sandboxed smoke before benchmark
   scheduling.
4. Treat `accepted_as_partial`, `non_comparable`, `invalid`, `missing`, and
   `excluded` as first-class public states in monthly reports rather than
   collapsing them into absent rows.
5. Before a monthly freeze, run a branch/log ledger that verifies every required
   Wave 1-4 dependency by final artifact path, commit SHA, remote ref, and
   validation command.

## Residual Risks

- This artifact is a spec, not an implementation. It cannot enforce lifecycle
  transitions until runner/async tooling writes and validates the state files.
- Evidence from sibling worktrees and watchdog logs may reflect unmerged or
  transient branch state. Release owners must re-fetch and validate branch SHAs
  before freezing public artifacts.
- Static risk review cannot prove safety. Runtime isolation must be enforced by
  OS/container boundaries, resource limits, and narrow input/output protocols.
- A complete source ledger can still be semantically wrong if a reviewer
  mislabels comparability. Human review remains required for public comparison
  prose.
- The watchdog directory is live; counts and tails can change. This report
  records inspection-time evidence, not a permanent status dashboard.

## Explicit Non-Claims

- This spec does not claim BSEBench currently has a fully implemented public
  submission sandbox.
- This spec does not claim that any external estimator, ECM, observer, Kalman
  filter, AI estimator, hybrid method, or future filter is better than another.
- This spec does not publish benchmark results, validate empirical SOC/SOH
  scores, or approve a monthly public report.
- This spec makes no SOTA, novelty, leaderboard, breakthrough, or verified-claim
  statement.
- This spec does not edit thesis files, manuscript files, claim registry files,
  `claims/registry.yaml`, `claim_55`, or the scientific roadmap.

## Validation Commands

Commands run during this artifact:

```bash
git status --short --branch
rg --files | rg '(^|/)(submission|template|workflow|universal|benchmark|report|intake|estimator|artifact|specs)'
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-*.log' | wc -l
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f \( -name 'manual-phase-8-0-*.log' -o -name 'manual-phase-8-1-*.log' -o -name 'manual-phase-8-2-*.log' \) | wc -l
for f in /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-[012]-*.log; do ...; done
sed -n '1,220p' templates/freelance-dev-template.md
sed -n '1,240p' templates/merge-validate-template.md
sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md
sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md
nl -ba /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-0-s-universal-async-submission-template/templates/universal-contributor-submission-template.md | sed -n '1,260p'
nl -ba /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-0-s-universal-async-submission-template/docs/BSEBENCH-UNIVERSAL-CONTRIBUTOR-VALIDATION-CHECKLIST-2026-05-07.md | sed -n '1,260p'
nl -ba /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-1-r-monthly-benchmark-workflow-design-20260507T193050Z/docs/universal/monthly-benchmark-workflow-20260507T193050Z.md | sed -n '1,280p'
nl -ba /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-a-universal-runner-estimator-plugin-contract/src/bsebench_runner/estimator_contract.py | sed -n '1,240p'
nl -ba /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-f-universal-runner-submission-smoke/tests/test_submission_smoke.py | sed -n '1,180p'
nl -ba /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-d-universal-runner-leakage-split-guard/src/bsebench_runner/split_guard.py | sed -n '1,160p'
nl -ba /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-2-g-submission-sandbox-security-audit-20260507T193528Z/audits/methodology/submission-sandbox-security-20260507T193528Z.md | sed -n '1,260p'
git diff --check
```

Final validation result:

| Command | Status | Notes |
|---|---|---|
| `git diff --check` | PASS | Completed with no output after this file was written. |
