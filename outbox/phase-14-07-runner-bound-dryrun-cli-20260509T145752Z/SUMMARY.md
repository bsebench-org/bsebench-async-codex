# phase-14-07-runner-bound-dryrun-cli-20260509T145752Z direct-worker summary

- Direct pid: `3068055`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-runner`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-runner-glassbox-phase14-07-runner-bound-dryrun-cli-20260509T145752Z`
- Target branch: `glassbox-phase14-07-runner-bound-dryrun-cli-20260509T145752Z`
- Branch SHA: `ed7fde28ca9887d8902174a9cc50f41c8203e5af`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T15:23:13.018221Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+
+def test_phase14_bound_dry_run_cli_returns_blocked_code_unless_allowed(tmp_path: Path) -> None:
+    payload = _inputs()
+    payload["evidence"].pop("truth")
+    inputs = _write_json(tmp_path / "blocked-inputs.json", payload)
+    output = tmp_path / "blocked-report.json"
+
+    assert main(["--plan-json", str(inputs), "--output", str(output)]) == 2
+    report = json.loads(output.read_text(encoding="utf-8"))
+    assert report["decision"]["plan_status"] == "blocked"
+    assert "missing_truth_evidence" in report["blocking_gaps"]
+
+    assert main(["--plan-json", str(inputs), "--output", str(output), "--allow-blocked"]) == 0
+
+
+def test_phase14_bound_dry_run_cli_rejects_non_standard_json_constants(
+    tmp_path: Path,
+    capsys: pytest.CaptureFixture[str],
+) -> None:
+    payload = _inputs()
+    payload["evidence"]["parameters"]["values"][0] = math.nan
+    inputs = _write_json(tmp_path / "nan-inputs.json", payload, allow_nan=True)
+
+    assert main(["--inputs-json", str(inputs)]) == 2
+    assert "non-standard JSON constant" in capsys.readouterr().err
+
+
+def test_phase14_bound_dry_run_module_entrypoint_smoke(tmp_path: Path) -> None:
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
+            "bsebench_runner.phase14_bound_dry_run_cli",
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
+    assert report["decision"]["bound_computation_allowed"] is False

tokens used
63,121
Implemented and pushed commit `ed7fde2` to `origin/glassbox-phase14-07-runner-bound-dryrun-cli-20260509T145752Z`.

Added:
- `src/bsebench_runner/phase14_bound_dry_run_cli.py`
  - strict JSON load
  - dry-run report generation from `phase14_bound_plan`
  - ready/blocked exit codes
  - `--allow-blocked`
  - no filter, estimator, dataset, SOC/SOH, upload, or bound-computation execution
- `tests/test_phase14_bound_dry_run_cli.py`
  - helper validation
  - CLI ready/blocked behavior
  - fail-closed blockers
  - non-standard JSON constant rejection
  - `python -m bsebench_runner.phase14_bound_dry_run_cli` smoke test

Validation:
- `uv run --extra dev pytest tests/test_phase14_bound_dry_run_cli.py tests/test_phase14_bound_plan.py` passed: 18 tests
- `git diff --check` passed
- `uv run --extra dev ruff check src/bsebench_runner/phase14_bound_dry_run_cli.py tests/test_phase14_bound_dry_run_cli.py` passed

Full project test suite was not run; validation stayed scoped to the requested Phase 14 CLI path plus the bound-plan dependency.
```
