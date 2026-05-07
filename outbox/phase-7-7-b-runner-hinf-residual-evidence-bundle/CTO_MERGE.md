# CTO merge: phase-7-7-b-runner-hinf-residual-evidence-bundle

- Decision: approved / merged as tooling only
- Decided at: 2026-05-07T02:49:10Z
- Decided by: chef-FR + codex-FR [role: codex-cto-FR]
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-runner`
- Main SHA after chef merge: `d4a9e2b2646738cfdf19c2ad2e09e05f7964fdf6`
- CTO hardening SHA after merge: `13ec004ddd22b581819b1694c1f8a0bd46bc3d74`

## Validation

- Worker summary: codex exit `0`, push OK.
- Chef verdict: approved and merged to main at `d4a9e2b`.
- Chef gates:
  - full non-slow -> `81 passed, 5 deselected`
  - `ruff format --check .` -> OK
  - `ruff check .` -> OK
- Panel check: PASS, average `89`.
- Independent validator Kuhn: GO, tooling approval only.
- CTO hardening `13ec004`:
  - focused tests -> `9 passed`
  - full non-slow -> `82 passed, 5 deselected`
  - `ruff format --check .` -> OK
  - `ruff check .` -> OK
  - independent validator Hooke: GO.

## Scope

- Added `scripts/hinf_residual_evidence_5x5.py`.
- Added `tests/test_hinf_residual_evidence_5x5.py`.
- Added CTO hardening to collapse all-config Hugging Face auth/repository access
  failures into one `hf_auth_missing_or_invalid` diagnostic.
- No output JSON was committed.
- No README, roadmap, claim registry, or thesis prose edits.
- No `Co-Authored-By: Claude` trailer.

## Evidence Status

- This is not an empirical Hinf evidence approval.
- The strict real-data run was attempted and failed before writing output:
  `ok_configs=0/5`, `ok_filter_runs=0/25`.
- All five config loads failed with Hugging Face `RepositoryNotFoundError` /
  `401` / `Invalid username or password`.
- Therefore `outputs/hinf_residual_evidence_5x5.json` does not exist and must
  not be claimed as produced.
- Future evidence work must fix HF auth or provide a valid local Tier 2 cache,
  then rerun the same strict `5 configs / 25 runs` gate.

## Residual Risk

- Hinf residual evidence remains blocked on data access, not statistics code.
- `claim_55` remains unavailable for Hinf because thesis preflight found it is
  already the verified EnsembleMeta/MAD floor claim.
