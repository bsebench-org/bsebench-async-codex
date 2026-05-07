# BSEBench Public Governance Model

GLASSBOX artifact for worker W4-18.

## Objective

Define a public, non-scientific governance model for recurring BSEBench
benchmark operation. The model covers monthly submissions, release freezing,
disputes, reproducibility fixes, decision records, and transparency artifacts.

This document supports the universal benchmark objective by making public
benchmark operations auditable before BSEBench publishes community snapshots for
SOC/SOH estimators, ECMs, filters, observers, AI estimators, hybrid methods, and
future method families.

## Scope

In scope:

- submission intake and cutoff rules;
- monthly candidate, validation, freeze, publication, dispute, and correction
  states;
- decision records required for public governance;
- transparency artifacts required before and after freeze;
- recommendations for future machine-checkable gates.

Out of scope:

- scientific roadmap changes;
- thesis, manuscript, claim registry, `claims/registry.yaml`, or `claim_55`
  edits;
- empirical execution, source-ledger population, or claim registration;
- code implementation of validators.

## Evidence Inspected

Repository and branch:

- Worktree:
  `/mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report-phase-8-3-r-public-governance-model-20260507T204627Z`.
- Branch:
  `phase-8-3-r-public-governance-model-20260507T204627Z`.
- Initial status from `git status --short --branch`: clean branch tracking
  `origin/main`.
- `rg --files docs || true` showed no existing `docs/universal` directory in
  this worktree before this artifact was added.

Project governance and benchmark context:

- `sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`
  confirmed monthly community snapshots, provenance, split/leakage checks,
  caveats, invalid comparability handling, and the universal benchmark goal.
- `sed -n '1,220p' docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`
  confirmed Wave 1 through Wave 3 scope, guarded write sets, GLASSBOX metadata,
  and public benchmark operations.
- `sed -n '1,220p' docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` confirmed
  separation of evidence generation, source-ledger comparison, and claim
  registration.
- `sed -n '220,270p' docs/PROTOCOL.md` confirmed the GLASSBOX commit format and
  role-tag requirement.

Watchdog log inventory:

- `find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 2 -type f
  -name 'manual-phase-8-*.log' -printf '%f\n' | sort | wc -l` returned 72
  Phase 8 logs, including Wave 4 logs already started.
- `for wave in 0 1 2 3; do printf 'phase-8-%s ' "$wave"; find
  /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 2 -type f -name
  "manual-phase-8-${wave}-*.log" | wc -l; done` returned 24 Wave 1 logs, 12
  Wave 2 logs, 12 Wave 3 logs, and 24 Wave 4 logs.
- `for f in /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-{0,1,2}-*.log;
  do ... done` classified the first 48 Phase 8 logs as 45 completion-like and
  3 usage-limit logs.
- `rg -l "You've hit your usage limit"
  /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-2-*.log`
  identified the three Wave 3 usage-limit logs:
  `manual-phase-8-2-j-reproducibility-artifact-manifest-audit-20260507T193528Z.log`,
  `manual-phase-8-2-k-merge-queue-runbook-20260507T193528Z.log`, and
  `manual-phase-8-2-l-worker-triage-and-relaunch-runbook-20260507T193528Z.log`.

Adjacent public-benchmark evidence sampled:

- `tail -160` on the Wave 4 monthly snapshot, source-ledger, submission
  lifecycle, and community report logs was used as a status signal only.
- The adjacent logs contain governance-relevant concepts such as accepted
  submission packets, release checklists, leakage guard reports, source-ledger
  rows, freeze records, and append-only corrections.
- These adjacent logs were not treated as merged repository artifacts because
  this branch must stand alone and write only this file.

## Explicit Non-Claims

This artifact does not state or imply that any method is superior, validated for
claim registration, novel, SOTA, breakthrough, or the winner of a public
benchmark. It defines operational governance only.

This artifact does not create a source ledger, populate external comparison
rows, execute benchmark protocols, validate empirical values, or approve public
scientific claims.

This artifact does not authorize edits to thesis files, manuscript files, claim
registry files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap.

## Governance Principles

1. Public benchmark outputs are snapshots, not living mutable tables. A frozen
   snapshot can be corrected only through append-only errata or a replacement
   snapshot.
2. Operational inclusion is separate from scientific endorsement. Accepting a
   submission means BSEBench can run and report it under declared protocols; it
   does not imply claim validity.
3. Comparable rows, partial rows, non-comparable rows, failed runs, missing
   runs, and excluded methods must remain visible in public transparency
   artifacts.
