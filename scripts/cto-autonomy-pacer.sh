#!/usr/bin/env bash
# cto-autonomy-pacer.sh - keep useful async work non-idle from a curated backlog.
#
# Intended cron:
#   */10 * * * * /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report/scripts/cto-autonomy-pacer.sh
#
# This script may mutate only the async orchestration repo. It does not run
# codex, pytest, uv, or target-repo writes. Workers consume the queued briefs.
# If a block is present, normal scientific queueing stays paused, but the pacer
# may queue one tightly scoped block-remediation task so the system does not
# sit silent while the red validation signal waits for diagnosis.

set -euo pipefail

export PATH="/home/oakir/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

ROOT="${BSEBENCH_ROOT:-/mnt/c/doctorat/bsebench-org}"
ASYNC_REPO="${ASYNC_REPO:-$ROOT/bsebench-async-codex-cto-report}"
ASYNC_ACTIVE="${ASYNC_ACTIVE:-$ROOT/bsebench-async-codex}"
ASYNC_WORKER_2="${ASYNC_WORKER_2:-$ROOT/bsebench-async-codex-worker-2}"
STATE_DIR="${STATE_DIR:-/home/oakir/.local/state/bsebench-async-watchdog}"
LOG_FILE="$STATE_DIR/pacer.log"
LOCK_FILE="$STATE_DIR/pacer.lock"

MIN_RUNNING="${MIN_RUNNING:-2}"
MIN_QUEUED="${MIN_QUEUED:-1}"
MIN_RESERVE="${MIN_RESERVE:-6}"
MAX_QUEUE_PER_TICK="${MAX_QUEUE_PER_TICK:-3}"
STALE_RUNNING_MIN="${STALE_RUNNING_MIN:-180}"
REPLENISHMENT_COOLDOWN_HOURS="${REPLENISHMENT_COOLDOWN_HOURS:-12}"
BLOCK_REMEDIATION_COOLDOWN_MIN="${BLOCK_REMEDIATION_COOLDOWN_MIN:-30}"
DRY_RUN=0

mkdir -p "$STATE_DIR"

