# Phase phase-7-8-c-datasets-hinf-loader-provenance-audit summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 75 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-7-8-c-datasets-hinf-loader-provenance-audit
- Branch SHA : f62a4daa8a9d2f6ad7aa906acf90b261b2ceabb3
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T08:36:00+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+        "field": "source_url",
+        "status": "missing_explicit_runtime_provenance",
+        "disposition": "documented_gap_not_fabricated",
+    } in nasa["provenance_gaps"]
+    assert "strict Hinf loader provenance audit ok" in format_summary(payload)
+
+
+def test_cache_identity_pins_static_and_metadata_driven_files() -> None:
+    assert cache_identity_for_config(
+        StrictHinfConfig("Yao US06 T25", "yao", "US06", 25.0)
+    )["required_files"] == ["Yao-US06-T25.parquet"]
+    assert cache_identity_for_config(
+        StrictHinfConfig("CALCE A123 DST T25", "calce_legacy", "DST", 25.0)
+    )["required_files"] == ["calce_a123_DST_T25.parquet"]
+    nasa_identity = cache_identity_for_config(
+        StrictHinfConfig("NASA B0005 T24", "nasa", "CC-discharge", 24.0)
+    )
+    assert nasa_identity["required_files"] == ["metadata.csv"]
+    assert nasa_identity["derived_files"][0]["selector"] == "nasa_pcoe_loader._select_row_paper2b"
+
+
+def test_audit_fails_when_hinf_filter_disappears(tmp_path: Path) -> None:
+    runner_root = tmp_path / "runner"
+    _write_runner_files(
+        runner_root,
+        filters=("EnsembleMeta", "EKF", "UKFDef", "JUKFV6B", "Other"),
+    )
+
+    with pytest.raises(HinfLoaderProvenanceAuditError, match="filter label 'Hinf' is missing"):
+        run_audit(runner_root=runner_root)
+
+
+def test_audit_fails_when_strict_wrapper_has_no_contract(tmp_path: Path) -> None:
+    runner_root = tmp_path / "runner"
+    configs = (*STRICT_CONFIGS[:-1], ('"Unknown strict"', '"unknown"', '"DST"', "25.0"))
+    _write_runner_files(runner_root, configs=configs)
+
+    with pytest.raises(HinfLoaderProvenanceAuditError, match="has no loader provenance contract"):
+        run_audit(runner_root=runner_root)
+
+
+def test_audit_fails_when_required_runtime_identity_field_disappears(
+    tmp_path: Path,
+) -> None:
+    runner_root = tmp_path / "runner"
+    _write_runner_files(runner_root)
+    contracts = dict(STRICT_HINF_LOADER_CONTRACTS)
+    panasonic = contracts["panasonic"]
+    contracts["panasonic"] = replace(
+        panasonic,
+        required_runtime_identity_fields=(
+            *panasonic.required_runtime_identity_fields,
+            "deterministic_loader_path",
+        ),
+    )
+
+    with pytest.raises(
+        HinfLoaderProvenanceAuditError,
+        match="required runtime identity fields disappeared",
+    ):
+        run_audit(runner_root=runner_root, loader_contracts=contracts)

tokens used
140,494
Implemented and committed `f62a4da` (`test(loaders): audit strict Hinf provenance`).

Added:
- [hinf_loader_provenance.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-8-c-datasets-hinf-loader-provenance-audit/src/bsebench_datasets/hinf_loader_provenance.py): parses runner strict 5x5 configs, maps wrappers to dataset loaders/HF repos/cache identities, and exercises loaders with synthetic local fixtures only.
- [audit_hinf_loader_provenance.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-8-c-datasets-hinf-loader-provenance-audit/scripts/audit_hinf_loader_provenance.py): CLI audit wrapper.
- [test_hinf_loader_provenance_audit.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-8-c-datasets-hinf-loader-provenance-audit/tests/test_hinf_loader_provenance_audit.py): falsification tests for missing Hinf filter, unknown wrapper, and vanished runtime identity fields.

The audit records NASA PCoE missing `dataset`, `chemistry`, and `source_url` as machine-readable gaps, without inventing values.

Validation passed:
- `uv run python scripts/audit_hinf_loader_provenance.py --runner-root /mnt/c/doctorat/bsebench-org/bsebench-runner`
- `uv run pytest tests/test_hinf_loader_provenance_audit.py -q`
- `uv run pytest tests/ -m "not slow" -q` (`227 passed, 29 deselected`)
- `uv run ruff check .`

Working tree is clean and the branch is ahead by 1 commit.
```

## Next step for chef

git fetch origin && git checkout phase-7-8-c-datasets-hinf-loader-provenance-audit in target_repo. Verify gates. Merge to main if green.
