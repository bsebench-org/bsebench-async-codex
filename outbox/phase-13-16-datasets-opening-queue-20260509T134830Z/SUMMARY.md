# Phase phase-13-16-datasets-opening-queue-20260509T134830Z direct-worker summary

- Direct pid: `3042031`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-datasets`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-datasets-glassbox-phase13-16-datasets-opening-queue-20260509T134830Z`
- Target branch: `glassbox-phase13-16-datasets-opening-queue-20260509T134830Z`
- Branch SHA: `bdde8b8cc249f30129aa611c2982aa086d3ddbca`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:07:16.881714Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+        tmp_path / "manifests" / "blocked_dataset.yaml",
+        _manifest("blocked_dataset"),
+    )
+
+    queue = build_phase13_dataset_evidence_opening_queue(
+        manifests_dir=tmp_path / "manifests",
+        splits_dir=tmp_path / "splits",
+        outputs_dir=tmp_path / "outputs",
+    )
+
+    assert queue["summary"]["blocked_count"] == 1
+    row = queue["rows"][0]
+    assert row["status"] == BLOCKED
+    assert {gap["code"] for gap in row["blocking_gaps"]} == {
+        "missing_split_evidence",
+        "missing_finite_metric_evidence",
+    }
+
+
+def test_phase13_opening_queue_fails_closed_on_invalid_manifest_hash(
+    tmp_path: Path,
+) -> None:
+    _write_yaml(
+        tmp_path / "manifests" / "bad_hash.yaml",
+        _manifest("bad_hash", sha256="not-a-sha256"),
+    )
+    _write_split(tmp_path / "splits" / "audit_j_v1.yaml")
+    _write_truth_audit(
+        tmp_path / "outputs" / "phase12_truth_candidate_audit_20260509.json",
+        soh_only=1,
+    )
+
+    queue = build_phase13_dataset_evidence_opening_queue(
+        manifests_dir=tmp_path / "manifests",
+        splits_dir=tmp_path / "splits",
+        outputs_dir=tmp_path / "outputs",
+    )
+
+    row = queue["rows"][0]
+    assert row["status"] == BLOCKED
+    assert "manifest_invalid" in {gap["code"] for gap in row["blocking_gaps"]}
+    assert set(row["gates"]) == {"manifest", "provenance", "hashes", "split", "finite_metrics"}
+
+
+def test_phase13_opening_queue_writer_round_trips_json(tmp_path: Path) -> None:
+    queue = {
+        "schema_version": PHASE13_OPENING_QUEUE_SCHEMA_VERSION,
+        "summary": {"row_count": 0, "ready_count": 0, "blocked_count": 0},
+        "rows": [],
+    }
+
+    path = write_phase13_dataset_evidence_opening_queue(queue, tmp_path / "queue.json")
+
+    assert json.loads(path.read_text(encoding="utf-8")) == queue

tokens used
113,989
Implemented and pushed commit `bdde8b8`:

`GLASSBOX [role: phase13-datasets-opening-queue] add dataset evidence opening queue`

Changed only owned paths:
- [phase13_opening_queue.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-glassbox-phase13-16-datasets-opening-queue-20260509T134830Z/src/bsebench_datasets/phase13_opening_queue.py)
- [test_phase13_opening_queue.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-glassbox-phase13-16-datasets-opening-queue-20260509T134830Z/tests/test_phase13_opening_queue.py)
- [phase13_dataset_evidence_open_queue_20260509.json](/mnt/c/doctorat/bsebench-org/bsebench-datasets-glassbox-phase13-16-datasets-opening-queue-20260509T134830Z/outputs/phase13_dataset_evidence_open_queue_20260509.json)

Generated queue summary:
- `15` manifest rows
- `1` ready for evidence opening: `nasa_pcoe_saha_goebel_2007`, scoped as `soh_only_evidence_opening`
- `14` blocked
- downloads/uploads/execution all explicitly `false`

Validation run:
- `uv run --extra dev pytest tests/test_phase13_opening_queue.py` passed
- `uv run --extra dev python -m bsebench_datasets.phase13_opening_queue` passed
- `uv run --extra dev ruff check .` passed
- `uv run --extra dev ruff format --check ...` passed
- `git diff --check` and `git diff --cached --check` passed

Skipped full pytest suite; targeted pytest plus repo-wide ruff were run instead. Branch is pushed to `origin/glassbox-phase13-16-datasets-opening-queue-20260509T134830Z`.
```
