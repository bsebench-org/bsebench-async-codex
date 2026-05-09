#!/usr/bin/env bash
# check-phase9-11-acceptance-gate.sh - fail-closed Phase 9/10/11 closure gate.
#
# This validates a checkpoint/checklist Markdown report. It intentionally
# separates tooling readiness from empirical execution and scientific closure.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-phase9-11-acceptance-gate.sh [--dry-run] CHECKLIST.md [...]

Checks Phase 9/10/11 acceptance-gate checklists for:
  - exactly scoped Phase 9, Phase 10, and Phase 11 blocks
  - separate tooling, empirical, and scientific/claim closure lanes
  - fail-closed empirical/scientific GO states unless evidence is explicit
  - no unsupported public-communication or comparison claims

Expected lane lines inside each phase block:
  Tooling status: GO_TOOLING|NO_GO_TOOLING ...
  Empirical status: GO_EMPIRICAL|NO_GO_EMPIRICAL ...
  Scientific closure: GO_CLAIM|NO_GO_CLAIM ...

Positive tooling states require branch, commit/SHA, validation, and blocker
status. Positive empirical states additionally require positive cache,
provenance, Tier2, and empirical-run/artifact evidence. Positive scientific
states additionally require positive source-ledger/comparability evidence.
USAGE
}

dry_run=0
files=()

while [[ $# -gt 0 ]] ; do
  case "$1" in
    --dry-run)
      dry_run=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      while [[ $# -gt 0 ]] ; do
        files+=("$1")
        shift
      done
      break
      ;;
    -*)
      echo "Error: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      files+=("$1")
      ;;
  esac
  shift
done

if [[ "${#files[@]}" -eq 0 ]] ; then
  echo "Error: no checklist files supplied." >&2
  usage >&2
  exit 2
fi

lower_text() {
  tr '[:upper:]' '[:lower:]'
}

has_pattern() {
  local text="$1"
  local pattern="$2"

  printf '%s\n' "$text" | grep -Eiq "$pattern"
}

print_match_lines() {
  local path="$1"
  local pattern="$2"

  grep -Ein "$pattern" "$path" || true
}

extract_phase_block() {
  local path="$1"
  local phase="$2"

  awk -v phase="$phase" '
    BEGIN {
      in_block = 0
      header = "^#{1,6}[[:space:]]*([0-9]+[.)][[:space:]]*)?phase[[:space:]_-]*"
      wanted = header phase "([^0-9]|$)"
    }
    {
      line = tolower($0)
      if (line ~ header "[0-9]+") {
        if (line ~ wanted) {
          in_block = 1
          print
          next
        }
        if (in_block) {
          exit
        }
      }
      if (in_block) {
        print
      }
    }
  ' "$path"
}

find_lane_line() {
  local block="$1"
  local lane="$2"
  local pattern

  case "$lane" in
    tooling)
      pattern='(^|[|* -])(tooling|tooling[[:space:]_-]*merge)([[:space:]_/-]*(status|decision|readiness|closure|merge))?[[:space:]]*[:|=-]'
      ;;
    empirical)
      pattern='(^|[|* -])(empirical|empirical[[:space:]_-]*(execution|scheduling))([[:space:]_/-]*(status|decision|readiness|closure|scheduling))?[[:space:]]*[:|=-]'
      ;;
    scientific)
      pattern='(^|[|* -])((scientific|claim)[[:space:]_-]*(closure|status|decision|readiness)|scientific|claim)([[:space:]_/-]*(status|decision|readiness|closure))?[[:space:]]*[:|=-]'
      ;;
    *)
      echo "Error: unknown lane: $lane" >&2
      exit 2
      ;;
  esac

  printf '%s\n' "$block" | grep -Eim1 "$pattern" || true
}

classify_lane() {
  local line="$1"
  local lower
  lower="$(printf '%s' "$line" | lower_text)"

  if [[ "$lower" =~ no_go|blocked|not_ready|not[[:space:]_-]*ready|deferred|fail[[:space:]_-]*closed|missing ]] ; then
    printf 'no_go\n'
    return 0
  fi
  if [[ "$lower" =~ go_tooling|go_empirical|go_claim|go[[:space:]_-]*merge|(^|[^a-z])go([^a-z]|$)|ready|pass|complete ]] ; then
    printf 'go\n'
    return 0
  fi

  printf 'unknown\n'
}

require_pattern_in_block() {
  local phase="$1"
  local label="$2"
  local block="$3"
  local pattern="$4"

  if has_pattern "$block" "$pattern" ; then
    echo "  [OK]   Phase $phase $label"
  else
    echo "  [FAIL] Phase $phase missing $label"
    failures=$((failures + 1))
  fi
}

check_required_lane() {
  local phase="$1"
  local lane="$2"
  local block="$3"
  local line
  local status

  line="$(find_lane_line "$block" "$lane")"
  if [[ -z "$line" ]] ; then
    echo "  [FAIL] Phase $phase missing separate $lane lane"
    failures=$((failures + 1))
    lane_status="missing"
    return 0
  fi

  status="$(classify_lane "$line")"
  case "$status" in
    go)
      echo "  [OK]   Phase $phase $lane lane is positive and will require evidence"
      ;;
    no_go)
      echo "  [OK]   Phase $phase $lane lane is fail-closed"
      ;;
    *)
      echo "  [FAIL] Phase $phase $lane lane has ambiguous status: $line"
      failures=$((failures + 1))
      ;;
  esac

  lane_status="$status"
}

