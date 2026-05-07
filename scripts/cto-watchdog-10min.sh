#!/usr/bin/env bash
# BSEBench CTO watchdog, audit-only.
#
# Intended cron:
#   */10 * * * * /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report/scripts/cto-watchdog-10min.sh
#
# This script must not mutate async clones, target repos, worker state, lock
# files, daemon state, or evidence artifacts. It writes only to
# /home/oakir/.local/state/bsebench-async-watchdog/.

set -uo pipefail

export PATH="/home/oakir/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

ROOT="/mnt/c/doctorat/bsebench-org"
ASYNC_ACTIVE="$ROOT/bsebench-async-codex"
ASYNC_WORKER_2="$ROOT/bsebench-async-codex-worker-2"
ASYNC_CTO="$ROOT/bsebench-async-codex-cto-report"
RUNNER="$ROOT/bsebench-runner"
STATE_DIR="/home/oakir/.local/state/bsebench-async-watchdog"
LOG_FILE="$STATE_DIR/watchdog.log"
LOCK_FILE="$STATE_DIR/watchdog.lock"

mkdir -p "$STATE_DIR"

status_counts() {
  local repo="$1"
  if [[ ! -d "$repo/inbox" ]] ; then
    echo "inbox missing: $repo/inbox"
    return 0
  fi

  find "$repo/inbox" -mindepth 2 -maxdepth 2 -name STATUS.json -print0 |
    xargs -0 -r jq -r '.status // "unknown"' 2>/dev/null |
    sort |
    uniq -c |
    sort -k2
}

open_status_count() {
  local repo="$1"
  if [[ ! -d "$repo/inbox" ]] ; then
    echo 0
    return 0
  fi

  find "$repo/inbox" -mindepth 2 -maxdepth 2 -name STATUS.json -print0 |
    xargs -0 -r jq -r '.status // "unknown"' 2>/dev/null |
    awk '$1 == "queued" || $1 == "running" || $1 == "needs_fix" { n++ } END { print n + 0 }'
}

queued_running_age_audit() {
  local repo="$1"
  local name="$2"
  local now_epoch="$3"

  if [[ ! -d "$repo/inbox" ]] ; then
    return 0
  fi

  find "$repo/inbox" -mindepth 2 -maxdepth 2 -name STATUS.json -print0 |
    while IFS= read -r -d "" status_file ; do
      local status phase ts started_epoch age_min warn_min
      status="$(jq -r '.status // ""' "$status_file" 2>/dev/null)"
      case "$status" in
        running) warn_min=120 ;;
        queued) warn_min=20 ;;
        needs_fix) warn_min=20 ;;
        *) continue ;;
      esac
      phase="$(jq -r '.phase_id // empty' "$status_file" 2>/dev/null)"
      if [[ "$status" == "running" ]] ; then
        ts="$(jq -r '.ts_started // ""' "$status_file" 2>/dev/null)"
      else
        ts="$(jq -r '.ts_queued // ""' "$status_file" 2>/dev/null)"
      fi
      started_epoch="$(date -d "$ts" +%s 2>/dev/null || printf '0')"
      age_min=-1
      if [[ "$started_epoch" =~ ^[0-9]+$ && "$started_epoch" -gt 0 ]] ; then
        age_min=$(((now_epoch - started_epoch) / 60))
      fi
      printf "%s %s %s age_min=%s ts=%s\n" "$name" "$phase" "$status" "$age_min" "$ts"
      if [[ "$age_min" -ge "$warn_min" ]] 2>/dev/null ; then
        echo "WARN stale_$status repo=$name phase=$phase age_min=$age_min"
      fi
    done
}

log_repo_snapshot() {
  local repo="$1"
  local name="$2"

  [[ -d "$repo" ]] || return 0
  echo
  echo "## $name"

  echo "status_counts:"
  status_counts "$repo" || true

  echo "queued_running_age:"
  queued_running_age_audit "$repo" "$name" "$(date +%s)" || true

  echo "blocks:"
  find "$repo/outbox/_blocks" -maxdepth 1 -type f -name "*.block" \
    -printf "%TY-%Tm-%Td %TH:%TM %p\n" 2>/dev/null || true

  echo "emails_pending:"
  find "$repo/outbox/_emails_pending" -maxdepth 1 -type f -name "*.eml" \
    2>/dev/null | wc -l | tr -d " "
  echo
}

