#!/usr/bin/env bash
# check-phase9-11-acceptance-gate.sh - validate Phase 9/10/11 closure rows.
#
# Input is a tab-separated checklist with columns:
#   phase  lane  status  evidence  blockers
#
# Required phases: phase9, phase10, phase11.
# Required lanes: tooling, empirical, scientific, public.
#
# A valid checklist may still report NO_GO scientific closure. This checker only
# verifies that GO labels are supported by the required evidence and that missing
# evidence is explicit.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-phase9-11-acceptance-gate.sh CHECKLIST.tsv

Validates a Phase 9/10/11 acceptance checklist that separates tooling,
empirical, scientific, and public-readiness decisions.

TSV columns:
  phase      phase9 | phase10 | phase11
  lane       tooling | empirical | scientific | public
  status     GO | GO_TOOLING | GO_EMPIRICAL | GO_CLAIM | NO_GO | WAIT | BLOCKED
  evidence   semicolon/comma-delimited evidence text
  blockers   none, or explicit blocking reason(s)

GO evidence requirements:
  tooling:    commit, validation, diff_check
  empirical:  commit, validation, cache, provenance, tier2, empirical_run
  scientific: commit, validation, cache, provenance, tier2, empirical_run, source_ledger
  public:     scientific lane must also be GO; evidence must include public_summary

The command exits non-zero for unsupported GO labels, missing rows, or implicit
closure. It exits zero for an explicit tooling-only checkpoint whose empirical,
scientific, or public lanes remain NO_GO with blockers.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] ; then
  usage
  exit 0
fi

if [[ "$#" -ne 1 ]] ; then
  usage >&2
  exit 2
fi

checklist="$1"
if [[ ! -f "$checklist" ]] ; then
  echo "Error: checklist file not found: $checklist" >&2
  exit 2
fi

lower_text() {
  tr '[:upper:]' '[:lower:]'
}

norm_token() {
  local value="$1"
  value="$(printf '%s' "$value" | lower_text)"
  value="${value//-/_}"
  value="${value// /_}"
  printf '%s' "$value"
}

is_known_phase() {
  case "$1" in
    phase9|phase10|phase11) return 0 ;;
    *) return 1 ;;
  esac
}

is_known_lane() {
  case "$1" in
    tooling|empirical|scientific|public) return 0 ;;
    *) return 1 ;;
  esac
}

is_go_status() {
  case "$1" in
    go|go_tooling|go_empirical|go_claim) return 0 ;;
    *) return 1 ;;
  esac
}

is_known_status() {
  case "$1" in
    go|go_tooling|go_empirical|go_claim|no_go|wait|blocked) return 0 ;;
    *) return 1 ;;
  esac
}

blockers_are_none() {
  local blockers
  blockers="$(norm_token "$1")"
  [[ -z "$blockers" || "$blockers" == "none" || "$blockers" == "n/a" || "$blockers" == "na" ]]
}

has_evidence() {
  local evidence="$1"
  local token="$2"
  local normalized
  normalized="$(norm_token "$evidence")"
  [[ "$normalized" =~ (^|[^a-z0-9])"$token"([^a-z0-9]|$) ]]
}

declare -A status_by_key
declare -A evidence_by_key
declare -A blockers_by_key
failures=0
line_no=0

while IFS=$'\t' read -r phase lane status evidence blockers extra ; do
  line_no=$((line_no + 1))

  [[ -n "${phase//[[:space:]]/}" ]] || continue
  [[ "${phase:0:1}" == "#" ]] && continue

  phase="$(norm_token "$phase")"
  lane="$(norm_token "$lane")"
  status="$(norm_token "$status")"
  evidence="${evidence:-}"
  blockers="${blockers:-}"

  if [[ "$phase" == "phase" && "$lane" == "lane" ]] ; then
    continue
  fi

  if [[ -n "${extra:-}" ]] ; then
    echo "[FAIL] line $line_no has extra tab-separated columns"
    failures=$((failures + 1))
    continue
  fi

  if ! is_known_phase "$phase" ; then
    echo "[FAIL] line $line_no has unknown phase: $phase"
    failures=$((failures + 1))
    continue
  fi
  if ! is_known_lane "$lane" ; then
    echo "[FAIL] line $line_no has unknown lane: $lane"
    failures=$((failures + 1))
    continue
  fi
  if ! is_known_status "$status" ; then
    echo "[FAIL] line $line_no has unknown status: $status"
    failures=$((failures + 1))
    continue
  fi

  key="$phase:$lane"
  if [[ -n "${status_by_key[$key]:-}" ]] ; then
    echo "[FAIL] duplicate row for $key"
    failures=$((failures + 1))
    continue
  fi

  status_by_key[$key]="$status"
  evidence_by_key[$key]="$evidence"
  blockers_by_key[$key]="$blockers"
