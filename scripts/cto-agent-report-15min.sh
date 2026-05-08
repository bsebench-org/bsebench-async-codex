#!/usr/bin/env bash
# cto-agent-report-15min.sh - 15 minute CTO snapshot with progress deltas.

set -euo pipefail

export PATH="/home/oakir/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

ROOT="${BSEBENCH_ROOT:-/mnt/c/doctorat/bsebench-org}"
STATE_DIR="${STATE_DIR:-/home/oakir/.local/state/bsebench-async-watchdog}"
REPORT_DIR="$STATE_DIR/reports"
CURRENT="$REPORT_DIR/latest-agent-report.md"
PREVIOUS_JSON="$REPORT_DIR/latest-progress.json"
LOG_FILE="$STATE_DIR/agent-report-15min.log"
REPORT_SCHEMA_VERSION="product-worktree-v2"

mkdir -p "$REPORT_DIR"

phase_total() {
  case "$1" in
    phase-7) echo 45 ;;
    phase-8) echo 50 ;;
    phase-9) echo 40 ;;
    phase-10) echo 40 ;;
    phase-11) echo 40 ;;
    phase-12) echo 40 ;;
    phase-13) echo 40 ;;
    phase-14) echo 35 ;;
    phase-15) echo 35 ;;
    phase-16) echo 30 ;;
    phase-17) echo 30 ;;
    *) echo 50 ;;
  esac
}

json_escape() {
  python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().rstrip("\n")))'
}

active_workdirs() {
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
    if any(marker in line for marker in ("pgrep", "cto-agent-report-15min", "cto-supervisor-10h")):
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

count_matching_active() {
  local pattern="$1"
  local count=0 workdir
  for workdir in "${active[@]:-}" ; do
    if [[ "$(basename "$workdir")" =~ $pattern ]] ; then
      count=$((count + 1))
    fi
  done
  echo "$count"
}

classify_repo() {
  local workdir="$1" base
  base="$(basename "$workdir")"
  case "$base" in
    bsebench-runner*) echo "runner" ;;
    bsebench-stats*) echo "stats" ;;
    bsebench-datasets*) echo "datasets" ;;
    bsebench-filters*) echo "filters" ;;
    bsebench-specs*) echo "specs" ;;
    bsebench-async-codex-cto-report*) echo "cto-report" ;;
    bsebench-async-codex*) echo "async" ;;
    *) echo "unknown" ;;
  esac
}

phase_from_workdir() {
  local base="$1"
  if [[ "$base" =~ (phase-[0-9]+) ]] ; then
    printf '%s\n' "${BASH_REMATCH[1]}"
  else
    printf 'unphased\n'
  fi
}

last_log_for_workdir() {
  local workdir="$1" base pattern
  base="$(basename "$workdir")"
  pattern="$STATE_DIR/manual-*${base#bsebench-}*.log"
  ls -1t $pattern 2>/dev/null | head -1 || true
}

completion_count_for_phase() {
  local phase="$1"
  local count=0 path
  shopt -s nullglob
  for path in \
    "$ROOT"/bsebench-runner-*"$phase"* \
    "$ROOT"/bsebench-stats-*"$phase"* \
    "$ROOT"/bsebench-datasets-*"$phase"* \
    "$ROOT"/bsebench-filters-*"$phase"* \
    "$ROOT"/bsebench-specs-*"$phase"*
  do
    [[ -d "$path" ]] || continue
    count=$((count + 1))
  done
  shopt -u nullglob
  echo "$count"
}

write_progress_json() {
  local tmp="$REPORT_DIR/progress.$$.json"
  {
    printf '{\n'
    printf '  "schema_version": %s,\n' "$(printf '%s\n' "$REPORT_SCHEMA_VERSION" | json_escape)"
    printf '  "generated_at": %s,\n' "$(date -Is | json_escape)"
    printf '  "phases": {\n'
    local first=1 phase completed total pct
    for phase in phase-7 phase-8 phase-9 phase-10 phase-11 phase-12 phase-13 phase-14 phase-15 phase-16 phase-17 ; do
      completed="$(completion_count_for_phase "$phase")"
      total="$(phase_total "$phase")"
      pct=$((completed * 100 / total))
      [[ "$pct" -gt 95 ]] && pct=95
      if [[ "$first" -eq 0 ]] ; then printf ',\n'; fi
      first=0
      printf '    "%s": {"completed": %s, "total": %s, "pct": %s}' "$phase" "$completed" "$total" "$pct"
    done
    printf '\n  }\n'
    printf '}\n'
  } > "$tmp"
  mv "$tmp" "$PREVIOUS_JSON.new"
}

