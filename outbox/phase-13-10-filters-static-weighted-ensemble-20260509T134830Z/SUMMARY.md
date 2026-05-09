# Phase phase-13-10-filters-static-weighted-ensemble-20260509T134830Z direct-worker summary

- Direct pid: `3039984`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-filters`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase13-10-filters-static-weighted-ensemble-20260509T134830Z`
- Target branch: `glassbox-phase13-10-filters-static-weighted-ensemble-20260509T134830Z`
- Branch SHA: `9a1a91f4b8e6cc469bf5a387fcbdeca43b679198`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:06:17.684949Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+    with pytest.raises(ContractComplianceError, match=message):
+        adapter.combine(members)
+
+
+@pytest.mark.parametrize(
+    ("kwargs", "message"),
+    [
+        ({"split_id": "unknown"}, r"split_id must identify concrete provenance/evidence"),
+        ({"artifact_sha256": "not-a-sha"}, "artifact_sha256 must be a lowercase SHA-256"),
+        (
+            {"dataset_fingerprint": "not-a-fingerprint"},
+            "dataset_fingerprint must include a lowercase SHA-256",
+        ),
+    ],
+)
+def test_member_metadata_requires_split_hash_and_provenance(
+    kwargs: dict[str, str],
+    message: str,
+) -> None:
+    base = {
+        "member_id": "ekf",
+        "estimate": universal_estimate(name="ekf", value=0.4),
+        "run_id": "run-ekf",
+        "split_id": "calce-a123-train-freeze-v1",
+        "dataset_fingerprint": DATASET_FINGERPRINT,
+        "artifact_sha256": "b" * 64,
+    }
+    base.update(kwargs)
+
+    with pytest.raises(ContractComplianceError, match=message):
+        StaticWeightedMemberEstimate(**base)
+
+
+def test_auxiliary_prediction_key_mismatch_fails_before_output() -> None:
+    adapter = StaticWeightedEnsembleAdapter(
+        method_id="phase13-static-weighted-fixture",
+        weights={"ekf": 0.5, "ukf": 0.5},
+    )
+    ekf = member("ekf", 0.4)
+    ukf = StaticWeightedMemberEstimate(
+        member_id="ukf",
+        estimate=UniversalEstimate(
+            contract_version=CONTRACT_VERSION,
+            target="soc",
+            target_unit="fraction",
+            value=0.6,
+            t=7.0,
+            provenance=provenance("ukf"),
+            evidence=sample_evidence(),
+            auxiliary_predictions={"alternate_voltage_predicted_V": 3.6},
+            state={"soc": 0.6},
+            innovation=0.01,
+        ),
+        run_id="run-ukf",
+        split_id="calce-a123-train-freeze-v1",
+        dataset_fingerprint=DATASET_FINGERPRINT,
+        artifact_sha256="b" * 64,
+    )
+
+    with pytest.raises(ContractComplianceError, match=r"auxiliary_predictions\.ukf keys"):
+        adapter.combine([ekf, ukf])

tokens used
123,136
Implemented and pushed the Phase 13 static weighted ensemble adapter.

Changes:
- Added `StaticWeightedEnsembleAdapter` and `StaticWeightedMemberEstimate` in `src/bsebench_filters/phase13_static_weighted_ensemble.py`.
- Added strict validation for weights, member IDs, evidence alignment, split IDs, SHA-256 hashes, dataset fingerprints, provenance, finite values, target/timestamp consistency, and aux prediction key consistency.
- Exported the new public symbols from `bsebench_filters`.
- Added focused tests in `tests/test_phase13_static_weighted_ensemble.py`.

Validation:
- `.venv/bin/python -m pytest tests/test_phase13_static_weighted_ensemble.py -q` passed: `18 passed`.
- `git diff --check` passed.
- `.venv/bin/ruff check src tests` passed.

Commit pushed:
- `9a1a91f GLASSBOX [role: phase13-filters-static-weighted] add static weighted ensemble adapter`
- Branch: `glassbox-phase13-10-filters-static-weighted-ensemble-20260509T134830Z`
```
