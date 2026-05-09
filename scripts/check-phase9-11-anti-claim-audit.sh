#!/usr/bin/env bash
# check-phase9-11-anti-claim-audit.sh - fail-closed claim audit for Phase 9/10/11 diffs.
#
# This guard is intentionally narrow: it audits changed Phase 9/10/11 text for
# unsupported closure/performance claims and public benchmark/comparison claims.
# It does not decide scientific readiness; it only rejects risky language unless
# the same added text carries explicit evidence markers.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-phase9-11-anti-claim-audit.sh [--dry-run] [--repo DIR] [--base REV] [--head REV]
  scripts/check-phase9-11-anti-claim-audit.sh [--dry-run] --staged [--repo DIR]
  scripts/check-phase9-11-anti-claim-audit.sh [--dry-run] --paths FILE [--diff FILE]

Checks changed Phase 9/10/11 paths or added text for:
  - forbidden SOTA, novelty, winner, leaderboard, or public benchmark claims
  - closure/performance claims without positive cache, provenance, Tier2,
    source-ledger, and empirical-run evidence markers

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

has_pattern() {
  local text="$1"
  local pattern="$2"
  printf '%s\n' "$text" | grep -Eiq "$pattern"
}

is_validation_only_path() {
  local path="$1"

  [[ "$path" =~ ^scripts/check-phase9-11-anti-claim-audit\.sh$ ]] && return 0
  [[ "$path" =~ ^scripts/probe-phase9-11-anti-claim-audit\.sh$ ]] && return 0
  [[ "$path" =~ ^tests?/fixtures/phase9[-_]11[-_]anti[-_]claim ]] && return 0
  return 1
}

is_phase9_11_text() {
  local text lower
  text="$1"
  lower=$(printf '%s' "$text" | lower_text)

  has_pattern "$lower" 'phase[[:space:]_-]*9([/[:space:]_-]*10)?([/[:space:]_-]*11)?' && return 0
  has_pattern "$lower" 'phase[[:space:]_-]*10' && return 0
  has_pattern "$lower" 'phase[[:space:]_-]*11' && return 0
  has_pattern "$lower" 'phase9-11|phase9_11|phase9/10/11' && return 0
  has_pattern "$lower" '(^|[^a-z0-9])p(9|10|11)[_-]' && return 0
  return 1
}

is_phase9_11_path() {
  local path lower
  path="$1"
  lower=$(printf '%s' "$path" | lower_text)

  is_phase9_11_text "$lower" && return 0
  [[ "$lower" =~ ^\.codex-direct-prompts/p(9|10|11)_ ]] && return 0
  return 1
}

is_guardrail_line() {
  local line lower
  line="$1"
  lower=$(printf '%s' "$line" | lower_text)

  has_pattern "$lower" '(do not|must not|forbid|forbidden|ban|banned|unsupported|without|unless)' && return 0
  has_pattern "$lower" '(fail[[:space:]_-]*closed|no-go|blocked|blocker|reject|refuse|not[[:space:]]+declare)' && return 0
  has_pattern "$lower" '(^|[^a-z0-9])no[[:space:]_-]+(sota|novelty|winner|leaderboard|claim|claims|closure|performance)' && return 0
  return 1
}

is_negative_evidence_line() {
  local line lower
  line="$1"
  lower=$(printf '%s' "$line" | lower_text)

  has_pattern "$lower" '(missing|absent|unavailable|incomplete|unknown|without|lacks?|not[[:space:]_-]*ready)' && return 0
  has_pattern "$lower" '(no-go|blocked|blocker|fail|fails|failure|reject|refuse)' && return 0
  return 1
}

non_guardrail_text() {
  local line

  while IFS= read -r line ; do
    if ! is_guardrail_line "$line" ; then
      printf '%s\n' "$line"
    fi
  done
}

positive_evidence_text() {
  local line

  while IFS= read -r line ; do
    if ! is_guardrail_line "$line" && ! is_negative_evidence_line "$line" ; then
      printf '%s\n' "$line"
    fi
  done
}

has_forbidden_public_benchmark_claim() {
  local text lower
  text="$1"
  lower=$(printf '%s' "$text" | lower_text)

  has_pattern "$lower" '(^|[^a-z0-9])sota([^a-z0-9]|$)' && return 0
  has_pattern "$lower" 'state-of-the-art' && return 0
  has_pattern "$lower" '(^|[^a-z0-9])novel(ty)?([^a-z0-9]|$)' && return 0
  has_pattern "$lower" '(^|[^a-z0-9])winner([^a-z0-9]|$)' && return 0
  has_pattern "$lower" 'leaderboard' && return 0
  has_pattern "$lower" 'public[[:space:]_-]*benchmark[[:space:]_-]*(claim|status|result|leader|win|winner)' && return 0
  return 1
}

