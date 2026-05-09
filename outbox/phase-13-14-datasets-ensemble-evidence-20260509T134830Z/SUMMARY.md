# Phase phase-13-14-datasets-ensemble-evidence-20260509T134830Z direct-worker summary

- Direct pid: `3041236`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-datasets`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-datasets-glassbox-phase13-14-datasets-ensemble-evidence-20260509T134830Z`
- Target branch: `glassbox-phase13-14-datasets-ensemble-evidence-20260509T134830Z`
- Branch SHA: `2ab41d80797c98e8f3c3308a99349cb95710e42b`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:07:53.537352Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+    )
+
+    assert manifest["status"] == "blocked"
+    gaps = manifest["datasets"][0]["blocking_gaps"]
+    assert "members.ensemble_a_ekf.metrics.non_finite_soc_rmse" in gaps
+    assert "members.ensemble_a_ukf.metrics.missing_soc_rmse" in gaps
+
+
+def test_manifest_fails_closed_on_artifact_hash_mismatch(tmp_path: Path) -> None:
+    path = _write_artifact(tmp_path, "truth-evidence.json", b"truth\n")
+    dataset = _dataset(tmp_path)
+    bad_dataset = DatasetEnsembleEvidenceSpec(
+        dataset_id=dataset.dataset_id,
+        split_id=dataset.split_id,
+        truth_evidence_status=dataset.truth_evidence_status,
+        truth_evidence=EvidenceArtifactRef(
+            uri="artifact://unit/truth-evidence.json",
+            local_path=path,
+            sha256="0" * 64,
+        ),
+        members=dataset.members,
+    )
+
+    manifest = build_phase13_ensemble_evidence_manifest(
+        manifest_id="phase13_fixture",
+        generated_at="2026-05-09T13:48:30Z",
+        datasets=[bad_dataset],
+        required_metric_keys=["soc_rmse"],
+    )
+
+    assert manifest["status"] == "blocked"
+    assert "truth_evidence.artifact_hash_mismatch" in manifest["datasets"][0]["blocking_gaps"]
+    assert manifest["datasets"][0]["truth_evidence"]["hash_status"] == "mismatch"
+
+
+def test_manifest_fails_closed_on_duplicate_dataset_split_and_member_ids(
+    tmp_path: Path,
+) -> None:
+    dataset = _dataset(tmp_path)
+    duplicate_member_dataset = DatasetEnsembleEvidenceSpec(
+        dataset_id="duplicate_dataset",
+        split_id="audit_j_v1",
+        truth_evidence_status="ready",
+        truth_evidence=_artifact(tmp_path, "duplicate-truth.json"),
+        members=[
+            _member(tmp_path, "duplicated_member"),
+            _member(tmp_path, "duplicated_member"),
+        ],
+    )
+
+    manifest = build_phase13_ensemble_evidence_manifest(
+        manifest_id="phase13_fixture",
+        generated_at="2026-05-09T13:48:30Z",
+        datasets=[dataset, dataset, duplicate_member_dataset],
+        required_metric_keys=["soc_rmse"],
+    )
+
+    assert manifest["status"] == "blocked"
+    assert "duplicate_dataset_split" in manifest["datasets"][1]["blocking_gaps"]
+    duplicate_member_gaps = manifest["datasets"][2]["blocking_gaps"]
+    assert "members.duplicated_member.duplicate_member_id" in duplicate_member_gaps

tokens used
119,238
Implemented and pushed the Phase 13 ensemble evidence helper.

Commit: `2ab41d8 GLASSBOX [role: phase13-datasets-evidence] add ensemble evidence manifest helper`

Changed only:
- `src/bsebench_datasets/phase13_ensemble_evidence.py`
- `tests/test_phase13_ensemble_evidence.py`

Validation run:
- `.venv/bin/python -m pytest tests/test_phase13_ensemble_evidence.py -q` passed, `6 passed`
- `.venv/bin/ruff check src tests` passed
- `.venv/bin/mypy src/bsebench_datasets/phase13_ensemble_evidence.py` passed
- `git diff --check` passed

Pushed branch:
`glassbox-phase13-14-datasets-ensemble-evidence-20260509T134830Z`
```