4. A public value must be traceable to a command, config identity, commit SHA,
   artifact path, schema version, and hash when practical.
5. Any external comparison text requires a completed source ledger. Missing
   source fields block positive comparison language.
6. Disputes are handled by evidence state and artifact identity, not by private
   preference or silent edits.
7. Protected files and claim-registration lanes remain outside monthly
   benchmark governance unless a separate, explicit claim-registration task
   authorizes them.

## Monthly Governance Cycle

Recommended default cadence for a monthly public snapshot:

| Stage | Default timing | Governance output |
|---|---:|---|
| Call for submissions | Day 1 | Public submission instructions, accepted schema versions, supported protocols, cutoff date. |
| Intake window | Days 1-14 | Public submission register with status, method family, adapter path, requested protocol scope, and missing fields. |
| Intake cutoff | End of Day 14 | Cutoff decision record and list of accepted, incomplete, withdrawn, and out-of-scope submissions. |
| Adapter and protocol validation | Days 15-18 | Adapter smoke results, protocol compatibility checks, resource-limit declarations, and unresolved blockers. |
| Benchmark execution | Days 19-23 | Run manifests, raw evidence bundle index, execution failures, timeouts, and invalid-output records. |
| Metrics and comparability review | Days 24-26 | Metric matrix, aggregation caveats, leakage guard status, source-ledger status if external comparisons are used. |
| Release candidate | Day 27 | Candidate snapshot JSON, report draft, freeze checklist, and open blocker list. |
| Freeze vote | Day 28 | Freeze decision record with exact commits, hashes, schema versions, validators, and residual risks. |
| Publication | Day 29 or next business day | Frozen snapshot, public report, caveat table, decision-record index, and dispute window. |
| Errata window | First 14 days after publication | Public dispute docket and append-only correction records. |

The release owner may shift dates for holidays, infrastructure outages, or
dataset access constraints, but must record the changed dates in a decision
record before freeze.

## Submission Lifecycle

Each method submission should have one visible lifecycle state:

| State | Meaning | Public handling |
|---|---|---|
| `received` | Submission packet arrived before cutoff. | Listed with timestamp and declared method family. |
| `incomplete` | Required intake fields are missing. | Listed with missing fields; not executed unless corrected before cutoff. |
| `accepted_for_validation` | Intake packet complete and in scope. | Eligible for adapter, protocol, and dataset checks. |
| `adapter_rejected` | Adapter cannot be constructed, stepped, or reset under the public contract. | Listed with validator command and failure reason. |
| `protocol_blocked` | Requested protocol cannot be resolved or violates declared rules. | Listed with unresolved protocol IDs. |
| `accepted_for_run` | Adapter, protocol, and dataset availability checks pass. | Eligible for monthly execution. |
| `running` | Benchmark execution started. | Run manifest must be created before or during execution. |
| `evidence_pending` | Execution finished but artifacts, hashes, or logs are incomplete. | Not eligible for freeze until resolved or excluded. |
| `validated` | Evidence, leakage, metric, and schema checks pass. | Eligible for release candidate rows. |
| `non_comparable` | Result exists but cannot be fairly compared under declared axes. | May appear only with caveat rows and no positive comparison wording. |
| `excluded` | Submission is out of scope, invalid, unsafe, or insufficiently evidenced. | Must remain visible with reason unless privacy or security requires redaction. |
| `release_candidate` | Included in the candidate snapshot. | Subject to freeze checklist. |
| `frozen` | Included in immutable monthly snapshot. | Changes require erratum or replacement snapshot. |
| `disputed` | A public challenge is open. | Affected rows remain visible with dispute marker. |
| `corrected` | Append-only correction has been published. | Correction record links original and corrected artifacts. |
| `superseded` | Replacement snapshot supersedes prior frozen state. | Prior snapshot remains accessible with supersession notice. |
| `withdrawn` | Contributor withdrew before freeze, or governance removed it. | Listed with timestamp and reason category. |

State transitions require a timestamp, actor, reason, and artifact link. A
transition from `validated` to `release_candidate`, `frozen`, `corrected`, or
`superseded` also requires a decision record.

## Required Submission Packet

A submission is complete only when it includes:

- contributor and contact identity, with a public display name if different;
- method name, version, method family, and implementation license;
- adapter repository, branch or tag, commit SHA, and adapter entry point;
- required runtime environment, dependency lock identity, hardware assumptions,
  and resource limits;
