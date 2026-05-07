# Phase phase-7-9-b-runner-hinf-determinism-audit summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 120 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-runner
- Target branch : phase-7-9-b-runner-hinf-determinism-audit
- Branch SHA : 0d1fed2644a41205294f8de18ccc0a16a843dfab
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T10:54:18+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+
+    assert summary["status"] == "ok"
+    assert summary["outputs"]["evidence"]["ok_filter_runs"] == 25
+    assert summary["artifact_hashes"]["evidence"]
+
+
+@pytest.mark.fast
+def test_fresh_run_drift_preserves_diagnostics(audit_module, tmp_path: Path, monkeypatch) -> None:
+    def fake_preflight(**kwargs: Any) -> dict[str, Any]:
+        payload = _json(PREFLIGHT_PATH)
+        Path(kwargs["output_path"]).write_text(
+            json.dumps(payload, indent=2, sort_keys=True, allow_nan=False) + "\n",
+            encoding="utf-8",
+        )
+        return payload
+
+    def fake_chi2(**kwargs: Any) -> dict[str, Any]:
+        payload = _json(CHI2_PATH)
+        Path(kwargs["output_path"]).write_text(
+            json.dumps(payload, indent=2, sort_keys=True, allow_nan=False) + "\n",
+            encoding="utf-8",
+        )
+        return payload
+
+    def fake_evidence(**kwargs: Any) -> dict[str, Any]:
+        payload = _json(EVIDENCE_PATH)
+        payload["residual_variance_decomposition"]["decomposition"]["config_share"] += 1.0e-3
+        Path(kwargs["output_path"]).write_text(
+            json.dumps(payload, indent=2, sort_keys=True, allow_nan=False) + "\n",
+            encoding="utf-8",
+        )
+        return payload
+
+    monkeypatch.setattr(audit_module, "run_cache_preflight", fake_preflight)
+    monkeypatch.setattr(audit_module, "run_sweep", fake_chi2)
+    monkeypatch.setattr(audit_module, "run_hinf_residual_evidence_5x5", fake_evidence)
+
+    with pytest.raises(
+        audit_module.HinfResidualDeterminismAuditError,
+        match="fresh diagnostics preserved",
+    ):
+        audit_module.run_fresh_strict_comparison(
+            mode="always",
+            diagnostics_dir=tmp_path,
+            manifest_path=MANIFEST_PATH,
+            committed_preflight_path=PREFLIGHT_PATH,
+            committed_chi2_path=CHI2_PATH,
+            committed_evidence_path=EVIDENCE_PATH,
+        )
+
+    assert (tmp_path / "hinf_residual_evidence_5x5.json").is_file()
+    assert (tmp_path / "hinf_residual_determinism_drift.json").is_file()

tokens used
155,377
Implemented and committed the strict Hinf determinism audit on `phase-7-9-b-runner-hinf-determinism-audit`.

Commit: `0d1fed2 GLASSBOX [role: codex-repro-engineer] Add strict Hinf determinism audit`

Added:
- [scripts/audit_hinf_residual_determinism.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-7-9-b-runner-hinf-determinism-audit/scripts/audit_hinf_residual_determinism.py:1)
- [tests/test_audit_hinf_residual_determinism.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-7-9-b-runner-hinf-determinism-audit/tests/test_audit_hinf_residual_determinism.py:1)

What it does:
- Audits committed strict output and manifest contracts.
- Recomputes covariance/decomposition from committed trace residuals at explicit `1e-12` tolerances.
- Compares key Hinf correlations and decomposition shares.
- Supports optional fresh strict recomputation into a temp diagnostics directory without touching committed `outputs/`.
- Fails non-zero on drift and preserves fresh diagnostics outside committed artifacts.

Validation passed:
- `uv run --locked --all-extras python scripts/audit_hinf_residual_determinism.py --fresh-run never`
- `uv run --locked --all-extras python scripts/audit_hinf_residual_determinism.py --fresh-run auto`
  - fresh run ok, diagnostics: `/tmp/bsebench_hinf_determinism_fkravwzx`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`
  - `119 passed, 5 deselected`
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`

No committed evidence, thesis, claim registry, roadmap, or SOTA-related files were edited.
```

## Next step for chef

git fetch origin && git checkout phase-7-9-b-runner-hinf-determinism-audit in target_repo. Verify gates. Merge to main if green.
