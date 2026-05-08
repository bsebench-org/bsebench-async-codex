#!/usr/bin/env bash
# check-research-diff-scope.sh - dry-run guard for protected research edits.
#
# The guard accepts either a git diff range or a changed-file list. It prints a
# deterministic report classifying each path as ALLOWED, BLOCKED, or
# REVIEW_REQUIRED, then exits non-zero if any blocked or review-required item is
# present.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-research-diff-scope.sh [--dry-run] [--repo DIR] [--base REV] [--head REV]
  scripts/check-research-diff-scope.sh [--dry-run] --staged [--repo DIR]
  scripts/check-research-diff-scope.sh [--dry-run] --paths FILE [--diff FILE]

Checks changed paths and, when a git diff is available, added text for:
  - protected thesis, claim registry, claims/registry.yaml, roadmap, claim_55 edits
  - unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim wording
  - unsupported Phase 9/10/11 closure or performance wording
  - comparison wording backed by a complete source ledger and comparability table

Default git mode compares origin/main...HEAD in the current repository.
USAGE
}

repo="."
base=""
head="HEAD"
dry_run=0
staged=0
paths_file=""
diff_file=""

while [[ $# -gt 0 ]] ; do
  case "$1" in
    --dry-run)
      dry_run=1
      ;;
    --repo)
      repo="${2:-}"
      shift
      ;;
    --base)
      base="${2:-}"
      shift
      ;;
    --head)
      head="${2:-}"
      shift
      ;;
    --staged)
      staged=1
      ;;
    --paths)
      paths_file="${2:-}"
      shift
      ;;
    --diff)
      diff_file="${2:-}"
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

if [[ -n "$paths_file" && ! -f "$paths_file" ]] ; then
  echo "Error: --paths file not found: $paths_file" >&2
  exit 2
fi
if [[ -n "$diff_file" && ! -f "$diff_file" ]] ; then
  echo "Error: --diff file not found: $diff_file" >&2
  exit 2
fi
if [[ ! -d "$repo" ]] ; then
  echo "Error: --repo directory not found: $repo" >&2
  exit 2
fi

git_diff_args=()
git_name_args=()
if [[ -z "$paths_file" ]] ; then
  if [[ "$staged" -eq 1 ]] ; then
    git_diff_args=(diff --cached --no-ext-diff)
    git_name_args=(diff --cached --name-status)
  else
    if [[ -z "$base" ]] ; then
      if git -C "$repo" rev-parse --verify --quiet origin/main >/dev/null ; then
        base="origin/main"
      elif git -C "$repo" rev-parse --verify --quiet HEAD~1 >/dev/null ; then
        base="HEAD~1"
      else
        base="$(git -C "$repo" hash-object -t tree /dev/null)"
      fi
    fi
    git_diff_args=(diff --no-ext-diff "${base}...${head}")
    git_name_args=(diff --name-status "${base}...${head}")
  fi
fi

normalize_changed_path() {
  local line="$1"
  local status first second third

  line="${line//$'\r'/}"
  [[ -n "$line" ]] || return 0

  if [[ "$line" == *$'\t'* ]] ; then
    IFS=$'\t' read -r status first second third <<< "$line"
    if [[ "$status" == R* || "$status" == C* ]] ; then
      printf '%s\n' "$second"
    else
      printf '%s\n' "$first"
    fi
  else
    printf '%s\n' "$line"
  fi
}

collect_paths() {
  if [[ -n "$paths_file" ]] ; then
    while IFS= read -r line ; do
      normalize_changed_path "$line"
    done < "$paths_file"
  else
    git -C "$repo" "${git_name_args[@]}" | while IFS= read -r line ; do
      normalize_changed_path "$line"
    done
  fi | sed '/^[[:space:]]*$/d' | sort -u
}

all_added_text() {
  if [[ -n "$diff_file" ]] ; then
    sed -n '/^+++ /!s/^+//p' "$diff_file"
  elif [[ -z "$paths_file" ]] ; then
    git -C "$repo" "${git_diff_args[@]}" --unified=0 | sed -n '/^+++ /!s/^+//p'
  fi
}

added_text_for_path() {
  local path="$1"

  if [[ -n "$diff_file" ]] ; then
    awk -v target="$path" '
      /^diff --git / {
        current = ""
        next
      }
      /^\+\+\+ b\// {
        current = substr($0, 7)
        next
      }
      /^\+\+\+ / {
        current = ""
        next
      }
      current == target && /^\+/ && $0 !~ /^\+\+\+ / {
        print substr($0, 2)
      }
    ' "$diff_file"
  elif [[ -z "$paths_file" ]] ; then
    git -C "$repo" "${git_diff_args[@]}" --unified=0 -- "$path" | sed -n '/^+++ /!s/^+//p'
  fi
}

