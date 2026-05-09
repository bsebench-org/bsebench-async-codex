# Phase phase-13-01-specs-method-card-schema-20260509T134830Z direct-worker summary

- Direct pid: `3037212`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-specs`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-specs-glassbox-phase13-01-specs-method-card-schema-20260509T134830Z`
- Target branch: `glassbox-phase13-01-specs-method-card-schema-20260509T134830Z`
- Branch SHA: `53ca307db81cd5ad17a6b6c63bc515c90488371b`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:06:10.385550Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+
+    with pytest.raises(ValidationError):
+        Phase13EnsembleMethodCard.model_validate(payload)
+
+
+def test_phase12_authorized_gate_requires_gate_evidence() -> None:
+    """Opening a Phase 12 blocker requires explicit gate-report evidence."""
+    payload = valid_method_card_payload()
+    payload["phase12_gates"]["estimator_execution"] = "authorized_by_gate"
+
+    with pytest.raises(ValidationError, match="gate_evidence_id"):
+        Phase13EnsembleMethodCard.model_validate(payload)
+
+    payload["phase12_gates"]["gate_evidence_id"] = "gate_report"
+    payload["evidence"].append(_evidence("gate_report", "gate_report", "9"))
+    card = Phase13EnsembleMethodCard.model_validate(payload)
+
+    assert card.phase12_gates.estimator_execution == "authorized_by_gate"
+
+
+def test_phase13_ensemble_method_card_schema_valid_json() -> None:
+    """Checked-in phase13_ensemble_method_card.schema.json parses as valid JSON."""
+    assert SCHEMA_PATH.exists()
+    schema = _load_checked_in_schema()
+
+    assert schema["title"] == "Phase13EnsembleMethodCard"
+    assert schema["$id"] == "https://bsebench.org/schemas/phase13_ensemble_method_card.schema.json"
+    assert schema["$schema"] == "https://json-schema.org/draft/2020-12/schema"
+    assert "no_claim_status" in schema["required"]
+    assert "finite_metric_checks" in schema["required"]
+
+
+def test_generated_schema_exposes_fail_closed_required_fields() -> None:
+    """Generated schema requires the contract fields that close common evidence gaps."""
+    schema = Phase13EnsembleMethodCard.model_json_schema()
+
+    required = set(schema["required"])
+    assert {
+        "method",
+        "member_families",
+        "members",
+        "aggregation",
+        "splits",
+        "evidence",
+        "finite_metric_checks",
+        "phase12_gates",
+        "no_claim_status",
+    } <= required
+    assert schema["properties"]["members"]["minItems"] == 2
+    assert schema["properties"]["finite_metric_checks"]["minItems"] == 1
+
+
+def test_checked_in_schema_matches_generated_schema() -> None:
+    """Checked-in schema stays synchronized with the Pydantic contract."""
+    generated = Phase13EnsembleMethodCard.model_json_schema()
+    generated["$id"] = "https://bsebench.org/schemas/phase13_ensemble_method_card.schema.json"
+    generated["$schema"] = "https://json-schema.org/draft/2020-12/schema"
+
+    assert _load_checked_in_schema() == generated

tokens used
167,082
Implemented and pushed `glassbox-phase13-01-specs-method-card-schema-20260509T134830Z`.

Changes:
- Added [phase13_ensemble_method_card.py](/mnt/c/doctorat/bsebench-org/bsebench-specs-glassbox-phase13-01-specs-method-card-schema-20260509T134830Z/src/bsebench_specs/phase13_ensemble_method_card.py) with fail-closed Pydantic contract.
- Added checked-in JSON Schema at [phase13_ensemble_method_card.schema.json](/mnt/c/doctorat/bsebench-org/bsebench-specs-glassbox-phase13-01-specs-method-card-schema-20260509T134830Z/schemas/phase13_ensemble_method_card.schema.json).
- Added focused tests at [test_phase13_ensemble_method_card.py](/mnt/c/doctorat/bsebench-org/bsebench-specs-glassbox-phase13-01-specs-method-card-schema-20260509T134830Z/tests/test_phase13_ensemble_method_card.py).

Validation run:
- `uv run --extra dev pytest tests/test_phase13_ensemble_method_card.py` passed, 13 tests.
- `uv run --extra dev pytest tests/test_schema_export.py` passed.
- `uv run --extra dev ruff check src/bsebench_specs/phase13_ensemble_method_card.py tests/test_phase13_ensemble_method_card.py` passed.
- `uv run python -m json.tool schemas/phase13_ensemble_method_card.schema.json >/dev/null` passed.
- `git diff --check` and `git diff --cached --check` passed.

Skipped: full repository pytest suite was not run; I ran the focused suite plus the local schema/export checks.

Commit pushed:
`53ca307 GLASSBOX [role: phase13-specs-method-card] add ensemble method-card schema`
```
