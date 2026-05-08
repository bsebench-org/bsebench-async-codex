#!/usr/bin/env bash
# check-phase9-11-checkpoint-report.sh - focused guard for Phase 9/10/11 checkpoint reports.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-phase9-11-checkpoint-report.sh REPORT.md

Checks that a Phase 9/10/11 checkpoint report:
  - contains the required audit-plan sections
  - keeps empirical, claim, public, and Phase 12/13 decisions fail-closed
  - records cache/provenance/Tier2/source-ledger/empirical-run blockers
  - avoids positive scientific-closure or public-result wording
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] ; then
  usage
  exit 0
fi

report="${1:-}"
if [[ -z "$report" ]] ; then
  usage >&2
  exit 2
fi
if [[ ! -f "$report" ]] ; then
  echo "[FAIL] report not found: $report" >&2
  exit 2
fi

failures=0

require_fixed() {
  local label="$1"
  local needle="$2"

  if grep -Fq "$needle" "$report" ; then
    echo "[OK]   $label"
  else
    echo "[FAIL] $label" >&2
    failures=$((failures + 1))
  fi
}

reject_regex() {
  local label="$1"
  local pattern="$2"

  if grep -Eiq "$pattern" "$report" ; then
    echo "[FAIL] $label" >&2
    grep -Ein "$pattern" "$report" >&2 || true
    failures=$((failures + 1))
  else
    echo "[OK]   $label"
  fi
}

require_fixed "title" "# Phase 9/10/11 General Audit Checkpoint"
require_fixed "evidence sources" "## Evidence Sources"
require_fixed "executive status" "## Executive Status"
require_fixed "percent complete" "## Percent Complete"
require_fixed "branch evidence" "## Branch/Commit Evidence"
require_fixed "validation table" "## Validation Table"
require_fixed "blockers" "## Blockers"
require_fixed "merge order" "## Merge Order"
require_fixed "rollback plan" "## Rollback Plan"
require_fixed "next queue" "## Next Queue"
require_fixed "final go no-go" "## Final GO/NO-GO"
require_fixed "tooling decision" "GO_TOOLING_WITH_REVALIDATION"
require_fixed "empirical no-go" "NO_GO_EMPIRICAL"
require_fixed "claim no-go" "NO_GO_CLAIM"
require_fixed "public no-go" "NO_GO_PUBLIC"
require_fixed "phase 12/13 locked" "Unlock Phase 12/13 work"
require_fixed "cache blocker" "cache"
require_fixed "provenance blocker" "provenance"
require_fixed "tier2 blocker" "Tier2"
require_fixed "source-ledger blocker" "source-ledger"
require_fixed "empirical-run blocker" "empirical-run"
require_fixed "hf upload zero" 'real HF upload processes: `0`'

reject_regex "no disallowed co-author trailer" '^Co-Authored-By:.*Clau''de'
reject_regex "no GO empirical decision" '(^|[^A-Z_])GO_EMPIRICAL([^A-Z_]|$)'
reject_regex "no GO claim decision" '(^|[^A-Z_])GO_CLAIM([^A-Z_]|$)'
reject_regex "no GO public decision" '(^|[^A-Z_])GO_PUBLIC([^A-Z_]|$)'
reject_regex "no positive complete claim" 'Phase (9|10|11)[^.\n|]*(is|are|:)[^.\n|]*(scientifically )?complete'
reject_regex "no public-result positive wording" '(leaderboard-ready|winner-ready|public benchmark-result claim|SOTA result|novel result|claim-registry-ready)'
reject_regex "no dataset-download authorization" '(authorize|authorized|run|schedule)[^.\n|]*(dataset download|Hugging Face download|HF download)'

if [[ "$failures" -gt 0 ]] ; then
  echo "Phase 9/10/11 checkpoint report check failed: $failures failure(s)." >&2
  exit 1
fi

echo "Phase 9/10/11 checkpoint report check passed."
