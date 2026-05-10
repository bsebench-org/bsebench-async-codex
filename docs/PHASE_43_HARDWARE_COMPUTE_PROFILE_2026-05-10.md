# Phase 43 Hardware Compute Profile

Date: 2026-05-10
Status: CLOSED
Runner commit: `b6d28d0`
Claim status: `NO_CLAIM`

## Objective

Close the Phase 41 compute blockers:

```text
compute_cost.ram_mb
compute_cost.cpu_percent
compute_cost.gpu
```

without re-authorizing the final BSE-Score while state truth remains incomplete.

## Definition Of Done

- Rerun the Phase 39 micro-panel inside a process-level hardware envelope.
- Measure RSS RAM in MB.
- Measure CPU percent from process CPU time over wall time.
- Declare and probe GPU policy.
- Keep ranking and BSE-Score disabled.
- Emit a machine-readable artifact.
- Validate with tests, Ruff, whitespace check, and secret scan.

## Implementation

Added to `bsebench-runner`:

```text
src/bsebench_runner/phase43_hardware_compute_profile.py
scripts/phase43_hardware_compute_profile.py
tests/test_phase43_hardware_compute_profile.py
outputs/phase43_hardware_compute_profile_20260510.json
```

The profiler wraps a real Phase 39 micro-panel rerun and records:

```text
RSS current and peak via /proc/self/statm plus getrusage(ru_maxrss)
CPU percent via 100 * process_cpu_time_ns / wall_elapsed_ns
GPU policy via nvidia-smi if present, otherwise explicit CPU-only policy
```

## Real Run

Command:

```bash
export BSEBENCH_CALCE_A123_DYN_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase9-local-cache/calce_a123_dyn_20260509
export BSEBENCH_CALCE_INR_DYN_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase9-local-cache/calce_inr_dyn_20260509
export BSEBENCH_PANASONIC_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase32-local-cache/panasonic_tier2_20260510
export BSEBENCH_LG_HG2_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase32-local-cache/lg_hg2_tier2_20260510
export BSEBENCH_YAO_CACHE_ROOT=/mnt/c/doctorat/bsebench-org/.phase32-local-cache/yao_tier2_20260510

uv run python scripts/phase43_hardware_compute_profile.py \
  --output outputs/phase43_hardware_compute_profile_20260510.json \
  --resolved-micro-slice-manifest outputs/phase37_resolved_micro_slice_20260510.json \
  --checkpoints-dir data/audit_j_v1/checkpoints \
  --amendment-artifact ../bsebench-specs/outputs/phase35_method_panel_amendment_20260510.json \
  --score-readiness-gate outputs/phase38_score_readiness_gate_20260510.json \
  --phase42-state-truth-policy outputs/phase42_state_truth_policy_20260510.json \
  --n-max 32
```

Result:

```text
status=hardware_compute_profile_completed
ram=available
cpu=available
gpu=available
bse_score_authorized=False
```

## Execution Evidence

Phase 39 rerun:

```text
cell_count=18
failure_trace_count=0
filters=EKF_projected, GRU_light, SO_SMO
configs=6 resolved configs
```

Resolved configs:

```text
calce_a123_dyn-DST-T20
panasonic-US06-T10
nasa-CC-discharge-T24
lg_hg2-WLTC_P066-T25
yao-BCDC-T35
calce_inr_dyn-DST-T25
```

System:

```text
platform=Linux
node=ECOFIXE20
cpu_count=16
```

## Hardware KPIs

RAM:

```text
status=available
unit=MB_RSS
start_rss_mb=151.1640625
end_rss_mb=406.48046875
delta_rss_mb=255.31640625
peak_rss_mb=419.140625
```

CPU:

```text
status=available
process_cpu_time_ns=7521560900
wall_elapsed_ns=11431808182
one_core_percent=65.79502367650906
host_normalized_percent=4.112188979781816
cpu_count=16
```

GPU:

```text
status=available
policy=cpu_only
nvidia_smi_available=False
gpu_present=False
gpu_device_count=0
utilization_gpu_percent=None
memory_used_mb=None
```

## Score Policy

Compute claims now authorized:

```text
hardware_compute_kpis_authorized=True
ram_mb_claim_authorized=True
cpu_percent_claim_authorized=True
gpu_policy_claim_authorized=True
```

Still disabled:

```text
ranking_authorized=False
bse_score_authorized=False
final_score_still_blocked_by_phase42=True
```

Remaining blockers:

```text
bse_score_weights_not_frozen
dataset_loader_truth_pass_through_required
normalization_policy_not_frozen
reduced_panel_score_policy_not_frozen
soc_truth_not_complete_across_resolved_panel
soh_truth_not_complete_across_resolved_panel
state_max_error_not_authorized_until_state_metrics_rerun
state_truth_derivation_policies_not_frozen
tier2_truth_reharmonization_required
```

## Artifact Hash

| Artifact | SHA-256 |
|---|---|
| `bsebench-runner/outputs/phase43_hardware_compute_profile_20260510.json` | `599119937d8188a2d9fc459bde816b15d7d10024b4b127a800b8f197e69c197e` |

## Validation

Executed in `bsebench-runner`:

```bash
uv run pytest tests/test_phase43_hardware_compute_profile.py tests/test_phase42_state_truth_policy.py tests/test_orchestrator.py
uv run ruff check src/bsebench_runner/orchestrator.py src/bsebench_runner/phase42_state_truth_policy.py src/bsebench_runner/phase43_hardware_compute_profile.py scripts/phase42_state_truth_policy.py scripts/phase43_hardware_compute_profile.py tests/test_orchestrator.py tests/test_phase42_state_truth_policy.py tests/test_phase43_hardware_compute_profile.py
git diff --check
rg -n "hf_[A-Za-z0-9]{20,}" . --glob '!uv.lock' --glob '!**/.venv/**' --glob '!outputs/phase31_hf_access_proof_*.json'
```

Result:

```text
19 passed
Ruff: All checks passed
git diff --check: clean
TOKEN_SCAN=OK
```

## Publication Note

Local runner commits now ahead of origin:

```text
df8fa6d GLASSBOX add Phase 42 state truth policy
b6d28d0 GLASSBOX add Phase 43 hardware compute profile
```

Push remains blocked by local WSL/GitHub HTTPS credential input. The commits are local and ready to publish once credentials are restored.

## Scientific Interpretation

Phase 43 removes the compute-cost blocker for the current micro-panel. It does not remove state-truth blockers and does not authorize a final BSE-Score. This is the correct separation: compute measurement is now empirical; scoring remains gated by truth, normalization, and reduced-panel policy.

## Next Path

Phase 44:

```text
Repair admissible truth exposure:
1. Yao raw SOC -> Tier 2 soc_truth -> loader output.
2. NASA SOH truth -> loader output.
```

Phase 45:

```text
Rerun a truth-aware panel/subset and emit SOC/SOH/max-error metrics only where truth and estimates overlap.
```

Phase 46:

```text
Freeze BSE-Score formula, weights, normalization, and denominator policy before any ranking.
```
