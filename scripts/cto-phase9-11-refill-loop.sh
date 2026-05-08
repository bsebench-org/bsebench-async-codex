#!/usr/bin/env bash
# Maintain Codex capacity using Phase 9/10/11-only work until checkpoint closure.

set -uo pipefail

ROOT="${BSEBENCH_ROOT:-/mnt/c/doctorat/bsebench-org}"
STATE_DIR="${STATE_DIR:-/home/oakir/.local/state/bsebench-async-watchdog}"
TARGET_CODEX="${TARGET_CODEX:-18}"
INTERVAL_SECONDS="${INTERVAL_SECONDS:-60}"
REPORT_SECONDS="${REPORT_SECONDS:-900}"
MODEL="${MODEL:-gpt-5.5}"
REASONING="${REASONING:-xhigh}"
LOCK_FILE="$STATE_DIR/phase9-11-refill.lock"
LOG_FILE="$STATE_DIR/phase9-11-refill.log"
REPORT_FILE="$STATE_DIR/phase9-11-checkpoint-status.md"
TASK_INDEX_FILE="$STATE_DIR/phase9-11-refill.index"

mkdir -p "$STATE_DIR"

log() {
  printf '[%s] %s\n' "$(date -Is)" "$*" | tee -a "$LOG_FILE"
}

unique_workdirs() {
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
    if any(x in line for x in ("pgrep", "cto-phase9-11-refill-loop")):
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

real_upload_count() {
  ps -eo comm=,args= |
    awk '$1 != "bash" && $1 != "awk" && ($0 ~ /\.hf-upload-stage|hf-upload-stage/ || ($0 ~ /huggingface-cli/ && $0 ~ / upload/)) {n++} END {print n + 0}'
}

task_spec() {
  local idx="$1"
  case "$idx" in
    0) printf '%s\t%s\t%s\n' "bsebench-datasets" "p9-tier2-profile-cache" "Phase 9 profile-axis Tier2 cache/provenance audit: add or harden read-only local evidence checks and exact remediation instructions. Owned paths should be new or existing profile-axis cache/audit files plus focused tests." ;;
    1) printf '%s\t%s\t%s\n' "bsebench-datasets" "p10-tier2-aging-cache" "Phase 10 aging/SOH Tier2 cache/provenance audit: add or harden local evidence checks for SOH/aging bins, splits, and ground-truth metadata. No downloads/uploads." ;;
    2) printf '%s\t%s\t%s\n' "bsebench-datasets" "p11-tier2-residual-cache" "Phase 11 residual Tier2 cache/unit/cadence audit: validate voltage/current/timebase/unit/cadence evidence from local loader-facing files only; fail closed." ;;
    3) printf '%s\t%s\t%s\n' "bsebench-runner" "p9-profile-empirical-scheduler" "Phase 9 empirical scheduler: consume profile-axis readiness, refuse all-blocked matrices, emit runnable jobs only with cache/provenance ready evidence." ;;
    4) printf '%s\t%s\t%s\n' "bsebench-runner" "p10-aging-empirical-scheduler" "Phase 10 aging/SOH empirical scheduler: consume aging readiness, block split/provenance gaps, emit exact dry-run jobs only." ;;
    5) printf '%s\t%s\t%s\n' "bsebench-runner" "p11-residual-trace-scheduler" "Phase 11 residual trace scheduler: consume residual readiness, require unit/cadence/component evidence, and refuse missing provenance." ;;
    6) printf '%s\t%s\t%s\n' "bsebench-stats" "p9-profile-verdict-inputs" "Phase 9 verdict-input validator: require real profile empirical artifacts, metrics, source-ledger IDs, and forbid synthetic-only evidence for scientific verdicts." ;;
    7) printf '%s\t%s\t%s\n' "bsebench-stats" "p10-aging-verdict-inputs" "Phase 10 verdict-input validator: require real aging/SOH artifacts, aging bins, split integrity, chemistry/SOH evidence, and provenance." ;;
    8) printf '%s\t%s\t%s\n' "bsebench-stats" "p11-residual-verdict-inputs" "Phase 11 verdict-input validator: require residual traces with sensor-noise/model-mismatch components, units, cadence, and finite metrics." ;;
    9) printf '%s\t%s\t%s\n' "bsebench-specs" "p9-11-schema-export-audit" "Phase 9/10/11 schema export audit: verify profile-axis, aging/SOH, residual schemas/exporter/tests are aligned; add fail-closed schema tests if needed." ;;
    10) printf '%s\t%s\t%s\n' "bsebench-filters" "p9-11-contract-export-audit" "Phase 9/10/11 filter contract audit: verify smoke/degraded-init/residual-output contracts and exports; add focused fail-closed tests if needed." ;;
    11) printf '%s\t%s\t%s\n' "bsebench-async-codex" "p9-11-checkpoint-report" "Phase 9/10/11 checkpoint report: consolidate current evidence, blocker table, GO/NO-GO, percent complete, and next executable task queue. Async repo only." ;;
    12) printf '%s\t%s\t%s\n' "bsebench-async-codex" "p9-11-merge-matrix" "Phase 9/10/11 merge matrix: list branch SHAs, validation state, merge order, conflicts, and blockers. Async repo only; do not merge." ;;
    13) printf '%s\t%s\t%s\n' "bsebench-async-codex" "p9-11-anti-claim-audit" "Phase 9/10/11 anti-claim audit: identify every unsupported closure/performance/SOTA claim and required evidence to unblock it. Async repo only." ;;
    14) printf '%s\t%s\t%s\n' "bsebench-datasets" "p9-11-local-path-discovery" "Phase 9/10/11 local path discovery: inspect existing local directories for candidate Tier2 files and produce read-only mapping/report plus tests; do not download/upload." ;;
    15) printf '%s\t%s\t%s\n' "bsebench-runner" "p9-11-dryrun-cli-smoke" "Phase 9/10/11 dry-run CLI smoke: add or harden tiny fixture smoke tests for profile/aging/residual dry-run schedulers without executing expensive filters." ;;
    16) printf '%s\t%s\t%s\n' "bsebench-stats" "p9-11-no-claims-linter" "Phase 9/10/11 no-claims linter: add or harden validation rejecting leaderboard/SOTA/winner wording unless source-ledger and empirical verdict evidence are present." ;;
    *) printf '%s\t%s\t%s\n' "bsebench-async-codex" "p9-11-acceptance-gate" "Phase 9/10/11 acceptance gate: define explicit closure criteria and machine-readable checklist for tooling complete vs scientific closure. Async repo only." ;;
  esac
}

