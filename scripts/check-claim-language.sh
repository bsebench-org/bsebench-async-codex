#!/usr/bin/env bash
# check-claim-language.sh - reject unsupported claim-promotion wording.
#
# This scanner is intentionally lightweight. It is meant to catch merge-blocking
# language in async BRIEFs, reports, and evidence cards before a worker turns
# mechanical evidence into a scientific claim.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-claim-language.sh [--dry-run] [--staged|--all] [FILE ...]

Flags unsupported claim-promotion wording in async BRIEFs, reports, and
evidence cards:
  - verified-claim promotion without an explicit claim gate marker
  - SOTA/novelty/breakthrough language without an explicit source-ledger marker
  - claim_55 targeting without an explicit claim gate marker

Neutral guardrail wording is allowed, such as mechanical evidence, candidate,
not ready, falsification, and explicit "do not" prohibitions.

Explicit context markers suppress historical quotes or forbidden examples:
  - Markdown blockquote lines starting with ">"
  - fenced Markdown code blocks
  - lines containing "forbidden wording example", "quoted context", or
    "historical context"
  - JSON/Markdown sections named forbidden_phrases or forbidden examples
  - line marker: claim-language-lint: allow-line

Explicit authorization markers for real claim/comparison text:
  - claim-language-lint: allow-source-ledger
  - claim-language-lint: allow-claim-gate

With no files, the default is --staged, which includes untracked matching files.
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

is_lint_target() {
  local path="$1"
  [[ "$path" =~ (^|/)(inbox|cto/AUTONOMY_BACKLOG)/phase-[^/]*/BRIEF\.md$ ]] && return 0
  [[ "$path" =~ (^|/)outbox/.*\.(md|json|txt)$ ]] && return 0
  return 1
}

collect_files() {
  case "$mode" in
    explicit)
      printf '%s\n' "${explicit_files[@]}"
      ;;
    all)
      {
        find inbox -type f -path '*/BRIEF.md' 2>/dev/null || true
        find cto/AUTONOMY_BACKLOG -type f -path '*/BRIEF.md' 2>/dev/null || true
        find outbox -type f \( -name '*.md' -o -name '*.json' -o -name '*.txt' \) 2>/dev/null || true
      } | sort
      ;;
    staged)
      {
        git diff --name-only --cached --diff-filter=AM -- inbox cto/AUTONOMY_BACKLOG outbox 2>/dev/null || true
        git ls-files --others --exclude-standard -- inbox cto/AUTONOMY_BACKLOG outbox 2>/dev/null || true
      } | sort -u
      ;;
    *)
      echo "Error: internal mode error: $mode" >&2
      exit 2
      ;;
  esac
}

lower_line() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

has_source_ledger_authorization() {
  local path="$1"
  grep -Eiq 'claim-language-lint:[[:space:]]*allow-source-ledger' "$path" && return 0
  grep -Eiq '(source[-_ ]ledger|source ledger status)[[:space:]:=-]*(complete|completed|present|attached)' "$path" &&
    grep -Eiq '(comparability[-_ ]table|comparability table status|fair-comparison table)[[:space:]:=-]*(complete|completed|present|attached)' "$path"
}

has_claim_gate_authorization() {
  local path="$1"
  grep -Eiq 'claim-language-lint:[[:space:]]*allow-claim-gate' "$path" && return 0
  grep -Eiq '(claim[-_ ]gate|claim gate status)[[:space:]:=-]*(passed|approved|complete|completed|present)' "$path"
}

is_marked_context_line() {
  local lower="$1"
  [[ "$lower" =~ claim-language-lint:[[:space:]]*(allow-line|quoted|forbidden-example|historical-context) ]] && return 0
  [[ "$lower" =~ forbidden[[:space:]_-]*(wording[[:space:]_-]*)?examples? ]] && return 0
  [[ "$lower" =~ forbidden[[:space:]_-]*phrases? ]] && return 0
  [[ "$lower" =~ banned[[:space:]_-]*wording ]] && return 0
  [[ "$lower" =~ quoted[[:space:]_-]*context ]] && return 0
  [[ "$lower" =~ historical[[:space:]_-]*context ]] && return 0
  return 1
}

