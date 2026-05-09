# phase-15-08-runner-adaptive-dryrun-cli-20260509T163452Z direct-worker summary

- Direct pid: `3089582`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-runner`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase15-08-runner-adaptive-dryrun-cli-20260509T163452Z`
- Target branch: `glassbox-phase15-08-runner-adaptive-dryrun-cli-20260509T163452Z`
- Branch SHA: `da55f794f026e87caf8062934a7719bcf6cc05e8`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T17:08:38.531795Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+    assert report["execution"]["filter_execution_attempted"] is False
+
+
+def test_phase15_adaptive_dry_run_cli_returns_blocked_code_unless_allowed(
+    tmp_path: Path,
+) -> None:
+    payload = _inputs()
+    payload["evidence"]["evaluation_split"]["calibration_overlap_count"] = 1
+    inputs = _write_json(tmp_path / "blocked-inputs.json", payload)
+    output = tmp_path / "blocked-report.json"
+
+    assert main(["--plan-json", str(inputs), "--output", str(output)]) == 2
+    report = json.loads(output.read_text(encoding="utf-8"))
+    assert report["decision"]["plan_status"] == "blocked"
+    assert "split_leakage:calibration_evaluation_overlap_count" in report["blocking_gaps"]
+
+    assert main(["--plan-json", str(inputs), "--output", str(output), "--allow-blocked"]) == 0
+
+
+def test_phase15_adaptive_dry_run_cli_rejects_non_standard_json_constants(
+    tmp_path: Path,
+    capsys: pytest.CaptureFixture[str],
+) -> None:
+    payload = _inputs()
+    payload["evidence"]["baseline"]["metrics"]["residual_rmse"] = math.nan
+    inputs = _write_json(tmp_path / "nan-inputs.json", payload, allow_nan=True)
+
+    assert main(["--inputs-json", str(inputs)]) == 2
+    assert "non-standard JSON constant" in capsys.readouterr().err
+
+
+def test_phase15_adaptive_dry_run_module_entrypoint_smoke(tmp_path: Path) -> None:
+    inputs = _write_json(tmp_path / "inputs.json", _inputs())
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
+            "bsebench_runner.phase15_adaptive_dry_run_cli",
+            "--inputs-json",
+            str(inputs),
+            "--output",
+            str(output),
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
+    assert report["decision"]["adaptive_update_execution_allowed"] is False

tokens used
106,397
Implemented and pushed the Phase 15 adaptive dry-run CLI.

Changed:
- [phase15_adaptive_dry_run_cli.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase15-08-runner-adaptive-dryrun-cli-20260509T163452Z/src/bsebench_runner/phase15_adaptive_dry_run_cli.py)
- [test_phase15_adaptive_dry_run_cli.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase15-08-runner-adaptive-dryrun-cli-20260509T163452Z/tests/test_phase15_adaptive_dry_run_cli.py)

Commit pushed:
`da55f794f026e87caf8062934a7719bcf6cc05e8`
`GLASSBOX [role: phase15-runner-adaptive-dryrun-cli] add adaptive dry-run cli`

Validation:
- `uv run --extra dev pytest tests/test_phase15_adaptive_plan.py tests/test_phase15_adaptive_dry_run_cli.py` -> 21 passed
- `uv run --extra dev ruff check src/bsebench_runner/phase15_adaptive_dry_run_cli.py tests/test_phase15_adaptive_dry_run_cli.py` -> passed
- `git diff --check` -> passed
- `git diff --cached --check` -> passed
- `python -m compileall -q src/bsebench_runner/phase15_adaptive_dry_run_cli.py` -> passed

Note: `python -m pytest ...` with the system Python could not run because `pytest` was not installed there, so I used the repo-managed `uv --extra dev` environment. Full project pytest was not run; focused Phase 15 coverage and a cheap ruff pass were run.
```
