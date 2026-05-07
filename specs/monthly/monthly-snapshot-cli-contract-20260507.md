# BSEBench Monthly Snapshot CLI Contract

GLASSBOX artifact for Wave 7 worker W7-e.

Saved: 2026-05-07T21:43:05Z task window.

Branch:
`phase-8-6-e-monthly-snapshot-cli-contract-20260507T214305Z`.

Owned path:
`specs/monthly/monthly-snapshot-cli-contract-20260507.md`.

## Scope

This document defines a concrete CLI contract for generating monthly benchmark
snapshot artifacts from frozen BSEBench inputs:

- dataset availability and split/provenance records;
- benchmark protocols and run manifests;
- source ledgers for any external comparison text;
- accepted estimator, ECM, observer, AI-estimator, hybrid, or baseline
  submissions;
- runner evidence bundles and stats metric outputs.

It is a contract only. It does not execute a benchmark, publish results, rank
methods, make external-comparison claims, register scientific claims, edit thesis
or manuscript files, edit claim registries, edit `claims/registry.yaml`, edit
`claim_55`, or change the scientific roadmap.

If an input is unavailable, mutable, dirty, unhashable, or only described in
prose, the CLI must record a blocker or non-comparable status. It must not
fabricate missing fields from memory.

## Evidence Cross-Check

The contract below was derived from the current checkout and read-only branch
artifacts. Paths are cited as `ref:path` when the artifact is not merged in this
branch.

| Area | Evidence inspected | Finding used in this contract |
|---|---|---|
| Universal benchmark direction | `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md` | Monthly community snapshots must support plug-and-play estimators, provenance, leakage checks, caveats, invalid comparability cases, and multi-axis reporting. |
| Universal wave guardrails | `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md` | Workers must avoid protected files, unsupported claim language, and missing validation. |
| Research gate | `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` | Evidence generation, source-ledger comparison, and claim registration are separate lanes; source-ledger rows require stable source identity, retrieval date, metric, dataset, split, value, BSEBench value, comparability, and caveat. |
| Snapshot JSON schema | `origin/phase-8-0-t-universal-async-monthly-snapshot-schema:docs/BSEBENCH-MONTHLY-SNAPSHOT-SCHEMA-2026-05-07.md` and `docs/schemas/bsebench-monthly-benchmark-snapshot-v1.schema.json` | Snapshot payload schema ID is `bsebench.monthly_benchmark_snapshot.v1`; release and row caveats are required. |
| Monthly workflow | `origin/phase-8-1-r-monthly-benchmark-workflow-design-20260507T193050Z:docs/universal/monthly-benchmark-workflow-20260507T193050Z.md` | Monthly cycle states run from intake through frozen snapshot, with publication gates G0-G9. |
| Snapshot artifact schema | `origin/phase-8-3-l-monthly-snapshot-artifact-schema-20260507T204627Z:specs/universal/monthly-snapshot-artifact-schema-20260507T204627Z.md` | Release wrapper schema ID is `bsebench.monthly_snapshot_artifact.v1`; it adds submissions, metric registry, validation gates, and freeze record around the snapshot payload. |
| Monthly dry-run checklist | `origin/phase-8-4-n-monthly-benchmark-dry-run-checklist-20260507T213125Z:runbooks/monthly-benchmark-dry-run-20260507T213125Z.md` | Dry-run requires a release dossier, ref ledger, gate records, hashes, blockers, and preserved invalid/missing/non-comparable rows. |
| Submission intake | `origin/phase-8-0-s-universal-async-submission-template:templates/universal-contributor-submission-template.md` and contributor validation checklist | CLI inputs must preserve submission identity, code/hash, adapter contract, split disclosure, provenance, source-ledger status, and reproduction commands. |
| Public release checklist | `origin/phase-8-0-w-universal-async-public-release-checklist:docs/BSEBENCH-PUBLIC-BENCHMARK-RELEASE-CHECKLIST-2026-05-07.md` | Release is blocked when public values lack frozen artifact/commit traceability, leakage separation, source-ledger rows, or visible failed/invalid rows. |

