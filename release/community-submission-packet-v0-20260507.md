---
GLASSBOX:
  worker: W10-e
  role: release-integration-blocker-closure
  artifact: community-submission-packet-v0
  created_utc: 2026-05-07T22:01:52Z
  target_branch: phase-8-10-e-community-submission-packet-v0-20260507T215945Z
  write_set:
    - release/community-submission-packet-v0-20260507.md
    - templates/submissions/community-packet-v0/
---

# BSEBench Community Estimator Submission Packet v0

This packet is an operational intake index for external estimator submissions.
It defines the files a submitter must provide, the metadata fields maintainers
must check, and the fail-closed gates that block intake when provenance,
contract, dependency, smoke, or replay evidence is incomplete.

This packet is not benchmark evidence and does not rank submitted methods.

## Read-Only Inputs Inspected

- W5 runner integration red-team artifact:
  `redteam/wave5/runner-integration-redteam-20260507T213656Z.md` in
  `phase-8-5-a-runner-integration-redteam-20260507T213656Z`.
- W5 runner outputs R1-R6 recorded in that red-team artifact, including R1
  estimator adapter contract and R6 external submission smoke.
- Wave task item 13 in
  `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`, which records the
  dataset ETL contract requirement for harmonized voltage, current,
  temperature, cadence, SOC, and SOH fields.
- W7 validation branches
  `phase-8-7-b-datasets-current-validation-20260507T214728Z` and
  `phase-8-7-c-stats-datasets-cross-validation-20260507T214728Z`; no separate
  submission template was present there, so v0 anchors to the runner R6 toy
  external-submission path.
- Runner contract branch
  `phase-8-0-a-universal-runner-estimator-plugin-contract`, read-only:
  `src/bsebench_runner/estimator_contract.py` and
  `tests/test_estimator_contract.py`.
- Runner submission-smoke branch
  `phase-8-0-f-universal-runner-submission-smoke`, read-only:
  `examples/submissions/README.md`, `toy_external_estimator.py`,
  `toy_external_submission_split.yaml`, and `tests/test_submission_smoke.py`.
- W6 adversarial spec captured in the runner integration red-team artifact:
  positive submission smoke is insufficient by itself; invalid entrypoints,
  malformed outputs, unsafe layout, missing registries, and malformed split YAML
  must fail intake.

## Required Submitter Files

Each v0 submission packet must include exactly these required files:

| Required file | Template | Purpose | Intake rule |
| --- | --- | --- | --- |
| `submission_metadata.json` | `templates/submissions/community-packet-v0/submission_metadata.json` | Machine-readable submitter, estimator, contract, dependency, and evidence metadata. | Must parse as JSON and include no placeholder values. |
| `estimator_adapter.py` | `templates/submissions/community-packet-v0/estimator_adapter.py` | Python module exposing `build_filter_registry()`. Optional local smoke fixtures may expose `build_adapter_registry()`. | Must import by file path without network or cache mutation during smoke. |
| `dependency_risk_form.md` | `templates/submissions/community-packet-v0/dependency_risk_form.md` | Human-readable dependency, license, runtime, and secret-handling risks. | Any unknown required runtime dependency blocks intake. |
| `smoke_test.md` | `templates/submissions/community-packet-v0/smoke_test.md` | Command log and expected behavior for the runner import-by-path smoke. | Must include one passing command on a clean checkout or a documented block. |
| `replay_evidence.md` | `templates/submissions/community-packet-v0/replay_evidence.md` | Replay command, repo SHAs, input split, output artifact hashes, and maintainer rerun notes. | Missing replay command or missing artifact identity blocks intake. |
| `fail_closed_checklist.md` | `templates/submissions/community-packet-v0/fail_closed_checklist.md` | Maintainer checklist for hard blocking conditions. | All required checks must be `pass` before intake proceeds. |

Optional files are allowed only when referenced by `submission_metadata.json`:
local smoke split YAML, pinned lock files, tiny synthetic fixtures, or generated
smoke outputs. Large datasets, secrets, credentials, and private cache material
must not be included.

## Metadata JSON Minimum

