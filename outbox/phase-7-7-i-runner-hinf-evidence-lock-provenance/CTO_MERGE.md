# CTO Merge: phase-7-7-i-runner-hinf-evidence-lock-provenance

Status: approved

Actor: codex-cto-FR

UTC: 2026-05-07T05:06:19Z

Target repo: `bsebench-runner`

Target commit: `cf99b71`

## Scope

Runner provenance hardening for the strict Hinf 5x5 bundle.

Changed:

- `uv.lock`
- `outputs/hinf_residual_artifact_manifest.json`
- `scripts/audit_hinf_residual_manifest.py`
- `tests/test_audit_hinf_residual_manifest.py`

## Reason

The committed Hinf evidence bundle used the sibling `bsebench-stats` source at
`d7e86b72398e6785238797fabbb5c788d2294215`, but the runner lock still pinned
`bsebench-stats` to stale commit
`f5285f5c25f0b41f20dcfbecd54689e9b7a893ca`.

This was a reproducibility gap, not a scientific result.

## Result

- `uv.lock` now pins `bsebench-stats` to
  `d7e86b72398e6785238797fabbb5c788d2294215`.
- The manifest records SHA256 and byte-size provenance for:
  - `outputs/hinf_residual_cache_preflight.json`
  - `outputs/chi2_sweep_5x5.json`
  - `outputs/hinf_residual_evidence_5x5.json`
  - `uv.lock`
- The new manifest audit verifies:
  - artifact hashes and sizes,
  - strict summaries,
  - stats lock provenance,
  - guardrails `scientific_verdict=none`,
  - `mechanical_evidence_only=true`,
  - `claim_55_targeted=false`.

## Validation

- `uv run --locked --all-extras python scripts/audit_hinf_residual_outputs.py`
  - pass: preflight 5/5, chi2 25/25, evidence 25/25.
- `uv run --locked --all-extras python scripts/audit_hinf_residual_manifest.py`
  - pass: 4 artifacts hash-checked; stats lock
    `d7e86b72398e6785238797fabbb5c788d2294215`.
- Focused tests:
  - `19 passed`.
- Full non-slow runner tests:
  - `108 passed, 5 deselected`.
- Ruff:
  - `ruff check .` pass.
  - `ruff format --check .` pass.
- Independent validator Pascal:
  - GO.

## Boundary

No thesis registry edit.

No thesis prose edit.

No roadmap edit.

No `claim_55` update.

No scientific verdict assigned.
