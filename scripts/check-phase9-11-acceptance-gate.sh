#!/usr/bin/env bash
# Validate the Phase 9/10/11 acceptance-gate checklist.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-phase9-11-acceptance-gate.sh [CHECKLIST.json]

The checklist may be NO_GO with missing evidence. It fails when the file marks
scientific closure as GO without all required local evidence, includes phases
outside Phase 9/10/11, or contains unsupported public-claim wording.
USAGE
}

case "${1:-}" in
  -h|--help)
    usage
    exit 0
    ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECKLIST="${1:-$REPO_ROOT/docs/PHASE_9_10_11_ACCEPTANCE_GATE_2026-05-08.json}"

failures=0

fail() {
  echo "[FAIL] $*" >&2
  failures=$((failures + 1))
}

ok() {
  echo "[OK] $*"
}

require_jq() {
  local label="$1"
  shift

  if jq -e "$@" "$CHECKLIST" >/dev/null ; then
    ok "$label"
  else
    fail "$label"
  fi
}

if [[ ! -f "$CHECKLIST" ]] ; then
  echo "Error: checklist not found: $CHECKLIST" >&2
  exit 2
fi

if ! command -v jq >/dev/null 2>&1 ; then
  echo "Error: jq is required for acceptance-gate validation" >&2
  exit 2
fi

if ! jq empty "$CHECKLIST" >/dev/null ; then
  echo "Error: checklist is not valid JSON: $CHECKLIST" >&2
  exit 2
fi

echo "[CHECK] $CHECKLIST"

require_jq "schema version" '.schema_version == "phase9-11-acceptance-gate/v1"'
require_jq "top-level decision value" '.decision == "GO" or .decision == "NO_GO"'
require_jq "scope is Phase 9/10/11 only" '
  (.scope.allowed_phases | sort) == ["phase_10", "phase_11", "phase_9"]
'
require_jq "uploads and downloads disabled" '
  (.scope.hf_uploads_allowed == false) and (.scope.dataset_downloads_allowed == false)
'
require_jq "required scientific evidence types are exact" '
  (.gate_policy.required_scientific_evidence_types | sort) ==
  ["empirical_run", "local_cache_provenance", "replay_or_stats_validation", "source_ledger", "tier2_readiness"]
'

mapfile -t phase_keys < <(jq -r '.phases | keys[]' "$CHECKLIST")
for phase in "${phase_keys[@]}" ; do
  case "$phase" in
    phase_9|phase_10|phase_11)
      ok "$phase is in scope"
      ;;
    *)
      fail "$phase is outside Phase 9/10/11 scope"
      ;;
  esac
done

for phase in phase_9 phase_10 phase_11 ; do
  if ! jq -e --arg phase "$phase" '.phases[$phase]' "$CHECKLIST" >/dev/null ; then
    fail "$phase checklist exists"
    continue
  fi

  require_jq "$phase tooling status value" --arg phase "$phase" '
    .phases[$phase].tooling_gate.status as $status |
    $status == "complete" or $status == "partial" or $status == "blocked"
  '
  require_jq "$phase scientific status value" --arg phase "$phase" '
    .phases[$phase].scientific_closure_gate.status as $status |
    $status == "GO" or $status == "NO_GO"
  '
  require_jq "$phase required evidence entries exist" --arg phase "$phase" '
    .gate_policy.required_scientific_evidence_types as $required |
    (.phases[$phase].scientific_closure_gate.required_evidence | map(.type) | unique | sort) == ($required | unique | sort)
  '

  status="$(jq -r --arg phase "$phase" '.phases[$phase].scientific_closure_gate.status' "$CHECKLIST")"
  missing_count="$(jq -r --arg phase "$phase" '
    [.phases[$phase].scientific_closure_gate.required_evidence[] | select(.status != "present")] | length
  ' "$CHECKLIST")"

  if [[ "$missing_count" -gt 0 && "$status" == "GO" ]] ; then
    fail "$phase cannot be GO with missing required evidence"
  elif [[ "$missing_count" -gt 0 ]] ; then
    ok "$phase fails closed with $missing_count missing required evidence item(s)"
  fi

  if [[ "$status" == "GO" ]] ; then
    mapfile -t present_paths < <(jq -r --arg phase "$phase" '
      .phases[$phase].scientific_closure_gate.required_evidence[]
      | select(.status == "present")
      | .path
    ' "$CHECKLIST")
    for path in "${present_paths[@]}" ; do
      if [[ -z "$path" ]] ; then
        fail "$phase GO evidence path is empty"
      elif [[ -e "$REPO_ROOT/$path" ]] ; then
        ok "$phase GO evidence path exists: $path"
      else
        fail "$phase GO evidence path does not exist: $path"
      fi
    done
  fi

  mapfile -t tooling_paths < <(jq -r --arg phase "$phase" '
    .phases[$phase].tooling_gate.evidence[]? | select(.status == "present") | .path
  ' "$CHECKLIST")
  for path in "${tooling_paths[@]}" ; do
    if [[ -z "$path" ]] ; then
      fail "$phase present tooling evidence path is empty"
    elif [[ -e "$REPO_ROOT/$path" ]] ; then
      ok "$phase tooling evidence path exists: $path"
    else
      fail "$phase tooling evidence path does not exist: $path"
    fi
  done
done

top_decision="$(jq -r '.decision' "$CHECKLIST")"
go_phase_count="$(jq -r '[.phases[] | select(.scientific_closure_gate.status == "GO")] | length' "$CHECKLIST")"

if [[ "$top_decision" == "GO" && "$go_phase_count" -ne 3 ]] ; then
  fail "top-level GO requires all three phase scientific gates to be GO"
else
  ok "top-level decision is consistent with phase gates"
fi

if jq -r '.. | scalars | tostring' "$CHECKLIST" |
  grep -Eiq '(^|[^[:alnum:]_])(sota|state-of-the-art|novel(ty)?|winner|leaderboard)([^[:alnum:]_]|$)|public[[:space:]_-]*benchmark' ; then
  fail "unsupported public-claim wording appears in checklist text"
else
  ok "no unsupported public-claim wording in checklist text"
fi

if [[ "$failures" -gt 0 ]] ; then
  echo "Phase 9/10/11 acceptance-gate validation failed: $failures failure(s)." >&2
  exit 1
fi

echo "Phase 9/10/11 acceptance-gate validation passed."
