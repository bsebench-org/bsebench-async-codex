# Chef verdict for phase-7-10-ah-stats-hinf-null-control-audit

- Decision : escalated
- Decided at : 2026-05-08T10:11:40+02:00
- Decided by : chef-daemon (automated, France PC) [role: chef-FR]

## Re-verification on chef PC

Worker reported status=error. Manual investigation needed (see SUMMARY + run.log.tail above for context). V1 chef-daemon does not auto-fix errors.

## Gate evidence

```

Changed:
- Added config-bootstrap null-control runner: [hinf_null_control.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-10-ah-stats-hinf-null-control-audit/src/bsebench_stats/runners/hinf_null_control.py)
- Added CLI: [hinf_null_control_audit.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-10-ah-stats-hinf-null-control-audit/scripts/hinf_null_control_audit.py)
- Exported runner APIs in [__init__.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-10-ah-stats-hinf-null-control-audit/src/bsebench_stats/runners/__init__.py)
- Added focused tests: [test_hinf_null_control.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-10-ah-stats-hinf-null-control-audit/tests/test_hinf_null_control.py)

Real audit run against frozen runner artifact wrote `/tmp/hinf_null_control_audit_5x5.json`:
- Evidence: `/mnt/c/doctorat/bsebench-org/bsebench-runner/outputs/hinf_residual_evidence_5x5.json`
- Seed: `710010`
- Statistic: `target_top_margin_abs_correlation`
- Observed: `0.6217968840408938`
- Null-control lower-tail statistic: `0.4537286599598518`
- Tolerance: `0.05`
- Gate: `null_control_separated`
- Mechanical effect: `strengthens`, with no scientific claim verdict.

Validation passed:
- `uv run --locked --all-extras pytest tests/test_hinf_null_control.py -q` → `4 passed`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q` → `174 passed`
- `uv run --locked --all-extras ruff check .` → passed
- `uv run --locked --all-extras ruff format --check .` → passed
- `git diff --check` → passed

Stats worktree has no uncommitted changes; branch is ahead 1 and behind 1 relative to `origin/main`.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-ah-stats-hinf-null-control-audit in target_repo. Verify gates. Merge to main if green.

--- run.log.tail ---
167,275
Implemented and committed the Hinf null-control audit.

Commit: `6918416`  
`GLASSBOX [role: codex-stats-engineer] Add Hinf null-control audit`

Changed:
- Added config-bootstrap null-control runner: [hinf_null_control.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-10-ah-stats-hinf-null-control-audit/src/bsebench_stats/runners/hinf_null_control.py)
- Added CLI: [hinf_null_control_audit.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-10-ah-stats-hinf-null-control-audit/scripts/hinf_null_control_audit.py)
- Exported runner APIs in [__init__.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-10-ah-stats-hinf-null-control-audit/src/bsebench_stats/runners/__init__.py)
- Added focused tests: [test_hinf_null_control.py](/mnt/c/doctorat/bsebench-org/bsebench-stats-phase-7-10-ah-stats-hinf-null-control-audit/tests/test_hinf_null_control.py)

Real audit run against frozen runner artifact wrote `/tmp/hinf_null_control_audit_5x5.json`:
- Evidence: `/mnt/c/doctorat/bsebench-org/bsebench-runner/outputs/hinf_residual_evidence_5x5.json`
- Seed: `710010`
- Statistic: `target_top_margin_abs_correlation`
- Observed: `0.6217968840408938`
- Null-control lower-tail statistic: `0.4537286599598518`
- Tolerance: `0.05`
- Gate: `null_control_separated`
- Mechanical effect: `strengthens`, with no scientific claim verdict.

Validation passed:
- `uv run --locked --all-extras pytest tests/test_hinf_null_control.py -q` → `4 passed`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q` → `174 passed`
- `uv run --locked --all-extras ruff check .` → passed
- `uv run --locked --all-extras ruff format --check .` → passed
- `git diff --check` → passed

Stats worktree has no uncommitted changes; branch is ahead 1 and behind 1 relative to `origin/main`.
```

## Changed files

```
unavailable: worker status=error; chef did not check out target branch
```

## Cross-references

- inbox/phase-7-10-ah-stats-hinf-null-control-audit/STATUS.json (worker artifact)
- outbox/phase-7-10-ah-stats-hinf-null-control-audit/SUMMARY.md (worker SUMMARY)
- outbox/phase-7-10-ah-stats-hinf-null-control-audit/run.log.tail (worker stdout tail, if non-empty)
