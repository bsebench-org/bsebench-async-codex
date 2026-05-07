# CTO Merge: phase-7-7-h-runner-hinf-output-audit

Status: approved and pushed

Actor: codex-cto-FR

UTC: 2026-05-07T04:42:00Z

## Context

The strict Hinf 5x5 evidence bundle is now committed in `bsebench-runner`.
Manual GLASSBOX inspection and independent sub-agent validation passed, but the
repository needed a cheap machine-checkable audit that can be rerun without
recomputing the 25 filter traces.

## Change

Repository: `bsebench-runner`

Commit: `5885b3f6c9bebef8aa9756445b53673dbbe6c8bc`

Subject: `GLASSBOX [role: codex-cto-FR] Add strict Hinf output audit`

Pushed to: `origin/main`

Added files:

- `scripts/audit_hinf_residual_outputs.py`
- `tests/test_audit_hinf_residual_outputs.py`

The audit verifies the committed output artifacts:

- `outputs/hinf_residual_cache_preflight.json`
- `outputs/chi2_sweep_5x5.json`
- `outputs/hinf_residual_evidence_5x5.json`

It enforces:

- preflight `ok_configs=5`, `missing_configs=0`, `evidence_ready=true`;
- chi2 `ok=25`, `skipped=0`, `error=0`, all 25 cells `ok`;
- evidence trace `ok_configs=5`, `error_configs=0`, `ok_filter_runs=25`,
  `error_filter_runs=0`;
- exact five config labels and five filter labels;
- Hinf `status=ok` on all five configs;
- Hinf `residual_mV` arrays are lists of numeric finite values with the exact
  retained-sample length;
- `scientific_verdict="none"`;
- `claim_target="new_hinf_candidate_not_claim_55"`;
- `mechanical_evidence_only=true`;
- `claim_55_targeted=false`;
- `stats_import.selected_stats_src` points to `bsebench-stats/src`.

## Validation

Local CTO gates:

- `uv run --locked --all-extras python scripts/audit_hinf_residual_outputs.py`
  - pass: preflight 5/5, chi2 25/25, evidence 25/25
- focused audit tests: `5 passed`
- full runner non-slow: `103 passed, 5 deselected`
- `uv run --locked --all-extras ruff check .`: pass
- `uv run --locked --all-extras ruff format --check .`: pass
- `git diff --check`: pass

Sub-agent validation:

- `Banach`: NO-GO on first draft because `Hinf.residual_mV` length was checked
  but elements were not explicitly required to be numeric finite values.
- CTO fix: added `_finite_float_array()` and a negative regression test where
  `residual_mV[0] = "0.0"` must fail.
- `Gibbs`: GO after correction.

## Scope Boundary

Audit tooling only. No output artifact was regenerated, no claim was updated,
and no thesis prose or roadmap text was changed.

The claim identity block still holds: Hinf evidence must remain
`new_hinf_candidate_not_claim_55` until a new claim id is explicitly introduced.

## Next Step

Use `scripts/audit_hinf_residual_outputs.py` as the cheap gate before any future
claim-candidate drafting from the Hinf bundle.
