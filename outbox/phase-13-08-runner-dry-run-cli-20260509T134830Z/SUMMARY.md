# Phase phase-13-08-runner-dry-run-cli-20260509T134830Z direct-worker summary

- Direct pid: `3039286`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-runner`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase13-08-runner-dry-run-cli-20260509T134830Z`
- Target branch: `glassbox-phase13-08-runner-dry-run-cli-20260509T134830Z`
- Branch SHA: `6cae1a88bfd358a7be444d02ee5425032a4aa0d2`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:34:46.880724Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+            "--generated-at-utc",
+            "2026-05-09T12:00:00Z",
+        ]
+    )
+
+    assert rc == 0
+    assert "status=ready" in capsys.readouterr().out
+    report = json.loads(output.read_text(encoding="utf-8"))
+    assert report["decision"]["validation_status"] == "ready"
+    assert report["input"]["sha256"]
+    assert report["execution"]["attempted"] is False
+
+
+def test_phase13_dry_run_cli_returns_blocked_code_unless_allowed(
+    tmp_path: Path,
+) -> None:
+    payload = _fixture()
+    payload["split"].pop("manifest_sha256")
+    plan = _write_json(tmp_path / "blocked-plan.json", payload)
+
+    assert main(["--plan-json", str(plan), "--metric", "soc_rmse"]) == 2
+    assert main(["--plan-json", str(plan), "--metric", "soc_rmse", "--allow-blocked"]) == 0
+
+
+def test_phase13_dry_run_loader_rejects_non_standard_json_constants(tmp_path: Path) -> None:
+    payload = _fixture()
+    payload["candidate_reports"][0]["metrics"]["soc_rmse"] = float("nan")
+    plan = _write_json(tmp_path / "nan-plan.json", payload, allow_nan=True)
+
+    with pytest.raises(Phase13DryRunError, match="non-standard JSON constant"):
+        load_ensemble_plan_fixture(plan)
+
+
+def test_phase13_dry_run_module_entrypoint_smoke(tmp_path: Path) -> None:
+    plan = _write_json(tmp_path / "plan.json", _fixture())
+    output = tmp_path / "module-report.json"
+    env = {
+        **os.environ,
+        "PYTHONPATH": f"{Path.cwd() / 'src'}{os.pathsep}{os.environ.get('PYTHONPATH', '')}",
+    }
+
+    result = subprocess.run(
+        [
+            sys.executable,
+            "-m",
+            "bsebench_runner.phase13_dry_run_cli",
+            "--plan-json",
+            str(plan),
+            "--output",
+            str(output),
+            "--metric",
+            "soc_rmse",
+        ],
+        check=False,
+        env=env,
+        text=True,
+        capture_output=True,
+    )
+
+    assert result.returncode == 0, result.stderr
+    report = json.loads(output.read_text(encoding="utf-8"))
+    assert report["execution"]["filter_execution_attempted"] is False
+    assert report["decision"]["estimator_execution_allowed"] is False

tokens used
131,294
Implemented and pushed commit `6cae1a88bfd358a7be444d02ee5425032a4aa0d2` to `origin/glassbox-phase13-08-runner-dry-run-cli-20260509T134830Z`.

Changed:
- Added [phase13_dry_run_cli.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase13-08-runner-dry-run-cli-20260509T134830Z/src/bsebench_runner/phase13_dry_run_cli.py)
- Added [test_phase13_dry_run_cli.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase13-08-runner-dry-run-cli-20260509T134830Z/tests/test_phase13_dry_run_cli.py)

Validation run:
- `uv run --extra dev pytest tests/test_phase13_dry_run_cli.py` passed, including the module-entrypoint no-execution smoke path.
- `uv run --extra dev ruff check src/bsebench_runner/phase13_dry_run_cli.py tests/test_phase13_dry_run_cli.py` passed.
- `uv run --extra dev ruff check` passed.
- `git diff --cached --check` passed before commit.

Skipped:
- Full pytest suite was not run; I used the focused Phase 13 tests plus broader lint as the cheap project-wide check. `gh` is not installed, so no PR was opened.
```