Blocked integration inputs in this branch:

- The monthly snapshot schema, artifact schema, workflow, dry-run checklist,
  release checklist, and submission template are branch artifacts, not files
  merged into this checkout.
- No implemented `bsebench-snapshot` or `bsebench_report` CLI exists in this
  async-report checkout.
- Runner, stats, and datasets Phase 8/11 integration branches were not edited or
  executed from this branch.

## CLI Name And Entry Points

The public entry point should be:

```bash
bsebench-snapshot <subcommand> [options]
```

Python module entry point:

```bash
python -m bsebench_snapshot <subcommand> [options]
```

Implementations may place the command in the async/report repo or a dedicated
report package, but the command name and JSON contracts below are stable.

Required subcommands:

| Subcommand | Purpose | Writes benchmark evidence? |
|---|---|---:|
| `plan` | Create or validate a freeze plan before execution. | no |
| `preflight` | Resolve frozen refs, input paths, hashes, schemas, and gates without running filters. | no |
| `build` | Assemble snapshot JSON and artifact wrapper from already-frozen inputs. | no new runner evidence |
| `validate` | Validate snapshot/artifact JSON, cross-reference closure, gate statuses, and hashes. | no |
| `freeze` | Write the final freeze record after validation passes. | no |
| `explain-blockers` | Render machine-readable blockers as a concise human report. | no |

The CLI must never run expensive estimator evaluation unless a later runner
contract explicitly delegates that responsibility. This CLI consumes frozen
runner/stat/dataset artifacts and can run read-only validation or replay checks.

## Common Options

All subcommands accept:

| Option | Required | Contract |
|---|---:|---|
| `--snapshot-id ID` | yes except `validate` when inferable from input | Pattern `bsebench-monthly-YYYY-MM` with optional `-rcN` or suffix. |
| `--snapshot-month YYYY-MM` | yes for `plan`, `preflight`, and `build` | Calendar month being reported. |
| `--candidate-id ID` | yes for mutable candidates | Immutable release-candidate ID, for example `bsebench-monthly-2026-05-rc1`. |
| `--artifact-root PATH` | yes | Output root for plan, preflight, snapshot, logs, validation reports, and freeze record. |
| `--format json|markdown` | no | Default `json`; `markdown` allowed only for `explain-blockers`. |
| `--strict` | no | Treat warnings as blockers when they affect comparability, source-ledger, leakage, or provenance. |
| `--dry-run` | no | Resolve and validate planned outputs without writing final snapshot/freeze files. May still write a dry-run report when `--out` is supplied. |
| `--out PATH` | no | Explicit output path for the subcommand report. Must be under `--artifact-root` unless `--stdout` is used. |
| `--stdout` | no | Write result JSON to stdout and avoid file output except temporary validator logs. |
| `--base-ref REF` | no | Base ref for protected-file scan. Default: merge base with `origin/main` when available. |

All paths in output JSON must be normalized relative paths under
`artifact_root`, or explicit repository paths with repo identity when they point
to immutable source inputs. User-home-dependent paths are allowed only in
`local_context` and must not be used as public evidence without a caveat.

## Input Options

`preflight` and `build` require explicit frozen inputs.

