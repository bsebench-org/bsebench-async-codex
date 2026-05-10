# Phase 42 State Truth Policy

Date: 2026-05-10
Status: CLOSED
Runner commit: `df8fa6d`
Claim status: `NO_CLAIM`

## Objective

Resolve the state-truth question behind the blocked precision KPIs:

```text
Can the current resolved six-config panel support SOC/SOH accuracy and state max error now?
```

Answer:

```text
No.
```

But Phase 42 establishes the recovery path precisely, without inventing truth labels.

## Definition Of Done

- Extend the runner truth-key contract to accept canonical Tier 2 names:
  `soc_truth` and `soh_truth`.
- Audit every resolved Phase 37 config for admissible SOC/SOH truth.
- Distinguish direct truth, recoverable truth, derivation candidates, and inadmissible estimates.
- Keep SOC/SOH accuracy, max state error, ranking, and BSE-Score disabled until a rerun proves overlap between truth and method estimates.
- Emit a machine-readable artifact.
- Validate with tests, Ruff, whitespace check, and secret scan.

## Implementation

Added to `bsebench-runner`:

```text
src/bsebench_runner/phase42_state_truth_policy.py
scripts/phase42_state_truth_policy.py
tests/test_phase42_state_truth_policy.py
outputs/phase42_state_truth_policy_20260510.json
```

Patched:

```text
src/bsebench_runner/orchestrator.py
tests/test_orchestrator.py
```

The orchestrator now recognizes these canonical truth columns:

```text
SOC: soc_truth, SOC_truth
SOH: soh_truth, SOH_truth
```

## Real Run

Command:

```bash
uv run python scripts/phase42_state_truth_policy.py \
  --output outputs/phase42_state_truth_policy_20260510.json \
  --phase41-ledger outputs/phase41_score_contract_gap_ledger_20260510.json \
  --resolved-micro-slice-manifest outputs/phase37_resolved_micro_slice_20260510.json \
  --nasa-cache-root /mnt/c/doctorat/bsebench-org/.phase10-local-cache/nasa_pcoe_b0005_20260509 \
  --yao-raw-root /mnt/c/doctorat/bsebench-org/.phase32-local-cache/yao_raw_20260510/extracted \
  --yao-tier2-root /mnt/c/doctorat/bsebench-org/.phase32-local-cache/yao_tier2_20260510 \
  --panasonic-raw-root /mnt/c/doctorat/bsebench-org/.phase32-local-cache/panasonic_raw_structured_20260510 \
  --lg-hg2-raw-root /mnt/c/doctorat/bsebench-org/.phase32-local-cache/lg_hg2_raw_20260510 \
  --calce-a123-tier2-root /mnt/c/doctorat/bsebench-org/.phase9-local-cache/calce_a123_dyn_20260509 \
  --calce-inr-tier2-root /mnt/c/doctorat/bsebench-org/.phase9-local-cache/calce_inr_dyn_20260509
```

Result:

```text
status=state_truth_policy_partial_recovery_path_defined
soc_recoverable=1/6
soh_recoverable=1/6
bse_score_authorized=False
```

## Dataset Verdict

| Config | SOC truth status | SOH truth status | Decision |
|---|---|---|---|
| `calce_a123_dyn:DST:T20` | `blocked_initial_soc_not_available` | `blocked_no_soh_trace_truth_identified` | Exclude from state scoring unless auditable truth is sourced. |
| `panasonic:US06:T10` | `candidate_ah_derived_soc_not_authorized` | `blocked_no_soh_trace_truth_identified` | Possible Ah-derived SOC, but not truth until capacity/sign/reset policy is frozen. |
| `nasa:CC-discharge:T24` | `blocked_no_finite_values` | `available_loader_pass_through_required` | SOH truth exists; local SOC truth column exists but has no finite values. |
| `lg_hg2:WLTC_P066:T25` | `blocked_bms_soc_estimate_not_ground_truth` | `blocked_no_soh_trace_truth_identified` | `soc_est` is an estimate, not admissible benchmark truth. |
| `yao:BCDC:T35` | `recoverable_raw_direct_soc_tier2_reharmonization_required` | `blocked_no_soh_source_identified` | Raw SOC is direct and finite, but Tier 2 dropped it. |
| `calce_inr_dyn:DST:T25` | `candidate_initial_soc_coulomb_counting_not_authorized` | `blocked_no_soh_trace_truth_identified` | Initial SOC is encoded, full SOC trace requires frozen derivation policy. |

## Score Policy

Still disabled:

```text
soc_accuracy_authorized=False
soh_accuracy_authorized=False
state_max_error_authorized=False
ranking_authorized=False
bse_score_authorized=False
```

Blocking gaps:

```text
soc_truth_not_complete_across_resolved_panel
soh_truth_not_complete_across_resolved_panel
state_max_error_not_authorized_until_state_metrics_rerun
dataset_loader_truth_pass_through_required
tier2_truth_reharmonization_required
state_truth_derivation_policies_not_frozen
```

## Artifact Hash

| Artifact | SHA-256 |
|---|---|
| `bsebench-runner/outputs/phase42_state_truth_policy_20260510.json` | `d1a4d4461d683f2a82b8bc6b538fd72534478371324298c0ddcb7772a70076b1` |

## Validation

Executed in `bsebench-runner`:

```bash
uv run pytest tests/test_orchestrator.py tests/test_phase42_state_truth_policy.py
uv run ruff check src/bsebench_runner/orchestrator.py src/bsebench_runner/phase42_state_truth_policy.py scripts/phase42_state_truth_policy.py tests/test_orchestrator.py tests/test_phase42_state_truth_policy.py
git diff --check
rg -n "hf_[A-Za-z0-9]{20,}" . --glob '!uv.lock' --glob '!**/.venv/**' --glob '!outputs/phase31_hf_access_proof_*.json'
```

Result:

```text
15 passed
Ruff: All checks passed
git diff --check: clean
TOKEN_SCAN=OK
```

## Publication Note

Local runner commit exists:

```text
df8fa6d GLASSBOX add Phase 42 state truth policy
```

Push via local HTTPS failed because WSL/GitHub credential input is unavailable:

```text
fatal: could not read Username for 'https://github.com': No such device or address
```

The work is committed locally and ready to push once credentials are restored.

## Scientific Interpretation

Phase 42 closes the ambiguity around the state metrics. The blocker is not missing runner plumbing anymore; it is the truth source contract. We can compute SOC error only after Yao Tier 2 is repaired and the benchmark is rerun. We can compute SOH error only on NASA unless additional SOH truth sources or method outputs are introduced. A final all-panel BSE-Score remains scientifically unauthorized.

## Next Path

Phase 43:

```text
Instrument fixed-hardware compute KPIs: RSS RAM MB, CPU percent, and explicit GPU policy/usage.
```

Phase 44:

```text
Repair source truth exposure where admissible: Yao SOC Tier 2 pass-through and NASA SOH loader pass-through.
```

Phase 45:

```text
Rerun the resolved panel or a formally labeled truth subset, then compute state max error only for cells with valid truth and estimates.
```

Phase 46:

```text
Freeze score weights, normalization, denominator policy, and reduced-panel labeling before any BSE-Score or ranking.
```