log_backlog_guard() {
  local total_open=0
  local repo count

  echo
  echo "## backlog guard"
  for repo in "$ASYNC_ACTIVE" "$ASYNC_WORKER_2" "$ASYNC_CTO"; do
    count="$(open_status_count "$repo")"
    total_open=$((total_open + count))
    echo "$(basename "$repo"): open_status_count=$count"
  done

  if pgrep -af 'codex exec' >/dev/null 2>&1 ; then
    echo "CODEX_EXEC_GUARD=active"
  else
    echo "CODEX_EXEC_GUARD=idle action=keep_falsifiable_backlog_nonempty"
  fi

  if [[ "$total_open" -eq 0 ]] ; then
    echo "BACKLOG_GUARD=empty action=queue_roadmap_mapped_validation_work"
  else
    echo "BACKLOG_GUARD=ok open_items=$total_open"
  fi
}

log_hourly_direction_checkpoint() {
  echo
  echo "## hourly research direction checkpoint"
  echo "questions:"
  echo "- Does active work map to roadmap Phase 7, 8, 11, or direct validation gates?"
  echo "- What observation could falsify the current task?"
  echo "- Are evidence, replay, manifest, and independent validation separated?"
  echo "- Are SOTA statements blocked pending a source ledger and fair-comparison table?"
  echo "- Is any task drifting into thesis, roadmap, prose, or claim-registry edits?"

  echo "source_hashes:"
  for path in \
    "$ASYNC_CTO/docs/RESEARCH-ROADMAP-2026-05-06.md" \
    "$ASYNC_CTO/docs/AI-RISKS-2026-05-06.md" \
    "$ASYNC_CTO/docs/CTO-48H-AUTONOMY-PLAN-2026-05-07.md" \
    "$RUNNER/outputs/hinf_residual_evidence_5x5.json" \
    "$RUNNER/outputs/hinf_residual_artifact_manifest.json"
  do
    [[ -f "$path" ]] && sha256sum "$path"
  done

  echo "hinf_guardrails:"
  if [[ -f "$RUNNER/outputs/hinf_residual_evidence_5x5.json" ]] ; then
    jq -r \
      '{scientific_verdict, claim_target, mechanical_evidence_only, claim_55_targeted, requirements}' \
      "$RUNNER/outputs/hinf_residual_evidence_5x5.json" 2>/dev/null || true
  fi
}

main() {
  {
    echo
    echo "### $(date -Is) bsebench CTO watchdog"

    echo
    echo "## processes"
    ps -eo pid,ppid,lstart,etime,stat,pcpu,pmem,args --sort=start_time |
      awk '/worker-daemon\.sh|chef-daemon\.sh|cto-daemon\.sh|codex exec|\/usr\/bin\/codex|@openai\/codex/ && $0 !~ /awk|cto-watchdog-10min/ {print}'

    echo
    echo "## daemon state files"
    for file in /home/oakir/.async-*-daemon.running "$ROOT"/.async-*-daemon.running; do
      [[ -e "$file" ]] || continue
      printf "%s: " "$file"
      cat "$file"
    done

    echo
    echo "## locks"
    for file in /tmp/codex-async-*.lock "$ROOT"/bsebench-async-codex*/.git/index.lock; do
      [[ -e "$file" ]] || continue
      stat -c "%y %s %n" "$file"
    done

    echo
    echo "## log mtimes"
    for file in "$ROOT"/.async*.log /home/oakir/.async*.log; do
      [[ -e "$file" ]] && stat -c "%y %s %n" "$file"
    done

    log_repo_snapshot "$ASYNC_ACTIVE" "bsebench-async-codex"
    log_repo_snapshot "$ASYNC_WORKER_2" "bsebench-async-codex-worker-2"
    log_repo_snapshot "$ASYNC_CTO" "bsebench-async-codex-cto-report"
    log_backlog_guard

    if [[ "$(date +%M)" == "00" ]] ; then
      log_hourly_direction_checkpoint
    fi

    echo
    echo "## disk"
    df -h "$ROOT" /home/oakir /tmp
  } >> "$LOG_FILE" 2>&1
}

(
  flock -n 9 || exit 0
  main
) 9>"$LOCK_FILE"