launch_one() {
  local idx repo slug objective ts branch base wt run_log prompt
  idx="$(cat "$TASK_INDEX_FILE" 2>/dev/null || printf '0')"
  idx=$((idx % 18))
  IFS=$'\t' read -r repo slug objective < <(task_spec "$idx")
  printf '%s\n' "$((idx + 1))" > "$TASK_INDEX_FILE"

  ts="$(date +%Y%m%dT%H%M%S%z)"
  branch="phase9-11-refill-${slug}-${ts}"
  base="$ROOT/$repo"
  wt="$ROOT/${repo}-${branch}"
  run_log="$STATE_DIR/${repo}-${branch}.log"

  if [[ ! -d "$base/.git" ]]; then
    log "SKIP missing repo=$repo"
    return 1
  fi
  if [[ -d "$wt" ]]; then
    log "SKIP existing worktree=$wt"
    return 1
  fi

  if ! git -C "$base" worktree add -q -b "$branch" "$wt" HEAD >> "$LOG_FILE" 2>&1; then
    log "LAUNCH_FAIL repo=$repo branch=$branch step=worktree_add"
    return 1
  fi
  prompt=$(printf '%s\n' \
"You are a BSEBench Phase 9/10/11 closure worker. Do not work on Phase 12/13 or later." \
"Objective: $objective" \
"Rules: no Co-Authored-By Claude. Commit subject must start with GLASSBOX. No Hugging Face uploads, no dataset downloads, no thesis edits, no roadmap edits, no claim-registry edits, no claim_55 edits." \
"Scientific integrity: do not declare Phase 9/10/11 complete unless evidence supports it. Fail closed on missing cache/provenance/Tier2/source-ledger/empirical-run evidence. No SOTA, novelty, winner, or leaderboard claims." \
"Implementation: inspect existing code/tests first, keep scope narrow, add focused tests, run ruff/format/diff checks available in this repo." \
"Output: commit and push origin/$branch if possible. Final response must include commit SHA, files changed, validation results, and blockers.")

  printf '%s\n' "$prompt" |
    nohup timeout --kill-after=30s 7200s codex exec --dangerously-bypass-approvals-and-sandbox \
      -c "model=\"${MODEL}\"" \
      -c "model_reasoning_effort=\"${REASONING}\"" \
      -C "$wt" \
      --add-dir "$ROOT/bsebench-runner" \
      --add-dir "$ROOT/bsebench-stats" \
      --add-dir "$ROOT/bsebench-datasets" \
      --add-dir "$ROOT/bsebench-specs" \
      --add-dir "$ROOT/bsebench-filters" \
      --add-dir "$ROOT/bsebench-async-codex" \
      > "$run_log" 2>&1 &
  local pid="$!"
  log "LAUNCHED repo=$repo branch=$branch pid=$pid log=$run_log"
}

write_report() {
  local active uploads
  mapfile -t workdirs < <(unique_workdirs)
  active="${#workdirs[@]}"
  uploads="$(real_upload_count)"
  {
    printf '## Phase 9/10/11 Checkpoint Status - %s\n\n' "$(date -Is)"
    printf -- '- Active unique Codex workdirs: `%s` / target `%s`\n' "$active" "$TARGET_CODEX"
    printf -- '- Real HF upload processes: `%s`\n' "$uploads"
    printf -- '- Scope lock: Phase 9/10/11 only until validation checkpoint closes.\n'
    printf -- '- Scientific status: tooling may be integrated, but closure remains NO-GO until cache/provenance/Tier2 empirical evidence passes.\n\n'
    printf '### Active Workdirs\n\n'
    printf -- '- `%s`\n' "${workdirs[@]}"
  } > "$REPORT_FILE"
  cat "$REPORT_FILE" >> "$LOG_FILE"
}

tick() {
  local active uploads needed i
  mapfile -t workdirs < <(unique_workdirs)
  active="${#workdirs[@]}"
  uploads="$(real_upload_count)"
  log "TICK active=$active target=$TARGET_CODEX uploads=$uploads"
  if [[ "$uploads" -gt 0 ]]; then
    log "UPLOAD_GUARD uploads=$uploads action=do_not_launch_uploads"
  fi
  if [[ "$active" -lt "$TARGET_CODEX" ]]; then
    needed=$((TARGET_CODEX - active))
    i=0
    while [[ "$i" -lt "$needed" ]]; do
      launch_one || true
      i=$((i + 1))
    done
  fi
}

main() {
  local last_report=0 now
  log "START phase9-11-only target=$TARGET_CODEX interval=$INTERVAL_SECONDS report=$REPORT_SECONDS"
  while true; do
    now="$(date +%s)"
    tick
    if [[ $((now - last_report)) -ge "$REPORT_SECONDS" ]]; then
      write_report
      last_report="$now"
    fi
    sleep "$INTERVAL_SECONDS"
  done
}

(
  flock -n 9 || exit 0
  main
) 9>"$LOCK_FILE"
