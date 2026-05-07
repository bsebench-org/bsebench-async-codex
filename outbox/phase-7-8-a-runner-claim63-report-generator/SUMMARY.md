# Phase phase-7-8-a-runner-claim63-report-generator summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 60 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-runner
- Target branch : phase-7-8-a-runner-claim63-report-generator
- Branch SHA : 6a56ae98dc1ac6ef5599ab7968315164be9f40ce
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T08:22:03+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+    bad_evidence = copy.deepcopy(evidence)
+    bad_evidence["claim_55_targeted"] = True
+    bad_evidence_path = _write_json(tmp_path / "bad_evidence.json", bad_evidence)
+    manifest_path = _manifest_for_evidence(tmp_path, bad_evidence_path)
+
+    with pytest.raises(
+        report_module.HinfCandidateReportError,
+        match=r"evidence\.claim_55_targeted",
+    ):
+        report_module.build_candidate_report(
+            evidence_path=bad_evidence_path,
+            manifest_path=manifest_path,
+        )
+
+
+@pytest.mark.fast
+def test_manifest_guardrail_change_exits_nonzero(report_module, tmp_path: Path, capsys) -> None:
+    manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
+    bad_manifest = copy.deepcopy(manifest)
+    bad_manifest["claim_target"] = "claim_55"
+    bad_manifest_path = _write_json(tmp_path / "bad_manifest.json", bad_manifest)
+    summary_path = tmp_path / "summary.json"
+    markdown_path = tmp_path / "report.md"
+
+    rc = report_module.main(
+        [
+            "--evidence",
+            str(EVIDENCE_PATH),
+            "--manifest",
+            str(bad_manifest_path),
+            "--summary-output",
+            str(summary_path),
+            "--markdown-output",
+            str(markdown_path),
+        ]
+    )
+
+    captured = capsys.readouterr()
+    assert rc == 2
+    assert "manifest.claim_target" in captured.out
+    assert not summary_path.exists()
+    assert not markdown_path.exists()
+
+
+@pytest.mark.fast
+def test_manifest_evidence_hash_mismatch_fails_closed(report_module, tmp_path: Path) -> None:
+    manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
+    bad_manifest = copy.deepcopy(manifest)
+    bad_manifest["artifacts"]["evidence"]["sha256"] = "0" * 64
+    bad_manifest_path = _write_json(tmp_path / "hash_mismatch_manifest.json", bad_manifest)
+
+    with pytest.raises(
+        report_module.HinfCandidateReportError,
+        match=r"manifest\.artifacts\.evidence\.sha256",
+    ):
+        report_module.build_candidate_report(
+            evidence_path=EVIDENCE_PATH,
+            manifest_path=bad_manifest_path,
+        )

tokens used
151,292
Implemented and committed the neutral Hinf candidate report generator.

Commit: `6a56ae98dc1ac6ef5599ab7968315164be9f40ce`

Changed files:
- [build_hinf_candidate_report.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-7-8-a-runner-claim63-report-generator/scripts/build_hinf_candidate_report.py)
- [test_build_hinf_candidate_report.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-7-8-a-runner-claim63-report-generator/tests/test_build_hinf_candidate_report.py)
- [hinf_candidate_report_summary.json](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-7-8-a-runner-claim63-report-generator/outputs/hinf_candidate_report_summary.json)
- [hinf_candidate_report.md](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-7-8-a-runner-claim63-report-generator/outputs/hinf_candidate_report.md)

Validation run:
- `uv run --locked --all-extras python scripts/audit_hinf_residual_manifest.py` passed
- `uv run --locked --all-extras python scripts/build_hinf_candidate_report.py` passed
- `uv run --locked --all-extras pytest tests/test_build_hinf_candidate_report.py -q` passed: 5 passed
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q` passed: 113 passed, 5 deselected
- `uv run --locked --all-extras ruff check .` passed

Worktree is clean and the branch is ahead by 1 commit.
```

## Next step for chef

git fetch origin && git checkout phase-7-8-a-runner-claim63-report-generator in target_repo. Verify gates. Merge to main if green.
