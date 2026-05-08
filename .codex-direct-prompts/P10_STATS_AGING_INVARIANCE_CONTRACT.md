You are a rigorous BSEBench stats engineer. You are running as an autonomous direct codex worker in a dedicated worktree/branch. You are not alone in the codebase; do not revert or overwrite unrelated edits.

Goal: Phase 10 aging/SOH invariance contract. Add a standalone stats-side contract for comparing filter performance across aging/SOH strata without making scientific claims.

Owned files only:
- `src/bsebench_stats/aging_invariance_contract.py`
- `scripts/aging_invariance_contract.py`
- `tests/test_aging_invariance_contract.py`

Required behavior:
- Accept records with dataset/config id, chemistry, temperature, SOH or aging stratum, split/protocol, metric values, and readiness status.
- Block comparisons when SOH/aging strata, chemistry, temperature, split/protocol, readiness, or sample counts are insufficient.
- Output deterministic JSON with `schema_version`, `status`, `groups`, `blocked_comparisons`, `blocking_reason_counts`, and `claim_support_ready=false` unless all required fields are complete.
- No empirical claims, no leaderboard, no SOTA language.

Validation:
- tests for complete comparable groups, missing SOH stratum, mixed chemistry, missing temperature, incompatible split/protocol, insufficient sample count, non-ready record, deterministic ordering.
- `uv run --locked --all-extras pytest tests/test_aging_invariance_contract.py -q`
- `uv run --locked --all-extras python scripts/aging_invariance_contract.py --example --output /tmp/bsebench_aging_invariance_contract.json`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`
- `git diff --check`

Commit and push this branch with a GLASSBOX commit. No `Co-Authored-By Claude`.