check_positive_tooling_evidence() {
  local phase="$1"
  local block="$2"

  require_pattern_in_block "$phase" "branch evidence" "$block" 'branch[[:space:]_:|=-]+[^[:space:]]+'
  require_pattern_in_block "$phase" "commit/SHA evidence" "$block" '((commit|sha|branch sha)[[:space:]_:|=-]+[0-9a-f]{7,40}|[0-9a-f]{7,40})'
  require_pattern_in_block "$phase" "validation evidence" "$block" '(validation|validated|pytest|ruff|git diff --check|diff[[:space:]_-]*check|tests?)'
  require_pattern_in_block "$phase" "blocker-status evidence" "$block" '(blocker|blockers|blocking|no[[:space:]_-]*blockers)'
}

check_positive_empirical_evidence() {
  local phase="$1"
  local block="$2"

  check_positive_tooling_evidence "$phase" "$block"
  require_pattern_in_block "$phase" "cache evidence" "$block" 'cache[[:alnum:]_ ./,:|=-]{0,120}(ready|present|available|validated|ok|complete|hit|evidence)'
  require_pattern_in_block "$phase" "provenance evidence" "$block" 'provenance[[:alnum:]_ ./,:|=-]{0,120}(ready|present|available|validated|ok|complete|evidence)'
  require_pattern_in_block "$phase" "Tier2 evidence" "$block" 'tier[[:space:]_-]*2[[:alnum:]_ ./,:|=-]{0,120}(ready|present|available|validated|ok|complete|cache|evidence)'
  require_pattern_in_block "$phase" "empirical-run evidence" "$block" '(empirical[[:space:]_-]*(run|artifact|trace|result)[[:alnum:]_ ./,:|=-]{0,120}(ready|present|available|validated|ok|complete|evidence)|run[[:space:]_-]*artifact[[:alnum:]_ ./,:|=-]{0,120}(present|available|validated|ok|complete))'
}

check_positive_scientific_evidence() {
  local phase="$1"
  local block="$2"

  check_positive_empirical_evidence "$phase" "$block"
  require_pattern_in_block "$phase" "source-ledger evidence" "$block" '(source[[:space:]_-]*ledger[[:alnum:]_ ./,:|=-]{0,120}(ready|present|available|validated|ok|complete|row|evidence)|comparability[[:alnum:]_ ./,:|=-]{0,120}(table|ledger|validated|complete))'
}

check_unsafe_claim_lines() {
  local path="$1"
  local bad=0
  local line
  local lower

  while IFS= read -r line ; do
    lower="$(printf '%s' "$line" | lower_text)"
    if [[ "$lower" =~ (sota|state-of-the-art|novelty|winner|leaderboard|public[[:space:]_-]*benchmark) ]] ; then
      if [[ ! "$lower" =~ (no|not|without|unsupported|ban|banned|block|blocked|reject|rejected|guardrail|must[[:space:]_-]*not|do[[:space:]_-]*not|no_go|n/a) ]] ; then
        printf '%s\n' "$line"
        bad=1
      fi
    fi
  done < "$path"

  return "$bad"
}

check_file() {
  local path="$1"
  local phase
  local block
  local tooling_status
  local empirical_status
  local scientific_status
  local unsafe_lines

  if [[ ! -f "$path" ]] ; then
    echo "[FAIL] $path"
    echo "  [FAIL] file does not exist"
    failures=$((failures + 1))
    return
  fi

  echo "[CHECK] $path"

  future_lines="$(print_match_lines "$path" 'phase[[:space:]_-]*(1[2-9]|[2-9][0-9])')"
  if [[ -n "$future_lines" ]] ; then
    echo "  [FAIL] future-phase scope violation"
    printf '%s\n' "$future_lines" | sed 's/^/         /'
    failures=$((failures + 1))
  else
    echo "  [OK]   no Phase 12+ scope"
  fi

  if unsafe_lines="$(check_unsafe_claim_lines "$path")" ; then
    echo "  [OK]   no unsupported comparison/public-communication claims"
  else
    echo "  [FAIL] unsupported comparison/public-communication claim wording"
    printf '%s\n' "$unsafe_lines" | sed 's/^/         /'
    failures=$((failures + 1))
  fi

  for phase in 9 10 11 ; do
    block="$(extract_phase_block "$path" "$phase")"
    if [[ -z "$block" ]] ; then
      echo "  [FAIL] missing Phase $phase block"
      failures=$((failures + 1))
      continue
    fi

    echo "  [CHECK] Phase $phase lanes"
    check_required_lane "$phase" "tooling" "$block"
    tooling_status="$lane_status"
    check_required_lane "$phase" "empirical" "$block"
    empirical_status="$lane_status"
    check_required_lane "$phase" "scientific" "$block"
    scientific_status="$lane_status"

    if [[ "$tooling_status" == "go" ]] ; then
      check_positive_tooling_evidence "$phase" "$block"
    fi
    if [[ "$empirical_status" == "go" ]] ; then
      check_positive_empirical_evidence "$phase" "$block"
    fi
    if [[ "$scientific_status" == "go" ]] ; then
      check_positive_scientific_evidence "$phase" "$block"
    fi
  done
}

if [[ "$dry_run" -eq 1 ]] ; then
  echo "DRY-RUN: checking Phase 9/10/11 acceptance gate; no files will be modified."
fi

failures=0
future_lines=""
lane_status=""

for path in "${files[@]}" ; do
  check_file "$path"
done

if [[ "$failures" -gt 0 ]] ; then
  echo "Phase 9/10/11 acceptance gate failed: $failures failure(s)." >&2
  exit 1
fi

echo "Phase 9/10/11 acceptance gate passed."
