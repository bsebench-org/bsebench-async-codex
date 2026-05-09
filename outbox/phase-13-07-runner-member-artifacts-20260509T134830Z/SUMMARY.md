# Phase phase-13-07-runner-member-artifacts-20260509T134830Z direct-worker summary

- Direct pid: `3038963`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-runner`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase13-07-runner-member-artifacts-20260509T134830Z`
- Target branch: `glassbox-phase13-07-runner-member-artifacts-20260509T134830Z`
- Branch SHA: `d4381ebce9cf0018a1f7d06f66d30dc0bc6418f2`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:06:14.806871Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+    )
+
+    assert collection["candidates"][0]["status"] == "blocked"
+    assert "dataset_fingerprint_mismatch" in collection["blocking_gaps"]
+
+
+def test_artifact_hash_mismatch_blocks_when_local_file_is_available(tmp_path: Path) -> None:
+    candidate = _candidate("ensemble_a", artifact_root=tmp_path)
+    candidate["ensemble"]["members"][0]["provenance"]["artifact_sha256"] = "0" * 64
+
+    collection = build_phase13_member_artifact_collection(
+        [candidate],
+        expected_dataset_fingerprint="sha256:dataset-a",
+        expected_split_id="holdout_v1",
+        required_metric_keys=("soc_rmse",),
+        artifact_root=tmp_path,
+    )
+
+    member = collection["candidates"][0]["members"][0]
+    assert member["artifact"]["verified_local_file"] is True
+    assert "member_artifact_sha256_mismatch" in member["blocking_gaps"]
+    assert "member_artifact_sha256_mismatch" in collection["blocking_gaps"]
+
+
+def test_json_loader_and_writer_round_trip_collection(tmp_path: Path) -> None:
+    candidate = _candidate("ensemble_a", artifact_root=tmp_path)
+    source = tmp_path / "candidate_reports.json"
+    source.write_text(
+        json.dumps({"candidate_reports": [candidate]}, allow_nan=False) + "\n",
+        encoding="utf-8",
+    )
+
+    reports = load_ensemble_candidate_reports_json(source)
+    collection = build_phase13_member_artifact_collection(
+        reports,
+        expected_dataset_fingerprint="sha256:dataset-a",
+        expected_split_id="holdout_v1",
+        required_metric_keys=("soc_rmse",),
+        artifact_root=tmp_path,
+    )
+    output = write_phase13_member_artifact_collection_json(
+        collection,
+        tmp_path / "collection.json",
+    )
+
+    loaded = json.loads(output.read_text(encoding="utf-8"))
+    assert loaded["schema_version"] == PHASE13_MEMBER_ARTIFACTS_SCHEMA_VERSION
+    assert loaded["summary"]["ready_candidates"] == 1
+
+
+def test_collection_rejects_empty_candidate_input() -> None:
+    with pytest.raises(Phase13MemberArtifactsError, match="non-empty sequence"):
+        build_phase13_member_artifact_collection([])
+
+
+def test_mutation_fixture_does_not_modify_original(tmp_path: Path) -> None:
+    candidate = _candidate("ensemble_a", artifact_root=tmp_path)
+    mutated = deepcopy(candidate)
+    mutated["ensemble"]["members"][0]["provenance"]["artifact_sha256"] = "0" * 64
+
+    assert candidate["ensemble"]["members"][0]["provenance"]["artifact_sha256"] != "0" * 64

tokens used
131,764
Implemented and pushed.

Commit: `d4381eb GLASSBOX [role: phase13-runner-artifacts] collect ensemble member artifacts`  
Branch: `glassbox-phase13-07-runner-member-artifacts-20260509T134830Z`

Changed only:
- `src/bsebench_runner/phase13_member_artifacts.py`
- `tests/test_phase13_member_artifacts.py`

Validation:
- `.venv/bin/python -m pytest -o addopts='' tests/test_phase13_member_artifacts.py -q` → `15 passed`
- `.venv/bin/python -m ruff check ...` → passed
- `.venv/bin/python -m ruff format --check ...` → passed
- `git diff --check` → passed

Skipped: full project test suite. The scoped module test and cheap lint/format checks were run.
```
