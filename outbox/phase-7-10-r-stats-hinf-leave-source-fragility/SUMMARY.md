# Phase phase-7-10-r-stats-hinf-leave-source-fragility summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 90 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-stats
- Target branch : phase-7-10-r-stats-hinf-leave-source-fragility
- Branch SHA : 22de97ba67adb2373a4d36d77c3365a1ca9be73c
- Push result : ok
- Merge readiness : ok
- Merge readiness detail : origin/main is an ancestor of HEAD
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-08T16:00:58+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+    json.dumps(report, allow_nan=False)
+
+
+@pytest.mark.fast
+def test_hinf_leave_source_fragility_missing_source_identity_is_evidence_gap() -> None:
+    trace = _trace_payload(
+        [
+            ("cfg_a", "dataset_a", "profile_a", {"EKF": 1.0, "Hinf": 2.0, "UKFDef": 3.0}),
+            ("cfg_b", None, "profile_b", {"EKF": 1.0, "Hinf": 2.0, "UKFDef": 3.0}),
+            ("cfg_c", "dataset_b", "profile_a", {"EKF": 1.0, "Hinf": 2.0, "UKFDef": 3.0}),
+        ]
+    )
+    report = build_hinf_leave_source_fragility(
+        _evidence_payload(trace),
+        share_delta_threshold=1.0,
+        effect_delta_threshold=1.0,
+        correlation_delta_threshold=1.0,
+        variance_relative_delta_threshold=1.0,
+    )
+
+    assert report["fragility_status"] == "fragile"
+    dataset_runs = report["perturbations"]["leave_one_dataset"]["runs"]
+    gap_run = next(
+        run for run in dataset_runs if run["fragility_status"] == "insufficient_evidence"
+    )
+    assert gap_run["evidence_gaps"][0]["id"] == "missing_dataset_source_identity"
+    assert report["falsification_gate"]["evidence_gap_count"] >= 1
+    assert report["falsification_gate"]["block_downstream_claim_registration"] is True
+
+
+@pytest.mark.fast
+def test_hinf_leave_source_fragility_runner_writes_json_and_markdown(tmp_path: Path) -> None:
+    evidence_path = tmp_path / "hinf_residual_evidence_5x5.json"
+    output_path = tmp_path / "hinf_leave_source_fragility.json"
+    markdown_path = tmp_path / "hinf_leave_source_fragility.md"
+    evidence_path.write_text(
+        json.dumps(_stable_evidence_payload(), allow_nan=False),
+        encoding="utf-8",
+    )
+
+    report = run_hinf_leave_source_fragility(
+        evidence_path,
+        output_path,
+        markdown_output_path=markdown_path,
+        share_delta_threshold=1.0,
+        effect_delta_threshold=1.0,
+        correlation_delta_threshold=1.0,
+        variance_relative_delta_threshold=1.0,
+    )
+
+    loaded = json.loads(output_path.read_text(encoding="utf-8"))
+    assert loaded == report
+    assert loaded["input_artifacts"]["evidence"]["file_sha256"]
+    assert markdown_path.read_text(encoding="utf-8").startswith(
+        "# Hinf leave-source fragility report"
+    )
+    text = json.dumps(loaded, sort_keys=True).lower()
+    for forbidden in ("verified", "novel", "sota", "thesis"):
+        assert forbidden not in text

tokens used
258,623
Implemented and committed `22de97b` on `phase-7-10-r-stats-hinf-leave-source-fragility`.

Added:
- [Hinf leave-source fragility runner](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-10-r-stats-hinf-leave-source-fragility/src/bsebench_stats/runners/hinf_leave_source_fragility.py:1)
- [CLI command](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-10-r-stats-hinf-leave-source-fragility/scripts/hinf_leave_source_fragility.py:1)
- [Focused tests](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-10-r-stats-hinf-leave-source-fragility/tests/test_hinf_leave_source_fragility.py:1)

The real frozen run against `../bsebench-runner/outputs/hinf_residual_evidence_5x5.json` completed read-only and marked the evidence `fragile`: embedded replay `ok`, no source identity gaps, all leave-one dataset/profile/config axes fragile, downstream claim registration blocked. Outputs were written to `/tmp/hinf_leave_source_fragility_5x5.json` and `/tmp/hinf_leave_source_fragility_5x5.md`.

Validation run:
- `pytest tests/test_hinf_leave_source_fragility.py -q`: 4 passed
- real fragility CLI run: passed, `fragility_status=fragile`
- `pytest tests/ -q`: 272 passed
- `ruff check .`: passed
- `ruff format --check .`: passed
- `git diff --check`: passed

No thesis, registry, `claim_55`, or protected roadmap files were edited. Branch is clean and ahead of `origin/main` by 1 commit.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-r-stats-hinf-leave-source-fragility in target_repo. Verify gates. Merge to main if green.