starts_marked_context_block() {
  local lower="$1"
  [[ "$lower" =~ forbidden[[:space:]_-]*phrases? ]] && return 0
  [[ "$lower" =~ banned[[:space:]_-]*wording ]] && return 0
  [[ "$lower" =~ forbidden[[:space:]_-]*(wording[[:space:]_-]*)?examples? ]] && return 0
  [[ "$lower" =~ quoted[[:space:]_-]*context ]] && return 0
  [[ "$lower" =~ historical[[:space:]_-]*context ]] && return 0
  [[ "$lower" =~ stronger[[:space:]_-]*wording[[:space:]]+such[[:space:]]+as ]] && return 0
  [[ "$lower" =~ ^[[:space:]]*#+[[:space:]]+.*(forbidden[[:space:]_-]*(wording[[:space:]_-]*)?examples?|banned[[:space:]_-]*wording|quoted[[:space:]_-]*context|historical[[:space:]_-]*context) ]] && return 0
  return 1
}

ends_marked_context_block() {
  local lower="$1"
  [[ "$lower" =~ ^[[:space:]]*#+[[:space:]]+ ]] && return 0
  [[ "$lower" =~ ^[[:space:]]*[]}] ]] && return 0
  return 1
}

has_source_claim_trigger() {
  local lower="$1"
  [[ "$lower" =~ sota ]] && return 0
  [[ "$lower" =~ state[-[:space:]]+of[-[:space:]]+the[-[:space:]]+art ]] && return 0
  [[ "$lower" =~ novelty ]] && return 0
  [[ "$lower" =~ (^|[^[:alnum:]_])novel([^[:alnum:]_]|$) ]] && return 0
  [[ "$lower" =~ breakthrough ]] && return 0
  [[ "$lower" =~ leaderboard ]] && return 0
  [[ "$lower" =~ better[[:space:]]+than[[:space:]]+prior[[:space:]]+work ]] && return 0
  return 1
}

has_verified_claim_trigger() {
  local lower="$1"
  [[ "$lower" =~ verified[[:space:]_-]+claim ]] && return 0
  [[ "$lower" =~ claim[[:space:]_-]+verified ]] && return 0
  [[ "$lower" =~ promote.{0,80}verified ]] && return 0
  [[ "$lower" =~ hinf.{0,80}verified ]] && return 0
  [[ "$lower" =~ verified.{0,80}hinf ]] && return 0
  return 1
}

has_claim55_target_trigger() {
  local lower="$1"
  [[ "$lower" =~ claim_55 ]] || return 1
  [[ "$lower" =~ (target|targeting|claim_target|promote|promotion|update|patch|edit|register|registration|verify|verified|verdict|retract|write|set|assign).{0,80}claim_55 ]] && return 0
  [[ "$lower" =~ claim_55.{0,80}(target|targeting|promote|promotion|update|patch|edit|register|registration|verify|verified|verdict|retract|write|set|assign) ]] && return 0
  return 1
}

is_source_neutral() {
  local lower="$1"
  [[ "$lower" =~ no[[:space:][:punct:]]+(sota|novel|novelty|breakthrough|verified) ]] && return 0
  [[ "$lower" =~ (do[[:space:]]+not|must[[:space:]]+not|should[[:space:]]+not|cannot|can[[:space:]]+not|never|without|unsupported|forbid|forbidden|prohibit|blocked|blocks?|avoid|flag|flags?|lint|checker|checklist|require|required|pending|unless|source[-_[:space:]]+ledger|comparability|comparison|fair|unfair|future|not[[:space:]]+ready|falsification|mechanical[[:space:]]+evidence) ]] && return 0
  return 1
}

is_verified_neutral() {
  local lower="$1"
  [[ "$lower" =~ no[[:space:][:punct:]]+(verified|claim) ]] && return 0
  [[ "$lower" =~ (do[[:space:]]+not|must[[:space:]]+not|should[[:space:]]+not|cannot|can[[:space:]]+not|never|without|unsupported|forbid|forbidden|prohibit|blocked|avoid|flag|flags?|lint|checker|checklist|not[[:space:]]+a[[:space:]]+verified|no[[:space:]]+verified|not[[:space:]]+verified|not[[:space:]]+assert|not[[:space:]]+state|claim[[:space:]]+candidate[[:space:]]+only|mechanical[[:space:]]+evidence|not[[:space:]]+ready|falsification|claim[-_[:space:]]+gate) ]] && return 0
  return 1
}

is_claim55_neutral() {
  local lower="$1"
  [[ "$lower" =~ (do[[:space:]]+not|must[[:space:]]+not|should[[:space:]]+not|cannot|can[[:space:]]+not|never|without|forbid|forbidden|prohibit|blocked|avoid|flag|flags?|lint|checker|checklist|not[[:space:]]+target|no[[:space:]]+claim_55|no[[:space:]]+.*claim_55|protected|unrelated|read-only|already|canonical|must_not_target|claim_55_targeted[^[:alnum:]]+false|new_hinf_candidate_not_claim_55|claim[-_[:space:]]+gate) ]] && return 0
  return 1
}

check_file() {
  local path="$1"

  if [[ ! -f "$path" ]] ; then
    echo "[FAIL] $path"
    echo "  [FAIL] file does not exist"
    failures=$((failures + 1))
    return
  fi

  if [[ "$mode" != "explicit" ]] && ! is_lint_target "$path" ; then
    skipped=$((skipped + 1))
    return
  fi

  echo "[CHECK] $path"
  checked=$((checked + 1))

  local source_authorized=1
  local claim_authorized=1
  if has_source_ledger_authorization "$path" ; then
    source_authorized=0
  fi
  if has_claim_gate_authorization "$path" ; then
    claim_authorized=0
  fi

  local line lower lineno=0 in_fence=0 in_marked_block=0 file_failures=0
  while IFS= read -r line || [[ -n "$line" ]] ; do
    lineno=$((lineno + 1))
    lower="$(lower_line "$line")"

    if [[ "$lower" =~ ^[[:space:]]*[\`][\`][\`] ]] ; then
      if [[ "$in_fence" -eq 1 ]] ; then
        in_fence=0
      else
        in_fence=1
      fi
      continue
    fi
    [[ "$in_fence" -eq 1 ]] && continue

    if [[ "$in_marked_block" -eq 1 ]] ; then
      if ends_marked_context_block "$lower" ; then
        in_marked_block=0
      fi
      continue
    fi

    if starts_marked_context_block "$lower" ; then
      in_marked_block=1
      continue
    fi

    [[ "$lower" =~ ^[[:space:]]*\> ]] && continue
    is_marked_context_line "$lower" && continue

    if has_source_claim_trigger "$lower" && ! is_source_neutral "$lower" && [[ "$source_authorized" -ne 0 ]] ; then
      echo "  [FAIL] $path:$lineno source-ledger gate missing for SOTA/novelty/breakthrough wording"
      file_failures=$((file_failures + 1))
    fi

    if has_verified_claim_trigger "$lower" && ! is_verified_neutral "$lower" && [[ "$claim_authorized" -ne 0 ]] ; then
      echo "  [FAIL] $path:$lineno claim gate missing for verified-claim wording"
      file_failures=$((file_failures + 1))
    fi

    if has_claim55_target_trigger "$lower" && ! is_claim55_neutral "$lower" && [[ "$claim_authorized" -ne 0 ]] ; then
      echo "  [FAIL] $path:$lineno claim gate missing for claim_55 targeting"
      file_failures=$((file_failures + 1))
    fi
  done < "$path"

  if [[ "$file_failures" -eq 0 ]] ; then
    echo "  [OK]   claim language lint"
  else
    failures=$((failures + file_failures))
  fi
}

if [[ "$dry_run" -eq 1 ]] ; then
  echo "DRY-RUN: checking claim language; no files will be modified."
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
  echo "No matching async claim-language files found."
fi

if [[ "$failures" -gt 0 ]] ; then
  echo "Claim language lint failed: $failures failure(s), $checked checked, $skipped skipped." >&2
  exit 1
fi

echo "Claim language lint passed: $checked checked, $skipped skipped."
