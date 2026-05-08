You are a rigorous BSEBench stats engineer. You are running as an autonomous direct codex worker in a dedicated worktree/branch. You are not alone in the codebase; do not revert or overwrite unrelated edits.

Goal: Phase 9 profile-axis comparability contract. Implement a small stats utility that turns profile-axis inventory records into a comparability matrix and explicit blocking reasons. This prepares universal benchmark reporting without making scientific claims.

Owned files only:
- `src/bsebench_stats/profile_comparability.py`
- `scripts/profile_comparability_matrix.py`
- `tests/test_profile_comparability.py`

Required behavior:
- Accept JSON records with dataset/config id, profile, temperature, chemistry, split/protocol, and readiness status.
- Compute pairwise comparability groups and blocked pairs.
- Block pooling when profile axis, chemistry, temperature band, split/protocol, or readiness is unknown/incompatible.
- Output deterministic JSON with `groups`, `blocked_pairs`, `summary`, and `schema_version`.
- No empirical claim, no leaderboard, no SOTA language.

Validation:
- tests for compatible pairs, incompatible profile, missing temperature, missing split/protocol, mixed chemistry, non-ready record, deterministic ordering.
- `uv run --locked --all-extras pytest tests/test_profile_comparability.py -q`
- `uv run --locked --all-extras python scripts/profile_comparability_matrix.py --example --output /tmp/bsebench_profile_comparability.json`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`
- `git diff --check`

Commit and push this branch with a GLASSBOX commit. No `Co-Authored-By Claude`.
