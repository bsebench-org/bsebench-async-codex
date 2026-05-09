# Phase 20 Final Closure Report - Sentinel Diagnostics

Date: 2026-05-09

## Executive Verdict

Phase 20 is closed as a diagnostic-only evidence phase.

Overall status:

- Classification: `EVIDENCE_GAP`.
- Claim status: `NO_CLAIM`.
- Scientific ranking verdict: none.
- Release gate: blocked.
- Reason: Phase 19 produced real executed metric rows, but 48 sentinel cells remain and every cross-filter profile-axis panel is incomplete.

Phase 20 did not tune filters, remove sentinels, promote a winner, or repair
the profile-axis claim. It converted the Phase 19 sentinel pattern into
auditable diagnostics and an explicit blocked gate.

## Scope

Phase 20 was opened after Phase 19 proved that the profile-axis execution path
can run real cells but cannot yet support a scientific comparison:

- 160 filter/config metric rows were emitted.
- 112 rows were usable non-sentinel values.
- 48 rows were sentinel values.
- 16/16 configs were blocked for complete-panel inference.
- Friedman/Nemenyi remained blocked with `NO_COMPLETE_CFGS`.

The Phase 20 objective was therefore root-cause triage and evidence gating, not
performance reporting.

## Artifacts

| Repo | Artifact | SHA-256 | Role |
| --- | --- | --- | --- |
| `bsebench-runner` | `outputs/phase20_sentinel_diagnostics_20260509.json` | `7a186ee95306c5ad28924e648c035f5bb54c10792d91156a100442d32f9cfaf4` | Deterministic sentinel matrix and complete-panel blocker audit |
| `bsebench-filters` | `outputs/phase20_filter_sentinel_root_cause_20260509.json` | `ed6013e4e2a9a3d8fdb2c4e07628424f506c04e32a08360ebbf28df5d3340f71` | Filter-side root-cause hypothesis classification |
| `bsebench-filters` | `docs/phase20_filter_sentinel_root_cause_20260509.md` | `db2ee78d23bcf6d5eab4ae24bf31b4f9986b493b86f7bf87106287bf2857e0f6` | Human-readable filter diagnostic report |
| `bsebench-stats` | `outputs/phase20_sentinel_diagnostic_gate_20260509.json` | `9481c58b7d2dcfdfea86a0aaa6acfa771650892de36862e263856d964132f22e` | Stats-side evidence gate preserving the Phase 20 sentinel count |

Source Phase 19 runner artifact:

- `bsebench-runner/outputs/phase19_profile_axis_runner_evidence_20260509.json`
- SHA-256: `e50e77cba3e06e3b034ed2be693e45dda564e1fb82fbc01922ae9066f20d67f5`

## Runner Diagnostic Result

`bsebench-runner` now emits a Phase 20 diagnostic artifact with:

- Schema: `phase20_sentinel_diagnostics_v1`.
- Task: `P20-01`.
- `diagnostic_only=true`.
- `claim_status=NO_CLAIM`.
- `metric_row_count=160`.
- `sentinel_cell_count=48`.
- `non_sentinel_cell_count=112`.
- `filter_count=10`.
- `config_count=16`.
- `complete_config_count=0`.
- `blocked_config_count=16`.
- `panel_status=blocked_no_complete_configs`.

The artifact includes deterministic sentinel and non-sentinel matrices by
config and filter. It also lists complete-panel blockers per config, including
the sentinel filters that prevent a full panel.

Most important blocked cells:

| Config | Sentinel filters | Count |
| --- | --- | ---: |
| `calce_inr_dyn-DST-T25` | `AUKF_SR`, `DUKF`, `EKF`, `EnsembleMeta`, `FO_EKF`, `Hinf`, `ICRPF`, `JUKF_V6B`, `UKF_def` | 9 |
| `calce_a123_dyn-FUDS-T0` | `AUKF_SR`, `DUKF`, `EKF`, `EnsembleMeta`, `FO_EKF`, `Hinf`, `ICRPF`, `UKF_def` | 8 |
| `calce_a123_dyn-US06-T0` | `AUKF_SR`, `DUKF`, `EKF`, `EnsembleMeta`, `FO_EKF`, `Hinf`, `ICRPF`, `UKF_def` | 8 |
| `calce_a123_dyn-DST-T0` | `DUKF`, `EKF`, `EnsembleMeta`, `FO_EKF`, `Hinf`, `ICRPF`, `UKF_def` | 7 |

## Filter Diagnostic Result

`bsebench-filters` now emits a root-cause review artifact with:

- Schema: `phase20_filter_sentinel_root_cause_v1`.
- Task: `P20-02`.
- `diagnostic_only=true`.
- `claim_status=NO_CLAIM`.
- `hypothesis_status=EVIDENCE_BASED_HYPOTHESES_ONLY`.
- `metric_row_count=160`.
- `sentinel_metric_row_count=48`.
- `non_sentinel_metric_row_count=112`.
- `sentinel_rate=0.300`.

The diagnostic hypotheses are deliberately not promoted to claims:

| Cause | Confidence | Classification |
| --- | --- | --- |
| exception/failure sentinel | high | runner evidence |
| low-temp sensitivity | medium | evidence-based hypothesis |
| domain mismatch | medium | evidence-based hypothesis |
| parameter instability | medium | evidence-based hypothesis |
| insufficient complete panel | high | runner evidence |

Filter-level pattern:

| Filter | Sentinel cells |
| --- | ---: |
| `DUKF` | 15/16 |
| `ICRPF` | 9/16 |
| `EKF` | 4/16 |
| `EnsembleMeta` | 4/16 |
| `FO_EKF` | 4/16 |
| `Hinf` | 4/16 |
| `UKF_def` | 4/16 |
| `AUKF_SR` | 3/16 |
| `JUKF_V6B` | 1/16 |
| `SO_SMO` | 0/16 |

Important limitation: `SO_SMO` having no sentinel cells is not a performance
claim. Its non-sentinel absolute errors still require metric-level scrutiny, and
Phase 20 intentionally does not interpret magnitudes as scientific evidence.

Temperature/profile pattern:

- 0 C has the strongest concentration: 24 sentinel cells.
- DST: 20 sentinel cells.
- FUDS: 14 sentinel cells.
- US06: 14 sentinel cells.
- `calce_inr_dyn-DST-T25` is the highest single-cell failure concentration with
  9/10 filters sentinel.

## Stats Gate Result

`bsebench-stats` now emits a Phase 20 gate artifact with:

- Schema: `phase20_sentinel_diagnostic_gate_v1`.
- Input source: `../bsebench-runner/outputs/phase20_sentinel_diagnostics_20260509.json`.
- Source schema: `phase20_sentinel_diagnostics_v1`.
- Classification: `EVIDENCE_GAP`.
- Gate status: `blocked`.
- Claim status: `NO_CLAIM`.
- `metric_row_count=160`.
- `sentinel_cell_count=48`.
- `sentinel_metric_row_count=48`.
- `non_sentinel_metric_row_count=112`.
- `complete_panel_count=0`.
- `incomplete_panel_count=16`.
- `missing_cell_count=48`.
- `panel_status=blocked_no_complete_configs`.

Blocking gap IDs:

- `sentinel_cells_remaining`.
- `sentinel_metric_rows_remaining`.
- `complete_panels_missing`.

The stats integration was hardened during final validation. The first generated
gate could consume the Phase 19 artifact correctly, but when pointed at the new
Phase 20 runner artifact it did not preserve the sentinel count because Phase 20
stores aggregate diagnostics rather than raw `metric_rows`. The gate now reads
`summary` and `complete_panel_blockers` explicitly, preserving the correct
`48` sentinel count and `0` complete panels.

## Validation Log

Runner validation:

```bash
uv run pytest tests/test_phase19_runner_evidence.py tests/test_phase20_sentinel_diagnostics.py -q
uv run ruff check src/bsebench_runner/phase20_sentinel_diagnostics.py scripts/phase20_sentinel_diagnostics.py tests/test_phase20_sentinel_diagnostics.py src/bsebench_runner/__init__.py
uv run ruff format --check src/bsebench_runner/phase20_sentinel_diagnostics.py scripts/phase20_sentinel_diagnostics.py tests/test_phase20_sentinel_diagnostics.py src/bsebench_runner/__init__.py
git diff --check
```

Result: `8 passed`; ruff check passed; format check passed; diff check passed.

Final runner targeted regeneration:

```bash
uv run pytest tests/test_phase20_sentinel_diagnostics.py -q
uv run python scripts/phase20_sentinel_diagnostics.py --input outputs/phase19_profile_axis_runner_evidence_20260509.json --output outputs/phase20_sentinel_diagnostics_20260509.json
```

Result: `3 passed`; artifact regenerated with `48` sentinel cells and
`NO_CLAIM`.

Filters validation:

```bash
uv run pytest tests/test_phase20_filter_sentinel_root_cause.py -q
uv run ruff check src/bsebench_filters/phase20_filter_sentinel_root_cause.py tests/test_phase20_filter_sentinel_root_cause.py scripts/phase20_filter_sentinel_root_cause.py
uv run ruff format --check src/bsebench_filters/phase20_filter_sentinel_root_cause.py tests/test_phase20_filter_sentinel_root_cause.py scripts/phase20_filter_sentinel_root_cause.py
git diff --check
```