| Option | Required for comparable rows | Description |
|---|---:|---|
| `--async-report-ref REF` | yes | Ref or commit for async/report artifacts. |
| `--runner-ref REF` | yes | Ref or commit for runner code used to generate evidence. |
| `--stats-ref REF` | yes | Ref or commit for stats code used to compute metrics. |
| `--datasets-ref REF` | yes | Ref or commit for dataset manifests, splits, and availability. |
| `--submission-registry PATH` | yes | Frozen submission packet index. |
| `--submission-bundle PATH` | no | Optional directory or archive containing frozen contributor packets. |
| `--dataset-availability PATH` | yes | Dataset availability snapshot or manifest. |
| `--dataset-splits PATH` | yes | Machine-readable split manifest. |
| `--protocol-registry PATH` | yes | Protocol registry snapshot. |
| `--metric-registry PATH` | yes | Metric definitions and aggregation policy. |
| `--run-manifest PATH` | yes | Frozen run manifest mapping methods, protocols, datasets, splits, and output paths. |
| `--runner-evidence PATH` | yes | Frozen runner evidence bundle or manifest. |
| `--stats-results PATH` | yes | Frozen stats metric output or manifest. |
| `--source-ledger PATH` | only when comparison text is present | Source ledger for external comparison rows. |
| `--report-draft PATH` | no | Candidate public report for wording and value-cell binding scans. |
| `--release-checklist PATH` | yes for `freeze` | Gate sign-off record or checklist artifact. |
| `--snapshot-schema PATH` | yes for `validate` | JSON Schema for `bsebench.monthly_benchmark_snapshot.v1`. |
| `--artifact-schema PATH` | yes for `validate` when wrapper is present | Schema or structural validator for `bsebench.monthly_snapshot_artifact.v1`. |

If any required input path is absent, not parseable, not immutable, or lacks a
hashable byte representation, the CLI must return a blocker with
`blocker_type=missing_input`, `unparseable_input`, or `unhashable_input`.

## Subcommand Contracts

### `plan`

Purpose: write the release-owner freeze plan before benchmark execution starts.

Example:

```bash
bsebench-snapshot plan \
  --snapshot-id bsebench-monthly-2026-05-rc1 \
  --snapshot-month 2026-05 \
  --candidate-id bsebench-monthly-2026-05-rc1 \
  --artifact-root artifacts/monthly/2026-05/rc1 \
  --cycle-window-start-utc 2026-05-01T00:00:00Z \
  --cycle-window-end-utc 2026-05-31T23:59:59Z \
  --submission-cutoff-utc 2026-05-25T23:59:59Z \
  --freeze-candidate-at-utc 2026-06-01T00:00:00Z \
  --release-owner release-owner-id \
  --out artifacts/monthly/2026-05/rc1/freeze-plan.json
```

Required output:

- `freeze-plan.json`;
- `plan_report.json` when `--out` differs from the default;
- status `planned`, `blocked`, or `dry_run`.

`plan` must fail with exit code `2` when required dates are missing, non-UTC,
not ordered, or after `freeze_candidate_at_utc` without a new candidate suffix.

### `preflight`

Purpose: resolve every planned input to a commit, content hash, parser status,
schema ID, gate expectation, and intended output path without running filters.

Example:

```bash
bsebench-snapshot preflight \
  --snapshot-id bsebench-monthly-2026-05-rc1 \
  --snapshot-month 2026-05 \
  --candidate-id bsebench-monthly-2026-05-rc1 \
  --artifact-root artifacts/monthly/2026-05/rc1 \
  --async-report-ref <async-report-sha> \
  --runner-ref <runner-sha> \
  --stats-ref <stats-sha> \
  --datasets-ref <datasets-sha> \
  --submission-registry inputs/submissions/submission-registry.json \
  --dataset-availability inputs/datasets/availability-2026-05.json \
  --dataset-splits inputs/datasets/splits-2026-05.json \
  --protocol-registry inputs/protocols/protocol-registry.json \
  --metric-registry inputs/stats/metric-registry.json \
  --run-manifest inputs/runs/run-manifest.json \
  --runner-evidence inputs/runs/runner-evidence-manifest.json \
  --stats-results inputs/stats/stats-results-manifest.json \
  --source-ledger inputs/source-ledgers/source-ledger.json \
  --report-draft reports/monthly/2026-05/report-draft.md \
  --dry-run \
  --out artifacts/monthly/2026-05/rc1/preflight-report.json
```

`preflight` must produce:

