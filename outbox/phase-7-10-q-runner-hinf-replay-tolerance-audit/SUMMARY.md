# Phase phase-7-10-q-runner-hinf-replay-tolerance-audit summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 90 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-runner
- Target branch : phase-7-10-q-runner-hinf-replay-tolerance-audit
- Branch SHA : 5bc53ab500be1ba6b9faf77e3c262e24addc08ca
- Push result : ok
- Merge readiness : ok
- Merge readiness detail : origin/main is an ancestor of HEAD
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-08T15:37:06+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+    ):
+        audit_module.audit_hinf_replay_tolerance(
+            manifest_path=paths["manifest"],
+            preflight_path=paths["preflight"],
+            chi2_path=paths["chi2"],
+            evidence_path=paths["evidence"],
+            repo_root=tmp_path,
+        )
+
+
+@pytest.mark.fast
+def test_audit_rejects_stale_stats_dependency(audit_module, tmp_path: Path) -> None:
+    manifest = copy.deepcopy(_json(MANIFEST_PATH))
+    manifest["locked_dependencies"]["bsebench_stats_git_sha"] = STALE_STATS_SHA
+    manifest["repositories"]["bsebench-stats"]["locked_git_sha"] = STALE_STATS_SHA
+    manifest["repositories"]["bsebench-stats"]["selected_src_git_sha"] = STALE_STATS_SHA
+    paths = _copy_bundle(tmp_path, manifest_payload=manifest)
+
+    with pytest.raises(
+        audit_module.HinfReplayToleranceAuditError,
+        match="known stale SHA",
+    ):
+        audit_module.audit_hinf_replay_tolerance(
+            manifest_path=paths["manifest"],
+            preflight_path=paths["preflight"],
+            chi2_path=paths["chi2"],
+            evidence_path=paths["evidence"],
+            repo_root=tmp_path,
+        )
+
+
+@pytest.mark.fast
+def test_audit_rejects_nonzero_replay_mismatch_count(audit_module, tmp_path: Path) -> None:
+    evidence = copy.deepcopy(_json(EVIDENCE_PATH))
+    matrix = evidence["residual_covariance_panel"]["aggregate_report"]["correlation_matrix"]
+    matrix[4][1] += 1.0e-3
+    matrix[1][4] += 1.0e-3
+    paths = _copy_bundle(tmp_path, evidence_payload=evidence)
+
+    with pytest.raises(
+        audit_module.HinfReplayToleranceAuditError,
+        match="strict Hinf replay mismatch count is non-zero",
+    ) as exc_info:
+        audit_module.audit_hinf_replay_tolerance(
+            manifest_path=paths["manifest"],
+            preflight_path=paths["preflight"],
+            chi2_path=paths["chi2"],
+            evidence_path=paths["evidence"],
+            repo_root=tmp_path,
+        )
+
+    assert exc_info.value.report is not None
+    replay = exc_info.value.report["replay"]
+    assert replay["mismatch_count"] > 0
+    assert replay["max_absolute_delta"] >= 1.0e-3

tokens used
214,639
Implemented and committed the read-only Hinf replay tolerance audit.

Commit: `5bc53ab500be1ba6b9faf77e3c262e24addc08ca`

Changed:
- Added [audit_hinf_replay_tolerance.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-7-10-q-runner-hinf-replay-tolerance-audit/scripts/audit_hinf_replay_tolerance.py)
- Added [test_audit_hinf_replay_tolerance.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-7-10-q-runner-hinf-replay-tolerance-audit/tests/test_audit_hinf_replay_tolerance.py)

The audit reports artifact hashes/sizes, strict tolerance contract and values, max absolute/relative replay deltas, mismatch counts, locked/runtime stats dependency identity, stale dependency status, and `claim_55_targeted=false`. It fails on hash drift, missing/non-finite/loose tolerances, stale/unknown stats identity, or non-zero replay mismatches.

Real audit result: passed with `rtol=1e-12`, `atol=1e-12`, `mismatch_count=0`, max deltas `0.0`, locked runtime `bsebench-stats` commit `d7e86b72398e6785238797fabbb5c788d2294215`, and no stale lock SHA.

Validation passed:
- `uv run --locked --all-extras pytest tests/test_audit_hinf_replay_tolerance.py -q`
- `uv run --locked --all-extras python scripts/audit_hinf_replay_tolerance.py`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`
- `git diff --check`
- `git diff --cached --check`

Working tree is clean; branch is ahead by 1 commit.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-q-runner-hinf-replay-tolerance-audit in target_repo. Verify gates. Merge to main if green.