- declared estimator outputs, including SOC and optional SOH fields;
- training, calibration, hyperparameter tuning, and evaluation data boundaries;
- any pretraining data, public data, private data, or synthetic data used;
- requested benchmark protocols, dataset axes, chemistry/profile/temperature
  axes, and unsupported axes;
- deterministic seeds or explicit statement that randomness is unavailable;
- known failure modes, invalid-output behavior, and expected timeout behavior;
- permission status for public reporting of results and artifact metadata.

Incomplete packets can be corrected until the cutoff. After cutoff, corrections
are allowed only for clerical metadata that does not change executable behavior,
dataset scope, or training/tuning boundaries.

## Freeze Requirements

A monthly snapshot can be frozen only when the release candidate has:

- snapshot ID, release candidate ID, release owner, and freeze timestamp;
- exact runner, stats, datasets, and report repository commits;
- schema versions for submissions, datasets, protocols, metrics, source ledger,
  snapshot JSON, and release checklist;
- accepted submission register and final lifecycle states;
- dataset availability snapshot with license and provenance caveats;
- protocol registry references and initialization policies;
- leakage guard reports for every comparable row;
- run manifests with commands, configs, cache identities, seeds, and resource
  limits;
- raw evidence bundle index with paths and hashes when practical;
- metric reports with failed, invalid, timeout, and missing counts;
- source ledger rows for any external comparison text;
- public report draft with caveat table and explicit non-claims;
- decision-record index for inclusion, exclusion, disputes, and freeze;
- `git diff --check` or equivalent whitespace validation for the governance
  repository branch carrying the release artifacts.

Freeze fails if a public numeric row cannot be traced to a frozen command,
config identity, output artifact, commit SHA, and validation status.

## Freeze Decision Record

Every freeze must create a decision record with these fields:

```yaml
record_id: PGM-FREEZE-YYYY-MM
record_type: freeze
snapshot_id: BSEBench-YYYY-MM
candidate_id: BSEBench-YYYY-MM-rcN
decision: freeze | block | defer
decision_time: YYYY-MM-DDTHH:MM:SSZ
release_owner: name-or-handle
validator_roster:
  runner: name-or-handle
  stats: name-or-handle
  datasets: name-or-handle
  governance: name-or-handle
frozen_refs:
  runner_commit: sha
  stats_commit: sha
  datasets_commit: sha
  report_commit: sha
artifact_index: path
hash_manifest: path
commands:
  - command: exact command
    result: pass | fail | skipped
    caveat: text
blockers_resolved:
  - blocker id and resolution
residual_risks:
  - risk and owner
protected_file_check: pass | fail
non_claim_statement: text
```

The freeze record is public. If sensitive contact details or private security
findings exist, redact only the sensitive fields and publish the redaction
reason.

## Public Decision Records

Decision records are append-only public governance artifacts. Each record must
include a stable ID, actor, date, affected submission or snapshot ID, decision,
evidence paths, commands inspected, alternatives considered, residual risk, and
reversal condition.

Required record types:

| Record type | Required when | Minimum decision values |
|---|---|---|
| `intake_cutoff` | Closing the monthly submission window. | `close`, `extend`, `partial_close`. |
| `inclusion` | Moving a submission into or out of release candidate scope. | `include`, `exclude`, `non_comparable`, `defer`. |
| `freeze` | Freezing or blocking a monthly snapshot. | `freeze`, `block`, `defer`. |
| `dispute_triage` | Accepting or rejecting a dispute for investigation. | `accept`, `reject`, `request_more_evidence`. |
| `dispute_outcome` | Closing a dispute. | `uphold`, `correct`, `supersede`, `retract_row`, `no_change`. |
| `reproducibility_fix` | Correcting artifacts after freeze. | `metadata_erratum`, `artifact_correction`, `value_change`, `supersede_snapshot`. |
| `protected_scope` | Any proposed exception touching protected files. | `block`, `escalate`; monthly governance should not approve. |

Decision records must never silently overwrite earlier records. If a decision
changes, write a new record that cites the previous record ID.

## Transparency Artifact Set

Each monthly public snapshot should publish or link these artifacts:

