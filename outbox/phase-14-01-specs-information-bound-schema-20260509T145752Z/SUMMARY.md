# phase-14-01-specs-information-bound-schema-20260509T145752Z direct-worker summary

- Direct pid: `3058985`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-specs`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-specs-glassbox-phase14-01-specs-information-bound-schema-20260509T145752Z`
- Target branch: `glassbox-phase14-01-specs-information-bound-schema-20260509T145752Z`
- Branch SHA: `1a67d01c03e2a6eb9630fd7ec2509afc28e1f875`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T15:11:01.164495Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+def test_noise_evidence_must_cover_all_noise_covariances() -> None:
+    """Process and measurement noise evidence must cover every noise covariance matrix."""
+    payload = _payload()
+    payload["noise_evidence"][0]["covariance_matrix_ids"] = ["q_000"]
+
+    with pytest.raises(ValidationError, match="process noise evidence"):
+        Phase14InformationBound.model_validate(payload)
+
+
+def test_claim_language_and_claim_fields_are_rejected() -> None:
+    """Unsupported scientific claims cannot be smuggled through text or flags."""
+    payload = _payload()
+    payload["summary"] = "SOTA tight bound that proves universal validity."
+
+    with pytest.raises(ValidationError, match="summary"):
+        Phase14InformationBound.model_validate(payload)
+
+    payload = _payload()
+    payload["no_go_claim"]["filter_superiority_claim"] = True
+
+    with pytest.raises(ValidationError):
+        Phase14InformationBound.model_validate(payload)
+
+
+def test_phase14_information_bound_schema_valid_json() -> None:
+    """Checked-in phase14_information_bound.schema.json parses as valid JSON."""
+    assert SCHEMA_PATH.exists()
+    schema = _load_checked_in_schema()
+
+    assert schema["title"] == "Phase14InformationBound"
+    assert schema["$id"] == "https://bsebench.org/schemas/phase14_information_bound.schema.json"
+    assert schema["$schema"] == "https://json-schema.org/draft/2020-12/schema"
+    assert "no_go_claim" in schema["required"]
+    assert "noise_evidence" in schema["required"]
+
+
+def test_generated_schema_exposes_fail_closed_required_fields() -> None:
+    """Generated schema requires the fields that close common evidence gaps."""
+    schema = Phase14InformationBound.model_json_schema()
+
+    required = set(schema["required"])
+    assert {
+        "state_space",
+        "measurement_space",
+        "pcrlb_inputs",
+        "model_uncertainty",
+        "noise_evidence",
+        "pcrlb_outputs",
+        "evidence",
+        "no_go_claim",
+    } <= required
+    assert schema["properties"]["noise_evidence"]["minItems"] == 2
+    assert schema["properties"]["evidence"]["minItems"] == 1
+
+
+def test_checked_in_schema_matches_generated_schema() -> None:
+    """Checked-in schema stays synchronized with the Pydantic contract."""
+    generated = Phase14InformationBound.model_json_schema()
+    generated["$id"] = "https://bsebench.org/schemas/phase14_information_bound.schema.json"
+    generated["$schema"] = "https://json-schema.org/draft/2020-12/schema"
+
+    assert _load_checked_in_schema() == generated

tokens used
129,845
Implemented, committed, and pushed the Phase 14 information-bound contract.

Changed:
- [phase14_information_bound.py](/mnt/c/doctorat/bsebench-org/bsebench-specs-glassbox-phase14-01-specs-information-bound-schema-20260509T145752Z/src/bsebench_specs/phase14_information_bound.py)
- [phase14_information_bound.schema.json](/mnt/c/doctorat/bsebench-org/bsebench-specs-glassbox-phase14-01-specs-information-bound-schema-20260509T145752Z/schemas/phase14_information_bound.schema.json)
- [test_phase14_information_bound.py](/mnt/c/doctorat/bsebench-org/bsebench-specs-glassbox-phase14-01-specs-information-bound-schema-20260509T145752Z/tests/test_phase14_information_bound.py)

Commit pushed:
`1a67d01 GLASSBOX [role: phase14-specs-bound-schema] add information-bound schema`

Validation:
- `uv run --extra dev pytest tests/test_phase14_information_bound.py tests/test_schema_export.py` passed: 26 passed
- `uv run --extra dev ruff check src/bsebench_specs/phase14_information_bound.py tests/test_phase14_information_bound.py` passed
- `git diff --check` and staged `git diff --cached --check` passed
- `uv run --extra dev pytest` passed: 210 passed, 1 skipped. The skipped test was an existing optional JSON Schema availability check.
```
