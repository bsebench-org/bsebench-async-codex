# CTO unblock — phase-7-8-g-stats-hinf-weighting-sensitivity

[role: codex-cto-FR]
Generated at: 2026-05-07T08:34:27Z

## Reason

The advisor BLOCK was correct at the time: chef-side `ruff format --check` failed on
`src/bsebench_stats/runners/hinf_sensitivity.py`, so the branch was not
mergeable even though the statistical result was useful.

## Remediation

The CTO created a formatter-only fix branch, rebased it on current
`bsebench-stats/main`, reran the real sensitivity command and full gates, then
fast-forward pushed `bsebench-stats/main`.

## Evidence

- Fixed stats main SHA: `6a892ee56aba401537d658fbfafca7443b3e559f`
- Gates rerun:
  - `uv run --locked --all-extras python scripts/hinf_residual_sensitivity.py --output /tmp/hinf_residual_sensitivity_fix_g.json`
  - JSON guard: `scientific_verdict == "none"`, `mechanical_evidence_only == true`, `falsification_gate.status == "material_sensitivity_detected"`
  - `uv run --locked --all-extras pytest tests/test_hinf_residual_sensitivity.py -q`
  - `uv run --locked --all-extras pytest tests/ -m "not slow" -q`
  - `uv run --locked --all-extras ruff check .`
  - `uv run --locked --all-extras ruff format --check .`

## Decision

The block file was removed after remediation. This does not convert the
mechanical Hinf sensitivity result into a thesis claim or scientific verdict.
