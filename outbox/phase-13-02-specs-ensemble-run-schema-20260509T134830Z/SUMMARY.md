# Phase phase-13-02-specs-ensemble-run-schema-20260509T134830Z direct-worker summary

- Direct pid: `3037491`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-specs`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-specs-glassbox-phase13-02-specs-ensemble-run-schema-20260509T134830Z`
- Target branch: `glassbox-phase13-02-specs-ensemble-run-schema-20260509T134830Z`
- Branch SHA: `d48d9e31297876fac85b89995b9230a66e829a60`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:06:11.762350Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+    payload = _payload()
+    payload["verdict"]["status"] = "accepted"
+    payload["verdict"]["checks"][0]["status"] = "not_run"
+
+    with pytest.raises(ValidationError, match="accepted verdict"):
+        Phase13EnsembleRun.model_validate(payload)
+
+
+def test_verdict_check_hash_must_match_verdict_report():
+    """Verdict checks must be backed by the verdict report artifact."""
+    payload = _payload()
+    payload["verdict"]["checks"][0]["evidence_sha256"] = METRICS_SHA
+
+    with pytest.raises(ValidationError, match="verdict_report evidence"):
+        Phase13EnsembleRun.model_validate(payload)
+
+
+def test_unknown_claim_like_fields_are_rejected():
+    """Unsupported extra fields are not silently retained."""
+    payload = _payload()
+    payload["leaderboard_rank"] = 1
+
+    with pytest.raises(ValidationError) as exc_info:
+        Phase13EnsembleRun.model_validate(payload)
+
+    assert "extra" in str(exc_info.value).lower()
+
+
+def test_checked_in_phase13_ensemble_schema_valid_json():
+    """Checked-in phase13_ensemble_run.schema.json parses as valid JSON."""
+    schema = json.loads(SCHEMA_PATH.read_text())
+
+    assert schema["title"] == "Phase13EnsembleRun"
+    assert schema["$id"] == "https://bsebench.org/schemas/phase13_ensemble_run.schema.json"
+    assert schema["$schema"] == "https://json-schema.org/draft/2020-12/schema"
+    assert {
+        "split",
+        "members",
+        "uncertainty",
+        "metric_keys",
+        "metrics",
+        "compute",
+        "verdict",
+        "provenance",
+    } <= set(schema["required"])
+
+
+def test_jsonschema_validation_if_available():
+    """The checked-in JSON Schema validates required fields when jsonschema is installed."""
+    jsonschema = pytest.importorskip("jsonschema")
+    schema = json.loads(SCHEMA_PATH.read_text())
+    validator = jsonschema.Draft202012Validator(schema)
+
+    validator.validate(_payload())
+
+    invalid = _payload()
+    invalid.pop("provenance")
+    errors = list(validator.iter_errors(invalid))
+
+    assert any("provenance" in [str(part) for part in error.path] for error in errors) or errors

tokens used
112,139
Implemented and pushed commit `d48d9e3` to `origin/glassbox-phase13-02-specs-ensemble-run-schema-20260509T134830Z`.

Added the Phase 13 fail-closed ensemble run contract in:
- `schemas/phase13_ensemble_run.schema.json`
- `src/bsebench_specs/phase13_ensemble_run.py`
- `tests/test_phase13_ensemble_run_schema.py`
- minimal package export in `src/bsebench_specs/__init__.py`

Validation run:
- `uv run --extra dev pytest tests/test_phase13_ensemble_run_schema.py`: passed, with the optional in-env `jsonschema` test skipped
- `uv run --extra dev --with jsonschema python ...`: JSON Schema validation passed
- `uv run --extra dev ruff check ...`: passed
- `uv run python -m json.tool schemas/phase13_ensemble_run.schema.json`: passed
- `git diff --check`: passed
- `uv run --extra dev pytest`: `183 passed, 1 skipped`

The one skipped test is the optional project-env `jsonschema` import check; I validated the schema explicitly with `jsonschema` via `uv --with jsonschema`.
```
