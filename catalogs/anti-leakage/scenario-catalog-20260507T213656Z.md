# Anti-Leakage Scenario Catalog

[role: worker-codex-FR]

GLASSBOX artifact for Wave 6 worker W6-09.

## Scope

- Owned path: `catalogs/anti-leakage/scenario-catalog-20260507T213656Z.md`.
- Branch: `phase-8-5-i-anti-leakage-scenario-catalog-20260507T213656Z`.
- Purpose: red-team calibration/evaluation split violations before alpha release.
- Scientific status: mechanical scenario catalog only. No performance, novelty, or leaderboard claim is made.

## Source Inspection

Local inspection found the benchmark-level leakage taxonomy in
`docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md`.
That charter requires separation between:

- ECM parameter identification and calibration;
- algorithm hyperparameter training and tuning;
- blind evaluation and inference.

Local inspection also found `universal-runner-leakage-split-guard` in
`docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md`, where the planned
runner work is to add calibration/evaluation split guard fixtures. No concrete
split-guard output artifact is present in this async repo worktree at this
commit; this catalog therefore records expected detector surfaces and failure
signals for the Wave 5/Wave 6 integration reviewers to compare against the
runner and datasets branches.

Inspection commands:

```bash
rg -n "leakage|anti-leak|split guard|split_guard|calibration|evaluation|calib|eval" -S .
find . -maxdepth 4 -type f \( -iname '*leak*' -o -iname '*split*' -o -iname '*guard*' -o -iname '*catalog*' \) | sort
rg -n "split|leak|calibration|evaluation|blind|provenance|guard|manifest|source ledger|comparability" docs cto inbox outbox -S
```

## Detector Vocabulary

| Detector | Expected role |
|---|---|
| `stage_role_contract` | Requires every artifact, row group, and metric request to declare exactly one role: identification, tuning, evaluation, or report-only. |
| `split_identity_overlap` | Rejects the same canonical sample, file, cell, cycle, segment, or derived-row hash in calibration/tuning and blind evaluation roles. |
| `time_window_overlap` | Rejects overlapping timestamp, cycle, or step-index windows across non-report roles for the same physical cell/run. |
| `provenance_hash_guard` | Rejects missing or mismatched raw-file, cache, transform, split, and evidence hashes. |
| `parameter_source_guard` | Requires ECM parameters, OCV tables, scalers, priors, and estimator defaults to name their source role and source artifact. |
| `metric_access_guard` | Blocks calibration or tuning code paths from reading blind-evaluation metrics, residuals, or rankings. |
| `cache_partition_guard` | Requires cache keys to include dataset identity, transform identity, and split role so derived artifacts cannot be silently shared. |
| `report_claim_guard` | Requires reports to mark any blocked or partial comparability row as incomplete rather than promoting it. |

## Scenario Catalog

