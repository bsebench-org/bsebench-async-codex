# Wave 7 Source-Ledger Fixture Pack Validation

Worker: `W7-c`
Date: `2026-05-07`
Branch: `phase-8-6-c-source-ledger-fixture-pack-20260507T214305Z`
Owned write set:

- `fixtures/source-ledger/phase8-alpha-20260507/`
- `validation/wave-7/source-ledger-fixture-pack-20260507.md`

## Artifact

Added a minimal fixture-only source-ledger pack for Phase 8 alpha comparability
audits:

- `fixtures/source-ledger/phase8-alpha-20260507/manifest.json`
- `fixtures/source-ledger/phase8-alpha-20260507/bsebench-values.json`
- `fixtures/source-ledger/phase8-alpha-20260507/external-sources.json`
- `fixtures/source-ledger/phase8-alpha-20260507/comparison-bindings.json`
- `fixtures/source-ledger/phase8-alpha-20260507/README.md`

## Evidence Inspected

Read-only evidence inspected from this worktree:

- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`, section `G4 - SOTA Comparison Source Ledger`.
- `docs/PROTOCOL.md`, section `Commit format - GLASSBOX`.
- `outbox/phase-7-10-p-async-source-ledger-comparability-fixtures/SUMMARY.md`.
- Remote branch listing for existing `source-ledger` and `phase-8` branches.
- `origin/phase-8-3-k-source-ledger-schema-spec-20260507T204627Z:specs/universal/source-ledger-schema-20260507T204627Z.md`.

No runner, stats, or datasets repository files were edited.

## Manual Field Completeness

`bsebench-values.json` rows include:

- `bsebench_value_id`
- `value_kind`
- `bsebench_value`
- `bsebench_metric`
- `metric_direction`
- `bsebench_dataset`
- `bsebench_split`
- `bsebench_method`
- `artifact_repo`
- `artifact_branch`
- `artifact_commit`
- `artifact_path`
- `artifact_hash`
- `generation_command`
- `replay_command`
- `validation_log`
- `environment`
- `evidence_status`
- `caveat`

`external-sources.json` rows include:

- `source_id`
- `source_type`
- `title`
- `doi_or_url`
- `retrieved_at`
- `source_location`
- `access_status`
- `method_family`
- `method`
- `task`
- `target_signal`
- `metric`
- `metric_unit`
- `metric_direction`
- `aggregation`
- `dataset`
- `dataset_version`
- `chemistry`
- `temperature_condition`
- `split`
- `preprocessing`
- `calibration_policy`
- `reported_value`
- `reported_uncertainty`
- `value_note`
- `caveat`

`comparison-bindings.json` rows include:

- `comparison_id`
- `source_id`
- `bsebench_value_ids`
- `comparison_scope`
- `comparability`
- `metric_match`
- `dataset_match`
- `split_match`
- `method_basis_match`
- `preprocessing_match`
- `leakage_risk`
- `caveat`
- `review_status`
- `reviewer`
- `expected_gate_decision`

Binding referential checks:

- `cmp-synth-comparable-001` references `src-synth-comparable-001` and `bsev-synth-soc-mae-001`.
- `cmp-synth-partial-001` references `src-synth-partial-001` and `bsev-synth-soc-mae-001`.
- `cmp-synth-not-comparable-001` references `src-synth-not-comparable-001`, `bsev-synth-soc-mae-001`, and `bsev-synth-soc-rmse-001`.

Expected classification coverage:

- Comparable fixture row: `cmp-synth-comparable-001`.
- Partial fixture row: `cmp-synth-partial-001`.
- Not-comparable fixture row: `cmp-synth-not-comparable-001`.

## Non-Claim Notes

- All fixture numbers are synthetic placeholders.
- The pack does not compare real methods, datasets, filters, observers, or models.
- The pack does not make SOTA, novelty, leaderboard, breakthrough, superior,
  universal-proven, or verified scientific statements.
- The pack does not register, verify, reject, or target any thesis claim,
  including `claim_55`.

## Blockers

Real Phase 8 alpha source-ledger rows are blocked because this branch does not
contain a committed frozen BSEBench evidence artifact or a completed external
source ledger with real retrieved source rows. The fixture pack therefore stays
synthetic-only and cannot support public comparison wording.

## Validation Commands

Commands run from the branch worktree:

```bash
jq empty fixtures/source-ledger/phase8-alpha-20260507/*.json
jq -e --slurpfile b fixtures/source-ledger/phase8-alpha-20260507/bsebench-values.json --slurpfile s fixtures/source-ledger/phase8-alpha-20260507/external-sources.json '($b[0].rows | map(.bsebench_value_id)) as $bids | ($s[0].rows | map(.source_id)) as $sids | all(.rows[]; (.source_id as $sid | $sids | index($sid)) and all(.bsebench_value_ids[]; . as $bid | $bids | index($bid)))' fixtures/source-ledger/phase8-alpha-20260507/comparison-bindings.json
git add -N fixtures/source-ledger/phase8-alpha-20260507 validation/wave-7/source-ledger-fixture-pack-20260507.md
git diff --check
```

Results:

- JSON parse check: pass.
- Binding reference check: pass; every `source_id` and `bsebench_value_id` in
  `comparison-bindings.json` resolves to a fixture row.
- `git diff --check`: pass with no output after intent-to-add marked the new
  files visible to the diff.
- `bash -n`: not applicable; no shell script was added.