- `preflight-report.json`;
- `input-lock.json` with refs, paths, SHA-256 hashes, and parser identities;
- `gate-plan.json` with G0-G9 expected validators;
- `blockers.json` when any blocking condition exists.

Minimum checks:

- refs resolve to full SHAs and are not local-only unless explicitly marked
  `local_only_blocked`;
- input files exist, parse, and hash;
- result-producing inputs have runner, stats, datasets, and async/report refs;
- submission rows resolve to method rows;
- dataset rows resolve to availability and split records;
- protocol rows resolve to metric, dataset, and split policies;
- source ledger exists when report text contains external comparison language;
- protected-file scan from `--base-ref` reports no protected-path changes;
- output paths are unique under `artifact_root`.

### `build`

Purpose: assemble the monthly snapshot payload and artifact wrapper from frozen
inputs. `build` may not create new runner evidence or recompute hidden metrics.
It may normalize already-frozen rows, copy hashes, and generate public-report
binding metadata.

Example:

```bash
bsebench-snapshot build \
  --snapshot-id bsebench-monthly-2026-05-rc1 \
  --snapshot-month 2026-05 \
  --candidate-id bsebench-monthly-2026-05-rc1 \
  --artifact-root artifacts/monthly/2026-05/rc1 \
  --input-lock artifacts/monthly/2026-05/rc1/input-lock.json \
  --gate-plan artifacts/monthly/2026-05/rc1/gate-plan.json \
  --submission-registry inputs/submissions/submission-registry.json \
  --dataset-availability inputs/datasets/availability-2026-05.json \
  --dataset-splits inputs/datasets/splits-2026-05.json \
  --protocol-registry inputs/protocols/protocol-registry.json \
  --metric-registry inputs/stats/metric-registry.json \
  --run-manifest inputs/runs/run-manifest.json \
  --runner-evidence inputs/runs/runner-evidence-manifest.json \
  --stats-results inputs/stats/stats-results-manifest.json \
  --source-ledger inputs/source-ledgers/source-ledger.json \
  --report-draft reports/monthly/2026-05/report-draft.md \
  --out artifacts/monthly/2026-05/rc1/monthly-snapshot-artifact.json
```

Required outputs:

- `monthly-snapshot.json` with `schema_version` equal to
  `bsebench.monthly_benchmark_snapshot.v1`;
- `monthly-snapshot-artifact.json` with `schema_version` equal to
  `bsebench.monthly_snapshot_artifact.v1`;
- `hashes.sha256`;
- `public-value-bindings.json` when `--report-draft` is provided;
- `blockers.json` when any row cannot be made comparable.

Required preservation rules:

- invalid, missing, excluded, blocked, partial, and non-comparable rows stay
  visible;
- null numeric values are used for missing/excluded/blocked rows;
- every result row has non-empty caveat strings for comparability, dataset,
  split, metric, leakage, provenance, compute, and exclusion;
- rankings are emitted only inside named ranking groups and only for valid,
  comparable, ranking-eligible rows;
- source-ledger rows cannot upgrade a row to scientific claim status.

### `validate`

Purpose: validate schema shape, cross-reference invariants, hashes, gate records,
report wording, and protected-file boundaries.

Example:

```bash
bsebench-snapshot validate \
  --artifact-root artifacts/monthly/2026-05/rc1 \
  --snapshot-json artifacts/monthly/2026-05/rc1/monthly-snapshot.json \
  --artifact-json artifacts/monthly/2026-05/rc1/monthly-snapshot-artifact.json \
  --snapshot-schema docs/schemas/bsebench-monthly-benchmark-snapshot-v1.schema.json \
  --artifact-schema specs/universal/monthly-snapshot-artifact-schema-20260507T204627Z.md \
  --report-draft reports/monthly/2026-05/report-draft.md \
  --base-ref origin/main \
  --strict \
  --out artifacts/monthly/2026-05/rc1/validation-report.json
```

Minimum validation gates:

