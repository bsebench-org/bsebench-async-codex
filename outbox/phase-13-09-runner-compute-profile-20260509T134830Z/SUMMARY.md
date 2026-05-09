# Phase phase-13-09-runner-compute-profile-20260509T134830Z direct-worker summary

- Direct pid: `3039572`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-runner`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase13-09-runner-compute-profile-20260509T134830Z`
- Target branch: `glassbox-phase13-09-runner-compute-profile-20260509T134830Z`
- Branch SHA: `86d2b92adb539fccf46d82a9b1719339ef4f864e`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:06:16.374970Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+
+@pytest.mark.fast
+def test_missing_or_mismatched_splits_fail_closed() -> None:
+    kwargs = _manifest_kwargs()
+    kwargs["splits"] = []
+    with pytest.raises(Phase13ComputeProfileError, match="splits must be a non-empty list"):
+        build_phase13_compute_profile_manifest(**kwargs)
+
+    kwargs = _manifest_kwargs()
+    members = copy.deepcopy(kwargs["member_profiles"])
+    members[0]["split_id"] = "undeclared-split"  # type: ignore[index]
+    kwargs["member_profiles"] = members
+    with pytest.raises(Phase13ComputeProfileError, match="split_id is not declared in splits"):
+        build_phase13_compute_profile_manifest(**kwargs)
+
+
+@pytest.mark.fast
+def test_missing_nonfinite_or_inconsistent_member_metrics_fail_closed() -> None:
+    kwargs = _manifest_kwargs()
+    members = copy.deepcopy(kwargs["member_profiles"])
+    del members[0]["runtime_ns"]  # type: ignore[index]
+    kwargs["member_profiles"] = members
+    with pytest.raises(Phase13ComputeProfileError, match="missing required fields: runtime_ns"):
+        build_phase13_compute_profile_manifest(**kwargs)
+
+    kwargs = _manifest_kwargs()
+    members = copy.deepcopy(kwargs["member_profiles"])
+    members[0]["runtime_ns"] = math.nan  # type: ignore[index]
+    kwargs["member_profiles"] = members
+    with pytest.raises(Phase13ComputeProfileError, match=r"runtime_ns must be finite"):
+        build_phase13_compute_profile_manifest(**kwargs)
+
+    kwargs = _manifest_kwargs()
+    members = copy.deepcopy(kwargs["member_profiles"])
+    members[0]["iteration_count"] = -1  # type: ignore[index]
+    kwargs["member_profiles"] = members
+    with pytest.raises(Phase13ComputeProfileError, match="iteration_count"):
+        build_phase13_compute_profile_manifest(**kwargs)
+
+    kwargs = _manifest_kwargs()
+    members = copy.deepcopy(kwargs["member_profiles"])
+    members[0]["memory_current_bytes"] = 31  # type: ignore[index]
+    members[0]["memory_peak_bytes"] = 30  # type: ignore[index]
+    kwargs["member_profiles"] = members
+    with pytest.raises(Phase13ComputeProfileError, match="memory_peak_bytes must be >="):
+        build_phase13_compute_profile_manifest(**kwargs)
+
+
+@pytest.mark.fast
+def test_validate_manifest_rejects_tampered_summary_or_id() -> None:
+    manifest = build_phase13_compute_profile_manifest(**_manifest_kwargs())
+    tampered_summary = copy.deepcopy(manifest)
+    tampered_summary["summary"]["runtime_ns_total"] = 1
+
+    with pytest.raises(Phase13ComputeProfileError, match="summary does not match"):
+        validate_phase13_compute_profile_manifest(tampered_summary)
+
+    tampered_id = copy.deepcopy(manifest)
+    tampered_id["manifest_id"] = PHASE13_COMPUTE_PROFILE_ID_PREFIX + ("0" * 64)
+
+    with pytest.raises(Phase13ComputeProfileError, match="manifest_id does not match"):
+        validate_phase13_compute_profile_manifest(tampered_id)

tokens used
93,185
Implemented and pushed the Phase 13 compute-profile manifest work.

Changed:
- [phase13_compute_profile.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase13-09-runner-compute-profile-20260509T134830Z/src/bsebench_runner/phase13_compute_profile.py:1): strict builder/validator/writer for ensemble compute-profile manifests, including provenance, split/hash evidence, runtime, memory, iteration counts, deterministic manifest IDs, and fail-closed validation.
- [test_phase13_compute_profile.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase13-09-runner-compute-profile-20260509T134830Z/tests/test_phase13_compute_profile.py:1): focused tests for deterministic output and missing-data/hash/split/provenance/metric failures.

Validation:
- `uv run --extra dev pytest tests/test_phase13_compute_profile.py` passed.
- `uv run --extra dev ruff check src/bsebench_runner/phase13_compute_profile.py tests/test_phase13_compute_profile.py` passed.
- `git diff --check` passed.
- Broader cheap check `uv run --extra dev ruff check src tests` passed.

Pushed commit:
`86d2b92adb539fccf46d82a9b1719339ef4f864e`  
`GLASSBOX [role: phase13-runner-compute] add compute profile manifest`
```