has_closure_or_performance_claim() {
  local text lower
  text="$1"
  lower=$(printf '%s' "$text" | lower_text)

  has_pattern "$lower" '(phase[[:space:]_-]*(9|10|11)|(^|[^a-z0-9])p(9|10|11)[_-]).{0,140}(complete|completed|closed|closure|done|accepted|validated|verified|ready|unblocked)' && return 0
  has_pattern "$lower" '(scientific[[:space:]_-]*(status|verdict)|claim[[:space:]_-]*(status|verdict)).{0,100}(go|complete|closed|verified|accepted|ready)' && return 0
  has_pattern "$lower" '(performance|metric|rmse|mae|accuracy|error).{0,100}(improve|improved|improvement|gain|better|lower|higher)' && return 0
  has_pattern "$lower" '(improve|improved|improvement|outperform|outperformed|outperforms|beat|beats|better[[:space:]]+than).{0,100}(baseline|prior|previous|method|phase[[:space:]_-]*(9|10|11))' && return 0
  return 1
}

has_required_evidence_markers() {
  local text lower
  text="$1"
  lower=$(printf '%s' "$text" | lower_text)

  has_pattern "$lower" 'cache|local[[:space:]_-]*cache' || return 1
  has_pattern "$lower" 'provenance' || return 1
  has_pattern "$lower" 'tier[[:space:]_-]*2|tier2' || return 1
  has_pattern "$lower" 'source[[:space:]_-]*ledger|source-ledger' || return 1
  has_pattern "$lower" 'empirical[[:space:]_-]*(run|runs|artifact|artifacts|evidence)|real[[:space:]_-]*(run|runs|data)' || return 1
  return 0
}

emit_result() {
  local status="$1"
  local path="$2"
  local reason="$3"

  printf '[%s] %s -- %s\n' "$status" "$path" "$reason"
}

if [[ "$dry_run" -eq 1 ]] ; then
  echo "DRY-RUN: checking Phase 9/10/11 anti-claim audit; no files will be modified."
fi

mapfile -t changed_paths < <(collect_paths)

allowed=0
blocked=0
review=0
audited=0

for path in "${changed_paths[@]}" ; do
  [[ -n "$path" ]] || continue

  if is_validation_only_path "$path" ; then
    emit_result "ALLOWED" "$path" "validation-only Phase 9/10/11 claim-audit tooling or fixture"
    allowed=$((allowed + 1))
    continue
  fi

  added_text="$(added_text_for_path "$path" || true)"
  audit_text="$(printf '%s\n' "$added_text" | non_guardrail_text)"
  evidence_text="$(printf '%s\n' "$added_text" | positive_evidence_text)"

  if ! is_phase9_11_path "$path" && ! is_phase9_11_text "$added_text" ; then
    emit_result "ALLOWED" "$path" "outside Phase 9/10/11 claim-audit scope"
    allowed=$((allowed + 1))
    continue
  fi

  audited=$((audited + 1))

  if [[ -z "$added_text" && -n "$paths_file" && -z "$diff_file" ]] ; then
    emit_result "REVIEW_REQUIRED" "$path" "Phase 9/10/11 path supplied without diff text or evidence"
    review=$((review + 1))
    continue
  fi

  if has_forbidden_public_benchmark_claim "$audit_text" ; then
    emit_result "BLOCKED" "$path" "forbidden SOTA/novelty/winner/leaderboard/public benchmark claim"
    blocked=$((blocked + 1))
    continue
  fi

  if has_closure_or_performance_claim "$audit_text" ; then
    if has_required_evidence_markers "$evidence_text" ; then
      emit_result "ALLOWED" "$path" "closure/performance language has required positive evidence markers"
      allowed=$((allowed + 1))
    else
      emit_result "REVIEW_REQUIRED" "$path" "unsupported closure/performance claim lacks cache/provenance/Tier2/source-ledger/empirical-run evidence"
      review=$((review + 1))
    fi
    continue
  fi

  emit_result "ALLOWED" "$path" "Phase 9/10/11 text has no unsupported closure/performance claim"
  allowed=$((allowed + 1))
done

if [[ "${#changed_paths[@]}" -eq 0 ]] ; then
  echo "No changed files found."
fi

printf 'Phase 9/10/11 anti-claim audit summary: allowed=%d blocked=%d review_required=%d audited=%d\n' \
  "$allowed" "$blocked" "$review" "$audited"

if [[ "$blocked" -gt 0 || "$review" -gt 0 ]] ; then
  echo "Phase 9/10/11 anti-claim audit failed: blocked or review-required claims are present." >&2
  exit 1
fi

echo "Phase 9/10/11 anti-claim audit passed."
