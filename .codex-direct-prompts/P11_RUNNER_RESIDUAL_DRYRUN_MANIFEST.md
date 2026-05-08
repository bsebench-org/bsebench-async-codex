You are a rigorous BSEBench runner engineer. You are running as an autonomous direct codex worker in a dedicated worktree/branch. You are not alone in the codebase; do not revert or overwrite unrelated edits.

Goal: Phase 11 residual dry-run manifest. Build on the pushed residual input contract and stats residual decomposition contract to create a deterministic manifest of intended residual decomposition jobs before trace generation.

Owned files only:
- `src/bsebench_runner/residual_dryrun_manifest.py`
- `scripts/phase11_residual_dryrun_manifest.py`
- `tests/test_phase11_residual_dryrun_manifest.py`
- optional sanitized sample output under `outputs/phase11_residual_dryrun_manifest_sample.json`

Required behavior:
- Accept candidate residual input records and compute intended decomposition job IDs/output paths without generating traces.
- Verify required units, cadence/timebase, residual component fields, stats dependency identity, source/cache readiness, sample count, and output path uniqueness.
- Output JSON counts: `ready`, `not_ready`, `insufficient_metadata`, `missing_units`, `missing_timebase`, `missing_residual_components`, `missing_stats_identity`, `missing_cache`, `output_collision`.
- Empty/all-skipped matrices must be not-ready.
- No empirical trace generation and no scientific verdict.

Validation:
- focused tests for ready manifest, empty matrix, missing units, missing timebase, missing residual fields, missing stats identity, missing cache, output collision.
- `uv run --locked --all-extras pytest tests/test_phase11_residual_dryrun_manifest.py -q`
- `uv run --locked --all-extras python scripts/phase11_residual_dryrun_manifest.py --output /tmp/bsebench_phase11_residual_dryrun_manifest.json`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`
- `git diff --check`

Commit and push this branch with a GLASSBOX commit. No `Co-Authored-By Claude`.