lower_text() {
  tr '[:upper:]' '[:lower:]'
}

is_validation_only_path() {
  local path="$1"

  [[ "$path" =~ ^scripts/(check|probe)-.*(research|sota|claim|brief|phase|diff).*\.sh$ ]] && return 0
  [[ "$path" =~ ^scripts/check-research-brief-gates\.sh$ ]] && return 0
  [[ "$path" =~ ^scripts/check-research-diff-scope\.sh$ ]] && return 0
  [[ "$path" =~ ^tests?/fixtures/research[-_].* ]] && return 0
  return 1
}

protected_path_reason() {
  local path="$1"
  local lower
  lower=$(printf '%s' "$path" | lower_text)

  if [[ "$lower" =~ (^|/)claims/registry\.ya?ml$ ]] ; then
    echo "protected claims/registry.yaml"
    return 0
  fi
  if [[ "$lower" =~ (^|/)(claim[-_]?registry|claims[-_]?registry|registry[-_]?claims)\.(ya?ml|json|md|toml)$ ]] ; then
    echo "protected claim registry file"
    return 0
  fi
  if [[ "$lower" =~ (^|/)(claim[-_]?registry|claims[-_]?registry|registry[-_]?claims)(/|$) ]] ; then
    echo "protected claim registry directory"
    return 0
  fi
  if [[ "$lower" =~ (^|/)(thesis|these|these_lfp_2026|manuscript|chapters?|dissertation)(/|$) ]] ; then
    echo "protected thesis or manuscript prose"
    return 0
  fi
  if [[ "$lower" =~ (^|/)docs/research-roadmap-[^/]*\.md$ || "$lower" =~ (^|/)[^/]*roadmap[^/]*\.(md|txt|rst)$ ]] ; then
    echo "protected roadmap file"
    return 0
  fi
  if [[ "$lower" =~ (^|/)claim[_-]?55(/|\.|_|-|$) ]] ; then
    echo "protected claim_55 target path"
    return 0
  fi

  return 1
}

has_claim55_targeting() {
  local text="$1"
  local lower
  lower=$(printf '%s' "$text" | lower_text)

  [[ "$lower" =~ claim_55 ]] || [[ "$lower" =~ claim-55 ]]
}

has_comparison_language() {
  local text="$1"
  local candidate
  local lower
  candidate="$(claim_assertion_text "$text")"
  lower=$(printf '%s' "$candidate" | lower_text)

  [[ "$lower" =~ (^|[^a-z0-9])sota([^a-z0-9]|$) ]] && return 0
  [[ "$lower" =~ state-of-the-art ]] && return 0
  [[ "$lower" =~ (^|[^a-z0-9])novel(ty)?([^a-z0-9]|$) ]] && return 0
  [[ "$lower" =~ leaderboard ]] && return 0
  [[ "$lower" =~ (^|[^a-z0-9])winner([^a-z0-9]|$) ]] && return 0
  [[ "$lower" =~ public[[:space:]_-]*benchmark ]] && return 0
  [[ "$lower" =~ breakthrough ]] && return 0
  [[ "$lower" =~ verified[[:space:]_-]*claim ]] && return 0
  [[ "$lower" =~ better[[:space:]]+than[[:space:]]+(prior|previous)[[:space:]]+work ]] && return 0
  [[ "$lower" =~ outperform(s|ed|ing)?[[:space:]]+(prior|previous|baseline|sota|state-of-the-art) ]] && return 0
  return 1
}

has_phase9_11_reference() {
  local text="$1"
  local lower
  lower=$(printf '%s' "$text" | lower_text)

  [[ "$lower" =~ phase[[:space:]_.-]*(9|10|11)([^0-9]|$) ]] && return 0
  [[ "$lower" =~ (^|[^a-z0-9])p(9|10|11)([^0-9]|$) ]] && return 0
  return 1
}

claim_assertion_text() {
  printf '%s\n' "$1" |
    grep -Eiv '(^|[[:space:]>#*-])(do not|must not|no[[:space:]]|not[[:space:]]|without|unsupported|forbid|forbidden|avoid|refuse|fail closed|fail-closed|blocked by|missing|required behavior)' ||
    true
}