| Gate ID | Blocking condition |
|---|---|
| `G0_SCOPE` | Protected files, claim registry, roadmap, or unrelated paths are changed. |
| `G1_SUBMISSION` | Included method lacks accepted submission packet and checklist decision. |
| `G2_ADAPTER` | Executable method lacks smoke result or explicit exclusion. |
| `G3_DATASET` | Reported row lacks dataset availability, license status, split, cache, or provenance caveat. |
| `G4_SPLIT_LEAKAGE` | Calibration/training/validation/tuning/evaluation separation is missing or violated. |
| `G5_EVIDENCE` | Public value lacks command, config hash, result hash, output path, or commit identity. |
| `G6_METRICS` | Metric unit, direction, aggregation, finite-value policy, or failed-run count is missing. |
| `G7_SOURCE_LEDGER` | External comparison language exists without complete source-ledger rows. |
| `G8_REPORT_QUALITY` | Report hides invalid rows, caveats, non-comparable cases, or unsupported ranking context. |
| `G9_FREEZE` | Snapshot JSON, artifact wrapper, report, checklist, source ledger, and hashes point to different candidates. |

`validate` must report:

- command executed;
- artifacts read;
- values or counts compared;
- mismatch count;
- tolerances when numeric comparisons are performed;
- pass/fail/blocker status for each gate.

"Command exited zero" is not sufficient without those fields.

### `freeze`

Purpose: write the final freeze record after `validate` passes.

Example:

```bash
bsebench-snapshot freeze \
  --snapshot-id bsebench-monthly-2026-05 \
  --snapshot-month 2026-05 \
  --candidate-id bsebench-monthly-2026-05-rc1 \
  --artifact-root artifacts/monthly/2026-05/rc1 \
  --snapshot-json artifacts/monthly/2026-05/rc1/monthly-snapshot.json \
  --artifact-json artifacts/monthly/2026-05/rc1/monthly-snapshot-artifact.json \
  --validation-report artifacts/monthly/2026-05/rc1/validation-report.json \
  --release-checklist artifacts/monthly/2026-05/rc1/release-checklist.json \
  --release-owner release-owner-id \
  --out artifacts/monthly/2026-05/rc1/freeze-record.json
```

`freeze` must fail unless:

- all blocking gates are `passed` or `not_applicable` with non-empty rationale;
- `hashes.sha256` includes snapshot JSON, artifact wrapper, report if present,
  source ledger if present, release checklist, and validation report;
- frozen refs match the refs recorded by `preflight`;
- no blocker has status `open`;
- the publish decision is one of `blocked`, `publish_with_caveats`, or
  `publish`.

The CLI must allow `publish_decision=blocked` as a valid freeze outcome for a
candidate that should not be public. Blocking records are useful artifacts.

### `explain-blockers`

Purpose: convert `blockers.json` or a validation report into a human-readable
handoff without changing machine artifacts.

Example:

```bash
bsebench-snapshot explain-blockers \
  --artifact-root artifacts/monthly/2026-05/rc1 \
  --blockers artifacts/monthly/2026-05/rc1/blockers.json \
  --format markdown \
  --out artifacts/monthly/2026-05/rc1/BLOCKERS.md
```

The Markdown report must include blocker ID, affected entity, validator command,
stop condition, next action, and caveat.

## Output JSON Envelopes

Every subcommand writes an envelope with these top-level fields:

| Field | Required | Rule |
|---|---:|---|
| `schema_version` | yes | Subcommand-specific schema ID, for example `bsebench.snapshot_cli.preflight.v1`. |
| `command` | yes | Exact argv string with secrets redacted. |
| `started_at_utc` | yes | ISO datetime. |
| `finished_at_utc` | yes | ISO datetime or null on fatal error. |
| `snapshot_id` | yes | Snapshot or candidate ID. |
| `candidate_id` | yes | Candidate ID or null for pure validation. |
| `artifact_root` | yes | Artifact root used by the command. |
| `inputs` | yes | Paths, refs, hashes, parser status, and caveats. |
| `outputs` | yes | Created or planned paths, hashes, and statuses. |
| `validation_gates` | yes | Gate status records when applicable. |
| `blockers` | yes | Array; empty only when no blocker exists. |
| `warnings` | yes | Array; warnings cannot mask blockers. |
| `exit_code` | yes | Numeric exit code from this contract. |