| Artifact | Purpose | Public minimum |
|---|---|---|
| Submission register | Shows who submitted what and what happened. | Submission ID, method display name, lifecycle state, reason category, timestamps. |
| Intake checklist | Shows completeness before execution. | Required fields, missing fields, cutoff status, accepted schema version. |
| Adapter validation report | Shows whether the method can run under the public contract. | Command, commit, environment, pass/fail, failure reason. |
| Protocol assignment record | Shows which protocols were requested and assigned. | Protocol IDs, initialization policy, unsupported axes, caveats. |
| Dataset availability snapshot | Shows what data axes were available and under what restrictions. | Dataset IDs, chemistry/profile/temperature/aging axes, license/provenance caveats. |
| Leakage guard report | Shows split and preprocessing boundaries. | Calibration, tuning, validation, evaluation scopes, overlap result, pass/fail. |
| Run manifest | Shows how evidence was generated. | Command, config hash, commit SHA, cache identity, seeds, resource limits, output paths. |
| Raw evidence bundle index | Shows where raw or per-run artifacts live. | Artifact path, hash when practical, size, schema version, permission caveat. |
| Metric matrix | Shows reported metrics and invalid rows. | Metric, unit, aggregation axis, counts, invalid/missing/timeout rows, caveats. |
| Compute evidence record | Shows runtime and resource evidence. | Runtime scope, hardware/environment identity, measurement caveat. |
| Source ledger | Supports any external comparison text. | Stable URL/DOI, retrieval date, exact metric, dataset, split, values, comparability. |
| Freeze record | Proves immutable release identity. | Snapshot ID, refs, hashes, validators, pass/fail status, residual risks. |
| Dispute docket | Shows public challenges and outcomes. | Dispute ID, affected artifact, status, evidence summary, decision record link. |
| Errata ledger | Shows post-freeze changes. | Original artifact, corrected artifact, reason, impact class, decision record link. |
| Non-claim statement | Prevents accidental claim promotion. | Exact wording that the snapshot is operational evidence, not claim registration. |

## Dispute Process

Any contributor, maintainer, or external reviewer may file a dispute against a
published snapshot row, exclusion decision, dataset/protocol assignment,
metric computation, source-ledger comparability decision, or reproducibility
record.

Dispute classes:

- `reproducibility`: command, hash, environment, or artifact cannot be replayed
  or audited as claimed.
- `leakage`: calibration, tuning, preprocessing, or evaluation boundaries are
  not disjoint or are insufficiently disclosed.
- `metric`: metric definition, unit, aggregation, invalid-row policy, or count
  is wrong or unclear.
- `dataset`: availability, license, chemistry/profile/temperature/aging
  metadata, or provenance is wrong or incomplete.
- `adapter`: submitted method was rejected or executed in a way inconsistent
  with the public contract.
- `comparability`: source-ledger row, external value, BSEBench value, or caveat
  does not support the public wording.
- `conduct_or_scope`: submission or dispute is abusive, unsafe, private,
  duplicate, or outside BSEBench scope.

Default dispute timeline:

| Step | Target time | Public output |
|---|---:|---|
| Acknowledge | 2 business days | Dispute ID, affected snapshot rows, dispute class, triage owner. |
| Triage | 5 business days | `accept`, `reject`, or `request_more_evidence` decision record. |
| Investigation | 10 business days after acceptance | Evidence review notes, commands run, artifact paths, interim caveats if needed. |
| Outcome | 15 business days after acceptance | `dispute_outcome` decision record and any erratum or supersession plan. |

The release owner may mark affected rows as `disputed` while investigation is
open. A disputed marker is not itself a finding; it tells readers that the row
is under active governance review.

## Reproducibility Fix Policy

Post-freeze fixes are append-only and classed by impact:

| Class | Example | Required action |
|---|---|---|
| A: Metadata erratum | Typo, broken link, missing contact display name, wrong non-numeric label that does not affect reproducibility. | Add erratum record; keep snapshot ID unchanged. |
| B: Artifact correction | Missing hash, wrong artifact path, or incomplete command record where values are unchanged and replay identity can be repaired. | Add corrected artifact index and `reproducibility_fix` decision record. |
| C: Value-impacting correction | Metric, split, dataset identity, source-ledger decision, invalid-row count, or run output changes. | Publish replacement snapshot or superseded row; keep original visible. |
| D: Integrity breach | Leakage, protected-file edit, hidden failed run, fabricated artifact, or source-ledger absence supporting public comparison text. | Retract affected rows or supersede snapshot; open incident record and block claim use. |

No class allows silent mutation of a frozen snapshot. The original artifact,
corrected artifact, reason, actor, command, timestamp, and impact class must
remain public.

## Public Communication Rules

Public reports should:

- separate accuracy, convergence, robustness, compute, generalization, and
  evidence-quality axes;
- show invalid, failed, missing, timeout, excluded, and non-comparable rows;
- include the non-claim statement near public tables and summaries;
- cite snapshot ID, release date, frozen refs, and artifact index;
- link to dispute and errata ledgers;
- avoid positive external comparison wording unless the source-ledger row is
  complete and marked comparable;
