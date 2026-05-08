You are a rigorous BSEBench runner engineer. You are running as an autonomous direct codex worker in a dedicated worktree/branch. You are not alone in the codebase; do not revert or overwrite unrelated edits.

Goal: Phase 10 aging/SOH pre-dispatch budget. Add a standalone dry-run budget tool that estimates intended aging/SOH benchmark jobs and blocks empty/all-skipped/not-provenanced matrices before expensive work.

Owned files only:
- `src/bsebench_runner/aging_budget.py`
- `scripts/aging_predispatch_budget.py`
- `tests/test_aging_predispatch_budget.py`
- optional sanitized sample output under `outputs/aging_predispatch_budget_sample.json`

Required behavior:
- Input can be built-in sample/current metadata discovery; keep it deterministic and testable.
- Output JSON counts: `ready`, `skipped`, `missing_soh_target`, `missing_cycle_or_timebase`, `missing_temperature`, `missing_provenance`, `missing_cache`, `loader_error`, `output_collision`.
- Empty/all-skipped matrices must fail/not-ready.
- Do not run filters; no empirical evidence; no leaderboard/claim wording.

Validation:
- focused tests for ready matrix, empty matrix, all skipped, missing SOH target, missing timebase, missing provenance/cache, output collision.
- `uv run --locked --all-extras pytest tests/test_aging_predispatch_budget.py -q`
- `uv run --locked --all-extras python scripts/aging_predispatch_budget.py --output /tmp/bsebench_aging_predispatch_budget.json`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`
- `git diff --check`

Commit and push this branch with a GLASSBOX commit. No `Co-Authored-By Claude`.
