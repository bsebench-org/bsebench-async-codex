#!/usr/bin/env bash
# cto-emergency-capacity.sh - direct product-repo Codex fallback.
#
# This is the last-resort path for the supervisor when async queues are blocked
# or stale STATUS.json rows claim work while no real codex exec workdirs exist.
# It launches useful, disjoint product tasks in real BSEBench repositories.

set -euo pipefail

export PATH="/home/oakir/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

ROOT="${BSEBENCH_ROOT:-/mnt/c/doctorat/bsebench-org}"
STATE_DIR="${STATE_DIR:-/home/oakir/.local/state/bsebench-async-watchdog}"
MIN_PRODUCT_CODEX_EXEC="${MIN_PRODUCT_CODEX_EXEC:-4}"
MAX_PRODUCT_LAUNCH="${MAX_PRODUCT_LAUNCH:-6}"
MODEL="${MODEL:-gpt-5.5}"
REASONING="${REASONING:-high}"
LOCK_FILE="$STATE_DIR/emergency-capacity.lock"
LOG_FILE="$STATE_DIR/emergency-capacity.log"

mkdir -p "$STATE_DIR"

log() {
  printf '[%s] %s\n' "$(date -Is)" "$*" | tee -a "$LOG_FILE"
}

unique_codex_workdirs() {
  python3 - "$ROOT" <<'PY'
import shlex
import subprocess
import sys

root = sys.argv[1]
proc = subprocess.run(
    ["pgrep", "-af", r"codex exec|/usr/bin/codex|@openai/codex"],
    text=True,
    capture_output=True,
    check=False,
)
seen = []
for line in proc.stdout.splitlines():
    if any(marker in line for marker in ("pgrep", "cto-emergency-capacity", "cto-supervisor-10h")):
        continue
    try:
        parts = shlex.split(line)
    except ValueError:
        parts = line.split()
    workdir = None
    for idx, token in enumerate(parts):
        if token in ("-C", "--cd") and idx + 1 < len(parts):
            workdir = parts[idx + 1]
            break
    if workdir and root in workdir and workdir not in seen:
        seen.append(workdir)
for workdir in seen:
    print(workdir)
PY
}

launch_product_task() {
  local repo="$1"
  local suffix="$2"
  local role="$3"
  local owned="$4"
  local objective="$5"
  local ts branch base wt run_log prompt pid

  ts="$(date +%Y%m%dT%H%M%S%z)"
  branch="phase-8-emergency-${suffix}-${ts}"
  base="$ROOT/$repo"
  wt="$ROOT/${repo}-${branch}"
  run_log="$STATE_DIR/manual-${repo}-${branch}.log"

  if [[ ! -d "$base/.git" ]] ; then
    log "SKIP missing repo=$repo"
    return 1
  fi

  git -C "$base" fetch origin main --quiet
  git -C "$base" worktree add -q -b "$branch" "$wt" origin/main

  prompt=$(printf '%s\n' \
"You are a BSEBench emergency product worker in repository ${repo}. This is real product work, not orchestration documentation." \
"Mission: advance BSEBench toward a universal SOC/SOH benchmark for filters, ECMs, observers, and AI estimators." \
"Rules: no Co-Authored-By Claude. Commit subject must start exactly: GLASSBOX [role: ${role}]" \
"Protected: do not edit /mnt/c/doctorat/these_lfp_2026, claims/registry.yaml, claim_55, manuscript, roadmap, or other repos. Do not revert unrelated changes." \
"Owned scope in ${repo}: ${owned}" \
"Objective: ${objective}" \
"Implementation expectations: inspect existing code/tests first; add focused production code and tests; fail closed on missing provenance/evidence; avoid unsupported SOTA/novelty/leaderboard claims; do not invent datasets/results." \
"Validation: run focused tests for your files plus ruff/format/diff checks if available. Commit and push to origin/${branch}." \
"Final response: branch, commit SHA, files changed, validation commands/results, residual risks.")

  printf '%s\n' "$prompt" |
    nohup timeout --kill-after=30s 14400s codex exec --dangerously-bypass-approvals-and-sandbox \
      -c "model=\"${MODEL}\"" \
      -c "model_reasoning_effort=\"${REASONING}\"" \
      -C "$wt" \
      --add-dir "$ROOT/bsebench-runner" \
      --add-dir "$ROOT/bsebench-stats" \
      --add-dir "$ROOT/bsebench-datasets" \
      --add-dir "$ROOT/bsebench-filters" \
      --add-dir "$ROOT/bsebench-specs" \
      > "$run_log" 2>&1 &
  pid="$!"
  log "LAUNCHED repo=$repo branch=$branch pid=$pid log=$run_log"
}

main() {
  local before needed launched
  mapfile -t before < <(unique_codex_workdirs)
  if [[ "${#before[@]}" -ge "$MIN_PRODUCT_CODEX_EXEC" ]] ; then
    log "NOOP active_codex=${#before[@]} min=$MIN_PRODUCT_CODEX_EXEC"
    return 0
  fi

  needed=$((MIN_PRODUCT_CODEX_EXEC - ${#before[@]}))
  if [[ "$needed" -gt "$MAX_PRODUCT_LAUNCH" ]] ; then
    needed="$MAX_PRODUCT_LAUNCH"
  fi

  log "EMERGENCY_CAPACITY active_codex=${#before[@]} min=$MIN_PRODUCT_CODEX_EXEC launch_target=$needed"
  launched=0

  while [[ "$launched" -lt "$needed" ]] ; do
    case "$launched" in
      0) launch_product_task bsebench-runner "runner-estimator-contract" "emergency-runner-contract" "src/bsebench_runner/estimator_contract.py tests/test_estimator_contract.py" "Implement or harden the plug-and-play estimator contract for step(voltage,current,temp,dt) outputs and SOC/SOH state validation." ;;
      1) launch_product_task bsebench-stats "stats-universal-metrics" "emergency-stats-metrics" "src/bsebench_stats/universal_metrics.py tests/test_universal_metrics.py" "Implement or harden universal benchmark metrics: RMSE, MAE, MAXE, convergence, and finite-value guards." ;;
      2) launch_product_task bsebench-datasets "datasets-leakage-guard" "emergency-datasets-leakage" "src/bsebench_datasets/leakage_guard.py tests/test_leakage_guard.py" "Implement or harden calibration-vs-blind-evaluation split leakage detection." ;;
      3) launch_product_task bsebench-filters "filters-contract-compliance" "emergency-filters-contract" "src/bsebench_filters/contract.py tests/test_universal_contract_compliance.py" "Implement or harden a thin compliance layer mapping existing filters to the universal estimator contract without changing filter math." ;;
      4) launch_product_task bsebench-specs "specs-universal-run-schema" "emergency-specs-schema" "schemas/universal_run.schema.json src/bsebench_specs/universal_run.py tests/test_universal_run_schema.py" "Implement or harden the universal benchmark run/submission schema for estimator identity, split, metrics, provenance, and validation state." ;;
      *) launch_product_task bsebench-runner "runner-compute-profile" "emergency-runner-compute" "src/bsebench_runner/compute_profile.py tests/test_compute_profile.py" "Implement or harden lightweight runtime and memory profiling utilities for benchmark execution." ;;
    esac
    launched=$((launched + 1))
  done
}

(
  flock -n 9 || {
    log "SKIP emergency capacity already running"
    exit 0
  }
  main
) 9>"$LOCK_FILE"
