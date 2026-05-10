# Phase 35 Method Panel Amendment

Date: 2026-05-10
Status: CLOSED
Specs commit: `b4d5357`
Claim status: `NO_CLAIM`

## Objective

Formalize the Phase 34 ECM decision before any future claimable execution. The benchmark must not silently replace raw `EKF`; the method-panel amendment must explicitly record why `EKF_projected` is used and what it can and cannot claim.

## Definition Of Done

- Add a fail-closed specs contract for the Phase 35 method-panel amendment.
- Preserve evidence links to Phase 23, Phase 32, Phase 33, and Phase 34 artifacts.
- Keep ranking and BSE-Score disabled.
- Export a public JSON Schema.
- Generate a checksummed amendment artifact.
- Validate with targeted tests, full specs test suite, Ruff, and whitespace checks.

## Implementation

Added to `bsebench-specs`:

```text
src/bsebench_specs/phase35_method_panel_amendment.py
scripts/phase35_method_panel_amendment.py
tests/test_phase35_method_panel_amendment.py
schemas/phase35_method_panel_amendment.schema.json
outputs/phase35_method_panel_amendment_20260510.json
```

Updated:

```text
src/bsebench_specs/__init__.py
scripts/export_schemas.py
tests/test_schema_export.py
```

## Amendment Decision

The future executable three-family panel is:

```text
family_1_ecm_classical: EKF_projected
family_2_data_driven_sequence: GRU_light
family_3_nonlinear_observer: SO_SMO
```

The ECM slot retains raw `EKF` identity as the base estimator and applies:

```text
policy_id=phase10-bounded-projection-v1
policy_name=unit_interval_projection
applied_outputs=soc_estimated, soh_estimated
contract_only=true
physical_model_validity_claim=false
```

The contract explicitly blocks:

```text
silent_replacement=false
posthoc_score_selection=false
ranking_authorized_now=false
bse_score_authorized_now=false
```

Score state remains:

```text
blocked_until_amended_rerun_and_loader_accounting
```

## Evidence Chain

The amendment requires and records these evidence kinds:

```text
parent_freeze
raw_ekf_failure_artifact
diagnostic_projection_artifact
ecm_replacement_probe
registry_probe
decision_report
```

Key referenced artifacts:

| Evidence | Artifact |
|---|---|
| Phase 23 freeze | `bsebench-specs/outputs/phase23_method_family_freeze_20260510.json` |
| Phase 32 raw EKF failure | `bsebench-runner/outputs/phase29_real_micro_run_20260510_phase32_tier2_overlay.json` |
| Phase 33 diagnostic projection | `bsebench-runner/outputs/phase33_diagnostic_projection_run_20260510.json` |
| Phase 34 UKF_def probe | `bsebench-runner/outputs/phase34_ukf_def_probe_20260510.json` |
| Phase 34 registry probe | `bsebench-runner/outputs/phase34_default_registry_probe_20260510.json` |
| Phase 34 decision report | `bsebench-async-codex/docs/PHASE_34_ECM_CLAIM_DECISION_2026-05-10.md` |

## Artifact Hashes

| Artifact | SHA-256 |
|---|---|
| `bsebench-specs/outputs/phase35_method_panel_amendment_20260510.json` | `51494790827b495fd1900e8ac0f514179b0f44049fefa938def87781e3df6154` |
| `bsebench-specs/schemas/phase35_method_panel_amendment.schema.json` | `b7c564edbfbfa5b62470af812ce35d76afec2ddb77c2b47df97f942cb91f9bdf` |

## Validation

Executed in `bsebench-specs`:

```bash
uv run pytest tests/test_phase23_method_family_freeze.py tests/test_phase35_method_panel_amendment.py
uv run pytest
uv run ruff check src/bsebench_specs/phase35_method_panel_amendment.py scripts/phase35_method_panel_amendment.py tests/test_phase35_method_panel_amendment.py tests/test_schema_export.py scripts/export_schemas.py src/bsebench_specs/__init__.py
git diff --check
```

Result:

```text
Targeted tests: 17 passed
Full specs suite: 260 passed, 1 skipped
Ruff: All checks passed
git diff --check: clean
```

Secret scan on Phase 35 artifacts found no raw Hugging Face token.

## Scientific Interpretation

Phase 35 converts Phase 34 from an informal engineering decision into a validated, fail-closed research contract. The benchmark may now rerun an amended real micro-slice using `EKF_projected`, but it still cannot claim ranking or BSE-Score until the amended runner execution is recorded and loader blockers are accounted for.

## Next Phase

Phase 36: runner integration and amended micro-run.

Definition of Done:

- add an amended Phase 35/36 panel builder in `bsebench-runner`;
- require the Phase 35 amendment artifact for amended execution;
- produce a real micro-run artifact with `EKF_projected`, `GRU_light`, `SO_SMO`;
- preserve raw `EKF` failure provenance;
- keep ranking and BSE-Score disabled;
- validate with runner tests and record remaining loader blockers.