Result: `2 passed`; ruff check passed; format check passed; diff check passed.
The worker also ran the full filters suite before final semantic alignment:
`254 passed`.

Stats validation:

```bash
./.venv/bin/pytest tests/test_phase19_profile_axis_metric_evidence.py tests/test_phase20_sentinel_diagnostic_gate.py -q
./.venv/bin/ruff check src/bsebench_stats/phase20_sentinel_diagnostic_gate.py scripts/phase20_sentinel_diagnostic_gate.py tests/test_phase20_sentinel_diagnostic_gate.py src/bsebench_stats/__init__.py
./.venv/bin/ruff format --check src/bsebench_stats/phase20_sentinel_diagnostic_gate.py scripts/phase20_sentinel_diagnostic_gate.py tests/test_phase20_sentinel_diagnostic_gate.py src/bsebench_stats/__init__.py
git diff --check
```

Result: `19 passed`; ruff check passed; format check passed; diff check passed.

Final stats targeted validation after regenerating from the Phase 20 runner
artifact:

```bash
./.venv/bin/python scripts/phase20_sentinel_diagnostic_gate.py ../bsebench-runner/outputs/phase20_sentinel_diagnostics_20260509.json --output outputs/phase20_sentinel_diagnostic_gate_20260509.json
./.venv/bin/pytest tests/test_phase20_sentinel_diagnostic_gate.py -q
```

Result: script exited `2` as expected for a blocked gate; `8 passed`.

## Scientific Interpretation

What Phase 20 supports:

- There are 48 sentinel rows in the executed Phase 19 profile-axis evidence.
- The sentinel rows are not uniformly distributed.
- `DUKF` and `ICRPF` are the largest filter-level contributors.
- 0 C conditions are overrepresented among sentinel rows.
- Every config is incomplete for cross-filter panel inference.
- A valid ranking or winner claim is impossible from the current panel.

What Phase 20 does not support:

- No filter is declared superior.
- No leaderboard is valid.
- No robustness claim is valid.
- No failure cause is proven mechanistically for each sentinel cell.
- No remediation is validated.

The main scientific blocker is not only the sentinel count. It is the absence of
per-step exception/divergence traces. Phase 20 can classify patterns and
hypotheses, but it cannot yet distinguish numerical divergence, model-domain
mismatch, covariance collapse, parameter drift, or implementation exceptions at
the individual time-step level.

## Lessons Learned

1. Aggregated diagnostic artifacts need explicit downstream contracts.
   The stats gate initially handled Phase 19 raw rows better than Phase 20
   aggregate diagnostics. That gap is now patched, but future diagnostic phases
   should define source compatibility at the schema boundary.

2. Sentinel-free is not automatically scientifically good.
   A filter can avoid sentinel assignment while still producing high absolute
   errors. Sentinel diagnostics are a readiness gate, not a ranking metric.

3. Low-temperature and domain-shift axes deserve first-class instrumentation.
   The 0 C concentration and `calce_inr_dyn-DST-T25` spike are too structured
   to treat as random noise, but Phase 20 cannot prove the mechanism.

4. Post-hoc filter subset selection is unsafe.
   Any future subset or exclusion rule must be pre-registered before evaluating
   a new result panel.

5. The correct next technical move is trace instrumentation, not claim writing.
   The next phase should capture per-cell and per-step failure reasons before
   any remediation attempt is presented as evidence.

## Roadmap State

The formal roadmap documents in this repository describe Phase 7 through Phase
17 as the original discovery roadmap. Phases 18, 19, and 20 were user-opened
evidence/diagnostic continuation phases around the profile-axis claim.

No Phase 21+ task graph is currently authorized in-repo. If work continues, the
recommended next phase is:

Phase 21 - Per-Step Sentinel Trace Instrumentation

Purpose:

- add deterministic per-step failure traces for sentinel cells;
- capture exception class, time index, filter state summary, covariance sanity,
  residual magnitude, and termination reason;
- rerun only the blocked Phase 19/20 profile-axis cells first;
- keep the gate at `NO_CLAIM` until a complete, non-sentinel panel exists.

## Closure

Phase 20 is complete as a diagnostic closure phase.

Final verdict: `EVIDENCE_GAP`, `NO_CLAIM`, gate blocked.

The project is on the right trajectory only if the next work attacks the
mechanistic failure evidence. Moving directly into claims, rankings, or
publication wording from Phase 20 would be a trajectory error.
