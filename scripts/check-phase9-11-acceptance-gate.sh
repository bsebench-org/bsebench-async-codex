#!/usr/bin/env bash
# check-phase9-11-acceptance-gate.sh - fail-closed Phase 9/10/11 closure gate.
#
# The gate separates tooling readiness from scientific closure. A tooling pass
# never implies scientific closure: each phase still needs repo-relative Tier2
# cache, provenance, source-ledger, and empirical-run evidence.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-phase9-11-acceptance-gate.sh [--repo DIR] [--checklist FILE]

Checks a key=value acceptance checklist. Default checklist search paths:
  outbox/phase-9-10-11-acceptance-gate/ACCEPTANCE_CHECKLIST.txt
  outbox/phase9-11-acceptance-gate/ACCEPTANCE_CHECKLIST.txt

Checklist row format, one requirement per line:
  phase=9 lane=tooling requirement=preflight_or_contract status=pass evidence=outbox/path.md
  phase=9 lane=scientific requirement=tier2_cache status=pass evidence=outbox/path.md

Required rows per phase:
  tooling:    preflight_or_contract, validation_gates
  scientific: tier2_cache, provenance, source_ledger, empirical_run

Only phases 9, 10, and 11 are accepted. Evidence paths must be repo-relative
files; absolute paths and parent-directory traversal are rejected so temporary
or uncommitted local artifacts cannot close the gate.
USAGE
}

repo="."
checklist=""

while [[ $# -gt 0 ]] ; do
  case "$1" in
    --repo)
      repo="${2:-}"
      shift
      ;;
    --checklist)
      checklist="${2:-}"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [[ ! -d "$repo" ]] ; then
  echo "Error: --repo directory not found: $repo" >&2
  exit 2
fi

repo="$(cd "$repo" && pwd)"

if [[ -z "$checklist" ]] ; then
  for candidate in \
    "$repo/outbox/phase-9-10-11-acceptance-gate/ACCEPTANCE_CHECKLIST.txt" \
    "$repo/outbox/phase9-11-acceptance-gate/ACCEPTANCE_CHECKLIST.txt"
  do
    if [[ -f "$candidate" ]] ; then
      checklist="$candidate"
      break
    fi
  done