previous_pct() {
  local phase="$1"
  [[ -f "$PREVIOUS_JSON" ]] || {
    echo 0
    return 0
  }
  if [[ "$(jq -r '.schema_version // ""' "$PREVIOUS_JSON" 2>/dev/null)" != "$REPORT_SCHEMA_VERSION" ]] ; then
    current_pct "$phase"
    return 0
  fi
  jq -r --arg phase "$phase" '.phases[$phase].pct // 0' "$PREVIOUS_JSON" 2>/dev/null || echo 0
}

current_pct() {
  local phase="$1"
  jq -r --arg phase "$phase" '.phases[$phase].pct // 0' "$PREVIOUS_JSON.new"
}

write_report() {
  local tmp="$REPORT_DIR/report.$$.md"
  local generated active_count
  generated="$(date -Is)"
  mapfile -t active < <(active_workdirs)
  active_count="${#active[@]}"
  write_progress_json

  {
    printf '# BSEBench CTO Agent Report\n\n'
    printf -- '- generated_at: `%s`\n' "$generated"
    printf -- '- active_codex_exec_workdirs: `%s`\n' "$active_count"
    printf -- '- product_workdirs: `%s`\n' "$(count_matching_active 'bsebench-(runner|stats|datasets|filters|specs)-')"
    printf -- '- orchestration_workdirs: `%s`\n\n' "$(count_matching_active 'bsebench-async-codex')"
    printf 'Progress method: conservative product evidence only (`runner/stats/datasets/filters/specs` worktrees), capped at 95%% until integration/merge validation.\n\n'

    printf '## Active Agents\n\n'
    if [[ "$active_count" -eq 0 ]] ; then
      printf -- '- NONE - SLO breach, emergency capacity must launch.\n'
    else
      local workdir repo phase log_file age size
      for workdir in "${active[@]}" ; do
        repo="$(classify_repo "$workdir")"
        phase="$(phase_from_workdir "$(basename "$workdir")")"
        log_file="$(last_log_for_workdir "$workdir")"
        if [[ -n "$log_file" && -f "$log_file" ]] ; then
          age=$(( $(date +%s) - $(stat -c %Y "$log_file") ))
          size="$(stat -c %s "$log_file")"
          printf -- '- `%s` | repo=`%s` | phase=`%s` | log=`%s` | log_age_s=`%s` | log_bytes=`%s`\n' \
            "$(basename "$workdir")" "$repo" "$phase" "$(basename "$log_file")" "$age" "$size"
        else
          printf -- '- `%s` | repo=`%s` | phase=`%s` | log=`missing`\n' "$(basename "$workdir")" "$repo" "$phase"
        fi
      done
    fi

    printf '\n## Phase Progress\n\n'
    local phase completed total pct prev delta
    for phase in phase-7 phase-8 phase-9 phase-10 phase-11 phase-12 phase-13 phase-14 phase-15 phase-16 phase-17 ; do
      completed="$(jq -r --arg phase "$phase" '.phases[$phase].completed' "$PREVIOUS_JSON.new")"
      total="$(jq -r --arg phase "$phase" '.phases[$phase].total' "$PREVIOUS_JSON.new")"
      pct="$(current_pct "$phase")"
      prev="$(previous_pct "$phase")"
      delta=$((pct - prev))
      printf -- '- `%s`: `%s%%` (%s/%s), delta `%+d%%`\n' "$phase" "$pct" "$completed" "$total" "$delta"
    done
  } > "$tmp"

  mv "$tmp" "$CURRENT"
  mv "$PREVIOUS_JSON.new" "$PREVIOUS_JSON"
  printf '[%s] report=%s active=%s\n' "$generated" "$CURRENT" "$active_count" >> "$LOG_FILE"
  cat "$CURRENT"
}

write_report
