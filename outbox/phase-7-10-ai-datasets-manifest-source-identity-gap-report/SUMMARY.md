# Phase phase-7-10-ai-datasets-manifest-source-identity-gap-report summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 90 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-7-10-ai-datasets-manifest-source-identity-gap-report
- Branch SHA : 0c4fbe6b45b4b8f58aed165bd9bffcab2359a139
- Push result : ok
- Merge readiness : ok
- Merge readiness detail : origin/main is an ancestor of HEAD
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-08T10:17:53+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+    assert record["source_identity_status"] == STATUS_MISSING_SOURCE_IDENTITY
+    assert record["fields"]["source_locator"]["status"] == STATUS_MISSING_SOURCE_IDENTITY
+    assert record["missing_fields"] == ["source_locator"]
+
+
+def test_manifest_source_identity_unknown_metadata_for_unreadable_yaml(tmp_path: Path) -> None:
+    manifests_dir = tmp_path / "manifests"
+    manifests_dir.mkdir()
+    (manifests_dir / "broken.yaml").write_text("name: [unterminated\n", encoding="utf-8")
+
+    report = build_manifest_source_identity_report(manifests_dir, repo_root=tmp_path)
+
+    record = report["manifests"][0]
+    assert record["manifest_id"] == "broken"
+    assert record["source_identity_status"] == STATUS_UNKNOWN_METADATA
+    assert record["unknown_fields"] == ["manifest_yaml"]
+    assert report["summary"]["status_counts"][STATUS_UNKNOWN_METADATA] == 1
+
+
+def test_manifest_source_identity_not_applicable_without_candidate_scope(tmp_path: Path) -> None:
+    manifests_dir = tmp_path / "manifests"
+    manifests_dir.mkdir()
+    _write_manifest(
+        manifests_dir,
+        "metadata_only",
+        _manifest(
+            "metadata_only",
+            source={
+                "canonical_url": "https://example.org/metadata-only",
+                "canonical_doi": None,
+                "access_friction": "open",
+                "publication_title": "Metadata only source identity dataset",
+                "publication_authors": ["Doe, J."],
+                "publication_venue": "Example Archive",
+                "publication_year": 2024,
+            },
+            tier1="bsebench-org/metadata-only-raw",
+            tier2="bsebench-org/metadata-only",
+        ),
+    )
+
+    report = build_manifest_source_identity_report(
+        manifests_dir,
+        repo_root=tmp_path,
+        candidate_phases=(),
+    )
+
+    record = _records_by_id(report)["metadata_only"]
+    assert record["source_identity_status"] == STATUS_READY
+    assert record["fields"]["canonical_doi"]["status"] == STATUS_NOT_APPLICABLE
+    assert record["fields"]["variant_or_profile"]["status"] == STATUS_NOT_APPLICABLE
+    assert record["fields"]["split_or_protocol"]["status"] == STATUS_NOT_APPLICABLE
+    assert set(record["not_applicable_fields"]) == {
+        "variant_or_profile",
+        "split_or_protocol",
+        "canonical_doi",
+    }

tokens used
343,523
Implemented and committed.

Commit: `0c4fbe6b45b4b8f58aed165bd9bffcab2359a139`  
`GLASSBOX [role: datasets-provenance] add manifest source identity gap report`

Changes:
- Added read-only source identity report builder: [manifest_source_identity.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-10-ai-datasets-manifest-source-identity-gap-report/src/bsebench_datasets/manifest_source_identity.py)
- Added CLI command: [audit_manifest_source_identity.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-10-ai-datasets-manifest-source-identity-gap-report/scripts/audit_manifest_source_identity.py)
- Added focused coverage for `ready`, `partial`, `missing_source_identity`, `unknown_metadata`, and `not_applicable`: [test_manifest_source_identity.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-10-ai-datasets-manifest-source-identity-gap-report/tests/test_manifest_source_identity.py)

Validation passed:
- `uv run --locked --all-extras pytest tests/test_manifest_source_identity.py -q`
- `uv run --locked --all-extras python scripts/audit_manifest_source_identity.py --allow-gaps --output /tmp/bsebench_manifest_source_identity_gap_report.json`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q` → `315 passed, 29 deselected`
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`
- `git diff --check`
- `git diff --cached --check`

The repo manifest run reported `13` manifests, all `partial`, with no `ready` records while Phase 8/11 candidate profile/split fields remain absent. No protected claim, roadmap, thesis, or `claim_55` files were touched.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-ai-datasets-manifest-source-identity-gap-report in target_repo. Verify gates. Merge to main if green.
