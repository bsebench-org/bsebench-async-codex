#!/usr/bin/env bash
# check-phase9-11-merge-matrix.sh - fail-closed lint for Phase 9/10/11 merge matrices.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-phase9-11-merge-matrix.sh [--dry-run] [--staged|--all] [REPORT.md ...]

Checks Phase 9/10/11 merge-matrix reports for:
  - Phase 9, Phase 10, and Phase 11 scope only
  - explicit no-merge posture
  - fail-closed merge, empirical, and scientific claim gates
  - cache/provenance/Tier2/source-ledger/empirical-run blockers
  - required validation commands and current refill branch rows

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

is_matrix_report() {
  local path="$1"
  local lower
  lower=$(printf '%s' "$path" | tr '[:upper:]' '[:lower:]')

  [[ "$lower" =~ (^|/)docs/phase_9_10_11_.*merge.*matrix.*\.md$ ]] && return 0
  [[ "$lower" =~ (^|/)docs/phase-9-10-11-.*merge.*matrix.*\.md$ ]] && return 0
  return 1
}

collect_files() {
  case "$mode" in
    explicit)
      printf '%s\n' "${explicit_files[@]}"
      ;;
    all)
      find docs -type f \
        \( -iname 'PHASE_9_10_11_*MERGE*MATRIX*.md' -o -iname 'PHASE-9-10-11-*MERGE*MATRIX*.md' \) \
        2>/dev/null | sort
      ;;
    staged)
      {
        git diff --name-only --cached --diff-filter=AM -- \
          'docs/PHASE_9_10_11_*MERGE*MATRIX*.md' \
          'docs/PHASE-9-10-11-*MERGE*MATRIX*.md'
        git ls-files --others --exclude-standard -- \
          'docs/PHASE_9_10_11_*MERGE*MATRIX*.md' \
          'docs/PHASE-9-10-11-*MERGE*MATRIX*.md'
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

has_literal() {
  local path="$1"
  local literal="$2"
  grep -Fq -- "$literal" "$path"
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

require_literal() {
  local path="$1"
  local label="$2"
  local literal="$3"

  if has_literal "$path" "$literal" ; then
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

check_report() {
  local path="$1"

  if [[ ! -f "$path" ]] ; then
    echo "[FAIL] $path"
    echo "  [FAIL] file does not exist"
    failures=$((failures + 1))
    return
  fi

  if ! is_matrix_report "$path" ; then
    echo "[SKIP] $path (not a Phase 9/10/11 merge-matrix report)"
    skipped=$((skipped + 1))
    return
  fi

  echo "[CHECK] $path"
  checked=$((checked + 1))

  require_pattern "$path" "Phase 9 coverage" 'phase[[:space:]_/-]*9'
  require_pattern "$path" "Phase 10 coverage" 'phase[[:space:]_/-]*10'
  require_pattern "$path" "Phase 11 coverage" 'phase[[:space:]_/-]*11'
  forbid_pattern "$path" "no later-phase scope" 'phase[[:space:]_/-]*(1[2-9]|[2-9][0-9])'

  require_pattern "$path" "no-merge posture" 'do not merge|no-merge|performs no merge'
  require_pattern "$path" "NO_GO_MERGE gate" 'no_go_merge'
  require_pattern "$path" "NO_GO_EMPIRICAL gate" 'no_go_empirical'
  require_pattern "$path" "NO_GO_CLAIM gate" 'no_go_claim'
  forbid_pattern "$path" "no positive merge gate" '(^|[^A-Z_])GO_MERGE([^A-Z_]|$)'
  forbid_pattern "$path" "no positive empirical gate" '(^|[^A-Z_])GO_EMPIRICAL([^A-Z_]|$)'
  forbid_pattern "$path" "no positive claim gate" '(^|[^A-Z_])GO_CLAIM([^A-Z_]|$)'

  require_pattern "$path" "branch evidence field" 'branch'
  require_pattern "$path" "commit evidence field" 'commit'
  require_pattern "$path" "validation command evidence field" 'validation[[:space:]_-]*command'
  require_pattern "$path" "artifact evidence field" 'artifact'
  require_pattern "$path" "blocker evidence field" 'blocker'
  require_pattern "$path" "clean worktree gate" 'clean[[:space:]_-]*worktree'
  require_pattern "$path" "dirty worktree blocker" 'dirty[[:space:]_-]*worktree'
  require_pattern "$path" "GLASSBOX subject gate" 'glassbox'

  require_pattern "$path" "cache blocker named" 'cache'
  require_pattern "$path" "provenance blocker named" 'provenance'
  require_pattern "$path" "Tier2 blocker named" 'tier[[:space:]_-]*2'
  require_pattern "$path" "source-ledger blocker named" 'source[-[:space:]]*ledger'
  require_pattern "$path" "empirical-run blocker named" 'empirical[-[:space:]]*run'

  require_literal "$path" "diff check command" "git diff --check"
  require_pattern "$path" "focused tests command guidance" 'focused tests'
  require_pattern "$path" "ruff check guidance" 'ruff check'
  require_pattern "$path" "format check guidance" 'format --check|format check'

  require_literal "$path" "acceptance gate row" "phase9-11-refill-p9-11-acceptance-gate-20260508T215244+0200"
  require_literal "$path" "anti-claim audit row" "phase9-11-refill-p9-11-anti-claim-audit-20260508T220147+0200"
  require_literal "$path" "checkpoint report row" "phase9-11-refill-p9-11-checkpoint-report-20260508T220012+0200"
  require_literal "$path" "merge matrix row" "phase9-11-refill-p9-11-merge-matrix-20260508T220131+0200"
  require_literal "$path" "schema export row" "phase9-11-refill-p9-11-schema-export-audit-20260508T215904+0200"
  require_literal "$path" "filter contract row" "phase9-11-refill-p9-11-contract-export-audit-20260508T220007+0200"
  require_literal "$path" "Phase 9 cache row" "phase9-11-refill-p9-tier2-profile-cache-20260508T215254+0200"
  require_literal "$path" "Phase 10 cache row" "phase9-11-refill-p10-tier2-aging-cache-20260508T215302+0200"
  require_literal "$path" "Phase 11 cache row" "phase9-11-refill-p11-tier2-residual-cache-20260508T215408+0200"
  require_literal "$path" "local path discovery row" "phase9-11-refill-p9-11-local-path-discovery-20260508T215013+0200"
  require_literal "$path" "Phase 9 runner row" "phase9-11-refill-p9-profile-empirical-scheduler-20260508T215517+0200"
  require_literal "$path" "Phase 10 runner row" "phase9-11-refill-p10-aging-empirical-scheduler-20260508T215522+0200"
  require_literal "$path" "Phase 11 runner row" "phase9-11-refill-p11-residual-trace-scheduler-20260508T215527+0200"
  require_literal "$path" "CLI smoke row" "phase9-11-refill-p9-11-dryrun-cli-smoke-20260508T215025+0200"
  require_literal "$path" "wording linter row" "phase9-11-refill-p9-11-no-claims-linter-20260508T215035+0200"
  require_literal "$path" "Phase 9 stats row" "phase9-11-refill-p9-profile-verdict-inputs-20260508T215536+0200"
  require_literal "$path" "Phase 10 stats row" "phase9-11-refill-p10-aging-verdict-inputs-20260508T215745+0200"
  require_literal "$path" "Phase 11 stats row" "phase9-11-refill-p11-residual-verdict-inputs-20260508T215755+0200"

  forbid_pattern \
    "$path" \
    "no unsupported public-performance wording" \
    'leaderboard|winner|state-of-the-art|novelty|public[[:space:]_-]*benchmark[[:space:]_-]*ready'
}

if [[ "$dry_run" -eq 1 ]] ; then
  echo "DRY-RUN: checking Phase 9/10/11 merge-matrix reports; no files will be modified."
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
  echo "No matching Phase 9/10/11 merge-matrix reports found."
fi

if [[ "$failures" -gt 0 ]] ; then
  echo "Phase 9/10/11 merge-matrix checks failed: $failures failure(s), $checked checked, $skipped skipped." >&2
  exit 1
fi

echo "Phase 9/10/11 merge-matrix checks passed: $checked checked, $skipped skipped."