| ID | Violation scenario | Fixture pattern | Expected detector | Failure signal |
|---|---|---|---|---|
| AL-001 | The same physical cell/run appears in ECM parameter identification and blind evaluation under different display names. | Two manifests point to the same raw-file hash and cell serial while using aliases such as `cell_A` and `validation_cell_01`. | `split_identity_overlap` | Fail with duplicate canonical cell/run identity across `identification` and `evaluation`. |
| AL-002 | Calibration and evaluation windows overlap within a single run. | Calibration covers cycles 1-50 and evaluation covers cycles 45-80 for the same raw trace. | `time_window_overlap` | Fail with overlapping cycle or timestamp interval and report both role/window pairs. |
| AL-003 | Hyperparameters are tuned against evaluation RMSE or residual summaries. | Tuning script reads `evaluation_metrics.json` before freezing estimator configuration. | `metric_access_guard` | Fail because a `tuning` role process accessed a `blind_evaluation` metric artifact. |
| AL-004 | ECM parameters are fitted using evaluation OCV rest points. | Parameter file lists `source_role: evaluation` or references an evaluation split path in its OCV table provenance. | `parameter_source_guard` | Fail because parameter source role is not `identification` or an allowed external frozen prior. |
| AL-005 | Normalization constants are fitted over the union of calibration and evaluation data. | Scaler metadata has sample count equal to full dataset and no split-role source list. | `parameter_source_guard` plus `provenance_hash_guard` | Fail on scaler source hash that includes evaluation rows or missing split-scoped fit provenance. |
| AL-006 | Derived cache keys omit split role, allowing calibration and evaluation to consume the same harmonized artifact. | Cache path is keyed only by dataset name and transform version, not split ID or role. | `cache_partition_guard` | Fail because cache identity cannot prove role isolation. |
| AL-007 | Interpolation or resampling creates duplicate derived rows assigned to both sides of the split. | Two split files contain different row IDs but identical raw-file hash, timestamp, voltage, current, temperature, and SOC tuple hashes. | `split_identity_overlap` | Fail with duplicate derived-row hash across calibration/tuning and evaluation. |
| AL-008 | Augmented evaluation traces are used for tuning. | Noise-augmented variants carry parent hash from an evaluation segment and appear in the tuning split. | `provenance_hash_guard` plus `split_identity_overlap` | Fail because parent trace lineage crosses from evaluation into tuning. |
| AL-009 | Evaluation labels are used to choose initialization or reset policy. | Protocol config selects initial SOC from evaluation ground-truth metadata instead of the declared degraded-initialization policy. | `parameter_source_guard` | Fail because estimator initialization consumed blind labels or label-derived metadata. |
| AL-010 | Split manifests classify one role ambiguously or use multiple roles for one artifact. | A row group is tagged `calibration,evaluation`, `validation`, or empty role. | `stage_role_contract` | Fail with invalid or multi-valued role; no fallback role inference is allowed. |
| AL-011 | A public report includes evaluation results from a run whose split guard failed. | Report manifest references an evaluation bundle with `split_guard_status: failed` or missing. | `report_claim_guard` | Fail closed and mark the result row incomplete. |
| AL-012 | Source-ledger comparison rows mix incompatible splits while treating them as directly comparable. | Ledger row lacks split detail or maps a tuning split from one source to a blind-evaluation split in BSEBench. | `report_claim_guard` | Fail or mark not-comparable because split identity and role semantics are incomplete. |
| AL-013 | A cross-chemistry transfer run calibrates on the target chemistry before evaluation. | Transfer manifest says source domain is LFP but parameter or scaler provenance includes NMC evaluation artifacts. | `parameter_source_guard` plus `split_identity_overlap` | Fail because target-domain evaluation artifacts influenced calibration. |
| AL-014 | Leave-one-cell-out evaluation accidentally includes sibling segments from the held-out cell in tuning. | Split file excludes cell `C07` by row ID but tuning cache contains segments with canonical cell ID `C07`. | `split_identity_overlap` | Fail with held-out cell identity present outside `evaluation`. |
| AL-015 | Dataset card or manifest provenance is too sparse to prove split separation. | Split file lists paths but lacks raw hash, cell/run ID, cycle/time window, transform hash, or role. | `provenance_hash_guard` plus `stage_role_contract` | Fail as unverifiable rather than inferring identity from filenames. |

## Merge-Hardening Checks

Reviewers should treat a split-guard implementation as incomplete if any row
below can pass silently.

| Check | Must reject |
|---|---|
| Role completeness | Missing, unknown, or multi-role stage labels. |
| Canonical identity | Alias-only split separation without raw hash and cell/run identity. |
| Window identity | Overlapping cycle, timestamp, or step windows for the same physical run. |
| Derived lineage | Duplicate or parent-linked derived rows crossing roles. |
| Parameter provenance | ECM parameters, scalers, OCV tables, priors, or init policies sourced from evaluation artifacts. |
| Metric access | Tuning/calibration code reading blind-evaluation metrics or residuals. |
| Cache isolation | Cache keys that do not include split role and transform provenance. |
| Report handling | Guard-failed or unverifiable rows emitted as complete benchmark results. |

## Expected Guard Output Shape

A concrete split-guard output should be machine-readable and include at least:

```json
{
  "status": "failed",
  "guard": "split_identity_overlap",
  "scenario_id": "AL-001",
  "roles": ["identification", "evaluation"],
  "artifact_a": "path-or-id",
  "artifact_b": "path-or-id",
  "canonical_identity": "raw_hash/cell/run/window-or-row-hash",
  "failure_signal": "duplicate canonical identity across non-report roles"
}
```

For passing cases, the output should still include the checked roles, split
manifest hash, raw artifact hashes, transform/cache hashes, and detector list.
An `unknown` or `missing` field on the identity path should make the guard fail
closed unless the artifact is explicitly report-only.

## Alpha Release Gate Use

Before an alpha release or merge announcement, require evidence that the active
runner/datasets split guard rejects AL-001 through AL-015 or marks unsupported
scenarios as explicit gaps. A useful release artifact should include:

- command used to run the split guard;
- split manifest path and SHA256;
- detector names exercised;
- negative fixture IDs and failure signals;
- status for unknown provenance and report-only artifacts.

This catalog is intentionally neutral: it defines ways to falsify leakage
protection, not benchmark quality or scientific standing.
