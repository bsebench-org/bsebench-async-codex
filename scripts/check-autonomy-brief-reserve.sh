#!/usr/bin/env bash
# check-autonomy-brief-reserve.sh - count queueable autonomy backlog BRIEFs.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

BACKLOG_DIR="${BACKLOG_DIR:-cto/AUTONOMY_BACKLOG}"
INBOX_DIR="${INBOX_DIR:-inbox}"
MIN_RESERVE="${MIN_RESERVE:-6}"
DRY_RUN=0
OUTPUT_MODE="report"

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-autonomy-brief-reserve.sh [--dry-run] [--min N] [--count-only|--list-queueable]

Counts queueable Phase 7/8/11 autonomy-backlog BRIEFs using the pacer rules:
  - no cto/AUTONOMY_BACKLOG/<phase>/QUEUED.json marker;
  - no existing inbox/<phase> directory;
  - no local or origin target_branch ref in the target_repo;
  - BRIEF frontmatter is parseable and target_repo is a Git repository;
  - BRIEF passes scripts/check-research-brief-gates.sh --dry-run.

Default mode reports queueable BRIEFs and skipped reasons, then fails if the
queueable count is below MIN_RESERVE or --min N.
USAGE
}

while [[ $# -gt 0 ]] ; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    --min)
      shift
      [[ $# -gt 0 ]] || {
        echo "Error: --min requires a value" >&2
        exit 2
      }
      MIN_RESERVE="$1"
      ;;
    --count-only)
      OUTPUT_MODE="count"
      ;;
    --list-queueable)
      OUTPUT_MODE="list"
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

if ! [[ "$MIN_RESERVE" =~ ^[0-9]+$ ]] ; then
  echo "Error: minimum reserve must be a non-negative integer: $MIN_RESERVE" >&2
  exit 2
fi

cd "$REPO_ROOT"

is_queueable_phase_id() {
  local phase_id="$1"
  [[ "$phase_id" =~ ^phase-(7|8|11)(-|$) ]]
}

frontmatter_value() {
  local path="$1"
  local key="$2"

  awk -v key="$key" '
    /^---[[:space:]]*$/ {
      if (!seen_frontmatter) {
        frontmatter = 1
        seen_frontmatter = 1
        next
      }
      if (frontmatter) {
        exit
      }
      next
    }
    frontmatter && index($0, key ":") == 1 {
      sub("^[^:]+:[[:space:]]*", "")
      gsub(/^["'\'']|["'\'']$/, "")
      print
      exit
    }
  ' "$path"
}

target_repo_from_brief() {
  frontmatter_value "$1" "target_repo"
}

target_branch_from_brief() {
  frontmatter_value "$1" "target_branch"
}

resolve_repo_dir() {
  local repo="$1"

  case "$repo" in
    "~")
      printf '%s\n' "$HOME"
      ;;
    "~/"*)
      printf '%s/%s\n' "$HOME" "${repo#~/}"
      ;;
    *)
      printf '%s\n' "$repo"
      ;;
  esac
}

target_branch_claimed() {
  local repo_dir="$1"
  local target_branch="$2"

  git -C "$repo_dir" show-ref --verify --quiet "refs/heads/$target_branch" && return 0
  git -C "$repo_dir" show-ref --verify --quiet "refs/remotes/origin/$target_branch" && return 0
  return 1
}

report_line() {
  if [[ "$OUTPUT_MODE" == "report" ]] ; then
    printf '%s\n' "$*"
  fi
}

report_skip() {
  local brief="$1"
  local reason="$2"
  local detail="${3:-}"

  skipped=$((skipped + 1))
  case "$reason" in
    queued-marker)
      skipped_queued=$((skipped_queued + 1))
      ;;
    inbox-exists)
      skipped_inbox=$((skipped_inbox + 1))
      ;;
    branch-claimed)
      skipped_branch_claimed=$((skipped_branch_claimed + 1))
      ;;
    malformed)
      skipped_malformed=$((skipped_malformed + 1))
      ;;
    non-research-phase)
      skipped_non_research=$((skipped_non_research + 1))
      ;;
  esac

  if [[ -n "$detail" ]] ; then
    report_line "[SKIP] $brief reason=$reason $detail"
  else
    report_line "[SKIP] $brief reason=$reason"
  fi
}

