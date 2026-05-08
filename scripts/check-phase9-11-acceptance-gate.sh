#!/usr/bin/env bash
# check-phase9-11-acceptance-gate.sh - fail-closed lint for Phase 9/10/11 gate reports.
#
# The guard checks acceptance-gate Markdown for the distinction between tooling
# readiness, empirical readiness, and scientific closure. It is intentionally
# conservative: missing evidence language is a failure, and a positive
# scientific closure label requires explicit empirical/source-ledger support.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-phase9-11-acceptance-gate.sh [--dry-run] [--staged|--all] [REPORT.md ...]

Checks Phase 9/10/11 acceptance-gate reports for:
  - Phase 9, Phase 10, and Phase 11 scope only
  - separate tooling, empirical, and scientific closure axes
  - branch, commit, validation command, artifact, and blocker evidence fields
  - fail-closed cache/provenance/Tier2/source-ledger/empirical-run blockers
  - GO/NO-GO decisions for tooling merge, empirical scheduling, scientific
    closure, and public communication

With no files, the default is --staged, which includes untracked matching docs.
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

is_gate_report() {
  local path="$1"
  local lower
  lower=$(printf '%s' "$path" | tr '[:upper:]' '[:lower:]')

  [[ "$lower" =~ (^|/)docs/phase_9_10_11_.*acceptance.*gate.*\.md$ ]] && return 0
  [[ "$lower" =~ (^|/)docs/phase_9_10_11_.*checkpoint.*\.md$ ]] && return 0
  return 1
}

collect_files() {
  case "$mode" in
    explicit)
      printf '%s\n' "${explicit_files[@]}"
      ;;
    all)
      find docs -type f \
        \( -iname 'PHASE_9_10_11_*ACCEPTANCE*GATE*.md' -o -iname 'PHASE_9_10_11_*CHECKPOINT*.md' \) \
        2>/dev/null | sort
      ;;
    staged)
      {
        git diff --name-only --cached --diff-filter=AM -- \
          'docs/PHASE_9_10_11_*ACCEPTANCE*GATE*.md' \
          'docs/PHASE_9_10_11_*CHECKPOINT*.md'
        git ls-files --others --exclude-standard -- \
          'docs/PHASE_9_10_11_*ACCEPTANCE*GATE*.md' \
          'docs/PHASE_9_10_11_*CHECKPOINT*.md'
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
  grep -Eiq -- "$pattern" "$path"
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

forbid_pattern() {
  local path="$1"
  local label="$2"
  local pattern="$3"

  if has_pattern "$path" "$pattern" ; then
    echo "  [FAIL] $label"
    failures=$((failures + 1))
  else
    echo "  [OK]   $label"
  fi
}

check_positive_claim_gate() {
  local path="$1"

  if ! has_pattern "$path" '(^|[^[:alnum:]_])go_claim([^[:alnum:]_]|$)' ; then
    echo "  [OK]   no positive scientific closure label"
    return
  fi

  echo "  [INFO] positive scientific closure label detected; requiring support"
  require_pattern \
    "$path" \
    "positive closure has empirical artifact evidence" \
    'empirical[-[:space:]]*(run[[:space:]-]*)?artifact'
  require_pattern \
    "$path" \
    "positive closure has source-ledger-backed verdict" \
    'source[-[:space:]]*ledger[-[:space:]]*(id|backed[[:space:]-]*verdict|verdict)'
  require_pattern \
    "$path" \
    "positive closure has validation command" \
    'validation[[:space:]-]*command'
  require_pattern \
    "$path" \
    "positive closure has provenance evidence" \
    'provenance'
}

check_report() {
  local path="$1"

  if [[ ! -f "$path" ]] ; then
    echo "[FAIL] $path"
    echo "  [FAIL] file does not exist"
    failures=$((failures + 1))
    return
  fi

  if ! is_gate_report "$path" ; then
    echo "[SKIP] $path (not a Phase 9/10/11 acceptance-gate report)"
    skipped=$((skipped + 1))
    return
  fi

  echo "[CHECK] $path"
  checked=$((checked + 1))

  require_pattern "$path" "Phase 9 coverage" 'phase[[:space:]_-]*9'
  require_pattern "$path" "Phase 10 coverage" 'phase[[:space:]_-]*10'
  require_pattern "$path" "Phase 11 coverage" 'phase[[:space:]_-]*11'
  forbid_pattern "$path" "no later-phase scope" 'phase[[:space:]_-]*(1[2-9]|[2-9][0-9])'

  require_pattern "$path" "tooling axis" 'tooling'
  require_pattern "$path" "empirical axis" 'empirical'
  require_pattern "$path" "scientific closure axis" 'scientific[[:space:]_-]*closure'

  require_pattern "$path" "branch evidence field" 'branch'
  require_pattern "$path" "commit evidence field" 'commit'
  require_pattern "$path" "validation command evidence field" 'validation[[:space:]_-]*command'
  require_pattern "$path" "artifact evidence field" 'artifact'
  require_pattern "$path" "blocker evidence field" 'blocker'

  require_pattern "$path" "cache blocker named" 'cache'
  require_pattern "$path" "provenance blocker named" 'provenance'
  require_pattern "$path" "Tier2 blocker named" 'tier[[:space:]_-]*2'
  require_pattern "$path" "source-ledger blocker named" 'source[-[:space:]]*ledger'
  require_pattern "$path" "empirical-run blocker named" 'empirical[-[:space:]]*run'
  require_pattern "$path" "fail-closed scientific default" 'no_go_claim'

  require_pattern "$path" "tooling merge decision" 'tooling[[:space:]_-]*merge'
  require_pattern "$path" "empirical scheduling decision" 'empirical[[:space:]_-]*scheduling'
  require_pattern "$path" "scientific closure decision" 'scientific[[:space:]_-]*closure'
  require_pattern "$path" "public communication decision" 'public[[:space:]_-]*communication'

  forbid_pattern \
    "$path" \
    "no unsupported completion assertion" \
    'phase[[:space:]_-]*(9|10|11).{0,120}(scientifically[[:space:]_-]*)?(complete|closed)|scientific[[:space:]_-]*closure[[:space:]:-]*(complete|closed|go)'
  forbid_pattern \
    "$path" \
    "no unsupported public-performance wording" \
    'leaderboard|winner|state-of-the-art|novelty|public[[:space:]_-]*benchmark[[:space:]_-]*ready'

  check_positive_claim_gate "$path"
}

if [[ "$dry_run" -eq 1 ]] ; then
  echo "DRY-RUN: checking Phase 9/10/11 acceptance gate reports; no files will be modified."
fi

mapfile -t files < <(collect_files)

failures=0
checked=0
skipped=0

for path in "${files[@]}" ; do
  [[ -n "$path" ]] || continue
  check_report "$path"
done

if [[ "$checked" -eq 0 ]] ; then
  echo "No matching Phase 9/10/11 acceptance-gate reports found."
fi

if [[ "$failures" -gt 0 ]] ; then
  echo "Phase 9/10/11 acceptance gate checks failed: $failures failure(s), $checked checked, $skipped skipped." >&2
  exit 1
fi

echo "Phase 9/10/11 acceptance gate checks passed: $checked checked, $skipped skipped."
