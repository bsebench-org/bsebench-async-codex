# phase-14-08-datasets-noise-evidence-20260509T145752Z direct-worker summary

- Direct pid: `3059751`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-datasets`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-datasets-glassbox-phase14-08-datasets-noise-evidence-20260509T145752Z`
- Target branch: `glassbox-phase14-08-datasets-noise-evidence-20260509T145752Z`
- Branch SHA: `f09d4f8cc7145a5bcd0f331269578cad632be529`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T15:10:32.863482Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+
+    model_gaps = gate["bundles"][0]["noise_models"][0]["blocking_gaps"]
+    assert gate["status"] == "blocked"
+    assert "units_dimension_mismatch" in model_gaps
+    assert "non_finite_variance" in model_gaps
+    assert "variance_dimension_mismatch" in model_gaps
+    assert "non_finite_covariance_matrix" in model_gaps
+    assert "covariance_dimension_mismatch" in model_gaps
+    json.dumps(gate, allow_nan=False)
+
+
+def test_gate_fails_closed_on_invalid_covariance_or_information_matrix(
+    tmp_path: Path,
+) -> None:
+    measurement = _noise_model(
+        tmp_path,
+        role="measurement",
+        noise_id="measurement_voltage",
+        covariance=[[1.0, 2.0], [2.0, 1.0]],
+        information_matrix=[[1.0, 0.0], [0.0, 0.0]],
+    )
+    process = _noise_model(tmp_path, role="process", noise_id="process_soc_soh")
+
+    gate = build_phase14_noise_evidence_gate(
+        manifest_id="phase14_noise_fixture",
+        generated_at="2026-05-09T14:57:52Z",
+        bundles=[_bundle(tmp_path, noise_models=[measurement, process])],
+    )
+
+    model_gaps = gate["bundles"][0]["noise_models"][0]["blocking_gaps"]
+    assert gate["status"] == "blocked"
+    assert "invalid_covariance_matrix" in model_gaps
+    assert "invalid_information_matrix" in model_gaps
+    assert "variance_covariance_diagonal_mismatch" in model_gaps
+
+
+def test_gate_fails_closed_on_missing_hash_or_empirical_claim(tmp_path: Path) -> None:
+    measurement = _noise_model(
+        tmp_path,
+        role="measurement",
+        noise_id="measurement_voltage",
+        source=NoiseEvidenceSource(uri="artifact://unit/measurement-noise.json"),
+    )
+    process = _noise_model(tmp_path, role="process", noise_id="process_soc_soh")
+
+    gate = build_phase14_noise_evidence_gate(
+        manifest_id="phase14_noise_fixture",
+        generated_at="2026-05-09T14:57:52Z",
+        bundles=[
+            _bundle(
+                tmp_path,
+                noise_models=[measurement, process],
+                empirical_claim="EKF is better on SOC/SOH for this split",
+            )
+        ],
+    )
+
+    assert gate["status"] == "blocked"
+    assert gate["decision"]["empirical_claim_allowed"] is False
+    bundle_gaps = gate["bundles"][0]["blocking_gaps"]
+    assert "unsupported_empirical_claim" in bundle_gaps
+    assert "noise_models.measurement_voltage.missing_source_hash" in bundle_gaps

tokens used
96,339
Implemented and pushed the Phase 14 noise-evidence gate.

Changed:
- [phase14_noise_evidence.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-glassbox-phase14-08-datasets-noise-evidence-20260509T145752Z/src/bsebench_datasets/phase14_noise_evidence.py)
- [test_phase14_noise_evidence.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-glassbox-phase14-08-datasets-noise-evidence-20260509T145752Z/tests/test_phase14_noise_evidence.py)

Validation:
- `uv run --extra dev pytest tests/test_phase14_noise_evidence.py` passed, 6 tests.
- `git diff --check` passed.
- `uv run --extra dev ruff check src tests` passed.
- No validation skipped.

Commit pushed:
- `f09d4f8 GLASSBOX [role: phase14-datasets-noise-evidence] add fail-closed noise evidence gate`
- Branch: `glassbox-phase14-08-datasets-noise-evidence-20260509T145752Z`
```