has_forbidden_phase9_11_public_claim() {
  local text="$1"
  local candidate
  local lower
  candidate="$(claim_assertion_text "$text")"
  lower=$(printf '%s' "$candidate" | lower_text)

  has_phase9_11_reference "$candidate" || return 1
  [[ "$lower" =~ (^|[^a-z0-9])sota([^a-z0-9]|$) ]] && return 0
  [[ "$lower" =~ state-of-the-art ]] && return 0
  [[ "$lower" =~ (^|[^a-z0-9])novel(ty)?([^a-z0-9]|$) ]] && return 0
  [[ "$lower" =~ (^|[^a-z0-9])winner([^a-z0-9]|$) ]] && return 0
  [[ "$lower" =~ leaderboard ]] && return 0
  [[ "$lower" =~ public[[:space:]_-]*benchmark ]] && return 0
  return 1
}

has_phase9_11_closure_or_performance_claim() {
  local text="$1"
  local candidate
  local lower
  candidate="$(claim_assertion_text "$text")"
  lower=$(printf '%s' "$candidate" | lower_text)

  has_phase9_11_reference "$candidate" || return 1
  [[ "$lower" =~ (complete|completed|completion|closure|done|go[[:space:]/-]*no-go|go[[:space:]]+status|green|accepted|verified|ready[[:space:]_-]*for[[:space:]_-]*claim) ]] && return 0
  [[ "$lower" =~ closed([[:space:]]+(phase|task|work|out|status|as)|[.,;:]|$) ]] && return 0
  [[ "$lower" =~ (performance|perf|accuracy|rmse|mae|mape|improv(ed|ement)?|regression[[:space:]_-]*passed|benchmark[[:space:]_-]*result) ]] && return 0
  return 1
}

is_source_ledger_path() {
  local path="$1"
  local lower
  lower=$(printf '%s' "$path" | lower_text)

  [[ "$lower" =~ (^|/)(source[-_]?ledger|sota[-_]?ledger|comparison[-_]?ledger|comparability[-_]?ledger)[^/]*\.(md|ya?ml|json|toml|csv|tsv)$ ]] && return 0
  [[ "$lower" =~ (^|/)(source[-_]?ledgers|ledgers|comparability)(/|$) ]] && return 0
  return 1
}

looks_like_comparison_path() {
  local path="$1"
  local lower
  lower=$(printf '%s' "$path" | lower_text)

  [[ "$lower" =~ (sota|state-of-the-art|novelty|leaderboard|comparison|comparability|benchmark) ]]
}

looks_like_phase9_11_claim_path() {
  local path="$1"
  local lower
  lower=$(printf '%s' "$path" | lower_text)

  [[ "$lower" =~ (phase[_.-]?(9|10|11)|p(9|10|11)).*(closure|complete|performance|benchmark|verdict|claim) ]]
}

has_field() {
  local text="$1"
  local pattern="$2"
  printf '%s\n' "$text" | grep -Eiq "$pattern"
}

ledger_text_is_complete() {
  local text="$1"

  has_field "$text" 'source[_ -]?id' || return 1
  has_field "$text" '(doi[_ -]?or[_ -]?url|doi|stable[[:space:]_-]*url|https?://|10\.[0-9]{4,9}/)' || return 1
  has_field "$text" '(retrieved[_ -]?at|retrieval[[:space:]_-]*date|retrieved[[:space:]_-]*date)' || return 1
  has_field "$text" 'metric' || return 1
  has_field "$text" 'dataset' || return 1
  has_field "$text" 'split' || return 1
  has_field "$text" '(reported[_ -]?value|external[_ -]?value|exact[[:space:]_-]*value)' || return 1
  has_field "$text" 'bsebench[_ -]?value' || return 1
  has_field "$text" 'comparability' || return 1
  has_field "$text" 'caveat' || return 1
  {
    has_field "$text" '\|[[:space:]]*comparability[[:space:]]*\|' ||
      has_field "$text" 'comparability[_ -]?table'
  } || return 1
  return 0
}

phase9_11_evidence_is_complete() {
  local text="$1"

  has_field "$text" '(cache|cached|local[_ -]?cache|cache[_ -]?root)' || return 1
  has_field "$text" 'provenance' || return 1
  has_field "$text" 'tier[[:space:]_-]*2|tier2' || return 1
  has_field "$text" 'source[[:space:]_-]*ledger|source_ledger|source-ledger' || return 1
  has_field "$text" 'empirical[[:space:]_-]*(run|evidence|artifact)|run[_ -]?id|run[[:space:]_-]*command' || return 1
  ledger_text_is_complete "$text" || return 1
  return 0
}

mapfile -t changed_paths < <(collect_paths)
added_all="$(all_added_text || true)"

ledger_candidate=0
for path in "${changed_paths[@]}" ; do
  if is_source_ledger_path "$path" ; then
    ledger_candidate=1
    break
  fi
done

ledger_present=0
if [[ "$ledger_candidate" -eq 1 ]] && ledger_text_is_complete "$added_all" ; then
  ledger_present=1
fi