done < "$checklist"

required_evidence_for_lane() {
  case "$1" in
    tooling) printf '%s\n' commit validation diff_check ;;
    empirical) printf '%s\n' commit validation cache provenance tier2 empirical_run ;;
    scientific) printf '%s\n' commit validation cache provenance tier2 empirical_run source_ledger ;;
    public) printf '%s\n' public_summary ;;
  esac
}

validate_go_evidence() {
  local phase="$1"
  local lane="$2"
  local evidence="$3"
  local missing=0
  local token

  while IFS= read -r token ; do
    [[ -n "$token" ]] || continue
    if ! has_evidence "$evidence" "$token" ; then
      echo "[FAIL] $phase $lane GO missing evidence token: $token"
      missing=$((missing + 1))
    fi
  done < <(required_evidence_for_lane "$lane")

  return "$missing"
}

scientific_go=0
empirical_go=0
public_go=0
rows=0

for phase in phase9 phase10 phase11 ; do
  for lane in tooling empirical scientific public ; do
    key="$phase:$lane"
    if [[ -z "${status_by_key[$key]:-}" ]] ; then
      echo "[FAIL] missing required row: $key"
      failures=$((failures + 1))
      continue
    fi

    rows=$((rows + 1))
    status="${status_by_key[$key]}"
    evidence="${evidence_by_key[$key]}"
    blockers="${blockers_by_key[$key]}"

    if is_go_status "$status" ; then
      if ! blockers_are_none "$blockers" ; then
        echo "[FAIL] $phase $lane GO has blockers: $blockers"
        failures=$((failures + 1))
      fi
      if ! validate_go_evidence "$phase" "$lane" "$evidence" ; then
        failures=$((failures + 1))
      fi
    elif blockers_are_none "$blockers" ; then
      echo "[FAIL] $phase $lane $status lacks explicit blocker"
      failures=$((failures + 1))
    fi
  done

  if is_go_status "${status_by_key[$phase:empirical]:-no_go}" ; then
    empirical_go=$((empirical_go + 1))
  fi

  if is_go_status "${status_by_key[$phase:scientific]:-no_go}" ; then
    scientific_go=$((scientific_go + 1))
    if ! is_go_status "${status_by_key[$phase:empirical]:-no_go}" ; then
      echo "[FAIL] $phase scientific GO without empirical GO"
      failures=$((failures + 1))
    fi
  fi

  if is_go_status "${status_by_key[$phase:public]:-no_go}" ; then
    public_go=$((public_go + 1))
    if ! is_go_status "${status_by_key[$phase:scientific]:-no_go}" ; then
      echo "[FAIL] $phase public GO without scientific GO"
      failures=$((failures + 1))
    fi
  fi
done

if [[ "$failures" -gt 0 ]] ; then
  echo "Phase 9/10/11 acceptance gate failed: $failures failure(s), $rows row(s) checked." >&2
  exit 1
fi

if [[ "$scientific_go" -eq 3 ]] ; then
  overall_scientific="GO"
else
  overall_scientific="NO_GO"
fi

if [[ "$empirical_go" -eq 3 ]] ; then
  overall_empirical="GO"
else
  overall_empirical="NO_GO"
fi

if [[ "$public_go" -eq 3 ]] ; then
  overall_public="GO"
else
  overall_public="NO_GO"
fi

echo "Phase 9/10/11 acceptance gate passed: $rows row(s) checked."
echo "overall_empirical_readiness=$overall_empirical"
echo "overall_scientific_closure=$overall_scientific"
echo "overall_public_readiness=$overall_public"
