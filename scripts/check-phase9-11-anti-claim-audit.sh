#!/usr/bin/env bash
# check-phase9-11-anti-claim-audit.sh - guard Phase 9/10/11 closure/performance claims.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-phase9-11-anti-claim-audit.sh [--dry-run] [--staged|--all] [FILE ...]

Checks Phase 9/10/11 artifacts for unsupported positive claims:
  - closure or scientific-verdict claims require cache, provenance, Tier2,
    source-ledger, and empirical-run evidence in the same artifact
  - performance claims require the same evidence markers
  - SOTA, novelty, winner, leaderboard, and public-benchmark claims are blocked

With no files, the default is --staged, which includes untracked files.
USAGE
}

mode="staged"
dry_run=0
explicit_files=()

while [[ $# -gt 0 ]] ; do
  case "$1" in
    --dry-run)
      dry_run=1
      ;;
    --staged)
      mode="staged"
      ;;
    --all)
      mode="all"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      while [[ $# -gt 0 ]] ; do
        explicit_files+=("$1")
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
      explicit_files+=("$1")
      ;;
  esac
  shift
done

if [[ ${#explicit_files[@]} -gt 0 ]] ; then
  mode="explicit"
fi

collect_files() {
  case "$mode" in
    explicit)
      printf '%s\n' "${explicit_files[@]}"
      ;;
    all)
      find docs inbox outbox cto scripts \
        -type f \( -name '*.md' -o -name '*.txt' -o -name '*.json' -o -name '*.py' -o -name '*.sh' \) \
        2>/dev/null | sort
      ;;
    staged)
      {
        git diff --name-only --cached --diff-filter=AM
        git ls-files --others --exclude-standard
      } | sort -u
      ;;
    *)
      echo "Error: internal mode error: $mode" >&2
      exit 2
      ;;
  esac
}

lower_text() {
  tr '[:upper:]' '[:lower:]'
}

matches_text() {
  local text="$1"
  local pattern="$2"

  [[ "$text" =~ $pattern ]]
}

path_has_phase_context() {
  local path="$1"
  local lower
  lower=$(printf '%s' "$path" | lower_text)

  [[ "$lower" =~ phase[-_]?9 ]] && return 0
  [[ "$lower" =~ phase[-_]?10 ]] && return 0
  [[ "$lower" =~ phase[-_]?11 ]] && return 0
  [[ "$lower" =~ phase9 ]] && return 0
  [[ "$lower" =~ phase10 ]] && return 0
  [[ "$lower" =~ phase11 ]] && return 0
  [[ "$lower" =~ p9 ]] && return 0
  [[ "$lower" =~ p10 ]] && return 0
  [[ "$lower" =~ p11 ]] && return 0
  [[ "$lower" =~ 9[-_/]10[-_/]11 ]] && return 0
  [[ "$lower" =~ 9[-_/]11 ]] && return 0
  return 1
}

content_has_phase_context() {
  local path="$1"

  grep -Eiq \
    'phase[[:space:]_/-]*(9|10|11)|phase[[:space:]]*9/10/11|p(9|10|11)([^0-9]|$)|9/10/11' \
    "$path"
}

is_self_validation_path() {
  local path="$1"
  local lower
  lower=$(printf '%s' "$path" | lower_text)

  [[ "$lower" =~ ^scripts/(check|probe)-phase9-11-anti-claim-audit\.sh$ ]]
}

line_is_guardrail() {
  local line="$1"
  local lower
  lower=$(printf '%s' "$line" | lower_text)

  matches_text "$lower" 'do[[:space:]_-]*not|must[[:space:]_-]*not|(^|[^a-z0-9])not([^a-z0-9]|$)|forbid|forbidden|unsupported|without|unless|until|guardrail|fail[[:space:]_-]*closed|no-go|blocked|blocker|wait|dependency|dependencies|candidate|fixture|expected[[:space:]_-]*fail|reject|refuse|avoid|ban|banned|define[[:space:]]+explicit|criteria|checklist' && return 0
  matches_text "$lower" '(^|[^a-z0-9])no[[:space:]_-]+.{0,80}(claim|sota|state-of-the-art|novelty|winner|leaderboard|public[[:space:]_-]*benchmark)'
}

line_has_forbidden_public_claim() {
  local line="$1"
  local lower
  lower=$(printf '%s' "$line" | lower_text)

  matches_text "$lower" '(^|[^a-z0-9])(sota|state-of-the-art|leaderboard|winner|winning|novel|novelty)([^a-z0-9]|$)' && return 0
  matches_text "$lower" 'public[[:space:]_-]*benchmark[[:space:]_-]*(claim|result|leader|winner|win|ranking|rank)' && return 0
  return 1
}

line_has_closure_claim() {
  local line="$1"
  local lower
  lower=$(printf '%s' "$line" | lower_text)

  matches_text "$lower" 'phase[[:space:]_/-]*(9|10|11|9[[:space:]_/-]*10[[:space:]_/-]*11).{0,120}(complete|completed|closed|done|finished|accepted|verified|validated|ready[[:space:]_-]*(for[[:space:]]+closure|to[[:space:]]+publish|for[[:space:]]+public)|scientific[[:space:]_-]*verdict[[:space:]_-]*(go|passed|accepted)|go[[:space:]_-]*verdict)' && return 0
  matches_text "$lower" '(complete|completed|closed|done|finished|accepted|verified|validated).{0,120}phase[[:space:]_/-]*(9|10|11|9[[:space:]_/-]*10[[:space:]_/-]*11)' && return 0
  matches_text "$lower" '(phase[[:space:]_/-]*)?p(9|10|11)([^0-9]|$).{0,120}(complete|completed|closed|done|finished|accepted|verified|validated|go[[:space:]_-]*verdict)' && return 0
  matches_text "$lower" '(closure|scientific[[:space:]_-]*verdict).{0,120}(approved|accepted|go|pass|passed|green)' && return 0
  return 1
}

line_has_performance_claim() {
  local line="$1"
  local lower
  lower=$(printf '%s' "$line" | lower_text)

  matches_text "$lower" '(performance|metric|metrics|rmse|mae|accuracy|score|benchmark|result|results|generalization).{0,120}(validated|verified|proven|improved|better|beats|wins|outperform|passes|green|accepted)' && return 0
  matches_text "$lower" '(validated|verified|proven|improved|better|beats|wins|outperform|passes|green|accepted).{0,120}(performance|metric|metrics|rmse|mae|accuracy|score|benchmark|result|results|generalization)' && return 0
  return 1
}

evidence_missing_labels() {
  local path="$1"
  local missing=()

  if ! grep -Eiq '(cache|local[[:space:]_-]*cache).{0,120}(evidence|ready|passed|present|available|ok|complete|evidence_ready[[:space:]_:=]*true|missing[[:space:]_-]*(=|:)[[:space:]]*0)' "$path" ; then
    missing+=("cache")
  fi
  if ! grep -Eiq 'provenance.{0,120}(evidence|ready|passed|present|available|ok|complete)' "$path" ; then
    missing+=("provenance")
  fi
  if ! grep -Eiq '(tier[[:space:]_-]*2|tier2).{0,120}(evidence|ready|passed|present|available|ok|complete)' "$path" ; then
    missing+=("Tier2")
  fi
  if ! grep -Eiq 'source[[:space:]_-]*ledger.{0,120}(evidence|ready|passed|present|available|ok|complete)' "$path" ; then
    missing+=("source-ledger")
  fi
  if ! grep -Eiq '(empirical[[:space:]_-]*(run|runs|artifact|artifacts|evidence|output|outputs)|real[[:space:]_-]*data[[:space:]_-]*(run|runs|evidence)).{0,120}(passed|present|available|ok|complete|ready|recorded)' "$path" ; then
    missing+=("empirical-run")
  fi

  if [[ "${#missing[@]}" -gt 0 ]] ; then
    printf '%s\n' "${missing[@]}"
  fi
}

has_disqualifying_gap() {
  local path="$1"

  grep -Eiq 'no-go|status:[[:space:]]*wait|status:[[:space:]]*blocked|incomplete|not[[:space:]]+ready|fail[[:space:]_-]*closed|missing[[:space:]_=:=-]*[1-9]' "$path"
}

check_file() {
  local path="$1"

  if [[ ! -f "$path" ]] ; then
    echo "[FAIL] $path"
    echo "  [FAIL] file does not exist"
    failures=$((failures + 1))
    return
  fi

  if ! grep -Iq . "$path" ; then
    echo "[SKIP] $path (not a text file)"
    skipped=$((skipped + 1))
    return
  fi

  if is_self_validation_path "$path" ; then
    echo "[SKIP] $path (validation guard/probe fixture)"
    skipped=$((skipped + 1))
    return
  fi

  if ! path_has_phase_context "$path" && ! content_has_phase_context "$path" ; then
    echo "[SKIP] $path (no Phase 9/10/11 context)"
    skipped=$((skipped + 1))
    return
  fi

  echo "[CHECK] $path"
  checked=$((checked + 1))

  local line line_no has_forbidden=0
  local closure_claims=()
  line_no=0
  while IFS= read -r line || [[ -n "$line" ]] ; do
    line_no=$((line_no + 1))
    if line_is_guardrail "$line" ; then
      continue
    fi
    if line_has_forbidden_public_claim "$line" ; then
      echo "  [FAIL] line $line_no: forbidden SOTA/novelty/winner/leaderboard/public-benchmark wording"
      echo "         $line"
      has_forbidden=1
    fi
    if line_has_closure_claim "$line" || line_has_performance_claim "$line" ; then
      closure_claims+=("$line_no:$line")
    fi
  done < "$path"

  if [[ "$has_forbidden" -eq 1 ]] ; then
    failures=$((failures + 1))
  fi

  if [[ "${#closure_claims[@]}" -eq 0 ]] ; then
    echo "  [OK] no unguarded closure/performance claim"
    return
  fi

  mapfile -t missing_evidence < <(evidence_missing_labels "$path")
  if [[ "${#missing_evidence[@]}" -gt 0 ]] || has_disqualifying_gap "$path" ; then
    echo "  [FAIL] unsupported closure/performance claim; required evidence is missing or contradicted"
    if [[ "${#missing_evidence[@]}" -gt 0 ]] ; then
      echo "         missing evidence markers: ${missing_evidence[*]}"
    fi
    if has_disqualifying_gap "$path" ; then
      echo "         disqualifying gap marker present"
    fi
    local claim
    for claim in "${closure_claims[@]}" ; do
      echo "         line $claim"
    done
    failures=$((failures + 1))
  else
    echo "  [OK] closure/performance claim includes required evidence markers"
  fi
}

if [[ "$dry_run" -eq 1 ]] ; then
  echo "DRY-RUN: checking Phase 9/10/11 anti-claim guardrails; no files will be modified."
fi

mapfile -t files < <(collect_files)

failures=0
checked=0
skipped=0

for path in "${files[@]}" ; do
  [[ -n "$path" ]] || continue
  check_file "$path"
done

if [[ "$checked" -eq 0 ]] ; then
  echo "No matching Phase 9/10/11 text files found."
fi

if [[ "$failures" -gt 0 ]] ; then
  echo "Phase 9/10/11 anti-claim audit failed: $failures failure(s), $checked checked, $skipped skipped." >&2
  exit 1
fi

echo "Phase 9/10/11 anti-claim audit passed: $checked checked, $skipped skipped."
