#!/usr/bin/env bash
# check-research-brief-gates.sh - lightweight guardrail check for research BRIEFs.
#
# Default mode checks staged and untracked Phase 7/8/11 BRIEF.md files. Pass
# explicit files for local review, or --all to audit every matching BRIEF.
# This also accepts curated autonomy backlog BRIEFs under
# cto/AUTONOMY_BACKLOG/<phase-id>/BRIEF.md before they are copied to inbox.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-research-brief-gates.sh [--dry-run] [--staged|--all] [BRIEF.md ...]

Checks Phase 7/8/11 inbox or autonomy-backlog BRIEFs for minimum research-gate wording:
  - falsification condition
  - validation/replay wording
  - no thesis/claim registry edits
  - no claim_55 targeting
  - no unsupported SOTA claims

With no files, the default is --staged, which includes untracked BRIEFs.
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

is_research_brief() {
  local path="$1"
  [[ "$path" =~ (^|/)(inbox|cto/AUTONOMY_BACKLOG)/phase-(7|8|11)[^/]*/BRIEF\.md$ ]]
}

collect_files() {
  case "$mode" in
    explicit)
      printf '%s\n' "${explicit_files[@]}"
      ;;
    all)
      {
        find inbox -type f -path '*/BRIEF.md'
        find cto/AUTONOMY_BACKLOG -type f -path '*/BRIEF.md' 2>/dev/null || true
      } | sort
      ;;
    staged)
      {
        git diff --name-only --cached --diff-filter=AM -- \
          'inbox/phase-7*/BRIEF.md' \
          'inbox/phase-8*/BRIEF.md' \
          'inbox/phase-11*/BRIEF.md' \
          'cto/AUTONOMY_BACKLOG/phase-7*/BRIEF.md' \
          'cto/AUTONOMY_BACKLOG/phase-8*/BRIEF.md' \
          'cto/AUTONOMY_BACKLOG/phase-11*/BRIEF.md'
        git ls-files --others --exclude-standard -- \
          'inbox/phase-7*/BRIEF.md' \
          'inbox/phase-8*/BRIEF.md' \
          'inbox/phase-11*/BRIEF.md' \
          'cto/AUTONOMY_BACKLOG/phase-7*/BRIEF.md' \
          'cto/AUTONOMY_BACKLOG/phase-8*/BRIEF.md' \
          'cto/AUTONOMY_BACKLOG/phase-11*/BRIEF.md'
      } | sort -u
      ;;
    *)
      echo "Error: internal mode error: $mode" >&2
      exit 2
      ;;
  esac
}

has_pattern() {
  local path="$1"
  local pattern="$2"
  grep -Eiq "$pattern" "$path"
}

require_pattern() {
  local path="$1"
  local label="$2"
  local pattern="$3"

  if has_pattern "$path" "$pattern" ; then
    echo "  [OK]   $label"
  else
    echo "  [FAIL] $label"
    failures=$((failures + 1))
  fi
}

reject_claim55_target_instruction() {
  local path="$1"
  local offending

  offending="$(
    awk '
      {
        line = tolower($0)
      }
      line ~ /claim_55/ && line ~ /(target|targeting|targets|promote|promotes|promotion|verified[ _-]?claim)/ {
        if (line ~ /(do not|must not|shall not|avoid|forbid|forbidden|unrelated|flag.*claim_55|must fail|fail validation|without being flagged|no[[:space:]_-]+claim_55|no[[:space:]_-]+.*target|not[[:space:]_-]+.*target)/) {
          next
        }
        print
        exit
      }
    ' "$path"
  )"

  if [[ -n "$offending" ]] ; then
    echo "  [FAIL] no protected claim_55 target instruction"
    failures=$((failures + 1))
  else
    echo "  [OK]   no protected claim_55 target instruction"
  fi
}

check_brief() {
  local path="$1"

  if [[ ! -f "$path" ]] ; then
    echo "[FAIL] $path"
    echo "  [FAIL] file does not exist"
    failures=$((failures + 1))
    return
  fi

  if ! is_research_brief "$path" ; then
    echo "[SKIP] $path (not inbox/phase-7, phase-8, or phase-11 BRIEF.md)"
    skipped=$((skipped + 1))
    return
  fi

  echo "[CHECK] $path"
  checked=$((checked + 1))

  require_pattern \
    "$path" \
    "falsification condition" \
    'falsif|failure condition|would prove|prove.*wrong|must fail|fail if'

  require_pattern \
    "$path" \
    "validation or replay wording" \
    'validation|validat|replay|independent validator|verify'

  require_pattern \
    "$path" \
    "no thesis/claim registry edits" \
    '(do not|must not|no)[[:alnum:]_ ./,-]{0,140}(thesis|claim registry|claims/registry\.yaml|registry)'

  require_pattern \
    "$path" \
    "no claim_55 targeting" \
    '((do not|must not|no|not).{0,180}claim_55|claim_55.{0,180}(protected|not|no|forbid|avoid|target|unrelated))'

  reject_claim55_target_instruction "$path"

  require_pattern \
    "$path" \
    "no unsupported SOTA claims" \
    '((do not|must not|no|not|without|unsupported)[[:alnum:]_ ./,-]{0,140}sota|sota[[:alnum:]_ ./,-]{0,140}(unsupported|source ledger|doi|stable url|comparability|claim|status|novelty))'
}

if [[ "$dry_run" -eq 1 ]] ; then
  echo "DRY-RUN: checking research BRIEF guardrails; no files will be modified."
fi

mapfile -t files < <(collect_files)

failures=0
checked=0
skipped=0

for path in "${files[@]}" ; do
  [[ -n "$path" ]] || continue
  check_brief "$path"
done

if [[ "$checked" -eq 0 ]] ; then
  echo "No matching Phase 7/8/11 BRIEF.md files found."
fi

if [[ "$failures" -gt 0 ]] ; then
  echo "Research BRIEF gate checks failed: $failures failure(s), $checked checked, $skipped skipped." >&2
  exit 1
fi

echo "Research BRIEF gate checks passed: $checked checked, $skipped skipped."