Blocker shape:

```json
{
  "blocker_id": "G5_EVIDENCE:row-001:no-result-hash",
  "gate_id": "G5_EVIDENCE",
  "blocker_type": "missing_hash",
  "severity": "blocking",
  "affected_entity": "result_rows[row-001]",
  "validator_command": "bsebench-snapshot validate ...",
  "observed": "result_sha256 is null",
  "expected": "result_sha256 is a SHA-256 hash for comparable rows",
  "stop_condition": "Public value lacks frozen result identity",
  "next_action": "rerun_preflight_or_mark_non_comparable",
  "caveat": "Row cannot support comparable publication until the raw result hash is recorded."
}
```

## Exit Codes

| Code | Meaning |
|---:|---|
| `0` | Command completed and no blocking conditions remain. |
| `1` | Command completed with non-blocking warnings. |
| `2` | CLI usage error, invalid arguments, bad date order, or unsupported option combination. |
| `3` | Missing, unparseable, unhashable, or mutable input. |
| `4` | Schema validation failed. |
| `5` | Cross-reference closure failed. |
| `6` | Protected-file or write-set gate failed. |
| `7` | Leakage, split, or provenance gate failed. |
| `8` | Source-ledger or unsupported comparison-language gate failed. |
| `9` | Freeze consistency failed. |
| `10` | Internal error; must include traceback path or diagnostic caveat, not a silent failure. |

Exit codes `3` through `9` are expected validation outcomes and must produce
`blockers.json` when file output is enabled.

## Required Artifact Layout

Default output layout under `--artifact-root`:

```text
artifacts/monthly/YYYY-MM/rcN/
  freeze-plan.json
  preflight-report.json
  input-lock.json
  gate-plan.json
  monthly-snapshot.json
  monthly-snapshot-artifact.json
  validation-report.json
  freeze-record.json
  blockers.json
  hashes.sha256
  logs/
    protected-file-scan.txt
    source-ledger-scan.txt
    schema-validation.txt
    cross-reference-validation.txt
```

The CLI may write fewer files in `--dry-run` or `--stdout` mode, but the report
must list planned paths and explain what was not written.

## Falsification Conditions

The CLI implementation is incomplete if any condition can pass silently:

- a comparable result row lacks a frozen runner command, config hash, result
  hash, output path, runner/stats/datasets/async commit, or non-empty caveat;
- a source-ledger-backed comparison lacks stable URL or DOI, retrieval date,
  exact metric, dataset, split, external value, BSEBench frozen row, comparability
  label, or caveat;
- a ranking includes invalid, missing, excluded, blocked, partial, or
  non-comparable rows without marking that status visibly;
- protected thesis, manuscript, claim registry, `claims/registry.yaml`,
  `claim_55`, roadmap, or unrelated files are accepted in the release diff;
- `freeze` succeeds while any blocking gate is `failed`, `blocked`, or
  `not_run`;
- a dry-run reports success without naming command, artifacts read, checks
  performed, mismatch counts, and blockers or warnings.

## Implementation Notes

Recommended parser behavior:

- Prefer JSON input for registries and manifests.
- Permit CSV only when the CLI writes a normalized JSON shadow artifact with a
  hash and parser version.
- Preserve unknown fields in an `extra_fields` or `raw_row` block only when the
  schema permits it; do not let unknown fields satisfy required fields.
- Hash exact bytes with SHA-256 and record the hash command.
- Use UTC for release lifecycle timestamps.
- Record local environment facts in `local_context`, but do not treat local paths
  as public provenance unless the release artifact explicitly caveats them.

