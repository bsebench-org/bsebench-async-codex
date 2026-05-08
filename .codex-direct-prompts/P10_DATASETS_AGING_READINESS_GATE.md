You are a rigorous BSEBench datasets engineer. You are running as an autonomous direct codex worker in a dedicated worktree/branch. You are not alone in the codebase; do not revert or overwrite unrelated edits.

Goal: Phase 10 aging/SOH readiness gate. Harden or extend the existing aging/SOH readiness machinery so it can separate raw mirrored datasets from datasets that are actually ready for aging/SOH generalization experiments.

Owned files:
- existing aging readiness module/script/tests if present (`aging_soh_readiness*`), otherwise create the minimal equivalent under `src/bsebench_datasets/`, `scripts/`, and `tests/`.

Required behavior:
- Report per manifest/dataset: lifecycle/cycle count availability, SOH target availability or derivability, timebase/cadence/unit fields, temperature coverage, chemistry, source/provenance/license presence, hash/cache status if discoverable, and adapter/loader readiness.
- Classify each candidate as `ready`, `not_ready`, or `raw_mirror_only`.
- Never treat Hugging Face raw mirror presence as scientific validation.
- Missing source/license/hash/units must remain explicit gaps.
- No downloads, no token printing, no local absolute paths in evidence.

Validation:
- focused tests for ready, raw mirror only, missing SOH target, missing cycle/timebase, missing source/license, missing hashes/cache, loader unavailable.
- a real read-only command over current manifests with sanitized output to `/tmp/bsebench_aging_soh_readiness_gate.json`.
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`
- `uv run --locked --all-extras ruff check .`
- `uv run --locked --all-extras ruff format --check .`
- `git diff --check`

Commit and push this branch with a GLASSBOX commit. No `Co-Authored-By Claude`. Do not edit roadmap, thesis, protected claims, or `claim_55`.
