# phase-15-01-specs-adaptive-filter-schema-20260509T163452Z direct-worker summary

- Direct pid: `3080798`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-specs`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-specs-glassbox-phase15-01-specs-adaptive-filter-schema-20260509T163452Z`
- Target branch: `glassbox-phase15-01-specs-adaptive-filter-schema-20260509T163452Z`
- Branch SHA: `996a9f2d3162e1f6906128c81d8ef819717bf48d`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T16:52:50.588311Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+    """Unsupported performance claims and adaptive-gain wording fail closed."""
+    payload = _payload()
+    payload["summary"] = "SOTA RMSE gain with >20% improvement."
+
+    with pytest.raises(ValidationError, match="summary"):
+        Phase15AdaptiveFilter.model_validate(payload)
+
+    payload = _payload()
+    payload["online_update_rules"][0]["equation_summary"] = "Adaptive gain tuning for EKF."
+
+    with pytest.raises(ValidationError, match="adaptive-gain"):
+        Phase15AdaptiveFilter.model_validate(payload)
+
+    payload = _payload()
+    payload["no_go_claim"]["rmse_gain_claim"] = True
+
+    with pytest.raises(ValidationError):
+        Phase15AdaptiveFilter.model_validate(payload)
+
+
+def test_phase15_adaptive_filter_schema_valid_json() -> None:
+    """Checked-in phase15_adaptive_filter.schema.json parses as valid JSON."""
+    assert SCHEMA_PATH.exists()
+    schema = _load_checked_in_schema()
+
+    assert schema["title"] == "Phase15AdaptiveFilter"
+    assert schema["$id"] == "https://bsebench.org/schemas/phase15_adaptive_filter.schema.json"
+    assert schema["$schema"] == "https://json-schema.org/draft/2020-12/schema"
+    assert "no_go_claim" in schema["required"]
+    assert "online_update_rules" in schema["required"]
+
+
+def test_generated_schema_exposes_fail_closed_required_fields() -> None:
+    """Generated schema requires fields that close common adaptive-filter evidence gaps."""
+    schema = Phase15AdaptiveFilter.model_json_schema()
+
+    required = set(schema["required"])
+    assert {
+        "contract_evidence_id",
+        "splits",
+        "split_separation",
+        "residual_access",
+        "learning_rate_bounds",
+        "online_update_rules",
+        "evidence",
+        "no_go_claim",
+    } <= required
+    assert schema["properties"]["splits"]["minItems"] == 2
+    assert schema["properties"]["online_update_rules"]["minItems"] == 1
+    assert schema["properties"]["learning_rate_bounds"]["minItems"] == 1
+
+
+def test_checked_in_schema_matches_generated_schema() -> None:
+    """Checked-in schema stays synchronized with the Pydantic contract."""
+    generated = Phase15AdaptiveFilter.model_json_schema()
+    generated["$id"] = "https://bsebench.org/schemas/phase15_adaptive_filter.schema.json"
+    generated["$schema"] = "https://json-schema.org/draft/2020-12/schema"
+
+    assert _load_checked_in_schema() == generated

tokens used
107,717
Implemented and pushed Phase 15 adaptive-filter schema contract.

Changed only:
- [phase15_adaptive_filter.py](/mnt/c/doctorat/bsebench-org/bsebench-specs-glassbox-phase15-01-specs-adaptive-filter-schema-20260509T163452Z/src/bsebench_specs/phase15_adaptive_filter.py)
- [phase15_adaptive_filter.schema.json](/mnt/c/doctorat/bsebench-org/bsebench-specs-glassbox-phase15-01-specs-adaptive-filter-schema-20260509T163452Z/schemas/phase15_adaptive_filter.schema.json)
- [test_phase15_adaptive_filter.py](/mnt/c/doctorat/bsebench-org/bsebench-specs-glassbox-phase15-01-specs-adaptive-filter-schema-20260509T163452Z/tests/test_phase15_adaptive_filter.py)

Validation run:
- `uv run --extra dev pytest tests/test_phase15_adaptive_filter.py tests/test_schema_export.py` passed: 25 passed
- `uv run --extra dev ruff check src/bsebench_specs/phase15_adaptive_filter.py tests/test_phase15_adaptive_filter.py` passed
- `git diff --cached --check` passed
- `uv run --extra dev pytest` passed: 223 passed, 1 skipped; the skipped test was the existing optional jsonschema validation check.

Committed and pushed:
`996a9f2 GLASSBOX [role: phase15-specs-adaptive-filter-schema] define adaptive filter preflight contract`

Branch pushed to:
`glassbox-phase15-01-specs-adaptive-filter-schema-20260509T163452Z`
```