usage() {
  cat <<'USAGE'
Usage:
  scripts/cto-autonomy-pacer.sh [--dry-run]

Maintains:
  - at least MIN_RUNNING active codex exec capacity plus MIN_QUEUED waiting task;
  - at least MIN_RESERVE curated backlog tasks under cto/AUTONOMY_BACKLOG;
  - worker daemons for france-personal and france-personal-2 when possible.

The script pauses normal queueing on outbox/_blocks/*.block. If blocked and
idle, it queues at most one block-remediation task per cooldown window instead
of leaving the system silent. It never fabricates scientific tasks except a
tightly scoped backlog-replenishment task when reserve is low.

In --dry-run mode, reserve candidate counting reports skipped backlog BRIEFs
with RESERVE_SKIP lines so CI logs show why each non-queueable BRIEF was not
counted.
USAGE
}

while [[ $# -gt 0 ]] ; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

log() {
  printf '[%s] %s\n' "$(date -Is)" "$*" | tee -a "$LOG_FILE"
}

count_status() {
  local status="$1"
  find inbox -mindepth 2 -maxdepth 2 -name STATUS.json -print0 2>/dev/null |
    xargs -0 -r jq -r '.status // "unknown"' 2>/dev/null |
    awk -v want="$status" '$1 == want { n++ } END { print n + 0 }'
}

codex_exec_count() {
  { pgrep -af 'codex exec|/usr/bin/codex|@openai/codex' 2>/dev/null || true; } |
    awk -v root="$ROOT" '
      $0 !~ /pgrep|cto-autonomy-pacer|cto-watchdog-10min/ && index($0, root) > 0 && ($0 ~ /codex exec/ || $0 ~ / -C /) { n++ }
      END { print n + 0 }
    '
}

block_count() {
  { find outbox/_blocks -maxdepth 1 -type f -name '*.block' 2>/dev/null || true; } |
    wc -l |
    tr -d ' '
}

is_queueable_phase_id() {
  local phase_id="$1"
  [[ "$phase_id" =~ ^phase-(7|8|11)(-|$) ]]
}

is_git_worktree() {
  local repo_dir="$1"
  git -C "$repo_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1
}

brief_target_branch_claimed() {
  local brief="$1"
  local target_repo target_branch repo_dir

  target_repo="$(target_repo_from_brief "$brief")"
  target_branch="$(target_branch_from_brief "$brief")"
  [[ -n "$target_repo" && -n "$target_branch" ]] || return 1

  repo_dir="$(eval echo "$target_repo")"
  is_git_worktree "$repo_dir" || return 1

  git -C "$repo_dir" show-ref --verify --quiet "refs/heads/$target_branch" && return 0
  git -C "$repo_dir" show-ref --verify --quiet "refs/remotes/origin/$target_branch" && return 0
  return 1
}

reserve_skip() {
  local phase_id="$1"
  local reason="$2"
  local detail="${3:-}"

  if [[ "${RESERVE_SUPPRESS_SKIP_LOGS:-0}" == "1" ]] ; then
    return 0
  fi
  if [[ "$DRY_RUN" -eq 1 || "${RESERVE_REPORT_SKIPS:-0}" == "1" ]] ; then
    if [[ -n "$detail" ]] ; then
      printf '[%s] RESERVE_SKIP phase=%s reason=%s %s\n' "$(date -Is)" "$phase_id" "$reason" "$detail" | tee -a "$LOG_FILE" >&2
    else
      printf '[%s] RESERVE_SKIP phase=%s reason=%s\n' "$(date -Is)" "$phase_id" "$reason" | tee -a "$LOG_FILE" >&2
    fi
  fi
}

gate_skip_reason() {
  local gate_output="$1"
  local reason=""

  if [[ "$gate_output" == *"[FAIL] falsification condition"* ]] ; then
    reason="${reason:+$reason,}missing_falsification_gate"
  fi
  if [[ "$gate_output" == *"[FAIL] validation or replay wording"* ]] ; then
    reason="${reason:+$reason,}missing_validation_command"
  fi
  if [[ "$gate_output" == *"[FAIL] no claim_55 targeting"* || "$gate_output" == *"[FAIL] no protected claim_55 target instruction"* ]] ; then
    reason="${reason:+$reason,}protected_claim_55_targeting"
  fi

  printf '%s\n' "${reason:-research_gate_failed}"
}

brief_targets_claim_55() {
  local phase_id="$1"
  local target_branch="$2"

  [[ "$phase_id" == *claim_55* || "$target_branch" == *claim_55* ]]
}

reserve_candidates() {
  { find cto/AUTONOMY_BACKLOG -mindepth 2 -maxdepth 2 -name BRIEF.md -print 2>/dev/null || true; } |
    sort |
    while IFS= read -r brief ; do
      local phase_dir phase_id target_repo target_branch gate_output reason
      phase_dir="$(dirname "$brief")"
      phase_id="$(basename "$phase_dir")"
      is_queueable_phase_id "$phase_id" || continue
      if [[ -f "$phase_dir/QUEUED.json" ]] ; then
        reserve_skip "$phase_id" "queued_marker_present" "brief=$brief"
        continue
      fi
      if [[ -d "inbox/$phase_id" ]] ; then
        reserve_skip "$phase_id" "inbox_already_exists" "brief=$brief"
        continue
      fi

      target_repo="$(target_repo_from_brief "$brief")"
      target_branch="$(target_branch_from_brief "$brief")"
      if [[ -z "$target_repo" || -z "$target_branch" ]] ; then
        reserve_skip "$phase_id" "malformed_frontmatter" "brief=$brief"
        continue
      fi
      if brief_targets_claim_55 "$phase_id" "$target_branch" ; then
        reserve_skip "$phase_id" "protected_claim_55_targeting" "brief=$brief target_branch=$target_branch"
        continue
      fi
      if brief_target_branch_claimed "$brief" ; then
        reserve_skip "$phase_id" "target_branch_already_claimed" "brief=$brief target_repo=$target_repo target_branch=$target_branch"
        continue
      fi
      if ! gate_output="$(bash scripts/check-research-brief-gates.sh --dry-run "$brief" 2>&1)" ; then
        reason="$(gate_skip_reason "$gate_output")"
        reserve_skip "$phase_id" "$reason" "brief=$brief"
        continue
      fi
      printf '%s\n' "$brief"
    done
}

reserve_count() {
  RESERVE_SUPPRESS_SKIP_LOGS=1 reserve_candidates | wc -l | tr -d ' '
}

fresh_running_count() {
  find inbox -mindepth 2 -maxdepth 2 -name STATUS.json -print0 2>/dev/null |
    xargs -0 -r jq -r --argjson now "$(date +%s)" --argjson max "$STALE_RUNNING_MIN" '
      select((.status // "") == "running")
      | ((.ts_started // "") as $ts | try ($ts | fromdateiso8601) catch 0) as $started
      | select($started > 0 and (($now - $started) / 60) <= $max)
      | .phase_id
    ' 2>/dev/null |
    wc -l |
    tr -d ' '
}

git_dirty() {
  ! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]
}

ensure_repo_ready() {
  if ! is_git_worktree "$ASYNC_REPO" ; then
    log "FATAL async repo missing: $ASYNC_REPO"
    exit 1
  fi
  cd "$ASYNC_REPO"

  if [[ "$DRY_RUN" -eq 1 ]] ; then
    log "DRY-RUN repo ready check only; skipping pull/rebase and dirty-tree enforcement"
    return 0
  fi

  if git_dirty ; then
    log "PAUSE async repo dirty before pacer mutation; manual review required"
    git status --short | tee -a "$LOG_FILE"
    exit 0
  fi

  git pull --rebase origin main --quiet
}

ensure_worker_daemon() {
  local worker_id="$1"
  local repo="$2"
  local log_file="$3"
  local script="$repo/scripts/worker-daemon.sh"

  if [[ ! -f "$script" ]] ; then
    log "WARN worker script missing for $worker_id: $script"
    return 0
  fi

  if pgrep -af 'worker-daemon.sh' 2>/dev/null | grep -F "$script" >/dev/null ; then
    return 0
  fi

  log "START worker daemon missing: worker_id=$worker_id repo=$repo"
  if [[ "$DRY_RUN" -eq 1 ]] ; then
    return 0
  fi

  chmod +x "$script" 2>/dev/null || true
  nohup env WORKER_ID="$worker_id" ASYNC_REPO="$repo" bash "$script" > "$log_file" 2>&1 &
  disown 2>/dev/null || true
}

ensure_chef_daemon() {
  local repo="$ASYNC_WORKER_2"
  local script="$repo/scripts/chef-daemon.sh"
  local log_file="/home/oakir/.async-chef.log"

  if [[ ! -f "$script" ]] ; then
    log "PAUSE chef daemon script missing: $script"
    return 1
  fi

  if pgrep -af 'chef-daemon.sh' 2>/dev/null | grep -F "$script" >/dev/null ; then
    return 0
  fi

  log "START chef daemon missing: repo=$repo"
  if [[ "$DRY_RUN" -eq 1 ]] ; then
    return 0
  fi

  chmod +x "$script" 2>/dev/null || true
  if command -v stdbuf >/dev/null 2>&1 ; then
    nohup env ASYNC_REPO="$repo" stdbuf -oL -eL bash "$script" > "$log_file" 2>&1 &
  else
    nohup env ASYNC_REPO="$repo" bash "$script" > "$log_file" 2>&1 &
  fi
  disown 2>/dev/null || true
  return 0
}

target_repo_from_brief() {
  awk '/^---$/{flag=!flag; next} flag && /^target_repo:/{print $2; exit}' "$1"
}

target_branch_from_brief() {
  awk '/^---$/{flag=!flag; next} flag && /^target_branch:/{print $2; exit}' "$1"
}

base_branch_from_brief() {
  awk '/^---$/{flag=!flag; next} flag && /^base_branch:/{print $2; exit}' "$1"
}

queue_backlog_brief() {
  local brief="$1"
  local phase_dir phase_id target_repo target_branch base_branch now inbox_dir queued_marker

  phase_dir="$(dirname "$brief")"
  phase_id="$(basename "$phase_dir")"
  inbox_dir="inbox/$phase_id"
  queued_marker="$phase_dir/QUEUED.json"
  now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

  target_repo="$(target_repo_from_brief "$brief")"
  target_branch="$(target_branch_from_brief "$brief")"
  base_branch="$(base_branch_from_brief "$brief")"
  base_branch="${base_branch:-main}"

  if ! is_queueable_phase_id "$phase_id" ; then
    log "SKIP non-research backlog phase: $phase_id"
    return 1
  fi

  if [[ -z "$target_repo" || -z "$target_branch" ]] ; then
    log "SKIP malformed backlog brief missing frontmatter: $brief"
    return 1
  fi

  if brief_targets_claim_55 "$phase_id" "$target_branch" ; then
    log "SKIP protected claim_55 targeting: $phase_id"
    return 1
  fi

  if brief_target_branch_claimed "$brief" ; then
    log "SKIP target branch already claimed: $phase_id target=$target_repo branch=$target_branch"
    return 1
  fi

  local gate_output reason
  if ! gate_output="$(bash scripts/check-research-brief-gates.sh --dry-run "$brief" 2>&1)" ; then
    printf '%s\n' "$gate_output" >> "$LOG_FILE"
    reason="$(gate_skip_reason "$gate_output")"
    log "SKIP research gate failed: $phase_id reason=$reason"
    return 1
  fi
  printf '%s\n' "$gate_output" >> "$LOG_FILE"

  log "QUEUE reserve task: $phase_id target=$target_repo branch=$target_branch"
  if [[ "$DRY_RUN" -eq 1 ]] ; then
    QUEUED_PHASES+=("$phase_id")
    return 0
  fi

  mkdir -p "$inbox_dir"
  cp "$brief" "$inbox_dir/BRIEF.md"
  cat > "$inbox_dir/STATUS.json" <<EOF
{
  "phase_id": "$phase_id",
  "status": "queued",
  "ts_queued": "$now",
  "ts_started": null,
  "ts_done": null,
  "exit_code": null,
  "worker_id": null,
  "target_repo": "$target_repo",
  "target_branch": "$target_branch",
  "base_branch": "$base_branch",
  "queued_by": "cto-autonomy-pacer",
  "source_backlog": "$brief"
}
EOF
  cat > "$queued_marker" <<EOF
{
  "phase_id": "$phase_id",
  "queued_at": "$now",
  "queued_by": "cto-autonomy-pacer",
  "inbox": "$inbox_dir"
}
EOF
  QUEUED_PHASES+=("$phase_id")
}

replenishment_recent_or_open() {
  find inbox -mindepth 1 -maxdepth 1 -type d -name 'phase-7-10-z-autonomy-backlog-replenishment-*' 2>/dev/null |
    while IFS= read -r dir ; do
      jq -r '
        (.status // "unknown") as $status
        | if (($status == "queued") or ($status == "running") or ($status == "needs_fix")) then
            "recent_or_open"
          else
            empty
          end
      ' "$dir/STATUS.json" 2>/dev/null
    done |
    awk 'NF { found=1 } END { exit found ? 0 : 1 }'
}

block_remediation_recent_or_open() {
  local cooldown_sec=$((BLOCK_REMEDIATION_COOLDOWN_MIN * 60))
  find inbox -mindepth 1 -maxdepth 1 -type d -name 'phase-7-10-y-block-remediation-*' 2>/dev/null |
    while IFS= read -r dir ; do
      jq -r --argjson now "$(date +%s)" --argjson cooldown "$cooldown_sec" '
        (.status // "unknown") as $status
        | ((.ts_queued // "") as $ts | try ($ts | fromdateiso8601) catch 0) as $queued
        | if (($status == "queued") or ($status == "running") or ($status == "needs_fix") or ($queued > 0 and (($now - $queued) <= $cooldown))) then
            "recent_or_open"
          else
            empty
          end
      ' "$dir/STATUS.json" 2>/dev/null
    done |
    awk 'NF { found=1 } END { exit found ? 0 : 1 }'
}

queue_block_remediation_task() {
  local now compact phase_id phase_dir branch block_list

  if block_remediation_recent_or_open ; then
    log "BLOCKED block remediation task is open or inside ${BLOCK_REMEDIATION_COOLDOWN_MIN}min cooldown"
    return 0
  fi

  now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  compact="$(date -u +%Y%m%dT%H%M%SZ)"
  phase_id="phase-7-10-y-block-remediation-$compact"
  branch="$phase_id"
  phase_dir="inbox/$phase_id"
  block_list="$(find outbox/_blocks -maxdepth 1 -type f -name '*.block' -printf '%f\n' 2>/dev/null | sort | paste -sd ',')"
  block_list="${block_list:-unknown}"

  log "QUEUE block remediation task: phase=$phase_id blocks=$block_list"
  if [[ "$DRY_RUN" -eq 1 ]] ; then
    QUEUED_PHASES+=("$phase_id")
    return 0
  fi

  mkdir -p "$phase_dir"
  cat > "$phase_dir/BRIEF.md" <<EOF
---
target_repo: $ASYNC_REPO
target_branch: $branch
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 45
---

# Phase 7.10.y - block remediation

You are a rigorous BSEBench incident-remediation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Diagnose the active async block(s), preserve a GLASSBOX root-cause record, and propose the smallest safe unblock or fix path.

## Active block snapshot

- Queued by: \`cto-autonomy-pacer\`
- Queued at: \`$now\`
- Block files seen by pacer: \`$block_list\`

## Required behavior

- Read \`outbox/_blocks/*.block\`, the matching \`outbox/<phase>/CHEF_VERDICT.md\`, \`PANEL_CHECK.md\`, \`ADVISOR_CHECK.md\` when present, and the latest worker/chef/pacer logs.
- Write an incident note under \`cto/OUTBOX/\` with root cause, blast radius, current evidence, and exact recovery gate.
- Do not delete block files unless the branch also proves the block cause has been fixed and records a \`CTO_UNBLOCK.md\` for the blocked phase.
- Do not edit thesis files, claim registry files, \`claims/registry.yaml\`, \`claim_55\`, or the roadmap.
- Do not make SOTA, novelty, breakthrough, or verified-claim statements without a source ledger and comparability table.

## Falsification gate

If the task cannot identify whether the block is still scientifically valid, infra-only, or stale-after-fix, it must fail and record the uncertainty instead of unblocking.

## Validation

Run and record:

- \`find outbox/_blocks -maxdepth 1 -type f -name '*.block' -print\`;
- \`pgrep -af 'worker-daemon|chef-daemon|cto-daemon|codex exec|/usr/bin/codex|@openai/codex'\`;
- \`bash scripts/check-research-brief-gates.sh --dry-run inbox/$phase_id/BRIEF.md\`;
- \`bash -n scripts/cto-autonomy-pacer.sh scripts/remote-worker.sh scripts/chef-daemon.sh scripts/cto-watchdog-10min.sh\`;
- \`git diff --check\`.

Commit with GLASSBOX metadata. No \`Co-Authored-By Claude\`.
EOF
  cat > "$phase_dir/STATUS.json" <<EOF
{
  "phase_id": "$phase_id",
  "status": "queued",
  "ts_queued": "$now",
  "ts_started": null,
  "ts_done": null,
  "exit_code": null,
  "worker_id": null,
  "target_repo": "$ASYNC_REPO",
  "target_branch": "$branch",
  "base_branch": "main",
  "queued_by": "cto-autonomy-pacer",
  "source_backlog": "dynamic-block-remediation",
  "block_files": "$block_list"
}
EOF
  QUEUED_PHASES+=("$phase_id")
}

queue_replenishment_task() {
  local queued_this_tick="${1:-0}"
  local now compact phase_id phase_dir branch reserve gate_dir gate_brief
  reserve="$(reserve_count)"
  if [[ "$reserve" -ge "$MIN_RESERVE" ]] ; then
    return 0
  fi
  if [[ "$queued_this_tick" -ge "$MAX_QUEUE_PER_TICK" ]] ; then
    log "RESERVE_LOW reserve=$reserve but queue cap already used this tick"
    return 0
  fi
  if replenishment_recent_or_open ; then
    log "RESERVE_LOW reserve=$reserve but replenishment task is open or inside ${REPLENISHMENT_COOLDOWN_HOURS}h cooldown"
    return 0
  fi

  now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  compact="$(date -u +%Y%m%dT%H%M%SZ)"
  phase_id="phase-7-10-z-autonomy-backlog-replenishment-$compact"
  branch="$phase_id"
  phase_dir="inbox/$phase_id"

  gate_dir="$(mktemp -d "$STATE_DIR/replenishment-brief.XXXXXX")"
  gate_brief="$gate_dir/inbox/$phase_id/BRIEF.md"
  mkdir -p "$(dirname "$gate_brief")"
  cat > "$gate_brief" <<EOF
---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: $branch
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.10.z - autonomy backlog replenishment

You are a rigorous BSEBench CTO planning engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Restore the curated autonomy reserve to at least six useful future tasks under \`cto/AUTONOMY_BACKLOG/\`, without changing the scientific roadmap.

## Required behavior

- Read \`docs/CTO-48H-AUTONOMY-PLAN-2026-05-07.md\`, \`docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md\`, \`docs/RESEARCH-ROADMAP-2026-05-06.md\`, and the latest \`HISTORY.md\` entries.
- Add at least six new \`cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md\` entries that are roadmap-mapped, falsifiable, and scoped to runner/stats/datasets/async validation work.
- Each BRIEF must include validation, a falsification gate, no thesis or claim registry edits, and no unsupported SOTA or novelty claims.
- Each BRIEF must explicitly forbid targeting \`claim_55\`.
- Prefer tasks that validate Hinf evidence fragility, manifest replay, dataset provenance, source-ledger comparability, CI gates, or Phase 8/11 preflight tooling.
- Do not edit thesis files, \`claims/registry.yaml\`, claim registry files, or \`docs/RESEARCH-ROADMAP-2026-05-06.md\`.
- Do not target \`claim_55\`; it is protected and unrelated to this backlog replenishment.
- Do not make SOTA claims without a source ledger, stable URL or DOI, retrieval date, and comparability table.

## Falsification gate

If the new backlog tasks cannot state a concrete failure condition or validation command, this task must fail and explain why in the outbox summary.

## Validation

Run and record:

- \`bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md\`;
- \`bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh\`;
- \`git diff --check\`;
- a reserve count command proving at least six unqueued backlog BRIEFs remain.

Commit with GLASSBOX metadata. No \`Co-Authored-By Claude\`.
EOF

  if ! bash scripts/check-research-brief-gates.sh --dry-run "$gate_brief" >> "$LOG_FILE" 2>&1 ; then
    rm -rf "$gate_dir"
    log "FATAL generated replenishment brief failed gate before queue"
    return 1
  fi

  log "QUEUE replenishment task: reserve=$reserve min=$MIN_RESERVE phase=$phase_id"
  if [[ "$DRY_RUN" -eq 1 ]] ; then
    rm -rf "$gate_dir"
    QUEUED_PHASES+=("$phase_id")
    return 0
  fi

  mkdir -p "$phase_dir"
  cp "$gate_brief" "$phase_dir/BRIEF.md"
  rm -rf "$gate_dir"
  cat > "$phase_dir/STATUS.json" <<EOF
{
  "phase_id": "$phase_id",
  "status": "queued",
  "ts_queued": "$now",
  "ts_started": null,
  "ts_done": null,
  "exit_code": null,
  "worker_id": null,
  "target_repo": "/mnt/c/doctorat/bsebench-org/bsebench-async-codex",
  "target_branch": "$branch",
  "base_branch": "main",
  "queued_by": "cto-autonomy-pacer",
  "source_backlog": "dynamic-reserve-low"
}
EOF
  QUEUED_PHASES+=("$phase_id")
}

append_history_and_commit() {
  local running queued execs reserve blocks queued_csv now
  running="$1"
  queued="$2"
  execs="$3"
  reserve="$4"
  blocks="$5"

  if [[ ${#QUEUED_PHASES[@]} -eq 0 ]] ; then
    log "NOOP capacity ok: codex_exec=$execs status_running=$running queued=$queued reserve=$reserve blocks=$blocks"
    return 0
  fi

  queued_csv="$(IFS=, ; echo "${QUEUED_PHASES[*]}")"
  now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

  if [[ "$DRY_RUN" -eq 1 ]] ; then
    log "DRY-RUN would commit queued=$queued_csv"
    return 0
  fi

  cat >> HISTORY.md <<EOF
- **$now** | [actor: cto-autonomy-pacer-FR] | [QUEUE] | $queued_csv | pacer restored non-idle or block-remediation capacity. Guards: codex_exec=$execs, status_running=$running, queued_before=$queued, reserve_before=$reserve, blocks=$blocks, min_running=$MIN_RUNNING, min_queued=$MIN_QUEUED, min_reserve=$MIN_RESERVE. Tasks remain mechanical, falsifiable, no thesis/registry/roadmap edits, no unsupported SOTA claims.
EOF

  git add HISTORY.md inbox/ cto/AUTONOMY_BACKLOG/
  git commit -m "chore(async): autonomy pacer queues work

[role: cto-autonomy-pacer-FR]

## Context
The async system must not sit idle after workers drain all queued tasks or after a block requires remediation.

## Objective
Restore non-idle capacity from a curated, gate-checked backlog or, when blocked, queue a bounded remediation task while keeping normal scientific queueing paused.

## Problem
The audit-only watchdog could report an empty backlog or active block but could not enqueue useful follow-up or remediation work.

## Result
Queued: $queued_csv
Guards before queue: codex_exec=$execs status_running=$running queued=$queued reserve=$reserve blocks=$blocks
No thesis, claim registry, roadmap, claim_55, or unsupported SOTA edits are authorized by this commit." --quiet

  if ! git push origin main --quiet ; then
    log "push raced; retrying after rebase"
    git pull --rebase origin main --quiet
    git push origin main --quiet
  fi
  log "COMMITTED queued=$queued_csv"
}

main() {
  ensure_repo_ready

  local running fresh_running effective_running queued execs reserve blocks effective_capacity target_open needed brief queued_now candidate_idx
  local -a candidates
  ensure_worker_daemon "france-personal" "$ASYNC_ACTIVE" "/home/oakir/.async-worker.log"
  ensure_worker_daemon "france-personal-2" "$ASYNC_WORKER_2" "/home/oakir/.async-worker-2.log"
  ensure_chef_daemon || return 0

  running="$(count_status running)"
  fresh_running="$(fresh_running_count)"
  queued="$(count_status queued)"
  execs="$(codex_exec_count)"
  effective_running="$execs"
  if [[ "$fresh_running" -gt "$effective_running" ]] ; then
    effective_running="$fresh_running"
  fi
  reserve="$(reserve_count)"
  blocks="$(block_count)"
  target_open=$((MIN_RUNNING + MIN_QUEUED))
  effective_capacity=$((effective_running + queued))
  needed=$((target_open - effective_capacity))
  if [[ "$queued" -lt "$MIN_QUEUED" && "$needed" -lt $((MIN_QUEUED - queued)) ]] ; then
    needed=$((MIN_QUEUED - queued))
  fi
  if [[ "$needed" -lt 0 ]] ; then
    needed=0
  fi
  if [[ "$needed" -gt "$MAX_QUEUE_PER_TICK" ]] ; then
    needed="$MAX_QUEUE_PER_TICK"
  fi

  log "SNAPSHOT codex_exec=$execs status_running=$running fresh_running=$fresh_running effective_running=$effective_running queued=$queued reserve=$reserve blocks=$blocks needed=$needed"

  if [[ "$blocks" -gt 0 ]] ; then
    QUEUED_PHASES=()
    if [[ "$effective_capacity" -lt "$target_open" ]] ; then
      queue_block_remediation_task
    else
      log "BLOCKED capacity already non-idle; normal backlog queueing paused"
    fi
    append_history_and_commit "$running" "$queued" "$execs" "$reserve" "$blocks"
    return 0
  fi

  QUEUED_PHASES=()
  queued_now=0
  candidate_idx=0
  mapfile -t candidates < <(reserve_candidates)
  while [[ "$queued_now" -lt "$needed" ]] ; do
    if [[ "$candidate_idx" -ge "${#candidates[@]}" ]] ; then
      log "RESERVE_EMPTY cannot queue normal task; reserve replenishment will be attempted"
      break
    fi
    brief="${candidates[$candidate_idx]}"
    candidate_idx=$((candidate_idx + 1))
    if queue_backlog_brief "$brief" ; then
      queued_now=$((queued_now + 1))
    fi
  done

  queue_replenishment_task "$queued_now"
  append_history_and_commit "$running" "$queued" "$execs" "$reserve" "$blocks"

  local stale
  stale="$(find inbox -mindepth 2 -maxdepth 2 -name STATUS.json -print0 2>/dev/null |
    xargs -0 -r jq -r --argjson now "$(date +%s)" --argjson max "$STALE_RUNNING_MIN" '
      select((.status // "") == "running")
      | .phase_id as $p
      | (.ts_started // "") as $ts
      | try ($ts | fromdateiso8601) catch 0
      | select(. > 0 and (($now - .) / 60) > $max)
      | $p
    ' 2>/dev/null || true)"
  if [[ -n "$stale" ]] ; then
    log "WARN stale running statuses over ${STALE_RUNNING_MIN}min: $(echo "$stale" | tr '\n' ' ')"
  fi
}

(
  flock -n 9 || exit 0
  main
) 9>"$LOCK_FILE"
