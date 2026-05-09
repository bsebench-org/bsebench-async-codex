# Phase 9 Integration Audit - 2026-05-09

## Executive Status

Phase 9 branch output has been converted from dispersed worker branches into
pushed `main` commits across the product repositories. This fixes the previous
failure mode where work existed mostly as logs and unmerged branches.

Current status: **Phase 9 tooling/integration is materially advanced but not
scientifically closed**. Do not claim Phase 9 complete until an end-to-end
empirical profile-axis run over real Tier2 cache/provenance evidence passes.

## Pushed Main Commits

| Repo | Main commit | Integrated evidence |
| --- | --- | --- |
| `bsebench-runner` | `8adadd8` | Phase 9 profile dispatch scheduler guard |
| `bsebench-stats` | `3c3a6b5` | Phase 9 synthetic-verdict rejection plus no-claims linter |
| `bsebench-datasets` | `4f018e0` | Phase 9 Tier2 profile cache audit plus local Tier2 discovery |
| `bsebench-specs` | `2964ed7` | Phase 9/10/11 evidence schema hardening, including Dataset evidence and RunResult empirical-run evidence |
| `bsebench-filters` | `8c0d64b` | Phase 9/10/11 filter export audit |
| `bsebench-async-codex` | `8dd4b2c` | Phase 9/10/11 merge matrix, acceptance gate, and anti-claim guard |

## Validation Run

All validations below passed on clean worktrees under
`/mnt/c/doctorat/bsebench-org/.phase9-integration-20260509T024454+0200`.

| Repo | Command | Result |
| --- | --- | --- |
| `bsebench-runner` | `UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_cli.py tests/test_profile_dispatch_budget.py` | 24 passed |
| `bsebench-stats` | `UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_profile_axis_variance.py tests/test_phase9_11_no_claims_linter.py` | 32 passed |
| `bsebench-datasets` | `UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_profile_axis_readiness.py tests/test_aging_soh_readiness.py` | 22 passed |
| `bsebench-specs` | `UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_run_result.py tests/test_schema_export.py tests/test_dataset.py` | 36 passed |
| `bsebench-filters` | `UV_LINK_MODE=copy uv run --with pytest --with pytest-cov pytest tests/test_phase9_10_11_exports.py tests/test_profile_axis_smoke_contract.py tests/test_phase10_smoke_contract.py tests/test_residual_output_contract.py` | 61 passed |
| `bsebench-async-codex` | `PYTHONPATH=. UV_LINK_MODE=copy uv run --with pytest pytest -q tests/test_phase9_11_merge_matrix.py && bash scripts/probe-phase9-11-acceptance-gate.sh && bash scripts/probe-research-diff-scope-guard.sh` | 5 passed plus both probes passed |

## Corrections Made During Integration

- Used clean Git worktrees instead of dirty product working trees, avoiding
  accidental overwrite of existing local modifications.
- Resolved `bsebench-specs` conflicts by preserving both evidence layers:
  evidence-backed SOC/SOH metric containers and required empirical Tier2 run
  evidence.
- Fixed a `bsebench-datasets` test fixture to use a readable Tier2 Parquet plus
  explicit manifest/source-ledger evidence, matching the new fail-closed audit.
- Kept Hugging Face uploads paused.

## Remaining Phase 9 Closure Criteria

1. Run one end-to-end Phase 9 profile-axis empirical dry run over real Tier2
   cache/provenance/source-ledger evidence.
2. Verify the produced `RunResult` contains `empirical_run`, `soc_metrics` or
   comparable evidence-backed state metrics, and no synthetic-only verdict.
3. Run the async acceptance gate against the resulting artifact bundle.
4. Publish a Phase 9 closure report only if the evidence artifact passes.

## Current Phase Estimate

- Phase 9: 88% (+18 points since the last mobile baseline at 70%).
- Phase 10: 62% (+0; intentionally not advanced in this focused integration).
- Phase 11: 54% (+0; intentionally not advanced in this focused integration).

Scientific closure remains **NO-GO** until the empirical Phase 9 artifact exists.
