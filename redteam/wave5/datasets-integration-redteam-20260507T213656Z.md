# GLASSBOX: Wave 5 Datasets Integration Red-Team

Metadata:
- Worker: W6-03
- Wave: 6 red-team, merge hardening, and alpha-release preparation
- Artifact timestamp: 2026-05-07T21:41:47Z
- Owned write-set: `redteam/wave5/datasets-integration-redteam-20260507T213656Z.md`
- Scope: datasets Wave 1 D1-D6 integration risk only
- Target integration branch: `phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z`
- Target pushed head observed: `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66`
- Report status: RED-TEAM CAUTIONS, with merge-blocking falsification gates

## Decision

Do not alpha-publish or merge the datasets integration as release-ready until a successor
validator reruns the gates on the pushed W5-03 head and the cross-schema falsification gates
below are satisfied. The current evidence supports that the W5-03 branch was eventually pushed
and has clean local validation in its worker log, but W5-07's independent validator artifact was
created before that push and therefore recorded `PENDING_REMOTE_PUSH`.

This is not a rejection of the dataset integration. It is a red-team hold on public/release
language and final merge readiness until the pushed SHA is independently replayed.

## Evidence Inspected

Wave 1 and validation artifacts:
- `validation/wave-1/datasets-20260507T193050Z.md` from
  `origin/phase-8-1-m-validator-datasets-wave1-20260507T193050Z`
- `validation/wave-4/datasets-wave1-deep-validation-20260507T204627Z.md` from
  `origin/phase-8-3-f-datasets-wave1-deep-validation-20260507T204627Z`
- `validation/wave-5/datasets-integration-validator-20260507T213125Z.md` from
  `origin/phase-8-4-g-datasets-integration-validator-20260507T213125Z`

Datasets repo/log evidence:
- Wave 1 D1-D6 watchdog logs under `/home/oakir/.local/state/bsebench-async-watchdog`
- W5-03 integration watchdog log:
  `/home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z.log`
- `git ls-remote --heads origin 'phase-8-0-[m-r]*'` in `bsebench-datasets`
- `git ls-remote --heads origin 'phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z'`
- Read-only inspection of the pushed W5 integration files:
  `etl_contract.py`, `ground_truth_metadata_audit.py`, `splits.py`,
  `dataset_card.py`, `equipment_registry.py`, `availability.py`, and their focused tests

## Timeline Findings

1. Wave 1 dataset validation initially found no pushed D1-D6 branch heads and correctly marked
   D1-D6 as pending.
2. Wave 4 deep validation later found D1-D6 pushed, matching local/remote heads, and focused
   tests passed. It still warned that D1-D6 were isolated branches and that combined
   import/export conflicts could appear around `src/bsebench_datasets/__init__.py`.
3. Wave 5 validator W5-07 inspected W5-03 while the integration branch was local-only at
   `d62d1efb5a032617eb08daee27dafc86cdc1e1f8`; it recorded `PENDING_REMOTE_PUSH` and did not
   run focused tests on mutable local state.
4. W5-03 subsequently committed `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66`, pushed
   `phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z`, and recorded:
   - focused D1-D6 tests: `60 passed`
   - non-slow suite with `dev` and `adapters-mat`: `292 passed, 29 deselected`
   - `ruff check src tests`: passed
   - `git diff --check`: passed
5. A fresh read-only fetch observed the pushed integration branch at
   `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66`, and `git diff --check
   origin/main..origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z`
   returned exit code 0 with no output.

## Confirmed Conflicts

The W5-03 log records two real merge conflicts in `src/bsebench_datasets/__init__.py`:
- D4 dataset-card exports conflicted with the already-merged D2 ground-truth audit exports.
- D6 availability exports conflicted with the accumulated D2/D4 public API exports.

The final pushed head includes a hardening commit for the export order. This resolves the
observed conflict class mechanically, but it does not prove that the public API shape is stable
for runner/stats consumers.

Required falsification gate:
- In a clean checkout of pushed head `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66`, run:
  `python - <<'PY'` importing every new package-level symbol from `bsebench_datasets`, then
  `rg -n '<<<<<<<|=======|>>>>>>>' src tests splits`.

## Schema Collision Risks

Risk 1: dataset identity is fragmented across schemas.
- Dataset cards use `dataset_id`.
- Availability records use `name`.
- Equipment records use `dataset_name`.
- Ground-truth audit accepts `dataset`, `dataset_id`, or `name`.

This is a likely join-collision surface for public reports: two records can be individually valid
while referring to different ids or aliases.

Falsification gate:
- Add a combined fixture that constructs one dataset card, availability record, equipment record,
  and ground-truth audit record for the same dataset and proves a single canonical id is used.
- Add a negative fixture where `dataset_id`, `name`, and `dataset_name` disagree, and require the
  integration/report builder to fail closed.

Risk 2: target names differ between ETL and split/report schemas.
- ETL truth targets are `soc_truth` and `soh_truth`.
- Split evaluation target signals include `soc`, `soh`, `voltage_V`, `current_A`, `temperature_C`,
  and `capacity_Ah`.
- Dataset card SOH targets include both source-label concepts such as `capacity_Ah` and the time
  series target name `soh_truth`.

This can silently blur "raw measured field", "derived truth label", and "evaluation target".

Falsification gate:
- Add a cross-schema target-normalization test that maps split targets to exact ETL fields or
  explicitly marks them as non-ETL aggregate targets.
- Fail when a split target is interpreted by string similarity rather than an explicit mapping.