elif [[ "$checklist" != /* ]] ; then
  checklist="$repo/$checklist"
fi

TOOLING_REQUIREMENTS=(preflight_or_contract validation_gates)
SCIENTIFIC_REQUIREMENTS=(tier2_cache provenance source_ledger empirical_run)

failures=0
rows=0
closure_claim_seen=0

declare -A STATUS_BY_KEY=()
declare -A EVIDENCE_BY_KEY=()

fail() {
  local message="$1"

  echo "[FAIL] $message"
  failures=$((failures + 1))
}

field_value() {
  local key="$1"
  local line="$2"
  local token

  for token in $line ; do
    case "$token" in
      "$key="*)
        printf '%s\n' "${token#*=}"
        return 0
        ;;
    esac
  done
  return 1
}

join_by_comma() {
  local first=1
  local item

  for item in "$@" ; do
    if [[ "$first" -eq 1 ]] ; then
      printf '%s' "$item"
      first=0
    else
      printf ',%s' "$item"
    fi
  done
}

is_allowed_requirement() {
  local lane="$1"
  local requirement="$2"
  local allowed

  case "$lane" in
    tooling)
      for allowed in "${TOOLING_REQUIREMENTS[@]}" ; do
        [[ "$requirement" == "$allowed" ]] && return 0
      done
      ;;
    scientific)
      for allowed in "${SCIENTIFIC_REQUIREMENTS[@]}" ; do
        [[ "$requirement" == "$allowed" ]] && return 0
      done
      ;;
  esac
  return 1
}

has_pattern() {
  local text="$1"
  local pattern="$2"

  grep -Eiq "$pattern" <<< "$text"
}

claim_language_found() {
  local text="$1"
  local lower

  lower="$(printf '%s\n' "$text" | tr '[:upper:]' '[:lower:]')"
  has_pattern "$lower" '(^|[[:space:]])(is|are|was|were|declared|claims?|proves?|shows?).{0,120}(sota|state-of-the-art|winner|leaderboard|public[[:space:]_-]*benchmark|novelty|novel|breakthrough|verified[[:space:]_-]*claim)' && return 0
  if has_pattern "$lower" '(winner|leaderboard|public[[:space:]_-]*benchmark|state-of-the-art|breakthrough)' ; then
    has_pattern "$lower" '(no|not|without|unsupported|do not|must not|forbid|forbidden).{0,120}(winner|leaderboard|public[[:space:]_-]*benchmark|state-of-the-art|breakthrough|sota)' || return 0
  fi
  return 1
}

closure_language_found() {
  local text="$1"
  local lower

  lower="$(printf '%s\n' "$text" | tr '[:upper:]' '[:lower:]')"
  has_pattern "$lower" 'phase[[:space:]_/-]*(9|10|11|9[/-]10[/-]11).{0,120}(complete|closed)' && return 0
  has_pattern "$lower" 'scientific[[:space:]_-]*(closure|verdict).{0,120}(pass|complete|closed|accepted)' && return 0
  return 1
}

require_evidence_pattern() {
  local source="$1"
  local text="$2"
  local pattern="$3"
  local reason="$4"

  if ! has_pattern "$text" "$pattern" ; then
    fail "$source: evidence lacks $reason"
  fi
}

reject_evidence_pattern() {
  local source="$1"
  local text="$2"
  local pattern="$3"
  local reason="$4"

  if has_pattern "$text" "$pattern" ; then
    fail "$source: evidence contains $reason"
  fi
}

validate_requirement_evidence() {
  local key="$1"
  local evidence_path="$2"
  local text="$3"
  local requirement="${key##*|}"

  case "$requirement" in
    preflight_or_contract)
      require_evidence_pattern "$key" "$text" '(preflight|contract|scheduler|readiness|gate|validator|checklist)' "tooling preflight/contract wording"
      require_evidence_pattern "$key" "$text" '(commit|sha|hash|artifact|validation|replay|command)' "tooling provenance or validation detail"
      ;;
    validation_gates)
      require_evidence_pattern "$key" "$text" '(validation|pytest|ruff|diff --check|bash -n|probe|test)' "validation command evidence"
      ;;
    tier2_cache)
      require_evidence_pattern "$key" "$text" 'tier[[:space:]_-]*2' "Tier2 reference"
      require_evidence_pattern "$key" "$text" 'cache' "cache reference"
      require_evidence_pattern "$key" "$text" '(ready|pass|available|readable|materialized)' "positive cache readiness"
      reject_evidence_pattern "$key" "$text" '(not_ready|ready[=:][[:space:]]*false|evidence_ready[=:][[:space:]]*false|loader_readable[=:][[:space:]]*0|missing[[:space:]_-]*cache|no[[:space:]_-]*loader)' "non-ready cache evidence"
      ;;
    provenance)
      require_evidence_pattern "$key" "$text" 'provenance' "provenance reference"
      require_evidence_pattern "$key" "$text" '(sha256|hash|manifest|commit|source)' "hash, manifest, commit, or source identity"
      reject_evidence_pattern "$key" "$text" '(missing[[:space:]_-]*provenance|unknown[[:space:]_-]*provenance|provenance[[:space:]_-]*gap)' "provenance gap"
      ;;
    source_ledger)
      require_evidence_pattern "$key" "$text" 'source[[:space:]_-]*ledger' "source-ledger reference"
      require_evidence_pattern "$key" "$text" '(doi|stable[[:space:]_-]*url|https?://|retriev)' "stable source URL/DOI or retrieval date"
      require_evidence_pattern "$key" "$text" 'source[[:space:]_-]*id' "source identifier"
      require_evidence_pattern "$key" "$text" 'metric' "metric field"
      require_evidence_pattern "$key" "$text" 'dataset' "dataset field"
      require_evidence_pattern "$key" "$text" 'split' "split field"
      require_evidence_pattern "$key" "$text" '(reported[[:space:]_-]*value|external[[:space:]_-]*value)' "reported or external value"
      require_evidence_pattern "$key" "$text" 'bsebench[[:space:]_-]*value' "frozen BSEBench value"
      require_evidence_pattern "$key" "$text" 'comparability' "comparability table/caveat"
      require_evidence_pattern "$key" "$text" 'caveat' "comparability caveat"
      reject_evidence_pattern "$key" "$text" '(synthetic[[:space:]_-]*positive[[:space:]_-]*fixture|fixture[[:space:]_-]*only|placeholder)' "synthetic-only or placeholder source ledger"
      ;;
    empirical_run)
      require_evidence_pattern "$key" "$text" 'empirical' "empirical-run wording"
      require_evidence_pattern "$key" "$text" '(run|replay|artifact|output|trace)' "run artifact or replay detail"
      require_evidence_pattern "$key" "$text" '(sha256|hash|commit|run_id|artifact)' "run provenance identity"
      reject_evidence_pattern "$key" "$text" '(dry[[:space:]_-]*run|synthetic[[:space:]_-]*only|fixture[[:space:]_-]*only|not_ready|blocked|missing[[:space:]_-]*(cache|provenance|run|artifact)|no[[:space:]_-]*(empirical|cache|provenance))' "dry-run, synthetic-only, blocked, or missing empirical evidence"
      ;;
    *)
      fail "$key: internal error for evidence $evidence_path"
      ;;
  esac
}

read_evidence() {
  local phase="$1"
  local lane="$2"
  local requirement="$3"
  local evidence="$4"
  local key="$phase|$lane|$requirement"
  local evidence_path
  local evidence_text

  if [[ -z "$evidence" || "$evidence" == "-" || "$evidence" == "none" ]] ; then
    fail "$key: status=pass requires a repo-relative evidence path"
    return
  fi
  if [[ "$evidence" == /* || "$evidence" == *".."* ]] ; then
    fail "$key: evidence path must be repo-relative without parent traversal: $evidence"
    return
  fi

  evidence_path="$repo/$evidence"
  if [[ ! -f "$evidence_path" ]] ; then
    fail "$key: evidence file not found: $evidence"
    return
  fi

  evidence_text="$(< "$evidence_path")"
  if claim_language_found "$evidence_text" ; then
    fail "$key: evidence contains unsupported public-claim language: $evidence"
  fi
  if closure_language_found "$evidence_text" ; then
    closure_claim_seen=1
  fi
  validate_requirement_evidence "$key" "$evidence_path" "$evidence_text"
}

if [[ -z "$checklist" || ! -f "$checklist" ]] ; then
  echo "Phase 9/10/11 acceptance gate: NO-GO"
  fail "no acceptance checklist found; expected outbox/phase-9-10-11-acceptance-gate/ACCEPTANCE_CHECKLIST.txt or pass --checklist"
  echo "Overall acceptance: NO-GO"
  exit 1
fi

while IFS= read -r raw_line || [[ -n "$raw_line" ]] ; do
  line="${raw_line%%#*}"
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"
  [[ -n "$line" ]] || continue

  rows=$((rows + 1))

  phase="$(field_value phase "$line" || true)"
  lane="$(field_value lane "$line" || true)"
  requirement="$(field_value requirement "$line" || true)"
  status="$(field_value status "$line" || true)"
  evidence="$(field_value evidence "$line" || true)"

  if [[ -z "$phase" || -z "$lane" || -z "$requirement" || -z "$status" ]] ; then
    fail "row $rows: missing one of phase/lane/requirement/status"
    continue
  fi

  if claim_language_found "$line" ; then
    fail "row $rows: checklist row contains unsupported public-claim language"
  fi
  if closure_language_found "$line" ; then
    closure_claim_seen=1
  fi

  case "$phase" in
    9|10|11)
      ;;
    *)
      fail "row $rows: phase must be one of 9, 10, or 11; got $phase"
      continue
      ;;
  esac

  case "$lane" in
    tooling|scientific)
      ;;
    *)
      fail "row $rows: lane must be tooling or scientific; got $lane"
      continue
      ;;
  esac

  if ! is_allowed_requirement "$lane" "$requirement" ; then
    fail "row $rows: unknown $lane requirement: $requirement"
    continue
  fi

  case "$status" in
    pass|fail|missing|blocked)
      ;;
    *)
      fail "row $rows: status must be pass, fail, missing, or blocked; got $status"
      continue
      ;;
  esac

  key="$phase|$lane|$requirement"
  STATUS_BY_KEY["$key"]="$status"
  EVIDENCE_BY_KEY["$key"]="$evidence"

  if [[ "$status" == "pass" ]] ; then
    read_evidence "$phase" "$lane" "$requirement" "$evidence"
  fi
done < "$checklist"

if [[ "$rows" -eq 0 ]] ; then
  fail "acceptance checklist has no requirement rows: $checklist"
fi

overall_ok=1

for phase in 9 10 11 ; do
  missing_tooling=()
  missing_scientific=()

  for requirement in "${TOOLING_REQUIREMENTS[@]}" ; do
    key="$phase|tooling|$requirement"
    if [[ "${STATUS_BY_KEY[$key]:-missing}" != "pass" ]] ; then
      missing_tooling+=("$requirement")
    fi
  done

  for requirement in "${SCIENTIFIC_REQUIREMENTS[@]}" ; do
    key="$phase|scientific|$requirement"
    if [[ "${STATUS_BY_KEY[$key]:-missing}" != "pass" ]] ; then
      missing_scientific+=("$requirement")
    fi
  done

  if [[ "${#missing_tooling[@]}" -eq 0 ]] ; then
    tooling_status="PASS"
  else
    tooling_status="NO-GO"
    overall_ok=0
  fi

  if [[ "${#missing_scientific[@]}" -eq 0 ]] ; then
    scientific_status="PASS"
  else
    scientific_status="NO-GO"
    overall_ok=0
  fi

  printf 'Phase %s: tooling=%s scientific=%s' "$phase" "$tooling_status" "$scientific_status"
  if [[ "${#missing_tooling[@]}" -gt 0 ]] ; then
    printf ' missing_tooling=%s' "$(join_by_comma "${missing_tooling[@]}")"
  fi
  if [[ "${#missing_scientific[@]}" -gt 0 ]] ; then
    printf ' missing_scientific=%s' "$(join_by_comma "${missing_scientific[@]}")"
  fi
  printf '\n'
done

if [[ "$overall_ok" -ne 1 && "$closure_claim_seen" -eq 1 ]] ; then
  fail "checklist/evidence contains Phase 9/10/11 completion language while the gate is NO-GO"
fi

if [[ "$failures" -gt 0 ]] ; then
  overall_ok=0
fi

echo "Rows checked: $rows"
if [[ "$overall_ok" -eq 1 ]] ; then
  echo "Overall acceptance: PASS"
  exit 0
fi

echo "Overall acceptance: NO-GO"
exit 1
