#!/usr/bin/env bash
# check-public-claims-language.sh - conservative public-report claim wording gate.
#
# The checker flags strong benchmark, leaderboard, SOTA, novelty, superiority,
# and verification phrases unless the same line is framed as a guardrail,
# missing-evidence blocker, source-ledger requirement, or candidate/mechanical
# context. It is intentionally line-oriented so reviewers can inspect every
# finding without hidden inference.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-public-claims-language.sh [--staged|--all] [FILE ...]

Flags unsupported public-report claim wording:
  - SOTA / state-of-the-art / leaderboard-leading
  - novelty / breakthrough / first-of-its-kind
  - superior / best / outperforms / beats
  - verified / proven / validated scientific claims
  - universal benchmark wording coupled to proof/completeness/superiority

Guardrail contexts are allowed when the same line clearly frames the wording as
unsupported, prohibited, candidate-only, blocked by missing evidence, or tied to
a source ledger / comparability / replay / provenance requirement.

With explicit FILE arguments, every file is checked. With no FILE arguments,
the default is --staged, which checks staged and untracked public-facing docs but
excludes this checker's negative fixture corpus.
USAGE
}

mode="staged"
explicit_files=()

while [[ $# -gt 0 ]] ; do
  case "$1" in
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

is_public_text_file() {
  local path="$1"

  case "$path" in
    tests/fixtures/public-claims-linter/fail-*) return 1 ;;
    tests/fixtures/public-claims-linter/*) return 0 ;;
    README|README.*|CHANGELOG*|RELEASE*|*.md|*.txt|*.rst) return 0 ;;
    docs/*|reports/*|outbox/*|validation/*) return 0 ;;
    *) return 1 ;;
  esac
}

collect_files() {
  case "$mode" in
    explicit)
      printf '%s\n' "${explicit_files[@]}"
      ;;
    all)
      git ls-files \
        'README' 'README.*' 'CHANGELOG*' 'RELEASE*' \
        '*.md' '*.txt' '*.rst' \
        'docs/**' 'reports/**' 'outbox/**' 'validation/**' \
        'tests/fixtures/public-claims-linter/**'
      ;;
    staged)
      {
        git diff --name-only --cached --diff-filter=AM -- \
          'README' 'README.*' 'CHANGELOG*' 'RELEASE*' \
          '*.md' '*.txt' '*.rst' \
          'docs/**' 'reports/**' 'outbox/**' 'validation/**' \
          'tests/fixtures/public-claims-linter/**'
        git ls-files --others --exclude-standard -- \
          'README' 'README.*' 'CHANGELOG*' 'RELEASE*' \
          '*.md' '*.txt' '*.rst' \
          'docs/**' 'reports/**' 'outbox/**' 'validation/**' \
          'tests/fixtures/public-claims-linter/**'
      } | sort -u
      ;;
    *)
      echo "Error: internal mode error: $mode" >&2
      exit 2
      ;;
  esac
}

has_guardrail_context() {
  local line="$1"

  [[ "$line" =~ (^|[^[:alnum:]_])(no|not|never|without|unsupported|forbid|forbidden|prohibit|prohibited|disallow|disallowed|avoid|blocked|blocker|missing|gap|caveat|candidate|mechanical|neutral|guardrail|source[[:space:]-]ledger|stable[[:space:]-]url|doi|comparability|comparable|partial|not[[:space:]-]comparable|provenance|replay|falsification|validated[[:space:]-]evidence|frozen[[:space:]-]evidence|requires?|requirement|required|must|should)([^[:alnum:]_]|$) ]]
}

claim_label_for_line() {
  local line="$1"

  if [[ "$line" =~ (^|[^[:alnum:]_])(sota|state[[:space:]-]of[[:space:]-]the[[:space:]-]art)([^[:alnum:]_]|$) ]] ; then
    echo "SOTA/state-of-the-art wording"
    return 0
  fi

  if [[ "$line" =~ (^|[^[:alnum:]_])(leaderboard|leaderboard[[:space:]-]leading|top[[:space:]-]ranked|ranked[[:space:]]*#?[[:space:]]*(1|one)|rank[[:space:]]*#?[[:space:]]*(1|one))([^[:alnum:]_]|$) ]] ; then
    echo "leaderboard/ranking wording"
    return 0
  fi

  if [[ "$line" =~ (^|[^[:alnum:]_])(breakthrough|novel|novelty|first[[:space:]-]of[[:space:]-]its[[:space:]-]kind|first[[:space:]-]ever)([^[:alnum:]_]|$) ]] ; then
    echo "novelty/breakthrough wording"
    return 0
  fi

  if [[ "$line" =~ (^|[^[:alnum:]_])(superior|best|best[[:space:]-]in[[:space:]-]class|best[[:space:]-]performing|outperform|outperforms|outperformed|outperforming|beat|beats|beating)([^[:alnum:]_]|$) ]] ; then
    echo "superiority wording"
    return 0
  fi

  if [[ "$line" =~ (^|[^[:alnum:]_])(verified|proven|proved|proves|validated|validates)([^[:alnum:]_]|$) ]] ; then
    echo "verification/proof wording"
    return 0
  fi

  if [[ "$line" =~ (^|[^[:alnum:]_])universal[[:space:]-]benchmark([^[:alnum:]_]|$) ]] && [[ "$line" =~ (^|[^[:alnum:]_])(complete|complete[[:space:]-]coverage|covers[[:space:]]+all|representative|definitive|verified|proven|proves|superior|leaderboard|sota)([^[:alnum:]_]|$) ]] ; then
    echo "universal benchmark overreach wording"
    return 0
  fi

  return 1
}

check_file() {
  local path="$1"
  local line_number=0
  local line=""
  local lowered=""
  local label=""
  local file_failures=0

  if [[ ! -f "$path" ]] ; then
    echo "[FAIL] $path"
    echo "  file does not exist"
    failures=$((failures + 1))
    return
  fi

  if [[ "$mode" != "explicit" ]] && ! is_public_text_file "$path" ; then
    echo "[SKIP] $path"
    skipped=$((skipped + 1))
    return
  fi

  checked=$((checked + 1))

  while IFS= read -r line || [[ -n "$line" ]] ; do
    line_number=$((line_number + 1))
    lowered="${line,,}"
    lowered="${lowered//$'\r'/}"

    if label="$(claim_label_for_line "$lowered")" ; then
      if has_guardrail_context "$lowered" ; then
        continue
      fi

      echo "[FAIL] $path:$line_number: $label"
      echo "  $line"
      failures=$((failures + 1))
      file_failures=$((file_failures + 1))
    fi
  done < "$path"

  if [[ "$file_failures" -eq 0 ]] ; then
    echo "[OK]   $path"
  fi
}

mapfile -t files < <(collect_files)

failures=0
checked=0
skipped=0

for path in "${files[@]}" ; do
  [[ -n "$path" ]] || continue
  check_file "$path"
done

if [[ "$checked" -eq 0 ]] ; then
  echo "No public-facing text files found."
fi

if [[ "$failures" -gt 0 ]] ; then
  echo "Public claim-language checks failed: $failures finding(s), $checked checked, $skipped skipped." >&2
  exit 1
fi

echo "Public claim-language checks passed: $checked checked, $skipped skipped."
