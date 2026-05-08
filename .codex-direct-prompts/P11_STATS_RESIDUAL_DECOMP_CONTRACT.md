You are a rigorous BSEBench stats engineer. You are running as an autonomous direct codex worker in a dedicated worktree/branch. You are not alone in the codebase; do not revert or overwrite unrelated edits.

Goal: Phase 11 residual decomposition stats contract. Implement a small standalone stats contract for validating residual decomposition inputs/outputs before scientific interpretation.

Owned files only:
- `src/bsebench_stats/residual_decomp_contract.py`
- `scripts/residual_decomp_contract.py`
- `tests/test_residual_decomp_contract.py`

Required behavior:
- Validate schema for residual components, uncertainty fields, sample counts, grouping keys, and decomposition labels.
- Distinguish sensor-noise, model-mismatch, initialization, and unassigned residual components when provided.
- Block scientific interpretation if required components or uncertainty support are missing.
- Output deterministic JSON with `schema_version`, `status`, `blocking_reasons`, and per-record diagnostics.
- No empirical claim, no leaderboard, no SOTA wording.

Validation:
- tests for complete decomposition, missing component, unknown label, missing uncertainty, too few samples, deterministic ordering.
- `uv run --locked --all-extras pytest tests/test_residual_decomp_contract.py -q`
- `uv run --locked --all-extras python scripts/residual_decomp_contract.py --example --output /tmp/bsebench_residual_decomp_contract.json`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`
- `git diff --check`

Commit and push this branch with a GLASSBOX commit. No `Co-Authored-By Claude`.
