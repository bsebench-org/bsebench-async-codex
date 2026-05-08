# Phase phase-7-10-s-datasets-phase8-11-provenance-hash-ledger summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 90 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-7-10-s-datasets-phase8-11-provenance-hash-ledger
- Branch SHA : f74d3267e7aadc47f6b2f8c22608decd325a0d05
- Push result : ok
- Merge readiness : ok
- Merge readiness detail : origin/main is an ancestor of HEAD
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-08T16:06:18+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+        include_metadata_datasets=False,
+        manifests_dir=manifests_dir,
+    )
+
+    config = _config_by_label(payload)["phase8_lg_hg2_manifest_grid:lg_P065_rep2_S03"]
+    assert config["loader_readiness"]["ready"] is True  # type: ignore[index]
+    assert config["manifest_identifier"]["value"] == {  # type: ignore[index]
+        "name": "lg_hg2_stroebl_2024",
+        "path": "manifests/lg_hg2_stroebl_2024.yaml",
+    }
+    assert config["source_identity"]["status"] == "ready"  # type: ignore[index]
+    assert config["source_identity"]["value"]["canonical_doi"] == "10.35097/1947"  # type: ignore[index]
+    assert config["license_provenance"]["status"] == "ready"  # type: ignore[index]
+    assert config["required_source_file_hash_status"]["status"] == "ready"  # type: ignore[index]
+    assert (
+        config["required_source_file_hash_status"]["files"][0]["path"]  # type: ignore[index]
+        == "cell_logext_P065_2_S03_C02_truncated.csv"
+    )
+    assert (
+        config["required_source_file_hash_status"]["files"][0]["hash_status"]  # type: ignore[index]
+        == "declared"
+    )
+    assert config["required_cache_file_hash_status"]["status"] == "ready"  # type: ignore[index]
+    assert (
+        config["required_cache_file_hash_status"]["files"][0]["sha256"]  # type: ignore[index]
+        == hashlib.sha256(parquet_path.read_bytes()).hexdigest()
+    )
+    assert config["claim_support_status"] == CLAIM_SUPPORT_NOT_READY
+    assert "retrieval_or_source_date" in config["missing_fields"]  # type: ignore[operator]
+    json.dumps(payload, allow_nan=False)
+
+
+def test_ledger_omits_machine_local_paths_and_redacts_secret_fragments(
+    tmp_path: Path,
+) -> None:
+    split_path = _write_split(tmp_path / "split.yaml", [("calce_legacy", "DST", 25.0)])
+    manifests_dir = tmp_path / "manifests"
+    manifests_dir.mkdir()
+    secret_root = tmp_path / "token=supersecret"
+    secret_root.mkdir()
+    _write_loader_parquet(secret_root / "calce_a123_DST_T25.parquet")
+
+    payload = build_phase8_11_provenance_hash_ledger(
+        split_path,
+        cache_root_overrides={"calce_legacy": secret_root},
+        datasets_roots=(),
+        env={},
+        include_strict_hinf=False,
+        include_metadata_datasets=False,
+        manifests_dir=manifests_dir,
+    )
+
+    dumped = json.dumps(payload, allow_nan=False)
+    summary = format_phase8_11_provenance_hash_ledger_summary(payload)
+    assert "supersecret" not in dumped
+    assert "supersecret" not in summary
+    assert str(tmp_path) not in dumped
+    assert str(tmp_path) not in summary
+    assert payload["path_sanitization"]["local_absolute_paths_included"] is False  # type: ignore[index]

tokens used
227,932
Implemented and committed `f74d326` (`GLASSBOX: add Phase 8/11 provenance hash ledger`).

Added:
- Sanitized Phase 8/11 provenance/hash ledger builder in `auditj_local_cache_manifest.py`.
- Read-only CLI: `scripts/phase8_11_provenance_hash_ledger.py`.
- Targeted tests: `tests/test_phase8_11_provenance_hash_ledger.py`.

The real ledger command ran against `../_datasets` and `../bsebench-runner`; it reported `evidence_ready=False`, `58` configs, `0` loader-ready, `0` claim-ready, and explicit `not_ready_for_claim_support` gaps. Generated JSON/Markdown artifacts were checked for local path/secret leakage and removed.

Validation passed:
- `uv run --locked --all-extras pytest tests/test_phase8_11_provenance_hash_ledger.py -q`
- real ledger CLI command with `--allow-gaps`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`
- `git diff --check`

Worktree is clean; branch is ahead by 1 commit.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-s-datasets-phase8-11-provenance-hash-ledger in target_repo. Verify gates. Merge to main if green.