Recommended first implementation milestone:

1. Implement `plan`, `preflight --dry-run`, `validate`, and `explain-blockers`
   before `build` and `freeze`.
2. Add two positive fixtures and one negative fixture for each blocking gate.
3. Add a CLI self-test that proves a missing result-row leakage caveat, missing
   source-ledger retrieval date, and protected-file diff each produce blockers.
4. Add a read-only branch-artifact rebinding step after Wave 5/Wave 6 integration
   lands the monthly schema and dry-run artifacts on the integration branch.

## Explicit Non-Claims

- This contract does not claim that BSEBench has published a monthly benchmark
  snapshot.
- This contract does not claim that any method is better than another.
- This contract does not make SOTA, novelty, leaderboard, breakthrough,
  superior, universal-proven, or verified scientific claims.
- This contract does not approve any dataset license, remote availability,
  redistribution right, source-ledger comparability decision, or public report.
- This contract does not implement runner, stats, datasets, or async-report code.

## Validation Commands For This Artifact

Commands used while drafting:

```bash
pwd && git status --short --branch
find specs -maxdepth 3 -type f 2>/dev/null | sort
rg -n "monthly|snapshot|dry-run|frozen|ledger|submission|protocol|benchmark" README.md docs specs outbox inbox cto 2>/dev/null
rg -n "monthly snapshot|monthly-snapshot|snapshot CLI|freeze|frozen evidence|source ledger|leaderboard|submission|dry-run preflight|manifest replay|frozen" docs README.md cto/AUTONOMY_BACKLOG inbox outbox --glob '*.md' --glob '!outbox/**/run.log.tail'
git branch -a --list '*monthly*' '*snapshot*' '*phase-8*' '*source-ledger*' '*manifest*'
nl -ba docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md | sed -n '1,240p'
nl -ba docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md | sed -n '1,190p'
nl -ba docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md | sed -n '1,130p'
git show origin/phase-8-0-t-universal-async-monthly-snapshot-schema:docs/BSEBENCH-MONTHLY-SNAPSHOT-SCHEMA-2026-05-07.md
git show origin/phase-8-0-t-universal-async-monthly-snapshot-schema:docs/schemas/bsebench-monthly-benchmark-snapshot-v1.schema.json
git show origin/phase-8-1-r-monthly-benchmark-workflow-design-20260507T193050Z:docs/universal/monthly-benchmark-workflow-20260507T193050Z.md
git show origin/phase-8-3-l-monthly-snapshot-artifact-schema-20260507T204627Z:specs/universal/monthly-snapshot-artifact-schema-20260507T204627Z.md
git show origin/phase-8-4-n-monthly-benchmark-dry-run-checklist-20260507T213125Z:runbooks/monthly-benchmark-dry-run-20260507T213125Z.md
git show origin/phase-8-0-s-universal-async-submission-template:templates/universal-contributor-submission-template.md
git show origin/phase-8-0-s-universal-async-submission-template:docs/BSEBENCH-UNIVERSAL-CONTRIBUTOR-VALIDATION-CHECKLIST-2026-05-07.md
git show origin/phase-8-0-w-universal-async-public-release-checklist:docs/BSEBENCH-PUBLIC-BENCHMARK-RELEASE-CHECKLIST-2026-05-07.md
```

Pre-commit validation required for this branch:

```bash
git diff --check
rg -n "SOTA|novelty|leaderboard|breakthrough|superior|universal-proven|verified scientific|claim_55|claims/registry.yaml|thesis|manuscript|roadmap" specs/monthly/monthly-snapshot-cli-contract-20260507.md
git diff --name-only HEAD
```

Expected wording-scan interpretation: matches are allowed only in guardrail,
blocked-language, protected-file, source-ledger, explicit non-claim, or
validation-command contexts. This contract must not contain result claims,
external comparison claims, or claim-registration language.