Risk 3: schema versions are independent and easy to overstate.
- D1 ETL: `bsebench-datasets-etl-field-contract/v1`
- D2 ground truth: `bsebench-ground-truth-metadata-audit/v1`
- D3 split: `1.1`
- D4 card: `bsebench-dataset-card/v1`
- D5 equipment: `bsebench-raw-equipment-registry/v1`
- D6 availability: `bsebench-dataset-availability-snapshot/v1`

These are useful local contracts, not a single universal dataset schema.

Falsification gate:
- Public/release artifacts must refer to these as component schemas unless a single top-level
  compatibility manifest is added and validated.

## Ground-Truth Ambiguity Risks

Risk 4: `STATUS_NOT_APPLICABLE` can be mistaken for readiness.

The ground-truth audit returns `not_applicable` when no supported SOC method is declared, including
records that only declare unsupported methods. That is correct for an audit helper, but dangerous
for a public benchmark gate if downstream logic treats "no blocking gaps" as ready.

Falsification gate:
- Any SOC/SOH benchmark or public dataset card must require `evidence_ready is True` and at least
  one audited ready method before claiming SOC/SOH ground-truth readiness.
- `not_applicable` and `not_audited_methods` must be non-ready states for SOC/SOH evidence.

Risk 5: leakage is metadata-only unless runner inputs are checked.

D1 marks `soc_truth` and `soh_truth` as `target_only`, and D2 requires `uses_future_test_labels`
to be exactly false. The current integration does not prove that runner estimator inputs cannot
receive truth arrays.

Falsification gate:
- Add a runner-facing fixture that constructs a loader trace with `soc_truth` and `soh_truth`, then
  proves estimator input construction includes only `t`, `V`, `I`, `T_meas`, and `dt_s`.
- Add a malicious estimator/submission smoke test that fails if target arrays are visible at step
  time.

Risk 6: OCV/coulomb-counting evidence is audited but not recalculated.

D2 checks required metadata fields for coulomb counting and OCV recalibration. It does not
download sources, recompute SOC, validate OCV curves, or verify that referenced capacities match
trace data.

Falsification gate:
- Public wording must say "metadata audit" unless a source-ledger-backed recomputation exists.
- A completed source ledger is required before using stronger terms such as verified ground truth.

## ETL Metadata Gap Risks

Risk 7: current sign conversion can diverge across existing loaders.

D1 defines BPX Tier 2 `current_A` as charge-positive and runner `I` as discharge-positive via
`I = -current_A`. Existing loaders were not all changed to consume this helper. The branch proves
the helper, not whole-repo adoption.

Falsification gate:
- For every Tier 2 loader used by runner protocols, add a known discharge segment fixture that
  asserts runner-facing `I` is positive during discharge and that no double inversion occurs.

Risk 8: `dt_s` is defined but optional.

D1 defines `dt_s` as derived from `t`, but existing loader outputs may not include it. That creates
an API ambiguity for estimators that depend on explicit sample cadence.

Falsification gate:
- Decide one of two contracts before alpha release:
  1. all benchmark traces must include `dt_s`, or
  2. runner protocol materializes `dt_s` before passing traces to estimators.
- Add a failing test for whichever layer owns the obligation.

Risk 9: availability snapshots are metadata availability, not remote uptime.

D6 policy correctly states that snapshots do not verify remote uptime, run loaders, or establish
performance claims. Public reports can still accidentally abbreviate `tier2_available` as
"available" without the caveat.

Falsification gate:
- Monthly/public reports must include the D6 policy caveat verbatim or a mechanically equivalent
  field-level caveat.
- `tier2_available` must mean "manifest records a Tier 2 repository", not "remote verified live".

Risk 10: equipment provenance permits unknown and inferred records.

D5 correctly preserves `unknown` and `inferred`; these states must not be counted as verified raw
equipment provenance.

Falsification gate:
- Public report aggregation must separate `reported`/`file_header` equipment confidence from
  `inferred`/`unknown`.
- Unknown equipment must remain a gap, not a guessed vendor.

## Merge-Hardening Gates

Required before calling the datasets integration independently validated:

1. Fetch pushed head and pin the SHA:
   `git fetch origin phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z`
   and require `6cbdc5477a51d5a65c36a568be6d56eeb6c7ce66` or record a newer SHA.
2. Run focused pushed-head gates in a clean datasets checkout:
   `uv run --extra dev pytest tests/test_etl_contract.py tests/test_ground_truth_metadata_audit.py tests/test_split_audit_j_v1.py tests/test_dataset_card.py tests/test_equipment_registry.py tests/test_availability_snapshot.py -q`.
3. Run practical non-slow suite with optional MAT dependencies:
   `uv run --extra dev --extra adapters-mat pytest -m "not slow" -q`.
4. Run `uv run --extra dev ruff check src tests`.
5. Run both `git diff --check HEAD` and conflict-marker search:
   `rg -n '<<<<<<<|=======|>>>>>>>' src tests splits`.
6. Add the cross-schema identity, target-normalization, truth-leakage, loader-sign, and `dt_s`
   ownership tests listed above, or record them as explicit alpha blockers.
7. Reissue the Wave 5 datasets integration validator artifact against the pushed branch, because
   the current W5-07 artifact predates the push.

## Non-Claims

This red-team artifact does not claim:
- Datasets Wave 5 has been merged to `main`.
- Dataset source ledgers, licenses, remote mirrors, or SOC/SOH ground truth are complete or
  scientifically verified.
- BSEBench is SOTA, novel, a leaderboard winner, or a verified scientific benchmark result.
- Availability snapshot rows prove live remote uptime.
- The pushed integration is release-ready without the gates above.