queueable=0
total=0
gate_checked=0
skipped=0
skipped_queued=0
skipped_inbox=0
skipped_branch_claimed=0
skipped_malformed=0
skipped_non_research=0
queueable_paths=()

if [[ "$DRY_RUN" -eq 1 && "$OUTPUT_MODE" == "report" ]] ; then
  echo "DRY-RUN: checking autonomy backlog reserve integrity; no files will be modified."
fi

while IFS= read -r brief ; do
  [[ -n "$brief" ]] || continue
  total=$((total + 1))

  phase_dir="$(dirname "$brief")"
  phase_id="$(basename "$phase_dir")"

  if ! is_queueable_phase_id "$phase_id" ; then
    report_skip "$brief" "non-research-phase" "phase_id=$phase_id"
    continue
  fi

  if [[ -f "$phase_dir/QUEUED.json" ]] ; then
    report_skip "$brief" "queued-marker" "phase_id=$phase_id"
    continue
  fi

  if [[ -d "$INBOX_DIR/$phase_id" ]] ; then
    report_skip "$brief" "inbox-exists" "phase_id=$phase_id"
    continue
  fi

  target_repo="$(target_repo_from_brief "$brief")"
  target_branch="$(target_branch_from_brief "$brief")"
  if [[ -z "$target_repo" || -z "$target_branch" ]] ; then
    report_skip "$brief" "malformed" "phase_id=$phase_id missing=target_repo_or_target_branch"
    continue
  fi

  repo_dir="$(resolve_repo_dir "$target_repo")"
  if [[ ! -d "$repo_dir/.git" ]] ; then
    report_skip "$brief" "malformed" "phase_id=$phase_id target_repo_not_git=$target_repo"
    continue
  fi

  if target_branch_claimed "$repo_dir" "$target_branch" ; then
    report_skip "$brief" "branch-claimed" "phase_id=$phase_id target_repo=$target_repo target_branch=$target_branch"
    continue
  fi

  gate_checked=$((gate_checked + 1))
  if ! gate_output="$(bash scripts/check-research-brief-gates.sh --dry-run "$brief" 2>&1)" ; then
    gate_summary="$(printf '%s\n' "$gate_output" | tail -n 1)"
    report_skip "$brief" "malformed" "phase_id=$phase_id research_gate_failed=\"$gate_summary\""
    continue
  fi

  queueable=$((queueable + 1))
  queueable_paths+=("$brief")
  report_line "[OK] $brief phase_id=$phase_id target_repo=$target_repo target_branch=$target_branch"
done < <({ find "$BACKLOG_DIR" -mindepth 2 -maxdepth 2 -name BRIEF.md -print 2>/dev/null || true; } | sort)

case "$OUTPUT_MODE" in
  count)
    printf '%s\n' "$queueable"
    ;;
  list)
    printf '%s\n' "${queueable_paths[@]}"
    ;;
  report)
    printf '[SUMMARY] queueable=%s min=%s total=%s gate_checked=%s skipped=%s queued=%s inbox=%s branch_claimed=%s malformed=%s non_research=%s\n' \
      "$queueable" \
      "$MIN_RESERVE" \
      "$total" \
      "$gate_checked" \
      "$skipped" \
      "$skipped_queued" \
      "$skipped_inbox" \
      "$skipped_branch_claimed" \
      "$skipped_malformed" \
      "$skipped_non_research"
    ;;
esac

if [[ "$queueable" -lt "$MIN_RESERVE" ]] ; then
  echo "Autonomy reserve integrity failed: queueable=$queueable below minimum=$MIN_RESERVE." >&2
  exit 1
fi

if [[ "$OUTPUT_MODE" == "report" ]] ; then
  echo "Autonomy reserve integrity passed: queueable=$queueable minimum=$MIN_RESERVE."
fi