- avoid single-axis public ranking unless the report also shows caveats,
  evidence quality, and invalid/missing row handling.

Public reports should not:

- hide missing or failed runs from denominator counts;
- merge SOC and SOH outcomes without separate units and caveats;
- present partial or non-comparable rows as direct comparisons;
- use protected files or claim registries as monthly-governance artifacts;
- imply thesis claim status from operational benchmark inclusion.

## Findings

| Finding | Status | Evidence |
|---|---|---|
| Public governance can stay non-scientific. | Pass | This artifact defines process, records, and transparency artifacts only. |
| Monthly submissions need explicit lifecycle states. | Recommendation | Existing charter calls for monthly snapshots; lifecycle states prevent silent exclusions and hidden failures. |
| Freeze must be immutable and hash-backed. | Recommendation | Research gate protocol requires provenance and replay; governance maps those requirements to monthly snapshots. |
| Disputes need public state and bounded outcomes. | Recommendation | Without a docket and decision records, post-publication corrections can become silent edits. |
| Reproducibility fixes need impact classes. | Recommendation | Classes A-D separate clerical errata from value-changing corrections and integrity breaches. |
| Decision records and transparency artifacts are mandatory for public trust. | Pass | Required record types and artifact set are defined above. |
| Three Wave 3 logs need retry/accounting. | Pass for accounting | Watchdog search found usage-limit failures for Wave 3 `j`, `k`, and `l`; this artifact accounts for them but does not retry them. |

## Falsification Conditions

This governance model is insufficient if any of these conditions are true:

- a monthly snapshot can be published without a freeze record;
- a public numeric row has no run manifest or artifact identity;
- a public comparison has no completed source-ledger row;
- an included method can move from submission to frozen status without visible
  lifecycle transitions;
- a dispute can change public rows without an append-only decision record;
- a value-changing reproducibility fix can silently mutate a frozen snapshot;
- protected files can be edited as part of monthly benchmark governance.

## Validation Commands To Record

Pre-commit validation for this branch should include:

```bash
git status --short --branch
git diff --name-only HEAD
git diff --check
rg -n "SOTA|novelty|leaderboard|breakthrough|verified-claim|claim_55|claims/registry.yaml|thesis|manuscript|roadmap" docs/universal/public-governance-model-20260507T204627Z.md
```

Expected validation interpretation:

- `git diff --name-only HEAD` must list only this file.
- `git diff --check` must pass.
- Guardrail terms may appear only in explicit non-claims, protected-file
  guardrails, or publication-blocking contexts.

## Observed Validation Results

Timestamp: 2026-05-07T22:53:52+02:00.

| Check | Result |
|---|---|
| `git status --short --branch` before edit | Clean branch at the task worktree. |
| `git pull --rebase origin main` | Fast-forwarded from `60fe4a7` to `69761bf`; upstream touched only `scripts/cto-autonomy-pacer.sh` and `scripts/probe-autonomy-pacer-safety.sh`. |
| `git diff --cached --name-only` | `docs/universal/public-governance-model-20260507T204627Z.md` only. |
| `git diff --name-only HEAD` | `docs/universal/public-governance-model-20260507T204627Z.md` only. |
| `git diff --cached --check` | Passed. |
| `git diff --check` | Passed. |
| Guardrail term scan | Terms appear only in scope exclusions, explicit non-claims, protected-file guardrails, or the validation command itself. |
| Protected-file scope | Passed. No thesis, manuscript, roadmap, claim registry, `claims/registry.yaml`, or `claim_55` files were edited. |
| Non-scientific governance | Passed. The artifact defines process and transparency controls only. |
| Decision records and transparency artifacts | Passed. Required record types and public artifact set are defined. |

## Residual Risks

- This artifact is a governance specification only; it does not implement
  validators, schemas, release tooling, or dispute automation.
- Adjacent Wave 4 logs were inspected as status signals, not as merged source
  artifacts. Future integration should reconcile this model with the final
  merged submission lifecycle, source-ledger, snapshot, and report artifacts.
- Exact public calendar dates should be adjusted by the release owner before a
  real launch because holidays, dataset access, and infrastructure outages may
  shift the monthly cadence.
- External dispute evidence may require private security or contact details;
  public records should redact sensitive fields while preserving the redaction
  reason.
- A source ledger is still required before any external comparison language can
  support a public scientific claim or claim-registration task.
