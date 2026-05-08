#!/usr/bin/env bash
# probe-phase9-11-merge-matrix.sh - focused checks for the Phase 9/10/11 merge matrix.

set -euo pipefail

REPORT="${1:-docs/PHASE_9_10_11_MERGE_MATRIX_20260508T213209+0200.md}"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

require_file() {
  [[ -f "$REPORT" ]] || fail "report not found: $REPORT"
}

require_contains() {
  local needle="$1"

  grep -Fq "$needle" "$REPORT" || fail "missing required text: $needle"
}

reject_regex() {
  local pattern="$1"
  local label="$2"

  if grep -Eiq "$pattern" "$REPORT" ; then
    fail "unexpected $label"
  fi
}

require_file

require_contains "Decision: do not merge from this branch."
require_contains "| 1 | \`bsebench-specs\` |"
require_contains "| 2 | \`bsebench-filters\` |"
require_contains "| 3 | \`bsebench-datasets\` |"
require_contains "| 4 | \`bsebench-stats\` |"
require_contains "| 5 | \`bsebench-runner\` |"
require_contains "| Phase 9 | GO for integrated tooling and dry-run budgeting | NO-GO | NO-GO scientific closure |"
require_contains "| Phase 10 | GO for readiness gates, schemas, budgets, and stats contracts | NO-GO | NO-GO scientific closure |"
require_contains "| Phase 11 | Partial GO for runner/stats contracts; datasets still incomplete | NO-GO | NO-GO scientific closure |"
require_contains "cache/provenance/Tier2/source-ledger/empirical-run evidence"

reject_regex 'phase[ -]*(12|13)' "later-phase scope"
reject_regex 'sota|state-of-the-art|leaderboard|winner|novelty|breakthrough' "unsupported public-comparison wording"

echo "PASS: Phase 9/10/11 merge matrix report guard passed."
