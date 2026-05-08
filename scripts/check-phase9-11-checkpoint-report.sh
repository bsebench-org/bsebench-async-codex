#!/usr/bin/env bash
# Validate that a Phase 9/10/11 checkpoint report stays evidence-backed and fail-closed.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-phase9-11-checkpoint-report.sh REPORT.md

Checks that a Phase 9/10/11 checkpoint report contains evidence, blockers,
GO/NO-GO decisions, closure percentages, and a next queue while forbidding
unsupported closure or public-result wording.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "$#" -ne 1 ]]; then
  usage >&2
  exit 2
fi

report="$1"
if [[ ! -f "$report" ]]; then
  echo "Error: report not found: $report" >&2
  exit 2
fi

failures=0

require_regex() {
  local label="$1"
  local pattern="$2"

  if grep -Eiq "$pattern" "$report"; then
    echo "[OK]   $label"
  else
    echo "[FAIL] $label"
    failures=$((failures + 1))
  fi
}

forbid_regex() {
  local label="$1"
  local pattern="$2"

  if grep -Eiq "$pattern" "$report"; then
    echo "[FAIL] $label"
    grep -Ein "$pattern" "$report" >&2 || true
    failures=$((failures + 1))
  else
    echo "[OK]   $label"
  fi
}

require_regex "checkpoint title" '^#[[:space:]]+Phase 9/10/11 Checkpoint Report[[:space:]]+-'
require_regex "overall scientific no-go" 'Overall scientific closure:[[:space:]]*NO-GO'
require_regex "queueing decision" 'Queueing decision:[[:space:]]*GO only'
require_regex "empirical-run no-go" 'Empirical-run decision:[[:space:]]*NO-GO'
require_regex "scientific verdict no-go" 'Scientific verdict decision:[[:space:]]*NO-GO'
require_regex "closure percent section" '^##[[:space:]]+Closure Percent'
require_regex "evidence section" '^##[[:space:]]+Evidence Snapshot'
require_regex "branch table section" '^##[[:space:]]+Branch And Commit Table'
require_regex "validation table section" '^##[[:space:]]+Validation Table'
require_regex "phase table section" '^##[[:space:]]+Phase Decisions'
require_regex "blockers section" '^##[[:space:]]+Blockers'
require_regex "merge order section" '^##[[:space:]]+Merge Order'
require_regex "rollback section" '^##[[:space:]]+Rollback And Hold Plan'
require_regex "next queue section" '^##[[:space:]]+Next Queue'
require_regex "validation notes section" '^##[[:space:]]+Validation Notes'
require_regex "Phase 9 row" '^\|[[:space:]]*9[[:space:]]*\|'
require_regex "Phase 10 row" '^\|[[:space:]]*10[[:space:]]*\|'
require_regex "Phase 11 row" '^\|[[:space:]]*11[[:space:]]*\|'
require_regex "Tier2/cache/provenance requirement" 'Tier2.*cache.*provenance|cache.*provenance.*Tier2'
require_regex "source-ledger requirement" 'source-ledger'
require_regex "empirical evidence requirement" 'empirical-run evidence|empirical outputs'
require_regex "active queue evidence" 'Active queue evidence'

next_count=$(grep -Ec '^[0-9]+\. ' "$report" || true)
if [[ "$next_count" -ge 12 ]]; then
  echo "[OK]   next queue item count"
else
  echo "[FAIL] next queue item count: expected at least 12, found $next_count"
  failures=$((failures + 1))
fi

unsupported_result_regex='state-of-the-''art|so''ta|novel''ty|leader''board|win''ner|break''through|outperform|public benchmark'
protected_claim_regex='claim[_-]?5''5'
coauthor_regex='Co-Authored-''By[[:space:]]+Clau''de'

forbid_regex "no unsupported overall go" 'Overall scientific closure:[[:space:]]*GO([^A-Z-]|$)'
forbid_regex "no Phase 9 complete phrase" 'Phase[[:space:]]+9[[:space:]]+(is[[:space:]]+)?(complete|closed|done)'
forbid_regex "no Phase 10 complete phrase" 'Phase[[:space:]]+10[[:space:]]+(is[[:space:]]+)?(complete|closed|done)'
forbid_regex "no Phase 11 complete phrase" 'Phase[[:space:]]+11[[:space:]]+(is[[:space:]]+)?(complete|closed|done)'
forbid_regex "no later phase scope" 'Phase[[:space:]]*(1[2-9]|[2-9][0-9])'
forbid_regex "no unsupported public-result wording" "$unsupported_result_regex"
forbid_regex "no protected claim token" "$protected_claim_regex"
forbid_regex "no disallowed coauthor trailer" "$coauthor_regex"

if [[ "$failures" -gt 0 ]]; then
  echo "Phase 9/10/11 checkpoint report check failed: $failures failure(s)." >&2
  exit 1
fi

echo "Phase 9/10/11 checkpoint report check passed."