phase9_11_evidence_present=0
if phase9_11_evidence_is_complete "$added_all" ; then
  phase9_11_evidence_present=1
fi

if [[ "$dry_run" -eq 1 ]] ; then
  echo "DRY-RUN: checking research diff scope; no files will be modified."
fi

allowed=0
blocked=0
review=0

emit_result() {
  local status="$1"
  local path="$2"
  local reason="$3"

  printf '[%s] %s -- %s\n' "$status" "$path" "$reason"
}

for path in "${changed_paths[@]}" ; do
  [[ -n "$path" ]] || continue

  if reason=$(protected_path_reason "$path") ; then
    emit_result "BLOCKED" "$path" "$reason"
    blocked=$((blocked + 1))
    continue
  fi

  if is_validation_only_path "$path" ; then
    emit_result "ALLOWED" "$path" "validation-only guardrail tooling or fixture"
    allowed=$((allowed + 1))
    continue
  fi

  added_text="$(added_text_for_path "$path" || true)"

  if [[ -n "$added_text" ]] && has_claim55_targeting "$added_text" ; then
    emit_result "BLOCKED" "$path" "added direct claim_55 targeting"
    blocked=$((blocked + 1))
    continue
  fi

  if [[ -n "$added_text" ]] && has_forbidden_phase9_11_public_claim "$added_text" ; then
    emit_result "BLOCKED" "$path" "Phase 9/10/11 public benchmark, SOTA, novelty, winner, or leaderboard claim"
    blocked=$((blocked + 1))
    continue
  fi

  if [[ -n "$added_text" ]] && has_phase9_11_closure_or_performance_claim "$added_text" ; then
    if [[ "$phase9_11_evidence_present" -eq 1 ]] ; then
      emit_result "ALLOWED" "$path" "Phase 9/10/11 closure/performance language with cache, provenance, Tier2, source-ledger, and empirical-run evidence in diff"
      allowed=$((allowed + 1))
    else
      emit_result "REVIEW_REQUIRED" "$path" "Phase 9/10/11 closure/performance language lacks cache, provenance, Tier2, source-ledger, or empirical-run evidence"
      review=$((review + 1))
    fi
    continue
  fi

  if [[ -n "$added_text" ]] && has_comparison_language "$added_text" ; then
    if [[ "$ledger_present" -eq 1 ]] ; then
      emit_result "ALLOWED" "$path" "comparison language with completed source ledger in diff"
      allowed=$((allowed + 1))
    else
      emit_result "REVIEW_REQUIRED" "$path" "comparison language lacks completed source ledger and comparability table"
      review=$((review + 1))
    fi
    continue
  fi

  if is_source_ledger_path "$path" ; then
    if [[ "$ledger_present" -eq 1 ]] ; then
      emit_result "ALLOWED" "$path" "completed source ledger"
      allowed=$((allowed + 1))
    else
      emit_result "REVIEW_REQUIRED" "$path" "source ledger path changed but required fields are incomplete"
      review=$((review + 1))
    fi
    continue
  fi

  if [[ -z "$diff_file" && -n "$paths_file" ]] && looks_like_comparison_path "$path" ; then
    if [[ "$ledger_present" -eq 1 ]] ; then
      emit_result "ALLOWED" "$path" "comparison-like path with completed source ledger in diff"
      allowed=$((allowed + 1))
    else
      emit_result "REVIEW_REQUIRED" "$path" "comparison-like path supplied without diff or source ledger evidence"
      review=$((review + 1))
    fi
    continue
  fi

  if [[ -z "$diff_file" && -n "$paths_file" ]] && looks_like_phase9_11_claim_path "$path" ; then
    if [[ "$phase9_11_evidence_present" -eq 1 ]] ; then
      emit_result "ALLOWED" "$path" "Phase 9/10/11 claim-like path with required evidence in diff"
      allowed=$((allowed + 1))
    else
      emit_result "REVIEW_REQUIRED" "$path" "Phase 9/10/11 claim-like path supplied without diff or required evidence"
      review=$((review + 1))
    fi
    continue
  fi

  emit_result "ALLOWED" "$path" "ordinary non-protected change"
  allowed=$((allowed + 1))
done

if [[ "${#changed_paths[@]}" -eq 0 ]] ; then
  echo "No changed files found."
fi

printf 'Research diff-scope summary: allowed=%d blocked=%d review_required=%d ledger_present=%d\n' \
  "$allowed" "$blocked" "$review" "$ledger_present"

if [[ "$blocked" -gt 0 || "$review" -gt 0 ]] ; then
  echo "Research diff-scope guard failed: blocked or review-required edits are present." >&2
  exit 1
fi

echo "Research diff-scope guard passed."
