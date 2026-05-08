# Phase phase-7-10-al-datasets-phase11-unit-cadence-contract summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 90 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-7-10-al-datasets-phase11-unit-cadence-contract
- Branch SHA : d62c02367a847c9eb9cb8442e713dbbce6cfdde1
- Push result : ok
- Merge readiness : ok
- Merge readiness detail : origin/main is an ancestor of HEAD
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-08T15:26:17+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+    payload = build_unit_cadence_contract(
+        manifests_dir=manifests_dir,
+        include_loader_configs=False,
+        include_metadata_datasets=True,
+        datasets_roots=(),
+        env={},
+    )
+
+    assert payload["configs"] == []
+    row = payload["metadata_datasets"][0]
+    assert row["readiness_status"] == READINESS_NOT_APPLICABLE
+    assert row["fields"]["voltage_unit"]["metadata_status"] == FIELD_NOT_APPLICABLE
+    assert row["fields"]["current_unit"]["metadata_status"] == FIELD_NOT_APPLICABLE
+    assert row["fields"]["timebase"]["metadata_status"] == FIELD_NOT_APPLICABLE
+    assert row["fields"]["sampling_cadence"]["metadata_status"] == FIELD_EXPLICIT_METADATA
+    assert row["fields"]["sampling_cadence"]["value"]["sampling_rate_hz"] == 2.0
+
+
+def test_filename_unit_and_cadence_tokens_are_rejected_not_promoted(
+    tmp_path: Path,
+) -> None:
+    manifests_dir = tmp_path / "manifests"
+    _write_manifest(manifests_dir, sampling_rate_hz=None)
+    filename = "cell_voltage_V_current_A_time_s_1Hz.parquet"
+    target = _target(
+        filename=filename,
+        file_plan_source="undocumented filename fixture",
+    )
+    cache_root = tmp_path / "cache"
+    cache_root.mkdir()
+    _write_trace(cache_root / filename, canonical_columns=False)
+
+    payload = _contract(tmp_path, target=target)
+
+    config = payload["configs"][0]  # type: ignore[index]
+    fields = config["fields"]
+    assert config["readiness_status"] == READINESS_INSUFFICIENT_METADATA
+    assert config["ready_for_phase11_residual_decomposition"] is False
+    assert fields["voltage_unit"]["metadata_status"] == FIELD_UNSAFE_FILENAME_GUESS  # type: ignore[index]
+    assert fields["current_unit"]["metadata_status"] == FIELD_UNSAFE_FILENAME_GUESS  # type: ignore[index]
+    assert fields["timebase"]["metadata_status"] == FIELD_UNSAFE_FILENAME_GUESS  # type: ignore[index]
+    assert fields["sampling_cadence"]["metadata_status"] == FIELD_UNSAFE_FILENAME_GUESS  # type: ignore[index]
+    assert payload["anti_inference_policy"]["filenames_used_for_metadata"] is False
+    assert payload["summary"]["unsafe_filename_guess_rejections"] == 4
+    assert set(config["known_missing_fields"]) == {
+        "voltage_unit",
+        "current_unit",
+        "timebase",
+        "sampling_cadence",
+    }

tokens used
212,422
Implemented and committed Phase 11 unit/cadence contract.

Commit: `d62c02367a847c9eb9cb8442e713dbbce6cfdde1`

Changed:
- Added [unit_cadence_contract.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-10-al-datasets-phase11-unit-cadence-contract/src/bsebench_datasets/unit_cadence_contract.py)
- Added [phase11_unit_cadence_contract.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-10-al-datasets-phase11-unit-cadence-contract/scripts/phase11_unit_cadence_contract.py)
- Added focused tests in [test_unit_cadence_contract.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-10-al-datasets-phase11-unit-cadence-contract/tests/test_unit_cadence_contract.py)

Behavior covered:
- Explicit Parquet unit/cadence metadata
- Loader-derived canonical Tier 2 schema/timebase metadata
- Missing unit metadata
- Missing cadence metadata
- Metadata-only/not-applicable rows
- Unsafe filename-derived guess rejection

Validation passed:
- `uv run --locked --all-extras pytest tests/test_unit_cadence_contract.py -q`
- `uv run --locked --all-extras python scripts/phase11_unit_cadence_contract.py --output /tmp/bsebench_phase11_unit_cadence_contract.json --allow-gaps`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q` (`323 passed, 29 deselected`)
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`
- `git diff --check`
- `git diff --cached --check`

No protected thesis/claim/roadmap files were touched. The worktree is clean and the target branch is ahead by one commit.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-al-datasets-phase11-unit-cadence-contract in target_repo. Verify gates. Merge to main if green.