`submission_metadata.json` is the packet root. Required top-level keys are:

- `packet_schema_version`: must be `bsebench.community_submission_packet.v0`.
- `submission_id`: stable lowercase identifier for this submitted packet.
- `estimator`: includes `name`, `version`, `contract_version`, `entrypoint`,
  and expected `step_outputs`.
- `submitter`: contact and affiliation fields, with explicit consent status.
- `repository`: source URL, commit SHA, license, and archive identity if any.
- `runtime`: Python version, package manager, platform, CPU/GPU requirements,
  network policy, and deterministic seed policy.
- `dependencies`: pinned direct dependencies and declared transitive-risk notes.
- `runner_smoke`: command, runner repo ref, split file, `n_max`, and expected
  status.
- `replay_evidence`: command, artifact paths, artifact hashes, and rerun status.
- `guardrails`: affirmations that the packet contains no secrets, no private
  cache material, and no unsupported result language.

The metadata file must mark unavailable metadata as `unknown` or `not_applicable`;
it must not infer missing source, license, split, hardware, or dependency facts.

## Runner Contract Summary

The v0 runner contract observed in the runner branch is:

- Estimator module exposes a factory registered through `FilterRegistry`.
- Each estimator instance provides `step(t, voltage_V, current_A, temperature_C)`.
- Each `step` result is a mapping with finite numeric values.
- `voltage_predicted` is required.
- Boolean, non-finite, missing, or non-numeric step outputs are intake blockers.
- Fresh estimator instances are required for separate runs.
- The smoke path imports the estimator module by file path and runs it through
  `run_benchmark` with a small split and bounded `n_max`.

For canonical datasets, submitters should replace only the estimator factory
side. Local adapters are allowed in v0 only for tiny no-I/O smoke fixtures.

## Smoke Test Command

Current runner-side reference smoke command, read-only:

```bash
cd /mnt/c/doctorat/bsebench-org/bsebench-runner-phase-8-0-f-universal-runner-submission-smoke
uv run --extra dev pytest tests/test_submission_smoke.py -q
```

Generic v0 packet smoke command is provided in
`templates/submissions/community-packet-v0/smoke_test.md`. It imports
`estimator_adapter.py` by path, loads a split YAML, builds the filter registry,
optionally builds a local smoke adapter registry, and calls `run_benchmark` with
bounded `n_max`.

## Replay Evidence Requirement

Replay evidence must identify:

- runner repository path or URL and commit SHA;
- datasets repository path or URL and commit SHA when canonical adapters are
  used;
- stats repository path or URL and commit SHA when a stats replay is run;
- exact smoke or replay command;
- split file identity and source commit;
- output artifact path, SHA256, and creation time;
- maintainer rerun status, including any blocker if the rerun could not start.

Replay mismatch, missing artifact hashes, unpinned runner ref, or unavailable
required dependencies must block intake.

## Fail-Closed Intake Checks

Maintainers must stop intake when any of these checks fails:

1. Required file missing, extra required file name changed, or JSON invalid.
2. Estimator contract version is not `bsebench.estimator.v1`.
3. `estimator_adapter.py` lacks `build_filter_registry()`.
4. Importing the estimator performs network access, writes outside a temp
   directory, reads secrets, or mutates caches.
5. Smoke run returns missing, non-finite, boolean, or non-numeric
   `voltage_predicted`.
6. Split YAML has overlapping calibration and evaluation identities or missing
   forensic metadata.
7. Dependency risk form has any required dependency with unknown license,
   unpinned version, native build requirement not documented, or private index.
8. Replay evidence lacks command, repo SHA, artifact path, or artifact hash.
9. Metadata contains unsupported result language, public ranking claims, or
   unverifiable performance assertions.
10. Commit messages or packet text include forbidden coauthor trailers.

## Maintainer Intake Order

1. Parse `submission_metadata.json`.
2. Check required file set against this index.
3. Run metadata and dependency-risk review.
4. Run estimator import smoke in a clean runner checkout.
5. Run replay command if provided and compare artifact identity.
6. Complete `fail_closed_checklist.md`.
7. Proceed only when every required check is `pass`.
