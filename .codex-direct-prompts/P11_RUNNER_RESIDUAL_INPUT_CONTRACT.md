You are a rigorous BSEBench runner engineer. You are running as an autonomous direct codex worker in a dedicated worktree/branch. You are not alone in the codebase; do not revert or overwrite unrelated edits.

Goal: Phase 11 residual input contract. Add a standalone dry-run contract that checks whether residual decomposition runs have enough input metadata before trace generation.

Owned files only:
- `src/bsebench_runner/residual_input_contract.py`
- `scripts/phase11_residual_input_contract.py`
- `tests/test_phase11_residual_input_contract.py`
- optional sanitized sample output under `outputs/phase11_residual_input_contract_sample.json`

Required behavior:
- Validate dataset/config identifiers, voltage/current/time units, sample count, cadence/timebase, residual component fields needed for sensor-noise vs model-mismatch decomposition, PCRLB/MAD floor dependencies when relevant, stats dependency identity, and source/cache readiness if discoverable.
- Output per config `ready`, `not_ready`, or `insufficient_metadata` with explicit reasons.
- Empty/all-skipped matrices must be non-ready.
- Do not generate residual traces or empirical evidence.

Validation:
- focused tests for complete inputs, missing units, missing timebase, missing residual fields, missing sample count, missing stats identity, missing provenance/cache.
- `uv run --locked --all-extras pytest tests/test_phase11_residual_input_contract.py -q`
- `uv run --locked --all-extras python scripts/phase11_residual_input_contract.py --output /tmp/bsebench_phase11_residual_input_contract.json`
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`
- `git diff --check`

Commit and push this branch with a GLASSBOX commit. No `Co-Authored-By Claude`. Do not edit roadmap, thesis, protected claims, or `claim_55`.
