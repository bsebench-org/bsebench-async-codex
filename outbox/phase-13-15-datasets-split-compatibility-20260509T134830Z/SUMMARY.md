# Phase phase-13-15-datasets-split-compatibility-20260509T134830Z direct-worker summary

- Direct pid: `3041669`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-datasets`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-datasets-glassbox-phase13-15-datasets-split-compatibility-20260509T134830Z`
- Target branch: `glassbox-phase13-15-datasets-split-compatibility-20260509T134830Z`
- Branch SHA: `f90b5a9cd1c300530163424915056d7d40eea88c`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:06:22.940146Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+                        evaluation=_split("evaluation_v2", SHA_D, role="evaluation"),
+                    ),
+                ],
+            }
+        ]
+    )
+    paths = write_phase13_split_compatibility_gate(
+        gate,
+        output_dir=tmp_path / "outputs",
+        docs_dir=tmp_path / "docs",
+    )
+
+    loaded = json.loads(paths["gate"].read_text(encoding="utf-8"))
+    report = paths["report"].read_text(encoding="utf-8")
+    record = loaded["candidates"][0]
+    assert loaded["summary"]["comparison_blocked"] == 1
+    assert loaded["decision"]["candidate_comparison_allowed"] is False
+    assert record["comparison_allowed"] is False
+    assert "mismatched_calibration_split" in record["blocking_gaps"]
+    assert "mismatched_evaluation_split" in record["blocking_gaps"]
+    assert "NO_GO_CLAIM" in report
+    assert "mismatched calibration splits" in report
+
+
+def test_phase13_split_compatibility_fails_closed_on_missing_evidence() -> None:
+    gate = build_phase13_split_compatibility_gate(
+        [
+            {
+                "candidate_id": "ensemble_incomplete",
+                "members": [
+                    {
+                        "member_id": "ekf",
+                        "calibration_split": {"split_id": "calibration_v1"},
+                        "evaluation_split": {
+                            "split_id": "evaluation_v1",
+                            "manifest_sha256": "not-a-sha",
+                        },
+                        "metrics": {"soc_rmse": math.nan},
+                    },
+                    _member(
+                        "ukf",
+                        calibration=_split("calibration_v1", SHA_A, role="calibration"),
+                        evaluation=_split("evaluation_v1", SHA_B, role="evaluation"),
+                    ),
+                ],
+            }
+        ]
+    )
+
+    record = gate["candidates"][0]
+    member = record["members"][0]
+    assert record["comparison_allowed"] is False
+    assert "missing_calibration_split_manifest_sha256" in member["blocking_gaps"]
+    assert "missing_calibration_split_evidence" in member["blocking_gaps"]
+    assert "missing_calibration_split_provenance" in member["blocking_gaps"]
+    assert "missing_evaluation_split_manifest_sha256" in member["blocking_gaps"]
+    assert "missing_evaluation_split_evidence" in member["blocking_gaps"]
+    assert "missing_member_provenance" in member["blocking_gaps"]
+    assert "missing_finite_metrics" in member["blocking_gaps"]
+    assert "non_finite_metric" in member["blocking_gaps"]

tokens used
115,639
Implemented and pushed commit `f90b5a9`:

`GLASSBOX [role: phase13-datasets-splits] add ensemble split compatibility gate`

Changed only the owned paths:
- [phase13_split_compatibility.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-glassbox-phase13-15-datasets-split-compatibility-20260509T134830Z/src/bsebench_datasets/phase13_split_compatibility.py)
- [test_phase13_split_compatibility.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-glassbox-phase13-15-datasets-split-compatibility-20260509T134830Z/tests/test_phase13_split_compatibility.py)

The new gate fails closed for missing ensemble members, split IDs, split manifest hashes, split evidence, split provenance, member provenance, provenance hashes, and finite metrics. It blocks ensemble comparison when member calibration or evaluation split signatures differ.

Validation run:
- `uv run pytest tests/test_phase13_split_compatibility.py` passed
- `git diff --check` passed
- `uv run ruff check src/bsebench_datasets/phase13_split_compatibility.py tests/test_phase13_split_compatibility.py` passed
- `uv run ruff format --check ...` passed

Branch pushed to `origin/glassbox-phase13-15-datasets-split-compatibility-20260509T134830Z`.
```
